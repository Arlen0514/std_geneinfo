<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "contact"; 				// 模組識別碼
	String show_title = "信件管理維護";		// 模組標題

	// 搜尋欄位
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"), DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"), DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qreply = StringTool.validString(request.getParameter("_qreply"));
	String qemail = StringTool.validString(request.getParameter("_qemail"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qname", "_qreply" , "_qemail" , "_qphone" ,"_qemitdate", "_qrestdate"};
	String[] values = new String[] { String.valueOf(pageno), qname, qreply , qemail ,qphone , qemitdate, qrestdate};
%>
<%
	try {
		// A:新增,M:修改,D:刪除,S:排序,P:顯示
		String action = StringTool.validString(request.getParameter("action"));
		String cp_title = StringTool.validString(request.getParameter("cp_title"));
		// 修改資料id	
		String cu_id = StringTool.validString(request.getParameter("cu_id"));

		// 設定收件者
		if("POP3".equals(action)) {
			String[] titles = new String[] { show_title.replace("維護", "") + "正本收件者", show_title.replace("維護", "") + "副本收件者" };
			String[] keywords = new String[] { "original", "duplicate" };
			Vector smtps = new Vector();
			for (int i = 0; i < titles.length; i++) {
			    TableRecord ss = SiteSetup.getSetup(keywords[i]+"."+code+"."+lang);
			    ss.setUpdate(app_account);
			    String value = StringTool.validString(request.getParameter(keywords[i]));
			    ss.setValue("ss_value", value);
			    ss.setUpdate(app_account);
			    app_sm.update(ss);
			}

			if(app_sm.success()) {
				// 回收件者頁
				out.write(HtmlCoder.getForm("poppage", code + "_pop.jsp", names, values));
				out.println("<script> alert('收件者設定成功!!'); poppage.submit(); </script>");
			} else {
				out.println("<script> alert('設定失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;

		// 變更處理狀態	
		} else if("REPLY".equals(action)) {
			TableRecord cu = app_sm.select(tblcu, "cu_id=?", new Object[] { cu_id });
			cu.setUpdate(app_account);
			cu.setValue("cu_reply", "Y".equals(StringTool.validString(request.getParameter("cu_reply")))?"Y":"N");
			app_sm.update(cu);

			if(app_sm.success()) {
				// 回列表頁
				out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
				out.println("<script> alert('修改成功!!');listpage.submit(); </script> ");
			} else {
				out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;

		// 刪除
		} else if("D".equals(action)) {
			TableRecord cu = app_sm.select(tblcu, cu_id);
			app_sm.delete(cu);

			if(app_sm.success()) {
				// 回列表頁
				out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
				out.println("<script> alert('刪除成功!!');listpage.submit(); </script>");
			} else {
				out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
	} catch (Exception e) {
		System.out.println("Project:" + projectName + ", Error info:[" + e + "]File name edit.jsp for ["+ code + "]Time:[" + DateTimeTool.dateTimeString() + "]");
		out.println("<script> alert('處理失敗!!'); history.back(); </script>");
	} finally {
		app_sm.close();
	}
%>