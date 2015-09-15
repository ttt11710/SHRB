var pointStartX, pointStartY, deltaX, deltaY;
var myScroll;
//图片ISCROLL
function initImgIscroll(){
    //显示当前第几张图片div
    var line=$(".indicator");
    line.eq(0).addClass("cl");
    myScroll=new iScroll('wrapper',{
        bounce:false,
        //true手指滑动之后 会滑动到别的元素，false手指滑动多少，scroll滚动多少
        snap:true,
        //不允许垂直滚动
        vScroll:false,
        //不开启拖动惯性
        momentum:false,
        //不显示水平滚动条
        hScrollbar:false,
        //因为 滑动图片时，页面可以上下移动
        //所以 需要判断 是否横向滑动，获取手指滑动开始和结束的x、y坐标，算出x、y移动的距离
        //x移动的距离大于y移动的距离，就是横向滑动，阻止浏览器默认行为，scroll滚动区域就不能上下移动
        onBeforeScrollStart: function(e){
            //获取手指滑动开始的x和y坐标
            var point = e.touches[0];
            pointStartX = point.pageX;
            pointStartY = point.pageY;
            return true;
        },
        //内容移动前 事件
        onBeforeScrollMove:function(e){
        },
        //手离开屏幕后 事件
        onTouchEnd:function(){
            //div根据第几张显示不同颜色
            line.removeClass("cl");
            line.eq(this.currPageX).addClass("cl");
        }
    });
}


