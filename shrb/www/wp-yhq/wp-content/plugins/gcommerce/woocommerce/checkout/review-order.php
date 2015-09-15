<?php
/**
 * Review order form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly
// $cart_pid;
// foreach ( WC()->cart->get_cart() as $cart_item_key => $cart_item ) {
// 	$cart_pid=$cart_item['product_id'];	

// }
// print_r($cart_pid);
?>
<div id="order_review" >
	<!-- <p style="width:90%;border: 1px solid;border-radius:10px;margin:10px auto;padding:5px;">尊敬的顾客您好！订单确认成功后，我们将下发一条短信到您手机中。凭短信中的优惠券验证码或短信链接订单详情中的二维码，到指定商家验证使用。</p> -->
		<!-- <img src="<?php echo CURRENT_TEMPLATE_DIR."/images/order-no.png" ?>" /> -->
		<p style="background:rgba(0,0,0,0.05);color:rgba(0,0,0,0.87);padding:8px 10px;margin:0;">订单明细</p>
		<table style="width:90%;">
			<?php
				do_action( 'woocommerce_review_order_before_cart_contents' );
				$cart_pid;
				foreach ( WC()->cart->get_cart() as $cart_item_key => $cart_item ) {
					$cart_pid=$cart_item['product_id'];	
				}
				// print_r($cart_pid);
				$customer_orders = get_posts( apply_filters( 'woocommerce_my_account_my_orders_query', array(
					'numberposts' => $order_count,
					'meta_key'    => '_customer_user',
					'meta_value'  => get_current_user_id(),
					'post_type'   => 'shop_order',
					'post_status' => 'publish'
				) ) );
				$is_receive=0;
				foreach ( $customer_orders as $customer_order ) {
					$order = new WC_Order();
					$order->populate( $customer_order );
					// print_r($order->get_items());
					foreach ($order->get_items() as $item) {
						// print_r($item['product_id']);
						if($item['product_id']==$cart_pid){
							$is_receive=1;
							break;
						}
					}
				}
				if($is_receive==1)
				{
					// print_r($cart_pid);
					$button_text=array();
					$cat_count = get_the_terms($cart_pid, 'product_cat' );
					foreach ($cat_count as $value) {
						$button_text[]=$value->name;
					}
					// print_r($button_text);
					if(!in_array('实体商品', $button_text)){
						?>
								<script type="text/javascript">
									jQuery( function($){
										$("#order_review").hide();
										$("#pb_review_used").show();
									});
								</script>
						<?php
					}
				}
				foreach ( WC()->cart->get_cart() as $cart_item_key => $cart_item ) {
					$_product     = apply_filters( 'woocommerce_cart_item_product', $cart_item['data'], $cart_item, $cart_item_key );

					if ( $_product && $_product->exists() && $cart_item['quantity'] > 0 && apply_filters( 'woocommerce_checkout_cart_item_visible', true, $cart_item, $cart_item_key ) ) {
						?>
						<tr class="<?php echo esc_attr( apply_filters( 'woocommerce_cart_item_class', 'cart_item', $cart_item, $cart_item_key ) ); ?>">
							<td class="product-name">
								<?php echo apply_filters( 'woocommerce_cart_item_name', $_product->get_title(), $cart_item, $cart_item_key ); ?>
								<?php echo apply_filters( 'woocommerce_checkout_cart_item_quantity', ' <strong class="product-quantity">' . sprintf( '&times; %s', $cart_item['quantity'] ) . '</strong>', $cart_item, $cart_item_key ); ?>
								<?php echo WC()->cart->get_item_data( $cart_item ); ?>
							</td>
							<td class="product-total" style="color:red !important;">
								<?php echo apply_filters( 'woocommerce_cart_item_subtotal', WC()->cart->get_product_subtotal( $_product, $cart_item['quantity'] ), $cart_item, $cart_item_key ); ?>
							</td>
						</tr>
						<?php
					}
				}

				do_action( 'woocommerce_review_order_after_cart_contents' );
			?>
		</table>
	<?php do_action( 'woocommerce_review_order_before_payment' ); ?>
	<p style="background:rgba(0,0,0,0.05);color:rgba(0,0,0,0.87);padding:8px 10px;margin:0">支付方式</p>
	<div id="payment" style="width:100%;margin:10px 0 0 0;">
		<?php if ( WC()->cart->needs_payment() ) : ?>
		<ul class="payment_methods methods">
			<?php
				$available_gateways = WC()->payment_gateways->get_available_payment_gateways();
				if ( ! empty( $available_gateways ) ) {

					// Chosen Method
					if ( isset( WC()->session->chosen_payment_method ) && isset( $available_gateways[ WC()->session->chosen_payment_method ] ) ) {
						$available_gateways[ WC()->session->chosen_payment_method ]->set_current();
					} elseif ( isset( $available_gateways[ get_option( 'woocommerce_default_gateway' ) ] ) ) {
						$available_gateways[ get_option( 'woocommerce_default_gateway' ) ]->set_current();
					} else {
						current( $available_gateways )->set_current();
					}

					foreach ( $available_gateways as $gateway ) {
						?>
						<li class="payment_method_<?php echo $gateway->id; ?>">
							<input id="payment_method_<?php echo $gateway->id; ?>" type="radio" class="input-radio" name="payment_method" value="<?php echo esc_attr( $gateway->id ); ?>" <?php checked( $gateway->chosen, true ); ?> data-order_button_text="<?php echo esc_attr( $gateway->order_button_text ); ?>" />
							<label class="pb_label" for="payment_method_<?php echo $gateway->id; ?>"><?php echo $gateway->get_title(); ?> <?php echo $gateway->get_icon(); ?></label>
							<?php
								if ( $gateway->has_fields() || $gateway->get_description() ) :
									echo '<div class="payment_box payment_method_' . $gateway->id . '" ' . ( $gateway->chosen ? '' : 'style="display:none;"' ) . '>';
									$gateway->payment_fields();
									echo '</div>';
								endif;
							?>
						</li>
						<?php
					}
				} else {

					if ( ! WC()->customer->get_country() )
						$no_gateways_message = __( 'Please fill in your details above to see available payment methods.', 'woocommerce' );
					else
						$no_gateways_message = __( 'Sorry, it seems that there are no available payment methods for your state. Please contact us if you require assistance or wish to make alternate arrangements.', 'woocommerce' );

					echo '<p>' . apply_filters( 'woocommerce_no_available_payment_methods_message', $no_gateways_message ) . '</p>';

				}
			?>
		</ul>
		<?php endif; ?>

		<div class="form-row place-order">

			<noscript><?php _e( 'Since your browser does not support JavaScript, or it is disabled, please ensure you click the <em>Update Totals</em> button before placing your order. You may be charged more than the amount stated above if you fail to do so.', 'woocommerce' ); ?><br/><input type="submit" class="button alt" name="woocommerce_checkout_update_totals" value="<?php _e( 'Update totals', 'woocommerce' ); ?>" /></noscript>

			<?php wp_nonce_field( 'woocommerce-process_checkout' ); ?>

			<?php do_action( 'woocommerce_review_order_before_submit' ); ?>

			<?php
			$order_button_text = apply_filters( 'woocommerce_order_button_text', __( 'Place order', 'woocommerce' ) );

			echo apply_filters( 'woocommerce_order_button_html', '<input type="submit" class="button alt" name="woocommerce_checkout_place_order" id="place_order" style="width:100%;font-size18px;" value="确认支付" data-value="确认支付" />' );
			?>

			<?php if ( wc_get_page_id( 'terms' ) > 0 && apply_filters( 'woocommerce_checkout_show_terms', true ) ) { 
				$terms_is_checked = apply_filters( 'woocommerce_terms_is_checked_default', isset( $_POST['terms'] ) );
				?>
				<p class="form-row terms">
					<label for="terms" class="checkbox"><?php printf( __( 'I&rsquo;ve read and accept the <a href="%s" target="_blank">terms &amp; conditions</a>', 'woocommerce' ), esc_url( get_permalink( wc_get_page_id( 'terms' ) ) ) ); ?></label>
					<input type="checkbox" class="input-checkbox" name="terms" <?php checked( $terms_is_checked, true ); ?> id="terms" />
				</p>
			<?php } ?>

			<?php do_action( 'woocommerce_review_order_after_submit' ); ?>

		</div>

		<div class="clear"></div>

	</div>

	<?php do_action( 'woocommerce_review_order_after_payment' ); ?>

</div>
<div id="pb_review_used" style="display:none;text-align: center;">
	<p style="width:80%;border: 1px solid;border-radius:10px;margin:10px auto;padding:5px">亲，不要太贪心哦！本次活动每人只限参加一次</p>
	<p style="text-align: center;"><a class="button" href="<?php echo home_url(); ?>">查看其它活动</a></p>
</div>
<!-- // <script>
// 	alert('优惠券领取成功');
// 	window.location.href='<?php echo home_url();?>/myaccount/';
// </script> -->