$(function () {

    var _showTab = 0;

    var $tabs = $('ul.tabs button[role="tab"]');
    var $panels = $('.p_tab_text_area [role="tabpanel"]');

    var $mobileTabBtn = $('.tabs_btn_now_arrow');
    var $imgScroll = $('.img-scroll');

    function isMobile() {
        return document.documentElement.clientWidth <= 760;
    }

    function getFocusable($area) {
        return $area
            .find('a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])')
            .filter(':visible');
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

        // hide all panels
        $panels
            .attr('hidden', true)
            .hide();

        // show current panel
        $targetPanel
            .removeAttr('hidden')
            .show();

        // remove old event
        $panels
            .find('a, button, input, select, textarea, [tabindex]')
            .off('keydown.backToTab');

        var $focusable = getFocusable($targetPanel);
        var $firstFocusable = $focusable.first();

        // panel first focusable shift+tab
        $firstFocusable.on('keydown.backToTab', function (e) {

            if (e.key === 'Tab' && e.shiftKey) {

                e.preventDefault();

                // 手機且 tabs 被收起來
                // 回到手機按鈕
                if (isMobile() && !$tab.is(':visible')) {

                    $mobileTabBtn.focus();

                } else {

                    // 一般情況回到目前 tab
                    $tab.focus();

                }

            }

        });

        // Enter 後進入內容
        if (moveFocusToContent) {

            if ($firstFocusable.length) {

                $firstFocusable.focus();

            } else {

                $targetPanel
                    .attr('tabindex', '-1')
                    .focus();

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

        // 手機滑鼠點擊後收起
        if (isMobile()) {

            $imgScroll.slideUp();

        }

    });

    // keyboard
    $tabs.on('keydown', function (e) {

        // Enter / Space
        if (e.key === 'Enter' || e.key === ' ') {

            e.preventDefault();

            switchTab($(this), true);

            return;

        }

        // 手機版：
        // 只有第一個 tab shift+tab
        // 才回到手機按鈕
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