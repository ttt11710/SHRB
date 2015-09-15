<?php 
/**
 * GanChu Theme Functions
 * Load languages directory for translation
*/ 
// 子主题的路径
define('CURRENT_TEMPLATE_DIR', dirname( get_bloginfo('stylesheet_url')) );

// 定制 footer
add_action( 'tha_footer_top', 'gchu_customize_footer', 10 );
function gchu_customize_footer() {
	// Change Credit link to copyright link
	remove_action( 'highwind_footer', 'highwind_credit', 20 );
	// add_action( 'highwind_footer', 'gchu_credit', 20 );
}
function gchu_credit() {
    ?>
	<p>© 2014 感触科技 沪ICP备13026829号</p>
	<?php
}


// 定制 header logo
// 参考 https://github.com/jameskoster/highwind/wiki/Snippets
// 隐藏 avatar 显示
add_filter( 'highwind_header_gravatar', '__return_false' );

// 指定具体的logo图像文件，取代gavatar
add_action( 'highwind_site_title_link', 'gchu_custom_header_image' );
function gchu_custom_header_image() {
    ?>
	<img src="<?php echo CURRENT_TEMPLATE_DIR . '/images/logo.png'; ?>" class="avatar" />
	<?php
}
// add_action( 'woocommerce_before_checkout_form', 'theme_wc_redirect_guest_user' );
// function theme_wc_redirect_guest_user(){
// 	if( !is_user_logged_in() ) {
// 		$checkout_url = get_permalink( woocommerce_get_page_id('checkout') );
// 		$args['redirect_to'] = urlencode( $checkout_url );
// 		$login_url = add_query_arg( $args, get_permalink( woocommerce_get_page_id('myaccount') ) );
// 		wp_safe_redirect($login_url);
// 	}
// }

add_filter ( 'woocommerce_registration_redirect', 'theme_wc_registration_redirect' );
function theme_wc_registration_redirect( $redirect ) {
	// print_r($_POST);
	// die;
    if ( $_POST['redirect'] ) {
        $redirect = $_POST['redirect'];
    }
    return $redirect;
}


add_shortcode('mycode', 'my_shortcode_func');
function my_shortcode_func()
{
	print_r('expresaasdsion');
}


function gad_shortcode($atts) {
	// extract(shortcode_atts(array(
	// 	'product_id' => 'no foo',  
	// 	'value' => 'default bar'
	// ), $atts));
	// print_r($atts['product_id']);
	$product_array=explode(',',$atts['product_id']);
	// print_r($product_array);
	foreach ($product_array as $value) {
		$url=home_url().'?p='.$value;
		echo "<a href=".$url.">".$value."</a>";
		echo '<br/>';
	}

	// echo ;
}
add_shortcode('adsense', 'gad_shortcode');


// add_action( 'init', 'select_all_product', 10 );
function select_all_product(){
	global $wpdb;
	$store=$wpdb->get_results("SELECT ID,post_title FROM `wp_posts` where post_type='product' and post_status='publish';",ARRAY_A);
	// print_r($store);

	$kitty=array();
	$cofcoo=array();
	$cofcoo_milk=array();
	foreach ($store as $key => $p_obj) {
		$cart_array=array();
		$cat=get_the_terms( $p_obj['ID'], 'product_cat' );
		foreach ($cat as $value) {
			$cart_array[]=$value->name;
		}
		// print_r($cart_array);print_r($p_obj['ID']);
		// echo '</br>';
		foreach ($cart_array as $key1 => $cart) {
			if($cart=='中粮油'){
				$cofcoo[]=$p_obj['ID'];
			}
			if($cart=='hello_kitty'){
				$kitty[]= $p_obj['ID'];
			}
			if($cart=='牛奶'){
				$cofcoo_milk[]=$p_obj['ID'];
			}
		}
	}
	$prodcut_info['kitty']=$kitty;
	$prodcut_info['cofcoo']=$cofcoo;
	$prodcut_info['cofcoo_milk']=$cofcoo_milk;
	return $prodcut_info;
}
