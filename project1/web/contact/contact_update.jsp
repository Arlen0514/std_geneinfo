<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="../include/words.jsp" %>
<%
	// 頁面識別碼
	String page_code = "contact";

	// 檢核圖形驗証碼
	String r = StringTool.validString((String) session.getAttribute("rand"));
	String ind = StringTool.validString(request.getParameter("ind"));
	if((!r.equals(ind)) || ("".equals(r))) {
		out.println("<script> alert('"+alert_str.get("code_error."+lang)+"'); history.back(); </script>");
		return;
	}
	
	// 必填欄位
	String[] requireColumns = {
		"cu_name", "cu_phone", "cu_email", "cu_content"
	};
	Vector<String> requireDatas = new Vector();
	for(String rc:requireColumns) {
		requireDatas.add(rc);
	}

	try {
		TableRecord cu = new TableRecord(tblcu);
		for(int j = 0; j < cu.fieldNames().length; j++) {
			String name = cu.fieldNames()[j];
			String value = StringTool.validString(request.getParameter(name));
			
			if(!value.equals("")) {
				cu.setValue(name, StringTool.validString(request.getParameter(name)));
			} else if(value.equals("") && requireDatas.contains(value)) {
				out.println("<script>alert('請確認表單是否填寫完整 !!'); history.back(); </script>");
				return;
			}
		}
		cu.setValue("cu_lang", lang);
		cu.setValue("cu_reply", "N");
		cu.setValue("cu_code", page_code);
		cu.setInsert("Web_User");
		app_sm.insert(cu);

		out.println("<script> location='" + page_code + "_sendmail.jsp?cu_id=" + cu.getString("cu_id") + "'; </script>");
		//out.println("<script>alert('已收到您的問題，我們會盡快與您聯繫 !!'); location='../index/index.jsp'; </script>");
		//out.println("<script> alert('感謝您的發問');location='" + page_code + ".jsp'; </script>");
	} catch (Exception e) {
		System.out.println("Project:" + projectName + ", Error info:[" + e + "], File:web/contact/contact_update.jsp for [" + page_code + "], Time:[" + DateTimeTool.dateTimeString() + "]");
		out.println("<script> alert('"+alert_str.get("code_error."+lang)+"'); history.back(); </script>");
	} finally {
		app_sm.close();
	}
%>