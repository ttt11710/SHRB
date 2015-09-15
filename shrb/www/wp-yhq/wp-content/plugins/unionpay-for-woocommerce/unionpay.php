<?php
/*
 * Plugin Name: Unionpay For WooCommerce
 * Plugin URI: http://www.codingpet.com
 * Description: 为woocommrece 提供银联的支付支持网关
 * Version: 1.0.0
 * Author: li wang
 * Author URI: http://www.codingpet.com
 * Requires at least: 3.3
 * Tested up to: 3.5.1
 *
 * Text Domain: alipay
 * Domain Path: /lang/
 */
if( preg_match('#' . basename(__FILE__) . '#', $_SERVER['PHP_SELF']) ) { die('You are not allowed to call this page directly.'); }

add_action( 'plugins_loaded', 'unionpay_gateway_init' );
function unionpay_gateway_init() {
    if( !class_exists('WC_Payment_Gateway') ) 
        return;
    load_plugin_textdomain( 'alipay', false, dirname( plugin_basename( __FILE__ ) ) . '/lang/'  );
    require_once( plugin_basename( 'class-wc-unionpay.php' ) );
    add_filter('woocommerce_payment_gateways', 'woocommerce_unionpay_add_gateway' );
}
 /**
 * Add the gateway to WooCommerce
 *
 * @access public
 * @param array $methods
 * @package		WooCommerce/Classes/Payment
 * @return array
 */
function woocommerce_unionpay_add_gateway( $methods ) {
    $methods[] = 'WC_Unionpay';
    return $methods;
}
?>