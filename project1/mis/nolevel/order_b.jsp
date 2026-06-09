<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code = "order";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String pd_code = "product";				// 產品功能識別碼 , 用於判別產品圖目錄位置使用
	String show_title = "詢價單維護";			// 功能標題

	String os_id = StringTool.validString(request.getParameter("os_id"));
	String src = StringTool.validString(request.getParameter("src"));
	TableRecord os = app_sm.select(tblos, os_id);
	//TableRecord ph = app_sm.select(tblph , "os_id=?" , new String[]{os.getString("os_id")});

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

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship",
		"_qcollect", "_qbonus", "_qosno", "_qpayment"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship,
		qcollect, qbonus, qosno, qpayment 
	};
	
	// 判別付款方式是否可手動變更狀態(非金流付款 人工check)
	boolean can_change_collect = ("epos".equals(os.getString("os_paymethod")) || "allpay".equals(os.getString("os_paymethod")) || "epos.atm".equals(os.getString("os_paymethod")));						
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	function checkform(F) {
		return true;
	}
	function goaction(FORM,JSP) {
	    FORM.action = JSP;
	    FORM.submit();
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
	            	<td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48"></td>
            		<td align="left" valign="middle" class="web_bigword"><%=show_title %></td>
          		</tr>
          		
          		<tr>
					<td colspan="2"><hr size="1" noshade></td>
          		</tr>

<form name="form0" method="post">  
				<tr>
					<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
					  		<tr>
				    	    	<td align="center" colspan="6" class="web_title-1">
			    		  			<span>詢價單詳細資訊</span>&nbsp;&nbsp;
			    		  			<span><input type="button" value="詢價單列表" onclick="javascript:location.href='<%=code+src %>.jsp'" /></span>&nbsp;
			    		  			<%if("".equals(src)) { %>
						  			<span><input type="button" value="設定詢價單信件收件者" onclick="javascript:location.href='<%=code %>_pop.jsp'" /></span>
						  			<%} %>
					    		</td>
				      		</tr>

					  		<tr class="web_table-2-1">
		                  		<td align="right" class="tablebg">詢價日期 ： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_createdate") %></td>
						  		<td align="right" class="tablebg">詢價狀態 ： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%="N".equals(os.getString("os_status"))?"作廢":"正常" %></td>
								<td align="right" class="tablebg">詢價單編號 ： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_no") %></td>
						  	</tr>

						  	<tr class="web_table-2-1">
		                  		<td width="16%" align="right" class="tablebg">姓名 ： </td>
		                 		<td width="16%" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_name") %></td>
		                  		<td width="16%" align="right" class="tablebg">性別 ：  </td>
		                  		<td width="16%" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_sex").replace("F", "女").replace("M", "男") %></td>
		                  		<td width="16%" align="right" class="tablebg">職務 ： </td>
		                 		<td width="16%" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_post") %></td>
						  	</tr>

						  	<tr class="web_table-2-1">
			                  	<td width="16%" align="right" class="tablebg">公司名稱 ： </td>
		                 		<td width="16%" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_company") %></td>
		                  		<td width="16%" align="right" class="tablebg">部門	 ：  </td>
		                  		<td width="16%" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_dep") %></td>
						 		<td align="right" class="tablebg">電子郵件： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_email")%></td>
						  	</tr>

						  	<tr class="web_table-2-1">
							 	<td align="right" class="tablebg">電話： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_phone")%></td>
						 		<td align="right" class="tablebg">手機： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_cellphone")%></td>	                 	
		                 		<td align="right" class="tablebg">傳真： </td>
		                 		<td align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_fax")%></td>
						  	</tr>					  

						  	<tr class="web_table-2-1">
			                 	<td align="right" class="tablebg">地址 ： </td>
		                 		<td colspan="5" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_county")+os.getString("os_city")+os.getString("os_address")%></td>
						  	</tr>

						  	<tr class="web_table-2-1">
		                  		<td colspan="6" align="center" class="web_title-1">詢價內容</td>
		                  	</tr>

		                  	<tr class="web_bk-2">
		                    	<td width="15%" align="right">詢價單明細</td>
		                    	<td colspan="5" align="left"><table width="100%"  border="1">
		                          		<tr>
		                            		<td width="15%"  align="center">項次</td>
		                            		<td width="35%" align="center">商品圖片</td>
		                            		<td width="30%" align="center">商品名稱 </td>
		                            		<td width="20%"  align="center">數量</td>
		                          		</tr>
		                          		<% 
		                          		Vector ols = app_sm.selectAll(tblol, "os_id=?", new String[]{os.getString("os_id")});  							
								  		int os_total = 0;	// 全部詢價單總金額
	
								  		// 取出詢價單商品
	                              		for(int i = 0; i < ols.size(); i++) {
	                            	  		TableRecord ol = (TableRecord)ols.get(i);
	                             	  		TableRecord pd = app_sm.select(tblpd, ol.getString("pd_id"));
	                             	  		os_total = os_total + (ol.getInt("pd_price") * ol.getInt("pd_quantity"));
						           		%>  
		                          		<tr>
		                            		<td align="center"><%=i+1 %></td>	                            
		                            		<td align="center"><img src="<%=app_fetchpath+"/"+pd_code+"/"+pd.getString("pd_lang") +"/"+pd.getString("pd_image") %>" width="133" height="79"></td>
		                            		<td align="center">
			                            		<%=ol.getString("pd_name") %>
		                            			<br />
		                            			<%=ol.getString("ps_type") %> 
		                            		</td>	                           
		                            		<td align="center"><%=app_df.format(ol.getInt("pd_quantity")) %></td>	                            
		                          		</tr>
								  		<%} %>
		                      	</table></td>
		                  	</tr>
	
						  	<tr class="web_table-2-1">
		                  		<td colspan="6" align="center" class="web_title-1">問卷內容</td>
		                  	</tr>
	
						  	<tr class="web_table-2-1">
		                  		<td width="16%" align="right" class="tablebg">連絡方式 ： </td>
		                 		<td colspan="2" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_contact") %></td>
		                  		<td width="16%" align="right" class="tablebg">取得資訊 ：  </td>
		                  		<td colspan="2" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_info") %></td>
						  	</tr>
	
						  	<tr class="web_table-2-1">
		                  		<td width="16%" align="right" class="tablebg">預計採購時間 ： </td>
		                 		<td colspan="2" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_shop_time") %></td>
		                  		<td width="16%" align="right" class="tablebg">是否編入預算 ：  </td>
		                  		<td colspan="2" align="left" class="tablebg">&nbsp;&nbsp;<%=os.getString("os_budget").replace("Y", "是").replace("N", "否") %></td>
						  	</tr>
	
						  	<tr class="web_bk-2">
								<td align="right">備註</td>					  
						  		<td colspan="5" align="left"><%=os.getString("os_memo").replace(String.valueOf((char)13) , "<BR/>") %></td>
						  	</tr>
	
						</table></td>
					</table>
					<br />
					<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
					<input type="hidden" name="os_id" id="os_id" value="<%=os.getString("os_id") %>" />
					<input type="hidden" name="code" id="code" value="<%=code %>_b" />
					<%=HtmlCoder.hiddenInputs(names, values)%>
					<input name="" type="button" value="<%="N".equals(os.getString("os_status"))?"恢復詢價單":"詢價單作廢" %>" onclick="goaction(this.form, '<%=code %>_update.jsp?action=STATUS<%="".equals(src)?"":"&src=_n" %>');" />&nbsp;&nbsp;			
		        	<input name="" type="button" value="回上一頁"  onclick="goaction(this.form, '<%=code+src %>.jsp');" />
		        	</td>
				</tr>
</form>
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
