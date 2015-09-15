var btn;
var stockFlag=false;

function popupMsg(msg,cb){
    $.popup({
        showID: "container",
        id: "dailog",
        title: "提示",
        message: msg,
        continueUIButton: '确定',
        //cancelUIButton: '取消',
        callback: function(){
            if(cb){
                cb();
            }
        }
    });
}
//判断颜色和尺寸都选择后，可以参团


//默认选中送货方式
function selsectmodel()
{
    var model=$('#choose_mode span');
    model.each(function(){
        if($(this).text()=='送货')
        {
            $(this).addClass('choose2');
        }
    });
}

//默认选中第一项
function selectone()
{
    var model=$('#choose_size span');
    model.eq(0).addClass('choose2');
    var model=$('#choose_color span');
    model.eq(0).addClass('choose2');
}

//选择颜色和尺寸click事件
function clickColorAndSize(ajax_url){
    $('#choose_color,#choose_size,#choose_mode').each(function(){
        var obj=$(this).find('span');
        if(obj.length==1)
        {
            console.log('bb');
            obj.addClass("choose2");
            canInGroup(ajax_url);
        }
        else
        {
            obj.click(function(){
                obj.removeClass("choose2");
                $(this).addClass("choose2");
                canInGroup(ajax_url);
            }); canInGroup(ajax_url);
        }
    });
}

function canInGroup(ajax_url){
    var span=$('#choose_color,#choose_size,#choose_mode').find(".choose2");
    if(span.length==3){
        btn.addClass("bg6");
        var g_color=span.eq(0).text();
        var g_size=span.eq(1).text();
        var g_mode=span.eq(2).text();
        stockFlag=false;
        $.get(ajax_url+"?action=getProductStock&product_id="+product_id+"&choose_color="+g_color+"&choose_size="+g_size+"&choose_mode="+g_mode,function(data){
            if(data.stock>0)
            {
                btn.addClass("bg1");
                btn.removeClass("bg6");
                $('#choose_stock').text('库存 '+data.stock+' 件');
                stockFlag=true;
            }
            else if(data.stock==-1){
                btn.addClass("bg1");
                btn.removeClass("bg6");
                $('#choose_stock').text('货源充足');
                stockFlag=true;
            }
            else{
                $('#choose_stock').text('无货');
                btn.removeClass("bg1");
                btn.addClass("bg6");
                stockFlag=false;
            }
        });
    }
}

