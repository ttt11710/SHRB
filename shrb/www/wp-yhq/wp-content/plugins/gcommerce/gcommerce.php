<?php

/**
 * The plugin bootstrap file
 *
 * This file is read by WordPress to generate the plugin information in the plugin
 * Dashboard. This file also includes all of the dependencies used by the plugin,
 * registers the activation and deactivation functions, and defines a function
 * that starts the plugin.
 *
 * @link              http://gchu.cn
 * @since             1.0.0
 * @package           GCommerce
 *
 * @wordpress-plugin
 * Plugin Name:       gCommerce
 * Plugin URI:        http://gchu.cn/gcommerce/
 * Description:       GanChu's mobile ecommerce platform. Based on Wordpress & WooCommerce.
 * Version:           1.0.0
 * Author:            Wang Xiongxiong
 * Author URI:        http://gchu.cn/
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       gcommerce
 * Domain Path:       /languages
 */

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
	die;
}

define( 'GCOMMERCE_PLUGIN_PATH', dirname( __FILE__ ) );

/**
 * The code that runs during plugin activation.
 */
require_once plugin_dir_path( __FILE__ ) . 'includes/class-gcommerce-activator.php';

/**
 * The code that runs during plugin deactivation.
 */
require_once plugin_dir_path( __FILE__ ) . 'includes/class-gcommerce-deactivator.php';

/** This action is documented in includes/class-gcommerce-activator.php */
register_activation_hook( __FILE__, array( 'GCommerce_Activator', 'activate' ) );

/** This action is documented in includes/class-gcommerce-deactivator.php */
register_deactivation_hook( __FILE__, array( 'GCommerce_Deactivator', 'deactivate' ) );

/**
 * The core plugin class that is used to define internationalization,
 * dashboard-specific hooks, and public-facing site hooks.
 */
require_once plugin_dir_path( __FILE__ ) . 'includes/class-gcommerce.php';

/**
 * Begins execution of the plugin.
 *
 * Since everything within the plugin is registered via hooks,
 * then kicking off the plugin from this point in the file does
 * not affect the page life cycle.
 *
 * @since    1.0.0
 */
function run_gcommerce() {

	$plugin = new GCommerce();
	$plugin->run();

}
run_gcommerce();

register_activation_hook( __FILE__,  'wev_install'  );
function wev_install()
{
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

register_activation_hook( __FILE__,  'yhq_install' );
function yhq_install()
{
	global $wpdb, $wp_version;
	$table_name='wp_gcommerce_yhq';
	if($wpdb->get_var("show tables like '{$table_name}") != $table_name){
		$sSql = "CREATE TABLE IF NOT EXISTS `{$table_name}` (";
		$sSql = $sSql . "`id` INT NOT NULL AUTO_INCREMENT ,";
		$sSql = $sSql . "`qu_id` INT NOT NULL,";
		$sSql = $sSql . "`use_id` INT NOT NULL,";
		$sSql = $sSql . "`order_id` INT NOT NULL,";
		$sSql = $sSql . "`p_id` INT NOT NULL,";
		$sSql = $sSql . "`rec_time` INT NOT NULL,";
		$sSql = $sSql . "`is_used` INT NOT NULL,";
		$sSql = $sSql . "`use_time` INT NOT NULL,";
		$sSql = $sSql . "`pay_order_id` VARCHAR(255) NOT NULL,";
		$sSql = $sSql . "PRIMARY KEY (`id`)";
		$sSql = $sSql . ")";
		$wpdb->query($sSql);
	}
}

register_activation_hook( __FILE__,  'user_card' );
function user_card()
{
	global $wpdb, $wp_version;
	$table_name='wp_gcommerce_user_card';
	if($wpdb->get_var("show tables like '{$table_name}") != $table_name){
		$sSql = "CREATE TABLE IF NOT EXISTS `{$table_name}` (";
		$sSql = $sSql . "`id` INT NOT NULL AUTO_INCREMENT ,";
		$sSql = $sSql . "`user_phone` VARCHAR(255) NOT NULL,";
		$sSql = $sSql . "`user_card` VARCHAR(255) NOT NULL,";
		$sSql = $sSql . "PRIMARY KEY (`id`)";
		$sSql = $sSql . ")";
		$wpdb->query($sSql);
	}
}
function pb_code_decrypt($user_card){
	$get_ip_url = "http://192.168.14.24/decrypt.php";
	$post_data = array ("user_card" => $user_card);
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $get_ip_url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	// post数据
	curl_setopt($ch, CURLOPT_POST, 1);
	// post的变量
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
	$output = curl_exec($ch);
	curl_close($ch);
	//打印获得的数据
	// print_r($output);
	return $output;
}
function pb_verify_card($card)
{
	$verify_card=substr($card, 0,6);
	$card_array=array('520169','521899','458124','458123','622253','622252','628218','628216','522964','622656','434910',
		'405512','601428','622258','622259','622260','622261','622262','621002','621069','620013');
	if(in_array($verify_card, $card_array)){
		return true;
	}
	else{
		return false;
	}
}
function pb_save_card($card)
{
	global $wpdb;
	global $current_user;
	$public_key= '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCucuqa4g86KL7Ii2KBxVhtL0+y
9k5mkh3rX+Yc0lNXVf2Qn7vP2OSXrYY5LnAcBUHDST1U05uLU3u/xgJJoO2q8WlD
DdgzlIQEqMtxK6Yh1mEbofweqB54sMCEaAqFvmlY7+HaR2/LigsesAFbHnCGcSkh
MlJ0ry/ZvnT2Et3RGwIDAQAB
-----END PUBLIC KEY-----';
	$encrypted = ""; 
	openssl_public_encrypt($card,$encrypted,$public_key);//公钥加密  
	$encrypted = base64_encode($encrypted);
	// $encrypted = $card;
	$user_phone=$current_user->user_login;
	$verify_phone=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_gcommerce_user_card where user_phone={$user_phone}"));
	// print_r($verify_phone);
	if(!($verify_phone>0))
	{
		$wpdb->query("INSERT INTO wp_gcommerce_user_card (user_phone, user_card) VALUES ('{$user_phone}','{$encrypted}')");
	}
	else{
		$wpdb->query("update wp_gcommerce_user_card set user_card ='{$encrypted}' where user_phone='{$user_phone}'");
	}
}