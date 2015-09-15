<?php
	/*
	Plugin Name: U-gen Planning
	Plugin URI: 
	Description: U-gen Planning
	Version: 1.0
	Author: U-gen
	Author URI: 
	*/
	
	
	
	const MENU_PB_PLAN = 'pb_plan/php/list.php';
	const MENU_PB_PLAN_ADD = 'pb_plan/php/add.php';
	
	
	/*
	function my_task_function() {
		pb_logResult("kimi minute");
	}
		
	function my_task_hourly_function() {
		pb_logResult("kimi hour");
	}
	
	function cron_add_minute( $schedules )
	{
		// Adds once weekly to the existing schedules.
		$schedules['minute'] = array(
			'interval' => 60, // 1周 = 60秒 * 60分钟 * 24小时 * 7天
			'display' => __('Once minute')
		);
		return $schedules;
	}
	
	function kimi_test(){
	//	add_filter('cron_schedules', 'cron_add_minute'); 
		if (!wp_next_scheduled('my_task_hook')) {
			wp_schedule_event( time(), 'hourly', 'my_task_hook' );
		}
		add_action( 'my_task_hook', 'my_task_hourly_function' );
	//	wp_clear_scheduled_hook('my_task_hook');
	//	wp_clear_scheduled_hook('my_task_min_hook');
		
	}
	*/

	//初始化插件
	function pb_plan_init(){
		require_once(plugin_dir_path(__FILE__) . 'config.php');
		require_once(plugin_dir_path(__FILE__) . 'class/file.php');
		require_once(plugin_dir_path(__FILE__) . 'class/XingeApp.php');
		add_action('admin_menu','pb_plan_addMenu');
		pb_plan_createTable();
		
	//	if($_GET['page'] == MENU_PB_PLAN ||$_GET['page'] == MENU_PB_PLAN_ADD){
			require_once(plugin_dir_path(__FILE__) . 'php/post.php');
			$pb_plan_post = new Pb_plan_post();
			add_action('wp_ajax_pb_plan_add_plan', array($pb_plan_post,'pb_plan_ajax_add_plan'));
			add_action('wp_ajax_pb_plan_update_plan', array($pb_plan_post,'pb_plan_ajax_update_plan'));
			add_action('wp_ajax_pb_plan_del_plan', array($pb_plan_post,'pb_plan_ajax_del_plan'));
			add_action('wp_ajax_pb_plan_add_item', array($pb_plan_post,'pb_plan_ajax_add_item'));
			add_action('wp_ajax_pb_plan_update_item', array($pb_plan_post,'pb_plan_ajax_update_item'));
			add_action('wp_ajax_pb_plan_del_item', array($pb_plan_post,'pb_plan_ajax_del_item'));
			add_action('wp_ajax_pb_plan_create_file', array($pb_plan_post,'pb_plan_ajax_create_file'));
			add_action('wp_ajax_pb_plan_push_box', array($pb_plan_post,'pb_plan_ajax_push_box'));
			add_action('wp_ajax_pb_plan_update_box', array($pb_plan_post,'pb_plan_ajax_update_box'));
			add_action('wp_ajax_pb_plan_get_list', array($pb_plan_post,'pb_plan_ajax_get_list'));
			
			add_action('wp_ajax_nopriv_pb_plan_download_log', array($pb_plan_post,'pb_plan_ajax_download_log'));
	//	}
		
		//add_action('wp_ajax_nopriv_pb_plan_get_num', array($pb_plan_post,'pb_plan_ajax_get_num'));
		
	}
	
	//添加菜单
	function pb_plan_addMenu(){
		add_menu_page('活动计划', '活动计划', 'edit_posts', MENU_PB_PLAN, '');
		add_submenu_page(MENU_PB_PLAN, '新增计划', '新增', 'edit_posts', MENU_PB_PLAN_ADD,'');
		
		
		
//		add_menu_page('ubox管理', 'ubox管理', 'manage_options', 'edit.php?post_type=pb_box', '','',26);
//		add_submenu_page('edit.php?post_type=pb_box', '盒子', '盒子', 'manage_options', 'edit.php?post_type=pb_box','','',26);
//		add_menu_page('活动', '活动', 'manage_options', MENU_PB_PLAN, '','',26);
//		add_submenu_page(MENU_PB_PLAN, '新增计划', '新增', 'manage_options', MENU_PB_PLAN_ADD,'','',26);
		
	}
	
	//新建表
	function pb_plan_createTable(){
		global $wpdb;
		$charset_collate = 'ENGINE=InnoDB';
		if(version_compare(mysql_get_server_info(), '4.1.0', '>=')) {
			if(!empty($wpdb->charset))
			{ $charset_collate .= " DEFAULT CHARACTER SET $wpdb->charset"; }
			if(!empty($wpdb->collate))
			{ $charset_collate .= " COLLATE $wpdb->collate"; }
		}
		$table_list_name='pb_plan_list';
		$table_info_name='pb_plan_info';
		$table_log_name='pb_plan_log';
	//	$wpdb->query("DROP TABLE IF EXISTS {$table_list_name}");
	//	$wpdb->query("DROP TABLE IF EXISTS {$table_info_name}");
		if($wpdb->get_var("SHOW TABLES LIKE '{$table_list_name}'") != $table_list_name){
			$wpdb->query("
					CREATE TABLE {$table_list_name}
					(
						plan_id int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
						plan_title VARCHAR(100),
						box_id int(11) UNSIGNED NOT NULL,
						plan_date date NOT NULL DEFAULT '0000-00-00',
						plan_item_num MEDIUMINT(8) NOT NULL DEFAULT 0,
						plan_create_time datetime DEFAULT '0000-00-00 00:00:00',
						plan_update_time datetime DEFAULT '0000-00-00 00:00:00',
						plan_package_time datetime DEFAULT '0000-00-00 00:00:00',
						plan_push_time datetime DEFAULT '0000-00-00 00:00:00',
						plan_download_time datetime DEFAULT '0000-00-00 00:00:00',
						plan_status TINYINT(3) UNSIGNED DEFAULT 0,
						INDEX (box_id,plan_status)
					) $charset_collate");
		}
		if($wpdb->get_var("SHOW TABLES LIKE '{$table_info_name}'") != $table_info_name){
			$wpdb->query("
					CREATE TABLE {$table_info_name}
					(
						plan_info_id int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
						plan_id int(11) UNSIGNED NOT NULL,
						plan_open_time time NOT NULL DEFAULT '00:00:00',
						plan_start_time time NOT NULL DEFAULT '00:00:00',
						item_type VARCHAR(20) NOT NULL,
						item_id int(11) UNSIGNED NOT NULL,
						plan_info_status TINYINT(3) UNSIGNED DEFAULT 0,
						INDEX (plan_id,plan_info_status)
					) $charset_collate");
		}
		
		if($wpdb->get_var("SHOW TABLES LIKE '{$table_log_name}'") != $table_log_name){
			$wpdb->query("
					CREATE TABLE {$table_log_name}
					(
						plan_log_id int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
						plan_id int(11) UNSIGNED NOT NULL,
						box_id int(11) UNSIGNED NOT NULL,
						action_time datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
						log_type TINYINT(3) UNSIGNED DEFAULT 0,
						INDEX (plan_id)
					) $charset_collate");
		}
	}
	



	pb_plan_init();
?>