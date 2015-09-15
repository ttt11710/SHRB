<?php get_header('vs');?>
<?php
/**
    Template Name:falshSalse_index
 */
?>
<style type="text/css">

#div_img{
	background:#ffffff;margin:16px 18px;position: relative;
}
#url_jump{
	padding: 3px;margin-bottom: 28px;color:#a40000;background:#f8c011;text-align:center;margin-left:18px;margin-right:18px;font-size:18px;
}
#an_quan{
	margin:10px 18px;border:1px dashed #ffffff;border-radius: 6px;font-size:13px;color:rgba(0,0,0,0.54);
}
@media screen and (min-width:396px){
	#div_img{
		width:360px;
		margin: 16px auto;
	}
	#url_jump{
		width:360px;
		margin: 16px auto;
	}
	#an_quan{
		width:360px;
		margin: 16px auto;
	}
}
</style>
<?php 	
	$flashSalse_id=$_GET['flashSalse_id'];
	$product_id=get_post_meta($flashSalse_id,"product_id",ture);
	$flashSalse_price=get_post_meta($flashSalse_id,"flash_salse_price",ture);
	$medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($product_id), 'medium');
	$regular_price=get_post_meta($product_id,"_regular_price",ture);
	$current_time=current_time('timestamp');
	//开始时间
	$startTime=get_post_meta($flashSalse_id,"start_time",ture);
	//结束时间
	$endTime=get_post_meta($flashSalse_id,"end_time",ture);
	$js_current_time=date('Y/m/d H:i:s',$current_time);
	// print_r();15873804420  1990M815
?>
<div id="div_img" style="">
	<div style="border-bottom:1px solid rgba(0,0,0,0.12);">
		<img style="margin: 0 auto;width:100%" src="<?php echo $medium_image_url[0]; ?>">
	</div>
	<div style="">
		<div style="text-align: center;">
			<span style="font-size:16px;color:rgba(0,0,0,0.54);">原价：</span><span style="font-size:18px;color:rgba(0,0,0,0.54)"><?php echo $regular_price; ?></span><span style="margin-left: 3px;font-size:14px;color:rgba(0,0,0,0.54)">元</span>
			<span style="margin-left:20px;font-size:18px;color:rgba(0,0,0,0.87);">秒杀价：</span><span style="font-size:24px;color:#d50000;"><?php echo $flashSalse_price; ?></span><span style="margin-left: 3px;font-size:14px;color:rgba(0,0,0,0.54);">元</span>
		</div>
	</div>
	<img style="position: absolute;z-index: 1;width: 30%;top:8px;right:8px;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/flash_salse_y.png' ?>" />
</div>
	<img style="margin: 22px auto 16px auto;width: 10%;" src="<?php echo  CURRENT_TEMPLATE_DIR.'/images/flash_sales_j2.png'; ?>">
	<div id="url_jump" style="">
		<p style="margin:6px 0">开始秒杀</p>
	</div>
<!-- </a> -->
<div id="an_quan" style="">
	<div style="margin: 12px;">
		<span style="color:rgba(255,255,255,0.7)">安全保证：</span>
		<br/>
		<p style="color:rgba(255,255,255,0.7);line-height: 1.33;margin: 0;">本热点wifi是闭环控制，信息只提供本店使用，不会外泄，绝对保证您的信息安全</p>
	</div>
</div>
<script type="text/javascript">
jQuery( function($){
	// var start_time=new Date('<?php echo $startTime; ?>').getTime();
	// var end_time=new Date('<?php echo $endTime; ?>').getTime();
	// var now=new Date('<?php echo $js_current_time; ?>').getTime();
	$(document).ready(function(){

		// var flashSalse_id=<?php echo $flashSalse_id; ?>;
		// if(now<end_time){
			url_jump(<?php echo $flashSalse_id; ?>);
		// }
	});
	function url_jump(flashSalse_id){
		$("#url_jump").click(function(){
			var startTime=new Date('<?php echo $startTime; ?>').getTime();
			var now1=new Date().getTime();
			console.log(startTime);
			console.log(now1);
			var stamp=startTime-now1;
			var residue_hour=Math.floor((stamp/(3600*1000)));
			var residue_minute=Math.floor((stamp/(60*1000))%60);
			var residue_second=Math.floor((stamp/(1000))%60);
			console.log(residue_hour);
			console.log(residue_minute);
			console.log(residue_second);
			var now_second=residue_hour*60*60+residue_minute*60+residue_second;
			console.log(typeof(now_second));
			if(now_second<=180 && now_second>=-30){
				var url="<?php echo home_url(); ?>";
				location.href = url+"?p="+flashSalse_id;
			}
			else if(now_second<=-30){
				alert('秒杀时间已过');
			}
			else{
				alert("离秒杀开始剩余："+residue_hour+"小时"+residue_minute+"分钟"+residue_second+"秒");
			}
			
		});

	}
});

</script>