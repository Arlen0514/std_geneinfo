<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "pdf_to_image"; 			// 模組識別碼
	String upload_code = "image"; 		// 上傳資料夾識別碼
	String show_title = "PDF轉圖片維護"; 		// 模組標題

	// 功能參數
	boolean single = true;	   		// 單網編/單一修改畫面模組 true=關閉列表+ 排序+ 新增功能
	boolean list_switch = false;	// 是否開啟列表功能
	boolean sort_switch = false;	// 是否開啟排序功能
	boolean keyword_switch = false;	// 是否開啟關鍵字設定
	boolean deadline_switch = false;// 是否開啟上下架日期	
	int add_num = 0;				// 設定可新增的資料筆數 , -1 為無限筆
/*--------------------------------------------------------------------------------------*/		
	Vector cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[] { code, lang }, "cp_showseq ASC , cp_createdate DESC");	
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num, cps);

	// 修改資料ID
	String cp_id = StringTool.validString(request.getParameter("cp_id"));
	TableRecord cp = app_sm.select(tblcp, cp_id);

	if(single){
		list_switch = false;
		sort_switch = false;
		add_switch = false;
		add_num = 1;
		
		// 單網編 直接抓功能代號
		cp = app_sm.select(tblcp, "cp_code=? and cp_lang=?",new Object[]{code,lang});
		// 設定預設值(單網編模組 直接顯示修改畫面)
		if (cp.getString("cp_id").equals("")) {
			cp = new TableRecord(tblcp);
			cp.setValue("cp_title", show_title);   
			cp.setValue("cp_code", code);	// 識別碼
			cp.setValue("cp_lang", lang);	// 語系
			cp.setInsert(app_account); 
			app_sm.insert(cp);
		}
		cp_id = cp.getString("cp_id");
	}
	
	String[] imageTok = cp.getString("cp_image").split(",");    //圖檔名稱
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F){
		//驗證副檔名
		// var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
		// var image = document.getElementById('cp_image').files[0];
		
	    if(F.cp_file.cp_file.value !="" && !F.cp_file.value.toLowerCase().endsWith(".pdf")){
	    	alert("附檔名限為pdf!!");
	        F.cp_file.focus();
		} else {
	        return true;
	    }
		return false;
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
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>
					<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&cp_id=<%=cp_id%>" onsubmit="javascript:return checkform(this);">
						<table width="99%" border="0" cellspacing="0" cellpadding="0">
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
								<td align="left" valign="middle" class="web_bigword"><%=show_title%>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<hr size="1" noshade />
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
															<%
																if (add_switch) {
															%>
															<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />
															&nbsp;
															<%
																}
															%>
															<%
																if (list_switch) {
															%>
															<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />
															&nbsp;
															<%
																}
															%>
															<%
																if (sort_switch) {
															%>
															<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
															<%
																}
															%>
														</td>
													</tr>
													<tr align="center" class="web_bk-2">
														<td colspan="4" align="center">修改資訊</td>
													</tr>
													
													<tr class="web_table-2-1">
														<td width="15%" align="right">圖片副檔名</td>
														<td align="left" class="tablebg">		
															<input name="imgext" type="radio" value="jpg" checked/>JPG &nbsp;
															<input name="imgext" type="radio" value="png" />PNG
														</td>
								                    </tr>

													<tr class="web_table-2-1">
														<td rowspan="2" align="right" class="web_table-2-1">PDF文件</td>
														<td colspan="3" align="left" class="tablebg">&nbsp;		
														<%if(!"".equals(cp.getString("cp_file"))) { %>					 
															<%=cp.getString("cp_file") %>
														<%} %>
														</td>
								                    </tr>
								                    <tr class="web_table-2-1">
														<td colspan="3" align="left" class="tablebg">
															<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.cp_file.value='';" />使用原檔<br />
															<input name="imgradio" type="radio" value="new" />上傳新檔
															<input name="cp_file" id="cp_file" type="file" class="button" accept=".pdf" onclick="frm.imgradio[1].checked=true;" /> <%--=image_info--%>
														</td>
								                    </tr>
								                    
								                    <tr class="web_table-2-1">
														<td width="15%" align="right">圖檔下載</td>
														<td colspan="3" width="85%" align="left">
														<%
														if(!"".equals(cp.getString("cp_image"))) {
															for(int l = 0; l < imageTok.length; l++) {
														%>
															&nbsp;&nbsp;
															<a href="<%=app_fetchpath+"/"+upload_code+"/"+lang+"/"+imageTok[l] %>" download><%=imageTok[l] %></a>
															<br />
														<%
															}
														} else {
														%>
															請上傳PDF文件!!
														<%} %>
														</td>
													</tr>

												</table>
											</td>
										</tr>
										<tr align="center">
											<td colspan="4" align="center">
												<br />
												<input type="submit" value="確定送出" />
												&nbsp;
												<input type="reset" value="重新設定" />
												&nbsp;
												<input type="button" value="回上一頁" onclick="javascript:history.back();" />
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
					</form>
				</td>
			</tr>
		</table>
	</div>
	</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>