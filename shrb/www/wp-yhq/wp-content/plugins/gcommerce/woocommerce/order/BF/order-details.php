<?php
/**
 * Order details
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce;

$order = new WC_Order( $order_id );
$items=$order->get_items();
$order_name=null;
foreach ($items as $it) {
	$order_name=$it['name'];
	$product_id=$it['product_id'];
}
$medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($product_id), 'thumbnail');
$total=null;
if ( $totals = $order->get_order_item_totals() ) foreach ( $totals as $total ) :
// print_r($total);
if($total['label']=='订单合计：')
{
	$total=$total['value'];
}
endforeach;
$status;
$img;
if ($order->status == 'processing' || $order->status == 'pending') {
	$string=substr(strip_tags($total),5);
	if($string=='0.00'){
		$img=CURRENT_TEMPLATE_DIR."/images/order-pay.png";
		$status='已支付'; 
	}else{
		$img=CURRENT_TEMPLATE_DIR."/images/order-no.png";
		$status='未付款';
	}
	
} else if ($order->status == 'paid' || ($order->status == 'processing' && $total==0)) {
	$img=CURRENT_TEMPLATE_DIR."/images/order-pay.png";
	$status='已支付';                             
} else if ($order->status == 'completed') {
	$img=CURRENT_TEMPLATE_DIR."/images/order-completed.png";
	$status='已验证';                             
}else {
	$img=CURRENT_TEMPLATE_DIR."/images/order-ca.png";
    $status='已失效';                                 
}
$act_end_time=get_post_meta($product_id,"end");
$act_end_time=strtotime($act_end_time[0]);
$act_end_time=date('Y-m-d H:i',$act_end_time);
if($status=='未付款')
{
	$actions=array();
	if ( in_array( $order->status, apply_filters( 'woocommerce_valid_order_statuses_for_payment', array( 'pending', 'failed' ), $order ) ) ) {
		$actions['pay'] = array(
			'url'  => $order->get_checkout_payment_url(),
			'name' => __( '立即付款', 'woocommerce' )
		);
	}
	$actions = apply_filters( 'woocommerce_my_account_my_orders_actions', $actions, $order );
	// print_r($actions);

}
?>

<!-- <h2><?php _e( 'Order Details', 'woocommerce' ); ?></h2> -->


<?php 
		// if ($order->status == 'paying') {
		// 	$current_status = '等待付款';
		// } else if ($order->status == 'paid') {
		// 	$current_status = '已付款';
		// } else {
			$current_status = __( $status->name, 'woocommerce' );
		// }
	?>
	<!-- <h3>订单号：<?php echo $order->get_order_number(); ?> </h3> -->
	<img src="<?php echo $img; ?>" />
	<div style="width:90%;height:auto;margin:10px auto;padding:10px;border: 1px solid;border-radius:10px;margin:10px auto">
			<p style="font-size:24px;margin:0;padding:0"><?php echo $order_name; ?></p>
			<p style="margin:0;padding:0;color:red;">优惠券价格：<?php echo $total; ?></p>
			<p style="margin:0;padding:0">领取日期：<?php echo date_i18n('Y-m-d H:i', strtotime( $order->order_date ) ); ?></p>
			<p style="margin:0;padding:0">活动结束时间：<?php echo $act_end_time; ?></p>
			<p style="margin:0;padding:0;color:blue">当前状态：<?php
					if($status=='已验证')
					{
						$status='已完成';
					}
					echo $status; 
					if ($actions) {
						foreach ( $actions as $key => $action ) {
							echo '<a href="' . esc_url( $action['url'] ) . '" class=" ' . sanitize_html_class( $key ) . '" style="margin-bottom:10px;margin-left:20px;color:#000000;">' . esc_html( $action['name'] ) . '</a>';
						}
					}


			?></p>
	</div>
<?php do_action( 'woocommerce_order_details_after_order_table', $order ); ?>
<?php 
	$qu_id=get_post_meta($order_id,'qid');
?>
<hr/>
<?php 
if($status=='未付款'){
	?>
	<img src='<?php echo CURRENT_TEMPLATE_DIR."/images/no_pay.jpg" ?>' />

	<?php
}
else{


?>
	<div style="width:100%">
		<p style="margin:0;padding:0;text-align:center">请向服务员出示下方8位验证码</p>
		<p style="margin:0 0 0 15px;padding:0;text-align:center;font-size:22px;"><?php echo $qu_id[0]; ?></p>
	</div>
	<hr/>
	<p style="margin:10px auto 30px auto;padding:0;text-align:center">请将下方二维码，对准商户终端摄像头验证</p>
	<div id="qrcode" data-id="<?php echo $qu_id[0]; ?>">
	</div>
<?php } ?>
<div style="width:90%;margin:50px auto;border: 1px solid;border-radius:10px;padding:5px;">
<?php 
	$poduct_content=get_post($product_id)->post_content;
	print_r($poduct_content);
?>
</div>
<div class="clear"></div>
