<?php

/**
 * Fired during plugin activation
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes
 */

/**
 * Fired during plugin activation.
 *
 * This class defines all code necessary to run during the plugin's activation.
 *
 * @since      1.0.0
 * @package    GCommerce
 * @subpackage GCommerce/includes
 * @author     Wang Xiongxiong <wangxx@gchu.cn>
 */
class GCommerce_Activator {

	/**
	 * Short Description. (use period)
	 *
	 * Long Description.
	 *
	 * @since    1.0.0
	 */
	public static function activate() {
		GCommerce_Activator::set_woocommerce_options();
	}

	/**
	 * 设置WooCommerce参数，使其基本用户体验符合移动应用
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function set_woocommerce_options() {
		// 设置必需的woocommerce参数
		// todo : 在配置中可设置？
		update_option('woocommerce_enable_shipping_calc', 'no');
		update_option('woocommerce_enable_guest_checkout', 'no');	
		update_option('woocommerce_enable_coupons', 'no');			// todo: 将来可考虑允许优惠券
		update_option('woocommerce_ship_to_billing', 'no');
		update_option('woocommerce_enable_signup_and_login_from_checkout', 'no');
		update_option('woocommerce_enable_myaccount_registration', 'yes');	
		update_option('woocommerce_enable_checkout_login_reminder', 'yes');	
		update_option('woocommerce_registration_generate_username', 'no');
		update_option('woocommerce_registration_generate_password', 'no');
	}

}
