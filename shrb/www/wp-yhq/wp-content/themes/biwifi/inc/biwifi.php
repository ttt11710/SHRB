<?php
/**
 * biwifi Function Customizer
 *
 * @package biwifi
 */

/**
 * remove woocommerce css.
 *
 * @param None.
 */
add_filter( 'woocommerce_enqueue_styles', '__return_false' );

// remove sidebar of shop and product page
remove_action( 'woocommerce_sidebar', 'woocommerce_get_sidebar', 10);

// remove woocommerce product sales icon
add_filter('woocommerce_sale_flash', '__return_false');

// remove woocommerce breadcrumb
remove_action( 'woocommerce_before_main_content','woocommerce_breadcrumb', 20, 0);

// remove page title of woocommerce
add_filter('woocommerce_show_page_title', '__return_false');

add_filter( 'woocommerce_product_tabs', 'pb_woo_remove_reviews_tab', 98);
function pb_woo_remove_reviews_tab($tabs) {
	unset($tabs['reviews']);
	// unset($tabs['additional_information']);
	return $tabs;
}

function woocommerce_remove_related_products(){
    remove_action( 'woocommerce_after_single_product_summary', 'woocommerce_output_related_products', 20);
}
add_action('woocommerce_after_single_product_summary', 'woocommerce_remove_related_products');

// redirect after register
add_filter('woocommerce_registration_redirect', 'pb_registration_redirect');

function pb_registration_redirect( $redirect_to ) {
	if ( ! empty( $_POST['redirect'] ) ) {
		$redirect_to = esc_url( $_POST['redirect'] );
	}
	return $redirect_to;
}


//Page Slug Body Class
function add_slug_body_class( $classes ) {
global $post;
if ( isset( $post ) ) {
$classes[] = $post->post_type . '-' . $post->post_name;
}
return $classes;
}
add_filter( 'body_class', 'add_slug_body_class' );


// 用户注册。

function pb_generate_dummy_email($validation_error, $username, $password, $email){

	if (!empty($username)) {
		$_POST['email'] = $username . "@xxx.com";
	}
	
	include 'Snoopy.class.php'; //引用底层类
    $snoopy = new Snoopy();
    $ar =  explode('@',$email);
 //   $username = $ar[0];
    $flag=pb_server();
    $res;
    if($flag)
    {
        $url='http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=add_user&user_mobile='.$username.'&password='.md5($password);
        $snoopy -> fetchtext($url);
        $res =  $snoopy -> results;
    }
    else
    {
        $res='success';
    }
    if($res=='success'){

    }else{
        //调用钩子 不在本地注册
    }
	return $validation_error;
}


/*
add_action( 'woocommerce_before_calculate_totals', 'add_custom_price' );

function add_custom_price( $cart_object ) {
	//$aa = $cart_object->cart_contents
	$current  = wp_get_current_user();
    $mobile = $current->display_name;
	include 'Snoopy.class.php'; //引用底层类
    $snoopy = new Snoopy();
    $url='http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=member_query&user_mobile'.$mobile;
    $snoopy -> fetchtext($url);
	$res =  $snoopy -> results;
	$res = 300;
	$custom_price = 10; // This will be your custome price  
	foreach ( $cart_object->cart_contents as $key => $value ) {
		if ($res>=300){
			//echo '300';
			$p = $value['data']->price;
			$a = $p*0.9;
			$value['data']->price = $a;
			//$value['data']->price = $p*0.9;
		}
	}
	//echo $cart_object->get_total();
	//print_r($cart_object->needs_payment());
}
*/

//查询积分
/*
function check_score($user){
	include 'Snoopy.class.php'; //引用底层类
    $snoopy = new Snoopy();
    $url='http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=member_query&user_mobile'.$user;
    $snoopy -> fetchtext($url);
	$res =  $snoopy -> results;
	//echo '积分结果'.$res;
	return $res;
}
*/

// Independence day 2013 coupon auto add
// Add coupon when user views cart before checkout (shipping calculation page).
add_action('woocommerce_before_cart_table', 'apply_matched_coupons');
//      
add_action('woocommerce_before_checkout_form', 'apply_matched_coupons');

function apply_matched_coupons() {
    global $woocommerce;
    $coupon_code = '九折'; // your coupon code here
    $current  = wp_get_current_user();
    $mobile = $current->display_name;
    include 'Snoopy.class.php'; //引用底层类
    $snoopy = new Snoopy();
    // $url='http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=member_query&user_mobile'.$mobile;
    $url="http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=member_query&user_mobile=".$mobile;
    $snoopy -> fetchtext($url);
    $res =  $snoopy -> results;
//    die($mobile.'___'.$res);
    if ( $woocommerce->cart->has_discount( $coupon_code ) ) return;
    if ( $woocommerce->cart->cart_contents_total >= 0 and $res>=300) {
        $woocommerce->cart->add_discount( $coupon_code );
        $woocommerce->show_messages();
    }

}

add_filter( 'woocommerce_process_registration_errors', 'pb_generate_dummy_email', 10, 4);


// 单品购买页面，调整商品信息的显示顺序
remove_action( 'woocommerce_single_product_summary', 'woocommerce_template_single_excerpt', 20 );

//add_action( 'woocommerce_single_product_summary', 'woocommerce_template_single_excerpt', 80);
add_action( 'woocommerce_single_product_summary', 'biwifi_template_single_special_price', 15 );


add_action('woocommerce_after_single_product_summary','woocommerce_template_single_excerpt',80);


if ( ! function_exists( 'biwifi_template_single_special_price' ) ) {
	/**
	 * Output the product short description (excerpt).
	 *
	 * @access public
	 * @subpackage	Product
	 * @return void
	 */
	function biwifi_template_single_special_price() {
		wc_get_template( 'single-product/biwifi-special-price.php' );
	}
}

/**
 * Process the checkout
 **/
add_action('woocommerce_checkout_process', 'my_custom_checkout_field_process');
 
function my_custom_checkout_field_process() {
    global $woocommerce;
    // 不使用账单地址，只使用送货地址
    $_POST['ship_to_different_address'] = '1';
    // Check if set, if its not set add an error.
    // if (!$_POST['invoice_checkbox'])
    //      $woocommerce->add_error( __('Please agree to my checkbox.') );
}


  // wp_deregister_script('wc-add-to-cart-variation'); 
   
  // wp_dequeue_script('wc-add-to-cart-variation'); 
  
  // wp_register_script( 'wc-add-to-cart-variation', get_template_directory_uri() . '/js/add-to-cart-variation.js', array( 'jquery'), false, true ); 
   
  // wp_enqueue_script('wc-add-to-cart-variation'); 


/***
5月16号   用户登录 hook

***/

add_filter('woocommerce_process_login_errors','woocommerce_process_login_check',10,3);

function woocommerce_process_login_check($validation_error,$username,$password){
    $flag=pb_server();
    if($flag)
    {
        $validurl = 'http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=login_user&user_mobile='.$username.'&password='.md5($password);
        include 'Snoopy.class.php';
        $password = '000000';
         $_POST['password']= '000000';
        $snoopy = new Snoopy();
    //    die($username.'--'.MD5($password));
        $snoopy ->fetchtext($validurl);
        $res = $snoopy->results;
    }
    else
    {
        $res='success';
    }
    if($res =='success')
    {
        $email = $username.'@xxx.com';
        //注册本地用户并登录
        $user_id =  get_user_id($username);
        if($user_id==''){
            $new_customer = wc_create_new_customer( $email, $username, '000000');
            if ( is_wp_error( $new_customer ) )
            {
                wc_add_notice( $new_customer->get_error_message(), 'error' );
                die($new_customer->get_error_message().'______');
                return;
            }
            wc_set_customer_auth_cookie( $new_customer );

            // Redirect
            if ( wp_get_referer() ) {
                $redirect = esc_url( wp_get_referer() );
            } 
            else {
                $redirect = esc_url( get_permalink( wc_get_page_id( 'myaccount' ) ) );
            }
            wp_redirect( apply_filters( 'woocommerce_registration_redirect', $redirect ) );
            exit;
        }
    }
    else
    {
        die($res);
      //  echo '用户登录失败';
    }
    return $validation_error;
}

/***

根据用户名获取用户id

***/
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


/*

add_filter('woocommerce_order_needs_payment','check_orders_status',10,3);

function check_orders_status($needs_payment, $obj, $valid_order_statuses){
	echo '-------------------'.$obj->status;
	$ret = pb_check_order_payment($obj->id);
	echo $ret;		
	return $needs_payment;

}
*/

/*****
5月16号  用户注册hook

****/

/*
add_filter('woocommerce_process_registration_errors','woocommerce_registration_add',10,4);
function woocommerce_registration_add($validation,$username,$password,$email)

    include 'Snoopy.class.php'; //引用底层类
    $snoopy = new Snoopy();
    $ar =  explode('@',$email);
    $username = $ar[0];
    echo $username.'--';
    $url='http://testwww.sanfu.com:8080/sanfuinterface.php?sign=sanfu_sign_rfw32423e&func=add_user&user_mobile='.$username.'&password='.md5($password);
    $snoopy -> fetchtext($url);
    $res =  $snoopy -> results;
    echo '返回结果：' . $res.'---';
    if($res=='success'){
        //注册成功！
    }else{
        //调用钩子 不在本地注册
    }
    return $validation;
}
*/



function  get_page_id($page_name){
        global $wpdb;
        $page_name = $wpdb->get_var("SELECT ID FROM $wpdb->posts WHERE post_name = '".$page_name."' AND post_status = 'publish' AND post_type = 'page'");
        return $page_name;
}
