<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "order";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "詢價單維護";				// 功能標題
	
	/*-- 設定預設值 --*/
	// Tiltes.
	String[] titles = new String[] { "詢價單通知正本收件者", "詢價單通知副本收件者" };
	
	// Keywords.
	String[] keywords = new String[] { "original", "duplicate" };
	
	// Get records.
	Vector misimages = new Vector();
	for(int i = 0; i < titles.length; i++) {
	   TableRecord ss = SiteSetup.getSetup(keywords[i]+"."+code+"."+lang);
	   if(ss.getString("ss_id").equals("")) {
	       ss = new TableRecord(tblss);
	       ss.setInsert(app_account);
	       ss.setValue("ss_title", titles[i]);
	       ss.setValue("ss_keyword", keywords[i]+"."+code+"."+lang);
	       app_sm.insert(ss);
	   }
	   misimages.add(ss);
	}
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	function checkform(F) {
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
            			<td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48"></td>
            			<td align="left" valign="middle" class="web_bigword"><%=show_title %></td>
          			</tr>
          			
          			<tr>
            			<td colspan="2"><hr size="1" noshade></td>
          			</tr>
					
					<tr>
						<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
				  				<tr>
		    	    				<td align="center" colspan="4" class="web_title-1">
		    		  					<span><%=show_title %></span>&nbsp;&nbsp;
					  					<span><input type="button" value="詢價單列表" onclick="javascript:location.href='<%=code %>.jsp'" /></span>&nbsp;
					  					<span><input type="button" value="設定詢價單信件收件者" onclick="javascript:location.href='<%=code %>_pop.jsp'" /></span>
				    				</td>
			       				</tr>         
<form name="frm1" id="frm1" method="post" action="<%=code %>_update.jsp?action=POP3&code=<%=code %>">
					  			<tr align="center" class="web_bk-2">
					    			<td colspan="4" align="center">收件者設定</td>
					  			</tr>
					  			
					  			<tr class="web_table-2-1">
					  				<td width="10%" align="center">
										正本
					  				</td>
					 				<td align="center">
										<textarea name="original" id="original" cols="70%" rows="2"><%=SiteSetup.getValue("original."+code+"."+lang) %></textarea>
									</td>
					  			</tr>
					  			
					  			<%--
					  			<tr class="web_table-2-1">
									<td align="center">
										副本
									</td>
									<td align="center"><textarea name="duplicate" id="duplicate" cols="70%" rows="2"><%=SiteSetup.getValue("duplicate."+code+"."+lang) %></textarea></td>
					  			</tr>
					  			--%>
					  			
					  			<tr class="web_table-2-1">
					  				<td colspan="4" align="center" ><B>請以逗號 『 , 』作收件人區分設定 : 例:123@gmail.com , abc@gmail.com</B></td>
					  			</tr>
					  			
					  			<tr class="web_bk-2">
					  				<td colspan="4" align="center" ><input type="submit" value="確定送出" /></td>
					  			</tr>
</form>
							</table></td>
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