<?php
	
	/*
	*
	*	Swift Framework Theme Functions
	*	------------------------------------------------
	*	Swift Framework v2.0
	* 	Copyright Swift Ideas 2014 - http://www.swiftideas.net
	*
	*	sf_theme_activation()
	*	sf_bwm_filter()
	*	sf_bwm_filter_script()
	*	sf_filter_wp_title()
	*	sf_maintenance_mode()
	*	sf_custom_login_logo()
	*	sf_breadcrumbs()
	*	sf_language_flags()
	*	sf_hex2rgb()
	*	sf_get_comments_number()
	*	sf_get_menus_list()
	*	sf_get_category_list()
	*	sf_get_category_list_key_array()
	*	sf_get_woo_product_filters_array()
	*	sf_add_nofollow_cat()
	*	sf_remove_head_links()
	*	sf_current_page_url()
	*	sf_woocommerce_activated()
	*	sf_global_include_classes()
	*	sf_countdown_shortcode_locale()
	*	sf_admin_bar_menu()
	*	sf_admin_css()
	*
	*/
	
	/* THEME ACTIVATION
	================================================== */	
	if (!function_exists('sf_theme_activation')) {
		function sf_theme_activation() {
			global $pagenow;
			if ( is_admin() && 'themes.php' == $pagenow && isset( $_GET['activated'] ) ) {
				#set frontpage to display_posts
				update_option('show_on_front', 'posts');
				
				#provide hook so themes can execute theme specific functions on activation
				do_action('sf_theme_activation');
				
				#redirect to options page
				header( 'Location: '.admin_url().'admin.php?page=sf_theme_options&sf_welcome=true' ) ;
			}
		}
		add_action('admin_init', 'sf_theme_activation');
	}
	
	
	/* BETTER WORDPRESS MINIFY FILTER
	================================================== */	
	function sf_bwm_filter($excluded) {
		global $is_IE;
		
		$excluded = array('fontawesome', 'ssgizmo');
		
		if (is_child_theme()) {
		$excluded = array('sf-main', 'fontawesome', 'ssgizmo');
		}
		
		if ($is_IE) {	
		$excluded = array('bootstrap', 'sf-main', 'sf-responsive', 'fontawesome', 'ssgizmo', 'woocommerce_frontend_styles');
		}
				
		return $excluded;
	}
	add_filter('bwp_minify_style_ignore', 'sf_bwm_filter');
	
	function sf_bwm_filter_script($excluded) {
		
		global $is_IE;
		
		$excluded = array();
		
		if ($is_IE) {	
		$excluded = array('jquery', 'sf-bootstrap-js', 'sf-respond', 'sf-html5shiv', 'sf-functions', 'sf-excanvas');
		}
				
		return $excluded;
		
	}
	add_filter('bwp_minify_script_ignore', 'sf_bwm_filter_script');
	
	
	/* BETTER SEO PAGE TITLE
	================================================== */
	if (!function_exists('sf_filter_wp_title')) {
		function sf_filter_wp_title( $title ) {
			global $page, $paged;
		
			if ( is_feed() )
				return $title;
		
			$site_description = get_bloginfo( 'description' );
		
			$filtered_title = $title . get_bloginfo( 'name' );
			$filtered_title .= ( ! empty( $site_description ) && ( is_home() || is_front_page() ) ) ? ' | ' . $site_description: '';
			$filtered_title .= ( 2 <= $paged || 2 <= $page ) ? ' | ' . sprintf( __( 'Page %s', 'swiftframework' ), max( $paged, $page ) ) : '';
		
			return $filtered_title;
		}
		add_filter( 'wp_title', 'sf_filter_wp_title' );
	}
	
	
	/* MAINTENANCE MODE
	================================================== */
	if (!function_exists('sf_maintenance_mode')) {
		function sf_maintenance_mode() {
			$options = get_option('sf_dante_options');
			$custom_logo = $custom_logo_output = $maintenance_mode = "";
			if (isset($options['custom_admin_login_logo'])) {
			$custom_logo = $options['custom_admin_login_logo'];
			}
			if ($custom_logo) {		
			$custom_logo_output = '<img src="'. $custom_logo .'" alt="maintenance" style="margin: 0 auto; display: block;" />';
			} else {
			$custom_logo_output = '<img src="'. get_template_directory_uri() .'/images/custom-login-logo.png" alt="maintenance" style="margin: 0 auto; display: block;" />';
			}
	
			if (isset($options['enable_maintenance'])) {
			$maintenance_mode = $options['enable_maintenance'];
			} else {
			$maintenance_mode = false;
			}
			
			if ($maintenance_mode == 2) {
				
				$holding_page = __($options['maintenance_mode_page'], 'swiftframework');
			    $current_page_URL = sf_current_page_url();
			    $holding_page_URL = get_permalink($holding_page);
			    
			    if ($current_page_URL != $holding_page_URL) {
			    	if ( !current_user_can( 'edit_themes' ) || !is_user_logged_in() ) {
			    	wp_redirect( $holding_page_URL );
			    	exit;
			    	}
			    }
		    
		    } else if ($maintenance_mode == 1) {
		    	if ( !current_user_can( 'edit_themes' ) || !is_user_logged_in() ) {
		    	    wp_die($custom_logo_output . '<p style="text-align:center">'.__('We are currently in maintenance mode, please check back shortly.', 'swiftframework').'</p>', get_bloginfo( 'name' ));
		    	}
		    }
		}
		add_action('get_header', 'sf_maintenance_mode');
	}
	
	
	/* CUSTOM LOGIN LOGO
	================================================== */
	if (!function_exists('sf_custom_login_logo')) {
		function sf_custom_login_logo() {
			$options = get_option('sf_dante_options');
			$custom_logo = "";
			if (isset($options['custom_admin_login_logo'])) {
			$custom_logo = $options['custom_admin_login_logo'];
			}
			if ($custom_logo) {		
			echo '<style type="text/css">
			    .login h1 a { background-image:url('. $custom_logo .') !important; height: 95px!important; width: 100%!important; background-size: auto!important; }
			</style>';
			} else {
			echo '<style type="text/css">
			    .login h1 a { background-image:url('. get_template_directory_uri() .'/images/custom-login-logo.png) !important; height: 95px!important; width: 100%!important; background-size: auto!important; }
			</style>';
			}
		}
		add_action('login_head', 'sf_custom_login_logo');
	}
	
	
	/* BREADCRUMBS
	================================================== */ 
	if (!function_exists('sf_breadcrumbs')) {
		function sf_breadcrumbs() {
			$breadcrumb_output = "";
			
			if ( function_exists('bcn_display') ) {
				$breadcrumb_output .= '<div id="breadcrumbs">'. "\n";
				$breadcrumb_output .= bcn_display(true);
				$breadcrumb_output .= '</div>'. "\n";
			} else if ( function_exists('yoast_breadcrumb') ) {
				$breadcrumb_output .= '<div id="breadcrumbs">'. "\n";
				$breadcrumb_output .= yoast_breadcrumb("","",false);
				$breadcrumb_output .= '</div>'. "\n";
			}
			
			return $breadcrumb_output;
		}
	}
	
	
	/* LANGUAGE FLAGS
	================================================== */
	if (!function_exists('sf_language_flags')){	
	    function sf_language_flags() {
	        $language_output = "";
	        if (function_exists('pll_the_languages')){
	            $languages = pll_the_languages(array('raw'=>1));
	            if(!empty($languages)){
	                foreach($languages as $l){
	                    $language_output .= '<li>';
	                    if($l['flag']){
	                        if(!$l['current_lang']) {
	                        	$language_output .= '<a href="'.$l['url'].'"><img src="'.$l['flag'].'" height="12" alt="'.$l['slug'].'" width="18" /><span class="language name">'.$l['name'].'</span></a>'."\n";
	                        } else {
	                        	$language_output .= '<div class="current-language"><img src="'.$l['flag'].'" height="12" alt="'.$l['slug'].'" width="18" /><span class="language name">'.$l['name'].'</span></div>'."\n";
	                        }
	                    }
	                    $language_output .= '</li>';
	                 }   
	            }
	        } elseif (function_exists('icl_get_languages')) {
	            $languages = icl_get_languages('skip_missing=0&orderby=code');
	            if(!empty($languages)){
	                foreach($languages as $l){
	                    $language_output .= '<li>';
	                    if($l['country_flag_url']){
	                        if(!$l['active']) {
	                        	$language_output .= '<a href="'.$l['url'].'"><img src="'.$l['country_flag_url'].'" height="12" alt="'.$l['language_code'].'" width="18" /><span class="language name">'.$l['translated_name'].'</span></a>'."\n";
	                        } else {
	                        	$language_output .= '<div class="current-language"><img src="'.$l['country_flag_url'].'" height="12" alt="'.$l['language_code'].'" width="18" /><span class="language name">'.$l['translated_name'].'</span></div>'."\n";
	                        }
	                    }
	                    $language_output .= '</li>';
	                }
	            }
	        } else {
	        	$flags_url = get_template_directory_uri() . '/images/flags';
	        	$language_output .= '<li><a href="#">DEMO - EXAMPLE PURPOSES</a></li><li><a href="#"><span class="language name">German</span></a></li><li><div class="current-language"><span class="language name">English</span></div></li><li><a href="#"><span class="language name">Spanish</span></a></li><li><a href="#"><span class="language name">French</span></a></li>'."\n";
	        }
	       return $language_output;
	    }
	}
	
	
	/* HEX TO RGB COLOR
	================================================== */
	function sf_hex2rgb( $colour ) {
        if ( $colour[0] == '#' ) {
                $colour = substr( $colour, 1 );
        }
        if ( strlen( $colour ) == 6 ) {
                list( $r, $g, $b ) = array( $colour[0] . $colour[1], $colour[2] . $colour[3], $colour[4] . $colour[5] );
        } elseif ( strlen( $colour ) == 3 ) {
                list( $r, $g, $b ) = array( $colour[0] . $colour[0], $colour[1] . $colour[1], $colour[2] . $colour[2] );
        } else {
                return false;
        }
        $r = hexdec( $r );
        $g = hexdec( $g );
        $b = hexdec( $b );
        return array( 'red' => $r, 'green' => $g, 'blue' => $b );
	}


	/* GET COMMENTS COUNT TEXT
	================================================== */
	function sf_get_comments_number($post_id) {
		$num_comments = get_comments_number($post_id); // get_comments_number returns only a numeric value
		$comments_text = "";
		
		if ( $num_comments == 0 ) {
			$comments_text = __('0 Comments', 'swiftframework');
		} elseif ( $num_comments > 1 ) {
			$comments_text = $num_comments . __(' Comments', 'swiftframework');
		} else {
			$comments_text = __('1 Comment', 'swiftframework');
		}
		
		return $comments_text;
	}
	
	/* GET USER MENU LIST
	================================================== */
	function sf_get_menu_list() {
		$menu_list = array( '' => '' );
	    $user_menus = get_terms( 'nav_menu', array( 'hide_empty' => false ) ); 
	  
	    foreach( $user_menus as $menu ) {
			$menu_list[$menu->term_id] = $menu->name;
	    }
	    
	    return $menu_list;
	}
	
	/* GET CUSTOM POST TYPE TAXONOMY LIST
	================================================== */
	function sf_get_category_list( $category_name, $filter=0, $category_child = "" ){
		
		if (!$filter) { 
		
			$get_category = get_categories( array( 'taxonomy' => $category_name	));
			$category_list = array( '0' => 'All');
			
			foreach( $get_category as $category ){
				if (isset($category->slug)) {
				$category_list[] = $category->slug;
				}
			}
				
			return $category_list;
			
		} else if ($category_child != "" && $category_child != "All") {
			
			$childcategory = get_term_by('slug', $category_child, $category_name);
			$get_category = get_categories( array( 'taxonomy' => $category_name, 'child_of' => $childcategory->term_id));
			$category_list = array( '0' => 'All');
			
			foreach( $get_category as $category ){
				if (isset($category->cat_name)) {
				$category_list[] = $category->slug;
				}
			}
				
			return $category_list;	
		
		} else {
			
			$get_category = get_categories( array( 'taxonomy' => $category_name));
			$category_list = array( '0' => 'All');
			
			foreach( $get_category as $category ){
				if (isset($category->cat_name)) {
				$category_list[] = $category->cat_name;
				}
			}
				
			return $category_list;	
		
		}
	}
	
	function sf_get_category_list_key_array($category_name) {
			
		$get_category = get_categories( array( 'taxonomy' => $category_name	));
		$category_list = array( 'all' => 'All');
		
		foreach( $get_category as $category ){
			if (isset($category->slug)) {
			$category_list[$category->slug] = $category->cat_name;
			}
		}
			
		return $category_list;
	}
	
	function sf_get_woo_product_filters_array() {
		
		global $woocommerce;
		
		$attribute_array = array();
		
		$transient_name = 'wc_attribute_taxonomies';

		if (sf_woocommerce_activated()) {
		
			if ( false === ( $attribute_taxonomies = get_transient( $transient_name ) ) ) {
				global $wpdb;
				
					$attribute_taxonomies = $wpdb->get_results( "SELECT * FROM " . $wpdb->prefix . "woocommerce_attribute_taxonomies" );
					set_transient( $transient_name, $attribute_taxonomies );
			}
	
			$attribute_taxonomies = apply_filters( 'woocommerce_attribute_taxonomies', $attribute_taxonomies );
			
			$attribute_array['product_cat'] = __('Product Category', 'swiftframework');
			$attribute_array['price'] = __('Price', 'swiftframework');
					
			if ( $attribute_taxonomies ) {
				foreach ( $attribute_taxonomies as $tax ) {
					$attribute_array[$tax->attribute_name] = $tax->attribute_name;
				}
			}
		
		}
		
		return $attribute_array;	
	}
	
	/* CATEGORY REL FIX
	================================================== */
	function sf_add_nofollow_cat( $text) {
	    $text = str_replace('rel="category tag"', "", $text);
	    return $text;
	}
	add_filter( 'the_category', 'sf_add_nofollow_cat' );
	
	
	/* REMOVE CERTAIN HEAD TAGS
	================================================== */
	if (!function_exists('sf_remove_head_links')) {
		function sf_remove_head_links() {
			remove_action('wp_head', 'index_rel_link');
			remove_action('wp_head', 'rsd_link');
			remove_action('wp_head', 'wlwmanifest_link');
		}
		add_action('init', 'sf_remove_head_links');
	}
	
	
	/* GET CURRENT PAGE URL
	================================================== */
	function sf_current_page_url() {
		$pageURL = 'http';
		if( isset($_SERVER["HTTPS"]) ) {
			if ($_SERVER["HTTPS"] == "on") {$pageURL .= "s";}
		}
		$pageURL .= "://";
		if ($_SERVER["SERVER_PORT"] != "80") {
			$pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
		} else {
			$pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
		}
		return $pageURL;
	}
	
	
	/* CHECK WOOCOMMERCE IS ACTIVE
	================================================== */ 
	if ( ! function_exists( 'sf_woocommerce_activated' ) ) {
		function sf_woocommerce_activated() {
			if ( class_exists( 'woocommerce' ) ) {
				return true;
			} else {
				return false;
			}
		}
	}
	
	/* CHECK WPML IS ACTIVE
	================================================== */ 
	if ( ! function_exists( 'sf_wpml_activated' ) ) {
		function sf_wpml_activated() {
			if ( function_exists('icl_object_id') ) {
				return true;
			} else {
				return false;
			}
		}
	}
	
	
	/* DYNAMIC GLOBAL INCLUDE CLASSES
	================================================== */ 
	function sf_global_include_classes() {
	
		// INCLUDED FUNCTIONALITY SETUP
		global $post, $sf_has_portfolio, $sf_has_blog, $sf_has_products, $sf_include_maps, $sf_include_isotope, $sf_include_carousel, $sf_include_parallax, $sf_include_infscroll, $sf_has_progress_bar, $sf_has_chart, $sf_has_countdown, $sf_has_imagebanner, $sf_has_team, $sf_has_portfolio_showcase, $sf_has_gallery;
			
		$sf_inc_class = "";
		
		if ($sf_has_portfolio) {
			$sf_inc_class .= "has-portfolio ";
		}
		if ($sf_has_blog) {
			$sf_inc_class .= "has-blog ";
		}
		if ($sf_has_products) {
			$sf_inc_class .= "has-products ";
		}
		
		$content = $post->post_content;
		
		if (function_exists('has_shortcode')) {
			if (has_shortcode( $content, 'product_category' ) || has_shortcode( $content, 'featured_products' ) || has_shortcode( $content, 'products' )) {
				$sf_inc_class .= "has-products ";
				$sf_include_isotope = true;
			}
		}
		
		if ($sf_include_maps) {
			$sf_inc_class .= "has-map ";
		}
		if ($sf_include_carousel) {
			$sf_inc_class .= "has-carousel ";
		}
		if ($sf_include_parallax) {
			$sf_inc_class .= "has-parallax ";
		}
		if ($sf_has_progress_bar) {
			$sf_inc_class .= "has-progress-bar ";
		}
		if ($sf_has_chart) {
			$sf_inc_class .= "has-chart ";
		}
		if ($sf_has_countdown) {
			$sf_inc_class .= "has-countdown ";
		}
		if ($sf_has_imagebanner) {
			$sf_inc_class .= "has-imagebanner ";
		}
		if ($sf_has_team) {
			$sf_inc_class .= "has-team ";
		}
		if ($sf_has_portfolio_showcase) {
			$sf_inc_class .= "has-portfolio-showcase ";
		}
		if ($sf_has_gallery) {
			$sf_inc_class .= "has-gallery ";
		}
		
		if ($sf_include_infscroll) {
			$sf_inc_class .= "has-infscroll ";
		}
		
		$options = get_option('sf_dante_options');
		
		if (isset($options['enable_product_zoom'])) {	
			$enable_product_zoom = $options['enable_product_zoom'];	
			if ($enable_product_zoom) {
				$sf_inc_class .= "has-productzoom ";
			}
		}
		
		if (isset($options['enable_stickysidebars'])) {
			$enable_stickysidebars = $options['enable_stickysidebars'];
			if ($enable_stickysidebars) {
				$sf_inc_class .= "stickysidebars ";
			} 
		}
		
		if (isset($options['disable_megamenu'])) {
			$disable_megamenu = $options['disable_megamenu'];
			if ($disable_megamenu) {
				$sf_inc_class .= "disable-megamenu ";
			} 
		}
		
		if (isset($options['sticky_header_mobile']) && $options['sticky_header_mobile']) {
			$sf_inc_class .= 'sticky-header-mobile ';
		}
		
		return $sf_inc_class;
	}
	
	
	/* PLUGIN OPTION PARAMS
	================================================== */
	if (!function_exists('sf_option_parameters')) {
		function sf_option_parameters() {
			$options = get_option('sf_dante_options');
			
			$slider_slideshowSpeed = "6000";
			$slider_animationSpeed = "500";
			$slider_autoplay = "0";
			
			if (isset($options['slider_slideshowSpeed']) && $options['slider_slideshowSpeed'] != "0") {
			$slider_slideshowSpeed = $options['slider_slideshowSpeed'];
			}
			if (isset($options['slider_animationSpeed'])  && $options['slider_animationSpeed'] != "0") {
			$slider_animationSpeed = $options['slider_animationSpeed'];
			}
			if (isset($options['slider_autoplay'])) {
			$slider_autoplay = $options['slider_autoplay'];
			}
		?>
			<div id="sf-option-params" data-slider-slidespeed="<?php echo $slider_slideshowSpeed;?>" data-slider-animspeed="<?php echo $slider_animationSpeed;?>" data-slider-autoplay="<?php echo $slider_autoplay;?>"></div>
		
		<?php 
		}
		add_action('wp_footer', 'sf_option_parameters');
	}
	
	
	/* COUNTDOWN SHORTCODE LOCALE
	================================================== */
	if (!function_exists('sf_countdown_shortcode_locale')) {
		function sf_countdown_shortcode_locale() {
			global $sf_has_countdown;
			if ($sf_has_countdown) { ?>
			<div id="countdown-locale" data-label_year="<?php _e('Year', 'swiftframework'); ?>" data-label_years="<?php _e('Years', 'swiftframework'); ?>" data-label_month="<?php _e('Month', 'swiftframework'); ?>" data-label_months="<?php _e('Months', 'swiftframework'); ?>" data-label_weeks="<?php _e('Weeks', 'swiftframework'); ?>" data-label_week="<?php _e('Week', 'swiftframework'); ?>" data-label_days="<?php _e('Days', 'swiftframework'); ?>" data-label_day="<?php _e('Day', 'swiftframework'); ?>" data-label_hours="<?php _e('Hours', 'swiftframework'); ?>" data-label_hour="<?php _e('Hour', 'swiftframework'); ?>" data-label_mins="<?php _e('Mins', 'swiftframework'); ?>" data-label_min="<?php _e('Min', 'swiftframework'); ?>" data-label_secs="<?php _e('Secs', 'swiftframework'); ?>" data-label_sec="<?php _e('Sec', 'swiftframework'); ?>"></div>
			<?php }
		}
		add_action('wp_footer', 'sf_countdown_shortcode_locale');
	}
	
	
	/* CUSTOM ADMIN MENU ITEMS
	================================================== */
	if(!function_exists('sf_admin_bar_menu')) {		
		function sf_admin_bar_menu() {
		
			global $wp_admin_bar;
			
			if ( current_user_can( 'manage_options' ) ) {
			
				$theme_options = array(
					'id' => '1',
					'title' => __('Theme Options', 'swiftframework'),
					'href' => admin_url('/admin.php?page=sf_theme_options'),
					'meta' => array('target' => 'blank')
				);
				
				$wp_admin_bar->add_menu($theme_options);
				
				$theme_customizer = array(
					'id' => '2',
					'title' => __('Color Customizer', 'swiftframework'),
					'href' => admin_url('/customize.php'),
					'meta' => array('target' => 'blank')
				);
				
				$wp_admin_bar->add_menu($theme_customizer);
			
			}
			
		}
		add_action('admin_bar_menu', 'sf_admin_bar_menu', 99);
	}	
	
	
	/* ADMIN CUSTOM POST TYPE ICONS
	================================================== */
	if (!function_exists('sf_admin_css')) {
		function sf_admin_css() {
			
			$options = get_option('sf_dante_options');
			$body_font_size = $options['body_font_size'];
			$body_font_line_height = $options['body_font_line_height'];
			if (isset($options['menu_font_size'])) {
			$menu_font_size = $options['menu_font_size'];
			}
			$h1_font_size = $options['h1_font_size'];
			$h1_font_line_height = $options['h1_font_line_height'];
			$h2_font_size = $options['h2_font_size'];
			$h2_font_line_height = $options['h2_font_line_height'];
			$h3_font_size = $options['h3_font_size'];
			$h3_font_line_height = $options['h3_font_line_height'];
			$h4_font_size = $options['h4_font_size'];
			$h4_font_line_height = $options['h4_font_line_height'];
			$h5_font_size = $options['h5_font_size'];
			$h5_font_line_height = $options['h5_font_line_height'];
			$h6_font_size = $options['h6_font_size'];
			$h6_font_line_height = $options['h6_font_line_height'];
			
		    ?>	    
		    <style type="text/css" media="screen">
		    	
		    	/* REVSLIDER HIDE ACTIVATION */
		    	a[name="activateplugin"] + div, a[name="activateplugin"] + div + div, a[name="activateplugin"] + div + div + div, a[name="activateplugin"] + div + div + div + div {
		    		display: none;
		    	}
		    	
		        #toplevel_page_sf_theme_options .wp-menu-image img {
		        	width: 11px;
		        	margin-top: -2px;
		        	margin-left: 3px;
		        }
		        .toplevel_page_sf_theme_options #adminmenu li#toplevel_page_sf_theme_options.wp-has-current-submenu a.wp-has-current-submenu, .toplevel_page_sf_theme_options #adminmenu #toplevel_page_sf_theme_options .wp-menu-arrow div, .toplevel_page_sf_theme_options #adminmenu #toplevel_page_sf_theme_options .wp-menu-arrow {
		        	background: #222;
		        	border-color: #222;
		        }
		        #wpbody-content {
		        	min-height: 815px;
		        }
		        .wp-list-table th#thumbnail, .wp-list-table td.thumbnail {
		        	width: 80px;
		        }
		        .wp-list-table td.thumbnail img {
		        	max-width: 100%;
		        	height: auto;
		        }
		        .sf-menu-options {
		        	clear: both;
		        	height: auto;
		        	overflow: hidden;
		        }
		        .sf-menu-options h4 {
		        	margin-top: 20px;
		        	margin-bottom: 5px;
		        	border-bottom: 1px solid #e3e3e3;
		        	margin-right: 15px;
		        	padding-bottom: 5px;
		        }
		        .sf-menu-options p label input[type=checkbox] {
		        	margin-left: 10px;
		        }
		        .sf-menu-options p label input[type=text] {
		        	margin-top: 5px;
		        }
		        .sf-menu-options p label textarea {
		        	margin-top: 5px;
		        	width: 100%;
		        }
		        i[class^="fa-"] {
		        	display: inline-block;
		        	font-family: FontAwesome;
		        	font-style: normal;
		        	font-weight: normal;
		        	line-height: 1;
		        	-webkit-font-smoothing: antialiased;
		        	-moz-osx-font-smoothing: grayscale;
		        }
		        
		        /* META BOX TABS */
		        .rwmb-meta-box {
		        	padding: 20px 10px;
		        }
		        .sf-meta-tabs-wrap.all-hidden {
		        	display: none;
		        }
		        #sf-tabbed-meta-boxes {
		        	position: relative;
		        	z-index: 1;
		        }
		        #sf-tabbed-meta-boxes > div > .hndle, #sf-tabbed-meta-boxes > div > .handlediv {
		        	display: none!important;
		        }
		        #sf-tabbed-meta-boxes .inside {
		        	display: block!important;
		        }
		        #sf-tabbed-meta-boxes > div {
		        	border-left: 0;	
		        	border-right: 0;	
		        	border-bottom: 0;	
		        }
		       	/* #sf-tabbed-meta-boxes > div.hide-if-js {
		        	display: none!important;
		        }*/
		        #sf-meta-box-tabs {
		        	margin: 15px 0 0 15px;
		        	position: relative;
		        	z-index: 2;
		        	height: 34px;
		        }
		        #sf-meta-box-tabs li {
		        	float: left;
		        	margin-right: 5px;
		        	margin-bottom: -1px;
		        }
		        #sf-meta-box-tabs li.user-hidden {
		        	display: none!important;
		        }
		        #sf-meta-box-tabs li > a {
		        	display: inline-block;
		        	background: #fff;
		        	padding: 10px;
		        	border: 1px solid #e5e5e5;
		        	-webkit-box-shadow: 0 1px 1px rgba(0,0,0,.04);
		        	box-shadow: 0 1px 1px rgba(0,0,0,.04);
		        	text-decoration: none;
		        }
		        #sf-meta-box-tabs li > a:hover {
		        	color: #222;
		        }
		        #sf-meta-box-tabs li > a.active {
		        	border-bottom-color: #fff;
		        	box-shadow: none;
		        }
		       	
		       	<?php 
		       		echo '#typography-preview p {font-size: '.$body_font_size.'px;line-height: '.$body_font_line_height.'px;}';
		       		echo '#typography-preview h1 {font-size: '.$h1_font_size.'px;line-height: '.$h1_font_line_height.'px;}';
		       		echo '#typography-preview h2 {font-size: '.$h2_font_size.'px;line-height: '.$h2_font_line_height.'px;}';
		       		echo '#typography-preview h3 {font-size: '.$h3_font_size.'px;line-height: '.$h3_font_line_height.'px;}';
		       		echo '#typography-preview h4 {font-size: '.$h4_font_size.'px;line-height: '.$h4_font_line_height.'px;}';
		       		echo '#typography-preview h5 {font-size: '.$h5_font_size.'px;line-height: '.$h5_font_line_height.'px;}';
		       		echo '#typography-preview h6 {font-size: '.$h6_font_size.'px;line-height: '.$h6_font_line_height.'px;}'; 
		       	?>
		        
			</style>
		
		<?php }
		add_action( 'admin_head', 'sf_admin_css' );
	}
?>