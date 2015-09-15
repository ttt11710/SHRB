<?php
/**
 * Lost password form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.0.0
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
global $pb_lostpw_step;
global $pb_lostpw_user;
if( 'input_verify_code' == $pb_lostpw_step ) {
    $cur_form = 'input_verify_code';
} elseif ('lost_password' == $args['form'] ) {
    $cur_form = 'input_phone_num';    
} else {    
    $cur_form = 'input_new_password';    
}
?>

<?php wc_print_notices();?>

<form method="post" class="lost_reset_password <?php echo $cur_form; ?>">

    <?php if( 'input_verify_code' == $pb_lostpw_step ) : ?>
        <p>请输入验证码</p>    
        <p class="form-row form-row-wide"><label for="ver_key">验证码</label> <input class="input-text" type="text" name="ver_key" id="ver_key" /></p>
        <input type="hidden" id="ver_phone" name="ver_phone" value="<?php echo isset( $pb_lostpw_user ) ? $pb_lostpw_user : ''; ?>" />

	<?php elseif( 'lost_password' == $args['form'] ) : ?>

        <p>忘记密码了？请输入注册的手机号，获取验证码</p>

        <p class="form-row form-row-wide"><label for="user_login">手机号</label> <input class="input-text" type="text" name="user_login" id="user_login" /></p>
        <div class="clear"></div>
        <div class="form-row form-row-wide captcha-block">
        <?php do_action( 'lostpassword_form' ); ?>
        </div>  

	<?php else : ?>

        <p><?php echo apply_filters( 'woocommerce_reset_password_message', __( 'Enter a new password below.', 'woocommerce') ); ?></p>

        <p class="form-row form-row-wide">
            <label for="password_1"><?php _e( 'New password', 'woocommerce' ); ?> <span class="required">*</span></label>
            <input type="password" class="input-text" name="password_1" id="password_1" placeholder="请输入密码，至少5位" />
        </p>
        <p class="form-row form-row-wide">
            <label for="password_2"><?php _e( 'Re-enter new password', 'woocommerce' ); ?> <span class="required">*</span></label>
            <input type="password" class="input-text" name="password_2" id="password_2" placeholder="请再次输入密码" />
        </p>

        <input type="hidden" name="reset_key" value="<?php echo isset( $args['key'] ) ? $args['key'] : ''; ?>" />
        <input type="hidden" name="reset_login" value="<?php echo isset( $args['login'] ) ? $args['login'] : ''; ?>" />

    <?php endif; ?>

    <div class="clear"></div>
    <?php if( 'input_verify_code' == $pb_lostpw_step ) : ?>
        <p class="form-row"><input type="submit" class="button" id="reset_pw_btn" name="wc_reset_password" value="重置密码" /></p>    
    <?php else : ?>
        <p class="form-row"><input type="submit" class="button" name="wc_reset_password" value="<?php echo 'lost_password' == $args['form'] ? '获取验证码' : '设置新密码'; ?>" /></p>
    <?php endif; ?>

	<?php wp_nonce_field( $args['form'] ); ?>

</form>