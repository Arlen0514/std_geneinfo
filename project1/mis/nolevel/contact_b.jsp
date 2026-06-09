<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%

	// 基本參數
	String code = "contact"; 			// 模組識別碼
	String show_title = "信件管理維護";		// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	int add_num = 0;				// 設定可新增的資料筆數 , -1 為無限筆
/*------------------------------------------------------------------------------------------*/
	Vector cus = app_sm.selectAll(tblcu, "cu_code=? and cu_lang=?", new Object[] { code, lang },  "cu_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cus);
	
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
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
	// 修改資料id
	String cu_id = StringTool.validString(request.getParameter("cu_id"));
	TableRecord cu = app_sm.select(tblcu, cu_id);
	
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
    return true;
    
}
</script>
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table class="default_table" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2">
      	<table border="0" cellspacing="0" cellpadding="0">       
			<%@include file="/WEB-INF/jspf/mis/top.jspf"%>
      </table>
      </td>
    </tr>
    
    <tr class="default_table_bottom page_mis">
    
      <td width="" align="center" valign="top" class="system_bk-2">
      		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<%@include file="../leftmenu.jsp"%>          
      		</table>
      	</td>
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><table width="99%" border="0" cellspacing="0" cellpadding="0">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>
			<tr>
				<td colspan="2" class="web_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle">
					<img src="../images/web_icon_1.gif" width="55" height="48">
				</td>
				<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
								<%if (add_switch) { %>
								<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
								<%} %>
								<%if (list_switch) { %>
								<input type="button" value="信件資訊列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
								<%} %>
								
								<input type="button" value="設定<%=show_title %>收件者" onclick="javascript:location.href='<%=code%>_pop.jsp'" />&nbsp;
								</td>
							</tr>							
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">檢視資訊</td>
							</tr>
							
							<tr class="web_table-2-1">
			                  	<td width="15%" align="right">詢問主題 ： </td>
			                 	<td width="35%" align="left">&nbsp;&nbsp;<%=cu.getString("cu_title") %></td>
			                  	<td width="15%" align="right">聯絡日期 ：  </td>
			                  	<td width="35%" align="left" >&nbsp;&nbsp;<%=cu.getString("cu_createdate") %>&nbsp;&nbsp;<span <%="Y".equals(cu.getString("cu_reply"))?"":"style='color:red'" %>><B>( <%="Y".equals(cu.getString("cu_reply"))?"已":"未" %>回覆 )</B></span></td>
							</tr>							
							
							<tr class="web_table-2-1">
			                  	<td align="right">公司名稱 ：  </td>
			                  	<td align="left" >&nbsp;&nbsp;<%=cu.getString("cu_company") %></td>
			                  	<td align="right">姓名 ： </td>
			                 	<td align="left">&nbsp;&nbsp;<%=cu.getString("cu_name") %></td>
							</tr>
							
						    <tr class="web_table-2-1">
								<td align="right">電話： </td>
			                 	<td align="left">&nbsp;&nbsp;<%=cu.getString("cu_phone")%></td>			         
		                 		<td align="right">電子郵件 ： </td>
		                 		<td align="left">&nbsp;&nbsp;<%=cu.getString("cu_email") %></td>
						    </tr>
										  
							<tr class="web_table-2-1">
			                  	<td align="right">需求說明： </td>
			                 	<td align="left" colspan="3" >&nbsp;&nbsp;<%=cu.getString("cu_content").replaceAll("(\r\n|\n)", "<br />") %></td>
							</tr>	
						</table>
						</td>
					</tr> 		
		        </table>
				</td>
			</tr>
			
		
							
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">       

	
							<tr class="web_table-2-1">
								<td width="15%" align="right">最後修改人員</td>
								<td width="35%" align="left"><%=cu.getString("cu_modifyuser") %></td>
								<td width="15%" align="right">最後修改日期</td>
								<td width="35%" align="left"><%=cu.getString("cu_modifydate") %></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="button" value="回上一頁" onClick="listpage.submit();">
					</td>
					</tr>
				</table>
				</td>

			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="web_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</div>
	</tr>
</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>