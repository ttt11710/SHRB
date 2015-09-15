<?php
/*
Plugin Name: BiWiFi Portal
Plugin URI:  
Description: biwifi验证控件
Version:     1.0.3
Author:      Ian Dunn
Author URI:  http://iandunn.name
*/
define( 'BIWIFI_PORTAL_PLUGIN_PATH', dirname( __FILE__ ) );
require_once( __DIR__ . '/classes/bwfpt_shot_code.php' );
register_activation_hook( __FILE__,  'wev_install_table'  );
require_once plugin_dir_path( __FILE__ ) . 'class-biwifi-portal.php';
function wev_install_table()
{
	$table_name='pb_group_message';
	global $wpdb, $wp_version;
	$table_name='wp_gcommerce_temp_user';
	if($wpdb->get_var("show tables like '{$table_name}") != $table_name){
		$sSql = "CREATE TABLE IF NOT EXISTS `{$table_name}` (";
		$sSql = $sSql . "`user_id` INT NOT NULL AUTO_INCREMENT ,";
		$sSql = $sSql . "`user_name` TEXT NOT NULL,";
		$sSql = $sSql . "`user_pass` TEXT NOT NULL,";
		$sSql = $sSql . "`user_email` TEXT NOT NULL,";
		$sSql = $sSql . "`confirm_code` TEXT NOT NULL,";
		$sSql = $sSql . "`type` TEXT NOT NULL,";
		$sSql = $sSql . "PRIMARY KEY (`user_id`)";
		$sSql = $sSql . ")";
		$wpdb->query($sSql);
	}
}
function run_biwifi_portal() {

	$plugin = new Biwifi_Portal();
	$plugin->run();

}
run_biwifi_portal();
//创建自定义文章类型
add_action( 'init', 'biwifi_box_init' );
//创建自定义输入字段
add_action( 'add_meta_boxes','biwifi_ubox_id' ); 
//保存盒子信息
add_action('save_post', 'biwifi_save_meta_box', 10, 2);
function biwifi_box_init()
{
	register_post_type( 'ubox',
        array(
            'labels' => array(
				'name' => __( '盒子' ),
				'singular_name' => __( '盒子' ),
				'add_new' => '添加盒子'
			),
		'public' => true,
		'has_archive' => true,
		'supports'=>array('title'),
		)
	);
}
function biwifi_ubox_id(){
	add_meta_box( 'ubox', '盒子信息','biwifi_id_key', 'ubox', 'normal', 'high' );
}
function biwifi_id_key()
{
		global $post;
		// print_r($post->ID);
		$mac_address=get_post_meta($post->ID,'mac_address');
		$box_id=get_post_meta($post->ID,'box_id');
		// print_r($mac_address[0]);
		// die;
		echo '<table>';
		echo '<tr><td style="vertical-align: top;">';
		echo '<label for="pb_shipping_no">MAC地址：</label></td><td>';
		echo '<input type="text" name="mac_address" value="'.$mac_address[0].'" /></td></tr><tr><td>';
		//echo '<p style="margin:0;">格式： 每个BSSid请使用|分割</p></td></tr><tr><td>';
		echo '<label for="pb_shipping_no">盒子id：</label></td><td>';
		echo '<input type="text" name="box_id" value="'.$box_id[0].'" />';
		echo '</td></tr></table>';
}
function biwifi_save_meta_box($post_id, $post)
{
	// print_r($post_id);
	// print_r($_POST);
	update_post_meta($post_id,'mac_address',$_POST['mac_address']);
	update_post_meta($post_id,'box_id',$_POST['box_id']);
}


add_action('parse_request','pb_parse_request',0);
function pb_parse_request()
{
	// print_r('expression');
	// die;
	global $wp;
	// isset($_GET['uamip']);
	// isset($_GET['uamport']);
	// isset($_GET['nasid']);
	// print_r(isset($_GET['uamip']));
	// print_r(isset($_GET['uamport']));
	// print_r(isset($_GET['nasid']));
	// print_r(get_client_ip());
	// print_r($wp->query_vars);
	// die;
	if(isset($_GET['uamip']) && isset($_GET['uamport']) && isset($_GET['nasid'])){
		$ap_mac=$_GET['nasid'];
		$ip=get_client_ip();
		// print_r($ip);
		// die;
		$url = "http://bankcomm.biwifi.cn:8080/wlan/addApIp?nasid=".$ap_mac."&ip=".$ip;
		// print_r($url);
		$send_result=pb_send_MacIp($url);
	}
}

function get_client_ip() {
	$ipaddress = '';
	$ipaddress=apache_request_headers();
	return $ipaddress['ssl-clientip'];
	// die;
	// print_r($_SERVER['HTTP_CLIENT_IP']);
	// echo "|";
	// print_r($_SERVER['HTTP_X_FORWARDED_FOR']);
	// echo "|";
	// print_r($_SERVER['HTTP_X_FORWARDED']);
	// echo "|";
	// print_r($_SERVER['HTTP_FORWARDED_FOR']);
	// echo "|";
	// print_r($_SERVER['HTTP_FORWARDED']);
	// echo "|";
	// print_r($_SERVER['REMOTE_ADDR']);
	// echo "||";
	// if ($_SERVER['HTTP_CLIENT_IP'])
	// 	$ipaddress = $_SERVER['HTTP_CLIENT_IP'];
	// else if($_SERVER['HTTP_X_FORWARDED_FOR'])
	// 	$ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
	// else if($_SERVER['HTTP_X_FORWARDED'])
	// 	$ipaddress = $_SERVER['HTTP_X_FORWARDED'];
	// else if($_SERVER['HTTP_FORWARDED_FOR'])
	// 	$ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
	// else if($_SERVER['HTTP_FORWARDED'])
	// 	$ipaddress = $_SERVER['HTTP_FORWARDED'];
	// else if($_SERVER['REMOTE_ADDR'])
	// 	$ipaddress = $_SERVER['REMOTE_ADDR'];
	// else
	// 	$ipaddress = 'UNKNOWN';
	// return $ipaddress;
}
function pb_send_MacIp($url)
{
	$ch = curl_init();
	//设置选项，包括URL
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	//执行并获取HTML文档内容
	$output = curl_exec($ch);
	//释放curl句柄
	curl_close($ch);
	// print_r($output);
	// die;
	//打印获得的数据
	return $output;
}
function biwifi_portal_select(){
	$ap_id=get_client_ip();
	$url = "http://bankcomm.biwifi.cn:8080/wlan/queryApIp?ip=".$ap_id;
	$is_ap=pb_send_MacIp($url);
	return $is_ap;
}