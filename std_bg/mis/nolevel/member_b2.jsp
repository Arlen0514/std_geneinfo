<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code 		= "member";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "會員資料維護";		// 功能標題

	// Conditions.
    String qcellphone = StringTool.validString(request.getParameter("_qcellphone"));
    String qaccount = StringTool.validString(request.getParameter("_qaccount"));
    String qname = StringTool.validString(request.getParameter("_qname"));
	
	// Names and values.
	String[] names = new String[] { "npage", "_qname", "_qcellphone", "_qaccount" };
	String[] values = new String[] { String.valueOf(pageno), qname, qcellphone, qaccount };

   String mpid = StringTool.validString(request.getParameter("mp_id"));
   TableRecord mp = app_sm.select(tblmp, mpid);
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	/*-- --*/
</script>
<style type="text/css">
	.style1 {
		color: #FF0000
	}
</style>
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
            		<td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48" /></td>
            		<td align="left" valign="middle" class="web_bigword"><%=show_title %></td>
          		</tr>
          		<tr>
            		<td colspan="2"><hr size="1" noshade></td>
          		</tr>
          		<tr align="center">
            		<td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
              			<tr>
                			<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    			<tr align="center">
                      				<td colspan="4" class="web_title-1"> 會員資料&nbsp;
                      					<span>
				                        	<input name="" type="button" value="會員資料新增" onClick="location='<%=code %>_a.jsp'" />
                      					</span>&nbsp;
                        				<span>
                        					<input name="" type="button" value="會員資料查詢" onClick="location='<%=code %>.jsp'" />
                        				</span>
                      				</td>
                    			</tr>

                    			<tr align="center" class="web_bk-2">
                      				<td colspan="4">會員資料檢視</td>
                    			</tr>

                    			<tr align="center">
									<td width="120" class="web_table-2-1" align="right">會員帳號</td>
                      				<td width="200" class="web_table-2-1" align="left"><%=mp.getString("mp_account")%></td>
                      				<td width="120" class="web_table-2-1" align="right">會員姓名</td>
                      				<td width="200" class="web_table-2-1" align="left"><%=mp.getString("mp_name")%></td>
                    			</tr>

                    			<tr align="center">
                      				<td class="web_table-2-1" align="right">連絡電話</td>
                      				<td class="web_table-2-1" align="left"><%=mp.getString("mp_phone")%></td>
                      				<td class="web_table-2-1" align="right">行動電話</td>
                      				<td class="web_table-2-1" align="left"><%=mp.getString("mp_cellphone")%></td>
                    			</tr>

                    			<tr align="center">
                      				<td class="web_table-2-1" align="right">通訊地址</td>
                      				<td colspan="3" class="web_table-2-1" align="left"><%=mp.getString("mp_county")+mp.getString("mp_zipcode")+mp.getString("mp_city")+mp.getString("mp_address")%></td>
                    			</tr>

                    			<tr align="center">
                      				<td class="web_table-2-1" align="right">最後修改人員</td>
                      				<td class="web_table-2-1" align="left"><%=mp.getString("mp_modifyuser")%></td>
                      				<td class="web_table-2-1" align="right">最後修改日期</td>
                      				<td class="web_table-2-1" align="left"><%=mp.getString("mp_modifydate")%></td>
                    			</tr>
                			</table></td>
              			</tr>
            		</table>
            		<br />

            		<input name="previous" type="button" value="回上一頁" onClick="lastpage.submit();">
            		
            		</td>
          		</tr>
          		<tr>
            		<td colspan="2">&nbsp;</td>
          		</tr>
          		<tr>
            		<td colspan="2" class="web_bk-2b">&nbsp;</td>
          		</tr>
        	</table></td>
    	</tr>
  	</table>
</div>
<%=HtmlCoder.form("lastpage", code + ".jsp", names, values)%>
</body>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>