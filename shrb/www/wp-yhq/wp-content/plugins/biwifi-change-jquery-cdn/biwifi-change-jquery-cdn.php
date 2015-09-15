<?php

/**
 * The Change jQuery CDN Plugin
 *
 * Change enqueuing of jquery ui css used by woocommerce from Google to Microsoft.
 *
 * @package Change_jQuery_CDN
 * @subpackage Main
 */

/**
 * Plugin Name: Change jQuery CDN
 * Plugin URI:  http://paybay.cn/
 * Description: Change enqueuing of jquery ui css used by woocommerce from Google to Microsoft.
 * Author:      wxx
 * Author URI:  http://paybay.cn/
 * Version:     1.0
 * License:     Paybay Private
 */

/* Exit if accessed directly */
if ( ! defined( 'ABSPATH' ) ) exit;

class PB_Change_jQuery_CDN {
	/**
	 * Hook actions and filters.
	 * 
	 * @since 1.0
	 * @access public
	 */
	public function __construct() {
		add_action('woocommerce_admin_css', array( $this, 'pb_woocommerce_admin_css'), 999);

	}

	/**
	 * Register actions that change jquery ui cdn.
	 *
	 *
	 * @since 1.0
	 * @access public
	 *
	 */
	public function pb_woocommerce_admin_css() {
    	global $wp_scripts;
	    $jquery_version = isset( $wp_scripts->registered['jquery-ui-core']->ver ) ? $wp_scripts->registered['jquery-ui-core']->ver : '1.9.2';
	    wp_deregister_style('jquery-ui-style');
	    wp_enqueue_style( 'jquery-ui-style', '//ajax.aspnetcdn.com/ajax/jquery.ui/' . $jquery_version . '/themes/smoothness/jquery-ui.css', array(), WC_VERSION );
	}
}

/* Although it would be preferred to do this on hook,
 * load early to make sure cdn is changed
 */
$pb_change_jquery_cdn = new PB_Change_jQuery_CDN;