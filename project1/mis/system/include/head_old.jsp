<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<meta charset="utf-8" />

<%-- =============META============= --%>
<%--不允許檢索--%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<%-- =============CSS============= --%>
<%--後台用css--%>
<link rel="stylesheet" type="text/css" href="../css/adm_css.css" />
<%-- =============SCRIPT============= --%>
<%--jquery--%>
<%@include file="../../../JQuery/jquery.jsp"%>
<%--萬年曆--%>
<%@include file="../../../JQuery/include_date.jsp"%>

<title><%=app_mistitle%></title>
    <!-- 螢幕比例偵測 -->
    <script>

        function windowChange(chang_w){            
            var defualWidth = chang_w; 									// 目標寬度
            var clientWidth = document.documentElement.clientWidth; 	// 視窗寬度
            document.body.style.zoom = clientWidth / defualWidth * 100 + '%';
        }

        // --螢幕縮放比例---------------------------------------------
        var percentage = [
            "htmlFontSizeA",
            "htmlFontSizeB",
            "htmlFontSizeC"   // win_PX > 1 && win_PX <= 1.5
        ];
        function getBrowserInfo() {
            let win_PX = window.devicePixelRatio;
            console.log("win_PX--"+win_PX);
            console.log("win_width--"+$(window).width());
            if( win_PX > 0.75 && win_PX <= 1.5 ){
                windowChange(1440);
                resizeBrowserStyle();
            }else{
                removeBrowserStyle();
            }
        }
        
        //一開始就執行 20230207 Patty 修改 
        $(window).load(function(e) {	
            getBrowserInfo();
        });
        //畫面寬度變化時要重置
        $(window).resize(function(e) {	
            getBrowserInfo();
        });
        function resizeBrowserStyle(){  
            $("html").addClass(percentage[2]);  //win_PX > 1 && win_PX <= 1.5
        }	
        function removeBrowserStyle(){
            $("html").removeClass(percentage[2]);
            document.body.style.zoom ='100%';
        }
    
    </script>
    
<%-- 畫面美觀 --%>
<style>
.loading-block {
    width: 100%;
    height: 100%;
    position: fixed;
    color: #fff;
    display: flex;
    justify-content: center;
    align-items: center;
    background: rgba(0, 0, 0, 0.8);
    z-index: 99998;
    opacity: 1;
    transition: opacity 1s ease-in-out;
}

.loading-bg {
    position: fixed;
    width: 100%;
    height: 100%;
    z-index: 99997;
}

.loading-text {
    font-size: 20px;
    font-weight: bold;
    position: relative;
    z-index: 99999;
    animation: bounce 1.5s infinite;
}

@keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}
</style>

<script>
    window.onload = function() {
        let loadingBlock = document.getElementById('loadingBlock');
        loadingBlock.style.opacity = '0';
        setTimeout(() => {
            loadingBlock.style.display = 'none';
        }, 1000);
    };
</script>

<div class="loading-block" id="loadingBlock">
    <img src="../images/block_bg.png" class="loading-bg" />
    <div class="loading-text">資料讀取中，請稍待片刻 ......</div>
</div>
    