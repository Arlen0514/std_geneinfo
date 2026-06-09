<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "order";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "詢價單維護";				// 功能標題
	int page_items		= 15;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 

	// Conditions.
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	String qship	 = StringTool.validString(request.getParameter("_qship"));
	String qbonus	 = StringTool.validString(request.getParameter("_qbonus"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qivoice = StringTool.validString(request.getParameter("_qivoice"));
	String qosno = StringTool.validString(request.getParameter("_qosno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));

	if("".equals(qposition)) { qposition = "Y"; }
	if("".equals(qcollect)) { qcollect = "%"; }
	if("".equals(qship)) { qship = "%"; }

	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) { qemitdate = def_qemitdate; }
	if("".equals(qrestdate)) { qrestdate = def_qrestdate; }

	// Names and values.
	String[] names = new String[] {
		"npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship",
		"_qcollect", "_qbonus","_qosno","_qpayment","_qivoice"
	};
	String[] values = new String[] {
		String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship,
		qcollect, qbonus, qosno, qpayment, qivoice 
	};

	Vector oss = app_sm.selectAll(tblos, "os_code=? AND os_lang=?", new Object[] { code, lang });

	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("os_code=? AND os_lang=?");
	keys.add(code);
	keys.add(lang);
	sb.append(" and os_no like ?");
	keys.add("%"+qosno+"%");
	sb.append(" and os_collect like ? and os_ship like ?");
	keys.add(qcollect);
	keys.add(qship);
	if(!"".equals(qbonus)) {
		sb.append(" and os_bonus_status like ? and os_getbonus > 0");
		keys.add(qbonus);
	}
	sb.append(" and os_status like ? and os_name like ?");
	keys.add(qposition);
	keys.add("%"+qname+"%");
	sb.append(" and os_phone like ?");
	keys.add("%"+qphone+"%");
	sb.append("and os_paymethod like ?");
	keys.add("%"+qpayment+"%");
	/*
	sb.append("and os_invoice_status like ?");
	keys.add("%"+qivoice+"%");
	*/
	sb.append(" and !(os_createdate>? || os_createdate<?)");
	keys.add(qrestdate+" 24:00:00");
	keys.add(qemitdate);
	oss = app_sm.selectAll(tblos, sb.toString(), keys.toArray() , "os_createdate DESC");
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));

	// 設定資料分頁每頁筆數
	app_dp = new DataPager(oss,page_items);
	oss = app_dp.getPageContent(pageno);
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-TW">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<script language="JavaScript" type="text/JavaScript">
	function checkform(F) {
	    if (F._qemitdate.value > F._qrestdate.value) {
	        alert("開始日期不得大於結束日期!!");
	        return false;
	    } else {
	        return true;
	    }
	}
	function clearData(F) {
		$("#_qname").val("");
		$("#_qosno").val("");
		$("#_qpayment").val("");
		$("#_qphone").val("");
		$("#_qemitdate").val("<%=def_qemitdate%>");
		$("#_qrestdate").val("<%=def_qrestdate%>");
		$("#_qposition").val("Y");
		$("#_qcollect").val("");
		$("#_qship").val("");
		$("#_qbonus").val("");
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
	            	<td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48" /></td>
	            	<td align="left" valign="middle" class="web_bigword"><%=show_title %></td>
	          	</tr>
	          	
	          	<tr>
	            	<td colspan="2"><hr size="1" noshade /></td>
	          	</tr>
			  	
			  	<tr>
					<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
						  	<tr>
				    	    	<td align="center" colspan="7" class="web_title-1">
				    		  		<span><%=show_title %></span>&nbsp;&nbsp;
							  		<span><input type="button" value="詢價單列表" onclick="javascript:location.href='<%=code %>.jsp'" /></span>&nbsp;
							  		<span><input type="button" value="設定詢價單信件收件者" onclick="javascript:location.href='<%=code %>_pop.jsp'" /></span>		    		  
						    	</td>
					      	</tr>         
				          	
				          	<tr class="web_bk-2">
			                  	<td colspan="7" align="center"><%=show_title %>查詢</td>
		                  	</tr>
						  	
						  	<tr class="web_bk-2">
		                 		<td width="15" align="center" class="tablebg">詢價人姓名</td>
		                 		<td width="10%" align="center" class="tablebg">電話</td>
		                 		<td width="14%" align="center" class="tablebg">詢價單編號</td>
		                 		<td width="20%" align="center" class="tablebg">日期區間</td>
		                 		<td width="8%" align="center" class="tablebg">詢價單狀態</td>
								<td width="8%" align="center">是否回覆</td>
		                 		<td width="25%" align="center" class="tablebg">&nbsp;</td>
						  	</tr>

<form name="form_search" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">          
			              	<tr class="web_table-2-1">
								<td align="center" class="tablebg">
			                    	<input name="_qname" id="_qname" type="text" value="<%=qname %>"  />
			                    </td>

			                    <td align="center" class="tablebg">
			                     	<input name="_qphone" id="_qphone" type="text" value="<%=qphone %>" />
			                    </td>

			                    <td align="center" class="tablebg">
			                     	<input name="_qosno" id="_qosno" type="text" value="<%=qosno %>"  />
			                    </td>

			                    <td align="center" class="tablebg">
			                     	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="5" /><br />
			                     		~<br />
			                       	<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="5" />
								</td>

			                    <td align="center">
									<select name="_qposition" id="_qposition">
										<option value="Y" <%="Y".equals(qposition)?"selected='selected'":"" %>>正常</option>
										<option value="N" <%="N".equals(qposition)?"selected='selected'":"" %>>作廢</option>
										<option value="%" <%="%".equals(qposition)?"selected='selected'":"" %>>全&nbsp;部</option>
									</select>
								</td>
								
								<td align="center">
									<select name="_qship" id="_qship">
										<option value="" <%="".equals(qship)?"selected='selected'":"" %>>全 &nbsp;部</option>
										<option value="N" <%="N".equals(qship)?"selected='selected'":"" %>>未處理</option>
										<option value="Y" <%="Y".equals(qship)?"selected='selected'":"" %>>已處理</option>
									</select>
								</td>
			                  	
			                  	<td align="center" class="tablebg">
			                        <input name="query" type="submit" value="查詢">&nbsp;
			            			<input type="button" value="清除" onclick="clearData(this.form);" />
			                  	</td>
			              	</tr>
</form>
						</table></td>
					</table></td>
				</tr>
				
				<tr>
					<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							  	<tr align="center">
								    <td colspan="8" align="center" class="web_title-1">查詢結果標題列表</td>
							  	</tr>
							  	
							  	<tr class="web_bk-2">
							    	<td width="5%" align="center">項目</td>
							    	<td width="10%" align="center">詢價人姓名</td>
							    	<td width="10%" align="center">電話</td>
							    	<td width="14%" align="center">詢價單編號</td>
							    	<td width="20%" align="center">詢價日期</td>
							    	<td width="8%" align="center">詢價單狀態</td>
			                 		<td width="8%" align="center" class="tablebg">回覆狀況</td>				
							    	<td width="25%" align="center">功能</td>
							  	</tr>
							  	
							  	<%
							  	for(int i = 0; i < oss.size(); i++) { 
									TableRecord os = (TableRecord) oss.get(i);
									// 判別付款方式是否可手動變更狀態(非金流付款 人工check)
									boolean can_change_collect = ("epos".equals(os.getString("os_paymethod")) || "allpay".equals(os.getString("os_paymethod")) || "epos.atm".equals(os.getString("os_paymethod")));						
							  	%>
<form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
							  	<tr class="web_table-2-1">
									<td align="center">
										<%=((pageno-1) * page_items) + i + 1 %></td>
							    	<td align="left">&nbsp;&nbsp;
							    		<%=os.getString("os_name") %>
							    	</td>
							    	<td align="left">&nbsp;&nbsp;
							    		<%=os.getString("os_phone") %>
							    	</td>
							    	<td align="left">&nbsp;&nbsp;
							    		<%=os.getString("os_no") %>
							    	</td>
							    	<td align="center">
							    		<%=os.getString("os_createdate").subSequence(0, 10) %>
							    	</td>				    
							    	<td align="center">
							    		<%="N".equals(os.getString("os_status"))?"作廢":"正常" %>
							    	</td>
					    			<td align="center">
					    				<input type="checkbox" value="Y" name="os_ship" <%="Y".equals(os.getString("os_ship"))?"checked":"" %> onclick="goaction(this.form, '<%=code %>_update.jsp?action=REPLY');"/>
					    			</td>						   
							    	<td align="center">
										<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
										<input type="hidden" name="os_id" id="os_id" value="<%=os.getString("os_id") %>" />
										<input type="hidden" name="code" id="code" value="<%=code %>" />
										<%=HtmlCoder.hiddenInputs(names, values) %>
										<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="檢視" onclick="goaction(this.form, '<%=code %>_b.jsp');" />&nbsp;
										<%--
										<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="刪除" onclick="godelete(this.form, '<%=code %>_update.jsp?action=D');"/> <%} %>
										--%>
										<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="<%="N".equals(os.getString("os_status"))?"恢復詢價單":"詢價單作廢" %>" onclick="goaction(this.form, '<%=code %>_update.jsp?action=STATUS');"/> <%} %>
							    	</td>
							  	</tr>
</form>
							  	<%} %>						
								<tr class="web_bk-2" >  
									<td colspan="8" align="center" height="26px">
								  		<%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
									</td>
								</tr>
							</table></td>
						</tr>
					</table></td>
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