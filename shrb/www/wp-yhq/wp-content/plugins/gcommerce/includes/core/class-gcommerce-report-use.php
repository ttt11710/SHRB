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

class GCommerce_Report_Use {

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
		$loader->add_action('init',$this, 'export_csv');
		
	}
	function add_menu(){
		$wc_page = 'woocommerce';
		// api: add_submenu_page( $parent_slug, $page_title, $menu_title, $capability, $menu_slug, $function );
		$comparable_settings_page = add_submenu_page( $wc_page , '优惠券使用情况', '优惠券使用情况', 'manage_options', 'yhq_use_report', array(
				&$this,
				'settings_page'
		));
	}
	public function settings_page() {
		$actionurl=$_SERVER['REQUEST_URI'];
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
		$used=$this->order_data($stime,$etime);
		// print_r($_POST);
		// if($_POST['export']=='导出'){
		// 	$str = iconv('utf-8','gb2312',$str);   
		// 	foreach ($used as $value) {
		// 		$order_id = iconv('utf-8','gb2312',$value['order_id']); //中文转码   
		// 		$phone = iconv('utf-8','gb2312',$value['phone']);
		// 		$order_name = iconv('utf-8','gb2312',$value['order_name']);
		// 		$create_time = iconv('utf-8','gb2312',$value['create_time']);
		// 		$pay_time = iconv('utf-8','gb2312','交易完成时间');
		// 		$create_ip = iconv('utf-8','gb2312',$value['create_ip']);
		// 		$store_name = iconv('utf-8','gb2312',$value['store_name']);
		// 		$order_price = iconv('utf-8','gb2312',$value['order_price']);
		// 		$order_completed = iconv('utf-8','gb2312',$value['order_completed']);
		// 		$str .= $order_id.",".$phone.",".$order_name.",".$create_time.",".$pay_time.",".$create_ip.",".$store_name.",".$order_price.",".$order_completed."\n";
		// 	}
		// }
	?>
		<form action="<?php echo $actionurl; ?>" method="post" enctype="multipart/form-data">
			<input type="date" name='date' value="<?php echo $stime; ?>" >至<input type="date" name='date1' value="<?php echo $etime; ?>" ><input type='submit' name='screening' value='筛选'><input type='submit' name='export' value='导出'>
		</form>
	<?php
		echo '<table border="1">';
		echo "<tr><td>订单号</td><td>用户名</td><td>商品名称</td><td>订单日期</td><td>交易时间</td><td>发生交易支行</td><td>活动商户</td><td>交易金额</td><td>状态</td></tr>";
		foreach ($used as $value) {
			echo "<tr><td>".$value['order_id']."</td><td>".$value['phone']."</td><td>".$value['order_name']."</td><td>".$value['create_time']."</td><td>交易完成时间</td><td>".$value['create_ip']."</td><td>".$value['store_name']."</td><td>".$value['order_price']."</td><td>".$value['order_completed']."</td></tr>";
		}
		echo '</table>';
		echo '统计日期：'.$stime.'至'.$etime;
	}

	public function export_csv()
	{
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
		$used=$this->order_data($stime,$etime);
		$filename=date('ymd');
		if($_POST['export']=='导出'){
			header( 'Content-Description: File Transfer' );
			header( 'Content-Disposition: attachment; filename='.$filename.'.csv');
			header( 'Content-Type: text/csv; charset=' . get_option( 'blog_charset' ), true );
			$str = "订单号,用户名,商品名称,订单日期,交易时间,发生交易支行,活动商户,交易金额,状态\n";
			$str = iconv('utf-8','gb2312',$str);
			foreach ($used as $value) {
				$order_id = iconv('utf-8','gb2312',$value['order_id']); //中文转码   
				$phone = iconv('utf-8','gb2312',$value['phone']);
				$order_name = iconv('utf-8','gb2312',$value['order_name']);
				$create_time = iconv('utf-8','gb2312',$value['create_time']);
				$pay_time = iconv('utf-8','gb2312','交易完成时间');
				$create_ip = iconv('utf-8','gb2312',$value['create_ip']);
				$store_name = iconv('utf-8','gb2312',$value['store_name']);
				$order_price = iconv('utf-8','gb2312',$value['order_price']);
				$order_completed = iconv('utf-8','gb2312',$value['order_completed']);
				$str .= $order_id.",".$phone.",".$order_name.",".$create_time.",".$pay_time.",".$create_ip.",".$store_name.",".$order_price.",".$order_completed."\n";
			}
			echo $str;
			exit();
		}
	}
	function order_data($stime,$etime){
		global $wpdb;
		$mypost = array( 'post_type' => 'shop_order','posts_per_page'=>-1 );
		$loop = new WP_Query( $mypost );
		$used=array();
		$i=0;
		$s_time=strtotime($stime.' 00:00:00');
		$e_time=strtotime($etime.' 23:59:59');
		while ( $loop->have_posts() ){
			$loop->the_post();
			// print_r(get_the_ID());
			$order=new WC_Order(get_the_ID());
			$order_id=get_the_ID();
			$items=$order->get_items();
			$order_name=null;
			foreach ($items as $it) {
				$order_name=$it['name'];
				$product_id=$it['product_id'];
			}
			$order_create=date_i18n('Y-m-d H:i', strtotime( $order->order_date ) );
			$ip=get_post_meta($order_id,'route_ip',ture);
			$price=get_post_meta($order_id,'_order_total',ture);
			// $user_phone=get_post_meta($order_id,'shot_phone',ture);
			$user_phone=substr($order->billing_email,0,11);
			$pay_complete=get_post_meta( $order_id, '_completed_date',ture);
			// die;
			$terms=get_the_terms( $product_id, 'product_cat' );
			// $store_name=$terms[0]->description;
			foreach ($terms as $value) {
				$store_name=$value->name;
			}
			$is_used=$wpdb->get_row("SELECT is_used,use_time FROM wp_gcommerce_yhq where order_id={$order_id}",ARRAY_A );
			if($is_used['is_used']==0)
			{
				$user_time="未验证";
			}
			else{
				$user_time="验证时间".date('Y-m-d H:i:s',$is_used['use_time']);
			}
			if(!empty($pay_complete)){
				// print_r('expression');
				if(strtotime($pay_complete)>$s_time && strtotime($pay_complete)<$e_time){
					// print_r('qq');
					$used[$i]['order_id']=$order_id;
					$used[$i]['phone']=$user_phone;
					$used[$i]['order_name']=$order_name;
					$used[$i]['create_time']=$order_create;
					$used[$i]['order_completed']=$user_time;
					$used[$i]['create_ip']=$ip;
					$used[$i]['store_name']=$store_name;
					$used[$i]['order_price']=$price ;
					$i++;
				}
			}
		}
		return $used;
	}
}