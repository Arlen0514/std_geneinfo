<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "message_excel"; 			// 模組識別碼
	String upload_code = "about"; 			// 上傳資料夾識別碼
	String show_title = "Excel匯入寄送設定"; 	// 模組標題

	// 功能參數
	boolean single = false;	   				// 單網編/單一修改畫面模組 true=關閉列表+ 排序+ 新增功能
	boolean list_switch = false;			// 是否開啟列表功能
	boolean sort_switch = false;			// 是否開啟排序功能
	boolean keyword_switch = false;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	boolean add_switch = false;				// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkMessage(F) {
		var file_chk = /([^\/]+\.(?:xls))/;//驗證副檔名
		
		if($("#import_file").val()=="" || !(file_chk.test($("#import_file").val()))){
	    	alert("請上傳 .xls 檔案 , 以利作業 !!");
	    	$("#import_file").focus();
		} else if (F._content.value == "") {
	         alert("請輸入簡訊內容!!");
	         F._content.focus();
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
					<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="message_excel_update.jsp" onsubmit="javascript:return checkMessage(this);">
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
								<td align="left" valign="middle" class="web_bigword"><%=show_title%><%----%>
								</td>
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
														<td align="center" colspan="4" class="web_title-1"><%=show_title%><%----%>&nbsp;&nbsp;
															<%
																if (add_switch) {
															%>
															<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />
															&nbsp;
															<%
																}
															%>
															<%
																if (list_switch) {
															%>
															<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />
															&nbsp;
															<%
																}
															%>
															<%
																if (sort_switch) {
															%>
															<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
															<%
																}
															%>
														</td>
													</tr>

													<tr align="center" class="web_bk-2">
														<td colspan="4" align="center">
															簡訊資訊<br />
															<font color="red">※國際簡訊(非+886 開頭)則需以三倍點數計價之。	</font>
														</td>
													</tr>
													
									             	<tr class="web_table-2-1">
									                	<td colspan="4" align="center">
									                    	選擇你要導入的 xls 資料表：
									                    	<input name="import_file" id="import_file" type="file" class="button" />
									                  	</td>
									               	</tr>
									               	
									              	<tr class="web_table-2-1">
									                	<td colspan="4" align="left">
									                    	資料表導入格式說明：<br/>
									                    	1、請以制式化規格上傳<a style="color: red;" href="message_excel.xls">檔案在此</a>；導入資料表文件必須是 xls 文件格式{.xls} 為副檔名．<br/>
									                 	</td>
									              	</tr>

													<tr class="web_table-2-1">
														<td width="15%" align="right">簡訊內容</td>
														<td colspan="3" align="left">
															<textarea name="_content" id="_content" cols="100" rows="8"></textarea>
														</td>
													</tr>

													<tr class="web_table-2-1">
														<td align="right">發送時間</td>
														<td align="left" class="tablebg">
															<input name="_sendDate" id="_qrestdate" type="text" value="<%=DateTimeTool.dateString()%>" size="15" readonly>
															寄送時間為當天的0時0分，逾時則立即發送。
														</td>
													</tr>

												</table>
											</td>
										</tr>
										<tr align="center">
											<td colspan="4" align="center">
												<br />
												<input type="submit" value="確定送出" />
												&nbsp;
												<input type="reset" value="重新設定" />
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
				</div>
			</tr>
		</table>
	</div>
	</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>