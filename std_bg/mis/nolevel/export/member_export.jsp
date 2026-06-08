<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.apache.xmlbeans.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.Font" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="org.apache.poi.xssf.util.*" %>
<%@ page import="org.apache.poi.xssf.streaming.SXSSFWorkbook" %> 
<%@ page import="org.apache.poi.xssf.streaming.SXSSFSheet" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/mis/check.jspf" %>
<%--
// 新版poi(4.1.2) 匯出 xlsx 所需要的檔案如下
WEB-INF/lib/
	commons-codec-1.3.jar
	commons-collections4-4.4.jar
	commons-compress-1.21.jar
	poi-4.1.2.jar
	poi-ooxml-schemas-4.1.2.jar
	poi-ooxml.jar
	poi-scratchpad.jar
	xmlbeans-3.1.0.jar

// 舊版poi(3.6) 匯出xls 所需要的檔案如下
WEB-INF/lib/
	poi-3.6.jar
	log4j-1.2.7.jar

// 舊專案更新POI套件時請將舊版套件刪掉。
// 新版與舊版寫法不同，更新時也要記得把所有的EXCEL匯出改寫一次。
--%>
<%
	/*-- 連結網址 --*/
	String serverName = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort() == 80 || request.getServerPort() == 443) {
		serverName = request.getScheme()+"://"+request.getServerName();
	}
	String localName = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = serverName + request.getContextPath();

	// 以利前端檢查時 , 了解正在進行檔案匯出的工作
	session.setAttribute("member_file","start");

   	// Conditions.
   	String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   	String qname = StringTool.validString(request.getParameter("_qname"));
   	String qcellphone = StringTool.validString(request.getParameter("_qcellphone"));

   	// Names and values.
   	String[] names = new String[] { "npage", "_qname",  "_qaccount","_qcellphone" };
   	String[] values = new String[] { String.valueOf(pageno), qname, qaccount, qcellphone };
   	
   	// Get records.
   	StringBuffer sb = new StringBuffer();
   	Vector keys = new Vector();

   	sb.append("mp_mail_status <> 'N'");
   	sb.append(" and mp_cellphone like ?");
   	keys.add("%"+qcellphone+"%");
   	sb.append(" and mp_account like ?");
   	keys.add("%"+qaccount+"%");
   	sb.append(" and mp_name like ?");
   	keys.add("%"+qname+"%");

   	Vector <TableRecord> datas = app_sm.selectAll(tblmp, sb.toString(), keys.toArray(), "mp_createdate DESC");

	// 指定位置存相關資料
	int counter = 0;
	// 檢查是否有資料可以供匯出
	if(datas == null || datas.size() == 0) {
	   out.write("<script>alert('查無資料可供匯出！');</script>");
	   session.setAttribute("member_file", "no");
	} else {
	    // 將資料內容寫入指定檔案
		String clientFileName = app_account + "_member_export.xlsx";

	    try {
	    	// 使用範本檔進行Excel匯出
		    InputStream fis = new URL(url + "/mis/nolevel/export/member_export.xlsx").openStream();
			XSSFWorkbook wb1 = new XSSFWorkbook(fis);
		    //SXSSFWorkbook wb = new SXSSFWorkbook(wb1, 1000, true, true);			// 因為需要修改範本，所以必須改為XSSFSheet
		    XSSFSheet sheet = wb1.getSheetAt(0);

			/*-- 將資料內容寫入指定檔案 --*/
			// 欄位名稱
			String[] fildnames = { 
				"帳號", "姓名", "聯絡電話", "手機號碼", "通訊地址", "會員註冊時間", "紅利點數"
			};

			// 欄位樣式 & 字型設定
			Font font = wb1.createFont();
			font.setFontName("新細明體"); 											// 設定字體
			font.setFontHeightInPoints((short) 12); 								// 設定字體大小

			Font font2 = wb1.createFont();
			font2.setFontName("新細明體"); 											// 設定字體
			font2.setFontHeightInPoints((short) 14); 								// 設定字體大小

			// 設定儲存格格式(新版寫法) 
			CellStyle styleRow1 = wb1.createCellStyle();
			styleRow1.setWrapText(true);											// 設定儲存格內換行
			styleRow1.setAlignment(HorizontalAlignment.CENTER);						// 水平置中
			styleRow1.setVerticalAlignment(VerticalAlignment.CENTER);				// 垂直置中
			styleRow1.setFont(font); 												// 設定字體

			CellStyle styleRow2 = wb1.createCellStyle();
			styleRow2.setWrapText(true);											// 設定儲存格內換行
			styleRow2.setAlignment(HorizontalAlignment.CENTER); 					// 水平置中
			styleRow2.setVerticalAlignment(VerticalAlignment.CENTER); 				// 垂直置中
			styleRow2.setFont(font2); 												// 設定字體

			for(int i = 0; i < datas.size(); i++) {
				TableRecord data = datas.get(i);

				// Data
				String mp_account = "", mp_name = "", mp_phone = "", mp_cellphone = "", mp_address = "", mp_createdate = "", bonus_point = "";

				mp_account 		= data.getString("mp_account");
				mp_name 		= data.getString("mp_name");
				mp_phone 		= data.getString("mp_phone");
				mp_cellphone 	= data.getString("mp_cellphone");
				mp_address 		= data.getString("mp_address");
				mp_createdate	= data.getString("mp_createdate");
				//bonus_point	= app_df.format(MemberBonus.getTotalBonus(data.getString("mp_id")));

				// 放進去的資料
				String[] export = { 
					mp_account, mp_name, mp_phone, mp_cellphone, mp_address, mp_createdate, bonus_point
				};

				// 先填入欄位名稱
				if(i == 0) {
					Row row = sheet.createRow(counter);
					for (int e = 0; e < fildnames.length; e++) {
						Cell cell = row.createCell(e);
						cell.setCellStyle(styleRow2); 									// 套用格式
						cell.setCellValue(fildnames[e]); 								// 填入值
						/*
						sheet.trackAllColumnsForAutoSizing();							// 自動調整欄位寬度
						sheet.autoSizeColumn(e, false);									// 自動調整欄位寬度
						*/
					}
				}

				// 新增一列空白列 開始放入資料
				counter++;
				Row row = sheet.createRow(counter);

				for(int e = 0; e < export.length; e++) {
					Cell cell = row.createCell(e);
					cell.setCellStyle(styleRow1);										// 套用格式
					cell.setCellValue(export[e]);										// 填入值
					if(i == datas.size() - 1) {
						//sheet.trackAllColumnsForAutoSizing();							// 自動調整欄位寬度
						sheet.autoSizeColumn(e,false);									// 自動調整欄位寬度	
					}
				}
			}

			// 無路徑-檔案目錄新增
			File outputFolder = new File(app_uploadpath + "/export/");
			if(!outputFolder.exists()) {
				outputFolder.mkdir();
			}

			// 新增檔案 / 若存在則刪除同檔
			File outputFile = new File(outputFolder, clientFileName);
			if(outputFile.exists()) {
				outputFile.delete();
			}

			// 輸出
			FileOutputStream fos = new FileOutputStream(outputFile);

			wb1.write(fos);
			fos.flush();
			fos.close();

			// 以利前端檢查時 , 了解已完成檔案匯出的工作
			session.setAttribute("member_file", "end");
		} catch (Exception e) {
			session.setAttribute("member_file", "error");
			System.out.println("Project:" + projectName + ", Error info:" + e.getMessage() + ", File name member_export.jsp, Time:" + DateTimeTool.dateTimeString());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>