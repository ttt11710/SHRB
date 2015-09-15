<?php

/**
 * gCommerce的结算页面中增加发票信息的输入 
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

/**
 * gCommerce的结算页面中增加发票信息的输入 
 *
 * 用户可选择是否需要发票，可输入发票抬头.
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 * @author     Wang Xiongxiong <wangxx@gchu.cn>
 */
class GCommerce_Invoice {


	/**
	 * Initialize the object.
	 *
	 * @since    1.0.0
	 */
	public function __construct() {

	}

	/**
	 * gCommerce初始化.
	 *
	 * @since    1.0.0
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	public function init( $loader ) {
		// $loader->add_filter( 'woocommerce_checkout_fields', $this, 'custom_override_checkout_fields');
		$loader->add_action( 'woocommerce_checkout_process', $this, 'custom_checkout_field_process' );
		$loader->add_filter( 'woocommerce_admin_shipping_fields', $this, 'show_shipping_custom_field_admin' );

		$loader->add_action( 'woocommerce_before_checkout_billing_form' , $this, 'custom_checkout_invoice_field' );
		// $loader->add_filter( 'woocommerce_checkout_fields' , $this, 'custom_override_checkout_fields_invoice');
		$loader->add_action( 'woocommerce_checkout_update_order_meta', $this, 'custom_checkout_field_update_order_meta' );
		$loader->add_filter( 'woocommerce_admin_billing_fields', $this, 'show_billing_custom_field_admin' );

	}

	/**
	 * “是否需要发票”的用户输入项
	 *
	 * @since    1.0.0
	 */
	public function custom_checkout_invoice_field( $checkout ) {
	    woocommerce_form_field( 'billing_invoice_checkbox', array(
	        'type'          => 'checkbox',
	        'class'         => array('input-checkbox'),
	        'label'         => '需要发票',
	        'required'      => false,
	    ), $checkout->get_value( 'billing_invoice_checkbox' ));    
	}

	/**
	 * “发票抬头”的用户输入项
	 *
	 * @since    1.0.0
	 */
	public function custom_override_checkout_fields_invoice( $fields ) {
	    $fields['billing']['billing_invoice_name'] = array(
	        'label'     => '发票抬头',
	        'placeholder'   => '发票抬头',
	        'required'  => false,
	        'class'     => array('form-row-wide'),
	        'clear'     => true
	     );
	    return $fields;
	}

	/**
	 * 保存用户输入的发票信息
	 *
	 * @since    1.0.0
	 */
	public function custom_checkout_field_update_order_meta( $order_id ) {
	    if ($_POST['billing_invoice_checkbox']) {
	        // update_post_meta( $order_id, '_shipping_need_invoice', esc_attr($_POST['shipping_invoice_checkbox']));        
	        update_post_meta( $order_id, '_billing_need_invoice', esc_attr("是"));
	    } else {
	        update_post_meta( $order_id, '_billing_need_invoice', esc_attr("否"));
	        update_post_meta( $order_id, '_billing_invoice_name', esc_attr(""));
	    }
	}

	/**
	 * 后台订单管理页面显示用户输入的发票信息
	 *
	 * @since    1.0.0
	 */
	public function show_billing_custom_field_admin($billing_fields) {
	    $billing_fields['need_invoice'] = array(
	        'label'     => "是否需要发票",
	        'show'   => true
	     );
	    $billing_fields['invoice_name'] = array(
	        'label'     => "发票抬头",
	        'show'   => true
	     );
	    return $billing_fields;

	}


}