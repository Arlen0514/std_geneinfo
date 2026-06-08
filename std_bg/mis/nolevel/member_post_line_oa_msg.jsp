<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code 		= "member";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "發送LINE OA ";		// 功能標題

	// Conditions.
    String qcellphone = StringTool.validString(request.getParameter("_qcellphone"));
    String qaccount = StringTool.validString(request.getParameter("_qaccount"));
    String qname = StringTool.validString(request.getParameter("_qname"));

	// Names and values.
	String[] names = new String[] { "npage", "_qname", "_qcellphone", "_qaccount" };
	String[] values = new String[] { String.valueOf(pageno), qname, qcellphone, qaccount };

   	String mp_id = StringTool.validString(request.getParameter("mp_id"));
   	TableRecord mp = app_sm.select(tblmp, mp_id);
   	
   	//  沒串 OA 的不能進來 
   	if("".equals(mp.getString("mp_command"))){
   		out.println("<script> alert('此帳號尚未串接LINE OA');  history.back(); </script>");
   		return;
   	}
   	
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	function post_line_oa() {
		var url = "../../web/bot/line_bot_post.jsp";
		$.post(url, {
			async: false,
			mp_id: '<%=mp.getString("mp_id") %>',
			msg : $("#msg").val()
			},function(data) {
				var jsonObj = JSON.parse(data);  							// 將JSON格式資料轉為物件
				if(jsonObj.status == "Y"){
					alert(jsonObj.msg);
				}else {
					alert(jsonObj.msg);
				}
				
		});		
	}
</script>
</head>
<body style="background-color: rgb(255, 255, 255);">
<div align="center">
  	<table width="1280" border="0" cellpadding="0" cellspacing="0">
    	<tr>
      		<td colspan="2"><table width="1280" border="0" cellspacing="0" cellpadding="0">        
				<%@include file="/WEB-INF/jspf/mis/top.jspf"%>
      		</table></td>
    	</tr>
    	<tr>
      		<td width="1%" align="center" valign="top" class="web_bk-2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
        		<tr>
          			<td><IFRAME HEIGHT="800" width="180" MARGINWIDTH="0" MARGINHEIGHT="0" HSPACE="0" VSPACE="0" FRAMEBORDER="0" SCROLLING="no" id="show" name="show" SRC="../leftmenu.jsp"></IFRAME></td>
        		</tr>
      		</table></td>
      		<td width="1125" align="center" valign="top" class="system_bk-2p"><table width="95%" border="0" cellspacing="0" cellpadding="0">
          		<tr>
            		<td colspan="2">&nbsp;</td>
          		</tr>
          		<tr>
            		<td colspan="2" class="web_bk-2b">&nbsp;</td>
          		</tr>
          		<tr>
            		<td colspan="2">&nbsp;</td>
          		</tr>
          		<tr>
            		<td width="8%" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48" /></td>
            		<td width="92%" align="left" valign="middle" class="web_bigword">會員資料</td>
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
                      				<td colspan="4">發送訊息</td>
                    			</tr>


                    			<tr align="center">
                      				<td class="web_table-2-1">發送訊息</td>
                      				<td colspan="3" class="web_table-2-1" align="left">
                      					<textarea name="msg" id="msg" cols="118" rows="8" class="mceEditor"></textarea>
                        				
                      				</td>
                    			</tr>


                			</table></td>
              			</tr>
            		</table>
            		<br />
            		
            		<input type="button" value="發送訊息" onclick="post_line_oa();">&nbsp;
            		
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
<%=HtmlCoder.getForm("lastpage", request.getHeader("referer"), names, values)%>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>