<?php
/* 
Plugin Name: Flash Salse
Plugin URI: http://www.u-gen.net
Description: 秒杀插件
Version: 1.0.140923
Author: U-gen
*/
add_action('init', 'pb_flash_salse');
//初始化插件
function pb_flash_salse()
{
	// print_r(plugins_url()."/flash_salse/js/jquery.knob.js");
	
}
//加载js
add_action( 'wp_enqueue_scripts', 'flashSalse_js', 999999 );
function flashSalse_js(){
	wp_enqueue_script( 'knob-script', plugins_url()."/flash_salse/js/jquery.knob.js");
}
//秒杀ajax
add_action('wp_ajax_nopriv_flashSale_create_order', 'flashSale_create_order');
add_action('wp_ajax_flashSale_create_order', 'flashSale_create_order');
function flashSale_create_order(){
	if(!isset($_GET['flashSale_id']))
	{	
		exit();
	}
	$time=current_time('timestamp');
	global $wpdb;
	$flashSalse_id=$_GET['flashSale_id'];
	$starttime=get_post_meta($flashSalse_id,'start_time',ture);
	$endtime=get_post_meta($flashSalse_id,'end_time',ture);
	$flashSalse_all=get_post_meta($flashSalse_id,'flash_salse_number',ture);
	// print_r($time."|");
	// print_r(strtotime($starttime)."|");
	// print_r(strtotime($endtime)."|");
	header("Content-Type: application/json");
	if (is_user_logged_in()) { 
		//登入
		global $current_user;
		$people_number=pb_select_group_user($current_user->ID,$flashSalse_id);
		if($people_number>0){
			echo json_encode(array('code'=>1001,'msg'=>'您已参加过次活动'));
			exit;
		}
	}
	// pb_select_group_user();
	if($time<strtotime($starttime)){
		//未开始
		echo json_encode(array('code'=>1001,'msg'=>'秒杀时间未到'));
	}
	else if($time>strtotime($endtime)){
		//结束
		echo json_encode(array('code'=>1002,'msg'=>'秒杀时间已过'));
	}
	else if ($actual_number>=$flashSalse_all) {
		echo json_encode(array('code'=>1002,'msg'=>'已售罄'));
	}
	else{
		header("Content-Type: application/json");
		$checkout = new WC_Checkout();
		$order_id = $checkout->create_order();
		$order = new WC_Order( $order_id );
		$q_code=flashSalse_ceate_qid();
		$product_id=get_post_meta($flashSalse_id,'product_id',ture);
		$flashSalse_price=get_post_meta($flashSalse_id,"flash_salse_price",ture);
		$product_info=get_product($product_id,$fields = null);
		$item['product_id'] = $product_id;
		$item['name'] = $product_info->post->post_title;
		$item['qty']               = 1;
		$item['line_total']        = $flashSalse_price;
		$item_id = wc_add_order_item( $order_id, array(
			'order_item_name'       => $item['name'],
			'order_item_type'       => 'line_item'
		));
		update_post_meta($order_id,"flash_salse_id",$flashSalse_id);
		if ($item_id) 
		{
			wc_add_order_item_meta( $item_id, '_qty', $item['qty'] );
			wc_add_order_item_meta( $item_id, '_product_id', $item['product_id'] );
			wc_add_order_item_meta( $item_id, '_line_total', $item['line_total'] );
			wc_add_order_item_meta( $item_id, '_flash_salse', $flashSalse_id );
		}
		update_post_meta( $order->id, '_order_total',  $item['line_total'] );
		$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where order_id={$order_id}");
		if($is_one==0)
		{
			$wpdb->query("INSERT INTO wp_gcommerce_yhq (qu_id, use_id, order_id,p_id,rec_time,pay_order_id) VALUES ({$q_code},{$u_id},{$order_id},{$pid},{$time},'{$pay_order_id}')");
		}
		echo json_encode(array('code'=>1000,'msg'=>'秒杀成功','order_id'=>$order_id));
	}
	exit;
}
//获取参加秒杀人数
function get_flashSalse_nubmer($flashSalse_id){
	global $wpdb;
	//SELECT count(*) FROM wp_woocommerce_order_items
// left join wp_woocommerce_order_itemmeta ON (wp_woocommerce_order_itemmeta.order_item_id = wp_woocommerce_order_items.order_item_id)
// left JOIN wp_term_relationships ON (wp_term_relationships.object_id = wp_woocommerce_order_items.order_id)
// left join wp_terms ON (wp_terms.term_id = wp_term_relationships.term_taxonomy_id)
// where wp_woocommerce_order_itemmeta.meta_key = '_flash_salse'
// and wp_woocommerce_order_itemmeta.meta_value = 311 and (wp_terms.name='pending' or wp_terms.name='paid' or wp_terms.name='completed')
	$pb_activity_people=$wpdb->get_var("SELECT count(*) FROM wp_woocommerce_order_items
										left join wp_woocommerce_order_itemmeta ON (wp_woocommerce_order_itemmeta.order_item_id = wp_woocommerce_order_items.order_item_id)
										left JOIN wp_term_relationships ON (wp_term_relationships.object_id = wp_woocommerce_order_items.order_id)
										left join wp_terms ON (wp_terms.term_id = wp_term_relationships.term_taxonomy_id)
										where wp_woocommerce_order_itemmeta.meta_key = '_flash_salse'
										and wp_woocommerce_order_itemmeta.meta_value = {$flashSalse_id} and (wp_terms.name='pending' or wp_terms.name='paid' or wp_terms.name='completed')");
	// print_r($pb_activity_people);
	return $pb_activity_people;

}
//用户是否有参加过活动
function pb_select_group_user($uid,$flashSalse_id){
	global $wpdb;
	$pb_activity_opportunity=$wpdb->get_var("SELECT count(*) from wp_woocommerce_order_items
									left join wp_postmeta ON (wp_postmeta.post_id = wp_woocommerce_order_items.order_id)
									left JOIN wp_woocommerce_order_itemmeta ON (wp_woocommerce_order_items.order_item_id = wp_woocommerce_order_itemmeta.order_item_id)
									left join wp_term_relationships ON (wp_term_relationships.object_id = wp_woocommerce_order_items.order_id)
									left JOIN wp_terms ON (wp_terms.term_id = wp_term_relationships.term_taxonomy_id)
									where wp_postmeta.meta_key = '_customer_user'
									and wp_postmeta.meta_value = {$uid}
									and wp_woocommerce_order_itemmeta.meta_key = '_flash_salse'
									and wp_woocommerce_order_itemmeta.meta_value = {$flashSalse_id}
									and (wp_terms.name='pending' or wp_terms.name='paid' or wp_terms.name='completed')");
	return $pb_activity_opportunity;
}
//生成随机验证码
function flashSalse_ceate_qid()
{
	global $wpdb;
	$q_id=rand(100000,999999);
	$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where qu_id={$q_id}");
	if($is_one>0)
	{
		flashSalse_ceate_qid();
	}
	return $q_id;
}
//调用秒杀模板
add_filter( 'template_include','pb_flash_salse_template');
function pb_flash_salse_template($template)
{
	if(get_post_type()=="flash_salse"){
		$template=plugin_dir_path( __FILE__ )."templet/flash_salse_templet.php";
	}
	return $template;
}