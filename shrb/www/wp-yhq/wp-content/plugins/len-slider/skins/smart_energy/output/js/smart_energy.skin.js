var smart_energy_lenslider_fn = function(inparr) {
    jQuery(".ls_sm_en_ib_manage li").hover(
        function() {
            jQuery(this).addClass("hvr");
        },
        function() {
            jQuery(this).removeClass("hvr");
        }
    );
    jQuery(".ls_sm_en_ib_manage").prepend("<div class=\"labs\"></div>");
    jQuery("#ibo_0").show();
    var lsSEObj = jQuery(".ls_sm_en_ibanner").tabs({
        show: {
            effect: inparr.slideshow.ls_easing_effect
        },
        beforeActivate: function(event, ui) {
            jQuery(".labs").animate({marginLeft:ui.newTab.index()*240}, 200);
            jQuery(".ls_sm_en_ibanner_overlay").hide();
            jQuery("#ibo_"+ui.newTab.index()).fadeIn(300);
        }
    });
    if(parseInt(inparr.slideshow.ls_has_autoplay) > 0 && parseInt(inparr.slideshow.ls_autoplay_delay) > 0) {
        if(inparr.slideshow.ls_autoplay_hover_pause > 0) {
            lsSEObj.tabs("rotate", parseInt(inparr.slideshow.ls_autoplay_delay), false).tabs("hover", true, true);
        } else {
            lsSEObj.tabs("rotate", parseInt(inparr.slideshow.ls_autoplay_delay), true);
        }
    }
};