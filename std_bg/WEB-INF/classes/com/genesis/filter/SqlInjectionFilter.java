package com.genesis.filter;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 強化版安全過濾器
 * 1. SQL Injection
 * 2. XSS
 * 3. Path Traversal
 * 4. Spring4Shell 參數名稱攻擊檢查
 *
 * 設計原則：
 * - 掃描器防護優先
 * - 只在攔截時 log
 * - 先 decode / normalize 再檢查
 * - 同時檢查 normal / compact 版本，降低 、空白、換行繞過
 */
public class SqlInjectionFilter implements Filter {

    private static class Rule {
        String name;
        Pattern pattern;
        boolean compact;

        Rule(String name, String regex) {
            this(name, regex, false);
        }

        Rule(String name, String regex, boolean compact) {
            this.name = name;
            this.pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
            this.compact = compact;
        }
    }

    private List<Rule> sqlRules;
    private List<Rule> xssRules;

    private int maxQueryLength = 20000;
    private int maxParamNameLength = 512;
    private int maxParamValueLength = 20000;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

        String maxQuery = filterConfig.getInitParameter("maxQueryLength");
        String maxName = filterConfig.getInitParameter("maxParamNameLength");
        String maxValue = filterConfig.getInitParameter("maxParamValueLength");

        if (maxQuery != null && maxQuery.trim().length() > 0) {
            try { maxQueryLength = Integer.parseInt(maxQuery.trim()); } catch (Exception ignored) {}
        }
        if (maxName != null && maxName.trim().length() > 0) {
            try { maxParamNameLength = Integer.parseInt(maxName.trim()); } catch (Exception ignored) {}
        }
        if (maxValue != null && maxValue.trim().length() > 0) {
            try { maxParamValueLength = Integer.parseInt(maxValue.trim()); } catch (Exception ignored) {}
        }

        sqlRules = new ArrayList<Rule>();

        // 1. UNION / SELECT / DML / DDL
        sqlRules.add(new Rule("SQL_UNION_SELECT",
                "\\bunion\\b\\s+(?:all\\s+|distinct\\s+)?\\bselect\\b"));
        sqlRules.add(new Rule("SQL_SELECT_FROM",
                "\\bselect\\b\\s+.{1,800}\\bfrom\\b"));
        sqlRules.add(new Rule("SQL_INSERT_UPDATE_DELETE",
                "\\b(?:insert\\s+into|update\\b.{1,400}\\bset\\b|delete\\s+from)\\b"));
        sqlRules.add(new Rule("SQL_DDL",
                "\\b(?:drop\\s+table|truncate\\b|alter\\s+table|create\\s+table)\\b"));

        // 2. Boolean based injection
        sqlRules.add(new Rule("SQL_BOOLEAN_COMPARE",
                "\\b(?:or|and)\\b\\s+['\"]?[a-z0-9_]+['\"]?\\s*(?:=|<>|!=|<=>|like|regexp|rlike)\\s*['\"]?[a-z0-9_%]+['\"]?"));
        sqlRules.add(new Rule("SQL_BOOLEAN_NUMERIC",
                "\\b(?:or|and)\\b\\s+\\d+\\s*(?:=|<>|!=|<=>|>|<|>=|<=)\\s*\\d+"));
        sqlRules.add(new Rule("SQL_BOOLEAN_TRUE_FALSE",
                "\\b(?:or|and)\\b\\s+(?:true|false|null\\s+is\\s+null|\\d+\\s+is\\s+not\\s+null)\\b"));
        sqlRules.add(new Rule("SQL_QUOTE_BOOLEAN",
                "['\"]\\s*(?:or|and)\\s*['\"]?\\d+['\"]?\\s*=\\s*['\"]?\\d+"));

        // 3. CASE WHEN 結構，專門擋 case randomblob(...) when not null then ...
        sqlRules.add(new Rule("SQL_CASE_WHEN",
                "\\bcase\\b.{0,600}\\bwhen\\b.{0,600}\\bthen\\b.{0,600}(?:\\belse\\b.{0,600})?\\bend\\b"));
        sqlRules.add(new Rule("SQL_CASE_RANDOMBLOB",
                "\\bcase\\b.{0,300}\\brandomblob\\s*\\(.{0,300}\\bwhen\\b.{0,300}\\bend\\b"));

        // 4. Time based / heavy function / DB fingerprint
        sqlRules.add(new Rule("SQL_DANGEROUS_FUNCTION",
                "\\b(?:sleep|benchmark|pg_sleep|randomblob|dbms_pipe\\.receive_message|waitfor|delay)\\s*\\("));
        sqlRules.add(new Rule("SQL_WAITFOR_DELAY",
                "\\bwaitfor\\b\\s+\\bdelay\\b"));
        sqlRules.add(new Rule("SQL_DB_INFO_FUNCTION",
                "\\b(?:version|database|schema|user|current_user|session_user|system_user|sqlite_version)\\s*\\("));
        sqlRules.add(new Rule("SQL_DB_VARIABLE",
                "@@(?:version|hostname|datadir|basedir|global|session|sql_mode)"));

        // 5. Error based
        sqlRules.add(new Rule("SQL_ERROR_BASED",
                "\\b(?:extractvalue|updatexml|exp|floor|rand|group_concat|json_extract|xmltype)\\s*\\("));

        // 6. File / command / MSSQL dangerous
        sqlRules.add(new Rule("SQL_FILE_COMMAND",
                "\\b(?:load_file|into\\s+outfile|into\\s+dumpfile|xp_cmdshell|sp_oacreate|sp_oamethod|openrowset|openquery)\\b"));

        // 7. 常見字串組合與盲注函數
        sqlRules.add(new Rule("SQL_STRING_FUNCTION",
                "\\b(?:concat|concat_ws|char|chr|ascii|ord|hex|unhex|substr|substring|mid|left|right|if|ifnull|nullif|coalesce|cast|convert)\\s*\\("));

        // 8. EXISTS / subquery / information_schema
        sqlRules.add(new Rule("SQL_EXISTS_SUBQUERY",
                "\\bexists\\s*\\("));
        sqlRules.add(new Rule("SQL_INFORMATION_SCHEMA",
                "\\b(?:information_schema|mysql\\.user|sys\\.|pg_catalog|sqlite_master)\\b"));

        // 9. 註解型注入
        sqlRules.add(new Rule("SQL_COMMENT",
                "(?:/\\*|\\*/|--\\s|#)"));

        // 10. compact 檢查：處理 r a n d o m b l o b、un/**/ion、s%65lect 類繞過
        sqlRules.add(new Rule("SQL_COMPACT_RANDOMBLOB",
                "randomblob\\(", true));
        sqlRules.add(new Rule("SQL_COMPACT_UNION_SELECT",
                "union(?:all|distinct)?select", true));
        sqlRules.add(new Rule("SQL_COMPACT_CASE_WHEN",
                "case.{0,300}when.{0,300}then.{0,300}(?:else.{0,300})?end", true));
        sqlRules.add(new Rule("SQL_COMPACT_DANGEROUS_FUNC",
                "(?:sleep|benchmark|pg_sleep|extractvalue|updatexml|load_file|xp_cmdshell|dbms_pipe\\.receive_message)\\(", true));

        xssRules = new ArrayList<Rule>();
	     // Script Tag
	    xssRules.add(new Rule("XSS_SCRIPT_TAG",
	             "<\\s*/?\\s*script\\b"));
	     // HTML Tag
	    xssRules.add(new Rule("XSS_HTML_A_TAG",
	             "<\\s*/?\\s*a\\b"));
	     // javascript: vbscript: data:
	    xssRules.add(new Rule("XSS_JS_PROTOCOL",
	             "\\b(?:javascript|vbscript|data)\\s*:"));
	     // onclick= onerror= onload=
	    xssRules.add(new Rule("XSS_EVENT_HANDLER",
	             "\\bon[a-z]{3,30}\\s*="));
	     // 屬性跳脫
	     // 例如： " src=
	//             " href=
	//             " style=
	//             " onclick=
	    xssRules.add(new Rule("XSS_ATTR_BREAKOUT",
	             "\"\\s*(?:src|href|style|action|formaction|background|poster|data|xlink:href|on[a-z]+)\\s*="));
	    // style=
	    xssRules.add(new Rule("XSS_STYLE_ATTR",
	             "\\bstyle\\s*="));
	    // expression(...)
	    xssRules.add(new Rule("XSS_CSS_EXPRESSION",
	             "\\bexpression\\s*\\("));
	    // 危險標籤
	    xssRules.add(new Rule("XSS_DANGEROUS_TAG",
	             "<\\s*(?:iframe|object|embed|svg|img|math|link|meta|base)\\b"));
	    // alert() eval() prompt()
	    xssRules.add(new Rule("XSS_JS_FUNCTION",
	             "\\b(?:alert|confirm|prompt|eval|settimeout|setinterval)\\s*\\("));
	    // document.cookie document.write
	    xssRules.add(new Rule("XSS_DOCUMENT_ACCESS",
	             "\\bdocument\\s*\\.\\s*(?:cookie|location|write|domain)\\b"));
    }

    private static String multiDecode(String s) {
        if (s == null) return null;

        String v = s;

        for (int i = 0; i < 3; i++) {
            try {
                String dec = URLDecoder.decode(v, StandardCharsets.UTF_8.name());
                if (dec.equals(v)) break;
                v = dec;
            } catch (Exception e) {
                break;
            }
        }

        v = decodeUnicodeEscapes(v);
        v = htmlEntityDecodeBasic(v);

        return v;
    }

    private static String decodeUnicodeEscapes(String s) {
        if (s == null) return null;

        Pattern p = Pattern.compile("(?:\\\\u|%u)([0-9a-fA-F]{4})");
        Matcher m = p.matcher(s);
        StringBuffer sb = new StringBuffer();

        while (m.find()) {
            try {
                char c = (char) Integer.parseInt(m.group(1), 16);
                m.appendReplacement(sb, Matcher.quoteReplacement(String.valueOf(c)));
            } catch (Exception e) {
                m.appendReplacement(sb, Matcher.quoteReplacement(m.group(0)));
            }
        }

        m.appendTail(sb);
        return sb.toString();
    }

    private static String htmlEntityDecodeBasic(String s) {
        if (s == null) return null;

        return s.replace("&lt;", "<")
                .replace("&LT;", "<")
                .replace("&gt;", ">")
                .replace("&GT;", ">")
                .replace("&quot;", "\"")
                .replace("&QUOT;", "\"")
                .replace("&#34;", "\"")
                .replace("&#x22;", "\"")
                .replace("&#39;", "'")
                .replace("&#x27;", "'")
                .replace("&apos;", "'")
                .replace("&amp;", "&")
                .replace("&AMP;", "&");
    }

    private static String normalizeNormal(String input) {
        if (input == null) return null;

        String v = multiDecode(input);
        if (v == null) return null;

        v = v.replace('\u0000', ' ');
        v = v.replace('\r', ' ');
        v = v.replace('\n', ' ');
        v = v.replace('\t', ' ');

        // SQL 註解轉空白，不直接刪掉，避免 token 黏在一起造成漏判
        v = v.replaceAll("/\\*.*?\\*/", " ");
        v = v.replaceAll("--+", " -- ");
        v = v.replaceAll("#", " # ");

        v = v.replaceAll("\\s+", " ");
        return v.trim().toLowerCase();
    }

    private static String normalizeCompact(String input) {
        if (input == null) return null;

        String v = multiDecode(input);
        if (v == null) return null;

        v = v.toLowerCase();

        // 移除 SQL 註解與所有空白，專門抓關鍵字被拆開的繞過
        v = v.replaceAll("/\\*.*?\\*/", "");
        v = v.replaceAll("\\s+", "");
        v = v.replaceAll("[`\"']", "");

        return v;
    }

    private String matchSqlRule(String input) {
        if (input == null) return null;

        String normal = normalizeNormal(input);
        String compact = normalizeCompact(input);

        if ((normal == null || normal.length() == 0)
                && (compact == null || compact.length() == 0)) {
            return null;
        }

        for (Rule rule : sqlRules) {
            String target = rule.compact ? compact : normal;
            if (target == null || target.length() == 0) continue;

            if (rule.pattern.matcher(target).find()) {
                return rule.name;
            }
        }

        return null;
    }

    private String matchXssRule(String input) {
        if (input == null) return null;

        String value = multiDecode(input);
        if (value == null) return null;

        value = value.trim();
        if (value.length() == 0) return null;

        for (Rule rule : xssRules) {
            if (rule.pattern.matcher(value).find()) {
                return rule.name;
            }
        }

        return null;
    }

    private static boolean isPathTraversalLike(String input) {
        if (input == null) return false;

        String v = multiDecode(input);
        if (v == null) return false;

        String lower = v.toLowerCase();

        if (lower.contains("../")
                || lower.contains("..\\")
                || lower.contains("/..")
                || lower.contains("\\..")) {
            return true;
        }

        if (lower.matches(".*[a-z]:\\\\.*")) {
            return true;
        }

        if (lower.startsWith("\\\\")) {
            return true;
        }

        if (lower.contains("/etc/passwd")
                || lower.contains("/etc/shadow")
                || lower.contains("web-inf")
                || lower.contains("meta-inf")) {
            return true;
        }

        return false;
    }

    private static boolean isDangerousParamName(String name) {
        if (name == null) return false;

        String lower = multiDecode(name);
        if (lower == null) return false;

        lower = lower.toLowerCase();

        return lower.startsWith("class.")
                || lower.contains("classloader")
                || lower.contains("module.classloader")
                || lower.contains("class.module")
                || lower.contains("class.classloader")
                || lower.contains("protectiondomain")
                || lower.contains("cachedintrospectionresults");
    }

    private void block(HttpServletRequest request,
                       HttpServletResponse response,
                       String reason,
                       String paramName,
                       String paramValue) throws IOException {

        String uri = request.getRequestURI();
        String method = request.getMethod();
        String queryString = request.getQueryString();
        String ip = request.getRemoteAddr();

        System.out.println("==================================================");
        System.out.println("[SqlInjectionFilter] 已攔截可疑請求");
        System.out.println("原因        : " + reason);
        System.out.println("Method      : " + method);
        System.out.println("URI         : " + uri);
        System.out.println("IP          : " + ip);
        System.out.println("QueryString : " + safeLog(multiDecode(queryString)));
        System.out.println("Param Name  : " + safeLog(paramName));
        System.out.println("Param Value : " + safeLog(paramValue));
        System.out.println("==================================================");

        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bad Request");
    }

    private static String safeLog(String s) {
        if (s == null) return "";

        String v = s.replace('\r', ' ')
                .replace('\n', ' ')
                .replace('\t', ' ');

        if (v.length() > 1000) {
            return v.substring(0, 1000) + "...(truncated)";
        }

        return v;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");

        String queryString = httpRequest.getQueryString();
        String decodedQuery = multiDecode(queryString);

        if (decodedQuery != null && decodedQuery.length() > maxQueryLength) {
            block(httpRequest, httpResponse, "queryString 過長", "queryString", decodedQuery);
            return;
        }

        if (isPathTraversalLike(decodedQuery)) {
            block(httpRequest, httpResponse, "queryString 含路徑穿越字樣", "queryString", decodedQuery);
            return;
        }

        String querySqlRule = matchSqlRule(decodedQuery);
        if (querySqlRule != null) {
            block(httpRequest, httpResponse, "queryString 疑似 SQL Injection: " + querySqlRule, "queryString", decodedQuery);
            return;
        }

        String queryXssRule = matchXssRule(decodedQuery);
        if (queryXssRule != null) {
            block(httpRequest, httpResponse, "queryString 疑似 XSS: " + queryXssRule, "queryString", decodedQuery);
            return;
        }

        Map<String, String[]> params = httpRequest.getParameterMap();

        if (params != null) {
            for (Map.Entry<String, String[]> entry : params.entrySet()) {

                String paramKey = entry.getKey();
                String decodedKey = multiDecode(paramKey);

                if (decodedKey != null && decodedKey.length() > maxParamNameLength) {
                    block(httpRequest, httpResponse, "參數名稱過長", decodedKey, null);
                    return;
                }

                if (isDangerousParamName(decodedKey)) {
                    block(httpRequest, httpResponse, "危險參數名稱(Spring4Shell特徵)", decodedKey, null);
                    return;
                }

                if (isPathTraversalLike(decodedKey)) {
                    block(httpRequest, httpResponse, "參數名稱含路徑穿越字樣", decodedKey, null);
                    return;
                }

                String keySqlRule = matchSqlRule(decodedKey);
                if (keySqlRule != null) {
                    block(httpRequest, httpResponse, "參數名稱疑似 SQL Injection: " + keySqlRule, decodedKey, null);
                    return;
                }

                String keyXssRule = matchXssRule(decodedKey);
                if (keyXssRule != null) {
                    block(httpRequest, httpResponse, "參數名稱疑似 XSS: " + keyXssRule, decodedKey, null);
                    return;
                }

                String[] values = entry.getValue();
                if (values == null) continue;

                for (String value : values) {
                    if (value == null) continue;

                    String decodedValue = multiDecode(value);

                    if (decodedValue != null && decodedValue.length() > maxParamValueLength) {
                        block(httpRequest, httpResponse, "參數值過長", decodedKey, decodedValue);
                        return;
                    }

                    if (isPathTraversalLike(decodedValue)) {
                        block(httpRequest, httpResponse, "參數值含路徑穿越字樣", decodedKey, decodedValue);
                        return;
                    }

                    String valueSqlRule = matchSqlRule(decodedValue);
                    if (valueSqlRule != null) {
                        block(httpRequest, httpResponse, "參數值疑似 SQL Injection: " + valueSqlRule, decodedKey, decodedValue);
                        return;
                    }

                    String valueXssRule = matchXssRule(decodedValue);
                    if (valueXssRule != null) {
                        block(httpRequest, httpResponse, "參數值疑似 XSS: " + valueXssRule, decodedKey, decodedValue);
                        return;
                    }
                }
            }
        }

        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (isDangerousParamName(name)) {
                block(httpRequest, httpResponse, "危險參數名稱(Spring4Shell特徵)", name, null);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }
}