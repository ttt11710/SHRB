<?php

/**
 * gCommerce的用户注册登录体验 
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

/**
 * 实现gCommerce的用户注册登录体验定制
 *
 * 定制WooCommerce模版，使其符合移动电商的缺省用户体验.
 * 手机号码注册，短信验证号码的有效性.
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 * @author     Wang Xiongxiong <wangxx@gchu.cn>
 */
class GCommerce_User {


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
		//注册修改
		$loader->add_filter( 'woocommerce_process_registration_errors', $this, 'generate_dummy_email', 10, 4 );
		//登入修改
		$loader->add_filter( 'woocommerce_process_login_errors', $this, 'g_login', 10, 4 );
		//ajax获取短信验证码
		$loader->add_action( 'wp_ajax_nopriv_getVcode', $this, 'getVcode', 10);
		//忘记密码短信通知
		$loader->add_action('woocommerce_reset_password_notification', $this,'pb_sms_reset_password_notification', 10, 2);
		//导入需要的js
		$loader->add_action( 'wp_enqueue_scripts', $this,'diantian_scripts', 999999 );
		//订单付款完成短信通知
		$loader->add_action( 'woocommerce_order_status_paid', $this,'order_paying_customer',10,1 );
		//订单完成短信通知
		$loader->add_action( 'woocommerce_order_status_completed', $this,'order_paying_completed',10,1 );
		//后台订单管理
		$loader->add_action( 'add_meta_boxes', $this,'pb_order_processing_add' ); 
		//订单状态修改及保存
		$loader->add_action('save_post', $this,'pb_save_meta_box', 10, 2);
		//后台部分的css、js导入
		$loader->add_action( 'admin_enqueue_scripts',$this, 'pb_admin_scripts' );
	}

	function diantian_scripts() {
		//m.popup.js
		wp_enqueue_script( 'validation-script', plugins_url().'/gcommerce/public/js/jquery.validate.min.js', array(), '1.0.0', true );
		wp_enqueue_script( 'monet-script', plugins_url().'/gcommerce/public/js/pb_custom.js', array(), '1.0.0', true );
		// wp_enqueue_script( 'corder-script', plugins_url().'/gcommerce/public/js/pb_create_order.js', array(), '1.0.0', true );
	}

	function g_login($validation_error,$username,$password){
		global $wpdb;
		$_username=$_POST['username'];
		$vcode=$wpdb->get_var("SELECT confirm_code FROM wp_gcommerce_temp_user WHERE user_name={$_username}");
		$password='111111';
		if($_POST['vcode']==$vcode)
		{	
			// $username=$_username.'@dummy.paybay.cn';
			$user_id =  $this->get_user_id($_username);
			// print_r($user_id);
			// die;
			if($user_id==''){
				if($_POST['usercard']=='')
				{
					header("Content-type: text/html; charset=utf-8"); 
					echo "<script>alert('卡号输入错误，请重新获取验证码绑定卡号');history.back();</script>";
					exit;
				}
				$iscard=$this->verify_card($_POST['usercard']);
				if(!$iscard)
				{
					header("Content-type: text/html; charset=utf-8"); 
					echo "<script>alert('卡号输入错误，请重新获取验证码绑定卡号');history.back();</script>";
					exit;
				}
				$username=$_username.'@dummy.paybay.cn';
				$new_customer = wc_create_new_customer( $username, $_username, $password);
				if(isset($_GET['order_id'])){
					update_post_meta($_GET['order_id'],"_customer_user",$new_customer);
				}
				if ( is_wp_error( $new_customer ) )
				{
					wc_add_notice( $new_customer->get_error_message(), 'error' );
					die($new_customer->get_error_message().'______');
					return;
				}
				//创建用户
				wc_set_customer_auth_cookie( $new_customer );
				//加密保存用户卡号
				$this->save_card($_POST['usercard']);
				// Redirect页面重定向
				if ( wp_get_referer() ) {
					$redirect = esc_url( wp_get_referer() );
				} 
				else {
					$redirect = esc_url( get_permalink( wc_get_page_id( 'myaccount' ) ) );
				}
				wp_redirect( apply_filters( 'woocommerce_registration_redirect', $redirect ) );
				exit;
			}
			else{
				if(isset($_GET['order_id'])){
					update_post_meta($_GET['order_id'],"_customer_user",$user_id);
				}
			}
		}
		else{
			header("Content-type: text/html; charset=utf-8"); 
			echo "<script>alert('验证码输入错误');history.back();</script>";
			exit;
		}
		return $validation_error;
	}
	function verify_card($card)
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
	function save_card($card)
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
		if(!($verify_phone>0))
		{
			$wpdb->query("INSERT INTO wp_gcommerce_user_card (user_phone, user_card) VALUES ('{$user_phone}','{$encrypted}')");
		}
		else{
			$wpdb->query("update wp_gcommerce_user_card set user_card ={$encrypted} where user_phone={$user_phone}");
		}
	}
	/**
	 * 用户注册及登录，使用手机号，审核验证码，审核用户输入卡号，不使用邮箱
	 *
	 * @since    1.0.0
	 */
	function generate_dummy_email($validation_error, $_username, $_password, $_email){
		global $wpdb;
		$vcode=$wpdb->get_var("SELECT confirm_code FROM wp_gcommerce_temp_user WHERE user_name={$_username}");
		if($_POST["vcode"]!=$vcode)
		{
			header("Content-type: text/html; charset=utf-8"); 
			echo "<script>alert('验证码输入错误');history.back();</script>";
			exit;
		}
		if (!empty($_username)) {
			$_POST['email'] = $_username . "@dummy.paybay.cn";
		}
		// print_r($_POST);
		// die;
		return $validation_error;
	}

	function getVcode()
	{
		if(!isset($_GET['phone']))
		{
			exit;
		}
		$time1=time();
		$phone=$_GET['phone'];
		global $wpdb;
		$new_key = rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9);
		$content = "您的验证码是：".$new_key."。请不要把验证码泄露给其他人。";
		$shot_message=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_gcommerce_temp_user where user_name={$phone}"));
		$time2=time();
		if($shot_message>0)
		{
			$wpdb->update('wp_gcommerce_temp_user',array('confirm_code'=>$new_key),array('user_name'=>$phone));
		}
		else
		{
			$wpdb->query("INSERT INTO wp_gcommerce_temp_user (user_name, user_pass, user_email,confirm_code,type) VALUES ('{$phone}','111111','111111','{$new_key}','phone user')");
		}
		$time3=time();
		$card_msg=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_gcommerce_user_card where user_phone={$phone}"));
		$time4=time();
		$res = $this->pb_send_sms_gcommerce($phone,$content);
		$time5=time();
		echo json_encode(array('status'=>200,'msg'=>'登入密码已通过短信发送到您的手机，输入验证码进行登入','card'=>$card_msg,'time'=>$time1.'|'.$time2.'|'.$time3.'|'.$time4.'|'.$time5));
		exit;
	}
	function pb_sms_reset_password_notification( $user_login, $key ) {
		global $pb_lostpw_step;
		global $pb_lostpw_user;
		global $wpdb;
		$pb_lostpw_step = "input_verify_code";
		$pb_lostpw_user = $user_login;
		$new_key = rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9);
		//更新验证码
		$wpdb->update('wp_gcommerce_temp_user',array('confirm_code'=>$new_key),array('user_name'=>$user_login));
		$wpdb->update( $wpdb->users, array( 'user_activation_key' => $new_key ), array( 'user_login' => $user_login ) );
		// 内容
		//$content = "您新的密码是：" . $key . "。请不要把密码泄露给其他人。【拍贝】";
		$link = add_query_arg( array( 'key' => $key, 'login' => $user_login ), wc_get_endpoint_url( 'lost-password', '', get_permalink( wc_get_page_id( 'myaccount' ) ) ) ) ;
		$content = "您找回密码的验证码是：". $new_key . "。请不要把验证码泄露给其他人。";
		//$content = "您的验证码是：" . $key . "。请不要把验证码泄露给其他人。";
		// $res = $this->pb_send_sms_gcommerce($user_login,$content);
		wc_add_notice("验证码已通过短信发送到您的手机，输入验证码并修改密码");
	}

	function order_paying_customer( $order_id ) {
		$order = new WC_Order( $order_id );
		$store='鼎天';
		$user=get_post_meta($order_id,'_billing_email',true);
		$user=substr($user,0,11);
		$content='用户：'.$user.'，感谢您在'.$store.'，购物订单号为：'.$order_id.'付款已完成，我们将在24小时内根据您的订单详情配送，请登录：'.home_url().'/myaccount 查询，谢谢光临！';
		// $res = $this->pb_send_sms_gcommerce($user,$content);
		//$order_post = get_post( $order_id );
	}
	function order_paying_completed( $order_id ) {
		$order = new WC_Order( $order_id );
		$user=get_post_meta($order_id,'_shipping_phone',true);
		// $user='13918206287';3
		$content='用户：'.$user.'，您在'.$order_id.'订单消费已完成，谢谢光临！';
		// $res = $this->pb_send_sms_gcommerce($user,$content);
		//$order_post = get_post( $order_id );
	}

	// 拍贝短信网关
	function pb_send_sms_gcommerce($to, $content) {
		// $url = "http://106.ihuyi.cn/webservice/sms.php?method=Submit";
		$url= "http://121.199.16.178/webservice/sms.php?method=Submit";
		$post_data = array('account'=>'cf_pbxx','password'=>'F1nf34ilcmo9','mobile'=>$to,'content'=>$content);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT,100);  
		// post数据
		curl_setopt($ch, CURLOPT_POST, 1);
		// post的变量
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		$output = curl_exec($ch);
		curl_close($ch);
		//打印获得的数据
		return $output;
	}
	function pb_order_processing_add() {
		add_meta_box( 'pb_order_processing', '订单处理',array($this,'pb_order_processing_call') , 'shop_order', 'normal', 'high' );
	}
	function pb_order_processing_call() {
	    global $woocommerce, $theorder, $wpdb, $post;

	    if ( ! is_object( $theorder ) )
	        $theorder = new WC_Order( $post->ID );

	    $order = $theorder;
	    $status     = get_term_by( 'slug', $order->status, 'shop_order_status' );
	    echo '<h3>当前订单状态：'.ucfirst( __( $status->name, 'woocommerce' ) ).'</h3>';
	    if ('paying'==$order->status) {
	        echo '<p>当前订单状态为“待支付”。表示用户未完成支付。但是如果支付宝未将支付结果正确传回，也可能出现已正确支付的订单的状态未能及时更新。</p>';
	        echo '<p>为防万一，请核对支付宝，银联等支付结果。<strong>如果用户确实已正确支付</strong>，请按以下按钮，手工修改状态。</p>';
	        echo '<p class="buttons">';
	        echo '<input type="hidden" name="pb_action" value="_status2paid"/>';
	        echo '<button type="button" class="button pb_status2paid button-primary">修改订单状态为已付款</button>';
	        echo '</p>';
	    } elseif ('pending'==$order->status) {
	        echo '<p>当前订单状态为“等待中”。表示用户未完成支付。但是如果支付宝未将支付结果正确传回，也可能出现已正确支付的订单的状态未能及时更新。</p>';
	        echo '<p>为防万一，请核对支付宝，银联等支付结果。<strong>如果用户确实已正确支付</strong>，请按以下按钮，手工修改状态。</p>';
	        echo '<p class="buttons">';
	        echo '<input type="hidden" name="pb_action" value="_status2paid"/>';
	        echo '<button type="button" class="button pb_status2paid button-primary">修改订单状态为已付款</button>';
	        echo '</p>';
	    } elseif ('paid'==$order->status) {
	        echo '<p>当前订单状态为“已支付”。表示用户已正确完成支付。</p>';
	        echo '<p>请与支付宝，银联的支付结果进行核对。并审核用户订单详情，包括送货地址，电话等。<strong>如果确认无误</strong>，请按以下按钮，确认订单。</p>';
	        echo '<p class="buttons">';
	        echo '<input type="hidden" name="pb_action" value="_status2confirmed" />';
	        echo '<button type="button" class="button pb_status2confirmed button-primary">订单确认</button>';
	        echo '</p>';
	    } elseif ('confirmed'==$order->status) {
	        echo '<p>当前订单状态为“已确认”。表示可以出库送货。</p>';
	        echo '<p>请正确填写运单号，并按以下按钮，修改订单状态。</p>';
	        echo '<label for="pb_shipping_no">圆通快递运单号：</label>';
	        echo '<input type="text" name="pb_shipping_no" />';
	        echo '<input type="hidden" name="pb_action" value="_status2shipping" />';
	        echo '<p class="buttons">';
	        echo '<button type="button" class="button pb_status2shipping button-primary">出库送货</button>';
	        echo '</p>';
	    } elseif ('shipping'==$order->status) {
	        echo '<p>当前订单状态为“已发货”。</p>';
	        echo '<p>如果运单已由用户签收，请按以下按钮，完成订单。</p>';
	        echo '<p class="buttons">';
	        echo '<input type="hidden" name="pb_action" value="_status2completed" />';
	        echo '<button type="button" class="button pb_status2completed button-primary">订单完成</button>';
	        echo '</p>';
	    } elseif ('completed'==$order->status) {
	        echo '<p>本订单已完成。</p>';
	    }
	}
	function pb_save_meta_box($post_id, $post)
	{
	    global $woocommerce, $theorder, $wpdb;
	    if ( ! is_object( $theorder ) )
	    {
	    	$theorder = new WC_Order( $post->ID );
	    }
	    $order = $theorder;
	    $customer_id = $order->customer_user;
	    $customer = get_userdata($customer_id);
	    $customer_name = $customer->user_login;
	   if(defined('DOING_AUTOSAVE') && DOING_AUTOSAVE)
	       return;

	   if('shop_order' == $_POST['post_type'])
	   {
	       if(!current_user_can('edit_page', $post_id))
	           return;
	   }
	   else
	       if(!current_user_can('edit_post', $post_id))
	           return;

	   if($_POST['pb_shipping_no'])
	   {
	       update_post_meta($post_id, 'pb_order_shipping_id', $_POST['pb_shipping_no']);
	   }
	   // }
	   if($_POST['pb_action']) {
	        //error_log('---'.$_POST['pb_action']);
	        if ('_status2confirmed'==$_POST['pb_action']) {
	            $order->add_order_note("您的订单已确认，我们将尽快为您安排出库送货。",1);
	        } elseif ('_status2shipping'==$_POST['pb_action']) {
	            $order->add_order_note('您的订单已发货，由<a href="http://www.sf-express.com/cn/sc/" target="_blank">顺丰</a>负责送货，运单号为：'.$_POST['pb_shipping_no'].'。',1);
	        } elseif ('_status2completed'==$_POST['pb_action']) {
	            $order->add_order_note("您的订单已完成。谢谢惠顾。",1);
	        }
	   }
	   return;
	}
	function pb_admin_scripts() {
	    $screen       = get_current_screen();
	    if ( in_array( $screen->id, array( 'shop_order', 'edit-shop_order' ) ) ) {
	        wp_enqueue_style( 'pb-style', plugins_url().'/gcommerce/public/css/pb-admin.css' );
	        wp_enqueue_script( 'pb-style',plugins_url().'/gcommerce/public/js/pb-admin.js', array(), '1.0.0', true );
	    }
	}
	function get_user_id($user=''){
	    $user = "'".$user."'";	
	    global $wpdb;
	    $user_ids = $wpdb->get_col("SELECT ID FROM $wpdb->users WHERE user_login = $user ORDER BY ID"); 
	    if($user_ids !=''){
	        foreach($user_ids as $user_id){
	            return $user_id;
	        }
	    }
	    else{
	        return '';	
	    }
	}

}