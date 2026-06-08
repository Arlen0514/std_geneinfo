<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
String code	= StringTool.validString(request.getParameter("code"));		// 識別碼
String db_names	= tblos; 												// 使用哪張資料表
String show_title = "詢價單維護";											// 功能標題
String src = StringTool.validString(request.getParameter("src"));
src = "".equals(src)?"":"?src="+src;

try {
	String action = StringTool.validString(request.getParameter("action"));		// A:新增,M:修改,D:刪除,S:排序
	String os_id = StringTool.validString(request.getParameter("os_id"));

	// Conditions.
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	String qship = StringTool.validString(request.getParameter("_qship"));
	String qbonus = StringTool.validString(request.getParameter("_qbonus"));
	String qivoice = StringTool.validString(request.getParameter("_qivoice"));
	String qosno = StringTool.validString(request.getParameter("_qosno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship",
		"_qcollect", "_qbonus", "_qosno", "_qpayment", "os_id", "_qivoice"
	};
	
	String[] values = new String[] { 
		String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship,
		qcollect, qbonus, qosno, qpayment, os_id, qivoice
	};
	
	out.println(HtmlCoder.form("backdata", code+".jsp"+src, names, values));

	// 刪除
	if("D".equals(action)) {				
		app_sm.delete(db_names, "os_id=?", new Object[] { os_id });		// 刪除詢價單
		//app_sm.delete(tblmb, "os_id=?", new Object[] { os_id });		// 刪除紅利記錄
		
		if(app_sm.success()) {
			out.println("<script> alert('刪除成功!!'); backdata.submit();  </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 設定收件者
	if("POP3".equals(action)) {
		// Tiltes.
		String[] titles = new String[] { show_title+"正本收件者", show_title+"副本收件者" };
		
		// Keywords.
		String[] keywords = new String[] { "original", "duplicate" };
		
		// Get records.
		Vector smtps = new Vector();
		for(int i = 0; i < titles.length; i++) {
		    TableRecord ss = SiteSetup.getSetup(keywords[i]+"."+code+"."+lang);
		    ss.setUpdate(app_account);
		    String value = StringTool.validString(request.getParameter(keywords[i]));
		    ss.setValue("ss_value", value);
		    ss.setUpdate(app_account);
		    app_sm.update(ss);
		}
		
		if(app_sm.success()) {
			out.println("<script> alert('收件者設定成功!!'); backdata.submit(); </script>");
		} else {
			out.println("<script> alert('設定失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 變更處理狀態	
	} else if("REPLY".equals(action)) {
		TableRecord os = app_sm.select(db_names, "os_id=?", new Object[]{os_id});
		os.setUpdate(app_account);
		os.setValue("os_ship", "Y".equals(StringTool.validString(os.getString("os_ship")))?"N":"Y");
		app_sm.update(os);
		
		if(app_sm.success()) {
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('修改成功!!');listpage.submit(); </script> ");
		} else {
			out.println("<script> alert('設定失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 變更詢價單狀態
	} else if("STATUS".equals(action)) {
		TableRecord os = app_sm.select(db_names, "os_id=?", new Object[]{os_id});
		os.setValue("os_status", "Y".equals(StringTool.validString(os.getString("os_status")))?"N":"Y");
		os.setUpdate(app_account);
		Vector ols = app_sm.selectAll(tblol, "os_id=?", new String[]{os_id});
		app_sm.update(os);
		
		if(app_sm.success()) {
			out.println("<script> backdata.submit();  </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
} catch(Exception e) {
	System.out.println("Project:" + projectName + ", Error info:" + e + ", File name order_update.jsp, Time:" + DateTimeTool.dateTimeString());
	out.println("<script> alert('處理失敗'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>