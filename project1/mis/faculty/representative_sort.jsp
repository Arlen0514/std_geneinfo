<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//上層基本參數
	String fp_id  = StringTool.validString(request.getParameter("fp_id"));	// 所屬上層資料代號
	String back_code = "faculty"; 											// 上層模組識別碼

	// 基本參數
	String code = "representative"; 										// 模組識別碼
	TableRecord fp = app_sm.select(tblfp,fp_id);  							// 所屬類別資料
	String show_title = fp.getString("fp_title")+"-代表著作";					// 模組標題
	
	// 相關模組識別碼
	String[] related_codes = new String[]{"education","experience","representative","plan","lab_member" ,"lab_activity"};
	String[] related_titles = new String[]{"學歷","經歷","代表著作","五年內執行計畫","實驗室成員" ,"實驗室活動"};
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
/*--------------------------------------------------------------------------------*/		
	Vector frs = app_sm.selectAll(tblfr, "fr_code=? and fr_lang=? and fp_id=?", new Object[] { code, lang , fp_id }, "fr_showseq ASC , fr_createdate DESC");
	
	// 跳頁參數
	String[] names = new String[] { "npage","fp_id" };
	String[] values = new String[] { String.valueOf(pageno), fp_id};

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	// 回排序頁
	out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
	// 新增頁
	out.write(HtmlCoder.getForm("addpage", code + "_a.jsp", names, values));
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<script type="text/JavaScript">
$(document).ready(function() {
	$("#select_down").click(function() {
		var $op = $('#left_select option:selected'), $this = $(this);
		if ($op.length) {
			($this.val() == 'Up') ? $op.first().prev().before($op) : $op.last().next().after($op);
		}
	});
	$("#select_up").click(function() {
		var $op = $('#left_select option:selected'), $this = $(this);
		if ($op.length) {
			($this.val() == 'Down') ? $op.last().next().after($op) : $op.first().prev().before($op);
		}
	});
	$("#all_down").click(function(){
	    var $op = $('#left_select option:selected');
	    if($op.length){
	    	$('#left_select option:selected').prependTo('#left_select')
	    }
	});
	$("#all_up").click(function(){
	    var $op = $('#left_select option:selected');
	    if($op.length){
	    	$('#left_select option:selected').appendTo('#left_select')
	    }
	});
});
function checkformsequ(F) {
	var varStr = "";
	$("#left_select option").each( function() {
		// add $(this).val() to your list
			varStr += $(this).val() + ",";
			//alert(  $(this).val());
		});
	//alert(varStr);
	$("#selData").val(varStr);
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
				<td width="60" align="left" valign="middle"><img
					src="../images/web_icon_1.gif" width="55" height="48"></td>
				<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>

			<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=S&fp_id=<%=fp_id %>" onsubmit="javascript:return checkformsequ(this);">
			<td align="center" colspan="2">
			<table width="95%" border="0" cellspacing="1" cellpadding="0">
				<td class="system_bk-2bk">
				<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
					<tr align="center">
						<td class="web_title-1">
							<input type="button" value="回到師資列表" onclick="javascript:location.href='<%=back_code%>.jsp'" />
						</td>
						<td colspan="2" class="web_title-1">
							<%-- 
							<%if (add_switch) { %>
							<input type="button" value="新增資料" onclick="addpage.submit();" />&nbsp;
							<%} %>
							--%>
							<%if (list_switch) { %>
							<input type="button" value="回到代表著作列表" onclick="listpage.submit();" />&nbsp;
							<%} %>
							<%if (sort_switch) { %>
							<input type="button" value="代表著作排序" onclick="sortpage.submit();" />
							<%} %>
						</td>
						<td class="web_title-1">
							<select name="change_page" onchange="listpage.action=this.value;listpage.submit()">
								<% for(int i=0;i<related_codes.length;i++){ %>
								<option value="<%=related_codes[i]%>.jsp" <%=code.equals(related_codes[i])?"selected":"" %>><%=related_titles[i]%></option>
								<% } %>
							</select>
						</td>
					</tr>
				</table>
				
				<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
					<tr align="center" class="web_bk-2">
						<td colspan="4" align="center"><%=show_title%>順序調整</td>
					</tr>
					<tr class="web_table-2-1">
						<td width="85%" align="center"><%=show_title%>列表</td>
						<td width="15%" align="center" colspan="3">功能</td>
					</tr>
					<tr class="web_table-2-1">
						<td class="web_table-2-1" align="left">
							<select name="left_select" id="left_select" multiple="multiple" style="width: 660px;" size="15">
								<%
									for (int i = 0; i < frs.size(); i++) {
										TableRecord fr = (TableRecord) frs.get(i);
								%>
								<option value="<%=fr.getString("fr_id")%>"><%=fr.getString("fr_title")%></option>
								<%
									}
								%>
							</select>
						</td>
						<td class="web_table-2-1" align="center" colspan="3">
							<input type="hidden" name="selData" id="selData" value="">
							<input type="button" id="select_up" value="↑↑上移↑↑" /><br /><br />
							<input type="button" id="select_down" value="↓↓下移↓↓" /><br /><br />
							<input type="button" id="all_down" value="至頂" /><br /><br />
							<input type="button" id="all_up" value="至底" /><br /><br />
							<input type="submit" value="儲存設定">
						</td>
					</tr>
				</table>
				</td>
			</table>
			</td>

			</form>

			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="web_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</div>
		</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>