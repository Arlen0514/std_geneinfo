// 燈箱效果
$(function(){
	
	var winHeight;  	  	    //螢幕高度
	var insideDomHeight;		//燈箱內可見的DOM 的高度
	var lightboxMainHeight;	    //燈箱主體高度

	//添加燈箱高度
	function lightboxHeight(){
		winHeight    = $(window).height();
		$(".lightboxArea").css({
			'height': winHeight+'px'
		})
	}
	
	lightboxHeight();
	
	$(window).resize(function(e) {
		setTimeout(function(){
			lightboxHeight();
		},300)
	});
	
	//顯示燈箱
	function lightboxShow(){
		
		//$(".lightboxArea").show();
		$(".lightboxArea").css({
			"display": "flex",
		})
		
		setTimeout(function(){
			$(".lightboxMain").css({
				'transform':'scale(1)'
			})
		},300)
		
	}
	
	$(".lightBoxShow").click(function(e) {
		lightboxShow();
	});
	
	//隱藏燈箱
	function lightboxHide() {
		
		setTimeout(function(){
			$(".lightboxArea").hide();
		},300)
		
		$(".lightboxMain").removeAttr("style");
		
	}
	
	$(".lightboxClose, .lightboxBG").click(function(e) {
		lightboxHide();
	});
	
	//燈箱內資料如果矮於燈箱區塊　讓資料置中
	function lightboxInsideMiddle(){
		insideDomHeight	   = $(".lightboxContentArea").children("div:visible").height();
		lightboxMainHeight = $(".lightboxMain").height();
		var paddingPx	   = lightboxMainHeight-insideDomHeight;
		//要padding的高度↑
		//console.log(paddingPx);
		if ( insideDomHeight < lightboxMainHeight ) {
			$(".lightboxContentArea").children("div:visible").css({
				'padding-top': paddingPx/2+'px'
			})
		}else {
			$(".lightboxContentArea").children("div:visible").removeAttr("style");
		}
	}
	
	$(".lightBoxShow").click(function(e) {
		setTimeout(function(){
			lightboxInsideMiddle();
		},300)
	});
	
	$(window).resize(function(e) {
		setTimeout(function(){
			lightboxInsideMiddle();
		},300)
	});
	

});