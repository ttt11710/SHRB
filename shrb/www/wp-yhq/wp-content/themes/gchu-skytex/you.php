<?php get_header();?>
<?php
/**
    Template Name:cofco
 */
?>
<style type="text/css">
.index_li{
    width:40%;
    float:left;
    margin:5px 5%;
}
.index_li div{
	width: 100%;
	margin: 0;
	padding: 0;
}
.index_li p{
	margin-top:5px;margin-bottom: 0;text-align: center;font-size:16px;font-weight:bold
}
p{
	margin: 0;
}
</style>
<?php
	$pid=select_all_product();
	$cofcoo=$pid['cofcoo'];
	$cofcoo_milk=$pid['cofcoo_milk'];
?>
<img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/cofcoo_title.jpg' ?>" />
<div style="padding-bottom: 20px;">
	<p class="you_title" style="width: 100%;margin-top: 5px;border-top: 3px solid #bdbdbd;font-size:18px;">交行专属油</p>
	<ul style="overflow:hidden;margin:5px;">
		<?php 
			foreach ($cofcoo as $key => $value) {
				$pb_product=get_product($value,$fields = null);
				$medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($value), 'medium');
		?>
		<li style="border-top:1px solid #bdbdbd;overflow:hidden;padding-top: 5px;">
			<div>
				<div style="float:left; width:50%;">
					<img src="<?php echo $medium_image_url[0]; ?>" />
				</div>
				<div style="margin-left:5px;width:45%;float:left;line-height: 1.5;">
					<span style="font-size:13px;color:#000000;line-height: 1.2;"><?php echo $pb_product->post->post_title; ?></span>
					</br>
					<span style="font-size:14px;color:#ff0404">专属价:</span><br/><span style="font-size:14px;color:#ff0404"><?php echo '￥'.$pb_product->sale_price; ?>&nbsp&nbsp</span><span style="text-decoration:line-through; text-decoration;font-size:14px;color:#bdbdbd"><?php echo '￥'.$pb_product->regular_price; ?></span>
					</br>
					<a style="background: #eb6100;padding: 5px 15px;color: #ffffff;border-radius: 5px;" href="<?php echo home_url().'/?p='.$value?>">去购买</a>
				</div>
			</div>
		</li>
		<?php
			}
		?>
	</ul>
		<p class="you_title" style="width: 100%;margin-top: 5px;border-top: 3px solid #bdbdbd;font-size:18px;">交行专属牛奶</p>
	<ul style="overflow:hidden;margin:5px;">
		<?php 
			foreach ($cofcoo_milk as $key => $value) {
				$pb_product=get_product($value,$fields = null);
				$medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($value), 'medium');
		?>
		<li style="border-top:1px solid #bdbdbd;overflow:hidden;padding-top: 5px;">
			<div>
				<div style="float:left; width:50%;">
					<img src="<?php echo $medium_image_url[0]; ?>" />
				</div>
				<div style="margin-left:5px;width:45%;float:left;line-height: 1.5;">
					<span style="font-size:13px;color:#000000;line-height: 1.2;"><?php echo $pb_product->post->post_title; ?></span>
					</br>
					<span style="font-size:14px;color:#ff0404">专属价:</span><br/><span style="font-size:14px;color:#ff0404"><?php echo '￥'.$pb_product->sale_price; ?>&nbsp&nbsp</span><span style="text-decoration:line-through; text-decoration;font-size:14px;color:#bdbdbd"><?php echo '￥'.$pb_product->regular_price; ?></span>
					</br>
					<a style="background: #eb6100;padding: 5px 15px;color: #ffffff;border-radius: 5px;" href="<?php echo home_url().'/?p='.$value?>">去购买</a>
				</div>
			</div>
		</li>
		<?php
			}
		?>
	</ul>
</div>