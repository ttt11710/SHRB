<?php
/**
 * Checkout login form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.0.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

if ( is_user_logged_in() || 'no' === get_option( 'woocommerce_enable_checkout_login_reminder' ) ) return;

$info_message  = apply_filters( 'woocommerce_checkout_login_message', __( 'Returning customer?', 'woocommerce' ) );
$info_message .= ' <a href="#" class="showlogin">' . __( 'Click here to login', 'woocommerce' ) . '</a>';
wc_print_notice( $info_message, 'notice' );
?>

<?php wc_print_notices(); ?>

<?php do_action( 'woocommerce_before_customer_login_form' ); ?>
<?php $redirect = get_permalink();//print_r($redirect); ?>

<?php if ( get_option( 'woocommerce_enable_myaccount_registration' ) === 'yes' ) : ?>

<div class="col2-set" id="customer_login">

	<div class="col-1">

<?php endif; ?>

		<img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jh_logo.png'; ?>" />

		<form method="post" class="login" style="display:block !important;width:90%;margin: 0 auto !important;">
			<p style='margin-top: 13px;margin-bottom:19px;font-size:13px;color:rgba(0,0,0,0.87)'>温馨提示：为了确保您正常使用，请输入正确的手机号</p>
			<?php do_action( 'woocommerce_login_form_start' ); ?>

			<p class="form-row form-row-wide" style='border:0px !important;margin-bottom:19px !important;' >
				<label style="display:none" for="username"><?php _e( 'Username or email address', 'woocommerce' ); ?> <span class="required">*</span></label>
				<input type="number" style="width:100%;font-size:13px;height:40px;" class="input-text" name="username" id="username" placeholder="请输入手机号" />
			</p>
			<p class="form-row form-row-wide" style='display:none;border-bottom:0px !important;'>
				<label style="display:none" for="password"><?php _e( 'Password', 'woocommerce' ); ?> <span class="required">*</span></label>
				<input class="input-text" type="password" name="password" id="password" placeholder="请输入密码" value="111111" />
			</p>
			<p class="form-row form-row-wide" style='border:0px !important;margin-bottom: 19px !important;'>
				
				<input style="width:48%;height:40px;" type="button" class="button" id='get_vcode' name="register" value="获取验证码" />
				<script type="text/javascript">
					jQuery("#get_vcode").click(function(){
						var ajax_url="<?php echo admin_url('admin-ajax.php');?>";
						var phone=jQuery('#username').val();	
						console.log(phone);
						if(phone=='')
						{
							alert('请输入手机号');
							return false;
						}
						else
						{
							var count = 60;
							var countdown = setInterval(CountDown, 1000);
							function CountDown() {
								jQuery("#get_vcode").attr("disabled", true);
								jQuery("#get_vcode").val("重新发送（" + count + " ）");
								if (count == 0) {
									jQuery("#get_vcode").val("获取验证码").removeAttr("disabled");
									clearInterval(countdown);
								}
								count--;
							}
							jQuery.ajax({
                                type:'get',
                                url:ajax_url+"?action=getVcode&phone="+phone,
                                dataType:'json',
                                success:function(data){
                                	console.log(data.status);
                                	if(data.status==200)
                                	{
                                		alert(data.msg);
                                		console.log(data.card);
                                		if(data.card==0)
                                		{
                                			var card=jQuery("#card");
                                			card.show();
                                		}
                                	}
                                	else
                                	{
                                		alert(data.msg);
                                	}
                                }
                        	});
						}
					});
				</script>
				<input  style="vertical-align: top;width:48%;font-size:13px;height:40px;" type="number" class="input-text" name="vcode" id="vcode" placeholder="请输入验证码" value="<?php if ( ! empty( $_POST['vcode'] ) ) echo esc_attr( $_POST['vcode'] ); ?>" />
			</p>
			<p class="form-row" style="border-bottom:0px solid !important;">
				<?php wp_nonce_field( 'woocommerce-login' ); ?>
				<input type="hidden" name="redirect" value="<?php echo esc_url( $redirect ) ?>" />
			</p>
			<p class="form-row form-row-wide" id="card" style="display:none;border:0px !important;">
				<label for="username" style="font-size:13px;color:rgba(0,0,0,0.87)">首次登录需要使用交通银行卡号注册<span class="required">*</span></label>
				<input type="text" style="width:100% !important;background: rgba(0, 0, 0, 0.05) !important;font-size:13px;height:40px;margin: 15px 0;" class="input-text" name="usercard" id="usercard" placeholder="请输交行卡号" />
			</p>
			<?php do_action( 'woocommerce_login_form' ); ?>

			<p class="form-row" style="border:0 !important;">
				<p style="font-size:13px;color:rgba(0,0,0,0.87);line-height: 1.5;margin:0">本业务属于交通银行专网服务，所有信息由交通银行保障安全，请放心使用。</p>
				<?php wp_nonce_field( 'woocommerce-login' ); ?>
				<input style="width:100%;margin-top: 15px;height:40px;" type="submit" class="button login" name="login" value="确认" /> 
				
			</p>
			<!-- <p class="lost_password">
				<a class="zc" href="#">免费注册</a>
				<a href="<?php echo esc_url( wc_lostpassword_url() ); ?>"><?php _e( 'Lost your password?', 'woocommerce' ); ?></a>
			</p> -->
			<?php do_action( 'woocommerce_login_form_end' ); ?>

		</form>
	</div>
<?php do_action( 'woocommerce_after_customer_login_form' ); ?>
