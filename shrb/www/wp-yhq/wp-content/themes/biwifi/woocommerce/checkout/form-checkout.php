<?php
/**
 * Checkout Form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.0.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce;

wc_print_notices();

do_action( 'woocommerce_before_checkout_form', $checkout );

// If checkout registration is disabled and not logged in, the user cannot checkout
if ( ! $checkout->enable_signup && ! $checkout->enable_guest_checkout && ! is_user_logged_in() ) {
	echo apply_filters( 'woocommerce_checkout_must_be_logged_in_message', __( 'You must be logged in to checkout.', 'woocommerce' ) );
	$myaccount_page_id = get_option( 'woocommerce_myaccount_page_id' );   
	echo '----------'.$myaccount_page_id;
	if ( $myaccount_page_id ) {   
  		$myaccount_page_url = get_permalink( $myaccount_page_id );
  		$checkout_page_url = $woocommerce->cart->get_checkout_url();
		echo 'xxx:'.$checkout_page_url.'sss:'.$myaccount_page_url;
		wp_safe_redirect(add_query_arg( 'redirect', esc_url($checkout_page_url), $myaccount_page_url ));
	} 
	return;
}

// filter hook for include new pages inside the payment method
$get_checkout_url = apply_filters( 'woocommerce_get_checkout_url', WC()->cart->get_checkout_url() );?>

<form name="checkout" id="jiesuan_post" method="post" class="checkout" action="<?php echo esc_url( $get_checkout_url ); ?>">

	<?php do_action( 'woocommerce_checkout_order_review' ); ?>

	<?php if ( sizeof( $checkout->checkout_fields ) > 0 ) : ?>

		<?php do_action( 'woocommerce_checkout_before_customer_details' ); ?>

		<div class="col2-set" id="customer_details">

			<!--div class="col-1">

				<?php //do_action( 'woocommerce_checkout_billing' ); ?>

			</div-->

			<div class="col-2">

				<?php do_action( 'woocommerce_checkout_shipping' ); ?>

			</div>

		</div>

		<?php do_action( 'woocommerce_checkout_after_customer_details' ); ?>

		<!--h3 id="order_review_heading"><?php _e( 'Your order', 'woocommerce' ); ?></h3-->

	<?php endif; ?>

	<?php //do_action( 'woocommerce_checkout_order_review' ); ?>

</form>

<?php do_action( 'woocommerce_after_checkout_form', $checkout ); ?>
