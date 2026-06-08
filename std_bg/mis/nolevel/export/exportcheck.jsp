<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
   	 String reportType = request.getParameter("reportType");
	 String sessionKey = null;

	 // 若有多檔需下載 , 可以識別字做為區分
	 // 會員資料查詢匯出
	 if("member_export".equals(reportType)) { sessionKey = "member_file"; }
	 if("clear_member_export".equals(reportType)) { session.setAttribute("member_file",""); }

 	 // 回傳前端 Ajax Session 的狀態值
	 Object res = session.getAttribute(sessionKey);
	 out.print(res);
%>