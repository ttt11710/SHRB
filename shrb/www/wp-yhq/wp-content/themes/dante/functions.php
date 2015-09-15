<?php
	
	/*
	*
	*	Dante Functions
	*	------------------------------------------------
	*	Swift Framework
	* 	Copyright Swift Ideas 2014 - http://www.swiftideas.net
	*
	*	VARIABLE DEFINITIONS
	*	PLUGIN INCLUDES
	*	THEME UPDATER
	*	THEME SUPPORT
	*	THUMBNAIL SIZES
	*	CONTENT WIDTH
	*	LOAD THEME LANGUAGE
	*	sf_custom_content_functions()
	*	sf_include_framework()
	*	sf_enqueue_styles()
	*	sf_enqueue_scripts()
	*	sf_load_custom_scripts()
	*	sf_admin_scripts()
	*	sf_layerslider_overrides()
	*
	*/
	
	
	/* VARIABLE DEFINITIONS
	================================================== */ 
	define('SF_TEMPLATE_PATH', get_template_directory());
	define('SF_INCLUDES_PATH', SF_TEMPLATE_PATH . '/includes');
	define('SF_FRAMEWORK_PATH', SF_TEMPLATE_PATH . '/swift-framework');
	define('SF_WIDGETS_PATH', SF_INCLUDES_PATH . '/widgets');
	define('SF_LOCAL_PATH', get_template_directory_uri());
	
	
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
	
	
	/* PLUGIN INCLUDES
	================================================== */
	$options = get_option('sf_dante_options');
	$disable_loveit = false;
	if (isset($options['disable_loveit']) && $options['disable_loveit'] == 1) {
	$disable_loveit = true;
	}
	require_once(SF_INCLUDES_PATH . '/plugins/aq_resizer.php');
	include_once(SF_INCLUDES_PATH . '/plugin-includes.php');
	
	if (!$disable_loveit) {
	include_once(SF_INCLUDES_PATH . '/plugins/love-it-pro/love-it-pro.php');
	}
	
	require_once(SF_INCLUDES_PATH . '/wp-updates-theme.php');
	new WPUpdatesThemeUpdater_445( 'http://wp-updates.com/api/2/theme', basename(get_template_directory()));
	
	
	/* THEME SETUP
	================================================== */
	if (!function_exists('sf_dante_setup')) {
		function sf_dante_setup() { 	
		
			/* THEME SUPPORT
			================================================== */  			
			add_theme_support( 'structured-post-formats', array('audio', 'gallery', 'image', 'link', 'video') );
			add_theme_support( 'post-formats', array('aside', 'chat', 'quote', 'status') );
			add_theme_support( 'automatic-feed-links' );
			add_theme_support( 'post-thumbnails' );
			add_theme_support( 'woocommerce' );
			
			
			/* THUMBNAIL SIZES
			================================================== */  	
			set_post_thumbnail_size( 220, 150, true);
			add_image_size( 'widget-image', 94, 70, true);
			add_image_size( 'thumb-square', 250, 250, true);
			add_image_size( 'thumb-image', 600, 450, true);
			add_image_size( 'thumb-image-twocol', 900, 675, true);
			add_image_size( 'thumb-image-onecol', 1800, 1200, true);
			add_image_size( 'blog-image', 1280, 9999);
			add_image_size( 'full-width-image-gallery', 1280, 720, true);
			
			
			/* CONTENT WIDTH
			================================================== */
			if ( ! isset( $content_width ) ) $content_width = 1140;
			
			
			/* LOAD THEME LANGUAGE
			================================================== */
			load_theme_textdomain('swiftframework', SF_TEMPLATE_PATH.'/language');
			
		}
		add_action( 'after_setup_theme', 'sf_dante_setup' );
	}
	
	
	/* CONTENT FUNCTIONS
	================================================== */
	if (!function_exists('sf_custom_content')) {
		function sf_custom_content_functions() {
			include_once(SF_INCLUDES_PATH . '/sf-header.php');
			include_once(SF_INCLUDES_PATH . '/sf-blog.php');
			include_once(SF_INCLUDES_PATH . '/sf-portfolio.php');
			include_once(SF_INCLUDES_PATH . '/sf-products.php');
			include_once(SF_INCLUDES_PATH . '/sf-post-formats.php');
		}
		add_action('init', 'sf_custom_content_functions', 0);
	}
	
	
	/* SWIFT FRAMEWORK
	================================================== */ 
	if (!function_exists('sf_include_framework')) {
		function sf_include_framework() {
			require_once(SF_INCLUDES_PATH . '/sf-theme-functions.php');
			require_once(SF_INCLUDES_PATH . '/sf-comments.php');
			require_once(SF_INCLUDES_PATH . '/sf-formatting.php');
			require_once(SF_INCLUDES_PATH . '/sf-media.php');
			require_once(SF_INCLUDES_PATH . '/sf-menus.php');
			require_once(SF_INCLUDES_PATH . '/sf-pagination.php');
			require_once(SF_INCLUDES_PATH . '/sf-sidebars.php');
			require_once(SF_INCLUDES_PATH . '/sf-customizer-options.php');
			include_once(SF_INCLUDES_PATH . '/sf-custom-styles.php');
			include_once(SF_INCLUDES_PATH . '/sf-styleswitcher/sf-styleswitcher.php');
			require_once(SF_FRAMEWORK_PATH . '/swift-framework.php');
		}
		add_action('init', 'sf_include_framework', 0);
	}
	
	
	/* THEME OPTIONS FRAMEWORK
	================================================== */  
	require_once(SF_INCLUDES_PATH . '/sf-colour-scheme.php');
	if (!function_exists('sf_include_theme_options')) {
		function sf_include_theme_options() {
			require_once(SF_INCLUDES_PATH . '/sf-options.php');
		}
		add_action('after_setup_theme', 'sf_include_theme_options', 0);
	}
	
	
	/* LOAD STYLESHEETS
	================================================== */
	if (!function_exists('sf_enqueue_styles')) {
		function sf_enqueue_styles() {  
			
			$options = get_option('sf_dante_options');
			$enable_responsive = $options['enable_responsive'];		
		
		    wp_register_style('bootstrap', SF_LOCAL_PATH . '/css/bootstrap.min.css', array(), NULL, 'all');
		    wp_register_style('fontawesome', SF_LOCAL_PATH .'/css/font-awesome.min.css', array(), NULL, 'all');
		    wp_register_style('ssgizmo', SF_LOCAL_PATH .'/css/ss-gizmo.css', array(), NULL, 'all');
		    wp_register_style('sf-main', get_stylesheet_directory_uri() . '/style.css', array(), NULL, 'all'); 
		    wp_register_style('sf-responsive', SF_LOCAL_PATH . '/css/responsive.css', array(), NULL, 'all');
			
		    wp_enqueue_style('bootstrap');  
		    wp_enqueue_style('ssgizmo');
		    wp_enqueue_style('fontawesome'); 
		    wp_enqueue_style('sf-main');  
		    
		    if ($enable_responsive) {
		    	wp_enqueue_style('sf-responsive');  
		    }
		
		}		
		add_action('wp_enqueue_scripts', 'sf_enqueue_styles', 99);  
	}
	
	
	/* LOAD FRONTEND SCRIPTS
	================================================== */
	if (!function_exists('sf_enqueue_scripts')) {
		function sf_enqueue_scripts() {
			
			$post_type = get_query_var('post_type');
			
		    wp_register_script('sf-bootstrap-js', SF_LOCAL_PATH . '/js/bootstrap.min.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-flexslider', SF_LOCAL_PATH . '/js/jquery.flexslider-min.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-isotope', SF_LOCAL_PATH . '/js/jquery.isotope.min.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-imagesLoaded', SF_LOCAL_PATH . '/js/imagesloaded.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-easing', SF_LOCAL_PATH . '/js/jquery.easing.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-carouFredSel', SF_LOCAL_PATH . '/js/jquery.carouFredSel.min.js', 'jquery', NULL, TRUE); 
			wp_register_script('sf-jquery-ui', SF_LOCAL_PATH . '/js/jquery-ui-1.10.2.custom.min.js', 'jquery', NULL, TRUE);
			wp_register_script('sf-viewjs', SF_LOCAL_PATH . '/js/view.min.js?auto', 'jquery', NULL, TRUE);
		    wp_register_script('sf-fitvids', SF_LOCAL_PATH . '/js/jquery.fitvids.js', 'jquery', NULL , TRUE);
		    wp_register_script('sf-maps', '//maps.google.com/maps/api/js?sensor=false', 'jquery', NULL, TRUE);
		    wp_register_script('sf-elevatezoom', SF_LOCAL_PATH . '/js/jquery.elevateZoom.min.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-infinite-scroll',  SF_LOCAL_PATH . '/js/jquery.infinitescroll.min.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-theme-scripts', SF_LOCAL_PATH . '/js/theme-scripts.js', 'jquery', NULL, TRUE);
		    wp_register_script('sf-functions', SF_LOCAL_PATH . '/js/functions.js', 'jquery', NULL, TRUE);
			
		    wp_enqueue_script('jquery');
			wp_enqueue_script('sf-bootstrap-js');
		    wp_enqueue_script('sf-jquery-ui');
		    wp_enqueue_script('sf-flexslider');
			wp_enqueue_script('sf-easing');
	   	    wp_enqueue_script('sf-carouFredSel');
		    wp_enqueue_script('sf-theme-scripts');
		    
		    if (sf_woocommerce_activated()) {
		    	if (!is_account_page()) {
		    		wp_enqueue_script('sf-viewjs');
		    	}
		    } else {
		   		wp_enqueue_script('sf-viewjs');
		    }
		   	
	   	    if ( !is_singular('tribe_events') && $post_type != 'tribe_events' && !is_post_type_archive('events') && !is_post_type_archive('tribe_events')) {
	   	    	wp_enqueue_script('sf-maps');
	   	    }
	   	    wp_enqueue_script('sf-isotope');
	   	    wp_enqueue_script('sf-imagesLoaded');
	   	    wp_enqueue_script('sf-infinite-scroll');
	   	
	   		$options = get_option('sf_dante_options');
	   		
	   		if (isset($options['enable_product_zoom'])) {	
	   			$enable_product_zoom = $options['enable_product_zoom'];	
	   			if ($enable_product_zoom) {
	   				wp_enqueue_script('sf-elevatezoom');
	   			}
	   		}
		   	
		    if (!is_admin()) {
		    	wp_enqueue_script('sf-functions');
		    }
		    
		   	if (is_singular() && comments_open()) {
		    	wp_enqueue_script('comment-reply');
		    }
		}
		add_action('wp_enqueue_scripts', 'sf_enqueue_scripts');
	}
	
	/* REQUIRED IE8 COMPATIBILITY SCRIPTS
	================================================== */
	if (!function_exists('sf_html5_ie_scripts')) {	
	    function sf_html5_ie_scripts() {
	        $theme_url = get_template_directory_uri();
	        $ie_scripts = '';
	        
	        $ie_scripts .= '<!--[if lt IE 9]>';
	        $ie_scripts .= '<script data-cfasync="false" src="'.$theme_url.'/js/respond.min.js"></script>';
	        $ie_scripts .= '<script data-cfasync="false" src="'.$theme_url.'/js/html5shiv.js"></script>';
	        $ie_scripts .= '<script data-cfasync="false" src="'.$theme_url.'/js/excanvas.compiled.js"></script>';
	        $ie_scripts .= '<![endif]-->';
	        echo $ie_scripts;
	    }
	    add_action('wp_head', 'sf_html5_ie_scripts');
	}
	
	/* LOAD BACKEND SCRIPTS
	================================================== */
	function sf_admin_scripts() {
	    wp_register_script('admin-functions', get_template_directory_uri() . '/js/sf-admin.js', 'jquery', '1.0', TRUE);
		wp_enqueue_script('admin-functions');
	}
	add_action('admin_init', 'sf_admin_scripts');
	
	
	/* LAYERSLIDER OVERRIDES
	================================================== */
	function sf_layerslider_overrides() {
		// Disable auto-updates
		$GLOBALS['lsAutoUpdateBox'] = false;
	}
	add_action('layerslider_ready', 'sf_layerslider_overrides');
	
	
	/* THEME UPDATES
	================================================== */
	function sf_envato_toolkit_admin_init() {
	 	
	    // Include the Toolkit Library
	    include_once( SF_INCLUDES_PATH .'/envato-wordpress-toolkit-library/class-envato-wordpress-theme-upgrader.php' );
	    
	    // Display a notice in the admin to remind the user to enter their credentials
	    function sf_envato_toolkit_credentials_admin_notices() {
	        $message = sprintf( __( "To enable Dante update notifications, please enter your Envato Marketplace credentials in the %s", "swift-framework-admin" ),
	            "<a href='" . admin_url() . "admin.php?page=envato-wordpress-toolkit'>Envato WordPress Toolkit Plugin</a>" );
	        echo "<div id='message' class='updated below-h2'><p>{$message}</p></div>";
	    }
	    
	    // Use credentials used in toolkit plugin so that we don't have to show our own forms anymore
	    $credentials = get_option( 'envato-wordpress-toolkit' );
	    if ( empty( $credentials['user_name'] ) || empty( $credentials['api_key'] ) ) {
	        add_action( 'admin_notices', 'sf_envato_toolkit_credentials_admin_notices' );
	        return;
	    }
	    
	    // Check updates only after a while
	    $lastCheck = get_option( 'toolkit-last-toolkit-check' );
	    if ( false === $lastCheck ) {
	        update_option( 'toolkit-last-toolkit-check', time() );
	        return;
	    }
	     
	    // Check for an update every 3 hours
	    if ( (time() - $lastCheck) < 10800 ) {
	        return;
	    }
	     
	    // Update the time we last checked
	    update_option( 'toolkit-last-toolkit-check', time() );
	    
	    // Check for updates
	    $upgrader = new Envato_WordPress_Theme_Upgrader( $credentials['user_name'], $credentials['api_key'] );
	    $updates = $upgrader->check_for_theme_update();
	    
	    // Add update alert, to update the theme
	    if ( $updates->updated_themes_count ) {
	        add_action( 'admin_notices', 'sf_envato_toolkit_admin_notices' );
	    }
	    
	    // Display a notice in the admin that an update is available	    
	    function sf_envato_toolkit_admin_notices() {
	        $message = sprintf( __( "An update to Dante is available! Head over to %s to update it now.", "swift-framework-admin" ),
	            "<a href='" . admin_url() . "admin.php?page=envato-wordpress-toolkit'>Envato WordPress Toolkit Plugin</a>" );
	        echo "<div id='message' class='updated below-h2'><p>{$message}</p></div>";
	    }

	}
	if (class_exists('Envato_WP_Toolkit')) {
		add_action( 'admin_init', 'sf_envato_toolkit_admin_init' );
	}
?>