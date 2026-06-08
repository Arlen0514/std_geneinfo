<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code 		= "member";			// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "會員資料維護";		// 功能標題
	int page_items		= 15;				// 列表分頁筆數設定

   	// Conditions.
   	String qcellphone = StringTool.validString(request.getParameter("_qcellphone"));
   	String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   	String qname = StringTool.validString(request.getParameter("_qname"));

	// Names and values.
   	String[] names = new String[] { "npage", "_qname", "_qcellphone", "_qaccount" };
   	String[] values = new String[] { String.valueOf(pageno), qname, qcellphone, qaccount };

   	// Get records.
   	StringBuffer sb = new StringBuffer();
   	Vector keys = new Vector();

   	sb.append("mp_cellphone like? and mp_account like? and mp_name like?");
   	keys.add("%"+qcellphone+"%");
   	keys.add("%"+qaccount+"%");
   	keys.add("%"+qname+"%");
   	Vector mps = app_sm.selectAll(tblmp, sb.toString(), keys.toArray()," mp_createdate DESC");

   	// Data paging.
   	app_dp = new DataPager(mps,page_items); 			// 查詢列表筆數
   	mps = app_dp.getPageContent(pageno);
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	var org_action_url = "";
	
	function checkform(F) {
		return true;
	}
	function clearData(F) {
		$("#_qname").val("");
		$("#_qaccount").val("");
		$("#_qcellphone").val("");
	}
	<%-- 會員資料Excel匯出 --%>
	var timer = "";
	// 啟動檔案匯出功能
	function export_file() {
		// var theForm = document.frm1;
		var theForm = document.form0;
		timer = window.setTimeout("exportProgress()", 1500);
		$(".block").show();
		
		org_action_url = theForm.action;
		// 查詢資料送出
		theForm.action="export/member_export.jsp";
		theForm.target="_exportFrame";
		theForm.submit();
	}
	// 檢查檔案是否已經匯出完成
	function exportProgress() {
		var theForm = document.form0;
		$.ajax({
			async: false,
			type: "GET",
			url: "export/exportcheck.jsp",
			data: { reportType:"member_export" },
			success: function(res) {
				res = $.trim(res);

				if(res == "start") {
					$(".block").show();
				} else if((res == "end") || (res == "no")) {
					$(".block").hide();
					clearProgress();
					if(res == "end") {
						 window.open("export/download.jsp?file=<%=app_account %>_member_export.xlsx", "查詢匯出" );
					} else {
						//history.back();
					}
				} else if(res == null || res == "null" || res == "error") {
					alert("匯出失敗 !!");
					$(".block").hide();
					clearProgress();
				}
				window.setTimeout("exportProgress()", 1500);
			},
			error: function(res) {
				res = $.trim(res);
			}
		});
		
		// 將form 的 action 改回原本網址
		theForm.action = org_action_url;
		theForm.target = "_self";
	}
	// 清除檔案匯出完成後之 Session 值
	function clearProgress() {
		$.ajax({
			async:false,
			type:"GET",
			url: "export/exportcheck.jsp",
			data: { reportType:"clear_member_export" },
			success: function(res) {
				clearTimeout(timer);
			}
		});
	}
</script>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<%-- 黑色遮蔽 --%>
<div class="block" style="width:100%; height:100%; position:fixed; color:#fff; display:none;">
	<img src="export/images/block_bg.png" width="100%" height="100%" style="position:fixed; z-index:99998;" />
	<div style="margin: 0 auto;width: 400px;height: 50px;position: relative;top: 50%; z-index:99999; text-align:center;">
		資料匯出準備中，請稍待片刻 ......
	</div>
</div>

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
                      				<td colspan="4">會員資料－查詢</td>
                    			</tr>
                   				<tr align="center" class="web_table-2-1">
                        			<td width="25%">會員帳號</td>
                        			<td width="25%">真實姓名</td>
                        			<td width="25%">行動電話</td>
                        			<td width="25%">&nbsp;</td>
                    			</tr>
<form name="form0" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">
                    			<tr class="web_table-2-1">
                      				<td align="center"><input name="_qaccount" id="_qaccount" value="<%=qaccount %>" type="text" size="27" /></td>
                      				<td align="center"><input name="_qname" id="_qname" value="<%=qname %>" type="text" size="27" /></td>
                      				<td align="center"><input name="_qcellphone" id="_qcellphone" value="<%=qcellphone %>" type="text" size="27" /></td>
                      				<td align="center" class="tablebg">
                        				<input name="query" type="submit" value="查詢">&nbsp;
            							<input type="button" value="清除" onclick="clearData(this.form);" />
            							<br /><br />
            							<input type="button" value="查詢資料匯出" onclick="export_file();" />
            						</td>
                    			</tr>
</form>
	                    		<tr align="center" class="web_bk-2">
	                      			<td colspan="4">會員資料－查詢列表</td>
	                    		</tr>
	                    		<tr align="center" class="web_table-2-1">
	                        		<td>會員帳號</td>
	                        		<td>真實姓名</td>
	                        		<td>行動電話</td>
	                        		<td>&nbsp;</td>
	                    		</tr>
								<%   
	   							for(int i = 0; i < mps.size(); i++) {
	       							TableRecord mp = (TableRecord)mps.get(i);
								%>
<form name="form<%=i+1%>" method="post">
	                    		<tr class="web_table-2-1">
	                      			<td align="center"><%=mp.getString("mp_account")%></td>
	                      			<td align="center"><%=mp.getString("mp_name")%></td>
	                      			<td align="center"><%=mp.getString("mp_cellphone")%></td>
	                      			<td align="center">
										<%=HtmlCoder.hiddenInputs(names, values) %>
										<input type="hidden" name="mp_id" value="<%=mp.getString("mp_id")%>" />
	                        			<input name="detail<%=i+1%>" type="button" value="查閱" onClick="goaction(this.form, '<%=code %>_b2.jsp');">
	                        			<input name="modify<%=i+1%>" type="button" value="修改" onClick="goaction(this.form, '<%=code %>_c.jsp');">
	                        			<input name="stop<%=i+1%>" type="button" value="<%="Y".equals(mp.getString("mp_status"))?"停權":"恢復"%>" onClick="goaction(this.form, '<%=code %>_update.jsp?action=stop');">
	                        			&nbsp;&nbsp;&nbsp;&nbsp;<input name="delete<%=i+1%>" type="button" value="刪除" onClick="godelete(this.form, '<%=code %>_update.jsp?action=D');">
	                      			</td>
	                    		</tr>
</form>
								<%} %>
	                		</table></td>
	              		</tr>
            		</table>
					<%@include file="/WEB-INF/jspf/mis/pager.jspf" %>
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
<iframe name="_exportFrame" width="0" height="0" style="display:none"></iframe>
<form name="frm1" id="frm1" method="post"  >
	<input type="hidden" name="_qname" value="<%=qname %>" />
	<input type="hidden" name="_qaccount" value="<%=qaccount %>" />
	<input type="hidden" name="_qcellphone"   value="<%=qcellphone %>" />
</form>
<%=HtmlCoder.getForm("pageform", request.getRequestURI(), names, values) %>
</body>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>