<?php
/**
 * Simple product add to cart
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce, $product;

if ( ! $product->is_purchasable() ) return;
?>

<?php
	// Availability
	$availability = $product->get_availability();
	// print_r($product->stock);
	// print_r($availability);
	// if ( $availability['availability'] )
	// 	echo apply_filters( 'woocommerce_stock_html', '<p class="stock ' . esc_attr( $availability['class'] ) . '">' . esc_html( $availability['availability'] ) . '</p>', $availability['availability'] );
?>
<p style="margin:6px 0 12px 0;color:rgba(0,0,0,0.87);">库存剩余：<?php echo $product->stock; ?></p>
<?php 
// print_r(get_the_id());	
$poduct_id=get_the_id();
$current_time=current_time('timestamp');
    //活动开始时间
$activity_start=get_post_meta( $poduct_id, 'activity_start', true );
//活动结束时间
$activity_end=get_post_meta( $poduct_id, 'activity_end_copy', true );
// print_r(date('Y-m-d H:m:s',$current_time));
// echo '...';
// print_r(strtotime($activity_start));
// echo '...';
// print_r($activity_end);
if($current_time>strtotime($activity_start) && $current_time<strtotime($activity_end)){
	$end_time = $activity_end;
	$period='no_start';
	$text='活动结束倒计时：';
}
else if($current_time<strtotime($activity_start))
{
	$end_time = $activity_start;
	$period='start';
	$text='活动开始倒计时：';
}
else{
	$period='end';
	$text='活动已经结束：';
}
// print_r($activity_start);
// print_r($activity_end);
$js_activity_start=strtotime($activity_start);
$js_activity_end=strtotime($activity_end);
// print_r($js_activity_start);
// print_r($js_activity_end);
$js_activity_start=date('Y/m/d H:i:s',$js_activity_start);
$js_activity_end=date('Y/m/d H:i:s',$js_activity_end);
$js_current_time=date('Y/m/d H:i:s',$current_time);
// print_r($js_activity_start);
// print_r($js_activity_end);
// $cat_count = sizeof( get_the_terms( $post->ID, 'product_cat' ) );
// print_r($cat_count);
// echo $product->get_categories($cat_count);

$cat_count = get_the_terms( $post->ID, 'product_cat' );
// print_r($cat_count);
$button_text=array();
foreach ($cat_count as $value) {
	$button_text[]=$value->name;
}
if(!in_array('实体商品', $button_text))
{
	?>
		<div id="countDown" style="margin-bottom:10px">
			<div class="panel-heading" style="color:#ff5722;">
				<span id="msg">活动开始倒计时：</span><span class="ft250" id="hour">0</span>时<span class="ft250" id="minute">00</span>分<span class="ft250" id="second">00</span>秒
			</div>
		</div>
	<?php
}
?>
<script>
	jQuery( function($){
		$(document).ready(function(){
			var startTime=new Date('<?php echo $js_activity_start; ?>').getTime();
			//结束时间
			var endTime=new Date('<?php echo $js_activity_end; ?>').getTime();
			decideTime(startTime,endTime);
		});
		function decideTime(startTime,endTime){
		    var now=new Date('<?php echo $js_current_time; ?>').getTime();
		    console.log('<?php echo $js_current_time; ?>');
		    var s_n=startTime - now;
		    s_hour=Math.floor((s_n/(3600*1000)));
		    s_minute=Math.floor((s_n/(60*1000))%60);
		    s_second=Math.floor((s_n/(1000))%60);
		    if(s_n>0){
		        var e_s=endTime - startTime;
		        e_hour=Math.floor((e_s/(3600*1000)));
		        e_minute=Math.floor((e_s/(60*1000))%60);
		        e_second=Math.floor((e_s/(1000))%60);
		        startCountDown(s_hour,s_minute,s_second);
		    }else if(s_n<=0&&now<endTime){
		        $("#msg").text("活动结束倒计时：");
		        var e_n=endTime - now;
		        e_hour=Math.floor((e_n/(3600*1000)));
		        e_minute=Math.floor((e_n/(60*1000))%60);
		        e_second=Math.floor((e_n/(1000))%60);
		        //活动结束 倒计时
		        endCountDown(e_hour,e_minute,e_second);
		    }else{
		        startReturnEnd("活动已结束：");
		    }
		}
		function startReturnEnd(text,id){
		    clearInterval(timing);
		    var countDiv=$("#countDown");
		    var countType=$("#type");
		    countDiv.removeClass("panel_pink");
		    countDiv.addClass("panel_gray");
		    $("#msg").text(text);
		    countType.text("已结束");
		    countType.removeClass("mrT15");
		    countType.addClass("mrT46");

		    $("#hour").text("0");
		    $("#minute").text("00");
		    $("#second").text("00");
		    if(id){
		        mscreen.send("saleEnd",id);
		    }
		}
		//活动结束 倒计时
		function endCountDown(e_hour,e_minute,e_second){
		    $("#hour").text(e_hour);
		    $("#msg").text("活动结束倒计时：");
		    countDown(e_hour,e_minute,e_second,function(){
		        startReturnEnd("活动已结束：");
		    });
		}
		//活动开始 倒计时
		function startCountDown(s_hour,s_minute,s_second){
		    $("#hour").text(s_hour);

		    countDown(s_hour,s_minute,s_second,function(){
		        endCountDown(e_hour,e_minute,e_second);
		    });
		}
		//计时器
		var timing;
		//倒计时
		function countDown(h,m,s,cb){
		    var hour=$("#hour");
		    var minute=$("#minute");
		    var second=$("#second");
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
	});
</script>



<?php if ( $product->is_in_stock() ) : ?>

	<?php do_action( 'woocommerce_before_add_to_cart_form' ); ?>
	<form class="cart" method="post" enctype='multipart/form-data'>
	 	<?php do_action( 'woocommerce_before_add_to_cart_button' ); ?>
	 	
	 	<?php
	 		if ( ! $product->is_sold_individually() )
	 			woocommerce_quantity_input( array(
	 				'min_value' => apply_filters( 'woocommerce_quantity_input_min', 1, $product ),
	 				'max_value' => apply_filters( 'woocommerce_quantity_input_max', $product->backorders_allowed() ? '' : $product->get_stock_quantity(), $product )
	 			) );
	 	?>
	 	
	 	<input type="hidden" name="add-to-cart" value="<?php echo esc_attr( $product->id ); ?>" />

	 	<button style="width:100%" type="submit" class="single_add_to_cart_button button alt"><?php echo $product->single_add_to_cart_text(); ?></button>

		<?php do_action( 'woocommerce_after_add_to_cart_button' ); ?>
	</form>

	<?php do_action( 'woocommerce_after_add_to_cart_form' ); ?>

<?php endif; ?>