<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code 		= "news2_download"; 		// 模組識別碼
	String show_title 	= "文件下載維護";				// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸1280px * 580px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = false;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
	int file_num = 5;						// 檔案下載數量 
/*------------------------------------------------------------------------------------*/	
	Vector cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[] { code, lang }, "cp_showseq ASC , cp_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cps);
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory };
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
	// 所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	// 檔案類型
	Vector<TableRecord> file_types = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=?",new Object[]{"file_type",lang},"dm_showseq ASC , dm_createdate DESC");
		
	// 修改資料id
	String cp_id = StringTool.validString(request.getParameter("cp_id"));	
	TableRecord cp = app_sm.select(tblcp, cp_id);
	
	// 所有檔案
	Vector<TableRecord> fd_files = app_sm.selectAll(tblfd,"fd_code=? and fk_id=?",new Object[]{"file",cp_id},"fd_showseq ASC , fd_createdate DESC");
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if(F.cp_category.value == "") {
        alert("請選擇類別!!");
        F.cp_category.focus();
	} else if(F.cp_title.value == "") {
        alert("請輸入標題名稱!!");
        F.cp_title.focus();
    <% for(int i=1;i<=fd_files.size();i++){ %> 	
    } else if (F.cp_FileType<%=i%>.value == "" && F.fileradio<%=i %>.value!="delete") {
        alert("請選擇檔案類型");
        F.cp_FileType<%=i%>.focus();
    } else if (F.cp_FileType<%=i%>.value != "" && F.fileradio<%=i %>.value=="delete") {
        alert("請使用原有檔案或上傳新檔案");
        F.cp_FileType<%=i%>.focus();
    <% } %>
    <% for(int i=fd_files.size()+1;i<=file_num;i++){ %> 	
    } else if (F.cp_newFile<%=i%>.value != "" && F.cp_newFileType<%=i%>.value=="") {
        alert("請選擇檔案類型");
        F.cp_newFileType<%=i%>.focus();
    } else if (F.cp_newFileType<%=i%>.value != "" && F.cp_newFile<%=i%>.value=="") {
        alert("請上傳檔案");
        F.cp_newFile<%=i%>.focus();
    <% } %>
    } else {
    	var have_file = false;
    	$("[name^=cp_File],[name^=cp_newFile]").each(function(i){
    		if($(this).val()!="") {
    			have_file = true;
    		}
    		<% for(int i=1;i<=fd_files.size();i++){ %>
    		if( !have_file && $(this).attr("name")=="cp_file<%=i%>"){
    			if($("[name=fileradio<%=i%>]:checked").val()!="delete"){
    				have_file = true;
    			}
    		}
    		<% } %>
    	});
    	if(!have_file){
    		alert("請至少上傳一個檔案");
    		$("[name^=cp_newFile]").focus();
    		return false;
    	}
    	
    	
    	<% for(int i=fd_files.size()+1;i<=file_num;i++){ %>		
    	if (F.cp_newFileType<%=i%>.value != "" && F.cp_newFile<%=i %>.value!="") {
            F.cp_NewFileid<%=i%>.value='add';
    	}
    	<% } %>
    	
    	<%
		//檔案下載
    	for(int i=1;i<=fd_files.size();i++){
         	TableRecord fd = fd_files.get(i-1);
        %>
    	if (F.cp_File<%=i%>.value == ""  && F.fileradio<%=i%>.value!="delete") {
    		F.cp_File<%=i%>.type = "text";
    		F.cp_File<%=i%>.value = "<%=fd.getString("fd_file")%>";
    	}
    	<% } %>
    	
    	
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
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&cp_id=<%=cp_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>&_qcategory=<%=qcategory %>" onsubmit="javascript:return checkform(this);">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if (add_switch) { %>
									<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp?_qcategory=<%=qcategory %>'" />&nbsp;
									<%} %>
									<%if (list_switch) { %>
									<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=qcategory %>'" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp?_qcategory=<%=qcategory %>'" />
									<%} %>
								</td>
							</tr>							
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">新增資訊</td>
							</tr>
<%-- 							
							<tr class="web_table-2-1">
								<td width="15%" align="right">所屬類別</td>
								<td colspan="3" width="85%" align="left">
								   <select name="cp_category" id="cp_category">
									   <option value="">請選擇類別</option>
			                  		   <%  
			                  				for(int i=0; i<dms.size(); i++){
			                  					TableRecord dm = (TableRecord) dms.get(i);
			                  			%>
			                  			<option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(cp.getString("cp_category"))?"selected":"" %>><%=dm.getString("dm_title") %></option>
										<% } %>
									</select>
								</td>
							</tr>
--%>						
							<input type="hidden" name="cp_category" id="cp_category" value="<%=cp.getString("cp_category")%>"/>
							<tr class="web_table-2-1">
								<td width="15%" align="right">標題</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="cp_title" id="cp_title" size="100" maxlength="120" value="<%=cp.getString("cp_title")%>"/>
								</td>
							</tr>	
							
							
							<% 
							for(int i=1;i<=fd_files.size();i++){
								TableRecord fd = fd_files.get(i-1);
							%> 	
						  	<tr class="web_table-2-1">
								<td rowspan="2" align="right" class="web_table-2-1">
									檔案<%=i %>
								</td>
								<td colspan="3" align="left" class="tablebg">
									檔案類型&nbsp;&nbsp;&nbsp;
									<input name="fileradio_id<%=i %>" type="hidden" value="<%=fd.getString("fd_id")%>" />
									<select name="cp_FileType<%=i %>" id="cp_FileType<%=i %>">
						  				<option value="">請選擇檔案類型</option>
						  				<% for(TableRecord dm:file_types){ %>
						  				<option value="<%=dm.getString("dm_id")%>" <%=fd.getString("fd_file_type").equals(dm.getString("dm_id"))?"selected":"" %>><%=dm.getString("dm_title")%></option>
						  				<% } %>
						  			</select>											     		
								</td>
		                    </tr>
		                    <tr class="web_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<input name="fileradio_id<%=i %>" type="hidden" value="<%=fd.getString("fd_id")%>" />
									<input name="fileradio<%=i %>" type="radio" value="ucpic" checked onclick="frm.cp_File<%=i %>.value='';">使用原檔&nbsp;&nbsp;&nbsp;
									<a href="<%=app_fetchpath+"/"+code+"/"+lang+"/"+fd.getString("fd_file")%>" download><%=fd.getString("fd_file") %></a>		         
									<br/>	
									<input name="fileradio<%=i %>" type="radio" value="new">上傳新檔&nbsp;&nbsp;&nbsp;
									<input name="cp_File<%=i %>" id="cp_File<%=i %>" type="file" class="button" onclick="frm.fileradio<%=i %>[1].checked=true;"> 
								    </br>
								    <input name="fileradio<%=i%>" type="radio" value="delete" onclick="frm.cp_File<%=i %>.value='';">
									刪除檔案 </br>
								</td>
		                    </tr>
						  	<% } %>
						  	
						  	<% for(int i=fd_files.size()+1;i<=file_num;i++){ %>
						  	<tr class="web_table-2-1">
								<td align="right" class="tablebg">
									檔案<%=i %>
								</td>
								<td colspan="3" align="left" class="tablebg">
						  			檔案類型&nbsp;&nbsp;&nbsp;
						  			<select name="cp_newFileType<%=i %>" id="cp_newFileType<%=i %>">
						  				<option value="">請選擇檔案類型</option>
						  				<% for(TableRecord dm:file_types){ %>
						  				<option value="<%=dm.getString("dm_id")%>"><%=dm.getString("dm_title")%></option>
						  				<% } %>
						  			</select>
									<input type="hidden" name="cp_NewFileid<%=i %>" id="cp_NewFileid<%=i %>"  />&nbsp;&nbsp;&nbsp;
									<input name="cp_newFile<%=i %>" id="cp_newFile<%=i %>" type="file" class="button" >
						  		</td>
						  	</tr>
							<% } %>
													
							<%-- 				
							<tr class="web_table-2-1">
								<td align="right">內文</td>
								<td colspan="3" align="left">
									<textarea name="cp_content" id="cp_content" cols="100" rows="8" class="mceEditor"><%=cp.getString("cp_content")%></textarea>
								</td>
							</tr>
		                    
		                    <tr class="web_table-2-1">
								<td rowspan="2" align="right" class="web_table-2-1">檔案</td>	
								<td colspan="3" align="left" class="tablebg">&nbsp;
						        <% if(!cp.getString("cp_file").isEmpty()){ %>
									<a href="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_file")%>" download><%=cp.getString("cp_file") %></a>		                      		
							    <% } %>
								</td>
		                    </tr>
							<tr class="web_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<input name="imgradio1" type="radio" value="ucpic" checked onclick="frm.cp_file.value='';">使用原檔<br>
									<input name="imgradio1" type="radio" value="new">上傳新檔
									<input name="cp_file" id="cp_file" type="file" class="button" <%--accept="image/*"-%> onclick="frm.imgradio1[1].checked=true;"> 
								</td>
		                    </tr>
		                    --%>	

							<%if(keyword_switch){ %>
							<tr align="center" class="web_table-2-1">
								<td colspan="4" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="cp_webtitle" id="cp_webtitle" size="100" maxlength="255" value="<%=cp.getString("cp_webtitle") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="cp_robots" id="cp_robots">
										<option value="index , follow"     <%="index , follow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="cp_revisit_after" id="cp_revisit_after" value="<%=cp.getString("cp_revisit_after") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="cp_copyright" id="cp_copyright" size="100" value="<%=cp.getString("cp_copyright") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="cp_keywords" id="cp_keywords" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_keywords") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="cp_description" id="cp_description" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_description") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="cp_seo_head_track" id="cp_seo_head_track" cols="100" rows="3"><%=cp.getString("cp_seo_head_track") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="cp_seo_body_track" id="cp_seo_body_track" cols="100" rows="3"><%=cp.getString("cp_seo_body_track") %></textarea>
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
									<input name="cp_emitdate" id="_qemitdate" type="text" value="<%=cp.getString("cp_emitdate") %>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="cp_restdate" id="_qrestdate" type="text" value="<%=cp.getString("cp_restdate") %>" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="web_table-2-1">
								<td align="right">最後修改人員</td>
								<td align="left"><%=cp.getString("cp_modifyuser") %></td>
								<td align="right">最後修改日期</td>
								<td align="left"><%=cp.getString("cp_modifydate") %></td>
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
				</form>
				</td>
				

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