<?php
/**
 * View Order
 *
 * Shows the details of a particular order on the account page 
 *
 * @author    WooThemes
 * @package   WooCommerce/Templates
 * @version   2.0.15
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
?>

<?php wc_print_notices(); ?>

<div class="order-info">
	
</div>

<!-- <?php print_r($order->status);?> -->
	


<?php do_action( 'woocommerce_view_order', $order_id );