<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%	
	// 基本參數
	String code = "hot_product"; 				// 模組識別碼
	String data_code = "product";				// 選取模組識別碼
	String show_title = "熱門商品維護";			// 模組標題
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage" };
	String[] values = new String[] { String.valueOf(pageno)};
	
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	// 回排序頁
	out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
%>
<%
try {
	// A:新增,M:修改,D:刪除,S:排序,P:顯示
	String action = StringTool.validString(request.getParameter("action"));
	// 修改資料ID
	String pd_id = StringTool.validString(request.getParameter("pd_id"));
	String pd_title = StringTool.validString(request.getParameter("pd_title"));
	// 欲取代選取的資料ID  
	String pd_replaceid = StringTool.validString(request.getParameter("pd_replaceid"));
	// 選取編號
	String showno = StringTool.validString(request.getParameter("showno"));

	// 選取
	if("choose".equals(action)) {
		TableRecord pd = app_sm.select(tblpd, "pd_id=?", new Object[] { pd_id });
		pd.setUpdate(app_account);
		pd.setValue("pd_hot", "Y"+showno);
		app_sm.update(pd);

		// 清除舊選取
		if(!pd_replaceid.isEmpty()) {
			TableRecord old_pd=app_sm.select(tblpd,pd_replaceid);
			old_pd.setValue("pd_hot", "");
			app_sm.update(old_pd);
		}

		if(app_sm.success()) {
			out.println("<script> alert('修改成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 清除現有選取
	if ("clear".equals(action)) {
		TableRecord pd = app_sm.select(tblpd, "pd_id=?", new Object[] { pd_id });
		pd.setUpdate(app_account);
		pd.setValue("pd_hot", "");
		app_sm.update(pd);

		if(app_sm.success()) {
			out.println("<script> alert('修改成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 刪除
	if ("D".equals(action)) {
		TableRecord pd = app_sm.select(tblpd, pd_id);
		app_sm.delete(pd);

		if(app_sm.success()) {
			out.println("<script> alert('刪除成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 排序
	if ("S".equals(action)) {
		String chk_pd = StringTool.validString(request.getParameter("selData"));
		String list[] = chk_pd.split(",");
		for (int j = 0; j < list.length; j++) {
			if (!"".equals(list[j].trim())) {
				TableRecord pd = app_sm.select(tblpd, "pd_id =?", new Object[] { list[j] });
				//pd.setValue("pd_showseq", j);
				pd.setValue("pd_hot", "Y"+(j+1));
				pd.setUpdate(app_account);
				app_sm.update(pd);
			}
		}

		if(app_sm.success()) {
			out.println("<script> alert('排序完成!!');sortpage.submit(); </script>");
		} else {
			out.println("<script> alert('排序失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
} catch (Exception e) {
	System.out.println("Project:" + projectName + ", Error info:[" + e + "]File name edit.jsp for ["+ code + "]Time:[" + DateTimeTool.dateTimeString() + "]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>