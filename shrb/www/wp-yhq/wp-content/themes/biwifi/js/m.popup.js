function reduceToNode ( node ) {
    var self = node.nodeName ? node : node[0];
    return self;
}

function UIClosePopup (selector) {
    $(selector).remove();
}

function Unblock() {
    $(".mask").remove();
}

function ViewBlock(){
    $("body").append('<div class="mask" style="opacity:0.5" ui-visible-state="visible"></div>');
    var bodyHeight= window.innerHeight + window.pageYOffset;
    $(".mask").css("height",bodyHeight);
}



(function($) {
    $.popup = function(opts){
        var id = opts.id || $.UIUuid();
        var selector = opts.showID || 'center';
        var title = opts.title || 'Alert!';
        var message = opts.message || '';
        var cancelUIButton = opts.cancelUIButton || '';
        var continueUIButton = opts.continueUIButton || 'Continue';
        var callback = opts.callback || function() {};
        var buttonHtml = '<p class="bor_r col2 cancel twoL" id="cancel">'+cancelUIButton+'</p><p class="col twoR" id="continue">'+continueUIButton+'</p>';
        if (cancelUIButton==""){
            buttonHtml = '<p class="col one" id="continue">'+continueUIButton+'</p>';
        }

        var popup = $('<div class="pop" id=' +id+'><div class="pop_title">'+title+ '</div><div class="pop_content2" id="msg"><a>'+ message+ '</a></div><div class="pop_bt">'+buttonHtml);

        var selectorID = '#' + selector;
        $(selectorID).append(popup);
        ViewBlock();

        var popupID = '#' + id;
        var popup= reduceToNode($(popupID));
        var tmpTop = ((window.innerHeight /2) + window.pageYOffset) - (popup.clientHeight /2) + 'px';
        var tmpLeft = ((window.innerWidth / 2) - (popup.clientWidth / 2) + 'px');

        // console.log(tmpTop + "--" + tmpLeft);

        $(".pop").attr('ui-visible-state', 'visible');
        $(".pop").css({left: tmpLeft, top: tmpTop});


        $("#cancel").bind('click', function(){
            Unblock();
            UIClosePopup($(popupID));
        });

        $("#continue").bind('click', function(){
            Unblock();
            UIClosePopup($(popupID));
            //这里执行一下 call back
            callback.call(callback, this);
        });
    };

    $.viewblock = function(opts){
        ViewBlock();

    };
    $.Unblock = function(opts){
        Unblock();
    };
    $.openLoading = function(opts){
        $("body").append('<div class="mask" style="opacity:0.8;" ui-visible-state="visible" ><div><img id="loading" src="/demo_gap/themes/paybaypage/images/loading.gif" style="height: 70px;width: 125px;"/></div></div>');
        var bodyHeight= window.innerHeight  + window.pageYOffset;
        $(".mask").css("height",bodyHeight);
    };
    $.closeLoading = function(opts){
        Unblock();
    };
})($);
