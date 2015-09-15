<?php

/**
 * gCommerce后台定义用户折扣、打印机id等等
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

class GCommerce_Report {

	/**
	 * Initialize the object.
	 *
	 * @since    1.0.0
	 */
	public function __construct() {
		// $loader->add_action('woocommerce_init',$this, 'init');
	}

	/**
	 * gCommerce初始化.
	 *
	 * @since    1.0.0
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	public function init( $loader ) {
		$loader->add_action( 'admin_menu',$this, 'add_menu' );
		if($_POST['action']=='app_report')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'app_report',999999);
	}
	function add_menu(){
		$wc_page = 'woocommerce';
		// api: add_submenu_page( $parent_slug, $page_title, $menu_title, $capability, $menu_slug, $function );
		$comparable_settings_page = add_submenu_page( $wc_page , '优惠券使用报表', '优惠券使用报表', 'manage_options', 'yhq_report', array(
				&$this,
				'settings_page'
		));
	}
	public function settings_page() {
		$stime;
		$etime;
		if(isset($_POST['date']) || isset($_POST['date1']))
		{
			$stime=$_POST['date'];
			$etime=$_POST['date1'];
		}
		else{
			$stime=date('Y-m-d');
			$etime=date('Y-m-d');
		}
		global $wpdb;
		$actionurl = $_SERVER['REQUEST_URI'];
// 		//查询订单id与账户
		$stoe_name=$wpdb->get_results($wpdb->prepare("select wp_posts.ID,wp_postmeta.meta_value from wp_posts
		left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id
		where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name';"),ARRAY_A);
		//查询订单时间
		$store_time=$wpdb->get_results("select wp_posts.ID,wp_postmeta.meta_value from wp_posts 
			left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id 
			where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='_completed_date' 
			and meta_value between '".$stime." 00:00:00' and '".$etime." 23:59:59' 
			group by wp_postmeta.meta_value ;",ARRAY_A);
		// print_r($stoe_name);
		// print_r($store_time);
		$newstore=array();
		foreach ($stoe_name as $key=>$value) {
			// print_r($value);
			foreach ($store_time as $time) {
				if($value['ID']==$time['ID'])
				{
					$stoe_name[$key]['time']=$time['meta_value'];
					// $newstore['id']=$value['ID'];
					// $newstore['storename']=$value['meta_value'];
					// $newstore['TIME']=$time['meta_value'];
					$newstore[$key]['id']=$value['ID'];
					$newstore[$key]['storename']=$value['meta_value'];
					$newstore[$key]['time']=$time['meta_value'];
				}
			}
		}
		// print_r($newstore);
		$row=$wpdb->get_results($wpdb->prepare("select count(*) as count,wp_postmeta.meta_value from wp_posts left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name' group by wp_postmeta.meta_value;"),ARRAY_A);
		// print_r($row);
		$store_name=$this->get_store_name();
		// print_r($store_name);
		// print_r($actionurl);
		?>
		<form action="<?php echo $actionurl; ?>" method="post">
			<input type="date" name='date' value="<?php echo $stime; ?>" >至<input type="date" name='date1' value="<?php echo $stime; ?>" ><input type='submit' value='筛选'>
		</form>
		<?php
		echo '<table border="1">';
		echo "<tr><td>用户名称</td><td>使用数量</td></tr>";
		foreach ($store_name as $value) {
			$i=0;
			foreach ($newstore as $store) {
				if($value==$store['storename']){
					$i++;
				}
			}
			echo "<tr><td>".$value."</td><td>".$i."</td></tr>";
		}
		echo '</table>';
		echo '统计日期：'.$stime.'至'.$etime;
	}
	function get_store_name(){
		$mypost = array( 'post_type' => 'storename', );
		$loop = new WP_Query( $mypost );
		$store_name=array();
		while ( $loop->have_posts() ){
			$loop->the_post();
			$store_post_id=get_the_ID();
			$store_name[]=get_post_meta($store_post_id,'stoe_name',ture);
		}
		return $store_name;
	}
	public function app_report(){
		global $wpdb;
		$stime;
		$etime;
		if(isset($_POST['stime']) || isset($_POST['etime']))
		{
			$stime=$_POST['stime'];
			$etime=$_POST['etime'];
		}
		else
		{
			$stime=date('Y-m-d');
			$etime=date('Y-m-d');
		}
		$all_count=$wpdb->get_results("select count(*) as all_count from wp_posts 
			left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id 
			where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name' and wp_postmeta.meta_value='".$_POST['store_user']."';");
		$stoe_name=$wpdb->get_results($wpdb->prepare("select wp_posts.ID,wp_postmeta.meta_value from wp_posts 
			left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id 
			where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name' and wp_postmeta.meta_value='".$_POST['store_user']."';"),ARRAY_A);
		$store_time=$wpdb->get_results("select wp_posts.ID,wp_postmeta.meta_value from wp_posts 
			left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id 
			where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='_completed_date' 
			and meta_value between '".$stime." 00:00:00' and '".$etime." 23:59:59' 
			group by wp_postmeta.meta_value ;",ARRAY_A);
		$newstore=array();
		$i=0;
		foreach ($stoe_name as $key=>$value) {
			// print_r($value);
			foreach ($store_time as $time) {
				if($value['ID']==$time['ID'])
				{
					$stoe_name[$i]['time']=$time['meta_value'];
					$newstore[$i]['id']=$value['ID'];
					$order = new WC_Order($value['ID']);
					$items=$order->get_items();
					$order_name=null;
					foreach ($items as $it) {
						$order_name=$it['name'];
						$product_id=$it['product_id'];
					}
					$newstore[$i]['name']=$order_name;
					$newstore[$i]['time']=$time['meta_value'];
					$i++;
				}
			}
		}
		// print_r($newstore);
		// die;
		echo json_encode(array('report_info'=>$newstore,"count"=>count($newstore),"all_count"=>$all_count[0],"stime"=>$stime,"etime"=>$etime));
		exit();


	}

}