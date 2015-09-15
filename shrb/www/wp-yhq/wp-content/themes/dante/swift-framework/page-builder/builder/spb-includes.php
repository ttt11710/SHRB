<?php

	/*
	*
	*	Swift Page Builder - Includes Class
	*	------------------------------------------------
	*	Swift Framework
	* 	Copyright Swift Ideas 2014 - http://www.swiftideas.net
	*
	*/
	
	/* DEFINITIONS
	================================================== */ 
	$lib_dir = $spb_settings['SPB_BUILDER_LIB'];
	define('SPB_SHORTCODES_DIR', $spb_settings['SPB_BUILDER_SHORTCODES']);
	
	
	/* INCLUDE LIB FILES
	================================================== */ 
	require_once( $lib_dir . 'abstract.php' );
	require_once( $lib_dir . 'helpers.php' );
	require_once( $lib_dir . 'mapper.php' );
	require_once( $lib_dir . 'shortcodes.php' );
	require_once( $lib_dir . 'builder.php' );
	require_once( $lib_dir . 'layouts.php' );	
	require_once( $lib_dir . 'templates.php' );
	
	
	/* INCLUDE SHORTCODE FILES
	================================================== */
	if (!function_exists('spb_register_assets')) {
		function spb_register_assets() {
			require_once( SPB_SHORTCODES_DIR . 'default.php' );
			require_once( SPB_SHORTCODES_DIR . 'column.php' );
			require_once( SPB_SHORTCODES_DIR . 'row.php' );
			require_once( SPB_SHORTCODES_DIR . 'accordion.php' );
			require_once( SPB_SHORTCODES_DIR . 'tabs.php' );
			require_once( SPB_SHORTCODES_DIR . 'tour.php' );
			require_once( SPB_SHORTCODES_DIR . 'impact-text.php' );
			require_once( SPB_SHORTCODES_DIR . 'icon-boxes.php' );
			require_once( SPB_SHORTCODES_DIR . 'media.php' );
			require_once( SPB_SHORTCODES_DIR . 'raw_content.php' );
			require_once( SPB_SHORTCODES_DIR . 'portfolio.php' );
			require_once( SPB_SHORTCODES_DIR . 'blog.php' );
			require_once( SPB_SHORTCODES_DIR . 'products.php' );
			require_once( SPB_SHORTCODES_DIR . 'gallery.php' );	
			require_once( SPB_SHORTCODES_DIR . 'clients.php' );
			require_once( SPB_SHORTCODES_DIR . 'full-width-text.php' );
			require_once( SPB_SHORTCODES_DIR . 'team.php' );
			require_once( SPB_SHORTCODES_DIR . 'jobs.php' );
			require_once( SPB_SHORTCODES_DIR . 'testimonial.php' );
			require_once( SPB_SHORTCODES_DIR . 'testimonial-carousel.php' );
			require_once( SPB_SHORTCODES_DIR . 'testimonial-slider.php' );
			require_once( SPB_SHORTCODES_DIR . 'faqs.php' );
			require_once( SPB_SHORTCODES_DIR . 'revslider.php' );
			require_once( SPB_SHORTCODES_DIR . 'recent-posts.php' );
			require_once( SPB_SHORTCODES_DIR . 'parallax.php' );
			require_once( SPB_SHORTCODES_DIR . 'portfolio-showcase.php' );
			require_once( SPB_SHORTCODES_DIR . 'portfolio-carousel.php' );
			require_once( SPB_SHORTCODES_DIR . 'posts-carousel.php' );
			require_once( SPB_SHORTCODES_DIR . 'team-carousel.php' );
			require_once( SPB_SHORTCODES_DIR . 'jobs-overview.php' );
			require_once( SPB_SHORTCODES_DIR . 'code-snippet.php' );
			require_once( SPB_SHORTCODES_DIR . 'googlechart.php' );
			require_once( SPB_SHORTCODES_DIR . 'sitemap.php' );
			require_once( SPB_SHORTCODES_DIR . 'search.php' );
			require_once( SPB_SHORTCODES_DIR . 'supersearch.php' );
			require_once( SPB_SHORTCODES_DIR . 'latest-tweets.php' );	
			require_once( SPB_SHORTCODES_DIR . 'tweets-slider.php' );	
			require_once( SPB_SHORTCODES_DIR . 'sidebar-widget.php' );
		}
		if (is_admin()) {
		add_action('admin_init', 'spb_register_assets', 2);
		}
		if (!is_admin()) {
		add_action('wp', 'spb_register_assets', 2);
		}
	}		
?>