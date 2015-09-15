var default_lenslider_fn = function(inparr) {
    var lsDefObj = jQuery(".ls_def_ibanner").tabs({
        show: {
            effect: inparr.slideshow.ls_easing_effect
        }
    });
    if(parseInt(inparr.slideshow.ls_has_autoplay) > 0 && parseInt(inparr.slideshow.ls_autoplay_delay) > 0) {
        if(inparr.slideshow.ls_autoplay_hover_pause > 0) {
            lsDefObj.tabs("rotate", parseInt(inparr.slideshow.ls_autoplay_delay), false).tabs("hover", true, true);
        } else {
            lsDefObj.tabs("rotate", parseInt(inparr.slideshow.ls_autoplay_delay), true);
        }
    }
}