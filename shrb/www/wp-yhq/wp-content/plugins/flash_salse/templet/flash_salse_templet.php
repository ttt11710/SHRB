<?php get_header('vs');?>
<?php
/**
    Template Name:flash_salse
 */
?>
<?php $bg_img=plugins_url().'/flash_salse/images/bg_green.png'; ?>

<style type="text/css">
.clock{
	/* The .clock div. Created dynamically by jQuery */
	background-color:#ff5722;
	height:200px;
	width:200px;
	position:relative;
	overflow:hidden;
	float:left;
}

.clock .rotate{
	/* There are two .rotate divs - one for each half of the background */
	position:absolute;
	width:200px;
	height:200px;
	top:0;
	left:0;
}

.rotate.right{
	display:none;
	z-index:11;
}

.clock .bg, .clock .front{
	width:100px;
	height:200px;
	background-color:#ff5722;
	position:absolute;
	top:0;
}



/* The left part of the background: */

.clock .bg.left{ left:0; }

/* Individual styles for each color: */
.orange .bg.left{ background:url(img/bg_orange.png) no-repeat left top; }
.green .bg.left{ background:url(<?php echo $bg_img; ?>) no-repeat left top; }
.blue .bg.left{	background:url(img/bg_blue.png) no-repeat left top; }

/* The right part of the background: */
.clock .bg.right{ left:100px; }

.orange .bg.right{ background:url(img/bg_orange.png) no-repeat right top; }
.green .bg.right{ background:url(<?php echo $bg_img; ?>) no-repeat right top; }
.blue .bg.right{ background:url(img/bg_blue.png) no-repeat right top; }


.clock .front.left{
	left:0;
	z-index:10;
}

</style>
<?php 
	$id=get_the_ID();
	//商品信息
	$product_id=get_post_meta($id,"product_id",ture);
	$product_info=get_product($product_id,$fields = null);
	$product_title=$product_info->post->post_title;
	$flash_price=$product_id=get_post_meta($id,"flash_salse_price",ture);
	// print_r($product_title);
	$current_time=current_time('timestamp');
	//开始时间
	$startTime=get_post_meta($id,"start_time",ture);
	//结束时间
	$endTime=get_post_meta($id,"end_time",ture);
	//当前时间
	$js_current_time=date('Y/m/d H:i:s',$current_time);

	$js_current_time='2015/06/19 14:19:50';
	$startTime='2015/06/19 14:20:00';
	$endTime='2015/06/19 14:20:30';
	// print_r();
?>
<script>
	var s;
	var m;
	jQuery( function($){
		// create_order();
		console.log("document.body.offsetWidth:"+document.body.offsetWidth);
		var p_width=document.body.offsetWidth;
		p_width=p_width-184;
		console.log(p_width);
		var input_knob=$(".knob");
		// .attr(attribute,value)
		input_knob.attr("data-width",p_width);
		input_knob.attr("data-height",p_width);
		$(document).ready(function(){
			//页面宽度



			var startTime=new Date('<?php echo $startTime; ?>').getTime();
			var endTime=new Date('<?php echo $endTime; ?>').getTime();
			decideTime(startTime,endTime);

		});
		function decideTime(startTime,endTime){
			var salse_after=$("#salse_after");
			var salse_in=$("#salse_in");
			var now=new Date('<?php echo $js_current_time; ?>').getTime();
			var s_n=startTime - now;
			s_hour=Math.floor((s_n/(3600*1000)));
			s_minute=Math.floor((s_n/(60*1000))%60);
			s_second=Math.floor((s_n/(1000))%60);
		    if(s_n>0){
		        var e_s=endTime - startTime;
		        e_hour=Math.floor((e_s/(3600*1000)));
		        e_minute=Math.floor((e_s/(60*1000))%60);
		        e_second=Math.floor((e_s/(1000))%60);
		        s=s_minute*60+s_second;
		        console.log("s:"+s);
		        startCountDown(s_hour,s_minute,s_second);
		        console.log('活动开始倒计时');

		    }else if(s_n<=0&&now<endTime){
		        // $("#msg").text("活动结束倒计时：");
		        var e_n=endTime - now;
		        e_hour=Math.floor((e_n/(3600*1000)));
		        e_minute=Math.floor((e_n/(60*1000))%60);
		        e_second=Math.floor((e_n/(1000))%60);
		        m=e_minute*60+e_second;
		        console.log("m:"+m);
		        //活动结束 倒计时
		        endCountDown(e_hour,e_minute,e_second);

		    }else{
		    	console.log('活动已经结束');
		    	$("#salse_in").hide();
				$("#salse_over").show();
		        // startReturnEnd("活动已结束：");
		    }
		}
		function startReturnEnd(text,id){
		    
		    var countDiv=$("#countDown");
		    var countType=$("#type");
		    countDiv.removeClass("panel_pink");
		    countDiv.addClass("panel_gray");
		    $("#msg").text(text);
		    countType.text("已结束");
		    countType.removeClass("mrT15");
		    countType.addClass("mrT46");
		    $("#hour").text("0");
		    $(".minute").text("00");
		    $(".second").text("00");


		    $("#salse_over").show();
		    $("#salse_in").hide();

		    if(id){
		        mscreen.send("saleEnd",id);
		    }
		}
		//活动结束 倒计时
		function endCountDown(e_hour,e_minute,e_second){
		    $("#hour").text(e_hour);
		    // $("#msg").text("活动结束倒计时：");
		    console.log('活动进行中');
			$("#salse_after").hide();
			$("#salse_in").show();
			$("#salse_in").css('font-size','106px');
			console.log("e_minute"+e_minute);
			console.log("e_second"+e_second);
			// alert('bbb');
			shake();
			m=e_minute*60+e_second;
			m=30-m;
			clock1();
			// $('#fancyClock1').tzineClock1();
			
		    countDown(e_hour,e_minute,e_second,function(){
		        startReturnEnd("活动已结束：");
		    });
		}
		//活动开始 倒计时
		function startCountDown(s_hour,s_minute,s_second){
		    $("#hour").text(s_hour);

		    $("#salse_after").show();
			$("#salse_in").hide();
			// 倒计时圆圈转动方法
			// $('#fancyClock').tzineClock();
			// s=e_minute*60+e_second;
			s=180-s;
			clock();
		    countDown(s_hour,s_minute,s_second,function(){
		        endCountDown(e_hour,e_minute,e_second);
		    });
		}
		//计时器
		var timing;
		//倒计时
		function countDown(h,m,s,cb){
		    var hour=$("#hour");
		    var minute=$(".minute");
		    var second=$(".second");
		    if(m<10){
		        minute.text("0"+m);
		    }else{
		        minute.text(m);
		    }
		    if(s<10){
		        second.text("0"+s);
		    }else{
		        second.text(s);
		    }
		    //计时器
		    timing=setInterval(function(){
		        //小时和分钟都为0，倒计时结束
		        if(h==0&&m==0&&s==0){
		            //清除timing计时器
		            clearInterval(timing);
		            if(cb){
		                cb();
		            }
		        }else{
		            if(s==0){
		                s=59;
		                if(m==0){
		                    m=59;
		                    if(h>0){
		                        h--;
		                    }
		                    //小时
		                    hour.text(h);
		                }else{
		                    m--;
		                }
		            }else{
		                s--;
		            }
		            //秒小于10时，前面加0
		            if(s>=0&&s<10){
		                second.text("0"+s);
		            }else{
		                second.text(s);
		            }
		            //分钟小于10时，前面加0
		            if(m>=0&&m<10){
		                minute.text("0"+m);
		            }else{
		                minute.text(m);
		            }
		        }
		    },1000);

		}
		//摇一摇方法
		function shake(){
			// window.onload=function(){
				if(window.DeviceMotionEvent){
					window.addEventListener('devicemotion',deviceMotionHandler, false); 
				}
				var SHAKE_THRESHOLD = 1000;
				var last_update = 0;
				var x, y, z, last_x, last_y, last_z;
				var ff=0;
				var flag1=0;
				var flag2=0;
				function deviceMotionHandler(eventData) {
					var acceleration =eventData.accelerationIncludingGravity;
					//alert(newDate().getTime());
					var curTime = new Date().getTime();
					// alert(curTime - last_update);
					if ((curTime - last_update)> 200) {
						x = acceleration.x;//west to east 
						y = acceleration.y;//south to north
						z = acceleration.z;//down to up
						if(x +y + z - last_x - last_y - last_z>30){
							flag1=0;
							// alert(flag1);
							if(flag1==flag2){
								if(ff>0 && ff<2){
									// alert(ff);
									create_order();
								}
								
								ff++;
							}
								//alert(ff++);
							flag2=1
						}
						if(x +y + z - last_x - last_y - last_z<-30){
							flag2=0;
							if(flag1==flag2)
								flag1=1;
						}
						last_x = x;
						last_y = y;
						last_z = z;
					}
				} 
				
			// }
		}//摇一摇end
		//创建订单请求
		function create_order(){
			var flashSale_id=<?php echo get_the_ID() ?>;
			// alert(flashSale_id);
			//ajajx秒杀请求
			$.get("<?php echo admin_url('admin-ajax.php');?>?action=flashSale_create_order&flashSale_id="+flashSale_id,function(data){
				// console.log(typeof(data));
				if(data.code==1000)
				{
					alert(data.msg);
					create_order_success(data.order_id);
				}
				else
				{
					alert(data.msg);				
				}
			});
		}
		//购买成功后
		function create_order_success(order_id_text){
			clearInterval(timing);
			var salse_create_order=$("#salse_create_order");
			$("#salse_in").hide();
			$("#salse_over").hide();
			salse_create_order.show();
			var order_id=$("#order_id");
			// console.log(order_id_text);
			order_id.text(order_id_text);

			salse_create_order.click(function(){
				var url="<?php echo home_url().'/myaccount'; ?>";
				location.href = url+"?order_id="+order_id_text;
			});
		}		


		$(".knob").knob({
		});
		$("input.infinite").knob({
			// min : 0,
			// max : 180,
			// stopper : false,
			// // readOnly: true,
			// change : function () {
			// }
		});

	});
	// var i=0;
	function clock() {
		if(s==180)
		{
			s=0;
		}
		// s=180-s;
		// alert('aaa');
		var second_i=jQuery(".second");
		console.log("time:"+s);
		second_i.val(s).trigger("change");
		s++;
		setTimeout("clock()", 1000);
	}
	function clock1() {
		if(m==30)
		{
			m=0;
		}
		// s=180-s;
		// alert('aaa');
		var second_i1=jQuery(".second1");
		console.log("time:"+m);
		second_i1.val(m).trigger("change");
		m++;
		setTimeout("clock1()", 1000);
	}
</script>
<div id='salse_after' style="display:none">
	<div id="countDown" style="text-align: center;font-size:99px;  margin-bottom: -160px;;z-index: 999;position: relative;">
		<div class="panel-heading" style="color:#ffffff;line-height: 1.5;">
			<!-- <span id="msg">活动开始倒计时：</span> <span class="ft250" id="hour">0</span>时-->
			<div>
				<span class="ft250 minute" id="minute">00</span>:<span class="ft250 second" id="second">00</span>
			</div>
			<!-- <br/> -->
			<div style="color:#f8c011;font-size:15px">即将开始</div>
		</div>
	</div>
	<div style="margin:0 92px;">

		<input class="knob second" data-min="0" data-max="180" data-bgColor="#f8c011" readonly="readonly" data-fgColor="rgb(255, 87, 34)" data-displayInput=false data-width="" data-height="" data-thickness=".2">
		
		<!-- <img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/flash_salse_quan.png'; ?>" /> -->
		<img style="margin: 22px auto 16px auto;width: 10%;" src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_sales_j2.png" ?>">
		<img src="<?php echo CURRENT_TEMPLATE_DIR."/images/yao.gif" ?>">
	</div>
</div>

<div id='salse_in' style="position: relative;">
	<div id="countDown" style="text-align: center;font-size:99px;  margin-bottom: -160px;;z-index: 999;position: relative;">
		<div class="panel-heading" style="color:#ffffff;line-height: 1.5;">
			<!-- <span id="msg">活动开始倒计时：</span> <span class="ft250" id="hour">0</span>时-->
			<div>
				<span class="ft250 minute" id="minute">00</span>:<span class="ft250 second" id="second">00</span>
			</div>
			<!-- <br/> -->
			<div style="color:#f8c011;font-size:15px">剩余时间</div>
		</div>
	</div>
 	<div style="margin:0 92px;">
 		<input class="knob second1" data-min="0" data-max="30" readonly="readonly" data-bgColor="#f8c011" data-fgColor="rgb(255, 87, 34)" data-displayInput=false data-width="" data-height="" data-thickness=".2">
		<!-- <img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/flash_salse_quan2.png'; ?>" /> -->
		<img style="margin: 22px auto 16px auto;width: 10%;" src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_sales_j2.png" ?>">
		<img src="<?php echo CURRENT_TEMPLATE_DIR."/images/yao.gif" ?>">
	</div>
</div>

<div id='salse_over' style="display:none;">
	<p style="margin-bottom: 10px;text-align: center;margin-top: 40px;font-size: 25px;color:#f8c011">秒杀结束，精彩待续！</p>
	<div style="margin-left: 93px;margin-right: 93px;">
		<img src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_salse_end.png" ?>">
		<img style="margin: 22px auto 16px auto;width: 10%;" src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_sales_j2.png" ?>">
	</div>
	<a href="<?php echo home_url().'/flash_salse-2/?flashSalse_id='.$id; ?>" style="font-size:20px;">
		<div style="color:#a40000;padding: 13px;background:#f8c011;text-align:center;margin-left:31px;margin-right:31px;font-size:20px;">
			确定
		</div>
	</a>
</div>

<div id='salse_create_order' style="margin-left:38px;margin-right:38px;display:none">
	<p style="padding: 12px 0 12px 28px;margin-bottom: 0px;border-radius:5px 5px 0px 0px;background:#d50000;text-align: left;font-size: 17px;color:#f8c011">恭喜，秒杀成功！</p>
	<div style="border-left: 1px solid #d50000;border-right: 1px solid #d50000;border-bottom: 1px solid #d50000;height:112px;background:rgba(255,255,255,0.7);padding-top: 30px;">
		<div style="margin-left: 39px;">
			<span style="font-size:16px;rgba(0,0,0,0.54);">秒杀产品：</span><span style="font-size:16px;rgba(0,0,0,0.87);"><?php echo $product_title; ?></span>
			<br/>
			<span style="font-size:16px;rgba(0,0,0,0.54);">秒杀惊喜：</span><span style="font-size:16px;rgba(0,0,0,0.87);"><?php echo $flash_price; ?></span>
		</div>
	</div>
	<img style="margin: 22px auto 16px auto;width: 10%;" src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_sales_j2.png" ?>">
	<!-- <a href="" style="font-size:20px;"> -->
		<div style="color:#a40000;padding: 13px;background:#f8c011;text-align:center;font-size:20px;">
			确定
		</div>
	<!-- </a> -->
</div>

<!-- <div style="width:100%;background:red;height:5px"></div> -->


