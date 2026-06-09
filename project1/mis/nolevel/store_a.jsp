<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "store"; 					// 模組識別碼
	String show_title = "服務據點維護";		// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸79px * 79px)";

	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";

	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = false;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*----------------------------------------------------------------------------------------------*/
	Vector datas = app_sm.selectAll(tblsp, "sp_code=? and sp_lang=?", new Object[] { code, lang }, "sp_showseq ASC, sp_createdate DESC");

	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,datas);
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {
		// 驗證副檔名
		var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
		// 驗證中文
		var chnese_chk = /[\u4e00-\u9fa5]/;
		// 使用 isEmail.test(欄位名稱) 檢查 E-Mail 是否格式正確 , 正確為 true
		var isEmail = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
	
		if (F.sp_area.value == "") {
	        alert("請輸入地區!!");
	        F.sp_area.focus();
		} else if(F.sp_title.value == "") {
	        alert("請輸入公司名稱!!");
	        F.sp_title.focus();
		} else if (F.sp_address.value == "") {
	        alert("請輸入地址!!");
	        F.sp_address.focus();
		} else if (F.sp_phone.value == "") {
	        alert("請輸入電話!!");
	        F.sp_phone.focus();
		} else if (F.sp_fax.value == "") {
	        alert("請輸入傳真!!");
	        F.sp_fax.focus();
	        <%--
		} else if (F.sp_url.value == "") {
	        alert("請輸入網址!!");
	        F.sp_url.focus();
	        --%>
		} else if (F.sp_email.value != "" && !isEmail.test(F.sp_email.value.trim())) {
	        alert("請輸入正確的email!!");
	        F.sp_email.focus();
		} else if (F.sp_image.value == "") {
	        alert("請上傳圖檔!!");
	        F.sp_image.focus();
	    } else if (!file_chk.test(F.sp_image.value.toLowerCase())) {
	        alert("附檔名限為jpg|jpeg|gif|png|webp!!");
	        F.sp_image.focus();
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
						<hr size="1" noshade />
					</td>
				</tr>
				
				<tr>
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=A" onsubmit="javascript:return checkform(this);">
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
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
									<td width="15%" align="right">地區</td>
									<td colspan="3" width="85%" align="left">
									 	<input type="text" name="sp_area" id="sp_area" size="100" maxlength="120" />								 	
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">公司名稱</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_title" id="sp_title" size="100" maxlength="120" />
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">地址</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_address" id="sp_address" size="100" maxlength="120" />
									</td>
								</tr>
								<tr class="web_table-2-1">
									<td width="15%" align="right">電話</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_phone" id="sp_phone" size="100" maxlength="120" />
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">傳真</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_fax" id="sp_fax" size="100" maxlength="120" />
									</td>
								</tr>
								
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">網址</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_url" id="sp_url" size="100"  />
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">Email</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_email" id="sp_email" size="100" maxlength="120" />
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right" class="web_table-2-1">圖檔</td>
									<td colspan="3" align="left" class="tablebg">
										<input name="sp_image" id="sp_image" type="file" class="button" accept="image/*"> <%=image_info%>
									</td>
								</tr>
								
								<%--
								<tr class="web_table-2-1">
									<td align="right">內文</td>
									<td colspan="3" align="left">
										<textarea name="sp_content" id="sp_content" cols="100" rows="8" class="mceEditor"></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">備註</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="sp_desc" id="sp_desc" size="100" maxlength="120" />
									</td>
								</tr>
								 --%>
								
								<%if(keyword_switch){ %>
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">關鍵字設定</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">網頁標題</td>
									<td colspan="3" align="left">
										<input type="text" name="sp_webtitle" id="sp_webtitle" size="100" maxlength="255" value="<%=SiteSetup.getSetup("web_title"+"."+lang).getString("ss_text") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">設定索引[Robots]</td>
									<td width="35%" align="left">
										<select name="sp_robots" id="sp_robots">
											<option value="index , follow"     <%="index , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>全部-All</option>
											<option value="noindex , nofollow" <%="noindex , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>無-None</option>
											<option value="index , nofollow"   <%="index , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>索引-不跟蹤</option>
											<option value="noindex , follow"   <%="noindex , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>不索引-跟蹤</option>
										</select>
									</td>
									<td width="20%" align="right">設定來訪週期</td>
									<td width="30%" align="left">
										<input type="number" name="sp_revisit_after" id="sp_revisit_after" value="<%=SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text") %>" size="4" maxlength="4" />天
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定網頁版權說明</td>
									<td colspan="3" align="left">
										<input type="text" name="sp_copyright" id="sp_copyright" size="100" value="<%=SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										設定主要關鍵字
									</td>
									<td colspan="3" align="left">
										<textarea name="sp_keywords" id="sp_keywords" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										網頁內容簡介<br />[建議80-100字]
									</td>
									<td colspan="3" align="left">
										<textarea name="sp_description" id="sp_description" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定head追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="sp_seo_head_track" id="sp_seo_head_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.head_track"+"."+lang).getString("ss_text") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定body追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="sp_seo_body_track" id="sp_seo_body_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.body_track"+"."+lang).getString("ss_text") %></textarea>
									</td>
								</tr>
								<%} %>
							
								<%if(deadline_switch) { %>
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">上下架時間</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right" class="web_table-2-1">上架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="sp_emitdate" id="_qemitdate" value="<%=DateTimeTool.dateString()%>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="sp_restdate" id="_qrestdate" value="2099/12/31" size="15" readonly />
									</td>
								</tr>
								<%} %>
								
								<tr class="web_table-2-1">
									<td align="right">資料建立人員</td>
									<td align="left"><%=app_account%></td>
									<td align="right">資料建立日期</td>
									<td align="left"><%=app_today%></td>
								</tr>
							</table></td>
						</tr>
						
						<tr align="center">
							<td colspan="4" align="center">
								<br />
								<input type="submit" value="確定送出" />&nbsp;
								<input type="reset" value="重新設定" />&nbsp;
								<input type="button" value="回上一頁" onClick="location='<%=code%>.jsp';">
							</td>
						</tr>
					</table></td>
</form>
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