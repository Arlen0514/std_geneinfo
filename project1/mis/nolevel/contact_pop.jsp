<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "contact"; 				// 模組識別碼
	String show_title = "信件管理維護";		// 模組標題

	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = false;		// 是否開啟排序功能
	int add_num = 0;					// 設定可新增的資料筆數 , -1 為無限筆

/*------------------------------------------------------------------------------------------*/

	Vector cus = app_sm.selectAll(tblcu, "cu_code=? and cu_lang=?", new Object[] { code, lang }, "cu_createdate DESC");

	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cus);

	TableRecord ss = new TableRecord(tblss);

	// 設定多預設值(直接顯示修改畫面)
	String[] titles = new String[] { show_title.replace("維護", "") + "正本收件者", show_title.replace("維護", "") + "副本收件者" };
	String[] keywords = new String[] { "original", "duplicate" };

	for(int i = 0; i < titles.length; i++) {
		ss = SiteSetup.getSetup(keywords[i]+"."+code+"."+lang);
		if(ss.getString("ss_id").equals("")) {
		    ss = new TableRecord(tblss);
		    ss.setInsert(app_account);
		    ss.setValue("ss_title", titles[i]);
		    ss.setValue("ss_keyword", keywords[i]+"."+code+"."+lang);
		    app_sm.insert(ss);
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {
		// 驗證副檔名
		var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png))/;
		// 驗證中文
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
<form name="frm" id="frm" method="post" action="<%=code%>_update.jsp?action=POP3" onsubmit="javascript:return checkform(this);">
				<tr>
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<tr>
									<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
										<%if (add_switch) { %>
										<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
										<%} %>
										<%if (list_switch) { %>
										<input type="button" value="信件資訊列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
										<%} %>
										<%if (sort_switch) { %>
										<input type="button" value="信件資訊排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
										<%} %>
										<input type="button" value="設定<%=show_title %>收件者" onclick="javascript:location.href='<%=code%>_pop.jsp'" />&nbsp;
									</td>
								</tr>							
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">收件者設定</td>
								</tr>
								<tr class="web_table-2-1">
							  		<td width="15%" align="right">
										正本
							  		</td>
							 		<td width="85%" colspan="3" align="center">
										<textarea name="original" id="original" cols="90%" rows="2"><%=SiteSetup.getValue("original."+code+"."+lang) %></textarea>
										<br />
										<B>請以逗號 『 ， 』作收件人區分設定 : 例:123@gmail.com , abc@gmail.com</B>
									</td>
						    	</tr>
						    	<%--
						    	<tr class="web_table-2-1">
									<td align="center">
										副本
									</td>
									<td align="center">
										<textarea name="duplicate" id="duplicate" cols="70%" rows="2"><%=SiteSetup.getValue("duplicate."+cu_code+"."+lang) %></textarea>
									</td>
						   		</tr>
						   		--%>
							</table></td>
						</tr> 		
		        	</table></td>
				</tr>    

				<tr>
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<tr class="web_table-2-1">
									<td width="15%" align="right">最後修改人員</td>
									<td width="35%" align="left"><%=ss.getString("ss_modifyuser") %></td>
									<td width="20%" align="right">最後修改日期</td>
									<td width="30%" align="left"><%=ss.getString("ss_modifydate") %></td>
								</tr>
							</table></td>
						</tr>
						<tr align="center">
							<td colspan="4" align="center"><br />
								<input type="submit" value="確定送出" />&nbsp;
								<input type="reset" value="重新設定" />&nbsp;
							</td>
						</tr>
					</table></td>
				</tr>
</form>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" class="web_bk-2b">&nbsp;</td>
				</tr>
			</table></td>
		</tr>
	</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>