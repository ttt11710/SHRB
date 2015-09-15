<?php get_header('vs');?>
<?php
/**
    Template Name:test_t
 */
?>
<?php 	
	$flashSalse_id=$_GET['flashSalse_id'];
	$product_id=get_post_meta($flashSalse_id,"product_id",ture);
	$flashSalse_price=get_post_meta($flashSalse_id,"flash_salse_price",ture);
	$medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($product_id), 'medium');

	$current_time=current_time('timestamp');
	//开始时间
	$startTime=get_post_meta($flashSalse_id,"start_time",ture);
	//结束时间
	$endTime=get_post_meta($flashSalse_id,"end_time",ture);
	$js_current_time=date('Y/m/d H:i:s',$current_time);
	// print_r();15873804420  1990M815
?>
<div style="border:1px solid #ff5722;margin:10px 31px auto 31px;position: relative;">
	<div style="width:80px;height:80px;border-radius:40px;background:#b71c1c;color:#ffffff;position: absolute;top:30px;z-index: 3;">
		<span style="display:inline-block;margin-left: 15px;margin-top: 7px;font-size:14px">秒杀价：</span><br/>
		<span style="display:inline-block;margin-left: 10px;font-size:16px"><?php echo $flashSalse_price; ?>元</span>
	</div>
	<div style="border:0px solid #ff5722;width:50%;position: relative; z-index: 2;margin-left: 15px;margin-top: 57px;">
		<img src="<?php echo $medium_image_url[0]; ?>">
	</div>
	<img style="position: absolute;left:15px;top:30px;z-index: 1;width: 95%;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/flash_salse_index.png' ?>" />
</div>

<img src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_sales_j2.png" ?>">
<!-- <a href="<?php echo home_url().'?p='.$flashSalse_id; ?>" style=""> -->
	<div id="url_jump" style="z-index:999;position:fixed;bottom:5px;left:0;right:0;font-size:20px;color:#a40000;padding: 13px;background:#f8c011;text-align:center;margin-left:31px;margin-right:31px;font-size:20px;">
		开始秒杀
	</div>
<!-- </a> -->
<div style="margin:10px 31px;border:1px dashed rgba(0,0,0,0.54);border-radius: 5px;font-size:13px;color:rgba(0,0,0,0.54);">
	<span>安全保证：</span>
	<br/>
	<span>本热点wifi是闭环控制，信息只提供本店使用，不会外泄，绝对保证您的信息安全</span>
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