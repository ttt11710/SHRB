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
if ($order->status == 'processing' || $order->status == 'pending') {
	$status='待验证';
} else if ($order->status == 'completed') {
	$status='已验证';                             
} else {
    $status='已失效';                                 
}
$act_end_time=get_post_meta($product_id,"activity_end_copy");
$act_end_time=strtotime($act_end_time[0]);
$act_end_time=date('Y-m-d H:i',$act_end_time);
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
	<div style="width:90%;height:auto;margin:10px auto;padding:10px;border: 1px solid;border-radius:10px;margin:10px auto">
			<p style="font-size:24px;margin:0;padding:0"><?php echo $order_name; ?></p>
			<p style="margin:0;padding:0;color:red;">优惠券价格：<?php echo $total; ?></p>
			<p style="margin:0;padding:0">领取日期：<?php echo date_i18n('Y-m-d H:i', strtotime( $order->order_date ) ); ?></p>
			<p style="margin:0;padding:0">活动结束时间：<?php echo $act_end_time; ?></p>
			<p style="margin:0;padding:0;color:blue">当前状态：<?php echo $status; ?></p>
	</div>
<?php do_action( 'woocommerce_order_details_after_order_table', $order ); ?>
<?php 
	$qu_id=get_post_meta($order_id,'qid');
?>
<hr/>
<div style="width:100%">
	<p style="margin:0;padding:0;text-align:center">请向服务员出示下方8位验证码</p>
	<p style="margin:0 0 0 15px;padding:0;text-align:center;font-size:22px;"><?php echo $qu_id[0]; ?></p>
</div>
<hr/>
<p style="margin:10px auto 30px auto;padding:0;text-align:center">请将下方二维码，对准商户终端摄像头验证</p>
<div id="qrcode" data-id="<?php echo $qu_id[0]; ?>">
</div>
<div style="width:90%;margin:50px auto;border: 1px solid;border-radius:10px;padding:5px;">
<?php 
	$poduct_content=get_post($product_id)->post_content;
	print_r($poduct_content);
?>
</div>
<div class="clear"></div>
