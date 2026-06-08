<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "product"; 				// 模組識別碼
	String show_title = "產品資訊維護";		// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸266px * 183px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;			// 是否開啟列表功能
	boolean sort_switch = true;			// 是否開啟排序功能
	boolean keyword_switch = true;		// 是否開啟關鍵字設定
	boolean deadline_switch = false;	// 是否開啟上下架日期
	int add_num = -1;					// 設定可新增的資料筆數 , -1 為無限筆
	int category_num = 1;		    	// 設定商品類別層數 2層以上使用選擇器 一層使用下拉選單即可
	int otherimage_count=4;				// 其餘產品圖檔數量

/*-------------------------------------------------------------------------------------*/	
	Vector pds = app_sm.selectAll(tblpd, "pd_code=? and pd_lang=?", new Object[] { code, lang }, "pd_showseq ASC , pd_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,pds);
	
	//所屬類別 
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category" , "" } , "dm_showseq ASC , dm_createdate DESC");
%>
<html lang="<%=encoded%>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){	
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	var num_chk = /^[0-9]*$/;
	
	//var image = document.getElementById('pd_image').files[0];
	
	if (F.pd_category.value == "") {
        alert("請選擇所屬類別!!");
        F.pd_category.focus();
    } else if (F.pd_title.value == "") {
        alert("請輸入產品名稱!!");
        F.pd_title.focus();
        <%--
    } else if (F.pd_desc.value == "") {
        alert("請輸入簡述!!");
        F.pd_desc.focus();
        --%>
    } else if (tinyMCE.get('pd_desc').getContent() == "") {
        alert("請輸入簡述!!");
        F.pd_desc.focus();
    } else if (F.pd_image.value == "") {
        alert("請上傳產品圖檔!!");
        F.pd_image.focus();
    } else if (!file_chk.test(F.pd_image.value.toLowerCase())) {
        alert("附檔名限為jpg|jpeg|gif|png|webp!!");
        F.pd_image.focus();
    <%--
    } else if (chnese_chk.test(F.pd_image.value)) {
        alert("檔案名稱不可有包含中文!!");
        F.pd_image.focus();
    } else if (image.size/1024><%=fSize%>) {
        alert("<%=file_info%>!!");
        F.pd_image.focus();
    --%>
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
<form name="form0" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=A" onsubmit="javascript:return checkform(this);">
      		<table width="99%" border="0" cellspacing="0" cellpadding="0">

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
								<td colspan="4" align="center">新增資訊</td>
							</tr>
							<tr class="web_table-2-1">
								<td align="right">所屬類別</td>
								<td colspan="3" align="left">
									<% if(category_num<=1){ %>
									<select name="pd_category" id="pd_category">
										<option value="">請選擇類別</option>
										<% for(TableRecord dm : dms){ %>
											<option value="<%=dm.getString("dm_id")%>"><%=dm.getString("dm_title")%></option>
										<% } %>
									</select>
									<% }else{  //2層以上 類別選擇器 %>
									<span id="dm_title" style="color:#FA0300;"></span>
                   					<input type="hidden" name="pd_upcategory" id="pd_upcategory" />
									<input type="hidden" name="pd_category" id="pd_category" />
                  					<input type="button" value="選擇類別" onclick="window.open('../mis_tools/category_selector.jsp?Back_id=pd_category&Back_category=pd_upcategory&max_layer=<%=category_num %>','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" />
                  					<% } %>
								    <%--
									//2層 optgroup
									<select name="pd_category" id="pd_category">
										<option value="">請選擇類別</option>
										<%for(TableRecord dm : dms){ %>
										<optgroup label="<%=dm.getString("dm_title")%>">
											<%
												Vector<TableRecord> sub_dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=? and dm_category=?",new Object[]{code,lang,dm.getString("dm_id")});
												for(TableRecord sub_dm : sub_dms){ 
											%>
											<option value="<%=sub_dm.getString("dm_id")%>"><%=sub_dm.getString("dm_title")%></option>
											<%} %>
										</optgroup>
										<% } %>
									</select>
									--%>
								</td>
								
							</tr>
							<tr class="web_table-2-1">
								<td width="15%" align="right">產品名稱</td>
								<td colspan="3" align="left">
									<input type="text" name="pd_title" id="pd_title" size="50" maxlength="120" />
								</td>
							</tr>
							
							
							<tr class="web_table-2-1">
								<td align="right">簡述</td>
								<td colspan="3" align="left">
									<textarea name="pd_desc" id="pd_desc" cols="100" rows="8" class="ezEditor"></textarea>
								</td>
							</tr>
							
							
							<tr class="web_table-2-1">
								<td align="right">產品介紹</td>
								<td colspan="3" align="left">
									<textarea name="pd_content" id="pd_content" cols="100" rows="8" class="mceEditor"></textarea>
								</td>
							</tr>
							
							
						   	<tr class="web_table-2-1">
								<td align="right" class="web_table-2-1">產品圖檔</td>
								<td colspan="3" align="left" class="tablebg">
									<input name="pd_image" id="pd_image" type="file" class="button" accept="image/*"> <%=image_info%>
								</td>
						  	</tr>
							
							<%if(otherimage_count > 0){ %>
						  	<tr align="center" class="web_bk-2">
								<td colspan="3" align="center">輪播圖檔</td>
							</tr>
							<%} %>
						   	<% for(int i=1;i<=otherimage_count;i++){ %> 			
							<tr class="web_table-2-1">
								<td align="right" class="web_table-2-1">輪播圖檔<%=i %></td>
								<td colspan="2" align="left" class="tablebg">
									<input name="pd_newImage<%=i %>" id="pd_newImage<%=i %>" type="file" class="button" accept="image/*"> <%=image_info%>
								</td>
						  	</tr>
						  	<% } %>	
						  
						   
						  	</table>
						</td>
					</tr>
				</table>
			    </td>
			</tr>
			
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">			
							<%if(keyword_switch){ %>
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="pd_webtitle" id="pd_webtitle" size="100" maxlength="255" value="<%=SiteSetup.getSetup("web_title"+"."+lang).getString("ss_text") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="pd_robots" id="pd_robots">
										<option value="index , follow"     <%="index , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="pd_revisit_after" id="pd_revisit_after" value="<%=SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="pd_copyright" id="pd_copyright" size="100" value="<%=SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="pd_keywords" id="pd_keywords" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="pd_description" id="pd_description" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="pd_seo_head_track" id="pd_seo_head_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.head_track"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="pd_seo_body_track" id="pd_seo_body_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.body_track"+"."+lang).getString("ss_text") %></textarea>
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
									<input name="pd_emitdate" id="_qemitdate" type="text" value="<%=DateTimeTool.dateString()%>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="pd_restdate" id="_qrestdate" type="text" value="2099/12/31" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="web_table-2-1">
								<td align="right">資料建立人員</td>
								<td align="left"><%=app_account%></td>
								<td align="right">資料建立日期</td>
								<td align="left"><%=app_today%></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="submit" value="確定送出" />&nbsp;
						<input type="reset" value="重新設定" />&nbsp;
						<input type="button" value="回上一頁" onClick="location='<%=code%>.jsp';">
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