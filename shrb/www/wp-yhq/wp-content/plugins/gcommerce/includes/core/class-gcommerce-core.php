<?php

/**
 * gCommerce的核心功能类 
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

/**
 * 实现gCommerce核心功能
 *
 * 设置WooCommerce的参数，使其符合移动电商的缺省用户体验.
 * 修改模版加载顺序，可在本插件中定制WooCommerce的页面模版.
 * 设置符合习惯的中国省市列表
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 * @author     Wang Xiongxiong <wangxx@gchu.cn>
 */
class GCommerce_Core {


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
		$this->reorder_state_list($loader);
		$this->customize_template_loader($loader);
		$this->load_core_modules($loader);
	}


	/**
	 * 设置中国的省市列表，WooCommerce自带的列表不符合中国习惯
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function reorder_state_list( $loader ) {
		$loader->add_filter( 'woocommerce_states', $this, 'custom_woocommerce_states' );
	}

	/**
	 * 设置中国的省市列表的回调
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	public function custom_woocommerce_states( $states ) {
	    $states['CN'] = array( 
		    'CN1'  => '北京',
		    'CN2' => '上海',
		    'CN3'  => '天津',
		    'CN4' => '重庆',
		    'CN5'  => '河北',
		    'CN6'  => '山西',
		    'CN7' => '河南',
		    'CN8'  => '辽宁',
		    'CN9'  => '吉林',
		    'CN10'  => '黑龙江',
		    'CN11'  => '内蒙古',
		    'CN12' => '江苏',
		    'CN13' => '山东',
		    'CN14' => '安徽',
		    'CN15' => '浙江',
		    'CN16' => '福建',
		    'CN17' => '湖北',
		    'CN18' => '湖南',
		    'CN19' => '广东',
		    'CN20' => '广西',
		    'CN21' => '江西',
		    'CN22' => '四川',
		    'CN23' => '海南',
		    'CN24' => '贵州',
		    'CN25'  => '云南',
		    'CN26' => '西藏',
		    'CN27' => '陕西',
		    'CN28' => '甘肃',
		    'CN29' => '青海',
		    'CN30' => '宁夏',
		    'CN31' => '新疆'
	    );
	    return $states; 
	}

	/**
	 * 修改WooCommerce的模版加载顺序，优先度 高－>低 为：主题，本插件，WooCommerce
	 *
	 * @since    1.0.0
	 * @access   private
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	private function customize_template_loader( $loader ) {
		//设置必需的woocommerce参数
		$loader->add_filter( 'woocommerce_locate_template', $this, 'gcommerce_locate_woocommerce_template', 10, 3 );
	}

	/**
	 * 修改WooCommerce加载模版的顺序
	 *
	 * @since    1.0.0
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	public function gcommerce_locate_woocommerce_template( $template, $template_name, $template_path ) {
		global $woocommerce;
		$_template = $template;

		if ( ! $template_path ) $template_path = $woocommerce->template_url;
		$plugin_path  = untrailingslashit( GCOMMERCE_PLUGIN_PATH ) . '/woocommerce/';
		// Look within passed path within the theme - this is priority
		$template = locate_template(
			array(
				$template_path . $template_name,
				$template_name
			) 
	 	);
	 
		// Modification: Get the template from this plugin, if it exists
		if ( ! $template && file_exists( $plugin_path . $template_name ) )
			$template = $plugin_path . $template_name;
		// Use default template
		if ( ! $template )
			$template = $_template;
		// Return what we found
		return $template;
	}

	/**
	 * 加载其他核心模块
	 *
	 * @since    1.0.0
	 * @access   private
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	private function load_core_modules( $loader ) {
		// todo 从options中获得参数设置
		$gcommerce_enable_invoice = apply_filters( 'gcommerce_enable_invoice', true );
		$gcommerce_user_must_login = apply_filters( 'gcommerce_user_must_login', true );
		// print_r($gcommerce_user_must_login);
		// 用户注册，登录流程，界面的定制
		if ($gcommerce_user_must_login) {
			// 标准用户体验，结算前必需注册,登录用户
			require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-user.php';
			$gc_user = new GCommerce_User();		
			$gc_user->init($loader);			
		} else {
			// 无用户注册结算
			require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-cookie-user.php';
			$gc_user = new GCommerce_Cookie_User();	
			$gc_user->init($loader);		
		}

		// 结算画面的定制
		require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-checkout.php';
		$gc_checkout = new GCommerce_Checkout();		
		$gc_checkout->init($loader);

		// 结算画面中用户发票信息的输入
		// if ($gcommerce_enable_invoice) {
		// 	require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-invoice.php';
		// 	$gc_invoice = new GCommerce_Invoice();		
		// 	$gc_invoice->init($loader);			
		// }
		require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-order-status.php';
		$order_status = new GCommerce_Order();		
		$order_status->init($loader);

		require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-flashsale.php';
		$order_status = new GCommerce_Flashsale();		
		$order_status->init($loader);

		require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-report.php';
		$order_status = new GCommerce_Report();		
		$order_status->init($loader);

		require_once GCOMMERCE_PLUGIN_PATH . '/includes/core/class-gcommerce-report-use.php';
		$order_status = new GCommerce_Report_Use();		
		$order_status->init($loader);
	}


}
