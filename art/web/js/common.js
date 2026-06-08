// JavaScript共用區
//20160921 by kevin

	var winHeight    = $(window).height();          //螢幕高度
	var win_W		 = $(window).width();			//螢幕寬度
	var hederHeight  = $(".header").innerHeight();;	//版頭高度
	var footerHeight = $(".footer").innerHeight();;	//版腳高度

	//浮動式top鍵
	$(window).load(function(){
		$(window).bind('scroll resize', function(){
			var $this = $(this);
			var $this_Top=$this.scrollTop();

			//距離底部
			var $this_Bottom =
				$(document).height() -
				($this.scrollTop() + $this.height());
			
			//當高度小於100時，關閉區塊 
			if($this_Top < 100){
				$('.topBtn').stop().animate({bottom:"-70px"});
			}
			if($this_Top > 100){
				// if(window.innerWidth > 1180){
				// 	$('.topBtn').stop().animate({bottom:"170px"});
				// }else{
				// 	$('.topBtn').stop().animate({bottom:"235px"});
				// }	
				
				
				if($("html").hasClass("zoom-175")){
					// $('.topBtn').stop().animate({bottom:"20px"});
				}
				if($("html").hasClass("zoom-200")){
					// $('.topBtn').stop().animate({bottom:"20px"});
				}
				if($("html").hasClass("zoom-250")){
					// $('.topBtn').stop().animate({bottom:"20px"});
				}
				if($("body").hasClass("zoom-300")){
					// $('.topBtn').stop().animate({bottom:"10px"});
				}
				if($("body").hasClass("zoom-400")){
					// $('.topBtn').stop().animate({bottom:"10px"});
				}
			}
			

			//當高度小於100時，關閉區塊 
			if($this_Top < 100){
				// $('.social_btn_area').stop().animate({bottom:"30px"});
			}
			if($this_Top > 100){				
				if(window.innerWidth > 1180){
					// $('.social_btn_area').stop().animate({bottom:"210px"});
				}else{
					// $('.social_btn_area').stop().animate({bottom:"275px"});
				}


				if($("body").hasClass("zoom-175")){
					// $('.social_btn_area').stop().animate({bottom:"65px"});
				}
				if($("body").hasClass("zoom-200")){
					// $('.social_btn_area').stop().animate({bottom:"65px"});
				}
				if($("body").hasClass("zoom-250")){
					// $('.social_btn_area').stop().animate({bottom:"65px"});
				}
				if($("body").hasClass("zoom-300")){
					// $('.social_btn_area').stop().animate({bottom:"47px"});
				}
				if($("body").hasClass("zoom-400")){
					// $('.social_btn_area').stop().animate({bottom:"47px"});
				}

			}
			
			//當高度小於100時，關閉區塊 
			if($this_Top < 100){
				$('.fiexdRight').stop().animate({bottom:"55px"});


				if($("html").hasClass("zoom-175")){
					$('.fiexdRight').stop().animate({bottom:"127px"});
				}
				if($("html").hasClass("zoom-200")){
					$('.fiexdRight').stop().animate({bottom:"20px"});
				}
				if($("html").hasClass("zoom-250")){
					$('.fiexdRight').stop().animate({bottom:"20px"});
				}
				if($("html").hasClass("zoom-300")){
					$('.fiexdRight').stop().animate({bottom:"20px"});
				}
				if($("html").hasClass("zoom-400")){
					$('.fiexdRight').stop().animate({bottom:"20px"});
				}

			}
			if($this_Top > 100){
				$('.fiexdRight').stop().animate({bottom:"127px"});

				if($("html").hasClass("zoom-175")){
					$('.fiexdRight').stop().animate({bottom:"55px"});
				}
				if($("html").hasClass("zoom-200")){
					$('.fiexdRight').stop().animate({bottom:"4px"});
				}
				if($("html").hasClass("zoom-250")){
					$('.fiexdRight').stop().animate({bottom:"4px"});
				}
				if($("html").hasClass("zoom-300")){
					$('.fiexdRight').stop().animate({bottom:"4px"});
				}
				if($("html").hasClass("zoom-400")){
					$('.fiexdRight').stop().animate({bottom:"4px"});
				}
			}				
			
			
			//當視窗卷軸滑動時，版頭下緣陰影會有顯示、隱藏的動作
			//當高度小於55時，關閉區塊 
			if($this_Top < 55){
				$('.header').stop().removeClass("fixed");
			}
			if($this_Top > 55){
				$('.header').stop().addClass("fixed");
			}


			//當視窗卷軸滑動時，版頭下緣陰影會有顯示、隱藏的動作
			//當高度小於55時，關閉區塊 
			if($this_Bottom < 600){
				$('.body_home .topBtn').stop().addClass("fixed");
			}
			if($this_Bottom > 600){
				$('.body_home .topBtn').stop().removeClass("fixed");
			}
			
			if(window.innerWidth > 1024){
				if($this_Bottom < 1200){
					$('.body_in .topBtn').stop().addClass("fixed");
				}
				if($this_Bottom > 1200){
					$('.body_in .topBtn').stop().removeClass("fixed");
				}
			}else{
				if($this_Top < 45){
					$('.body_in .topBtn').stop().removeClass("fixed");
				}
				if($this_Top > 45){
					$('.body_in .topBtn').stop().addClass("fixed");
				}

				console.log("$this_Top"+$this_Top)
			}


			


		}).scroll();
	});
	
	//錨點平滑滾動效果
	$(function(){
		$('a[href*=#]').click(function() {
			if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
				var $target = $(this.hash);
				$target = $target.length && $target || $('[name=' + this.hash.slice(1) + ']');
				if ($target.length) {
					var targetOffset = $target.offset().top;
					$('html,body').animate({
						scrollTop: targetOffset
					},
					1000);
					return false;
				}
			}
		});
	});
	

	
	//----------------------------------將主體添加最小高度 讓footer置底----------------------------------
	
	let lastWindowWidth = window.innerWidth;
	let resizeTimer;
	let periodicTimer;
	let periodicCounter = 0;
	const periodicInterval = 1200; // 每 1.2 秒
	const periodicLimit = 5000;    // 最多跑 5 秒

	function fixMainPadding() {
		window.requestAnimationFrame(() => {
			const header = document.querySelector('.header');
			const footer = document.querySelector('.footer');
			const main = document.querySelector('.main');
			//const pageContent = document.querySelector('.pageContent');
			//const left_bg = document.querySelector('.left_bg');
			//const right = document.querySelector('.right');
			
			const inMain = document.querySelector('.inMain');
			 

			// ✅ 安全檢查
			if (!header || !footer || !main) {
				//console.warn("⛔ 無法執行 fixMainPadding：元素缺失");
				return;
			}

			const headerHeight = header.offsetHeight;
			const footerHeight = footer.offsetHeight;
			const mainPaddingTop = parseInt(getComputedStyle(main).paddingTop) || 0;
			
			//console.log(`📏 headerHeight: ${headerHeight}, main paddingTop: ${mainPaddingTop}`);

			// ✅ 設定 main 的 min-height
			main.style.minHeight = (window.innerHeight - headerHeight - footerHeight) + 'px';

			// ✅ 修正 paddingTop
			if (Math.abs(mainPaddingTop - headerHeight) > 1) {

				if (main) {	
					main.style.marginTop = headerHeight + 'px';	
				} 
			}
			
			// ✅ navbar 補判斷
			const currentWidth = window.innerWidth;

		});
	}

	// ✅ 初始安全三連發（避免 header 沒出來）
	window.addEventListener('load', () => {
		fixMainPadding();                // 立即一次
		setTimeout(fixMainPadding, 100); // 100ms 再補一次
		setTimeout(fixMainPadding, 300); // 300ms 再補一次
	});

	// ✅ resize 補強邏輯（每 1.2 秒跑一次，最多 5 秒）
	window.addEventListener('resize', () => {
		clearTimeout(resizeTimer);
		resizeTimer = setTimeout(() => {
			const currentWidth = window.innerWidth;

			const crossedBreakpoint =
				(lastWindowWidth <= 860 && currentWidth > 860) ||
				(lastWindowWidth > 860 && currentWidth <= 860);

			if (crossedBreakpoint) {
				//console.log("⚠️ 斷點跨越：補跑一次修正");
				fixMainPadding();
				setTimeout(fixMainPadding, 100);
			}

			lastWindowWidth = currentWidth;
			fixMainPadding();

			// ✅ 開始 5 秒內每 1.2 秒補一次
			if (periodicTimer) clearInterval(periodicTimer);
			periodicCounter = 0;

			periodicTimer = setInterval(() => {
				periodicCounter += periodicInterval;
				//console.log(`⏱ 自動補修正 fixMainPadding() @ ${periodicCounter / 1000}s`);
				fixMainPadding();

				if (periodicCounter >= periodicLimit) {
					clearInterval(periodicTimer);
					//console.log("✅ 自動補修正結束");
				}
			}, periodicInterval);
		}, 100);
	});

	
	
	
	
	
	
	
	
	
	
	
	// function mainH() {
	// 	winHeight    = $(window).height();
	// 	hederHeight  = $(".header").innerHeight();
	// 	footerHeight = $(".footer").innerHeight();
		
	// 	$(".main").css({
	// 		'min-height': winHeight-hederHeight-footerHeight-0+'px',		//"-30"這要隨每個案子不同調整
	// 		'padding-top': hederHeight-0+'px'
	// 	})
	// }
	
	// mainH();
	
	// setTimeout(function(){
	// 	mainH();
	// },300)
	
	// $(window).on("resize scroll", function (e) {
	// 	setTimeout(function(){
	// 		mainH();
	// 	},300)
	// });

	// $(window).resize(function(e) {
	// 	setTimeout(function(){
	// 		mainH();
	// 	},300)
	// });
	








	//----------------------------------錨點偏移計算----------------------------------
	function adjustScrollMargin() {
		const headerHeight = $(".header").innerHeight() || 0;
		const isMobile = $(window).width() <= 860;
	
		//const isSamePage = $(".about_bg").length > 0 || $(".contact_bg").length > 0 || $(".serv_info_bg").length > 0 || $(".mainContent").length > 0;
		const isSamePage = $(".pageContent").length > 0;

		if (isSamePage) {
			// 本頁：使用 transform 位移
			$(".id_offset").css({
				'transform': 'translateY(-' + headerHeight + 'px)',
				'scroll-margin-top': ''
			});
			$(".id_offset2").css({
				'transform': 'translateY(-' + (isMobile ? headerHeight * 1.5 : headerHeight) + 'px)',
				'scroll-margin-top': ''
			});
			$(".id_offset3").css({
				'transform': 'translateY(-' + (isMobile ? headerHeight * 1.5 : headerHeight) + 'px)',
				'scroll-margin-top': ''
			});
		} else {
			// 跨頁：使用 scroll-margin-top 修正錨點跳轉位置
			$(".id_offset").css({
				'transform': '',
				'scroll-margin-top': headerHeight + 'px'
			});
			$(".id_offset2").css({
				'transform': '',
				'scroll-margin-top': (isMobile ? headerHeight * 1.5 : headerHeight) + 'px'
			});
			// 留空，讓 .id_offset3 用 forceScrollToHashTarget 處理滾動
		}
	}
	
	

	function forceScrollToHashTarget() {
		const hash = window.location.hash;
	
		if (hash && $(hash).length) {
			setTimeout(function () {
				const $target = $(hash);
				const headerHeight = $(".header").innerHeight() || 0;
				const isMobile = window.innerWidth <= 860;   //$(window).width() <= 1180;

				let offset = headerHeight;
				if ($target.hasClass("id_offset2")) {
					offset = isMobile ? headerHeight * 1.5 : headerHeight;
				} else if ($target.hasClass("id_offset3")) {
					offset = isMobile ? headerHeight * 1.5 : headerHeight;
				}
	
				const correction = 12;
				const top = $target.offset().top - offset + headerHeight - correction;
	
				$('html, body').stop().animate({ scrollTop: top }, 500);
			}, 200);
		}
	}
	
	$(window).on("load resize scroll", function () {
		clearTimeout(window._adjustTimer);
		window._adjustTimer = setTimeout(adjustScrollMargin, 300);
	});
	
	$(window).on("load", function () {
		adjustScrollMargin();       // 頁面進來時先套好樣式
		forceScrollToHashTarget();  // 再滑順滾動到 hash 位置
	});









	//----------------------------------手機版主按鍵收合----------------------------------
	$(function () {

	// function setMenu(open) {
	// 	$(".menu_btn")
	// 	.toggleClass("active", open)
	// 	.attr("aria-expanded", open ? "true" : "false");

	// 	$(".header_right_bg").toggleClass("active", open);
	// 	$("body").toggleClass("active", open);
	// }



	// function setMenu(open) {
	// 	$(".menu_btn")
	// 		.toggleClass("active", open)
	// 		.attr("aria-expanded", open ? "true" : "false");

	// 	$(".header_right_bg").toggleClass("active", open);
	// 	$("body").toggleClass("active", open);

	// 	// ✅ ✅ ✅ 新增：開/關後重排 tabindex（讓 isExpanded 生效）
	// 	if (typeof setTabIndex === "function") setTabIndex();

	// 	// ✅ ✅ ✅ 新增：開啟後把焦點導入選單第一個項目
	// 	if (open) {
	// 		setTimeout(() => {
	// 		const el = document.querySelector("#search_input_MB, #search_btn_MB, #headerMenu .navbar a, #donate_icon");
	// 		if (el) el.focus();
	// 		}, 0);
	// 	} else {
	// 		// (可選) 關閉後把焦點回到漢堡，鍵盤體驗更好
	// 		// setTimeout(() => document.querySelector(".menu_btn")?.focus(), 0);
	// 	}
	// }


	
	function setMenu(open) {
		$(".menu_btn")
			.toggleClass("active", open)
			.attr({
				"aria-expanded": open ? "true" : "false",
				"aria-label": open ? "開啟主選單" : "關閉主選單"
			});
			//.attr("aria-expanded", open ? "true" : "false");

		$(".header_right_bg").toggleClass("active", open);
		$("body").toggleClass("active", open);

		// ✅ 狀態改變後：重排 tabindex
		if (typeof setTabIndex === "function") setTabIndex();

		// ✅ 開啟後：導入焦點到第一個
		if (open) {
			setTimeout(() => {
			const first = document.querySelector("#search_input_MB, #search_btn_MB, #headerMenu .navbar a, #donate_icon");
			first?.focus();
			}, 0);
		}
	}


	
	function toggleMenu() {
		const isOpen = $(".menu_btn").hasClass("active");
		setMenu(!isOpen);
	}

	// 滑鼠/觸控
	$(".menu_btn").on("click", function (e) {
		toggleMenu();
		e.stopPropagation();
	});

	// 鍵盤：只處理 Space 防捲，其餘交給 button 原生行為
	$(".menu_btn").on("keydown", function (e) {
		if (e.key === " ") {
			e.preventDefault();
			$(this).trigger("click");
		}
	});

	$(window).on("resize", function () {
		if ($(window).width() > 860) setMenu(false);
	});

	$(".header_right_bg").on("click", function (e) {
		e.stopPropagation();
	});

	$(window).on("click", function () {
		setMenu(false);
	});

	});



	




//----------------------------------無障礙主按鍵收合----------------------------------

$(function () {
    var win_W = $(window).width();

    function setButtonState($btn, isExpanded) {
        $btn.attr("aria-expanded", isExpanded ? "true" : "false");
        $btn.attr("aria-label", isExpanded ? "收合選單" : "展開選單");
        $btn.find(".detection_aa").text(isExpanded ? "收合" : "展開");
    }

    function closeOtherMenus($currentBtn) {
        $(".nav.arrow").find(".arrow_down").not($currentBtn).each(function () {
            var $btn = $(this);
            var $nav = $btn.closest(".nav.arrow");
            var $panel = $nav.find(".navOpen");

            $panel.stop(true, true).slideUp("fast");
            setButtonState($btn, false);
        });
    }

    function toggleCurrentMenu($btn) {
        var $nav = $btn.closest(".nav.arrow");
        var $panel = $nav.find(".navOpen");
        var isExpanded = $btn.attr("aria-expanded") === "true";

        closeOtherMenus($btn);

        if (isExpanded) {
            $panel.stop(true, true).slideUp("fast");
            setButtonState($btn, false);
        } else {
            $panel.stop(true, true).slideDown("fast");
            setButtonState($btn, true);
        }
    }

    // 初始狀態統一設為收合
    $(".nav.arrow").find(".arrow_down").each(function () {
        setButtonState($(this), false);
    });

	if (win_W > 860) {

		$(".nav.arrow").find(".arrow_down").on("click keydown", function (e) {

			if (
				e.type === "click" ||
				e.key === "Enter" ||
				e.key === " "
			) {
				e.preventDefault();
				e.stopPropagation();

				toggleCurrentMenu($(this));
			}
		});

		$(".navOpen").on("click focus", function (e) {
			e.stopPropagation();
		});

		// 點擊外部收合
		$(window).on("click", function () {

			$(".nav.arrow").find(".arrow_down").each(function () {

				var $btn = $(this);
				var $nav = $btn.closest(".nav.arrow");
				var $panel = $nav.find(".navOpen");

				$panel.stop(true, true).slideUp("fast");
				setButtonState($btn, false);

			});

		});

	} else {


		$(".nav.arrow").find(".arrow_down").on("click keydown", function (e) {

			if (
				e.type === "click" ||
				e.key === "Enter" ||
				e.key === " "
			) {
				e.preventDefault();
				e.stopPropagation();

				toggleCurrentMenu($(this));
				console.log("打開下一層");
			}
		});

		$(".navOpen").on("click", function (e) {
			e.stopPropagation();
		});

		$(window).on("click", function () {
			$(".nav.arrow").find(".arrow_down").each(function () {
				var $btn = $(this);
				var $nav = $btn.closest(".nav.arrow");
				var $panel = $nav.find(".navOpen");

				$panel.stop(true, true).slideUp("fast");
				setButtonState($btn, false);
			});
		});
    }
});







//----------------------------------無障礙主按鍵收合(不用enter直接展開)----------------------------------

// $(function () {
//     var win_W = $(window).width();

//     function setButtonState($btn, isExpanded) {
//         $btn.attr("aria-expanded", isExpanded ? "true" : "false");
//         $btn.attr("aria-label", isExpanded ? "收合選單" : "展開選單");
//         $btn.find(".detection_aa").text(isExpanded ? "收合" : "展開");
//     }

//     function closeOtherMenus($currentBtn) {
//         $(".nav.arrow").find(".arrow_down").not($currentBtn).each(function () {
//             var $btn = $(this);
//             var $nav = $btn.closest(".nav.arrow");
//             var $panel = $nav.find(".navOpen");

//             $panel.stop(true, true).slideUp("fast");
//             setButtonState($btn, false);
//         });
//     }

//     function toggleCurrentMenu($btn) {
//         var $nav = $btn.closest(".nav.arrow");
//         var $panel = $nav.find(".navOpen");
//         var isExpanded = $btn.attr("aria-expanded") === "true";

//         closeOtherMenus($btn);

//         if (isExpanded) {
//             $panel.stop(true, true).slideUp("fast");
//             setButtonState($btn, false);
//         } else {
//             $panel.stop(true, true).slideDown("fast");
//             setButtonState($btn, true);
//         }
//     }

//     // 初始狀態統一設為收合
//     $(".nav.arrow").find(".arrow_down").each(function () {
//         setButtonState($(this), false);
//     });

//     if (win_W > 860) {
//         // 桌機：focus 展開
//         $(".nav.arrow").find(".arrow_down").on("focus", function (e) {
//             var $btn = $(this);
//             var $nav = $btn.closest(".nav.arrow");
//             var $panel = $nav.find(".navOpen");

//             closeOtherMenus($btn);
//             $panel.stop(true, true).slideDown("fast");
//             setButtonState($btn, true);

//             e.stopPropagation();
//         });

//         $(".navOpen").on("click focus", function (e) {
//             e.stopPropagation();
//         });

//     } else {
//         // 手機：click 開關
//         $(".nav.arrow").find(".arrow_down").on("click", function (e) {
//             toggleCurrentMenu($(this));
//             e.stopPropagation();
//         });

//         $(".navOpen").on("click", function (e) {
//             e.stopPropagation();
//         });

//         $(window).on("click", function () {
//             $(".nav.arrow").find(".arrow_down").each(function () {
//                 var $btn = $(this);
//                 var $nav = $btn.closest(".nav.arrow");
//                 var $panel = $nav.find(".navOpen");

//                 $panel.stop(true, true).slideUp("fast");
//                 setButtonState($btn, false);
//             });
//         });
//     }
// });


//.closest()（往上找最近符合的元素）和 .find()（往下找所有符合的子元素）




	



//----------------------------------手機板左選單收合(無障礙)----------------------------------
$(function () {
    var breakpoint = 1024;
    var mobile_left = false;

    var $btn = $(".left_title_mobile");
    var $menu = $(".leftListArea");

    function openMenu() {
        $(".left_title").addClass("active");
        $btn.attr({
            "aria-expanded": "true",
            "aria-label": "收合分類項目選單"
        });
        $menu.stop(true, true).slideDown("slow");
        $("body").addClass("active");
    }

    function closeMenu() {
        $(".left_title").removeClass("active");
        $btn.attr({
            "aria-expanded": "false",
            "aria-label": "展開分類項目選單"
        });
        $menu.stop(true, true).slideUp("slow");
        $("body").removeClass("active");
    }

    function toggleMenu() {
        var isOpen = $btn.attr("aria-expanded") === "true";

        if (isOpen) {
            closeMenu();
        } else {
            openMenu();
        }
    }

    // button 的 click 本身支援滑鼠、Enter、Space
    $btn.on("click", function (e) {
        if ($(window).width() <= breakpoint) {
            toggleMenu();
            e.stopPropagation();
        }
    });

    // 初始判斷
    $(window).on("load", function () {
        if ($(window).width() <= breakpoint) {
            mobile_left = true;
            closeMenu();
        } else {
            $menu.show();
            $btn.attr({
                "aria-expanded": "true",
                "aria-label": "分類項目選單"
            });
        }
    });

    // resize 判斷
    $(window).on("resize", function () {
        if ($(window).width() > breakpoint) {
            $(".left_title").removeClass("active");
            $menu.stop(true, true).show();
            $("body").removeClass("active");

            $btn.attr({
                "aria-expanded": "true",
                "aria-label": "分類項目選單"
            });

            mobile_left = false;
        } else {
            if (!mobile_left) {
                closeMenu();
            }
            mobile_left = true;
        }
    });
});








//----------------------------------手機板左選單收合(無障礙)----------------------------------
// $(function () {
//     var breakpoint = 1024;
//     var mobile_left = false;

//     var $leftTitle = $(".left_title");
//     var $btn = $(".left_title_mobile");
//     var $menu = $(".leftListArea");

//     function openMenu() {
//         $leftTitle.addClass("active");
//         $("body").addClass("active");

//         $btn.attr({
//             "aria-expanded": "true",
//             "aria-label": "收合分類項目選單"
//         });
//     }

//     function closeMenu() {
//         $leftTitle.removeClass("active");
//         $("body").removeClass("active");

//         $btn.attr({
//             "aria-expanded": "false",
//             "aria-label": "展開分類項目選單"
//         });
//     }

//     function resetPcMenu() {
//         $leftTitle.removeClass("active");
//         $("body").removeClass("active");

//         $menu.css("display", "flex");

//         $btn.attr({
//             "aria-expanded": "true",
//             "aria-label": "分類項目選單"
//         });

//         mobile_left = false;
//     }

//     function resetMobileMenu() {
//         $menu.removeAttr("style");
//         closeMenu();
//         mobile_left = true;
//     }

//     // button 原生支援滑鼠 click、鍵盤 Enter、Space
//     $btn.on("click", function (e) {
//         if ($(window).width() <= breakpoint) {
//             var isOpen = $leftTitle.hasClass("active");

//             if (isOpen) {
//                 closeMenu();
//             } else {
//                 openMenu();
//             }

//             e.stopPropagation();
//         }
//     });

//     $(window).on("load", function () {
//         if ($(window).width() <= breakpoint) {
//             resetMobileMenu();
//         } else {
//             resetPcMenu();
//         }
//     });

//     $(window).on("resize", function () {
//         if ($(window).width() > breakpoint) {
//             resetPcMenu();
//         } else {
//             if (!mobile_left) {
//                 resetMobileMenu();
//             }
//         }
//     });
// });

	

//----------------------------------手機板左選單收合----------------------------------
// $(function(){
// 	$(".left_title").click(function(e) {		
// 		if ( $(window).width() <= 1024 ) { // Eric修改-手機版時才有收合效果 860隨每個案子修改
// 			$(this).toggleClass("active");
			
// 			$(".leftListArea").slideToggle("slow");
// 			$("body").toggleClass("active");
// 			e.stopPropagation();
// 		}else{
// 			$(".leftListArea").removeAttr();
// 		}
// 	});
	

// 	//  Eric 20190529修改 判斷當前左選單是否為手機版
// 	var mobile_left = false;
// 	$(window).load(function(){
// 		if ( $(window).width() <= 1024 ) { 
// 			mobile_left = true;
// 		}
// 	});
// 	// Eric 20180314 返回pc時 左選單選單回覆展開狀態 20190529修改
// 	$(window).resize(function(e) {
// 		//  860隨每個案子修改
// 		if ( $(window).width() > 1180 ) { 
// 			$(".left_title").removeClass("active");
// 			$(".leftListArea").show();
// 			$("body").removeClass("active");
// 			mobile_left = false;
// 		}
// 		// Eric修改-手機版時才有收合效果 767隨每個案子修改 
// 		if ( $(window).width() <= 1180) { 
// 			if(!mobile_left){ // Eric 20190529 增加判斷當前左選單是否為手機版
// 				$(".leftListArea").hide();
// 			}
// 			mobile_left = true;
// 			/*$(this).toggleClass("active");*/
// 			/*$(".leftListArea").slideToggle("slow");*/
// 			/*$("body").toggleClass("active");*/
// 		}
// 		e.stopPropagation();
// 	});


// });





//----------------------------------左選單第二層收合----------------------------------
$(function(){
	$(".leftList").children(".leftList_title").click(function(e) {
		$(".leftList").children(".leftList_title").not(this).parent(".leftList").removeClass("active");
		$(this).parent(".leftList").toggleClass("active");

		$(".leftList").children(".leftList_title").not(this).siblings(".leftList_open").slideUp();
		$(this).siblings(".leftList_open").slideToggle();
	});
})





//----------------------------------左選單第三層收合----------------------------------
$(function(){
	$(".leftList_sec_title").click(function(e) {			
		//$(".leftList_sec_title").not(this).removeClass("active");
		$(".leftList_sec_title").parent().parent().siblings().find('.leftList_sec_title').not(this).removeClass("active");
		$(this).toggleClass("active");
		
		$(".leftList_sec_title").not(this).siblings(".leftList_third_area").slideUp();
		$(this).siblings(".leftList_third_area").slideToggle();
	});
})






//----------------------------------左選單第二層收合----------------------------------
// $(function(){
// 	$(".leftList").children("a").click(function(e) {
// 		$(".leftList").children("a").not(this).parent(".leftList").removeClass("active");
// 		$(this).parent(".leftList").toggleClass("active");
		
// 		$(".leftList").children("a").not(this).siblings(".leftList_open").slideUp();
// 		$(this).siblings(".leftList_open").slideToggle();
// 	});
// })	







	




//----------------------------------footer主按鍵收合效果----------------------------------
$(document).ready(function(e) {

	$(".footer_left .footer_nav").click(function(e) {
		var win_W = $(window).width(); // 螢幕寬度
		if (window.innerWidth <= 768) {
			var $thisNav = $(this).children(".fR_nav_Area");

			if ($(this).hasClass("active")) {
				$thisNav.stop(true, true).slideUp(300, function() {
					$thisNav.css("display", "none"); // 確保收起來
				});
				$(this).removeClass("active");
			} else {
				// 收起其他區塊
				$(".footer_left .footer_nav").not(this).children(".fR_nav_Area").slideUp(300, function() {
					$(this).css("display", "none");
				});
				$(".footer_left .footer_nav").not(this).removeClass("active");

				// 展開當前區塊並強制 display: flex
				$thisNav.stop(true, true)
					.css("display", "flex") // 先設定 flex
					.hide().slideDown(300); // 用 slideDown 顯示動畫

				$(this).addClass("active");
			}
		}
	});
});

$(window).resize(function(e) {
	if (window.innerWidth >= 768) {
		$(".footer_left .fR_nav_Area").removeAttr("style");
		$(".footer_left .footer_nav").removeClass("active");
	}
});


		
	
	
//----------------------------------右側浮動廣告收合20260326----------------------------------
 $(function(){

	// $(".fixedRightZoom").click(function(e) {
	// 	$(".fixedRightZoom, .fiexdRight_img").toggleClass("active");
	// });

	// 支援滑鼠 + 鍵盤開啟 右側浮動
	// $(".fixedRightZoom").on("click keydown", function (e) {
	// 	if (e.type === "click" || e.key === "Enter" || e.key === " " || e.keyCode === 13 || e.keyCode === 32) {
	// 		$(".fixedRightZoom, .fiexdRight_img").toggleClass("active");
	// 	}
	// });


	// const zoomBtn = document.querySelector('.fixedRightZoom');
	// const fixedRightBox = document.querySelector('.fiexdRight_img');
	// const donatePanel = document.querySelector('#donatePanel');

	// function setDonatePanel(open) {
	// 	zoomBtn.classList.toggle('active', open);
	// 	fixedRightBox.classList.toggle('active', open);

	// 	zoomBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
	// 	zoomBtn.setAttribute(
	// 		'aria-label',
	// 		open ? '開啟捐款支持選單' : '關閉捐款支持選單'
	// 	);

	// 	if (donatePanel) {
	// 		donatePanel.hidden = !open;
	// 	}
	// }

	// zoomBtn?.addEventListener('click', () => {
	// 	const isOpen = zoomBtn.getAttribute('aria-expanded') === 'true';
	// 	setDonatePanel(!isOpen);
	// });



	const zoomBtn = document.querySelector('.fixedRightZoom');
	const zoomBtn_in = document.querySelector('.fixedRightZoom span');
	const fixedRightBox = document.querySelector('.fiexdRight_img');
	const donatePanel = document.querySelector('#donatePanel');

	function setDonatePanel(open) {
		zoomBtn.classList.toggle('active', !open);
		fixedRightBox.classList.toggle('active', !open);

		zoomBtn_in.setAttribute('aria-hidden', open ? 'true' : 'false');
		zoomBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
		zoomBtn.setAttribute(
			'aria-label',
			open ? '開啟捐款支持選單' : '關閉捐款支持選單'
		);

		if (donatePanel) {
			donatePanel.hidden = !open;
		}
	}

	zoomBtn?.addEventListener('click', () => {
		const isOpen = zoomBtn.getAttribute('aria-expanded') === 'true';
		setDonatePanel(!isOpen);
	});


})	






//----------------------------------測試時隱藏連結用----------------------------------
$(function(){
	//$(".nav a:first").attr("href" , "javascript:void(0)");
	// $(".mLI_btn input").attr("onclick" , "location='javascript:void(0)'");
});	
 











document.addEventListener('DOMContentLoaded', function() {

    // 取得 html
    var htmlstyle = document.querySelector("html");

    // 使用者資訊
    var userAgent = navigator.userAgent;

    //----------------------------------
    // 作業系統
    //----------------------------------

    // Mac
    if (userAgent.indexOf('Mac OS X') !== -1) {
        htmlstyle.classList.add('macBrowser');
    } else {
        htmlstyle.classList.add('winBrowser');
    }

    //----------------------------------
    // iPhone + Safari
    //----------------------------------

    if (
        userAgent.indexOf('iPhone') !== -1 &&
        userAgent.indexOf('Safari') !== -1 &&
        userAgent.indexOf('Chrome') === -1
    ) {
        htmlstyle.classList.add('iPhoneSafariBrowser');
    }

    //----------------------------------
    // Android 內建瀏覽器
    //----------------------------------

    if (
        userAgent.indexOf('Android') !== -1 &&
        userAgent.indexOf('Chrome') === -1
    ) {
        htmlstyle.classList.add('AndroidDefaultBrowser');
    }

    //----------------------------------
    // 手機裝置判斷
    //----------------------------------

    if (
        /Android|iPhone|iPad|iPod|Mobile/i.test(userAgent)
    ) {
        htmlstyle.classList.add('mobileDevice');
    } else {
        htmlstyle.classList.add('pcDevice');
    }

});

//----------------------------------獲取瀏覽器種類----------------------------------

// document.addEventListener('DOMContentLoaded', function() {
//     // 獲取 body 元素
//     //var body = document.querySelector(".inbody") || document.body;
// 	var htmlstyle = document.querySelector("html") || document;
    
//     // 獲取用戶代理字符串
//     var userAgent = navigator.userAgent;
    
//     if (userAgent.indexOf('Mac OS X') !== -1) {
//         // 如果是 mac 系統
//         htmlstyle.classList.add('macBrowser');
//     } else {
//         // 如果是其他系統
//         htmlstyle.classList.add('winBrowser');
//     }

// 	// 判斷是否為 iPhone 且 Safari 瀏覽器
//     if (userAgent.indexOf('iPhone') !== -1 && userAgent.indexOf('Safari') !== -1 && userAgent.indexOf('Chrome') === -1) {
//         // 如果是 iPhone 且 Safari 瀏覽器
//         htmlstyle.classList.add('iPhoneSafariBrowser');
//     } 

// 	// 判斷是否為 Android 系統且內建瀏覽器
// 	if (userAgent.indexOf('Android') !== -1 && userAgent.indexOf('Chrome') === -1) {
// 		// 如果是 Android 系統且內建瀏覽器
// 		htmlstyle.classList.add('AndroidDefaultBrowser');
// 	}
// });


  //------------------------ 使手機版LINE 另開手機預設瀏覽器 20181226 -------------------
	if (/Line/.test(navigator.userAgent)) {
		var str=location.href
		if(str.indexOf("?")>-1)location.href =  location.href + '&openExternalBrowser=1';
		else location.href =  location.href + '?openExternalBrowser=1';
	}
 
























 

$(function(){
});