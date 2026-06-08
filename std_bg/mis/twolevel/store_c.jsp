<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "store"; 					// 模組識別碼
	String show_title = "據點資訊維護";		// 模組標題

	// 圖片建議尺寸
	//String image_info = "(建議尺寸1280px * 580px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = true;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
	int category_num = 2;				    // 設定類別層數 2層以上使用選擇器 一層使用下拉選單即可
/*------------------------------------------------------------------------------------*/	
	Vector cps = app_sm.selectAll(tblsp, "sp_code=? and sp_lang=?", new Object[] { code, lang }, "sp_showseq ASC , sp_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cps);
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	String qupcategory = StringTool.validString(request.getParameter("_qupcategory"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory", "_qupcategory"  };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory, qupcategory  };
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		
	// 所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");

	// 修改資料id
	String sp_id = StringTool.validString(request.getParameter("sp_id"));	
	TableRecord sp = app_sm.select(tblsp, sp_id);
	// 所屬類別標題
	String title1 = app_sm.select(tbldm,sp.getString("sp_upcategory")).getString("dm_title");
	String title2 = app_sm.select(tbldm,sp.getString("sp_category")).getString("dm_title");
%>
<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F) {
	if(F.sp_category.value == "") {
        alert("請選擇類別!!");
        F.sp_category.focus();
	} else if(F.sp_title.value == "") {
        alert("請輸入公司名稱!!");
        F.sp_title.focus();
	} else if(F.sp_area.value == "") {
        alert("請輸入地區!!");
        F.sp_area.focus();
	} else if(F.sp_address.value == "") {
        alert("請輸入地址!!");
        F.sp_address.focus();
	} else if(F.sp_phone.value == "") {
        alert("請輸入電話!!");
        F.sp_phone.focus();
	} else if(F.sp_time.value == "") {
        alert("請輸入營業時間!!");
        F.sp_time.focus();
	} else if(F.sp_url.value == "") {
        alert("請輸入Google地圖嵌入網址!!");
        F.sp_url.focus();
    } else {
        return true;
    }
	return false;
}
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
			<tr>
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&sp_id=<%=sp_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>&_qcategory=<%=qcategory %>&_qupcategory=<%=qupcategory %>" onsubmit="javascript:return checkform(this);">
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if (add_switch) { %>
									<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
									<%} %>
									<%if (list_switch) { %>
									<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
									<%} %>
								</td>
							</tr>							
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">修改資訊</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>所屬類別</td>
								<td colspan="3" width="85%" align="left">
								  	<% if(category_num<=1){ %>
								    <select name="sp_category" id="sp_category">
										<option value="">請選擇類別</option>
										<% for(TableRecord dm : dms){ %>
											<option value="<%=dm.getString("dm_id")%>" <%=dm.getString("dm_id").equals(sp.getString("sp_category"))?"selected":""%>><%=dm.getString("dm_title")%></option>
										<% } %>
									</select>
									<% }else{  //2層以上 類別選擇器 %>
									<span id="dm_title" style="color:#FA0300;"><%=title1+"--"+title2%></span>&nbsp;&nbsp;
                   					<input type="hidden" name="sp_upcategory" id="sp_upcategory"  value="<%=sp.getString("sp_upcategory") %>"/>
									<input type="hidden" name="sp_category" id="sp_category"  value="<%=sp.getString("sp_category") %>"/>
                  					<input type="button" value="選擇類別" onclick="window.open('../mis_tools/category_selector.jsp?Back_id=sp_category&Back_category=sp_upcategory&max_layer=<%=category_num %>&dm_code=<%=code%>_category','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" />
                  					<% } %>
                  					<%--
									//兩層下拉
									<select name="sp_category" id="sp_category">
										<%for(TableRecord dm : dms){ %>
										<optgroup label="<%=dm.getString("dm_title")%>">
											<%
												Vector<TableRecord> sub_dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=? and dm_category=?",new Object[]{code,lang,dm.getString("dm_id")});
												for(TableRecord sub_dm : sub_dms){ 
											%>
											<option value="<%=sub_dm.getString("dm_id")%>" <%=sp.getString("sp_category").equals(sub_dm.getString("dm_id")) %>><%=sub_dm.getString("dm_title")%></option>
											<%} %>
										</optgroup>
										<%} %>
									</select>
									--%>
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>公司名稱</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_title" id="sp_title" size="100" maxlength="120" value="<%=sp.getString("sp_title")%>" />
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>地區</td>
								<td colspan="3" width="85%" align="left">
									
									<input type="text" name="sp_area" id="sp_area" size="100" maxlength="120" value="<%=sp.getString("sp_area")%>" />
								
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>地址</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_address" id="sp_address" size="100" maxlength="120" value="<%=sp.getString("sp_address")%>" />
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>電話</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_phone" id="sp_phone" size="100" maxlength="120" value="<%=sp.getString("sp_phone")%>" />
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">傳真</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_fax" id="sp_fax" size="100" maxlength="120" value="<%=sp.getString("sp_fax")%>" />
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>營業時間</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_time" id="sp_time" size="100" maxlength="120" value="<%=sp.getString("sp_time")%>" />
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">備註</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_desc" id="sp_desc" size="100" maxlength="120" value="<%=sp.getString("sp_desc")%>" />
								</td>
							</tr>
							
							
							<tr class="web_table-2-1">
								<td width="15%" align="right"><span class="style1">＊</span>Google地圖嵌入網址</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="sp_url" id="sp_url" size="100" value="<%=sp.getString("sp_url")%>"  />
								</td>
							</tr>	
													
							<tr class="web_table-2-1">
								<td align="right">內文</td>
								<td colspan="3" align="left">
									<textarea name="sp_content" id="sp_content" cols="100" rows="8" class="mceEditor"><%=sp.getString("sp_content")%></textarea>
								</td>
							</tr>
					
							
							<%if(keyword_switch){ %>
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="sp_webtitle" id="sp_webtitle" size="100" maxlength="255" value="<%=sp.getString("sp_webtitle") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="sp_robots" id="sp_robots">
										<option value="index , follow"     <%="index , follow".equals(sp.getString("sp_robots")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(sp.getString("sp_robots")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(sp.getString("sp_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(sp.getString("sp_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="sp_revisit_after" id="sp_revisit_after" value="<%=sp.getString("sp_revisit_after") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="sp_copyright" id="sp_copyright" size="100" value="<%=sp.getString("sp_copyright") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="sp_keywords" id="sp_keywords" cols="100" rows="3" maxlength="255"><%=sp.getString("sp_keywords") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="sp_description" id="sp_description" cols="100" rows="3" maxlength="255"><%=sp.getString("sp_description") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="sp_seo_head_track" id="sp_seo_head_track" cols="100" rows="3"><%=sp.getString("sp_seo_head_track") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="sp_seo_body_track" id="sp_seo_body_track" cols="100" rows="3"><%=sp.getString("sp_seo_body_track") %></textarea>
								</td>
							</tr>
							<%} %>
							<%if(deadline_switch){ %>
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">上下架時間</td>
							</tr>
							<tr class="web_table-2-1">
								<td align="right" class="web_table-2-1">上架日期</td>
								<td align="left" class="tablebg">
									<input name="sp_emitdate" id="_qemitdate" type="text" value="<%=sp.getString("sp_emitdate") %>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="sp_restdate" id="_qrestdate" type="text" value="<%=sp.getString("sp_restdate") %>" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="web_table-2-1">
								<td align="right">最後修改人員</td>
								<td align="left"><%=sp.getString("sp_modifyuser") %></td>
								<td align="right">最後修改日期</td>
								<td align="left"><%=sp.getString("sp_modifydate") %></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="hidden" name="_qtitle" value="<%=qtitle %>" />
						<input type="submit" value="確定送出" />&nbsp;
						<input type="reset" value="重新設定" />&nbsp;
						<input type="button" value="回上一頁" onClick="listpage.submit();">
					</td>
					</tr>
				</table>
				</td>
				</form>

			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="web_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</div>
	</tr>
</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>