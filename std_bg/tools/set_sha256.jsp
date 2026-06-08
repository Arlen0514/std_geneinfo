<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<%
	String pwd_ok = (String) session.getAttribute("pwd_ok");

	/*-- 將後台管理員密碼使用sha256加密 --*/
	if(pwd_ok == null) {
		Vector<TableRecord> aus = app_sm.selectAll(tblau);

		for(TableRecord au : aus) {
			String au_password = sha256(au.getString("au_password"));
			au.setValue("au_password", au_password);
			app_sm.update(au);
		}
		
		session.setAttribute("pwd_ok", "OK");
		out.println("<script> alert('後台管理員密碼轉換完畢！'); </script>");
	} else {
		out.println("<script> alert('後台管理員密碼已轉換，將不再重複執行。'); </script>");
	}

	app_sm.close();
	return;
%>