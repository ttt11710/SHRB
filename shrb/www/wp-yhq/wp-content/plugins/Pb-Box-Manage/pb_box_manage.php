<?php
/* 
Plugin Name: Pb-Box-Manage
Plugin URI: http://www.u-gen.net
Description: 大屏幕促销活动设置（三福百货）
Version: 1.0.140923
Author: U-gen

*/
/*尝试使用插件*/
// include_once( 'create_post_controls/pb_add_store.php' ); 
// include_once( 'create_post_controls/pb_add_box.php' ); 
include_once( 'create_post_controls/pb_add_controls.php' ); 
include_once( 'create_post_controls/pb_add_group.php' ); 
include_once( 'create_post_controls/pb_add_flashsale.php' ); 
// include_once( 'create_post_controls/pb_add_product_purchase.php');
// include_once( 'create_post_controls/pb_add_product_property.php');
include_once( 'pb_interface_ajax.php' ); 
include_once( 'pb_dispatch.php' );
include_once( 'pb_create_menu.php' ); 
include_once( 'class/publicClass.php' );


add_action('init', 'pb_box_init');
//初始化插件
function pb_box_init()
{
	include_once( ABSPATH . 'wp-admin/includes/plugin.php' ); 
	//&& is_plugin_active('pb-select-store/pb_select_store.php')
	if(is_plugin_active('fields-framework/index.php'))
	{
		//盒子区块
		pb_box_fff_fields_framework();
		//团购区块
		pb_add_group_init();
		//秒杀区块
		pb_add_flashSale_init();
		pb_create_menu_init();
		pb_intface_ajax_init();
		// pb_template_init();
		//add_store_box_menu();
		//add_activity_menu();
		new pb_timingTasks();
        pb_add_diy_menu();
    }
	else
	{
		pb_box_stop_box_manage();
	}
}
//停用插件
function pb_box_stop_box_manage()
{
	deactivate_plugins( 'Pb-Box-Manage/pb_box_manage.php' );
	echo "<script>alert('启用Pb-Box-Manage插件前必须启用Fields-Framework插件与pb select-store插件');</script>";
}

?>
