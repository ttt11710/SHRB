<?php

// disable direct access to the file	
defined('GAVERN_WP') or die('Access denied');

global $gk_tpl;



?>

<?php if(get_option($gk_tpl->name . '_login_popup_state', 'Y') == 'Y') : ?>
<div id="gk-popup-login" class="gk-popup">	
	<div class="gk-popup-wrap">
		<i class="gk-icon-cross"></i>
		
		<?php if ( is_user_logged_in() ) : ?>
			<h3><?php _e('Your Account', GKTPLNAME); ?></h3>
			
			<?php 
				
				global $current_user;
				get_currentuserinfo();
			
			?>
			
			<p>
				<?php echo __('Hi, ', GKTPLNAME) . ($current_user->user_firstname) . ' ' . ($current_user->user_lastname) . ' (' . ($current_user->user_login) . ') '; ?>
			</p>
			<p>
				 <a href="<?php echo wp_logout_url(); ?>" class="btn button-primary" title="<?php _e('Logout', GKTPLNAME); ?>">
					 <?php _e('Logout', GKTPLNAME); ?>
				 </a>
			</p>
		
		<?php else : ?>
		    <h3><?php _e('Log In', GKTPLNAME); ?></h3>
		    
			<?php 
				wp_login_form(
					array(
						'echo' => true,
						'form_id' => 'loginform',
						'label_username' => __( 'Username', GKTPLNAME ),
						'label_password' => __( 'Password', GKTPLNAME ),
						'label_remember' => __( 'Remember Me', GKTPLNAME ),
						'label_log_in' => __( 'Log In', GKTPLNAME ),
						'id_username' => 'user_login',
						'id_password' => 'user_pass',
						'id_remember' => 'rememberme',
						'id_submit' => 'wp-submit',
						'remember' => true,
						'value_username' => NULL,
						'value_remember' => false 
					)
				); 
			?>		
			
		<nav class="small">
			<ul>
				<li>
					<a href="<?php echo home_url(); ?>/wp-login.php?action=lostpassword" title="<?php _e('Password Lost and Found', GKTPLNAME); ?>"><?php _e('Lost your password?', GKTPLNAME); ?></a>
				</li>
			</ul>
		</nav>
		
		<a href="<?php echo home_url(); ?>/wp-login.php?action=register" class="btn register" title="<?php _e('Create an account', GKTPLNAME); ?>"><?php _e('Create an account', GKTPLNAME); ?></a>
			
		<?php endif; ?>
	</div>
</div>
<?php endif; ?>

<?php if(get_option($gk_tpl->name . '_login_popup_state', 'Y') == 'Y' || $cartActive) : ?>
<div id="gk-popup-overlay"></div>
<?php endif; ?>