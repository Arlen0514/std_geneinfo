<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<%
	String pwd_ok = (String) session.getAttribute("pwd_ok");

	/*-- 將後台管理員密碼使用sha256加密 --*/
	if(pwd_ok == null) {
		Vector<TableRecord> mps = app_sm.selectAll(tblmp);

		for(TableRecord mp : mps) {
			String password = sha256(mp.getString("mp_password"));
			mp.setValue("mp_password", password);
			mp.setUpdate("set_md_member.jsp");
			app_sm.update(mp);
		}
		
		session.setAttribute("pwd_ok", "OK");
		out.println("<script> alert('會員資料密碼轉換完畢！'); </script>");
	} else {
		out.println("<script> alert('會員資料密碼已轉換，將不再重複執行。'); </script>");
	}

	app_sm.close();
	return;
%>