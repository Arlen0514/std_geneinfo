<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%-- POI 4.1.2 Excel匯入需要的檔案: WEB-INF/lib/commons-math3-3.6.1.jar --%>
<%
	String code	= "message_excel";		// 頁面代碼
	String ul_file = "";
	String cellphone = "";				// 接收人手機
	String content = "";				// 簡訊發送內容
	String sendDate = "";				// 寄送日期

try {
	// 檔案路徑與設置
    String dir = app_uploadpath+"/import";
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");		// 亂碼關鍵(1)
	fu.setSizeMax(4194304); 			// 設置文件大小
	fu.setSizeThreshold(4096); 			// 設置緩衝大小
	fu.setRepositoryPath(dir); 			// 設置臨時目錄
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();
	
	while(i.hasNext()) {
		FileItem fi = (FileItem) i.next();

		// 這是用來確定是否為文件屬性 
		if(fi.isFormField()) {
			// 讀取匯入類別
			String fieldName = new String(fi.getFieldName()); 										// 取得表單名
			String fieldvalue = new String(fi.getString("UTF-8")); 									// 取得值
			//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
			
			if("_content".equals(fieldName)) {
				content = fieldvalue;
			} else if("_sendDate".equals(fieldName)) {
				sendDate = fieldvalue;
			}
		} else {
			int g = fi.getName().lastIndexOf("\\");
			String fileName = fi.getName();
			String fileName_1 = "";
			if(g<0) {
	        	fileName = fi.getName();															// 兼容非ie
	         	fileName_1 = fi.getName();
	        } else {
	        	fileName = fi.getName().substring(g);												// 取得上傳文件名
	        	fileName_1 = fileName.substring(1,fileName.length());
	      	}
			if (fileName != null && !"".equals(fileName)) {
				String chk_str = fileName;
				/*if(chk_str.getBytes().length != new String(chk_str).length()) {
					out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
					return;
				}*/
				fi.write(new File(dir, fileName_1));
				ul_file = fileName_1;
			}
		}
	}
	
	/*-- 讀取欲匯入的 Execl 檔 --*/
    HSSFWorkbook wb = new HSSFWorkbook(session.getServletContext().getResourceAsStream("/uploads/import/"+ul_file));
	HSSFSheet sheet = wb.getSheetAt(0);

	// 獲取Excel的列數
	int rows = sheet.getPhysicalNumberOfRows();
	Vector in_db = new Vector();

	// 第0列為欄位名稱, 故而從第1列開始讀取 !!(程式有0列)
    for(int ex = 1; ex < rows; ex++) {
		// 欄位資料
		String excelCellphone = "";

    	int error_count = 0;
   		boolean can_into = true;
    	HSSFRow row = sheet.getRow(ex);
		if (row != null) {
			if(row.getCell(0) != null) {
				if(row.getCell(0).getCellType() == CellType.STRING) {
					row.getCell(0).setCellType(CellType.STRING);
					excelCellphone = row.getCell(0).getStringCellValue();
				} else if(row.getCell(0).getCellType() == CellType.NUMERIC) {
					row.getCell(0).setCellType(CellType.STRING);
					excelCellphone = row.getCell(0).getStringCellValue();
				}
			} else {
				excelCellphone = "";
				can_into = false;
			}

			// 全抓值完畢
			if(can_into){
				if(!"".equals(excelCellphone)) {
					cellphone += ((ex > 1)?",":"") +  excelCellphone;
				}
           	} else {
           		//
           	}
		}
    }
    FileTool.deleteFile(app_uploadpath+"/import/"+ul_file);
    
    // session
    Vector<String> dataVec = new Vector();
    dataVec.add(cellphone);
    dataVec.add(content);
    dataVec.add(sendDate);
    dataVec.add(app_account);

    session.setAttribute("messageData", dataVec);

    out.println("<script> location.href='../../web/message/every8d_message_post.jsp?action=excel'; </script>");
} catch(Exception e) {
	System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for [import_update]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('檔案上傳處理失敗，請與管理人員聯絡 !!'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>