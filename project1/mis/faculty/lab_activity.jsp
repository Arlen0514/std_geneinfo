<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 上層基本參數
	String fp_id  = StringTool.validString(request.getParameter("fp_id"));// 所屬上層資料代號
	String back_code = "faculty"; // 上層模組識別碼
	
	// 基本參數
	String code = "lab_activity"; 							// 模組識別碼
	String upload_code = "lab_activity"; 					// 上傳資料夾識別碼
	TableRecord fp = app_sm.select(tblfp,fp_id);  			// 所屬類別資料
	String show_title = fp.getString("fp_title")+"-實驗室活動";// 模組標題
	
	// 相關模組識別碼
	String[] related_codes = new String[]{"education","experience","representative","plan","lab_member" ,"lab_activity"};
	String[] related_titles = new String[]{"學歷","經歷","代表著作","五年內執行計畫","實驗室成員" ,"實驗室活動"};
	

	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean keyword_switch = false;	// 是否開啟關鍵字設定
	boolean deadline_switch = false;// 是否開啟上下架日期
	boolean single = true;	        // 單網編/單一修改畫面模組 true=關閉列表+ 排序+ 新增功能	
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
/*--------------------------------------------------------------------------------------*/		
	Vector frs = app_sm.selectAll(tblfr, "fr_code=? and fr_lang=? and fp_id=?", new Object[] { code, lang , fp_id }, "fr_showseq ASC , fr_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,frs);

	// 修改資料ID
	String fr_id = StringTool.validString(request.getParameter("fr_id"));
	TableRecord fr = app_sm.select(tblfr, fr_id);

	if(single){
		list_switch = false;
		sort_switch = false;
		add_switch = false;
		add_num = 1;
		
		// 單網編 直接抓功能代號
		fr = app_sm.select(tblfr, "fr_code=? and fr_lang=? and fp_id=?",new Object[]{code,lang,fp_id});
		// 設定預設值(單網編模組 直接顯示修改畫面)
		if (fr.getString("fr_id").equals("")) {
			fr = new TableRecord(tblfr);
			fr.setValue("fr_title", show_title);
			/*
			fr.setValue("fr_robots", SiteSetup.getSetup("seo.robots"+"."+lang).getString("ss_text"));
			fr.setValue("fr_revisit_after", SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text"));
			fr.setValue("fr_keywords", SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text"));
			fr.setValue("fr_copyright", SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text"));
			fr.setValue("fr_description", SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text"));
			fr.setValue("fr_seo_track", SiteSetup.getSetup("seo.track"+"."+lang).getString("ss_text"));		   
			*/
			fr.setValue("fp_id", fp_id);
			fr.setValue("fr_code", code);	// 識別碼
			fr.setValue("fr_lang", lang);	// 語系
			fr.setInsert(app_account); 
			app_sm.insert(fr);
		}
		fr_id = fr.getString("fr_id");
	}
	
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

<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
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
					<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&fr_id=<%=fr_id%>&fp_id=<%=fp_id%>">
					<table width="99%" border="0" cellspacing="0" cellpadding="0">
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
									<img src="../images/web_icon_1.gif" width="55" height="48">
								</td>
								<td align="left" valign="middle" class="web_bigword"><%=show_title%>
								</td>
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
															<select  onchange="listpage.action=this.value;listpage.submit()">
																<% for(int i=0;i<related_codes.length;i++){ %>
																<option value="<%=related_codes[i]%>.jsp" <%=code.equals(related_codes[i])?"selected":"" %>><%=related_titles[i]%></option>
																<% } %>
															</select>
														</td>
													</tr>
													<%-- 
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
													--%>
													<tr align="center" class="web_bk-2">
														<td colspan="4" align="center">修改資訊</td>
													</tr>
													
													<tr class="web_table-2-1">
														<td width="15%" align="right">標題</td>
														<td colspan="3" width="85%" align="left">
															<%=fr.getString("fr_title")%>
															<%--
															<input type="text" name="fr_title" id="fr_title" size="100" maxlength="120" value="<%=fr.getString("fr_title")%>"/>
															 --%>
														</td>
													</tr>
													<%--
													<tr class="web_table-2-1">
														<td align="right">顯示設定</td>
														<td colspan="3" align="left">
															<input type="radio" name="fr_display" value="Y" <%=fr.getString("fr_display").equals("Y") ? "checked" : ""%> />
															&nbsp;顯示
															<input type="radio" name="fr_display" value="N" <%=fr.getString("fr_display").equals("N") ? "checked" : ""%> />
															&nbsp;隱藏
														</td>
													</tr>
													
													<tr class="web_table-2-1">
														<td align="right">連結提示</td>
														<td colspan="3" align="left">
															<input type="text" name="fr_alt" id="fr_alt" size="100" maxlength="120" required value="<%=fr.getString("fr_alt")%>"/>
														</td>
													</tr>
													--%>
													<tr class="web_table-2-1">
														<td align="right">內文</td>
														<td colspan="3" align="left">
															<textarea name="fr_content" id="fr_content" cols="100" rows="8" class="mceEditor"><%=fr.getString("fr_content")%></textarea>
														</td>
													</tr>
													
													<% if (keyword_switch) { %>
													<tr align="center" class="web_table-2-1">
														<td colspan="4" align="center">關鍵字設定</td>
													</tr>
													<tr class="web_table-2-1">
														<td width="15%" align="right">設定索引[Robots]</td>
														<td width="35%" align="left">
															<select name="fr_robots" id="fr_robots">
																<option value="all" <%="all".equals(fr.getString("fr_robots")) ? "selected" : ""%>>全部-ALL</option>
																<option value="none" <%="none".equals(fr.getString("fr_robots")) ? "selected" : ""%>>無索引-None</option>
																<option value="index" <%="index".equals(fr.getString("fr_robots")) ? "selected" : ""%>>索引該網頁-Index</option>
																<option value="noindex" <%="noindex".equals(fr.getString("fr_robots")) ? "selected" : ""%>>不索引該網頁-NoIndex</option>
																<option value="follow" <%="follow".equals(fr.getString("fr_robots")) ? "selected" : ""%>>關注特定連結-Follow</option>
																<option value="nofollow" <%="nofollow".equals(fr.getString("fr_robots")) ? "selected" : ""%>>不關注特定連結-NoFollow</option>
															</select>
														</td>
														<td width="15%" align="right">設定來訪週期</td>
														<td width="35%" align="left">
															<input type="text" name="fr_revisit_after" id="fr_revisit_after" value="<%=fr.getString("fr_revisit_after")%>" size="4" maxlength="4" />
															天
														</td>
													</tr>
													<tr class="web_table-2-1">
														<td align="right">設定主要關鍵字</td>
														<td align="left">
															<input type="text" name="fr_keywords" id="fr_keywords" size="40" maxlength="255" value="<%=fr.getString("fr_keywords")%>" />
														</td>
														<td align="right">設定網頁版權說明</td>
														<td align="left">
															<input type="text" name="fr_copyright" id="fr_copyright" size="30" value="<%=fr.getString("fr_copyright")%>" />
														</td>
													</tr>
													<tr class="web_table-2-1">
														<td align="right">
															網頁內容簡介
															<br />
															[建議80-100字]
														</td>
														<td colspan="3" align="left">
															<textarea name="fr_description" id="fr_description" cols="100" rows="3" maxlength="255"><%=fr.getString("fr_description")%></textarea>
														</td>
													</tr>
													<tr class="web_table-2-1">
														<td align="right">設定追蹤碼</td>
														<td colspan="3" align="left">
															<textarea name="fr_seo_track" id="fr_seo_track" cols="100" rows="3"><%=fr.getString("fr_seo_track")%></textarea>
														</td>
													</tr>
													<% } %>
													
													<% if(deadline_switch){ %>
													<tr align="center" class="web_bk-2">
														<td colspan="4" align="center">上下架時間</td>
													</tr>
													<tr class="web_table-2-1">
														<td align="right" class="web_table-2-1">上架日期</td>
														<td align="left" class="tablebg">
															<input name="fr_emitdate" id="_qemitdate" type="text" value="<%=fr.getString("fr_emitdate") %>" size="15" readonly>
														</td>
														<td align="right" class="tablebg">下架日期</td>
														<td align="left" class="tablebg">
															<input name="fr_restdate" id="_qrestdate" type="text" value="<%=fr.getString("fr_restdate") %>" size="15" readonly>
														</td>
													</tr>
													<% } %>
													<tr class="web_table-2-1">
														<td width="15%" align="right">最後修改人員</td>
														<td width="35%" align="left"><%=fr.getString("fr_modifyuser")%></td>
														<td width="15%" align="right">最後修改日期</td>
														<td width="35%" align="left"><%=fr.getString("fr_modifydate")%></td>
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
												<input type="button" value="回上一頁" onClick="javascript:history.back();">
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
				</div>
			</tr>
		</table>
	</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>