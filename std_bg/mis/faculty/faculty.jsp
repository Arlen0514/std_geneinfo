<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "faculty"; 				// 模組識別碼
	String show_title = "師資團隊維護";			// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
	boolean search_switch = true;	// 是否開啟搜尋功能
	int page_items = 15; 			// 列表分頁筆數設定
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;				// 設定少於幾筆不可刪除 , -1 為無限制
/*--------------------------------------------------------------------------------------------*/
	Vector fps = app_sm.selectAll(tblfp, "fp_code=? and fp_lang=?", new Object[] { code, lang }, "fp_showseq ASC , " + "fp_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,fps);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num,fps);	
	
	// 搜尋欄位
	String qtitle 	 = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"),"");
	String qjob 	 = StringTool.validString(request.getParameter("_qjob"));
	String qemail 	 = StringTool.validString(request.getParameter("_qemail"));
	String qphone 	 = StringTool.validString(request.getParameter("_qphone"));
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory" ,"_qjob" , "_qemail" ,"_qphone" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory , qjob , qemail , qphone};
	
	//所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	
	if (search_switch) {
		StringBuffer sb = new StringBuffer();
		Vector keys = new Vector();
		sb.append("fp_lang=? and fp_code=? and fp_category like ? and fp_title like ?");
		keys.add(lang);
		keys.add(code);
		keys.add("%" + qcategory + "%");	
		keys.add("%" + qtitle + "%");	
		if(!qjob.isEmpty()){
			sb.append(" and fp_job like ?");
			keys.add("%" + qjob + "%");	
		}
		if(!qemail.isEmpty()){
			sb.append(" and fp_email like ?");
			keys.add("%" + qemail + "%");	
		}
		if(!qphone.isEmpty()){
			sb.append(" and fp_phone like ?");
			keys.add("%" + qphone + "%");	
		}
		fps = app_sm.selectAll(tblfp, sb.toString(), keys.toArray(), "fp_showseq ASC , fp_createdate DESC");
	}
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	// 分頁設定
	app_dp = new DataPager(fps, page_items);
	fps = app_dp.getPageContent(pageno);
	
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<script>
function checkform(F) {
//     if (F._qemitdate.value > F._qrestdate.value) {
//         alert("開始日期不得大於結束日期!!");
//         return false;
//     } else {
        return true;
   // }
}
function clearData(){
	$("#_qtitle").val("");
	$("#_qcategory").val("");
	$("#_qjob").val("");
	$("#_qemail").val("");
	$("#_qphone").val("");
	//$("#_qemitdate").val("<%=DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4)%>");
	//$("#_qrestdate").val("<%=DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4)%>");
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
			<%if(search_switch){ %>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3"
						cellspacing="1">
						<tr>
							<td align="center" colspan="6" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
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
							<td colspan="6" align="center">條件值搜尋</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="20%" align="center">所屬類別</td>
							<td width="10%" align="center">姓名</td>	
							<td width="10%" align="center">職稱</td>	
							<td width="20%" align="center">Email</td>
							<td width="0%" align="center">連絡電話</td>					
							<td width="20%" align="center">功能</td>
						</tr>
						
						<form name="list_sea" id="list_sea" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">
						<tr class="web_table-2-1">
							<td align="center">
								<select name="_qcategory" id="_qcategory">
									<option value="">全部</option>
	                  			<%  
	                  				for(int i=0; i<dms.size(); i++){
	                  					TableRecord dm = (TableRecord) dms.get(i);
	                  			%>
	                  			<option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(qcategory)?"selected":"" %>><%=dm.getString("dm_title") %></option>
								<% } %>
								</select>
							</td>
							<td align="center">
								<input name="_qtitle" id="_qtitle" type="text" value="<%=qtitle %>" size="20" />
							</td>	
							<td align="center">
								<input name="_qjob" id="_qjob" type="text" value="<%=qjob %>" size="20" />
							</td>	
							<td align="center">
								<input name="_qemail" id="_qemail" type="text" value="<%=qemail %>" size="20" />
							</td>	
							<td align="center">
								<input name="_qphone" id="_qphone" type="text" value="<%=qphone %>" size="20" />
							</td>						
		                    <td align="center">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData();" />
		                    </td>
						</tr>
						</form>

					</table>
					</td>
				</table>
				</td>
			</tr>
			<%} %>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3"
						cellspacing="1">
						<%if(!search_switch){ %>
						<tr>
							<td align="center" colspan="8" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
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
						<%}else{ %>
						<tr>
							<td align="center" colspan="8" class="web_title-1"><%=show_title%>查詢列表&nbsp;&nbsp;
						</tr>
						<%} %>
						<tr align="center" class="web_bk-2">
							<td colspan="8" align="center">標題列表</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="5%" align="center">項目</td>
							<td width="10%" align="center">所屬類別</td>
							<td width="15%" align="center">姓名</td>
							<td width="10%" align="center">縮圖</td>	
							<td width="15%" align="center">職稱</td>
							<td width="15%" align="center">電話</td>
							<td width="15%" align="center">Email</td>
							<td width="25%" align="center">功能</td>
						</tr>
						<%
							for (int i = 0; i < fps.size(); i++) {
								TableRecord fp = (TableRecord) fps.get(i);
						%>
						<form name="list<%=i + 1%>" id="list<%=i + 1%>" method="post">
						<tr class="web_table-2-1">
							<td align="center"><%=((pageno - 1) * page_items) + i + 1%></td>
							<td align="center"><%=app_sm.select(tbldm,fp.getString("fp_category")).getString("dm_title") %></td>
							<td align="center"><%=fp.getString("fp_title") %></td>
							<td align="center"><img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+fp.getString("fp_image")%>" width="168"></td>
							<td align="center"><%=fp.getString("fp_job") %></td>
							<td align="center"><%=fp.getString("fp_phone") %></td>
							<td align="center"><%=fp.getString("fp_email") %></td>
							<td align="center">
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="hidden" name="fp_id" id="fp_id" value="<%=fp.getString("fp_id")%>" />
								<%if (modify_switch) { %> 
								<input type="button" value="修改" onclick="goaction(this.form, '<%=code%>_c.jsp');" />&nbsp;&nbsp;
								<%} %>
								<%if (delete_switch) { %>
								<input type="button" value="刪除" onclick="godelete(this.form, '<%=code%>_update.jsp?action=D');" />
								<%} %>
								<%--
								<input type="button" value="學歷" onclick="goaction(this.form, '<%=code%>_in.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								 --%>
								<br/><br/><br/>
								<input type="button" value="學歷" onclick="goaction(this.form, 'education.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								<br/><br/>
								<input type="button" value="經歷" onclick="goaction(this.form, 'experience.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								<br/><br/>
								<input type="button" value="代表著作" onclick="goaction(this.form, 'representative.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								<br/><br/>
								<input type="button" value="五年內執行計畫" onclick="goaction(this.form, 'plan.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								<br/><br/>
								<input type="button" value="實驗室成員" onclick="goaction(this.form, 'lab_member.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								<br/><br/>
								<input type="button" value="實驗室活動" onclick="goaction(this.form, 'lab_activity.jsp?fp_id=<%=fp.getString("fp_id") %>');" />&nbsp;
								<br/>

							</td>
						</tr>
						</form>
						<%} %>

						<td class="web_bk-2" colspan="8" align="center" height="26px">
							<%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
						</td>

					</table>
					</td>
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
		</td>
	</tr>
</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>