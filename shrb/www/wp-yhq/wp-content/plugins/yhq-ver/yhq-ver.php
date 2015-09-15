<?php
	/*
	Plugin Name: yhq-ver
	Plugin URI: 
	Description: 优惠券网页验证
	Version: 1.0
	Author: U-gen
	Author URI: 
	*/	
	define( 'YHQ_VALIDATE', dirname( __FILE__ ) );

	define('HOME_URL', home_url());
	// print_r(plugin_dir_path(__FILE__));
	// die;
	//导入所用的js
	// require_once plugin_dir_path(__FILE__).'js';
	// //导入所用的模板
	// require_once plugin_dir_path(__FILE__).'/templates';
	//
	require_once plugin_dir_path(__FILE__).'pagetemplater.php';
	add_action( 'plugins_loaded', array( 'PageTemplater1', 'get_instance') );

?>