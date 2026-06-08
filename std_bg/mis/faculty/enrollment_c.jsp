<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "enrollment"; 				// 模組識別碼
	String show_title = "招生資訊維護";				// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸198px * 140px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = false;	// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
	boolean keyword_switch = true;	// 是否開啟關鍵字設定
	boolean deadline_switch = true; // 是否開啟上下架日期	
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int file_num = 3;				// 檔案下載數量 
	int filetype_num = 5;			// 檔案類型數量
/*-------------------------------------------------------------------------*/
	Vector nps = app_sm.selectAll(tblnp, "np_code=? and np_lang=?", new Object[] { code,lang }, "np_showseq ASC , " + "np_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,nps);		

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"), DateTimeTool.getYear() - 10 + DateTimeTool.dateString().substring(4));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"), DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4));
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory", "_qemitdate", "_qrestdate" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory, qemitdate, qrestdate };
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
	// 所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");
	// 檔案類型
	Vector<TableRecord> file_types = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=?",new Object[]{"file_type",lang},"dm_showseq ASC , dm_createdate DESC");
		
	// 修改資料id
	String np_id = StringTool.validString(request.getParameter("np_id"));
	TableRecord np = app_sm.select(tblnp, np_id);
	
	// 所有檔案
	Vector<TableRecord> fd_files = app_sm.selectAll(tblfd,"fd_code like ? and fk_id=?",new Object[]{"file%",np_id},"fd_showseq ASC , fd_createdate ASC ,  fd_modifydate DESC");
	
%>
<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){	
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if (F.np_category.value == "") {
        alert("請選擇類別!!");
        F.np_category.focus();
    }else if (F.np_title.value == ""){
	   	alert("請輸入標題名稱!!");
	   	F.np_title.focus();
	   	<%--
	} else if (F.np_image.value != "" && !file_chk.test(F.np_image.value.toLowerCase())) {
		alert("附檔名限為jpg|jpeg|gif|png|webp!!");
		F.np_image.focus();
		--%>
    } else if (F.np_emitdate.value > F.np_restdate.value) {
        alert("上架日期不得大於下架日期!!");
        F.np_emitdate.focus();
        return false;
    }else {
    	var error_file = false;
	   	for(var i=1;i<=file_num;i++){
	   		var have_file = false;
	   		var $file_title;
	   		var modify_file = i<=<%=fd_files.size()%>;
	   		if(modify_file){
	   			$file_title = $("[name=np_FileTitle"+i+"]");
	   		}else{
	   			$file_title = $("[name=np_newFileTitle"+i+"]");
	   		}
	   		var file_title = $file_title.val();
	   		if(error_file){
	   			break;
	   		}
	   		for(var j=1;j<=<%=filetype_num%>;j++){
	   			var modify_files = $("[name=np_FileType"+i+j+"]").length>0;
	   			var $file_type;
	   			var $file;
	   			if(modify_files){
	   				$file_type = $("[name=np_FileType"+i+j+"]");
	   				$file = $("[name=np_File"+i+j+"]");
	   			}else{
	   				$file_type = $("[name=np_newFileType"+i+j+"]");
	   				$file = $("[name=np_newFile"+i+j+"]");
	   			}
	   			var file_type = $file_type.val();
	   			var file = $file.val();
	   			if(!have_file){
			   		if(file_title!=""){
			   			if(file_type!="" && (file!="" || $("[name=fileradio"+i+j+"]:checked").val()!="delete")){
			   				have_file = true;
			   			}
			   			if(j==<%=filetype_num%> && !have_file){
							if(file_type==""){
				   				alert("請選擇檔案類型");
				   				$file_type.focus();
				   				error_file = true;
				   				break;
				   			}else if(file==""){
				   				alert("請上傳檔案");
				   				$file.focus();
				   				error_file = true;
				   				break;
				   			}
		   				}
			   		}
	   			}
	   			
	   			
	   			if(file_type!=""){
		   			if(file_title==""){
		   				alert("請輸入檔案標題");
		   				$file_title.focus();
		   				error_file = true;
		   				break;
		   			}
		   			
		   			if(modify_files){
		   				if(file=="" &&  $("[name=fileradio"+i+j+"]:checked").val()=="delete"){
				   			alert("請上傳檔案");
			   				$file.focus();
			   				error_file = true;
			   				break;
		   				}
		   			}else if(file==""){
		   				alert("請上傳檔案");
		   				$file.focus();
		   				error_file = true;
		   				break;
		   			}
		   			
		   			
		   		}
	   		 	
	   			if(modify_files){
	   				if(file!="" || $("[name=fileradio"+i+j+"]:checked").val()!="delete"){
			   			if(file_type==""){
			   				alert("請選擇檔案類型");
			   				$file_type.focus();
			   				error_file = true;
			   				break;
			   			}else if(file_title==""){
			   				alert("請輸入檔案標題");
			   				$file_title.focus();
			   				error_file = true;
			   				break;
			   			}
	   				}
	   			}else if(file!=""){
	   				if(file_type==""){
		   				alert("請選擇檔案類型");
		   				$file_type.focus();
		   				error_file = true;
		   				break;
		   			}else if(file_title==""){
		   				alert("請輸入檔案標題");
		   				$file_title.focus();
		   				error_file = true;
		   				break;
		   			}
	   			}
	   					
	   					
	   			
   			}

   		}
	   	if(error_file){
	   		return false;
   		}
	   
	   	for(var i=1;i<=file_num;i++){ 
			for(var j=1;j<=<%=filetype_num%>;j++){
				if($("[name=np_newFileType"+i+j+"]").val()!= "" && $("[name=np_newFile"+i+j+"]").val()!= "" ){
					$("[name=np_NewFileid"+i+j+"]").val('add');
		   		}
				<%--
		   		if (F.np_newFileType<%=i%><%=j %>.value != "" && F.np_newFile<%=i %><%=j %>.value!="") {
		            F.np_NewFileid<%=i%><%=j %>.value='add';
		    	}
		    	--%>
	   		}
	   	}
	   	
	   	$("[name^=np_FileType]").each(function(i){
	   		var $np_File = $("[name^=np_File][type=file]").eq(i);
	   		var fileradio = $np_File.siblings("fileradio").attr("name");
	   		var filename = $np_File.siblings("a");
	   		if($np_File.val()=="" && $("[name="+fileradio+"]:checked").val()!="delete"){
	   			$np_File[0].type="text";
	   			$np_File.val($(filename).text());
	   		}
	   	});
	   
    	
    	
        return true;
    }
	return false;
}

var file_num = <%=fd_files.size()>file_num?fd_files.size():file_num%>;
function add_file(){
	file_num++;
	var $file = $("#file_clone").clone();
	$file.find("[name=np_newFileTitle]").attr("name","np_newFileTitle"+file_num).attr("id","np_newFileTitle"+file_num);
	for(var i=1;i<=<%=filetype_num%>;i++){
		$file.find("[name=np_NewFileid"+i+"]").attr("name","np_NewFileid"+file_num+i).attr("id","np_NewFileid"+file_num+i);	
		$file.find("[name=np_newFileType"+i+"]").attr("name","np_newFileType"+file_num+i).attr("id","np_newFileType"+file_num+i);
		$file.find("[name=np_newFile"+i+"]").attr("name","np_newFile"+file_num+i).attr("id","np_newFile"+file_num+i);
	}
	$file.find("[id=file_num]").attr("id","file_num"+file_num);
	$("#file_num"+(file_num-1)).after($file.html());
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
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&np_id=<%=np_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>&_qcategory=<%=qcategory %>&_qemitdate=<%=qemitdate %>&_qrestdate=<%=qrestdate %>" onsubmit="javascript:return checkform(this);">
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
								<td width="15%" align="right">所屬類別</td>
								<td colspan="3" width="85%" align="left">
							   <select name="np_category" id="np_category">
							   <option value="">請選擇類別</option>
	                  			<%  
	                  				for(int i=0; i<dms.size(); i++){
	                  					TableRecord dm = (TableRecord) dms.get(i);
	                  			%>
	                  			<option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(np.getString("np_category"))?"selected":"" %>><%=dm.getString("dm_title") %></option>
								<% } %>
								</select>
								</td>
							</tr>
							 
							<tr class="web_table-2-1">
								<td width="15%" align="right">標題</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="np_title" id="np_title" size="100" maxlength="120" value="<%=np.getString("np_title")%>"/>
								</td>
							</tr>
							
							
							<tr class="web_table-2-1">
								<td align="right">簡述</td>
								<td colspan="3" align="left">
									<textarea name="np_desc" id="np_desc" cols="100" rows="5" class="ezEditor"><%=np.getString("np_desc") %></textarea>
								</td>
							</tr>
					
							
							<tr class="web_table-2-1">
								<td align="right">內文</td>
								<td colspan="3" align="left">
									<textarea name="np_content" id="np_content" cols="100" rows="8" class="mceEditor"><%=np.getString("np_content") %></textarea>
								</td>
							</tr>
							
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">
									檔案下載
									<input type="button" value="新增檔案數" onclick="add_file();" />
								</td>
							</tr>
							
						  	
						  	<% 
							for(int i=1;i<=fd_files.size();i++){
								TableRecord fd = fd_files.get(i-1);
							%> 	
						  	<tr class="web_table-2-1">
								<td rowspan="<%=filetype_num+1%>" align="right" class="web_table-2-1">
									檔案<%//=i %>
								</td>
								<td colspan="3" align="left" class="tablebg">
						  			檔案標題&nbsp;&nbsp;&nbsp;
						  			<input type="text" name="np_FileTitle<%=i %>" id="np_FileTitle<%=i %>" value="<%=fd.getString("fd_title")%>" size="100" />
						  		</td>
		                    </tr>
		                    <% 
		                    Vector<TableRecord> fd_infiles = app_sm.selectAll(tblfd,"fd_code=? and fk_id=?",new Object[]{fd.getString("fd_id"),np_id},"fd_showseq ASC , fd_createdate DESC");
		                    fd_infiles.add(0,fd);
		                    for(int j=1;j<=fd_infiles.size();j++){
		                    	fd = fd_infiles.get(j-1);
		                    %>
		                    <tr class="web_table-2-1">
								<td colspan="3" align="left" <%=j==filetype_num?"id=\"file_num"+i+"\"":""%>>	
									<table border="0" cellspacing="1" cellpadding="3" >
										<tr>
											<td>  
												檔案類型&nbsp;&nbsp;&nbsp;
												<input name="fileradio_id<%=i %><%=j %>" type="hidden" value="<%=fd.getString("fd_id")%>" />
												<select name="np_FileType<%=i %><%=j %>" id="np_FileType<%=i %><%=j %>">
									  				<option value="">請選擇檔案類型</option>
									  				<% for(TableRecord dm:file_types){ %>
									  				<option value="<%=dm.getString("dm_id")%>" <%=fd.getString("fd_file_type").equals(dm.getString("dm_id"))?"selected":"" %>><%=dm.getString("dm_title")%></option>
									  				<% } %>
									  			</select>	
						  					</td>
											<td>  
												<a href="<%=app_fetchpath+"/"+code+"/"+lang+"/"+fd.getString("fd_file")%>" download><%=fd.getString("fd_file") %></a>		         
												</br>
												<input name="fileradio_id<%=i %><%=j %>" type="hidden" value="<%=fd.getString("fd_id")%>" />
												<input name="fileradio<%=i %><%=j %>" type="radio" value="ucpic" checked onclick="frm.np_File<%=i %><%=j %>.value='';">使用原檔<br>
												<input name="fileradio<%=i %><%=j %>" type="radio" value="new">上傳新檔
												<input name="np_File<%=i %><%=j %>" id="np_File<%=i %><%=j %>" type="file" class="button" onclick="frm.fileradio<%=i %><%=j %>[1].checked=true;"> 
											    </br>
											    <input name="fileradio<%=i%><%=j %>" type="radio" value="delete" onclick="frm.np_File<%=i %><%=j %>.value='';">
												刪除檔案 </br>		  		
											</td>
										</tr>
									</table>
																     		
								</td>
		                    </tr>
		                    <%-- 
		                    <tr class="web_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<a href="<%=app_fetchpath+"/"+code+"/"+lang+"/"+fd.getString("fd_file")%>" download><%=fd.getString("fd_file") %></a>		         
									<br/>	
									<input name="fileradio_id<%=i %>" type="hidden" value="<%=fd.getString("fd_id")%>" />
									<input name="fileradio<%=i %>" type="radio" value="ucpic" checked onclick="frm.np_File<%=i %>.value='';">使用原檔<br>
									<input name="fileradio<%=i %>" type="radio" value="new">上傳新檔
									<input name="np_File<%=i %>" id="np_File<%=i %>" type="file" class="button" onclick="frm.fileradio<%=i %>[1].checked=true;"> 
								    </br>
								    <input name="fileradio<%=i%>" type="radio" value="delete" onclick="frm.np_File<%=i %>.value='';">
									刪除檔案 </br>
								</td>
		                    </tr>
		                    --%>
		                    <% 
		                    } 
		                    for(int j=fd_infiles.size()+1;j<=filetype_num;j++){
		                    %>
		                    <tr class="web_table-2-1"  <%=j==filetype_num?"id=\"file_num"+i+"\"":""%>>
								<td colspan="3" align="left" class="tablebg">
						  			檔案類型&nbsp;&nbsp;&nbsp;
						  			<select name="np_newFileType<%=i %><%=j %>" id="np_newFileType<%=i %><%=j %>">
						  				<option value="">請選擇檔案類型</option>
						  				<% for(TableRecord dm:file_types){ %>
						  				<option value="<%=dm.getString("dm_id")%>"><%=dm.getString("dm_title")%></option>
						  				<% } %>
						  			</select>
									<input type="hidden" name="np_NewFileid<%=i %><%=j %>" id="np_NewFileid<%=i %><%=j %>"  />&nbsp;&nbsp;&nbsp;
						  			<input name="np_newFile<%=i %><%=j %>" id="np_newFile<%=i %><%=j %>" type="file" class="button" >
						  		</td>
						  	</tr>
						  	<%-- 
						  	<tr class="web_table-2-1" <%=j==filetype_num?"id=\"file_num"+i+"\"":""%>>
								<td colspan="3" align="left" class="tablebg">
									<input name="np_newFile<%=i %><%=j %>" id="np_newFile<%=i %><%=j %>" type="file" class="button" >
								</td>
							</tr>
							--%>
		                    <% } %>
		                    <tr align="center" class="web_bk-2">
								<td colspan="4" align="center">
									&nbsp;
								</td>
							</tr>
						  	<% } %>
						  	
						  	<% for(int i=fd_files.size()+1;i<=file_num;i++){ %>
						  	<tr class="web_table-2-1">
								<td rowspan="<%=filetype_num+1%>" align="right" class="tablebg">
									檔案<%//=i %>
								</td>
								<td colspan="3" align="left" class="tablebg">
						  			檔案標題&nbsp;&nbsp;&nbsp;
						  			<input type="text" name="np_newFileTitle<%=i %>" id="np_newFileTitle<%=i %>" value="<%//=%>" size="100" />
						  		</td>
						  	</tr>
						  	<% for(int j=1;j<=filetype_num;j++){ %>
						  	<tr class="web_table-2-1" <%=j==filetype_num?"id=\"file_num"+i+"\"":""%>>
								<td colspan="3" align="left" class="tablebg">
						  			檔案類型&nbsp;&nbsp;&nbsp;
						  			<select name="np_newFileType<%=i %><%=j %>" id="np_newFileType<%=i %><%=j %>">
						  				<option value="">請選擇檔案類型</option>
						  				<% for(TableRecord dm:file_types){ %>
						  				<option value="<%=dm.getString("dm_id")%>"><%=dm.getString("dm_title")%></option>
						  				<% } %>
						  			</select>
									<input type="hidden" name="np_NewFileid<%=i %><%=j %>" id="np_NewFileid<%=i %><%=j %>"  />&nbsp;&nbsp;&nbsp;
						  			<input name="np_newFile<%=i %><%=j %>" id="np_newFile<%=i %><%=j %>" type="file" class="button" >
						  		</td>
						  	</tr>
						  	<%--
						  	<tr class="web_table-2-1" <%=j==filetype_num?"id=\"file_num"+i+"\"":""%>>
								<td colspan="3" align="left" class="tablebg">
									<input name="np_newFile<%=i %><%=j %>" id="np_newFile<%=i %><%=j %>" type="file" class="button" >
								</td>
							</tr>
							 --%>
							<% } %>
							<% } %>
							
							
							<%-- 
							<tr class="web_table-2-1">
								<td rowspan="2" align="right" class="web_table-2-1">消息圖片</td>	
								<td colspan="3" align="left" class="tablebg">&nbsp;
						        <% if(!np.getString("np_image").isEmpty()){ %>
									<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+np.getString("np_image")%>" width="198">		                      		
							    <% } %>
								</td>
		                    </tr>
		                    <tr class="web_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.np_image.value='';">使用原圖<br>
									<input name="imgradio" type="radio" value="new">上傳新圖
									<input name="np_image" id="np_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;"> <%=image_info%>
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
									<input type="text" name="np_webtitle" id="np_webtitle" size="100" maxlength="255" value="<%=np.getString("np_webtitle") %>"/>
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="np_robots" id="np_robots">
										<option value="index , follow"     <%="index , follow".equals(np.getString("np_robots")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(np.getString("np_robots")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(np.getString("np_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(np.getString("np_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="np_revisit_after" id="np_revisit_after" value="<%=np.getString("np_revisit_after") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td align="right">設定主要關鍵字</td>
								<td align="left">
									<input type="text" name="np_keywords" id="np_keywords" size="40" maxlength="255" value="<%=np.getString("np_keywords") %>"/>
								</td>
								<td align="right">設定網頁版權說明</td>
								<td align="left">
									<input type="text" name="np_copyright" id="np_copyright" size="30" value="<%=np.getString("np_copyright") %>"/>
								</td>
							</tr>
							<tr class="web_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="np_description" id="np_description" cols="100" rows="3" maxlength="255"><%=np.getString("np_description") %></textarea>
								</td>
							</tr>
								
							<tr class="web_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="np_seo_head_track" id="np_seo_head_track" cols="100" rows="3"><%=np.getString("np_seo_head_track") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="np_seo_body_track" id="np_seo_body_track" cols="100" rows="3"><%=np.getString("np_seo_body_track") %></textarea>
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
									<input name="np_emitdate" id="_qemitdate" type="text" value="<%=np.getString("np_emitdate") %>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="np_restdate" id="_qrestdate" type="text" value="<%=np.getString("np_restdate") %>" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="web_table-2-1">
								<td align="right">最後修改人員</td>
								<td align="left"><%=np.getString("np_modifyuser") %></td>
								<td align="right">最後修改日期</td>
								<td align="left"><%=np.getString("np_modifydate") %></td>
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
		</div>
<%-- 複製新增用 --%>
<table style="display:none;">
	<tbody id="file_clone">
		<tr class="web_table-2-1">
			<td rowspan="<%=filetype_num+1%>" align="right" class="tablebg">
				檔案
			</td>
			<td colspan="3" align="left" class="tablebg">
	 			檔案標題&nbsp;&nbsp;&nbsp;
	 			<input type="text" name="np_newFileTitle" id="np_newFileTitle" size="100" />
	 		</td>
		</tr>
		<% for(int j=1;j<=filetype_num;j++){ %>
	 	<tr class="web_table-2-1" <%=j==filetype_num?"id=\"file_num\"":""%>>
			<td colspan="3" align="left" class="tablebg">
	 			檔案類型&nbsp;&nbsp;&nbsp;
	 			<select name="np_newFileType<%=j %>" id="np_newFileType">
	 				<option value="">請選擇檔案類型</option>
	 				<% for(TableRecord dm:file_types){ %>
	 				<option value="<%=dm.getString("dm_id")%>"><%=dm.getString("dm_title")%></option>
	 				<% } %>
	 			</select>
				<input type="hidden" name="np_NewFileid<%=j %>" id="np_NewFileid<%=j %>"  />&nbsp;&nbsp;&nbsp;
				<input name="np_newFile<%=j %>" id="np_newFile" type="file" class="button" >
	 		</td>
	 	</tr>
	 	<%-- 
	 	<tr class="web_table-2-1" <%=j==filetype_num?"id=\"file_num\"":""%>>
			<td colspan="3" align="left" class="tablebg">
				<input name="np_newFile<%=j %>" id="np_newFile" type="file" class="button" >
			</td>
		</tr>
		--%>
		<% } %>
	</tbody>
</table>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>