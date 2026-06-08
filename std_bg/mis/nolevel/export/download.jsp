<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	/*-- 檔案下載 --*/
   	// Download file name.
   	String fileName = StringTool.validString(request.getParameter("file"));
	// Whole path of download file.
	String downloadfile = request.getRealPath("/uploads/export") + "/"+fileName; 
	File file = new File(downloadfile);
	
    // 設定 HTTP Header
    response.reset();
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + "\"");
    response.setHeader("Content-Length", String.valueOf(file.length()));

    // 使用串流輸出
    // ✅ 自動關閉：try-with-resources
    try (
        FileInputStream fis = new FileInputStream(file);
        BufferedInputStream in = new BufferedInputStream(fis);
        OutputStream os = response.getOutputStream();
        BufferedOutputStream outStream = new BufferedOutputStream(os);
    ) {
        byte[] buffer = new byte[8192];
        int bytesRead;
        while ((bytesRead = in.read(buffer)) != -1) {
            outStream.write(buffer, 0, bytesRead);
        }
        outStream.flush();  // ✅ 確保資料全部送出
    } catch (IOException e) {
    	System.out.println("Project:" + projectName + ", Error info:" + e.getMessage() + ", File name download.jsp, Time:" + DateTimeTool.dateTimeString());
    }
    
    // 解決 getOutputStream() has already been called for this response
    out.clear(); 
    out = pageContext.pushBody();
%>
