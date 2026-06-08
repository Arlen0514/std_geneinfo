<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	String page_code = "contact";				// 頁面識別碼		

	// 取出資料
	TableRecord cp = app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{ page_code+"_info", lang }, "cp_showseq ASC, cp_createdate DESC");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%-- SEO --%>
<%if(!"".equals(cp.getString("cp_id"))) { %>
<meta name="Robots" content="<%=cp.getString("cp_robots") %>" />
<meta name="revisit-after" content="<%=cp.getString("cp_revisit_after") %> days" />
<meta name="keywords" content="<%=cp.getString("cp_keywords") %>" />
<meta name="copyright" content="<%=cp.getString("cp_copyright") %>" />
<meta name="description" content="<%=cp.getString("cp_description") %>" />
<%-- 追蹤碼 --%><%=cp.getString("cp_seo_track") %>
<%} %>
<%-- 共用設定 --%>
<%@include file="../include/head.jsp" %>
<script>
	function checkcontent(F) {
		var isEmail = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;  // 使用 isEmail.test(欄位名稱) 檢查 E-Mail 是否格式正確 , 正確為 true
		$("#btnok").prop("disabled", true);

	    if(F.cu_name.value.trim() == "") {
	        alert("請輸入您的姓名!!");
	        F.cu_name.focus();
	    } else if(F.cu_phone.value.trim() == "") {
	        alert("請輸入正確的電話號碼 !!");
	        F.cu_phone.focus();
		} else if(F.cu_email.value.trim() == "" || !isEmail.test(F.cu_email.value.trim())) {
	        alert("請輸入正確的 E-Mail !!");
	        F.cu_email.focus();
	    } else if(F.cu_content.value.trim() == "") {
	        alert("請輸入訊息內容 !!");
	        F.cu_content.focus();
	    } else if(F.ind.value.trim() == "" ) {
	        alert("請輸入圖形驗証碼 !!");
	        F.ind.focus();
	    } else {
		    $("#btnok").prop("disabled", false);
	        return true;
	    }
	    $("#btnok").prop("disabled", false);
	    return false;
	}
	function loadimage() {
	  	document.getElementById("randImage").src = "../../comm/image.jsp?"+Math.random(); 
	  	//$("#randImage").attr("src","../../comm/image.jsp?"+Math.random());
	}
</script>
</head>
<body>
	<%-- 版頭 --%>
	<%@include file="../include/top_menu.jsp" %>

    <%-- Main --%>
    <div class="main indexMain wow fadeInLeftBig" id="top">

        <div class="inBanner wow fadeInLeft" data-wow-delay="0.3s"><!--動態效果 wow + animated樣式-->
        	<img src="images/inBanner.png" />
        </div>

        <div class="inMain">

            <div class="wrap">

                <div class="titStyle2"> 
					聯絡我們       
                </div> 

                <!--聯絡我們左-->
                <div class="contactLeft wow fadeInLeft" data-wow-delay="0.6s"><!--動態效果 wow + animated樣式-->
                    <!--網編區-->
                    <section class="textArea">
                         <%=cp.getString("cp_content") %>
                    </section>
                </div>

                <!--聯絡我們右-->
                <div class="contactRight wow fadeInLeft" data-wow-delay="0.9s"><!--動態效果 wow + animated樣式-->
                
                    <!--網編區-->
                    <section class="textArea">                        
                        <p style="font-size:15px; color:#000; line-height:25px;">
							您好，歡迎光臨<%=SiteSetup.getText("cp.company."+lang) %>
                            <br />
							如您有任何需求歡迎填寫以下表單，我們將盡快與您聯繫。
                        </p>
                        <br />
                        <p style="font-size:15px; color:#7d0022; line-height:25px;">※以下每個欄位皆為必填。</p>                    
                    </section>
                    
                    <br />            

<form name="form0" method="post" action="<%=page_code %>_update.jsp" onsubmit="return checkcontent(this);">    

                    <!--表單區-->
                    <div class="form_area">

                        <!--姓名-->
                        <div class="form_list fLType2"><!--一列兩個時class內加fLType2-->
                            <div class="fL_tit">
								姓名
                            </div>
                            <div class="fL_right">
                                <input type="text" name="cu_name" id="cu_name" />
                            </div>
                        </div>

                        <!--電話-->
                        <div class="form_list fLType2">
                            <div class="fL_tit">
								電話
                            </div>
                            <div class="fL_right">
                                <input type="text" name="cu_phone" id="cu_phone" />
                            </div>
                        </div>

                        <!--Email-->
                        <div class="form_list">
                            <div class="fL_tit">
                                Email
                            </div>
                            <div class="fL_right">
                                <input type="text" name="cu_email" id="cu_email" />
                            </div>
                        </div>

                        <!--訊息內容-->
                        <div class="form_list">
                            <div class="fL_tit">
								訊息內容
                            </div>
                            <div class="fL_right">
                                <textarea name="cu_content" id="cu_content"></textarea>
                            </div>
                        </div>

                        <!--驗證碼-->
                        <div class="form_list">
                            <div class="fL_tit">
								驗證碼
                            </div>
                            <div class="fL_right">
                                <div class="captcha">
                                    <input type="text" name="ind" id="ind" />
                                    <img src="../../comm/image.jsp" name="randImage" id="randImage" width="72" height="27" />
                                    <a href="javascript:loadimage();">
                                        <i class="material-icons">&#xE5D5;</i>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!--表單區 按鍵區-->
                        <div class="form_btn_area one">
                            <input name="btnok" id="btnok" type="submit" value="確認送出" />
                            <input type="reset" value="重新填寫"/>
                            <div class="clearfloat">
                            </div>
                        </div>
                    </div>
</form>

                </div>

            </div>

            <div class="clearfloat">
            </div>

        </div>

    </div>

	<%--版腳--%>
	<%@include file="../include/copyright.jsp" %>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>  
