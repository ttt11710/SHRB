<?php
/**
 * My Account page
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.0.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce;

wc_print_notices(); ?>

<p class="myaccount_user">
	<?php
	printf(
		__( 'Hello <strong>%1$s</strong> (not %1$s? <a href="%2$s">Sign out</a>).', 'woocommerce' ) . ' ',
		$current_user->display_name,
		wp_logout_url( get_permalink( wc_get_page_id( 'myaccount' ) ) )
	);

  //	printf( __( 'From your account dashboard you can view your recent orders, manage your shipping and billing addresses and <a href="%s">edit your password and account details</a>.', 'woocommerce' ),
	//	wc_customer_edit_account_url()	);
  // echo get_template_directory_uri().'/ugen/goodsSync.js.php';
	//include('../../ugen/goodsSync.js.php');
	?>
	<div id="test">
	
		<?php include(get_stylesheet_directory().'/ugen/goodsSync.js.php'); ?>
		<input type="hidden" value="<?php echo bloginfo('template_directory'); ?>" id ="imgurl"/>
	</div>
</p>
<?php
    global $woocommerce;
    $customer_orders = get_posts( apply_filters( 'woocommerce_my_account_my_orders_query', array(
    'numberposts' => $order_count,
    'meta_key'    => '_customer_user',
    'meta_value'  => get_current_user_id(),
    'post_type'   => 'shop_order',
    'post_status' => 'publish'
) ) );

$index = 0;
$count = 0;
foreach ( $customer_orders as $customer_order ) {
                $order = new WC_Order();
                $order->populate( $customer_order );
                $status     = get_term_by( 'slug', $order->status, 'shop_order_status' );
                $item_count = $order->get_item_count();
                $itemss = $order->get_items();
    if ( in_array( $order->status, apply_filters( 'woocommerce_valid_order_statuses_for_payment', array( 'pending','failed'), $order ) ) ):
     foreach( $itemss as $it){
                    $index++;
         }
     endif;

	if($order->status == "paid" ):
		foreach($itemss as $it){
				$count++;
		}
	endif;
}
?>
<?php 
	$nopaypage = get_page_id('myorder');
	$paypage = get_page_id('carry_now');
	$deliverypage = get_page_id('order_delivery');
  	$nopayurl = get_permalink($nopaypage);
	$payurl = get_permalink($paypage);
	$deliveryurl = get_permalink($deliverypage);
 ?>

<div id="my_count_order">
	<a id="lnkpay" href="<?php echo $nopayurl; ?>"><p id="payingorder"><span id="payord">待支付订单</span><span id="payordnum"><?php echo $index;?>张</span></p></a>
	<hr/>
	<a id="lnkpadord" href="<?php echo $payurl;?>"><p id="paiedorder"><span id="padord">配送单</span><span id="padordnum"><?php echo $count;?>张</span></p></a>
	<hr/>
	<a id="lnksend" href="<?php echo $deliveryurl ;?>"><p id="sendorder"><span id="sendord">提货单</span><span id="sendordnum"><?php echo 0;?>张</span></p></a>
	<hr/>
</div>

<?php //do_action( 'woocommerce_before_my_account' ); ?>
<?php //echo $order_count ?>
<?php //wc_get_template( 'myaccount/my-downloads.php' ); ?>

<?php //wc_get_template( 'myaccount/my-orders.php', array( 'order_count' => $order_count ) ); ?>

<?php //wc_get_template( 'myaccount/my-address.php' ); ?>

<?php //do_action( 'woocommerce_after_my_account' ); ?>
