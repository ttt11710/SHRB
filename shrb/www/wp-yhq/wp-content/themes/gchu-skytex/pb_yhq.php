<?php get_header();?>
<?php
/**
    Template Name:pb_yhq
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
	// $pid=select_all_product();
	// $cofcoo=$pid['kitty'];
	// print_r($cofcoo);
	global $wpdb;
	$preferential=$wpdb->get_results("SELECT wp_posts.ID,wp_posts.post_title,wp_terms.name FROM `wp_posts`
left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
where post_type='product' and post_status='publish' and wp_terms.name='虚拟商品' and wp_posts.ID not in (SELECT wp_posts.ID FROM `wp_posts`
left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
where post_type='product' and post_status='publish' and wp_terms.name='preferential')",ARRAY_A);
	$store=array();
	foreach ($preferential as $key => $value) {
		$store[]=$value['ID'];
	}
?>
<!-- <img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/hello_title.jpg' ?>" /> -->
<div style="padding-bottom: 20px;">
	<!-- <p class="you_title" style="width: 100%;margin-top: 5px;border-top: 0px solid #ff6088;background:#e00059;height:30px"></p> -->
	<div style="margin-bottom:10px;">
		<span style="margin-left:13px;">超值优惠</span>
	</div>
	<ul style="overflow:hidden;background:rgba(0,0,0,0.05);">
		<?php 
			foreach ($store as $key => $value) {
				$pb_product=get_product($value,$fields = null);
				$medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($value), 'medium');
		?>
		<li style="overflow:hidden;padding-top: 5px;background:#ffffff;margin-top:5px;text-align:left;border: 1px solid rgba(0,0,0,0.12);width:90%;margin-left:13px">
			<div>
				<div style="float:left; width:40%;margin:9px 10px 9px 13px;">
					<img src="<?php echo $medium_image_url[0]; ?>" />
				</div>
				<div style="margin-left:10px;margin-top:11px;margin-bottom:8px;width:45%;float:left;">
					<span style="font-size:13px;color:rgba(0,0,0,0.87)"><?php echo $pb_product->post->post_title; ?></span>
					</br>
					<span style="font-size:11px;color:#fe5722;">专属价:<?php echo '￥'.$pb_product->sale_price; ?>&nbsp&nbsp</span>
					<span style="text-decoration:line-through; text-decoration;font-size:11px;color:rgba(0,0,0,0.54)">
						<?php 
							if(!empty($pb_product->regular_price)){
								echo '￥'.$pb_product->regular_price; 
							}
						?>
					</span>
					</br>
				</div>
			</div>
			<br style="clear:both"/>
			<a style="color: rgba(0,0,0,0.87);width:100%;font-size:15px" href="<?php echo home_url().'/?p='.$value?>"><div style="background: rgba(0,0,0,0.12);text-align:center">去购买</div></a>
		</li>
		<?php
			}
		?>
	</ul>
</div>