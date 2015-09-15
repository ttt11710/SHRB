    
    (function($) {
        // //颜色选择状态
        // var choose_color=false;
        // //尺寸选择状态
        // var choose_size=false;


        // // $("#name").text("SANFU流行氨棉T恤");
        // // $("#cost").text("500.00");
        // // $("#price").text("100.00");

        // clickColorAndSize();

        // var line=$(".indicator");
        // loaded(line);        

        // //选择颜色和尺寸click事件
        // function clickColorAndSize(){
        //     var color=$("#color span");
        //     color.click(function(){
        //         color.removeClass("choose2");
        //         $(this).addClass("choose2");
        //         choose_color=true;
        //         canInGroup();
        //     });

        //     var size=$("#size span");
        //     size.click(function(){
        //         size.removeClass("choose2");
        //         $(this).addClass("choose2");
        //         choose_size=true;
        //         canInGroup();
        //     });
        // }
        // //判断颜色和尺寸都选择后，可以参团
        // function canInGroup(){
        //     if(choose_color&&choose_size){
        //         var btn=$("#in");
        //         btn.addClass("bg1");
        //         btn.removeClass("bg6");
        //         btn.click(function(){

        //         });
        //     }
        // }
        //图片ISCROLL
        var point, pointStartX, pointStartY, deltaX, deltaY;
        var myScroll;
        function loaded(line) {

            myScroll=new iScroll('wrapper',{
                snap:true,
                vScroll:false,
                momentum:false,
                hScrollbar:false,
                onBeforeScrollStart: function (e) {
                    point = e.touches[0];
                    pointStartX = point.pageX;
                    pointStartY = point.pageY;
                },
                onBeforeScrollMove:function(e){
                    deltaX = Math.abs(point.pageX - pointStartX);
                    deltaY = Math.abs(point.pageY - pointStartY);
                    if (deltaX >= deltaY) {
                        e.preventDefault();
                    }else{
                    }
                },
                onTouchEnd:function(){
                    line.removeClass("cl");
                    line.eq(this.currPageX).addClass("cl");
                }
            });
        }


    })(window.jQuery || window.Zepto);   

