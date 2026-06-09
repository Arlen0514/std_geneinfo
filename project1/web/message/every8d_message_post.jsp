<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@ page import="java.net.*" %>
<%@ page import="javax.net.ssl.*" %>
<%@page import="org.w3c.dom.*"%>
<%@page import="javax.xml.parsers.*"%>
<%@page import="org.xml.sax.InputSource"%>
<%@page import="javax.servlet.*"%>
<%@page import="javax.servlet.Servlet"%>
<%@page import="com.genesis.sms.MainClass"%>
<%@page import="com.genesis.sms.SMSHttpService"%>
<% 	
try {
	String action = StringTool.validString(request.getParameter("action"));
	String cellphone = StringTool.validString(request.getParameter("_cellphone"), "");			// 接收人手機
	String content = StringTool.validString(request.getParameter("_content"));					// 簡訊發送內容
	String sendDate = StringTool.validString(request.getParameter("_sendDate"));				// 寄送日期
	String account = StringTool.validString(request.getParameter("account"));					// 簡訊發送人
	String userID= SiteSetup.getSetup("every8d.account" + "." + lang).getString("ss_text");		// 帳號
	String password= SiteSetup.getSetup("every8d.password" + "." + lang).getString("ss_text");	// 密碼
	String sendTime = sendDate.replace("/", "") + "000000";    									// 寄送時間設定
	String subject="";					// 簡訊主旨，主旨不會隨著簡訊內容發送出去。用以註記本次發送之用途。可傳入空字串。
	
	// 單封寄送
	if("one".equals(action)) {
		MainClass sms_message = new MainClass();
		
		// 簡訊寄出
		String message_result = sms_message.getPost(userID,password,subject,content,cellphone,sendTime,"sms");
		//System.out.println(message_result);
		
		// 簡訊寄送紀錄
		TableRecord mh = new TableRecord(tblmh);
		mh.setValue("mh_sendid", "");
		mh.setValue("mh_status", "Y");
		mh.setValue("mh_cellphone", cellphone);
		mh.setValue("mh_senddate", app_today);
		mh.setValue("mh_content", content);
		mh.setValue("mh_memo", message_result);
		mh.setValue("mh_code", "message_history");
		mh.setInsert(account);
		app_sm.insert(mh);
		
		out.println("<script> alert('簡訊寄送成功!!'); location.href='../../mis/special/message_one.jsp'; </script>");
	// 多封寄送
	} else if("multi".equals(action)) {
		MainClass sms_message = new MainClass();
		
		// 簡訊寄出
		String message_result = sms_message.getPost(userID,password,subject,content,cellphone,sendTime,"sms");
		//System.out.println(message_result);

		// 簡訊寄送紀錄
		TableRecord mh = new TableRecord(tblmh);
		mh.setValue("mh_sendid", "");
		mh.setValue("mh_status", "Y");
		mh.setValue("mh_cellphone", cellphone);
		mh.setValue("mh_senddate", app_today);
		mh.setValue("mh_content", content);
		mh.setValue("mh_memo", message_result);
		mh.setValue("mh_code", "message_history");
		mh.setInsert(account);
		app_sm.insert(mh);
		
		out.println("<script> alert('簡訊寄送成功!!'); location.href='../../mis/special/message_multi.jsp'; </script>");
	// Excel匯入寄送
	} else if("excel".equals(action)) {
		MainClass sms_message = new MainClass();
		
		Vector<String> dataVec = (Vector) session.getAttribute("messageData");
		cellphone = dataVec.get(0);
		content = dataVec.get(1);
		sendTime = dataVec.get(2);
		account = dataVec.get(3);
		
		// 簡訊寄出
		String message_result = sms_message.getPost(userID,password,subject,content,cellphone,sendTime,"sms");
		//System.out.println(message_result);
		
		// 簡訊寄送紀錄
		TableRecord mh = new TableRecord(tblmh);
		mh.setValue("mh_sendid", "");
		mh.setValue("mh_status", "Y");
		mh.setValue("mh_cellphone", cellphone);
		mh.setValue("mh_senddate", app_today);
		mh.setValue("mh_content", content);
		mh.setValue("mh_memo", message_result);
		mh.setValue("mh_code", "message_history");
		mh.setInsert(account);
		app_sm.insert(mh);
		
		session.removeAttribute("messageData");
		out.println("<script> alert('簡訊寄送成功!!'); location.href='../../mis/special/message_excel.jsp'; </script>");
	// 金額查詢
	} else if("credit".equals(action)) {
		MainClass sms_message = new MainClass();
		
		SMSHttpService sms=new SMSHttpService();
 		sms.getCredit(userID, password);
 		Double creditValue = sms.getCreditValue();
		// 金額查詢
// 		String message_result = sms_message.getPost(userID,password,subject,content,cellphone,sendTime,"credit");
		//System.out.println(message_result);

		out.println("<script> alert('剩餘點數 :"+creditValue+"'); location.href='../../mis/special/message_search.jsp'; </script>");
	}
} catch(Exception e) {
	System.out.println("Error info:["+e+"]File name edit.jsp for [every8d_message_post]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('簡訊寄送失敗'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>