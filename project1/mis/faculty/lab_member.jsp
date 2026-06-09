<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 上層基本參數
	String fp_id  = StringTool.validString(request.getParameter("fp_id"));// 所屬上層資料代號
	String back_code = "faculty"; // 上層模組識別碼
	
	// 基本參數
	String code = "lab_member"; 		// 模組識別碼
	TableRecord fp = app_sm.select(tblfp,fp_id);  // 所屬類別資料
	String show_title = fp.getString("fp_title")+"-實驗室成員";			// 模組標題
	
	// 相關模組識別碼
	String[] related_codes = new String[]{"education","experience","representative","plan","lab_member" ,"lab_activity"};
	String[] related_titles = new String[]{"學歷","經歷","代表著作","五年內執行計畫","實驗室成員" ,"實驗室活動"};

	// 圖片建議尺寸
	String image_info = "(建議尺寸264px * 220px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能	
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;				// 設定少於幾筆不可刪除 , -1 為無限制
	int level_number =2;			// 類別層數
/*-----------------------------------------------------------------------------------------*/	
	Vector frs = app_sm.selectAll(tblfr, "fr_code=? and fr_lang=? and fp_id=?", new Object[] { code, lang , fp_id }, "fr_showseq ASC , fr_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,frs);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num,frs);

	// 跳頁參數
	String[] names = new String[] { "npage", "fp_id"};
	String[] values = new String[] { String.valueOf(pageno), fp_id};
	
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	// 回排序頁
	out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
	// 新增頁
	out.write(HtmlCoder.getForm("addpage", code + "_a.jsp", names, values));

%>
<!DOCTYPE html>
<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<script>
function goaction(F,JSP){
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if (F.fr_department.value == ""){
	   	alert("請輸入班級組別!!");
	   	F.fr_department.focus();
   }else if (F.fr_title.value == "") {
		alert("請輸入姓名");
		F.fr_title.focus();
	   	<%--
   }else if (F.fr_image.value == "" && !file_chk.test(F.fr_image.value.toLowerCase()) && F.name=="formA") {
		alert("請上傳圖檔，附檔名限為jpg|jpeg|gif|png|webp!!");
		F.fr_image.focus();
	}else if (F.fr_image.value != "" && !file_chk.test(F.fr_image.value.toLowerCase())) {
		alert("附檔名限為jpg|jpeg|gif|png|webp!!");
		F.fr_image.focus();
	<% } %>
		--%>
	}else{
		F.action = JSP;
		F.submit();
	}
    
}
function godelete(FORM,JSP){
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
		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><!-- InstanceBeginEditable name="system-page" -->
		<table width="95%" border="0" cellspacing="0" cellpadding="0">
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
				<td width="60" align="left" valign="middle">
					<img src="../images/web_icon_1.gif" width="55" height="48" />
				</td>
				<td align="left" valign="middle" class="web_bigword">
					<%=show_title%>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr align="center">
				<td colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3"
							cellspacing="1">
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
									<input type="button" value="回到實驗室成員列表" onclick="listpage.submit();" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="實驗室成員排序" onclick="sortpage.submit();" />
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
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center" class="tablebg"><%= show_title%>列表</td>
							</tr>
							<tr align="center" class="web_table-2-1">
								<td width="10%" align="center">編號</td>
								<td width="30%" align="center">班級組別</td>
								<td width="40%" align="center">姓名</td>
								<td width="20%" align="center">功能</td>
							</tr>
							<%if (add_switch) { %>
							<form name="formA" method="post" enctype="multipart/form-data">
							<tr class="web_table-2-1">
								<td align="center"></td>
								<td align="left">
								<div align="center">
									<input name="fr_department" type="text" value="" size="30" maxlength="120"/>
									<input name="fp_id" type="hidden" value="<%=fp_id%>" />
								</div>
								</td>
								
								<td align="left">
								<div align="center">
									<input name="fr_title" type="text" value="" size="50" maxlength="120"/>
								</div>
								</td>
								
			
								<td align="left">
								<div align="center">
									<input name="add" type="button" value="新增" onClick="goaction(this.form, '<%=code%>_update.jsp?action=A&fp_id=<%=fp_id%>');">
								</div>
								</td>
							</tr>
							</form>
							<%} %>
							<%
								for (int i = 0; i < frs.size(); i++) {
									TableRecord fr = (TableRecord) frs.get(i);
							%>
							<form name="form<%=i + 1%>" method="post" enctype="multipart/form-data">
								<tr class="web_table-2-1">
									<td align="center"><%=i + 1%></td>
									<td align="left">
										<div align="center">
											<input name="fr_department" type="text" value="<%=fr.getString("fr_department")%>" size="30" maxlength="120"/>
											<input name="fp_id" type="hidden" value="<%=fp_id%>"/>
										</div>
									</td>
									
									<td align="left">
										<div align="center">
											<input name="fr_title" type="text" value="<%=fr.getString("fr_title")%>" size="50" maxlength="120"/>
										</div>
									</td>
		           
									<td align="left">
										<div align="center">
										
										<%if (modify_switch) { %>
											<input name="modify<%=i + 1%>" type="button" value="修改" onClick="goaction(this.form, '<%=code%>_update.jsp?action=M&fr_id=<%=fr.getString("fr_id")%>&fp_id=<%=fp_id%>');">
										<%} %>
										<%if (delete_switch) { %>
											<input name="modify<%=i + 1%>" type="button" value="刪除" onClick="godelete(this.form, '<%=code%>_update.jsp?action=D&fr_id=<%=fr.getString("fr_id")%>&fp_id=<%=fp_id%>');">
										<%} %>
										</div>
									</td>
								</tr>
							</form>
							<%} %>
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" class="web_bk-2b">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>