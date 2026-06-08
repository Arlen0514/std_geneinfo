<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "order";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "即時詢價單監控";				// 功能標題
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	int reload_time		= 1;						// 網頁自動 Reload 分數

	Vector oss = app_sm.selectAll(tblos , "os_code=? AND os_lang=? AND os_createdate>? AND os_ship<>? AND os_status=?",  new Object[] { code, lang , app_today , "Y" , "Y"} , "os_createdate DESC");
	Vector old_oss = app_sm.selectAll(tblos , "os_code=? AND os_lang=? AND os_createdate>? AND NOT(os_ship<>? AND os_status=?)",  new Object[] { code, lang , app_today , "Y" , "Y"} , "os_modifydate DESC LIMIT 3");
	String rec_num = StringTool.validString(request.getParameter("rec_num"));
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<%if(reload_time > 0) { %>
<meta http-equiv="refresh" content="<%=reload_time * 60 %>; url=order_n.jsp?rec_num=<%=oss.size() %>" />						<%-- 讓網頁自動 Reload --%>
<%} %>
<script language="JavaScript" type="text/JavaScript">
	function goaction(FORM,JSP) {
	    FORM.action = JSP;
	    FORM.submit();
	}
	function godelete(FORM,JSP) {
	    if (confirm("確定刪除嗎？")) {
	        FORM.action = JSP;
	        FORM.submit();
	    }
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
            		<td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48"></td>
            		<td align="left" valign="middle" class="web_bigword"><%=show_title %></td>
          		</tr>
          		
          		<tr>
            		<td colspan="2"><hr size="1" noshade></td>
          		</tr>

				<tr>
					<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
				  				<tr align="center">
				    				<td colspan="11" align="center" class="web_title-1">本日待出貨詢價單列表</td>
				  				</tr>
				  				
				  				<tr class="web_bk-2">
								    <td width="5%" align="center">項目</td>
								    <td width="8%" align="center">訂購人姓名</td>
								    <td width="8%" align="center">電話</td>
								    <td width="8%" align="center">詢價單編號</td>
								    <td width="8%" align="center">詢價日期</td>
								    <td width="8%" align="center">詢價單狀態</td>
									<td width="8%" align="center">是否回覆</td>
								    <td width="15%" align="center">功能</td>
				  				</tr>
				  				
				  				<%
				  				for(int i = 0; i <oss.size(); i++) { 
									TableRecord os = (TableRecord)oss.get(i);
									// 判別付款方式是否可手動變更狀態(非金流付款 人工check)
									boolean can_change_collect = ("epos".equals(os.getString("os_paymethod")) || "allpay".equals(os.getString("os_paymethod")) || "epos.atm".equals(os.getString("os_paymethod")));						
				  				%>
<form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
				  				<tr class="web_table-2-1">
									<td align="center"><%=i+1 %></td>
								    <td align="left">&nbsp;&nbsp;<%=os.getString("os_name") %></td>
								    <td align="left">&nbsp;&nbsp;<%=os.getString("os_cellphone") %></td>
								    <td align="left">&nbsp;&nbsp;<%=os.getString("os_no") %></td>
								    <td align="center"><%=os.getString("os_createdate").subSequence(0, 10) %></td>				    
								    <td align="center"><%="N".equals(os.getString("os_status"))?"作廢":"正常" %></td>
								    <td align="center">
								    	<input type="checkbox" value="Y" name="os_ship" <%="Y".equals(os.getString("os_ship"))?"checked":"" %> onclick="goaction(this.form, '<%=code %>_update.jsp?action=REPLY');"/>
								    </td>				   
								    <td align="center">
										<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
										<input type="hidden" name="os_id" id="os_id" value="<%=os.getString("os_id") %>" />
										<input type="hidden" name="code" id="code" value="<%=code %>_n" />
										
										<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="檢視" onclick="goaction(this.form, '<%=code %>_b.jsp');" />&nbsp;
										<%-- 
										<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="刪除" onclick="godelete(this.form, '<%=code %>_update.jsp?action=D');"/> <%} %>
										--%>
										<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="<%="N".equals(os.getString("os_status"))?"恢復詢價單":"詢價單作廢" %>" onclick="goaction(this.form, '<%=code %>_update.jsp?action=STATUS');"/> <%} %>
								    </td>
								</tr>
</form>
								<%} %>
							</table></td>
						</tr>
					</table></td>
				</tr>
				
				<tr>
					<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
				  				<tr align="center">
				    				<td colspan="11" align="center" class="market_title-1">本日最新 3 筆已處理詢價單列表</td>
				  				</tr>
				   				
				   				<tr class="market_bk-2">
								    <td width="5%" align="center">項目</td>
								    <td width="8%" align="center">訂購人姓名</td>
								    <td width="8%" align="center">電話</td>
								    <td width="8%" align="center">詢價單編號</td>
								    <td width="8%" align="center">詢價日期</td>
								    <td width="8%" align="center">詢價單狀態</td>
									<td width="8%" align="center">是否回覆</td>
								    <td width="15%" align="center">功能</td>
				  				</tr>
				  				
				  				<%
				  				for(int i = 0; i < old_oss.size(); i++) { 
									TableRecord os = (TableRecord)old_oss.get(i);
									// 判別付款方式是否可手動變更狀態(非金流付款 人工check)
									boolean can_change_collect = ("epos".equals(os.getString("os_paymethod")) || "allpay".equals(os.getString("os_paymethod")) || "epos.atm".equals(os.getString("os_paymethod")));						
				  				%>
<form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
				  				<tr class="market_table-2-1">
									<td align="center"><%=i+1 %></td>
								    <td align="left">&nbsp;&nbsp;<%=os.getString("os_name") %></td>
									<td align="left">&nbsp;&nbsp;<%=os.getString("os_cellphone") %></td>
								    <td align="left">&nbsp;&nbsp;<%=os.getString("os_no") %></td>
								    <td align="center"><%=os.getString("os_createdate").subSequence(0, 10) %></td>				    
								    <td align="center"><%="N".equals(os.getString("os_status"))?"作廢":"正常" %></td>
								    <td align="center">
								    	<input type="checkbox" value="Y" name="os_ship" <%="Y".equals(os.getString("os_ship"))?"checked":"" %> onclick="goaction(this.form, '<%=code %>_update.jsp?action=REPLY');"/>
								    </td>				   			    
								    <td align="center">
										<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
										<input type="hidden" name="os_id" id="os_id" value="<%=os.getString("os_id") %>" />
										<input type="hidden" name="code" id="code" value="<%=code %>_n" />
										
										<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="檢視" onclick="goaction(this.form, '<%=code %>_b.jsp');" />&nbsp;
										<%-- 
										<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="刪除" onclick="godelete(this.form, '<%=code %>_update.jsp?action=D');"/> <%} %>
										--%>
										<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="<%="N".equals(os.getString("os_status"))?"恢復詢價單":"詢價單作廢" %>" onclick="goaction(this.form, '<%=code %>_update.jsp?action=STATUS');"/> <%} %>
								    </td>
								</tr>
</form>
								<%} %>
							</table></td>
						</tr>
					</table></td>
				</tr>		
		
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