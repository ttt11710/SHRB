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

		<div>
			
			<img id='loimg' style='width:160px;height:40px;margin-top:20px;' src='<?php echo get_template_directory_uri().'/img/lhcslogo.png' ?>' />			

		</div>

		<form method="post" class="login" id='logform'>
		
			<?php do_action( 'woocommerce_login_form_start' ); ?>
			<input type="hidden" name="redirect" value="<?php   echo $_GET['redirect']; ?>" />
			<p class="form-row form-row-wide">
				<label style='display:none;' for="username"><?php _e( 'Username or email address', 'woocommerce' ); ?> <span style='display:none;' class="required">*</span></label>
				<input type="tel" style="border-radius:5px;"  class="input-text xx" name="username" id="username" placeholder="请输入手机号" />
			</p>
			<p class="form-row form-row-wide">
				<label style='display:none;' for="password"><?php _e( 'Password', 'woocommerce' ); ?> <span style='display:none;' class="required">*</span></label>
				<input class="input-text xx" style="border-radius:5px;"  type="password" name="password" id="password" placeholder="请输入密码" />
			</p>

			<?php do_action( 'woocommerce_login_form' ); ?>

			<p class="form-row">
				<?php wp_nonce_field( 'woocommerce-login' ); ?>
				<input type="checkbox" id="isshowpwd" /><span>显示密码</span>
				<input type="submit" id='btnlog' class="button btn" name="login" value="<?php _e( 'Login', 'woocommerce' ); ?>" /> 
				<label style="display:none;" for="rememberme" class="inline">
					<input name="rememberme" type="checkbox" id="rememberme" value="forever" /> <?php _e( 'Remember me', 'woocommerce' ); ?>
				</label>
			</p>
		<!--
			<p class="lost_password">
				<a href="<?php echo esc_url( wc_lostpassword_url() ); ?>"><?php _e( 'Lost your password?', 'woocommerce' ); ?></a>
			</p>
		-->
			<p id='lostpwd' class='lstpwd'> 没有账号或忘记密码？</p>
			<hr class='hr' />
			<br/>
			<div id='reshow'>
				<input type='button' value='马上注册' id='btnreg'/>
				<!-- <input type='button' value='找回密码' id='btnrepwd'/>  -->

			</div>
			<?php do_action( 'woocommerce_login_form_end' ); ?>

		</form>

<?php if ( get_option( 'woocommerce_enable_myaccount_registration' ) === 'yes' ) : ?>

	</div>

	<div class="col-2" style='display:none;' id='regform' >
		<form method="post" class="register">

		<input type="hidden" name="redirect" value="<?php   echo $_GET['redirect']; ?>" />

			<?php do_action( 'woocommerce_register_form_start' ); ?>

			<?php if ( 'no' === get_option( 'woocommerce_registration_generate_username' ) ) : ?>

				<p class="form-row form-row-wide">
					<label for="reg_username" style='display:none;' ><?php _e( 'Username', 'woocommerce' ); ?> <span style='display:none;' class="required">*</span></label>
					<input type="tel" class="input-text xx" name="username" id="reg_username" value="<?php if ( ! empty( $_POST['username'] ) ) echo esc_attr( $_POST['username'] ); ?>" placeholder="请输入手机号" />
				</p>

			<?php endif; ?>

			<p class="form-row form-row-wide">
				<label for="reg_email" style='display:none;'><?php _e( 'Email address', 'woocommerce' ); ?> <span style='display:none;' class="required">*</span></label>
				<input type="email" class="input-text xx"  style='display:none;'  name="email" id="reg_email" value="<?php if ( ! empty( $_POST['email'] ) ) echo esc_attr( $_POST['email'] ); ?>" placeholder="请输入手机号" />
			</p>

			<?php if ( 'no' === get_option( 'woocommerce_registration_generate_password' ) ) : ?>
	
				<p class="form-row form-row-wide">
					<label for="reg_password" style='display:none;'><?php _e( 'Password', 'woocommerce' ); ?> <span style='display:none;'  class="required">*</span></label>
					<input type="text" class="input-text xx" name="password" id="reg_password" value="<?php if ( ! empty( $_POST['password'] ) ) echo esc_attr( $_POST['password'] ); ?>" placeholder="请输入密码" />
				</p>
				
				 <p class="form-row form-row-wide">
                                        <label for="reg_password" style='display:none;'><?php _e( 'Password', 'woocommerce' ); ?> <span style='display:none;'  class="required">*</span></label>
                                        <input type="text" class="input-text xx" name="password2" id="reg_password2" value="<?php if ( ! empty( $_POST['password'] ) ) echo esc_attr( $_POST['password'] ); ?>" placeholder="请再次输入密码" />
                                </p>




			<?php endif; ?>

			<!-- Spam Trap -->
			<div style="left:-999em; position:absolute;"><label for="trap"><?php _e( 'Anti-spam', 'woocommerce' ); ?></label><input type="text" name="email_2" id="trap" tabindex="-1" /></div>

			<?php do_action( 'woocommerce_register_form' ); ?>
			<?php do_action( 'register_form' ); ?>

			<p class="form-row">
				<?php wp_nonce_field( 'woocommerce-register', 'register' ); ?>
				<input type="submit" id="reg" class="button btn" name="register" value="<?php _e( 'Register', 'woocommerce' ); ?>" />
			</p>
			<p class='lstpwd'>已有账号？返回登录</p>
			<br/>
			<hr class='hr' />
			<br/>
			<div>
				<input type='button' value='返回登录' id='backtolog' class='baklog' />			
			</div>
			<?php do_action( 'woocommerce_register_form_end' ); ?>
		</form>

	</div>

</div>
<?php endif; ?>

<?php// do_action( 'woocommerce_after_customer_login_form' ); ?>

