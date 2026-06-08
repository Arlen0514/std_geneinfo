<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
   // Keyword.
   String keyword = StringTool.validString(request.getParameter("ss_keyword"));
   TableRecord ss = SiteSetup.getSetup(keyword);
   // Input data.
   ss.setValue("ss_text", StringTool.validString(request.getParameter("ss_text")));
   ss.setValue("ss_value", StringTool.validString(request.getParameter("ss_value")));
   // Additional data.
   ss.setUpdate(app_account);
   // Update data.
   app_sm.update(ss);
   if (app_sm.success()) {
       out.println("<script> alert('資料更新成功!!'); location.replace('"+request.getHeader("referer")+"'); </script>");
   } else {
		out.println("<script> alert('資料更新失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
   }
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>