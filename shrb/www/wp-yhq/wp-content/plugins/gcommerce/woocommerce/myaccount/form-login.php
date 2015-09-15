<?php
/**
 * Login Form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly
?>

<?php wc_print_notices(); ?>

<?php do_action( 'woocommerce_before_customer_login_form' ); ?>

<?php if ( get_option( 'woocommerce_enable_myaccount_registration' ) === 'yes' ) : ?>

<div class="col2-set" id="customer_login">

	<div class="col-1">

<?php endif; ?>
		<?php 
			if(isset($_GET['order_id']))
			{
		?>		<script type="text/javascript">
					jQuery(document).ready(function(){
						jQuery("body").css("background","#eeeeee");
						jQuery(".inner-wrap").css("background","#eeeeee");
						jQuery("#masthead").css("background","#ff5722");
						jQuery("#masthead .ft21").css("color","#ffffff");
					});
				</script>
				<form method="post" class="login" style="margin: 0 13px !important;">
					<input type='hidden' value="<?php echo $_GET['order_id']; ?>">
					<p style='margin-top: 13px;margin-bottom:19px;font-size:13px;color:rgba(0,0,0,0.26)'>温馨提示：为了确保您正常使用，请输入正确的手机号</p>
					<?php do_action( 'woocommerce_login_form_start' ); ?>

					<p class="form-row form-row-wide" style='border:0px !important;margin-bottom:19px !important;' >
						<label style="display:none" for="username"><?php _e( 'Username or email address', 'woocommerce' ); ?> <span class="required">*</span></label>
						<input type="number" style="width:100%;font-size:14px;height:40px;background:rgba(255,255,255,0.54);" class="input-text" name="username" id="username" placeholder="请输入手机号" />
					</p>
					<p class="form-row form-row-wide" style='display:none'>
						<label style="display:none" for="password"><?php _e( 'Password', 'woocommerce' ); ?> <span class="required">*</span></label>
						<input class="input-text" type="password" name="password" id="password" placeholder="请输入密码" value="111111" />
					</p>
					<p class="form-row form-row-wide" style='border:0px !important;margin-bottom: 19px !important;'>
						<input style="width:48%;height:40px;background:#ffc107 !important;color:rgba(0,0,0,0.54);font-size:14px;" type="button" class="button" id='get_vcode' name="register" value="获取验证码" />
						<script type="text/javascript">
						// alert('aaa');
							jQuery("#get_vcode").click(function(){
								var date = Date.parse(new Date());
								console.log(date);
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
		                                	console.log(data);
		                                	if(data.status==200)
		                                	{                                		
		                                		alert(data.msg);
		                                		console.log(data.time);
		                                		// console.log(data.card);
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
						<input  style="vertical-align: top;width:48%;font-size:13px;height:40px;background:rgba(255,255,255,0.87);" type="number" class="input-text" name="vcode" id="vcode" placeholder="请输入验证码" value="<?php if ( ! empty( $_POST['vcode'] ) ) echo esc_attr( $_POST['vcode'] ); ?>" />
					</p>

					<p class="form-row form-row-wide" id="card" style="display:none;border:0px !important;">
						<label for="username" style="font-size:14px;color:rgba(0,0,0,0.54)">首次登录需要使用交通银行卡号注册<span class="required">*</span></label>
						<input type="text" style="width:100% !important;background:rgba(255,255,255,0.87); !important;font-size:13px;height:40px;margin: 15px 0;" class="input-text" name="usercard" id="usercard" placeholder="请输交行卡号" />
					</p>
					<?php do_action( 'woocommerce_login_form' ); ?>

					<p class="form-row" style="border:0 !important;">
						<p style="font-size:13px;color:rgba(0,0,0,0.26);line-height: 1.5;margin:0;text-decoration:underline">本业务属于交通银行专网服务，所有信息由交通银行保障安全，请放心使用。</p>
						<?php wp_nonce_field( 'woocommerce-login' ); ?>
						<input style="width:100%;margin-top: 15px;height:40px;background:#ffc107;" type="submit" class="button login" name="login" value="确认" /> 
						
					</p>
					<!-- <p class="lost_password">
						<a class="zc" href="#">免费注册</a>
						<a href="<?php echo esc_url( wc_lostpassword_url() ); ?>"><?php _e( 'Lost your password?', 'woocommerce' ); ?></a>
					</p> -->

					<?php do_action( 'woocommerce_login_form_end' ); ?>

				</form>
		<?php
			}
			else{
		?>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jh_logo.png'; ?>" />
				<form method="post" class="login" style="margin: 0 13px !important;">
					<p style='margin-top: 13px;margin-bottom:19px;font-size:13px;color:rgba(0,0,0,0.87)'>温馨提示：为了确保您正常使用，请输入正确的手机号</p>
					<?php do_action( 'woocommerce_login_form_start' ); ?>

					<p class="form-row form-row-wide" style='border:0px !important;margin-bottom:19px !important;' >
						<label style="display:none" for="username"><?php _e( 'Username or email address', 'woocommerce' ); ?> <span class="required">*</span></label>
						<input type="number" style="width:100%;font-size:13px;height:40px;" class="input-text" name="username" id="username" placeholder="请输入手机号" />
					</p>
					<p class="form-row form-row-wide" style='display:none'>
						<label style="display:none" for="password"><?php _e( 'Password', 'woocommerce' ); ?> <span class="required">*</span></label>
						<input class="input-text" type="password" name="password" id="password" placeholder="请输入密码" value="111111" />
					</p>
					<p class="form-row form-row-wide" style='border:0px !important;margin-bottom: 19px !important;'>
						<input style="width:48%;height:40px;" type="button" class="button" id='get_vcode' name="register" value="获取验证码" />
						<script type="text/javascript">
						// alert('aaa');
							jQuery("#get_vcode").click(function(){
								var date = Date.parse(new Date());
								console.log(date);
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
		                                	console.log(data);
		                                	if(data.status==200)
		                                	{                                		
		                                		alert(data.msg);
		                                		console.log(data.time);
		                                		// console.log(data.card);
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
		<?php
			}
		?>



<?php do_action( 'woocommerce_after_customer_login_form' ); ?>
