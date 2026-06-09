<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<%
	String account = StringTool.validString(request.getParameter("account"), "%");		// 指定帳號
	String idno = "";																	// 統編
	String web_name = "";																// 網域名稱
	
	/*-- 使用MD5加密重設所有後台管理員密碼 --*/
	Vector<TableRecord> aus = app_sm.selectAll(tblau, "au_account like ?", new Object[]{ account });

	for(TableRecord au : aus) {
		String au_password = sha256(au.getString("au_account") + idno + web_name);
		au.setValue("au_password", au_password);
		app_sm.update(au);
	}
	out.println("<script> alert('後台管理員密碼重設完畢！'); </script>");

	app_sm.close();
	return;
%>