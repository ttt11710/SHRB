<?php 
/*
 * Plugin Name: order select
 * Plugin URI: 
 * Description: 银联商务订单查询接口插件
 * Version: 1.0.0
 * Author: 
 * Author URI: 
 * Requires at least: 3.3
 * Tested up to: 3.5.1
 *
 * Text Domain: alipay
 * Domain Path: /lang/
 */

add_action( 'admin_menu','add_order_select_menu' );
function add_order_select_menu(){
	$wc_page = 'woocommerce';
	// api: add_submenu_page( $parent_slug, $page_title, $menu_title, $capability, $menu_slug, $function );
	$comparable_settings_page = add_submenu_page( $wc_page , '订单查询', '订单查询', 'manage_options', 'order_pay_select','order_page');
}
function order_page(){
	include 'umspay.php';
	global $wpdb;

	$mypost = array( 'post_type' => 'shop_order','posts_per_page'=>-1 );
	$loop = new WP_Query( $mypost );
	$umspay=new umspay('898000093990002','99999999');
	$order_array=array();
	while ( $loop->have_posts() ){
		$loop->the_post();
		$order_id=get_the_ID();
		$order = new WC_Order( $order_id );
		print_r($order->status);
		// if($order->status='pending'){
		// 	$order_TransId=get_post_meta($order_id,'order_TransId',ture);
		// 	print_r($order_TransId);
		// 	// die;
		// 	// $umspay->seek($order_id,$order_TransId);
		// 	$order_array[]=$order_id;
		// }
	}
	echo '<br/>';
	if(!empty($order_array))
	{
		foreach ($order_array as $value) {

			echo '<p>更新了订单：'.$value.'</p>';
		}
	}
	else{
		echo '<p>无更新订单信息</p>';
	}
	// echo '更新了：'.;
}


?>