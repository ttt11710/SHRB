<?php
/**
 * biwifi functions and definitions
 *
 * @package biwifi
 */

/**
 * Set the content width based on the theme's design and stylesheet.
 */
if ( ! isset( $content_width ) ) {
	$content_width = 640; /* pixels */
}

if ( ! function_exists( 'biwifi_setup' ) ) :
/**
 * Sets up theme defaults and registers support for various WordPress features.
 *
 * Note that this function is hooked into the after_setup_theme hook, which
 * runs before the init hook. The init hook is too late for some features, such
 * as indicating support for post thumbnails.
 */
function biwifi_setup() {

	/*
	 * Make theme available for translation.
	 * Translations can be filed in the /languages/ directory.
	 * If you're building a theme based on biwifi, use a find and replace
	 * to change 'biwifi' to the name of your theme in all the template files
	 */
	load_theme_textdomain( 'biwifi', get_template_directory() . '/languages' );

	// Add default posts and comments RSS feed links to head.
	add_theme_support( 'automatic-feed-links' );

	/*
	 * Enable support for Post Thumbnails on posts and pages.
	 *
	 * @link http://codex.wordpress.org/Function_Reference/add_theme_support#Post_Thumbnails
	 */
	//add_theme_support( 'post-thumbnails' );

	// This theme uses wp_nav_menu() in one location.
	register_nav_menus( array(
		'primary' => __( 'Primary Menu', 'biwifi' ),
	) );

	// Enable support for Post Formats.
	add_theme_support( 'post-formats', array( 'aside', 'image', 'video', 'quote', 'link' ) );

	// Setup the WordPress core custom background feature.
	add_theme_support( 'custom-background', apply_filters( 'biwifi_custom_background_args', array(
		'default-color' => 'ffffff',
		'default-image' => '',
	) ) );

	// Enable support for HTML5 markup.
	add_theme_support( 'html5', array(
		'comment-list',
		'search-form',
		'comment-form',
		'gallery',
		'caption',
	) );
}
endif; // biwifi_setup
add_action( 'after_setup_theme', 'biwifi_setup' );

/**
 * Register widget area.
 *
 * @link http://codex.wordpress.org/Function_Reference/register_sidebar
 */
function biwifi_widgets_init() {
	register_sidebar( array(
		'name'          => __( 'Sidebar', 'biwifi' ),
		'id'            => 'sidebar-1',
		'description'   => '',
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget'  => '</aside>',
		'before_title'  => '<h1 class="widget-title">',
		'after_title'   => '</h1>',
	) );
}
add_action( 'widgets_init', 'biwifi_widgets_init' );

/**
 * Enqueue scripts and styles.
 */
function biwifi_scripts() {
	wp_enqueue_style( 'biwifi-pure', get_template_directory_uri() . '/css/pure-min.css');
	wp_enqueue_style( 'biwifi-color', get_template_directory_uri() . '/css/color.css');
	wp_enqueue_style( 'biwifi-sanfu', get_template_directory_uri() . '/css/sanfu.css');
	wp_enqueue_style( 'biwifi-mpopup', get_template_directory_uri() . '/css/m.popup.css');

	wp_enqueue_style( 'biwifi-style', get_stylesheet_uri() );

	//wp_enqueue_script( 'biwifi-zepto', get_template_directory_uri() . '/js/zepto.min.js', array(), '20140520', true );
	//wp_enqueue_script( 'biwifi-mpopup-js', get_template_directory_uri() . '/js/m.popup.js', array(), '20140612', true );

	wp_enqueue_script( 'biwifi-iscroll', get_template_directory_uri() . '/js/iscroll.js', array(), '20140520', true );

	wp_enqueue_script( 'biwifi-navigation', get_template_directory_uri() . '/js/navigation.js', array(), '20120206', true );

	wp_enqueue_script( 'biwifi-skip-link-focus-fix', get_template_directory_uri() . '/js/skip-link-focus-fix.js', array(), '20130115', true );

	wp_enqueue_script( 'biwifi-sanfu-js', get_template_directory_uri() . '/js/sanfu.js', array(), '20140520', true );

	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) ) {
		wp_enqueue_script( 'comment-reply' );
	}
	if (is_product()) {
		wp_enqueue_script( 'biwifi-sanfu-product-js', get_template_directory_uri() . '/js/sanfu-product.js', array(), '20140520', true );
	}
}
add_action( 'wp_enqueue_scripts', 'biwifi_scripts' );

/**
 * Implement the Custom Header feature.
 */
//require get_template_directory() . '/inc/custom-header.php';

/**
 * Custom template tags for this theme.
 */
require get_template_directory() . '/inc/template-tags.php';

/**
 * Custom functions that act independently of the theme templates.
 */
require get_template_directory() . '/inc/extras.php';

/**
 * Customizer additions.
 */
require get_template_directory() . '/inc/customizer.php';

/**
 * Load Jetpack compatibility file.
 */
require get_template_directory() . '/inc/jetpack.php';

/**
 * biwifi customize.
 */
require get_template_directory() . '/inc/biwifi.php';

