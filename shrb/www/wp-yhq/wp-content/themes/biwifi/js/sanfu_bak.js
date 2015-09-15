function popupMsg(msg){
    $.popup({
	showID: "page",
	id: "dailog",
	title: "提示",
	message: msg,
	continueUIButton: '确定',
	//cancelUIButton: '取消',
	callback:function(){}
	});
}

$("#place_order").live("click",function(){
	var first_name_val = $.trim($("#shipping_first_name").val());
	var address_val = $.trim($("#shipping_address_1").val());
	var phone_val = $.trim($("#shipping_phone").val());
	if (first_name_val.length == 0){
		popupMsg('收货人姓名不能为空');
		return false;
	}
	if (address_val.length == 0){
		popupMsg('收货人地址不能为空');
		return false;
	}
	if (phone_val.length == 0){
		popupMsg('手机号码不能为空');
		return false;
	}
	if ($("#shipping_phone").length>0){
	     if(!phone_val.match(/^1[3|4|5|8][0-9]\d{4,8}$/)){
		popupMsg('手机号码格式不正确！请重新输入!');
		return false;
	       }
	     if(phone_val.length != 11){
		popupMsg('请输入11位手机号');
		return false;
		}
	}
	$(this).submit();
	//$(this).parent().parent().parent().parent('form').submit();
	//$(this).submit();
	
});


(function($) {
	$('#head-menu-button').click(function(e){
		// $('#site-navigation').toggle();
		$('#site-navigation').animate({
			height: "toggle"
		},500,'linear');
	});	

	$('#shipping_phone').attr('type','tel');

	$("#more").live('click',
		function(){
		    if($(this).text() == "详情"){
			$(this).parent().siblings("#shiyong").show();
			$(this).parent().siblings(".sanfu_shouhuo").show();
			//$(this).attr("text","隐藏");
			$(this).text("隐藏");
			$(this).parent().parent().parent().css("height","180px");

		    }else{
			$(this).parent().siblings("#shiyong").hide();
			$(this).parent().siblings(".sanfu_shouhuo").hide();
			$(this).text("详情");
			$(this).parent().parent().parent().css("height","85px");
		    }
        });

	$("#order_click").live('click',function(){
		var if_change;
		$.ajax({
			url:"wp-admin/admin-ajax.php",
			data:{ "action": "checkOrderPayment", "oid": $(this).siblings('a').text()},
			dataType:"json",
			type:"get",
			async: false,
			cache:false,
			success:function(result){
				if_change=result.pay;
				if (!if_change){
					alert(result.msg);
				}
			}
		});
		return if_change;

	});

	if($("#order_url").text() == "myorder_history"){
		$("#order_h2").hide();
		$(".buy_order").hide();
		$("#success_img").hide();
	    }
	$(".shipping_address p input").attr("value","");

	$("#shiyong").live("click",
        function(){
            var order_id = $(this).siblings(".wid98").children("#orderid1").text();
            var just_order_id = $(this).siblings(".wid98").children("#orderid2").text();

            var product_name = $.trim($(this).siblings('.lh20').children("#productname1").text());
            var count = $(this).siblings(".history_order3").text();
            var total = $(this).siblings(".history_order4").text();
            total = total.replace("¥", "");//去除¥
            var order_date = $(this).siblings("#order_data").text();
            var unit_price = $.trim($(this).siblings("#unit_price").text());

            var send_msg = '%2530sanfu%%%%%2500'+order_id+'%%%%商品名称:'+product_name+'%%%%购买时间:'+order_date+'%%%%'+count+'%%%%商品单价:'+unit_price+'%%%%'+total+'%%%2530%%%2500';
            send_msg = send_msg+'%%%%'+send_msg;
            //send_msg = encodeURIComponent(send_msg);
            alert(send_msg);
            $.ajax({
               type: "POST",
               //url: "http://112.124.61.96/content",
               url: "http://sanfuprint.paybay.cn/content",
               data: {'content':$.trim(send_msg),'order_id':$.trim(just_order_id)},
               success: function(msg){
                 alert('wow'+msg);
               }
            });

            $(this).attr({"disabled":"disabled"});

    	});

	/*
	$("#place_order").live("click",function(){
		if ($("#shipping_first_name").val().length == 0){
			//alert($.popup);
			alert("收货人姓名不能为空");
			return false;
		}
		if ($("#shipping_address_1").val().length == 0){
			alert("收货人地址不能为空");
			return false;
		}
		if ($("#shipping_phone").length>0){
		     if(!$("#shipping_phone").val().match(/^1[3|4|5|8][0-9]\d{4,8}$/)){
			alert("手机号码格式不正确！请重新输入!");
			return false;
		       }
		     if($("#shipping_phone").val().length != 11){
			alert("请输入11位手机号");
			return false;
			}
		}
		$(this).submit();
    	});
	*/


})(window.jQuery || window.Zepto);

