<?php
/**
 * My Account page
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.0.0
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

wc_print_notices(); ?>
<div style="width:100%;background:#eeeeee">
	<p class="user">
		<?php 
			echo "<img style='display:inline;' src='".CURRENT_TEMPLATE_DIR."/images/smile.png'/>当前用户：<strong>" . $current_user->display_name ."</strong> ";
		?>
	</p>
	<div class="row" style="text-align:center;">
		<!-- <div class="myaccount-menu button"><a href="<?php echo wc_customer_edit_account_url();?>" >修改密码</a></div> -->
		<div class="myaccount-menu">
			<a style="margin-right:15px;text-decoration:none !important;border: 1px solid #aaaaaa;border-radius: 3px;padding: 0 10px;color:#000000" href="<?php echo wc_get_endpoint_url('edit-address/shipping');?>" style="color: #000000;">修改账号信息</a>
			<a style="margin-right:15px;text-decoration:none !important;border: 1px solid #aaaaaa;border-radius: 3px;padding: 0 10px;color:#000000" href="<?php echo wp_logout_url( get_permalink( wc_get_page_id( 'myaccount' ) ) );?>" style="color: #000000;">退出</a>
		</div>
		<!-- <div class="myaccount-menu"></div> -->
	</div>
</div>
<hr style="margin-bottom: 15px;margin-top: 15px;" />
<?php do_action( 'woocommerce_before_my_account' ); ?>

<?php wc_get_template( 'myaccount/my-downloads.php' ); ?>

<?php wc_get_template( 'myaccount/my-orders.php', array( 'order_count' => $order_count ) ); ?>


<?php do_action( 'woocommerce_after_my_account' ); ?>
