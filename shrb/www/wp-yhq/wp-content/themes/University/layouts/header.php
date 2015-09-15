<?php 
	
	/**
	 *
	 * Template header
	 *
	 **/
	
	// create an access to the template main object
	global $gk_tpl;

?>
<?php do_action('gavernwp_doctype'); ?>
<html <?php do_action('gavernwp_html_attributes'); ?>>
<head>
	<title><?php do_action('gavernwp_title'); ?></title>
	<?php do_action('gavernwp_metatags'); ?>
	
	<link rel="profile" href="http://gmpg.org/xfn/11" />
	<link rel="shortcut icon" href="<?php get_stylesheet_directory_uri(); ?>/favicon.ico" />
	<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>" />
	<?php
	wp_enqueue_style('gavern-normalize', gavern_file_uri('css/normalize.css'), false);
	wp_enqueue_style('gavern-font-awesome', '//netdna.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.css', array('gavern-normalize'), '4.2.0' );
	wp_enqueue_style('gavern-template', gavern_file_uri('css/template.css'), array('gavern-font-awesome'));
	wp_enqueue_style('gavern-wp', gavern_file_uri('css/wp.css'), array('gavern-template'));
	wp_enqueue_style('gavern-stuff', gavern_file_uri('css/stuff.css'), array('gavern-wp'));
	wp_enqueue_style('gavern-wpextensions', gavern_file_uri('css/wp.extensions.css'), array('gavern-stuff'));
	wp_enqueue_style('gavern-extensions', gavern_file_uri('css/extensions.css'), array('gavern-wpextensions'));
	?>
	<!--[if IE 9]>
	<link rel="stylesheet" href="<?php echo gavern_file_uri('css/ie9.css'); ?>" />
	<![endif]-->
	<!--[if lt IE 9]>
	<link rel="stylesheet" href="<?php echo gavern_file_uri('css/ie8.css'); ?>" />
	<![endif]-->
	
	<?php if(is_singular() && get_option('thread_comments' )) wp_enqueue_script( 'comment-reply' ); ?>
	
	<?php do_action('gavernwp_ie_scripts'); ?>
	
	<?php gk_head_shortcodes(); ?>
		  
	<?php 
	 gk_load('responsive_css'); 
	 
	 if(get_option($gk_tpl->name . "_overridecss_state", 'Y') == 'Y') {
	   wp_enqueue_style('gavern-override', gavern_file_uri('css/override.css'), array('gavern-style'));
	 }
	?>
	
	<?php
	if(get_option($gk_tpl->name . '_prefixfree_state', 'N') == 'Y') {
	  wp_enqueue_script('gavern-prefixfree', gavern_file_uri('js/prefixfree.js'));
	} 
	?>
	
	<?php gk_head_style_css(); ?>
	<?php gk_head_style_pages(); ?>
	
	<?php gk_thickbox_load(); ?>
	<?php wp_head(); ?>
	
	<?php do_action('gavernwp_fonts'); ?>
	<?php gk_head_config(); ?>
	<?php wp_enqueue_script("jquery"); ?>
	
	<?php
	    wp_enqueue_script('gavern-scripts', gavern_file_uri('js/gk.scripts.js'), array('jquery'), false, true);
	    wp_enqueue_script('gavern-menu', gavern_file_uri('js/gk.menu.js'), array('jquery', 'gavern-scripts'), false, true);
	    wp_enqueue_script('gavern-modernizr', gavern_file_uri('js/modernizr.js'), false, false, true);
	    wp_enqueue_script('gavern-scrollreveal', gavern_file_uri('js/scrollreveal.js'), false, false, true);
	?>
	
	<?php do_action('gavernwp_head'); ?>

	<?php
		if (is_page_template( 'template.contact.php' ) && 
			get_option($gk_tpl->name . '_recaptcha_state', 'N') == 'Y' && 
			get_option($gk_tpl->name . '_recaptcha_public_key', '') != '' &&
			get_option($gk_tpl->name . '_recaptcha_private_key', '') != ''
		) {
			wp_enqueue_script( 'gk-captcha-script', 'https://www.google.com/recaptcha/api.js', array( 'jquery' ), false, false);
		}
	?>
	
	<?php 
		echo stripslashes(
			htmlspecialchars_decode(
				str_replace( '&#039;', "'", get_option($gk_tpl->name . '_head_code', ''))
			)
		); 
	?>
</head>
<body <?php do_action('gavernwp_body_attributes'); ?>>
	<div id="gk-bg">
		<header id="gk-head" <?php if(!is_front_page()) : ?>class="gk-page"<?php endif; ?>>
			<div id="gk-header-nav">
				<div class="gk-page">
					<?php if(get_option($gk_tpl->name . "_branding_logo_type", 'css') != 'none') : ?>
						<a href="<?php echo home_url(); ?>" class="<?php echo get_option($gk_tpl->name . "_branding_logo_type", 'css'); ?>Logo"><?php gk_blog_logo(); ?></a>
					<?php endif; ?>
					
					<i id="aside-menu-toggler" class="fa fa-bars"></i>
					
					<div id ="gk-main-menu">
						<nav class="gk-menu-wrap">
						<?php if(gk_show_menu('mainmenu')) : ?>
							<?php gavern_menu('mainmenu', 'gk-main-menu', array('walker' => new GKMenuWalker())); ?>
						<?php endif; ?>
						</nav>
					</div>

				</div>
			</div>
			
			<?php if(gk_is_active_sidebar('header-bg')) : ?>
			<div id="gk-header-bg">
				<?php gk_dynamic_sidebar('header-bg'); ?>
			</div>
			<?php endif; ?>
			
			<?php if(
				gk_is_active_sidebar('header-left') ||
				gk_is_active_sidebar('header-right')
			) : ?>
			<div id="gk-header-widgets" class="gk-page">
				<?php if(gk_is_active_sidebar('header-left')) : ?>
				<div id="gk-header-left">
					<?php gk_dynamic_sidebar('header-left'); ?>
				</div>
				<?php endif; ?>
				
				<?php if(gk_is_active_sidebar('header-right')) : ?>
				<div id="gk-header-right">
					<?php gk_dynamic_sidebar('header-right'); ?>
				</div>
				<?php endif; ?>
			</div>
			<?php endif; ?>		
		</header>
		
		<?php if(gk_is_active_sidebar('header-bottom')) : ?>
		<div id="gk-header-bottom">
			<div class="gk-page">
				<?php gk_dynamic_sidebar('header-bottom'); ?>
			</div>
		</div>
		<?php endif; ?>