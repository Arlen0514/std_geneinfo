<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%
	// 轉之前要確認
	// 1.資料庫本身就要是 utf8mb4 utf8mb4_unicode_520_ci 如果沒有會失敗
	
	// SHOW TABLES
	Vector <QueryResult> shows = app_sm.queryResult("SHOW TABLES;") ;
	for(QueryResult show_table:shows){
		System.out.println("tableName:"+show_table.getString(0));
	
		// String change_tbl = tblnp;
	
		app_sm.update("CREATE TABLE "+show_table.getString(0)+"_bk"+DateTimeTool.dateString("")+"  like "+show_table.getString(0)+";");
		app_sm.update("ALTER TABLE "+show_table.getString(0)+" CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;");
	
		if(app_sm.success()){
			System.out.println ("資料表 "+show_table.getString(0)+" 轉換完畢");
			// out.println("<script> alert('資料表 "+show_table.getString(0)+" 轉換完畢'); </script>");
		}else {
			System.out.println ("資料表 "+show_table.getString(0)+" 轉換失敗，轉換失敗，失敗原因："+app_sm.getMessage());
			// out.println("<script> alert('資料表 "+show_table.getString(0)+" 轉換失敗，失敗原因："+app_sm.getMessage()+"'); </script>");
		}
	}	
%>