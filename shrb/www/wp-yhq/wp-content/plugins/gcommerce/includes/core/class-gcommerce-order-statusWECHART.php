<?php

/**
 * 优惠券订单创建修改验证
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

class GCommerce_Order {


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
		//创建订单
		// $loader->add_action( 'woocommerce_order_status_processing', $this,'order_create',10,1 );
		//创建订单订单状态变为处理中，付款订单修改库存
		$loader->add_action( 'woocommerce_checkout_order_processed', $this,'order_create',10,1 );
		//创建订单当订单状态改付款完成
		$loader->add_action( 'woocommerce_order_status_paid', $this,'order_secd_info',10,1 );
		//订单延时取消付款订单库存改回
		$loader->add_action( 'woocommerce_order_status_cancelled', $this,'order_product_stock',10,1 );
		//订单二维码js
		$loader->add_action( 'wp_enqueue_scripts',$this, 'pb_qrcode_scripts',999999);
		//验证优惠券
		if($_POST['action']=='verification_yhq')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'verification_yhq',999999);
		//更改优惠券状态
		if($_POST['action']=='update_yhq')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'update_yhq',999999);
		//商户登入登记uuid
		if($_POST['action']=='store_login')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'store_login',999999);
		//购物车后woocommerce_after_add_to_cart_form
		$loader->add_action( 'init',$this, 'add_cart_verification',10,1);
	}
	function update_yhq()
	{
		global $wpdb;
		$order_id=$_POST['order_id'];
		$uuid=$_POST['id'];
		$storename=$_POST['storename'];
		// print_r('expression');
		// $is_store_used=$this->yhq_store($uuid);
		$order=new WC_Order($order_id);
		$product_id;
		foreach( $order->get_items() as $item ) {
			$product_id=$item['product_id'];
		}
		if($product_id==0){

			$this->update_wechat($order);
		}

		$status=get_term_by( 'slug', $order->status, 'shop_order_status' );
		// print_r($status);
		$price=get_post_meta($order_id,'_order_total');
		// print_r($price);
		// print_r($status->name);
		// die;
		if($status->name=='paid' || ($status->name=='processing' && $price[0]=='0.00'))
		{
			$start_time=get_post_meta($product_id,'start');
			$end_time=get_post_meta($product_id,'end');
			$start_time=strtotime($start_time[0]);
			$end_time=strtotime($end_time[0]);
			$current_time=current_time('timestamp');
			// print_r($start_time);echo "|";
			// print_r($end_time);echo "|";
			// print_r(current_time('timestamp'));
			if($current_time<=$start_time)
			{
				echo json_encode(array('code'=>'1001','msg'=>'验证时间未到'));
			}
			else if($current_time>=$end_time)
			{
				echo json_encode(array('code'=>'1001','msg'=>'验证时间已过'));
			}
			else{
				$order->update_status('completed', '已完成');
				update_post_meta($order_id,'uuid',$uuid);
				update_post_meta($order_id,'store_name',$storename);
				$time=current_time('timestamp');
				$wpdb->query("update wp_gcommerce_yhq set is_used = 1,use_time={$time} where order_id ={$order_id}");
				echo json_encode(array('code'=>'1000','msg'=>'验证成功'));
			}
			
		}
		else{
			echo json_encode(array('code'=>'1002','msg'=>'当前优惠券不可使用'));
		}
		exit();
	}
	//验证优惠券
	function verification_yhq(){
		global $wpdb;
		$qid=$_POST['qid'];
		$store_id=$_POST['store_id'];
		// print_r($qid);
		// die;
		$order_id=$wpdb->get_results("SELECT order_id FROM wp_gcommerce_yhq where qu_id={$qid};");
		$order_id=$order_id[0]->order_id;
		$order=new WC_Order($order_id);
		$status=get_term_by( 'slug', $order->status, 'shop_order_status' );
		$time=date_i18n('Y-m-d H:i', strtotime( $order->order_date ) );

		foreach( $order->get_items() as $item ) {
			$name=$item['name'];
			$product_id=$item['product_id'];
			$qty=$item['item_meta']['_qty']['0'];
		}
		$price=get_post_meta($order_id,'_order_total');
		// print_r($product_id);
		if($product_id==0){
			$this->wechat_verification($order_id,$status,$price[0],$time,$name,$qty);
		}
		die;
		//order_id,status,总价
		$is_store=$this->pb_verification_stoe($product_id,$store_id);
		// print_r($is_store);
		// die;
		// if($is_store==0){

		// }
		if($is_store==0)
		{
			$status='商户不可验证';
			echo json_encode(array('code'=>'1002','order_id'=>$order_id,'status'=>$status,'price'=>$price[0],'time'=>$time,'name'=>$name,'qty'=>$qty));
		}
		else{
			if($status->name=='paid' || ($status->name=='processing' && $price[0]=='0.00'))
			{
				$status='可用';
				echo json_encode(array('code'=>'1000','order_id'=>$order_id,'status'=>$status,'price'=>$price[0],'time'=>$time,'name'=>$name,'qty'=>$qty));
			}
			else{
				$status='不可用';
				echo json_encode(array('code'=>'1001','order_id'=>$order_id,'status'=>$status,'price'=>$price[0],'time'=>$time,'name'=>$name,'qty'=>$qty));
			}
		}
		exit();
	}
	//订单二维码js
	function pb_qrcode_scripts() {
		wp_enqueue_script( 'qrcode.jquery-script', plugins_url().'/gcommerce/public/js/jquery.qrcode.min.js', array(), '1.0.0', true );
		wp_enqueue_script( 'qrcode-script', plugins_url().'/gcommerce/public/js/pb-qrcode.js', array(), '1.0.0', true );
	}
	//订单状态改为已支付后发送短信
	function order_secd_info($order_id)
	{
		global $wpdb,$current_user;
		$order=new WC_Order($order_id);
		$price=get_post_meta($order_id,'_order_total',true);
		$qid=get_post_meta($order_id,'qid',true);
		$name;
		foreach( $order->get_items() as $item ) {
			$name=$item['name'];
			$pid=$item['product_id'];
		}
		if($price!='0.00'){
			$url=home_url().'/myaccount';
			// print_r($name);
			// print_r($qid);
			// print_r($url);
			// die;
			$content="尊敬的顾客您好，您已在交通银行热点银行网点成功购买了".$name."，请凭验证码".$qid."到指定商户使用，手机登录 ".$url." 可查询订单。";
			// print_r($content);
			// die;
			// $res = $this->pb_sms_gcommerce(substr($order->billing_email,0,11),$content);
			update_post_meta($order_id,'send_phone',substr($order->billing_email,0,11));
			update_post_meta($order_id,'content',$content);
		}

	}
	//订单创建
	function order_create($order_id){
		global $wpdb,$current_user;
		$order=new WC_Order($order_id);
		$pid;
		$name;
		foreach( $order->get_items() as $item ) {
			$name=$item['name'];
			$pid=$item['product_id'];
		}
		$qid=$this->ceate_qid($pid);
		$u_id=$current_user->ID;
		$time=current_time('timestamp');
		$pay_order_id=$this->ceate_pay_order_id();
		$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where order_id={$order_id}");
		if($is_one==0)
		{
			// $sql="INSERT INTO wp_gcommerce_yhq (qu_id, use_id, order_id,p_id,rec_time,pay_order_id) VALUES ({$qid},{$u_id},{$order_id},{$pid},{$time},'{$pay_order_id}')";
			// print_r($sql);
			// die;
			$wpdb->query("INSERT INTO wp_gcommerce_yhq (qu_id, use_id, order_id,p_id,rec_time,pay_order_id) VALUES ({$qid},{$u_id},{$order_id},{$pid},{$time},'{$pay_order_id}')");
		}
		$price=get_post_meta($order_id,'_order_total',true);
		$product=get_product($pid,$fields = null);
		$stock=$product->stock;
		if($price=='0.00')
		{
			$url=home_url().'/myaccount';
			// $content="尊敬的顾客您好！您已在交通银行热点银行网点成功领取了一张".$name."，请到指定商户使用，优惠券验证码".$qid."，手机登陆".$url." 可查询订单。";
			$content="尊敬的顾客您好，您已在交通银行热点银行网点成功免费领取了".$name."，请凭验证码".$qid."到指定商户使用，手机登录 ".$url." 可查询订单。";
			$res = $this->pb_sms_gcommerce($current_user->user_login,$content);
			$ip=get_client_ip();
			update_post_meta($order_id,'shot_phone',$current_user->user_login);
			update_post_meta($order_id,'shot_content',$content);
			update_post_meta($order_id,'shot',$res);
			
		}
		else{
			$stock=$stock-1;
			wc_update_product_stock($pid,$stock);
		}
		update_post_meta($order_id,'route_ip',$ip);
		update_post_meta($order_id,'qid',$qid);
		update_post_meta($order_id,'pay_order_id',$pay_order_id);

	}
	//订单状态取消
	function order_product_stock($order_id){
		$order=new WC_Order($order_id);
		$pid;
		$name;
		foreach( $order->get_items() as $item ) {
			$name=$item['name'];
			$pid=$item['product_id'];
		}
		$product=get_product($pid,$fields = null);
		$stock=$product->stock;
		$price=get_post_meta($order_id,'_order_total',true);
		if($price!='0.00'){
			$stock=$stock+1;
			wc_update_product_stock($pid,$stock);
		}
	}
	//创建优惠券验证码id
	function ceate_qid($pid)
	{
		global $wpdb;
		$q_id=rand(100000,999999);
		$q_id=$pid.$q_id;
		$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where qu_id={$q_id}");
		if($is_one>0)
		{
			ceate_qid($pid);
		}
		return $q_id;
	}
	//创建支付订单唯一id
	function ceate_pay_order_id()
	{
		global $wpdb; 
		$time=date('ymdHis',current_time('timestamp'));
		$order_id="YL".$time.rand(1000,9999);
		$is_one=$wpdb->query("SELECT * FROM wp_gcommerce_yhq where qu_id={$q_id}");
		if($is_one>0){
			ceate_pay_order_id();
		}
		return $order_id;
	}
	function pb_sms_gcommerce($to,$content) {
		$url = "http://121.199.16.178/webservice/sms.php?method=Submit";
		$post_data = array('account'=>'cf_pbxx','password'=>'F1nf34ilcmo9','mobile'=>$to,'content'=>$content);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		// post数据
		curl_setopt($ch, CURLOPT_POST, 1);
		// post的变量
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		$output = curl_exec($ch);
		curl_close($ch);
		//打印获得的数据
		return $output;
	}
	//添加购物车后
	function add_cart_verification(){
		if ( empty( $_REQUEST['add-to-cart'] ) || ! is_numeric( $_REQUEST['add-to-cart'] ) ) {
			return;
		}
		$product_id= apply_filters( 'woocommerce_add_to_cart_product_id', absint( $_REQUEST['add-to-cart'] ) );
		//商品id
		// print_r($product_id);
		$activity_stat=get_post_meta($product_id,'activity_start');
		$activity_end=get_post_meta($product_id,'activity_end_copy');
		$activity_stat=strtotime($activity_stat[0]);
		$activity_end=strtotime($activity_end[0]);
		// print_r($activity_stat);
		// print_r($activity_end);
		// print_r(date('Y/m/d h:i:s',current_time('timestamp')));
		// print_r('|'.date('Y/m/d h:i:s',$activity_stat));
		$product=get_product($product_id);
		// print_r($product->stock);
		// die;
		$cat_count = get_the_terms( $product_id, 'product_cat' );
		// print_r($cat_count);
		$button_text=array();
		foreach ($cat_count as $value) {
			$button_text[]=$value->name;
		}
		if(!in_array('实体商品', $button_text)){
			if($product->stock<=0){
				wc_add_notice( sprintf( __( "抱歉，您来晚了券已被抢光，下次再来吧" ), $product->get_title() ), 'error' );
				return;
			}
			if (current_time('timestamp')<$activity_stat) {
				wc_add_notice( sprintf( __( "活动开始时间未到，不能领取" ), $product->get_title() ), 'error' );
				return;
			}
			if(current_time('timestamp')>$activity_end){
				wc_add_notice( sprintf( __( "抱歉您来晚了活动已结束，下次再来吧" ), $product->get_title() ), 'error' );
				return;
			}
			$is_receive=$this->pb_select_quan($product_id);
			// print_r($is_receive);
			// die;
			if($is_receive==1)
			{
				wc_add_notice( sprintf( __( "亲，不要太贪心哦！本次活动每人只限参加一次" ), $product->get_title() ), 'error' );
				return;
			}
		}


		// if()
		// {
		// 	print_r('expression');
		// 	die;
		// }
	}
	//查询用户是否领用过券
	function pb_select_quan($product_id)
	{
		global $current_user;
		$customer_orders = get_posts( apply_filters( 'woocommerce_my_account_my_orders_query', array(
			'numberposts' => $order_count,
			'meta_key'    => '_customer_user',
			'meta_value'  => get_current_user_id(),
			'post_type'   => 'shop_order',
			'post_status' => 'publish'
		) ) );
		$is_receive=0;
		foreach ( $customer_orders as $customer_order ) {
			$order = new WC_Order();
			$order->populate( $customer_order );
			// print_r($order->get_items());
			foreach ($order->get_items() as $item) {
				// print_r($item['product_id']);
				if($item['product_id']==$product_id){
					$is_receive=1;
					break;
				}
			}
			// echo "<br/>";
		}
		return $is_receive;
	}
	//商户登入
	function store_login(){
		$sname=$_POST['store_name'];
		$spwd=$_POST['pwd'];
		$uuid=$_POST['uuid'];
		$store_id=$this->pb_store_id($sname,$spwd,$uuid);
		if($store_id)
		{
			echo json_encode(array('status'=>'1000','store_id'=>$store_id));
		}
		else{
			echo json_encode(array('status'=>'1001'));
		}
		exit();
	}
	//获取商户id
	function pb_store_id($name,$pwd,$uuid){
		$mypost = array( 'post_type' => 'storename','posts_per_page'=>-1 );
		$loop = new WP_Query( $mypost );
		$store_id;
		while ( $loop->have_posts() ){
			$loop->the_post();
			$store_post_id=get_the_ID();
			$sname=get_post_meta($store_post_id,'stoe_name');
			$spwd=get_post_meta($store_post_id,'store_pwd');
			$sname=$sname[0];
			$spwd=$spwd[0];
			if($sname==$name && $spwd==$pwd)
			{
				$store_id=get_post_meta($store_post_id,'store_id');
				$store_id=$store_id[0];
				$equipment_id=get_post_meta($store_post_id,'equipment_id');
				$equipment_id=$equipment_id[0];
				$equipment_id=explode("|",$equipment_id);
				$isin=0;
				$key=0;
				foreach ($equipment_id as $value) {
					if($value==$uuid){
						$isin=1;
					}
					$key++;
				}
				if($isin==0){
					$equipment_id[$key]=$uuid;
					$equipment_id=implode("|",$equipment_id);
					update_post_meta($store_post_id,'equipment_id',$equipment_id);
				}
				break;
			}
		}
		return $store_id;
	}
	//验证优惠券是否在此商家下可用
	function pb_verification_stoe($product_id,$store_id){
		global $wpdb;
		$store=$wpdb->get_col("SELECT wp_posts.ID FROM `wp_posts` 
			left join wp_term_relationships on wp_posts.id=wp_term_relationships.object_id 
			left join wp_terms on wp_terms.term_id=wp_term_relationships.term_taxonomy_id 
			where wp_terms.term_id={$store_id}");
		// print_r($store);
		$is_use=0;
		foreach ($store as $value) {
			if($value==$product_id){
				$is_use=1;
			}
		}
		return $is_use;
	}

	//验证微信优惠券
	function wechat_verification($order_id,$status,$price,$time,$name,$qty){
		global $wpdb;
		$status='可用';
		if($status->name=='paid'){
			echo json_encode(array('code'=>'1000','order_id'=>$order_id,'status'=>$status,'price'=>$price,'time'=>$time,'name'=>$name,'qty'=>$qty));
		}
		die;
	}
	function update_wechat($order){
		$order_id=$order->id;
		$wechat_orderId=get_post_meta($order_id,'wechat_order_id',ture);
		$url = "http://paytest.biwifi.cn/bankchat/useTicket";
		$post_data = "orderId=".$wechat_orderId;//array('orderId'=>'1432205641861');http://paytest.biwifi.cn/bankchat/useTicket?orderId=
		$rel=send_orderId($url,$post_data);
		if($rel=='success'){
			$time=current_time('timestamp');
			$order->update_status('completed', '已完成');
			$wpdb->query("update wp_gcommerce_yhq set is_used = 1,use_time={$time} where order_id ={$order_id}");
			echo json_encode(array('code'=>'1000','msg'=>'验证成功'));
		}
		else{
			echo json_encode(array('code'=>'1002','msg'=>'验证失败'));
		}
		exit();
	}
}