<?php

/**
 * gCommerce的无注册用户模式 
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

/**
 * 无需注册完成购物流程的用户体验
 *
 * 非完整用户，只在cookie中保持的临时用户.
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 * @author     Wang Xiongxiong <wangxx@gchu.cn>
 */
class GCommerce_Cookie_User {


	/**
	 * Initialize the object.
	 *
	 * @since    1.0.0
	 */
	public function __construct() {
		update_option('woocommerce_enable_guest_checkout', 'yes');	
		update_option('woocommerce_enable_myaccount_registration', 'no');	
		update_option('woocommerce_enable_checkout_login_reminder', 'no');	
	}

	/**
	 * 初始化.
	 *
	 * @since    1.0.0
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	public function init( $loader ) {
		// $loader->add_action( 'after_setup_theme', $this->create_cookie_user(), 10 );
		// print_r($loader)
		$loader->add_action( 'init', $this,'create_cookie_user', 10 );
		//创建用户cookie
		$loader->add_action( 'woocommerce_new_order', $this,'cookie_user_order', 10 ,1);
	}
	function create_cookie_user()
	{
		
		//创建用户cookie
		if(isset($_COOKIE['gcommerce_guid']))
		{
			//存在
			// print_r('aa');
		}
		else
		{
			//不存在
			global $wpdb;
			$wpdb->query("INSERT INTO wp_gcommerce_temp_user (user_name, user_pass, user_email,confirm_code,type) VALUES ('aaa','111111','111111','12345678','cookie user')");
			$usreid=$wpdb->get_var("select last_insert_id()");
			// setCookie('gcommerce_guid',$usreid,time+3600);
			$a=setcookie('gcommerce_guid', $usreid, time()+1209600, COOKIEPATH, COOKIE_DOMAIN, false);
		}
		
	}
	/**
	 * 匿名用户下单
	 *
	 * @since    1.0.0
	 */
	public function cookie_user_order($order_id){
		// todo 流程
		// 检查当前cookie是否含"gcommerce_guid" (guest user id)
		// 如果存在，在该order的meta中增加gcommerce_guid
		// 如不存在，在wp_gcommerce_temp_user 表中增加一匿名用户，类型为cookie user，
		// 在cookie中设置gcommerce_guid，并在该order的meta中增加gcommerce_guid
		// print_r($_COOKIE);
		// die;
		// print_r($_COOKIE['gcommerce_guid']);
		//在订单表的额外字段中增加gcommerce_guid（用户访问页面后给用户的cookieid）
		//给订单的meta增加用户字段
		update_post_meta($order_id, 'gcommerce_guid', $_COOKIE['gcommerce_guid']);
		// $order=new WC_Order();
		// print_r($order);
		

	}

}