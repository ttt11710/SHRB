<?php
/**
 * Edit account form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     1.6.4
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
?>

<?php wc_print_notices(); ?>

<form action="" method="post">
	<h3>修改密码</h3>

	<p class="form-row form-row-first">
		<input type="hidden" class="input-text" name="account_first_name" id="account_first_name" value="<?php esc_attr_e( $user->display_name ); ?>" />
	</p>
	<p class="form-row form-row-last">
		<input type="hidden" class="input-text" name="account_last_name" id="account_last_name" value="<?php esc_attr_e( $user->display_name ); ?>" />
	</p>
	<p class="form-row form-row-wide">
		<input type="hidden" class="input-text" name="account_email" id="account_email" value="<?php esc_attr_e( $user->user_email ); ?>" />
	</p>
	<p class="form-row form-row-wide">
		<label for="password_1">新密码</label>
		<input type="password" class="input-text" name="password_1" id="password_1" />
	</p>
	<p class="form-row form-row-wide">
		<label for="password_2"><?php _e( 'Confirm new password', 'woocommerce' ); ?></label>
		<input type="password" class="input-text" name="password_2" id="password_2" />
	</p>
	<div class="clear"></div>

	<p><input type="submit" class="button" name="save_account_details" value="修改" /></p>

	<?php wp_nonce_field( 'save_account_details' ); ?>
	<input type="hidden" name="action" value="save_account_details" />
</form>