$(function () {

    var _showTab = 0;

    var $tabs = $('.index_admissionBg ul.tabs button[role="tab"]');
    var $panels = $('.index_admissionBg .p_tab_text_area [role="tabpanel"]');

    var $mobileTabBtn = $('.index_admissionBg .tabs_btn_now_arrow');
    var $imgScroll = $('.index_admissionBg .img-scroll');

    function isMobile() {
        return document.documentElement.clientWidth <= 760;
    }

    function switchTab($tab, moveFocusToContent) {

        var target = $tab.data('tab');
        var $targetPanel = $(target);
        var tabText = $.trim($tab.text());

        // reset tabs
        $tabs
            .removeClass('active')
            .attr('aria-selected', 'false')
            .removeAttr('tabindex');

        $('ul.tabs li').removeClass('active');

        // active tab
        $tab
            .addClass('active')
            .attr('aria-selected', 'true')
            .removeAttr('tabindex')
            .parent()
            .addClass('active');

        // mobile title
        $('.tabs_btn_now > span').text(tabText);

        // // hide all panels
        // $panels
        //     .attr('hidden', true)
        //     .hide();

        // // show current panel
        // $targetPanel
        //     .removeAttr('hidden')
        //     .show();


        // hide all panels
        $panels
            .prop('hidden', true);

        // show current panel
        $targetPanel
            .prop('hidden', false);


        // 移除所有舊的鍵盤事件
        $panels.find('a, button, input, select, textarea, [tabindex]')
            .off('keydown.tabFocus');

        // 取得下一個焦點目標
        var currentTabIndex = $tabs.index($tab);
        var isLastTab = currentTabIndex === $tabs.length - 1;
        var $nextFocus = isLastTab
            ? $('.footer a').first()
            : $tabs.eq(currentTabIndex + 1);

        // 固定入口：swiper 第一個真實 slide 的連結（排除 loop clone）
        var $entryLink = $targetPanel
            .find('.swiper-slide:not(.swiper-slide-duplicate) a')
            .first();

        // fallback：沒有輪播時用第一個可見連結
        if (!$entryLink.length) {
            $entryLink = $targetPanel.find('a, button').filter(':visible').first();
        }

        // 固定出口：panel 內的 .index_button a
        var $exitLink = $targetPanel.find('.index_button a');

        // panel 入口 Shift+Tab → 回到當前 tab button
        $entryLink.on('keydown.tabFocus', function (e) {
            if (e.key === 'Tab' && e.shiftKey) {
                e.preventDefault();
                if (isMobile() && !$tab.is(':visible')) {
                    $mobileTabBtn.focus();
                } else {
                    $tab.focus();
                }
            }
        });

        // panel 出口 Tab → 下一個 tab button，最後一個 tab 則跳到 footer
        $exitLink.on('keydown.tabFocus', function (e) {
            if (e.key === 'Tab' && !e.shiftKey) {
                e.preventDefault();
                $nextFocus.focus();
            }
        });

        // Enter 後進入 panel 內容
        if (moveFocusToContent) {
            if ($entryLink.length) {
                $entryLink.focus();
            } else {
                $targetPanel.attr('tabindex', '-1').focus();
            }
        }

    }

    // init
    switchTab($tabs.eq(_showTab), false);

    // mobile button
    $mobileTabBtn.on('click', function () {
        $imgScroll.slideToggle();
    });

    // mouse click
    $tabs.on('click', function () {
        switchTab($(this), false);
        if (isMobile()) {
            $imgScroll.slideUp();
        }
    });

    // keyboard
    $tabs.on('keydown', function (e) {

        // Enter / Space → 進入 panel 內容
        if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            switchTab($(this), true);
            return;
        }

        // 手機：第一個 tab Shift+Tab → 手機按鈕
        if (e.key === 'Tab' && e.shiftKey && isMobile()) {
            var $firstTab = $tabs.first();
            if (this === $firstTab[0]) {
                e.preventDefault();
                $mobileTabBtn.focus();
            }
        }

    });

    // resize
    $(window).on('resize', function () {
        $imgScroll.removeAttr('style');
    });

});
