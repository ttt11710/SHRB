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
	$qty=$it['item_meta']['_qty'][0];
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
}else if($order->status == 'confirmed'){
	$status='已确认';
}else if($order->status == 'shipping'){
	$status='已发货';
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
	<!-- <img src="<?php echo $img; ?>" /> -->
	<div style="height:auto;padding:13px 10px;margin:20px 13px;background:rgba(0,0,0,0.12);font-size:13px;color(0,0,0,0.87);">
			<img style="display: inline-block;width:20px;margin-right:5px;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/order_title.png'; ?>"/>
			<span style="padding:0;">订单号：<?php echo $order_id; ?></span>
			<br/>
			<span style="margin-left:30px;padding:0;">下单时间：<?php echo date_i18n('Y-m-d H:i', strtotime( $order->order_date ) ); ?></span>
			<br/>
			<span style="margin-left:30px;padding:0;">当前状态：<?php
					if($status=='已验证')
					{
						$status='已完成';
					}
					if($status=='未付款'){
						echo '<span style="color:rgba(0,0,0,0.54);">'.$status.'</span>';
					}
					else{
						echo $status; 
					}
					
					if ($actions) {
						foreach ( $actions as $key => $action ) {
							echo '<a href="' . esc_url( $action['url'] ) . '" class=" ' . sanitize_html_class( $key ) . '" style="margin-bottom:10px;margin-left:20px;color:#000000;">' . esc_html( $action['name'] ) . '</a>';
						}
					}


			?></span>
			<br/>
			<span style="margin-left:30px;padding:0;">实付款：<span style="color:#ff5722"><?php echo $total; ?></span></span>
			<br/>
			<span style="margin-left:30px;padding:0;">数量：<?php echo $qty; ?></span>
			<br/>
			<?php 
				$cat_count = get_the_terms( $product_id, 'product_cat' );
				$button_text=array();
				foreach ($cat_count as $value) {
					$button_text[]=$value->name;
				}
				// print_r($button_text);
				if($status=='未付款' && !in_array('hello_kitty', $button_text)){
					?>
					<span style="margin-left:30px;padding:0;">亲，您还没有付款哦!</span>
					<br/>
					<span style="margin-left:30px;padding:0;">付款成功后才可以获取到订单验证码哦!</span>
					<?php
				}
			?>
<!-- 			<p style="font-size:24px;margin:0;padding:0;color:#ffffff;"><?php echo $order_name; ?></p>
			
			<p style="margin:0;padding:0;color:#ffffff;">活动结束时间：<?php echo $act_end_time; ?></p> -->
	</div>
<?php do_action( 'woocommerce_order_details_after_order_table', $order ); ?>
<?php 
	$qu_id=get_post_meta($order_id,'qid');
?>

<?php 
	$cat_count = get_the_terms( $product_id, 'product_cat' ) ;
	foreach ($cat_count as $value) {
		$button_text[]=$value->name;
	}
	if(!in_array('hello_kitty', $button_text)){
		if($status=='未付款'){
			?>
			<!-- <img src='<?php echo CURRENT_TEMPLATE_DIR."/images/no_pay.jpg" ?>' /> -->

			<?php
		}
		else
		{


		?>
			<div style="width:100%">
				<p style="margin:0;padding:0;text-align:center">请向服务员出示下方8位验证码</p>
				<p style="margin:0 13px;padding:0;text-align:center;font-size:22px;background: rgba(0,0,0,0.12);color(0,0,0,0.87);"><?php echo $qu_id[0]; ?></p>
			</div>
			<p style="margin:10px 13px 30px 13px;padding:0;text-align:center">请将下方二维码，对准商户终端摄像头验证</p>
			<div id="qrcode" data-id="<?php echo $qu_id[0]; ?>">
			</div>
		<?php } ?>


		<div style="width:90%;margin:50px auto;border: 1px solid;border-radius:10px;padding:5px;">
		<?php 
			$poduct_content=get_post($product_id)->post_content;
			print_r($poduct_content);
		?>
		</div>
	<?php 
	}else{
		global $current_user;
		$name=get_user_meta($current_user->id,'shipping_first_name',ture);
		$address=get_user_meta($current_user->id,'shipping_address_1',ture);
		$phone=get_user_meta($current_user->id,'shipping_phone',ture);
		$logistics=get_post_meta($order_id,'pb_order_shipping_id',ture);
		?>
		<div style="text-align: left;font-size:16px;margin:0 13px;">
			<div style="padding:6px 0;color:rgba(0,0,0,0.87);border-bottom:1px solid rgba(0,0,0,0.05);">收货人：<?php echo $name; ?></div>
			<div style="padding:6px 0;color:rgba(0,0,0,0.54);border-bottom:1px solid rgba(0,0,0,0.05);">手机号码：<?php echo $phone; ?></div>
			<div style="padding:6px 0;color:rgba(0,0,0,0.87);border-bottom:1px solid rgba(0,0,0,0.05);">详细地址：<?php echo $address; ?></div>
		<!-- </div>
		<div style="width:100%;text-align: left;"> -->
			<div style="padding:6px 0;color:rgba(0,0,0,0.54);border-bottom:1px solid rgba(0,0,0,0.05);">物流公司：圆通快递</div>
			<div style="padding:6px 0;color:rgba(0,0,0,0.87);border-bottom:1px solid rgba(0,0,0,0.05);">物流单号：<?php echo $logistics; ?></div>
		</div>
		<?php
	}
	?>

<div class="clear"></div>
