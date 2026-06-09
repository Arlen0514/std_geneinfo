<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%
	/*-- 非 A4  大小用 --*/
	String page_code = "ebook";

	// 資料編號
	String fd_id = StringTool.validString(request.getParameter("fd_id"));

	// 資料內容
	TableRecord fd = app_sm.select(tblfd, fd_id);
	String[] images = fd.getString("fd_url").split(",");
%>
<html>
<head>
	<%@ include file="/WEB-INF/jspf/norobots.jspf" %>
  	<!--讓ie在切換瀏覽器模式時 文件模式會使用最新的版本-->
  	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  	<!--RWD用-->
  	<meta charset="utf-8" />
  	<!-- viewport -->
  	<meta content="width=device-width,initial-scale=1" name="viewport" />
  	<!--android 手機板主題顏色用 更改網址列顏色-->
  	<meta name="theme-color" content="#fff0" />
  	<!--取消行動版 safari 自動偵測數字成電話號碼-->
  	<meta name="format-detection" content="telephone=no" />
	<title><%=app_webtitle%></title>
  	<link rel="shortcut icon" href="../images/favicon.png" />
  	<!--電腦版icon-->
  	<link rel="apple-touch-icon" href="../images/icon.png" />
  	<!--手機版icon  57x57px-->
  	<link rel="apple-touch-icon" sizes="72x72" href="../images/icon-72.png" />
  	<!--手機版icon  72x72px-->
  	<link rel="apple-touch-icon" sizes="114x114" href="../images/icon%402.png" />
  	<!--手機版icon  114x114px-->
  	<!--內容區塊css-->
  	<link rel="stylesheet" type="text/css" href="../css/style.css" />
  	<!-- bootstrap-icons -->
  	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.0/font/bootstrap-icons.css" />
  	<!-- <link rel="stylesheet" href="web/icon_fonts/bootstrap_icons/bootstrap-icons.css"> -->  <!-- 為了弱掃留原始檔案 -->
  	<!-- 新增 版本更新jQuery modify by Judy 20221206 start -->
  	<!-- jQuery版本3.6.1 -->
  	<script src="https://code.jquery.com/jquery-3.6.1.min.js" type="text/javascript"></script>
  	<!-- <script src="web/js/jquery/jquery-3.6.1.min.js" type="text/javascript"></script> -->  <!-- 為了弱掃留原始檔案 -->
  	<!-- jQuery 遷移插件_簡化從舊版本jQuery的轉換3.4.0-->
  	<script src="https://code.jquery.com/jquery-migrate-3.4.0.min.js" type="text/javascript"></script>
  	<!-- <script src="web/js/jquery/jquery-migrate-3.4.0.min.js" type="text/javascript"></script> -->  <!-- 為了弱掃留原始檔案 -->
  	<!-- 新增 版本更新jQuery modify by Judy 20221206 end -->
  	<!--JavaScript共用區-->	
  	<script src="../js/common.js" type="text/javascript"></script>
	<!--Montserrat字型 -->
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
	<!-- Noto Sans Traditional Chinese字型 -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
	<!-- Noto Serif Traditional Chinese字型 -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@200;300;400;500;600;700;900&display=swap" rel="stylesheet" />

	<!-- add js -->
	<script src="js/jquery.js"></script>
	<script src="js/turn.js"></script>
	<script src="js/jquery.fullscreen.js"></script>
	<script src="js/jquery.address-1.6.min.js"></script>
	<script src="js/onload.js"></script>

  	<!-- add css -->
  	<link type="text/css" href="css/style.css" rel="stylesheet" />
  	<link type="text/css" rel="stylesheet" href="http://fonts.googleapis.com/css?family=Play:400,700" />
  	<link type="text/css" rel="stylesheet" href="http://fonts.googleapis.com/css?family=Nunito:400,300" />

  	<style>
    	html,
    	body {
      		margin: 0;
      		padding: 0;
      		overflow: auto !important;
    	}
  	</style>
</head>
<body>  
	<!-- BEGIN FLIPBOOK STRUCTURE -->   
	<div data-template="false" data-cat="book7" id="fb7-ajax">  
    	
    	<!-- BEGIN HTML BOOK -->     
    	<div data-current="book7" class="fb7" id="fb7" style="background-color: #fff0;">      
    
	        <!-- preloader -->
        	<div class="fb7-preloader">
            	<div id="wBall_1" class="wBall">
            		<div class="wInnerBall"></div>
            	</div>
            	<div id="wBall_2" class="wBall">
            		<div class="wInnerBall"></div>
            	</div>
            	<div id="wBall_3" class="wBall">
            		<div class="wInnerBall"></div>
            	</div>
            	<div id="wBall_4" class="wBall">
            		<div class="wInnerBall"></div>
            	</div>
            	<div id="wBall_5" class="wBall">
            		<div class="wInnerBall"></div>
            	</div>
        	</div>

        	<!-- background for book -->  
        	<div class="fb7-bcg-book"></div>               

        	<!-- BEGIN CONTAINER BOOK -->
        	<div id="fb7-container-book">

          		<!-- BEGIN deep linking -->
          		<section id="fb7-deeplinking">
		     		<ul>
		        		<li data-address="page1" data-page="1"></li>
		        		<% 
		            	for(int i = 2; i <= (images.length * 2 - 1); i += 2) {
		                	String pageRange = "page" + i + "-page" + (i + 1);
		        		%>
		        		<li data-address="<%=pageRange %>" data-page="<%=i %>"></li>
		        		<li data-address="<%=pageRange %>" data-page="<%=i + 1 %>"></li>
		        		<%} %>
		     		</ul>
		  		</section>
          		<!-- END deep linking -->

          		<!-- BEGIN ABOUT -->
          		<section id="fb7-about">
          		</section>
          		<!-- END ABOUT -->

          		<!-- BEGIN PAGES -->
          		<div id="fb7-book">

            		<!-- BEGIN PAGE 1 -->
            		<div style="background-image:url(<%=app_fetchpath + "/" + page_code + "/" + lang + "/" + images[0] %>)" class="fb7-noshadow">
	
              			<!-- begin container page book -->
              			<div class="fb7-cont-page-book">

	                		<!-- description for page -->
	                		<div class="fb7-page-book">
	
	                		</div>
	
	              		</div>
              			<!-- end container page book -->

            		</div>
            		<!-- END PAGE 1 -->

					<%for(int j = 1; j < images.length; j++) { %>
	           		<!-- BEGIN PAGE 2 -->
            		<div style="background-image:url(<%=app_fetchpath + "/" + page_code + "/" + lang + "/" + images[j] %>)" class="fb7-double fb7-first fb7-noshadow">

              			<!-- begin container page book -->
              			<div class="fb7-cont-page-book">

                			<!-- description for page  -->
                			<div class="fb7-page-book">

                			</div>

                			<!-- begin number page -->
                			<div class="fb7-meta">
                  				<span class="fb7-num"><%=j * 2 %></span>
                			</div>
                			<!-- end number page -->

              			</div>
              			<!-- end container page book -->

            		</div>
            		<!-- BEGIN PAGE 2 -->
            
            		<div style="background-image:url(<%=app_fetchpath + "/" + page_code + "/" + lang + "/" + images[j] %>)" class="fb7-double fb7-second fb7-noshadow">

              			<!-- begin container page book -->
              			<div class="fb7-cont-page-book">

                			<!-- description for page  -->
                			<div class="fb7-page-book">

                			</div>

                			<!-- begin number page -->
                			<div class="fb7-meta">
                  				<span class="fb7-num"><%=(j * 2) + 1 %></span>
                			</div>
                			<!-- end number page -->

              			</div>
              			<!-- end container page book -->

            		</div>            
            		<!-- END PAGE 2 -->
					<%} %>

          		</div>
          		<!-- END PAGES -->

          		<!-- arrows -->
          		<a class="fb7-nav-arrow prev"></a>
          		<a class="fb7-nav-arrow next"></a>

          		<!-- shadow -->
          		<div class="fb7-shadow"></div>

        	</div>
        	<!-- END CONTAINER BOOK -->

        	<!-- BEGIN FOOTER -->
        	<div id="fb7-footer">

            	<div class="fb7-bcg-tools"></div>
            
            	<div class="fb7-menu" id="fb7-center">
                	<ul>

                    	<!-- icon home -->
                    	<li>
                      		<a title="Go Home" class="fb7-home_icon" href="../../home.jsp?lang=<%=lang %>">
                        		<img src="images/house_icon.svg" alt="" srcset="" />
                      		</a>
                    	</li>

                    	<!-- icon download -->
                    	<li>
                        	<a title="Pdf File Or Zip" class="fb7-download" href="<%=app_fetchpath + "/" +page_code + "/" + lang + "/" + fd.getString("fd_file") %>">
                          		<img src="images/download_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<!-- icon_zoom_in -->                         
                    	<li>
                        	<a title="Zoom In" class="fb7-zoom-in">
                          		<img src="images/zoom_in_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<!-- icon_zoom_out -->                 
                    	<li>
                        	<a title="Zoom Out" class="fb7-zoom-out">
                          		<img src="images/zoom_out_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<!-- icon_zoom_auto -->
                    	<li>
                        	<a title="Zoom Auto" class="fb7-zoom-auto">
                          		<img src="images/zoom_auto_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<!-- icon_zoom_original -->
                    	<li>
                        	<a title="Zoom Original (Scale 1:1)" class="fb7-zoom-original">
                          		<img src="images/zoom_original_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<!-- icon_allpages -->
                    	<li>
                        	<a title="Show All Pages " class="fb7-show-all"> 
                          		<img src="images/book_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<!-- icon fullscreen -->                 
                    	<li>
	                        <a title="Full / Normal Screen" class="fb7-fullscreen">
                          		<img src="images/arrows_fullscreen_icon.svg" alt="" srcset="" />
                        	</a>
                    	</li>

                    	<div class="clearfloat">
                    	</div>
                	</ul>
            	</div>

            	<div class="fb7-menu" id="fb7-right">
                	<ul>                              
                    	<!-- icon page manager -->                 
                    	<li class="fb7-goto">
	                        <label for="fb7-page-number" id="fb7-label-page-number"></label>
                        	<input type="text" id="fb7-page-number" />
                        	<button type="button">Go</button>
                    	</li>
                	</ul>
            	</div>     

        	</div>
        	<!-- END FOOTER -->

        	<!-- BEGIN THUMBS -->
        	<div id="fb7-all-pages" class="fb7-overlay" >

          		<section class="fb7-container-pages">

            		<div id="fb7-menu-holder">
    
                		<ul id="fb7-slider">
				  			<%for(int k=0; k<images.length; k++){ %>
                  			<!-- PAGE 1 - THUMB -->
                  			<li class="<%=(k*2)+1 %>">
                    			<img alt="" src="<%=app_fetchpath + "/" +page_code+ "/" + lang + "/" + images[k] %>" />
                  			</li>
				  			<%} %>
                		</ul>

            		</div>

        		</section>

       		</div>
        	<!-- END THUMBS -->

   		</div>
    	<!-- END HTML BOOK -->    

	</div>
	<!-- END FLIPBOOK STRUCTURE --> 

	<!-- CONFIGURATION FLIPBOOK -->    
	<script>
		jQuery('#fb7-ajax').data('config',
	    {
			"page_width":"640",
			"page_height":"920",
			"go_to_page":"Page",
			"gotopage_width":"45",
			"zoom_double_click":"1",
			"zoom_step":"0.06",
			"tooltip_visible":"true",
			"toolbar_visible":"true",
			"deeplinking_enabled":"true",
			"double_click_enabled":"true",
			"rtl":"false"
	     })
	</script>
</body>
</html>