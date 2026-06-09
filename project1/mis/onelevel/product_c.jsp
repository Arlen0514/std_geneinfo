<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "product"; 				// 模組識別碼
	String show_title = "產品介紹維護";		// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸400px * 400px)";

	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";

	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = true;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
	int category_num = 1;		    		// 設定商品類別層數 2層以上使用選擇器 一層使用下拉選單即可
	int content_num = 2;		    		// 設定商品網編數
	int otherimage_count = 4;				// 其餘產品圖檔數量
/*--------------------------------------------------------------------------------------*/	
	Vector pds = app_sm.selectAll(tblpd, "pd_code=? and pd_lang=?", new Object[] { code, lang }, "pd_showseq ASC, pd_createdate DESC");
	
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,pds);

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle  };
	
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));

	// 修改資料id
	String pd_id = StringTool.validString(request.getParameter("pd_id"));
	TableRecord pd = app_sm.select(tblpd, pd_id);

	// 輪播圖檔
    Vector<TableRecord> pi_imgs = app_sm.selectAll(tblpi, "pd_id=? and pi_code=?", new Object[]{ pd.getString("pd_id"), "img" }, "pi_showseq ASC, pi_createdate DESC");
%>

<html lang="<%=encoded%>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {
		// 驗證副檔名
		var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
		// 驗證中文
		var chnese_chk = /[\u4e00-\u9fa5]/;
		var num_chk = /^[0-9]*$/;
		//var image = document.getElementById('pd_image').files[0];
	
		if(F.pd_title.value == "") {
	        alert("請輸入產品名稱!!");
	        F.pd_title.focus();
	        <%--
		} else if(F.pd_desc.value == "") {
		    alert("請輸入簡述!!");
		    F.pd_desc.focus();
		    --%> 
	    } else if(tinyMCE.get("pd_desc").getContent() == "") {
	        alert("請輸入簡述!!");
	        F.pd_desc.focus();
	    } else if(F.pd_image.value != "" && !file_chk.test(F.pd_image.value.toLowerCase())) {
	        alert("附檔名限為jpg|jpeg|gif|png|webp!!");
	        F.pd_image.focus();
	    	<%--
	    } else if(chnese_chk.test(F.pd_image.value)) {
	        alert("檔案名稱不可有包含中文!!");
	        F.pd_image.focus();
	    } else if(image.size/1024><%=fSize%>) {
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
<form name="form0" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&pd_id=<%=pd_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>" onsubmit="javascript:return checkform(this);">
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
									<td colspan="4" align="center">修改資訊</td>
								</tr>

								<tr class="web_table-2-1">
									<td width="15%"align="right">產品名稱</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="pd_title" id="pd_title" value="<%=pd.getString("pd_title") %>" size="50" maxlength="120" />
									</td>
								</tr>
											
								<tr class="web_table-2-1">
									<td align="right">簡述</td>
									<td colspan="3" align="left">
										<textarea name="pd_desc" id="pd_desc" cols="100" rows="8" class="ezEditor"><%=pd.getString("pd_desc") %></textarea>
									</td>
								</tr>
							
								<tr class="web_table-2-1">
									<td align="right">
										產品介紹
									</td>
									<td colspan="3" align="left">
										<textarea name="pd_content" id="pd_content" cols="100" rows="8" class="mceEditor"><%=pd.getString("pd_content") %></textarea>
									</td>
								</tr>
							
								<tr class="web_table-2-1">
									<td rowspan="2" align="right" class="web_table-2-1">產品圖檔</td>
									<td colspan="3" align="left" class="tablebg">&nbsp;							 
										<img src="<%=app_fetchpath+"/"+code+"/"+pd.getString("pd_lang")+"/"+pd.getString("pd_image")%>" width="485">		                      		
									</td>
			                    </tr>
		                    
			                    <tr class="web_table-2-1">
									<td colspan="3" align="left" class="tablebg">
										<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.pd_image.value='';">使用原圖<br>
										<input name="imgradio" type="radio" value="new">上傳新圖
										<input name="pd_image" id="pd_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;"> <%=image_info%>
									</td>
			           			</tr>

								<%if(otherimage_count > 0) { %>
							  	<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">輪播圖檔</td>
								</tr>
								<%} %>
		                    
			                    <% 
			                    for(int i = 1; i <= pi_imgs.size(); i++) {
			                    	TableRecord pi = pi_imgs.get(i - 1);
			                    %>
								<tr class="web_table-2-1">
									<td rowspan="2" align="right" class="web_table-2-1">輪播圖檔<%=i %></td>
									<td colspan="3" align="left" class="tablebg">&nbsp;							 
										<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+pi.getString("pi_image")%>" width="401">		                      		
									</td>
			                    </tr>
			                    <tr class="web_table-2-1">
									<td colspan="3" align="left" class="tablebg">
										<input name="imgradio_id<%=i %>" type="hidden" value="<%=pi.getString("pi_id")%>" />
										<input name="imgradio<%=i %>" type="radio" value="ucpic" checked onclick="frm.pd_Image<%=i %>.value='';">使用原圖<br>
										<input name="imgradio<%=i %>" type="radio" value="new">上傳新圖
										<input name="pd_Image<%=i %>" id="pd_Image<%=i %>" type="file" class="button" accept="image/*" onclick="frm.imgradio<%=i %>[1].checked=true;"> <%=image_info%>
									    <br />
									    <input name="imgradio<%=i%>" type="radio" value="delete" onclick="frm.pd_Image<%=i %>.value='';">
										刪除圖檔 <br />
									</td>
			                    </tr>
			                    <% } %>
		                   
		                   		<%for(int i = pi_imgs.size() + 1; i <= otherimage_count; i++) { %>		
								<tr class="web_table-2-1">
									<td align="right" class="web_table-2-1">輪播圖檔<%=i %></td>
									<td colspan="3" align="left" class="tablebg">
										<input name="pd_newImage<%=i %>" id="pd_newImage<%=i %>" type="file" class="button" accept="image/*"> <%=image_info %>
									</td>
						  		</tr>
						  		<%} %>	
		                    </table></td>
						</tr>
					</table></td>
				</tr>

				<tr>
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<%if(keyword_switch) { %>
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">關鍵字設定</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">網頁標題</td>
									<td colspan="3" align="left">
										<input type="text" name="pd_webtitle" id="pd_webtitle" size="100" maxlength="255" value="<%=pd.getString("pd_webtitle") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">設定索引[Robots]</td>
									<td width="35%" align="left">
										<select name="pd_robots" id="pd_robots">
											<option value="index , follow"     <%="index , follow".equals(pd.getString("pd_robots")) ? "selected" : "" %>>全部-All</option>
											<option value="noindex , nofollow" <%="noindex , nofollow".equals(pd.getString("pd_robots")) ? "selected" : "" %>>無-None</option>
											<option value="index , nofollow"   <%="index , nofollow".equals(pd.getString("pd_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
											<option value="noindex , follow"   <%="noindex , follow".equals(pd.getString("pd_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
										</select>
									</td>
									<td width="20%" align="right">設定來訪週期</td>
									<td width="30%" align="left">
										<input type="number" name="pd_revisit_after" id="pd_revisit_after" value="<%=pd.getString("pd_revisit_after") %>" size="4" maxlength="4" />天
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定網頁版權說明</td>
									<td colspan="3" align="left">
										<input type="text" name="pd_copyright" id="pd_copyright" size="100" value="<%=pd.getString("pd_copyright") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										設定主要關鍵字
									</td>
									<td colspan="3" align="left">
										<textarea name="pd_keywords" id="pd_keywords" cols="100" rows="3" maxlength="255"><%=pd.getString("pd_keywords") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										網頁內容簡介<br />[建議80-100字]
									</td>
									<td colspan="3" align="left">
										<textarea name="pd_description" id="pd_description" cols="100" rows="3" maxlength="255"><%=pd.getString("pd_description") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定head追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="pd_seo_head_track" id="pd_seo_head_track" cols="100" rows="3"><%=pd.getString("pd_seo_head_track") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定body追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="pd_seo_body_track" id="pd_seo_body_track" cols="100" rows="3"><%=pd.getString("pd_seo_body_track") %></textarea>
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
										<input type="text" name="pd_emitdate" id="_qemitdate" value="<%=pd.getString("pd_emitdate") %>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="pd_restdate" id="_qrestdate" value="<%=pd.getString("pd_restdate") %>" size="15" readonly />
									</td>
								</tr>
								<%} %>
							
								<tr class="web_table-2-1">
									<td align="right">最後修改人員</td>
									<td align="left"><%=pd.getString("pd_modifyuser") %></td>
									<td align="right">最後修改日期</td>
									<td align="left"><%=pd.getString("pd_modifydate") %></td>
								</tr>
							</table></td>
						</tr>
					
						<tr align="center">
							<td colspan="4" align="center">
								<br />
								<input type="submit" value="確定送出" />&nbsp;
								<input type="hidden" name="_qtitle" value="<%=qtitle %>" />
								<input type="reset" value="重新設定" />&nbsp;
								<input type="button" value="回上一頁" onClick="listpage.submit();">
					    	</td>
						</tr>
					</table></td>
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