<?php 
/*
Plugin Name: wechat_order
Plugin URI: 
Description: wechat_order
Version: 1.0
Author: 
Author URI: 
*/
add_action('init','pb_wechat');
function pb_wechat(){
	if($_POST['action']=='wechat_order')
		add_action( 'wp_ajax_nopriv_'.$_POST['action'].'', 'wechat_order', 10);
	// add_action( 'wp_ajax_nopriv_'.$_POST['action'].'', 'wechat_order', 10);
}


function wechat_order()
{
	global $wpdb;
	$checkout = new WC_Checkout();
	$order_id = $checkout->create_order();
	$order = new WC_Order( $order_id );
	$q_code=wechat_ceate_qid();
	$pid=0;
	$item['product_id'] = $pid;
	$item['name'] = $_POST['GoodName'];
	$item['qty']               = 1;
	$item['line_total']        = $_POST['totalPrice'];
	// $item['qty'] = 1;
	update_post_meta( $order->id, 'wechat_name',$_POST['GoodName']);
	update_post_meta( $order->id, 'wechat_status',$_POST['status']);
	$item_id = wc_add_order_item( $order_id, array(
		'order_item_name'       => $item['name'],
		'order_item_type'       => 'line_item'
	));
	if ($item_id) 
	{
		wc_add_order_item_meta( $item_id, '_qty', $item['qty'] );
		wc_add_order_item_meta( $item_id, '_product_id', $item['product_id'] );
	}
	update_post_meta( $order->id, '_order_total',  $item['line_total'] );
	update_post_meta($order_id,'wechat_order_id',$_POST['orderId']);
	
	$u_id=0;
	$time=current_time('timestamp');
	$pay_order_id=0;
	$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where order_id={$order_id}");
	if($is_one==0)
	{
		// print_r("INSERT INTO wp_gcommerce_yhq (qu_id, use_id, order_id,p_id,rec_time,pay_order_id) VALUES ({$q_code},{$u_id},{$order_id},{$pid},{$time},'{$pay_order_id}')");
		// die;
		$wpdb->query("INSERT INTO wp_gcommerce_yhq (qu_id, use_id, order_id,p_id,rec_time,pay_order_id) VALUES ({$q_code},{$u_id},{$order_id},{$pid},{$time},'{$pay_order_id}')");
	}
	$order->update_status('paid', '已支付');
	echo json_encode(array('status'=>'1000','q_code'=>$q_code));
	exit();
}

function wechat_ceate_qid()
{
	global $wpdb;
	$q_id=rand(100000,999999);
	$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where qu_id={$q_id}");
	if($is_one>0)
	{
		wechat_ceate_qid($pid);
	}
	return $q_id;
}

function send_orderId($url,$data){
	// $url = "http://192.168.10.211:8080/bankchat/useTicket";
	// $post_data = array('orderId'=>$oid);
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	// post数据
	curl_setopt($ch, CURLOPT_POST, 1);
	// post的变量
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
	$output = curl_exec($ch);
	curl_close($ch);
	//打印获得的数据
	return $output;
}
//http://localhost:8080/bankchat/useTicket?orderId=1432115058917
?>