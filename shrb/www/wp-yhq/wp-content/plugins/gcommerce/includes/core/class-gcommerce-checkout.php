<?php

/**
 * 定制gCommerce的结算页面 
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

/**
 * 定制gCommerce的结算页面
 *
 * 减少不需要的输入项，定制WooCommerce模版，使其符合移动电商的缺省用户体验.
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 * @author     Wang Xiongxiong <wangxx@gchu.cn>
 */
class GCommerce_Checkout {


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
		$loader->add_action( 'woocommerce_checkout_fields', $this, 'custom_override_checkout_fields' );
		$loader->add_action( 'woocommerce_checkout_process', $this, 'custom_checkout_field_process' );
		$loader->add_filter( 'woocommerce_admin_shipping_fields', $this, 'show_shipping_custom_field_admin' );
		// $loader->add_action( 'woocommerce_checkout_update_order_meta', $this, 'custom_checkout_field_update_order_meta' );
		// $loader->add_filter( 'woocommerce_process_checkout_field_user_card' , $this, 'verify_card');
	}

	/**
	 * 定制结算页用户输入项
	 *
	 * @since    1.0.0
	 */
	public function custom_override_checkout_fields( $fields ) {
		foreach ( WC()->cart->get_cart() as $cart_item_key => $cart_item ) {
			$product_id=$cart_item['product_id'];
		}
		$tag_count = get_the_terms( $product_id, 'product_tag' ) ;
		$flag=0;
		foreach ($tag_count as $key => $value) {
			if($value->name=='creadit'){
				$flag=1;
			}
		}
		if($flag!=1){
			$fields2['shipping']['shipping_first_name'] = $fields['shipping']['shipping_first_name'];
			$fields2['shipping']['shipping_first_name']['label'] = '姓名';
			$fields2['shipping']['shipping_first_name']['placeholder'] = '* 收货人姓名';
			$fields2['shipping']['shipping_address_1'] = $fields['shipping']['shipping_address_1'];
			$fields2['shipping']['shipping_address_1']['placeholder'] = '* 收货人地址';
			$fields2['shipping']['shipping_phone'] = array(
				'type'          => 'text',
				'label'     => __('Phone', 'woocommerce'),
				'placeholder'   => '* 联系电话',
				'required'  => true,
				'class'     => array('form-row-wide'),
				'clear'     => true
			);
		}
		else{
			$fields2['shipping']['user_card'] = array(
				'label'     => '※请输入交通银行信用卡卡号',
				'class'     => array('form-row-wide'),
				'clear'     => true,
				'placeholder'=>'信用卡',
			);
		}

		return $fields2;
	}

	/**
	 * 缺省只使用送货地址
	 *
	 * @since    1.0.0
	 */
	public function custom_checkout_field_process() {
	    global $woocommerce;
	    // 不使用账单地址，只使用送货地址
	    $_POST['ship_to_different_address'] = '1';
	    // Check if set, if its not set add an error.
	    // if (!$_POST['invoice_checkbox'])
	    //      $woocommerce->add_error( __('Please agree to my checkbox.') );
	}

	/**
	 * 后台现实送货联系手机号
	 *
	 * @since    1.0.0
	 */
	function show_shipping_custom_field_admin($shipping_fields) {
	    $shipping_fields['phone'] = array(
	        'label'     => __('Phone', 'woocommerce'),
	        'show'   => true
	     );
	    return $shipping_fields;

	}
	public function custom_checkout_field_update_order_meta( $order_id ) {
		$usercard=$_POST['usercard'];
		$verify_card=$this->verify_card($usercard);
		print_r($verify_card);
		if($verify_card){
			global $wpdb;
		}
		else{
			header("Content-type: text/html; charset=utf-8"); 
			echo "<script>alert('输入的卡号错误或者不是交通银行的信用卡');history.back();</script>";
			exit;
		}
		update_post_meta( $order_id, 'shipping_table',$_POST['shipping_table']);
	}
	//验证卡号
	function verify_card()
	{
		global $wpdb;
		global $current_user;
		$card=$_POST['user_card'];
		$verify_card=substr($card, 0,6);
		$card_array=array('520169','521899','458124','458123','622253','622252','628218','628216','522964','622656','434910',
			'405512','601428','622258','622259','622260','622261','622262','621002','621069','620013');
		if(in_array($verify_card, $card_array)){
			$public_key= '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7wyvZfgBXs6bBVUTvqyaPglVN
VQDKbiw1/iSbMVlERfFm2jUVy1jG++DChTlMBfOn3Tt7zNtX4t5rk0J2ElchjJnE
7cTwN5+f3JsBArM8YnSYIi4GxazuvzhGgDQIiXHLsQlbsw6WUoOMB8K9phES6Eus
31Bqr5adtMXcJFW43wIDAQAB
-----END PUBLIC KEY-----';
			$encrypted = ""; 
			openssl_public_encrypt($card,$encrypted,$public_key);//公钥加密  
			$encrypted = base64_encode($encrypted);
			$user_phone=$current_user->user_login;
			$verify_phone=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_gcommerce_user_card where user_phone={$phone}"));
			if(!($verify_phone>0))
			{
				$wpdb->query("INSERT INTO wp_gcommerce_user_card (user_phone, user_card) VALUES ('{$user_phone}','{$encrypted}')");
			}
		}
		else{
			wc_add_notice( '<strong>卡号输入错误，请输入交通银行信用卡卡号</strong>' , 'error' );
		}
	}
		


}