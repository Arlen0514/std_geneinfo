<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "hot_product"; 			// 模組識別碼
	String data_code = "product";			// 選取模組識別碼
	String show_title = "熱門商品維護";			// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean search_switch = true;	// 是否開啟搜尋功能
	int page_items = 15; 			// 列表分頁筆數設定
	int category_num = 2;		    // 設定資料類別層數 2層以上使用選擇器 一層使用下拉選單即可
/*--------------------------------------------------------------------------------------------*/
	// 未選取列表
	Vector pds = app_sm.selectAll(tblpd, "pd_code=? and pd_lang=? and pd_hot=?", new Object[] { data_code, lang ,"" }, "pd_showseq ASC , pd_createdate DESC");
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"),"%");
	String qupcategory = StringTool.validString(request.getParameter("_qupcategory"),"%");

	// 欲取代選取的資料ID  
	String pd_replaceid = StringTool.validString(request.getParameter("pd_replaceid"));
	// 選取編號
	String showno = StringTool.validString(request.getParameter("showno"));
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" , "pd_replaceid " ,"showno", "_qcategory", "_qupcategory" };
	String[] values = new String[] { String.valueOf(pageno), qtitle , pd_replaceid , showno, qcategory, qupcategory  };
	
	// 所屬類別 
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, data_code+"_category" , "" } , "dm_showseq ASC , dm_createdate DESC");
	
	// 當前搜尋類別標題
	String title1=app_sm.select(tbldm,qupcategory).getString("dm_title");
	String title2=app_sm.select(tbldm,qcategory).getString("dm_title");
	
	if (search_switch) {
		StringBuffer sb = new StringBuffer();
		Vector keys = new Vector();
		sb.append("pd_lang=? and pd_code=? and pd_category like ? and pd_title like ? and pd_hot=?");
		keys.add(lang);
		keys.add(data_code);
		keys.add(qcategory);
		keys.add("%" + qtitle + "%");
		keys.add("");	
		pds = app_sm.selectAll(tblpd, sb.toString(), keys.toArray(), "pd_showseq ASC , pd_createdate DESC");
	}
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	// 分頁設定
	app_dp = new DataPager(pds, page_items);
	pds = app_dp.getPageContent(pageno);
	
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
	$("#_qcategory").val("%");
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
							<td align="center" colspan="3" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
								
								<%if (list_switch) { %>
								<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
								<%} %>
								<%if (sort_switch) { %>
								<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
								<%} %>
							</td>
						</tr>

						<tr align="center" class="web_bk-2">
							<td colspan="3" align="center">條件值搜尋</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="30%" align="center">所屬類別</td>
							<td width="50%" align="center">標題名稱</td>						
							<td width="20%" align="center">功能</td>
						</tr>
						
						<form name="list_sea" id="list_sea" method="post" action="<%=code %>_b.jsp" onsubmit="return checkform(this);">
						<tr class="web_table-2-1">
							<td align="center">
								<% if(category_num<=1){ %>
								<select name="_qcategory" id="_qcategory">
				    		            <option value="%">全部</option>
			                  			<% 
				                  			for(int i=0; i<dms.size(); i++){
				                  				TableRecord dm = (TableRecord) dms.get(i);
				                  		%>
				                  		<option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(qcategory)?"selected":"" %>><%=dm.getString("dm_title") %></option>
				                  		<%} %>
					            </select>
							    <% }else{  //2層以上 類別選擇器 %>
								<span id="dm_title" style="color:#FA0300;"><%=!"%".equals(qcategory)?title1+"--"+title2:""%></span>&nbsp;&nbsp;
	                  			<input type="hidden" name="_qupcategory" id="_qupcategory" value="<%=qupcategory%>" />
								<input type="hidden" name="_qcategory" id="_qcategory" value="<%=qcategory %>" />
	                  			<input type="button" value="選擇類別" onclick="window.open('../mis_tools/category_selector.jsp?Back_id=_qcategory&Back_category=_qupcategory&max_layer=<%=category_num %>','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" />
								<% } %>
								<%-- 2層 optgroup
								<select name="_qcategory" id="_qcategory">
									<option value="%">全部</option>
									<%for(TableRecord dm : dms){ %>
									<optgroup label="<%=dm.getString("dm_title")%>">
										<%
											Vector<TableRecord> sub_dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=? and dm_category=?",new Object[]{code,lang,dm.getString("dm_id")});
											for(TableRecord sub_dm : sub_dms){ 
										%>
										<option value="<%=sub_dm.getString("dm_id")%>" <%=sub_dm.getString("dm_id").equals(qcategory)?"selected":"" %>><%=sub_dm.getString("dm_title")%></option>
										<%} %>
									</optgroup>
									<%} %>
								</select>
								--%>
							</td>
							<td align="center"><input name="_qtitle" id="_qtitle" type="text" value="<%=qtitle %>" size="70" /></td>							
		                    <td align="center">
		                     	<input name="showno" type="hidden" value="<%=showno%>">
		                    	<input type="hidden" name="pd_replaceid" id="pd_replaceid" value="<%=pd_replaceid%>" />
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
							<td align="center" colspan="5" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
								
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
							<td align="center" colspan="5" class="web_title-1"><%=show_title%>查詢列表&nbsp;&nbsp;
						</tr>
						<%} %>
						<tr align="center" class="web_bk-2">
							<td colspan="5" align="center">標題列表</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="5%" align="center">項目</td>
							<td width="25%" align="center">所屬類別</td>
							<td width="20%" align="center">產品縮圖</td>
							<td width="30%" align="center">標題名稱</td>							
							<td width="20%" align="center">功能</td>
						</tr>
						<%
							for (int i = 0; i < pds.size(); i++) {
								TableRecord pd = (TableRecord) pds.get(i);
						%>
						<form name="list<%=i + 1%>" id="list<%=i + 1%>" method="post">
						<tr class="web_table-2-1">
							<td align="center"><%=((pageno - 1) * page_items) + i + 1%></td>
							<td align="center"><%=app_sm.select(tbldm, pd.getString("pd_upcategory")).getString("dm_title")+"--"+app_sm.select(tbldm, pd.getString("pd_category")).getString("dm_title")%></td>
							<td align="center"><img src="<%=app_fetchpath+"/"+data_code+"/"+pd.getString("pd_lang")+"/"+pd.getString("pd_image") %>" width="100%"></td>						
							<td align="center"><%=pd.getString("pd_title") %></td>	
							<td align="center">
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="hidden" name="pd_id" id="pd_id" value="<%=pd.getString("pd_id")%>" />
								<input type="hidden" name="pd_replaceid" id="pd_replaceid" value="<%=pd_replaceid%>" />
								 <input name="showno" type="hidden" value="<%=showno%>">
								<input type="button" value="選取" onclick="goaction(this.form, '<%=code%>_update.jsp?action=choose');" />&nbsp;
							</td>
						</tr>
						</form>
						<%} %>

						<td class="web_bk-2" colspan="5" align="center" height="26px">
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