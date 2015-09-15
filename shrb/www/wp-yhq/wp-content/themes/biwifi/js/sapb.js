$(function(){

	//cancel_order();
	doregredir();
	backtolog();
	init();
	domore();
	showpwd();
	gohistory();
	checktopwd();
	changepwd();
	changeimg();
	showbillingpage();
	check_order_notices();
	var point, pointStartX, pointStartY, deltaX, deltaY;
        var myScroll;
	initImgIscroll();
});

function doregredir(){
	$('#btnreg').click(function(){
		$('#logform').hide();
		$('#regform').show();	
});
//        $("#btnrepwd").click(function(){
  //      alert("跳转到修改密码页面");
//});
}

function backtolog(){
	$('#backtolog').click(function(){
		$('#logform').show();
        $('#regform').hide();
});
	

}

function init(){
	//修改显示
	$("label[for='color']").text("颜色");
	$("label[for='size']").text('尺码');
	$("label[for='delivery']").text('配送');
}

function domore(){
	$("#clickimg").click(function(){
		var postid = $("#posid").text();
		var posturl = $("#posurl").text();
		window.location.href= posturl+'?posid='+postid;
});
}

function checktopwd(){
        $("#reg").click(function(){
        var pwd1 = $("#reg_password").val();
        var pwd2 = $("#reg_password2").val();
	var username = $("#reg_username").val();
        if(pwd1 !=pwd2){
                alert("用户密码两次不一致");
                return false;
        }
	alert("您的账号："+username);
        return true;
});
}

function changepwd(){
        $("#btnrepwd").click(function(){
         window.open("http://www.sanfu.com/forget.php");
});
}

function changeimg(){
	 var head = $("header").children(".ft21").text().replace(/(^\s*)|(\s*$)/g, "");
	if(head=="我的账户"){
	
		var imgurl = $("#imgurl").val()+"/img/dianit.png";
		//alert(imgurl);
		$("#sf_sync_logo").attr("src",imgurl);
		$("#sf_sync_logo").attr("class","newimg");;
	}
}
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

function  gohistory(){
	$("#headimg").click(function(){
		history.back();
});
	
}

function showpwd(){
	$("#isshowpwd").click(function(){
		var ht = $("#password").val();
	   if($(this).attr("checked")=="checked"){
		//$("#password").remove();
		var innerhtml = "<input class='input-text xx showpwd' style='border-radius:5px;'  type='text' name='password' id='password' placeholder='请输入密码' value='"+ht+"' />";
		$("#password").parent().append(innerhtml);
		$("#password").remove();
	}else{
		$(".showpwd").hide();		
		$("#password").hide();
		var innerhtml = "<input class='input-text xx' style='border-radius:5px;'  type='password' name='password' id='password' placeholder='请输入密码' value='"+ht+"' />";
		$("#password").parent().append(innerhtml);
		 $("#password").remove();
	}	    	
     });
}

function showbillingpage(){
	 $("#billing_invoice_name").val("");
	$("#billing_invoice_checkbox").click(function(){
	if($(this).attr("checked")=="checked"){
		$("#is_need_billing").show();
	}else{
		 $("#is_need_billing").hide();
		 $("#billing_invoice_name").val("");
	}
});
}

function check_order_notices(){
	$("#place_order").click(function(){
		if($("#billing_invoice_checkbox").attr("checked")=="checked"){
			if($("#billing_invoice_name").val() == ""){
				alert("请输入发票抬头");
				return false;
			}
		}
	});
}


