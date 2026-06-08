package com.genesis.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.nio.charset.Charset;
import java.security.SecureRandom;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Base64;

/**
 * ContentSecurityPolicyFilter (merged)
 *
 * ✅ 合併自：
 * - cspFilter：SRI(script+link)、補 a[target=_blank] rel、security headers、Set-Cookie(JSESSIONID) SameSite/Secure patch
 * - CspNonceFilter：nonce + CSP header、只改寫 text/html（script nonce、移除 inline handler、javascript: href 改寫）、stylesheet SRI allowlist
 *
 * 注意：
 * - 這是字串改寫，不是完整 HTML parser（跟你原本 CspNonceFilter 一樣的取捨）
 * - 不對靜態資源做 body 改寫，避免破壞 chunk/map/js
 */
public class cspFilter implements Filter {

    // ===== Session cookie patch（沿用你原本 cspFilter 的行為）=====
    public static final String SESSION_SAMESITE = "Lax";
    public static final boolean FORCE_SECURE_ON_SESSION = true;

    // ===== 只印 block 類 log =====
    private static final boolean DEBUG_BLOCK_ONLY = false;
    private static final ThreadLocal<HttpServletRequest> requestRef = new ThreadLocal<HttpServletRequest>();

    // ===== Nonce =====
    private static final SecureRandom RNG = new SecureRandom();

    private static String genNonce() {
        byte[] b = new byte[16];
        RNG.nextBytes(b);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(b);
    }

    // ===== SRI allowlist（合併兩支的 Map）=====
    private static final Map<String, String> SRI_MAP = new HashMap<String, String>();
    static {
        // scripts
//        SRI_MAP.put(
//            "https://code.jquery.com/jquery-3.7.1.min.js",
//            "sha384-1H217gwSVyLSIfaLxHbE7dRb3v4mYCKbpQvzx0cegeju1MVsGrX5xXxAvs/HgeFs"
//        );
//        SRI_MAP.put(
//            "https://code.jquery.com/jquery-migrate-3.4.0.min.js",
//            "sha384-MWooe10lo6cvKQSudVN1BEepxRAEoDDyZmEGwi6v1bh86cKSdudatSa5O7OEMa5V"
//        );
//
//        // styles
//        SRI_MAP.put(
//            "https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css",
//            "sha512-c42qTSw/wPZ3/5LBzD+Bw5f7bSF2oxou6wEb+I/lqeaKV5FDIfMvvRp772y4jcJLKuGUOpbJMdg/BTl50fJYAw=="
//        );
//        SRI_MAP.put(
//            "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css",
//            "sha512-dPXYcDub/aeb08c63jRq/k6GaKccl256JQy/AnOq7CAnEZ9FzSL9wSbcZkMp4R26vBsMLFYH4kQ67/bbV8XaCQ=="
//        );
//        SRI_MAP.put(
//            "https://unpkg.com/aos@2.3.4/dist/aos.css",
//            "sha512-1cK78a1o+ht2JcaW6g8OXYwqpev9+6GqOkz9xmBN9iUUhIndKtxwILGWYOSibOKjLsEdjyjZvYDq/cZwNeak0w=="
//        );

        // 你其他 CDN 的 integrity 也一樣加在這裡（URL 必須完全一致）
    }

    private void logBlock(HttpServletRequest request, String message) {
        if (!DEBUG_BLOCK_ONLY) return;

        String uri = "";
        try {
            uri = request.getRequestURI();
        } catch (Exception ignore) {
        }

        if (message != null && message.length() > 300) {
            message = message.substring(0, 300) + "...";
        }

        System.out.println("[CSP-BLOCK] uri=" + uri + " , " + message);
    }

    private HttpServletRequest currentRequest() {
        return requestRef.get();
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        //=========後台白名單===============
        String uri = request.getRequestURI();

        if (uri != null && uri.startsWith(request.getContextPath() + "/mis/")  || uri.contains("/web/payment/")) {
            chain.doFilter(req, res);
            return;
        }
        
//      // HTTP 強制轉 HTTPS
	    String host = request.getServerName();
//	    System.out.println("host=="+host);
//
      boolean isLocal =
          "localhost".equalsIgnoreCase(host)
          || "127.0.0.1".equals(host);
//      System.out.println("isLocal="+isLocal);
      if (!isLocal) {
      	
      
	        // HTTP 強制轉 HTTPS
		    String forwardedProto = request.getHeader("X-Forwarded-Proto");
	
		    if ("http".equalsIgnoreCase(request.getScheme())
		            || "http".equalsIgnoreCase(forwardedProto)) {
	
		        String query = request.getQueryString();
	
		        String httpsUrl = "https://" + request.getServerName() + request.getRequestURI()
		                + (query != null ? "?" + query : "");
	
		        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
		        response.setHeader("Location", httpsUrl);
		        response.setHeader("Connection", "close");
		        return;
		    }
      }

        requestRef.set(request);
        try {
            // ====== 每 request 產生 nonce（JSP 可用 request.getAttribute("cspNonce")）=====
            String nonce = genNonce();
            request.setAttribute("cspNonce", nonce);

            // ====== 基本安全 headers ======
            setSecurityHeaders(response);

            // ====== CSP header ======
            boolean isGoogleSearchPage =
                    uri != null && (uri.contains("/search/") || uri.contains("search.jsp"));

            String defaultSrc =
                    "default-src 'self' " +
                            "https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://unpkg.com " +
                            "https://fonts.googleapis.com https://fonts.gstatic.com " +
                            "https://www.google-analytics.com https://www.googletagmanager.com " +
                            "https://maps.googleapis.com https://cse.google.com https://www.google.com; ";

            String baseDirectives =
                    "base-uri 'self'; " +
                            "object-src 'none'; " +
                            "form-action 'self'; " +
                            "upgrade-insecure-requests; " +
                            "block-all-mixed-content; ";

            String scriptSrc =
                    "script-src 'self' 'nonce-" + nonce + "'; " +
                            "script-src-elem 'self' 'nonce-" + nonce + "' " +
                            "https://cdnjs.cloudflare.com https://code.jquery.com https://cdn.jsdelivr.net https://unpkg.com " +
                            "https://www.googletagmanager.com https://www.google-analytics.com " +
                            "https://cse.google.com https://www.google.com; " +
                            "script-src-attr 'none'; ";

            // 全站需要 Google CSE → 必須允許 inline style
            String styleSrc =
                    "style-src 'self' 'unsafe-inline' " +
                            "https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://unpkg.com https://fonts.googleapis.com " +
                            "https://www.google.com; ";

            String imgSrc =
                    "img-src 'self' data: "
                    + "blob: "
                    + "https://www.google.com "
                    + "https://maps.googleapis.com "
                    + "https://maps.gstatic.com "
                    + "https://www.google-analytics.com; ";

            String fontSrc =
                    "font-src 'self' data: https://fonts.gstatic.com; https://cdn.jsdelivr.net/";

            String connectSrc =
                    "connect-src 'self' " +
                            "https://www.google-analytics.com https://www.googletagmanager.com " +
                            "https://maps.googleapis.com https://unpkg.com " +
                            "https://ep1.adtrafficquality.google; ";

            String frameSrc =
                    "frame-src 'self' " +
                            "https://www.youtube.com https://www.google.com " +
                            "https://maps.google.com https://maps.googleapis.com " +
                            "https://ep1.adtrafficquality.google https://ep2.adtrafficquality.google; ";

            String frameAncestors =
                    "frame-ancestors 'self'; ";

            String csp =
                    defaultSrc +
                            baseDirectives +
                            scriptSrc +
                            styleSrc +
                            imgSrc +
                            fontSrc +
                            connectSrc +
                            frameSrc +
                            frameAncestors;

            response.setHeader("Content-Security-Policy", csp);

            // ====== 靜態資源：不包、不改內容 ======
            final String reqUri = (uri == null) ? "" : uri;
            if (isStatic(reqUri)) {
                chain.doFilter(req, res);
                return;
            }

            // ====== 攔截 response：要同時做到（1）body 改寫（2）Set-Cookie patch ======
            BufferedResponseWrapper wrapper = new BufferedResponseWrapper(response);
            setSecurityHeaders(wrapper);

            // 所有 cookie 設定 20240125 May
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    String name = cookie.getName();
                    String value = cookie.getValue();
                    if ("JSESSIONID".equals(name)) {
                        response.setHeader("Set-Cookie", name + "=" + value + "; Path=/; SameSite=Lax; HttpOnly; Secure");
                    } else {
                        response.setHeader("Set-Cookie", name + "=" + value + "; Path=/; SameSite=Lax; HttpOnly; Secure");
                    }
                }
            } else {
                String JSESSIONID = request.getSession().getId();
                response.setHeader("Set-Cookie", "JSESSIONID=" + JSESSIONID + "; Path=/; SameSite=Lax; Secure; HttpOnly");
            }

            chain.doFilter(request, wrapper);

            byte[] raw = wrapper.getBody();
            String contentType = wrapper.getContentType();

            // 非 HTML：原封不動回傳
            if (contentType == null || !contentType.toLowerCase().contains("text/html")) {
                writeBytes(response, raw, contentType, wrapper.getStatus());
                return;
            }

            // 取 encoding
            String enc = wrapper.getCharacterEncoding();
            if (enc == null || enc.trim().isEmpty()) enc = "UTF-8";
            Charset cs = Charset.forName(enc);

            String html = new String(raw, cs);

            // ====== 合併：cspFilter 的功能 ======
            // 1) 補 rel=noopener
            html = html.replaceAll(
                    "(?i)<a([^>]*?)target=[\"']_blank[\"'](?![^>]*rel=)",
                    "<a$1target=\"_blank\" rel=\"noopener noreferrer\""
            );

            // 2) 注入 SRI（script + link）
            html = injectSRI(html);

            // ====== 合併：CspNonceFilter 的功能 ======
            // 3) script nonce：補沒有 nonce 的 script
            html = html.replaceAll(
                    "(?is)<script(?![^>]*\\snonce=)([^>]*)>",
                    "<script nonce=\"" + nonce + "\"$1>"
            );

            // 覆蓋寫死的 nonce
            html = html.replaceAll(
                    "(?is)(<script\\b[^>]*?)\\snonce\\s*=\\s*(['\"]).*?\\2",
                    "$1 nonce=\"" + nonce + "\""
            );

            // 修正 nonce="" 或 nonce=''
            html = html.replaceAll("(?i)\\snonce\\s*=\\s*(['\"])\\s*\\1", " nonce=\"" + nonce + "\"");

            // 再保險覆蓋一次所有 script nonce
            html = html.replaceAll("(?i)(<script\\b[^>]*?)\\snonce\\s*=\\s*(['\"]).*?\\2", "$1 nonce=\"" + nonce + "\"");

            // style nonce
            html = html.replaceAll("(?is)<style(?![^>]*\\snonce=)([^>]*)>", "<style nonce=\"" + nonce + "\"$1>");
            html = html.replaceAll("(?i)(<style\\b[^>]*?)\\snonce\\s*=\\s*(['\"]).*?\\2", "$1 nonce=\"" + nonce + "\"");

            // stylesheet SRI allowlist
            html = addSriToStylesheetLinks(html);

            // 4) inline handlers & javascript: href 轉成 listener + 注入一段 nonce script
            List<String> eventScripts = new ArrayList<String>();
            int idx = 0;

            Result r;
            r = transformInlineHandler(html, "onclick", "click", eventScripts, idx);   html = r.html; idx = r.idx;
            r = transformInlineHandler(html, "onsubmit", "submit", eventScripts, idx); html = r.html; idx = r.idx;
            r = transformInlineHandler(html, "onchange", "change", eventScripts, idx); html = r.html; idx = r.idx;

            r = transformJavascriptHref(html, eventScripts, idx); html = r.html; idx = r.idx;

            if (!eventScripts.isEmpty()) {
                StringBuilder js = new StringBuilder();
                js.append("<script nonce=\"").append(nonce).append("\">");
                js.append("(function(){");
                for (String s : eventScripts) js.append(s);
                js.append("})();");
                js.append("</script>");

                if (html.toLowerCase().contains("</body>")) {
                    html = html.replaceFirst("(?i)</body>", Matcher.quoteReplacement(js.toString()) + "</body>");
                } else if (html.toLowerCase().contains("</html>")) {
                    html = html.replaceFirst("(?i)</html>", Matcher.quoteReplacement(js.toString()) + "</html>");
                } else {
                    html = html + js;
                }
            }

            writeBytes(response, html.getBytes(cs), contentType, wrapper.getStatus());

        } finally {
            requestRef.remove();
        }
    }

    // ====== SRI 注入（script + link）=====
    private String injectSRI(String html) {
        if (SRI_MAP.isEmpty()) return html;

        String out = html;
        for (Map.Entry<String, String> e : SRI_MAP.entrySet()) {
            String url = e.getKey();
            String integrity = e.getValue();

            // <script src="URL" ...> but no integrity
            out = out.replaceAll(
                    "(?is)<script([^>]*?)\\s+src=[\"']" + Pattern.quote(url) + "[\"'](?![^>]*\\sintegrity=)([^>]*)>",
                    "<script$1 src=\"" + url + "\" integrity=\"" + integrity + "\" crossorigin=\"anonymous\"$2>"
            );

            // <link ... href="URL" ...> but no integrity
            out = out.replaceAll(
                    "(?is)<link([^>]*?)\\s+href=[\"']" + Pattern.quote(url) + "[\"'](?![^>]*\\sintegrity=)([^>]*)>",
                    "<link$1 href=\"" + url + "\" integrity=\"" + integrity + "\" crossorigin=\"anonymous\"$2>"
            );
        }
        return out;
    }

    // ====== 只對 rel=stylesheet 的 link 做 SRI ======
    private String addSriToStylesheetLinks(String html) {
        Pattern p = Pattern.compile("(?is)<link\\b([^>]*?)>", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(html);
        StringBuffer sb = new StringBuffer();

        while (m.find()) {
            String attrs = m.group(1) == null ? "" : m.group(1);

            if (!Pattern.compile("(?i)\\brel\\s*=\\s*(['\"])\\s*stylesheet\\s*\\1").matcher(attrs).find()) {
                m.appendReplacement(sb, m.group(0));
                continue;
            }

            if (Pattern.compile("(?i)\\bintegrity\\s*=").matcher(attrs).find()) {
                m.appendReplacement(sb, m.group(0));
                continue;
            }

            Matcher hm = Pattern.compile("(?i)\\bhref\\s*=\\s*(['\"])(.*?)\\1").matcher(attrs);
            if (!hm.find()) {
                m.appendReplacement(sb, m.group(0));
                continue;
            }

            String href = (hm.group(2) == null ? "" : hm.group(2).trim());

            if (!(href.startsWith("https://") || href.startsWith("http://"))) {
                m.appendReplacement(sb, m.group(0));
                continue;
            }

            // Google Fonts 內容可能變動，SRI 很容易不穩
            if (href.startsWith("https://fonts.googleapis.com/")) {
                m.appendReplacement(sb, m.group(0));
                continue;
            }

            String integrity = SRI_MAP.get(href);
            if (integrity == null || integrity.trim().isEmpty()) {
                m.appendReplacement(sb, m.group(0));
                continue;
            }

            String newAttrs = attrs
                    + " integrity=\"" + integrity + "\""
                    + " crossorigin=\"anonymous\""
                    + " referrerpolicy=\"no-referrer\"";

            String newTag = "<link" + newAttrs + ">";
            m.appendReplacement(sb, Matcher.quoteReplacement(newTag));
        }

        m.appendTail(sb);
        return sb.toString();
    }

    // ====== 靜態判斷 ======
    private boolean isStatic(String uri) {
        String u = uri.toLowerCase();
        return u.endsWith(".js") || u.endsWith(".css")
                || u.endsWith(".png") || u.endsWith(".jpg") || u.endsWith(".jpeg") || u.endsWith(".gif")
                || u.endsWith(".ico") || u.endsWith(".pdf") || u.endsWith(".svg")
                || u.endsWith(".woff") || u.endsWith(".woff2") || u.endsWith(".ttf") || u.endsWith(".eot")
                || u.endsWith(".map")
                || u.contains("/images/")
                || u.contains("/upload/")
                || u.contains("/uploads/");
    }

    // ====== security headers ======
    private void setSecurityHeaders(HttpServletResponse res) {
        res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload");
        res.setHeader("Permissions-Policy", "geolocation=(), microphone=()");
        res.setHeader("X-Content-Type-Options", "nosniff");
        res.setHeader("X-Frame-Options", "SAMEORIGIN");
        res.setHeader("X-XSS-Protection", "1; mode=block");
    }

    // ====== inline handler / javascript: href 改寫 ======
    private static class Result {
        final String html;
        final int idx;
        Result(String html, int idx) { this.html = html; this.idx = idx; }
    }

    private static class SubmitCall {
        final String funcName;
        final String args;
        SubmitCall(String funcName, String args) { this.funcName = funcName; this.args = args; }
    }

    private SubmitCall parseSubmitCall(String code) {
        String c = code.trim();
        if (c.endsWith(";")) c = c.substring(0, c.length() - 1).trim();
        if (c.toLowerCase().startsWith("return ")) c = c.substring(7).trim();

        Matcher mm = Pattern.compile("^([a-zA-Z_$][\\w$]*)\\s*\\((.*)\\)$").matcher(c);
        if (mm.find()) return new SubmitCall(mm.group(1), mm.group(2).trim());
        return null;
    }

    private String buildSubmitInvokeJs(SubmitCall call) {
        String fn = call.funcName;
        String args = call.args;
        return ""
                + "if(typeof " + fn + "==='function'){"
                +   "var r=" + fn + "(" + args + ");"
                +   "if(r===false){ok=false;}"
                + "}else{ok=false;}";
    }

    private Result transformInlineHandler(
            String html,
            String attrName,
            String eventName,
            List<String> eventScripts,
            int startIdx
    ) {
        Pattern p = Pattern.compile(
                "(?is)<([a-z0-9]+)([^>]*?)\\s" + attrName + "\\s*=\\s*(['\"])(.*?)\\3([^>]*)>",
                Pattern.CASE_INSENSITIVE
        );
        Matcher m = p.matcher(html);

        StringBuffer sb = new StringBuffer();
        int idx = startIdx;

        while (m.find()) {
            String tag = m.group(1);
            String beforeAttrs = m.group(2) == null ? "" : m.group(2);
            String code = (m.group(4) == null ? "" : m.group(4)).trim();
            String afterAttrs = m.group(5) == null ? "" : m.group(5);

            String attrsAll = (beforeAttrs + " " + afterAttrs);

            boolean wasSelfClosing = Pattern.compile("\\s*/\\s*$").matcher(attrsAll).find();
            boolean isVoid = isVoidTag(tag);

            Matcher idm = Pattern.compile("(?i)\\sid\\s*=\\s*(['\"])(.*?)\\1").matcher(attrsAll);
            String id;
            if (idm.find()) {
                id = idm.group(2);
            } else {
                id = "auto_evt_" + (idx++);
                attrsAll = attrsAll + " id=\"" + id + "\"";
            }

            // remove onXXX
            attrsAll = attrsAll.replaceAll("(?i)\\s" + attrName + "\\s*=\\s*(['\"]).*?\\1", "");

            // remove tail "/"
            attrsAll = attrsAll.replaceAll("\\s*/\\s*$", "");

            String newTag = (isVoid || wasSelfClosing)
                    ? ("<" + tag + attrsAll + " />")
                    : ("<" + tag + attrsAll + ">");

            if (!code.isEmpty()) {
                HttpServletRequest req = currentRequest();
                if (req != null) {
                    logBlock(req, "移除 inline handler: " + attrName + "=\"" + code + "\"");
                }

                String escapedId = escapeJs(id);

                if ("submit".equalsIgnoreCase(eventName)) {
                    SubmitCall call = parseSubmitCall(code);

                    String invokeJs;
                    if (call != null) {
                        invokeJs = buildSubmitInvokeJs(call);
                    } else {
                        invokeJs =
                                "var r=(function(){" + stripJavascriptPrefix(code) + ";}).call(this);" +
                                "if(r===false){ok=false;}";
                    }

                    String listener =
                            "var el=document.getElementById('" + escapedId + "');" +
                                    "if(el){el.addEventListener('submit', function(e){" +
                                    "var ok=true;" +
                                    "try{" +
                                    invokeJs +
                                    "}catch(ex){" +
                                    "ok=false;" +
                                    "if(window.console&&console.error){console.error('CSP submit handler error:', ex);}" +
                                    "}" +
                                    "if(ok===false){" +
                                    "e.preventDefault();" +
                                    "e.stopPropagation();" +
                                    "}" +
                                    "});}";

                    eventScripts.add(listener);
                } else {
                    String listener =
                            "var el=document.getElementById('" + escapedId + "');" +
                                    "if(el){el.addEventListener('" + eventName + "', function(e){" +
                                    "try{" + stripJavascriptPrefix(code) + ";}catch(ex){}" +
                                    "});}";
                    eventScripts.add(listener);
                }
            }

            m.appendReplacement(sb, Matcher.quoteReplacement(newTag));
        }

        m.appendTail(sb);
        return new Result(sb.toString(), idx);
    }

    private Result transformJavascriptHref(String html, List<String> eventScripts, int startIdx) {
        Pattern p = Pattern.compile(
                "(?is)<a([^>]*?)\\shref\\s*=\\s*(['\"])javascript:(.*?)\\2([^>]*)>",
                Pattern.CASE_INSENSITIVE
        );
        Matcher m = p.matcher(html);

        StringBuffer sb = new StringBuffer();
        int idx = startIdx;

        while (m.find()) {
            String before = m.group(1) == null ? "" : m.group(1);
            String code = (m.group(3) == null ? "" : m.group(3)).trim();
            String after = m.group(4) == null ? "" : m.group(4);

            String attrsAll = (before + " " + after);

            Matcher idm = Pattern.compile("(?i)\\sid\\s*=\\s*(['\"])(.*?)\\1").matcher(attrsAll);
            String id;
            if (idm.find()) {
                id = idm.group(2);
            } else {
                id = "auto_href_" + (idx++);
                attrsAll = attrsAll + " id=\"" + id + "\"";
            }

            attrsAll = attrsAll.replaceAll("(?i)\\shref\\s*=\\s*(['\"]).*?\\1", " href=\"#\"");

            String newTag = "<a" + attrsAll + ">";

            if (!code.isEmpty()) {
                HttpServletRequest req = currentRequest();
                if (req != null) {
                    logBlock(req, "阻擋 javascript: href => " + code);
                }

                String escapedId = escapeJs(id);
                String listener =
                        "var el=document.getElementById('" + escapedId + "');" +
                                "if(el){el.addEventListener('click', function(e){" +
                                "e.preventDefault();e.stopPropagation();" +
                                "try{" + stripJavascriptPrefix(code) + ";}catch(ex){}" +
                                "});}";
                eventScripts.add(listener);
            }

            m.appendReplacement(sb, Matcher.quoteReplacement(newTag));
        }

        m.appendTail(sb);
        return new Result(sb.toString(), idx);
    }

    private static boolean isVoidTag(String tag) {
        String t = tag.toLowerCase();
        return t.equals("input") || t.equals("img") || t.equals("br") || t.equals("hr")
                || t.equals("meta") || t.equals("link") || t.equals("source")
                || t.equals("area") || t.equals("base") || t.equals("col")
                || t.equals("embed") || t.equals("param") || t.equals("track") || t.equals("wbr");
    }

    private String stripJavascriptPrefix(String code) {
        String c = code.trim();
        if (c.regionMatches(true, 0, "javascript:", 0, "javascript:".length())) {
            c = c.substring("javascript:".length()).trim();
        }
        return c;
    }

    private String escapeJs(String s) {
        return s.replace("\\", "\\\\").replace("'", "\\'");
    }

    private void writeBytes(HttpServletResponse response, byte[] bytes, String contentType, int status) throws IOException {
        if (!response.isCommitted()) {
            if (status > 0) response.setStatus(status);
            if (contentType != null) response.setContentType(contentType);
        }
        // 不要 setContentLength（避免 chunked/gzip 出事）
        try (ServletOutputStream out = response.getOutputStream()) {
            out.write(bytes);
        }
    }

    /**
     * wrapper：同時支援 getWriter/getOutputStream + 保留 status/contentType
     * 並且：攔截 Set-Cookie(JSESSIONID) 補 SameSite/Secure
     */
    private static class BufferedResponseWrapper extends HttpServletResponseWrapper {
        private final ByteArrayOutputStream bos = new ByteArrayOutputStream();
        private ServletOutputStream sos;
        private PrintWriter writer;
        private int httpStatus = HttpServletResponse.SC_OK;
        private String contentType;

        BufferedResponseWrapper(HttpServletResponse response) {
            super(response);
        }

        @Override public void setStatus(int sc) { this.httpStatus = sc; super.setStatus(sc); }
        @Override public void sendError(int sc) throws IOException { this.httpStatus = sc; super.sendError(sc); }
        @Override public void sendError(int sc, String msg) throws IOException { this.httpStatus = sc; super.sendError(sc, msg); }
        @Override public void sendRedirect(String location) throws IOException { this.httpStatus = HttpServletResponse.SC_FOUND; super.sendRedirect(location); }

        @Override public void setContentType(String type) { this.contentType = type; super.setContentType(type); }
        @Override public String getContentType() { return this.contentType != null ? this.contentType : super.getContentType(); }
        public int getStatus() { return httpStatus; }

        @Override
        public void addCookie(Cookie cookie) {
            if (cookie == null) {
                super.addCookie(null);
                return;
            }

            String name = cookie.getName();
            if (!isTargetCookie(name)) {
                super.addCookie(cookie);
                return;
            }

            String built = buildSetCookie(cookie);
            super.addHeader("Set-Cookie", patchSetCookie(built));
        }

        @Override
        public void addHeader(String name, String value) {
            if ("Set-Cookie".equalsIgnoreCase(name)) value = patchSetCookie(value);
            super.addHeader(name, value);
        }

        @Override
        public void setHeader(String name, String value) {
            if ("Set-Cookie".equalsIgnoreCase(name)) value = patchSetCookie(value);
            super.setHeader(name, value);
        }

        private boolean isTargetCookie(String cookieName) {
            if (cookieName == null) return false;
            return "JSESSIONID".equalsIgnoreCase(cookieName) || "nctu_id".equalsIgnoreCase(cookieName);
        }

        private String getCookieNameFromSetCookie(String setCookie) {
            if (setCookie == null) return null;
            int eq = setCookie.indexOf('=');
            if (eq <= 0) return null;
            return setCookie.substring(0, eq).trim();
        }

        private String patchSetCookie(String v) {
            if (v == null) return null;

            String cookieName = getCookieNameFromSetCookie(v);
            if (!isTargetCookie(cookieName)) return v;

            String out = v;
            String lower = out.toLowerCase();

            if (FORCE_SECURE_ON_SESSION && !lower.contains("secure")) {
                out += "; Secure";
                lower = out.toLowerCase();
            }

            if (!lower.contains("httponly")) {
                out += "; HttpOnly";
                lower = out.toLowerCase();
            }

            if (!lower.contains("samesite=")) {
                out += "; SameSite=" + SESSION_SAMESITE;
                lower = out.toLowerCase();
            }

            if (lower.contains("samesite=none") && !lower.contains("secure")) {
                out += "; Secure";
            }

            return out;
        }

        private String buildSetCookie(Cookie c) {
            StringBuilder sb = new StringBuilder();
            sb.append(c.getName()).append("=").append(c.getValue() == null ? "" : c.getValue());

            if (c.getPath() != null && !c.getPath().isEmpty()) sb.append("; Path=").append(c.getPath());
            if (c.getDomain() != null && !c.getDomain().isEmpty()) sb.append("; Domain=").append(c.getDomain());

            if (c.getMaxAge() >= 0) sb.append("; Max-Age=").append(c.getMaxAge());

            if (c.getSecure()) sb.append("; Secure");
            try {
                if (c.isHttpOnly()) sb.append("; HttpOnly");
            } catch (Throwable ignore) {
            }

            return sb.toString();
        }

        @Override
        public ServletOutputStream getOutputStream() {
            if (writer != null) throw new IllegalStateException("getWriter() already called");
            if (sos == null) {
                sos = new ServletOutputStream() {
                    @Override public void write(int b) { bos.write(b); }
                    @Override public boolean isReady() { return true; }
                    @Override public void setWriteListener(WriteListener writeListener) {}
                };
            }
            return sos;
        }

        @Override
        public PrintWriter getWriter() throws IOException {
            if (sos != null) throw new IllegalStateException("getOutputStream() already called");
            if (writer == null) {
                String enc = getCharacterEncoding();
                if (enc == null) enc = "UTF-8";
                writer = new PrintWriter(new OutputStreamWriter(bos, enc), true);
            }
            return writer;
        }

        byte[] getBody() throws IOException {
            if (writer != null) writer.flush();
            if (sos != null) sos.flush();
            return bos.toByteArray();
        }
    }
}