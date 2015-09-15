var vania_fit_lenslider_fn = function(inparr) {
    var lsVFObj = jQuery(".ls_van_fit_ibanner").tabs({
        effect: inparr.slideshow.ls_easing_effect
    });
    if(parseInt(inparr.slideshow.ls_has_autoplay) > 0 && parseInt(inparr.slideshow.ls_autoplay_delay) > 0) {
        if(inparr.slideshow.ls_autoplay_hover_pause > 0) {
            lsVFObj.tabs("rotate", parseInt(inparr.slideshow.ls_autoplay_delay), false).tabs("hover", true, true);
        } else {
            lsVFObj.tabs("rotate", parseInt(inparr.slideshow.ls_autoplay_delay), true);
        }
    }
};