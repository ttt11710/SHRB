<?php
/**
 * Plugin Name: WooCommerce - Custom Order Statuses
 * Plugin URI: http://www.remicorson.com/woocommerce-custom-order-statuses/
 * Description: Create custom statuses for WooCommerce orders
 * Version: 1.0
 * Author: Remi Corson
 * Author URI: http://remicorson.com
 * Requires at least: 3.0
 * Tested up to: 3.6
 *
 * Text Domain: sosm
 * Domain Path: /languages/
 *
 */
 
/*
|--------------------------------------------------------------------------
| CONSTANTS
|--------------------------------------------------------------------------
*/

if( !defined( 'SOSM_BASE_FILE' ) )		define( 'SOSM_BASE_FILE', __FILE__ );
if( !defined( 'SOSM_BASE_DIR' ) ) 		define( 'SOSM_BASE_DIR', dirname( SOSM_BASE_FILE ) );
if( !defined( 'SOSM_PLUGIN_URL' ) ) 		define( 'SOSM_PLUGIN_URL', plugin_dir_url( __FILE__ ) );
if( !defined( 'SOSM_PLUGIN_VERSION' ) ) 	define( 'SOSM_PLUGIN_VERSION', '1.0' );

/*
|--------------------------------------------------------------------------
| APPLY ACTIONS & FILTERS IS WOOCOMMERCE IS ACTIVE
|--------------------------------------------------------------------------
*/

if ( in_array( 'woocommerce/woocommerce.php', apply_filters( 'active_plugins', get_option( 'active_plugins' ) ) ) ) {
	
	/*
	|--------------------------------------------------------------------------
	| ACTIONS
	|--------------------------------------------------------------------------
	*/
	
	add_action( 'init', 'woo_sosm_textdomain' );
	add_action('admin_menu', 'woo_shop_order_status_menu', 10);
	add_action('parent_file', 'woo_shop_order_status_parent_file');
	
	/*
	|--------------------------------------------------------------------------
	| FILTERS
	|--------------------------------------------------------------------------
	*/
	
	add_filter( 'woocommerce_taxonomy_args_shop_order_status', 'woo_custom_taxonomy_args_shop_order_status' );

} // endif WooCommerce active


/*
|--------------------------------------------------------------------------
| INTERNATIONALIZATION
|--------------------------------------------------------------------------
*/

function woo_sosm_textdomain() {
	load_plugin_textdomain( 'sosm', false, dirname( plugin_basename( __FILE__ ) ) . '/languages/' );
}


/*
|--------------------------------------------------------------------------
| START PLUGIN FUNCTIONS
|--------------------------------------------------------------------------
*/

/*
 * Create Order Statuses menu item
 *
 * Adds a link to the order statuses edition page
 *
 */
function woo_shop_order_status_menu() {
		
	add_submenu_page( 
		'woocommerce', 
		__('Order Statuses', 'sosm'), 
		__('Order Statuses', 'sosm'), 
		'edit_others_posts', 
		'edit-tags.php?taxonomy=shop_order_status'
	);
	
}


/*
 * Highlight order menu status menu item
 *
 * Tweak default parent file to highlight menu item
 *
 */
function woo_shop_order_status_parent_file($parent_file) {
	
	global $current_screen;
	
	$taxonomy = $current_screen->taxonomy;
	
	if ($taxonomy == 'shop_order_status' )
		$parent_file = 'woocommerce';
		
	return $parent_file;
}


/*
 * Customize order status taxonomy arguments
 *
 * Add new arguments attributes to the order status taxonomy
 *
 */
function woo_custom_taxonomy_args_shop_order_status() {

	$admin_only_query_var = is_admin();
	
	$args = array(
	            'hierarchical' 			=> true,
	            'update_count_callback' => '_update_post_term_count',
	            'label' 				=> __( 'Order Statuses', 'sosm'),
	            'labels' => array(
	                    'name' 				=> __( 'Order Statuses', 'sosm'),
	                    'singular_name' 	=> __( 'Order Status', 'sosm'),
						'menu_name'			=> _x( 'Order Statuses', 'Admin menu name', 'sosm' ),
	                    'search_items' 		=> __( 'Search Order Statuses', 'sosm'),
	                    'all_items' 		=> __( 'All Order Statuses', 'sosm'),
	                    'parent_item' 		=> __( 'Parent Order Status', 'sosm'),
	                    'parent_item_colon' => __( 'Parent Order Status:', 'sosm'),
	                    'edit_item' 		=> __( 'Edit Order Status', 'sosm'),
	                    'update_item' 		=> __( 'Update Order Status', 'sosm'),
	                    'add_new_item' 		=> __( 'Add New Order Status', 'sosm'),
	                    'new_item_name' 	=> __( 'New Order Status Name', 'sosm')
	            	),
	            'show_ui' 				=> true,
	            'show_in_nav_menus' 	=> true,
	            'query_var' 			=> $admin_only_query_var,
				'capabilities'			=> array(
					'manage_terms' 		=> 'manage_product_terms',
					'edit_terms' 		=> 'edit_product_terms',
					'delete_terms' 		=> 'delete_product_terms',
					'assign_terms' 		=> 'assign_product_terms',
				),
	            'rewrite' 				=> false,
	            
	        );
	        
	return $args;
	
}


