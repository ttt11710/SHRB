<?php
/**
 * The Header for our theme.
 *
 * Displays all of the <head> section and everything up till <div id="content">
 *
 * @package biwifi
 */
?><!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
<meta charset="<?php bloginfo( 'charset' ); ?>">
<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<title><?php wp_title( '|', true, 'right' ); ?></title>
<link rel="profile" href="http://gmpg.org/xfn/11">
<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>">
<script type="text/javascript" src="<?php echo get_template_directory_uri().'/js/jquery-1.7.2.min.js'?>"></script>
<script type="text/javascript" src="<?php  echo get_template_directory_uri().'/js/sapb.js'?>"></script> 
<script type="text/javascript" src="<?php  echo get_template_directory_uri().'/js/m.popup.js'?>"></script> 
<link rel="stylesheet" href="<?php  echo get_template_directory_uri().'/sapb.css' ?>"> 
<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
<div id="page" class="hfeed site">
	<header id="masthead" class="site-header head bg1 fc1" role="banner">
		<p id='headimg' ><img src="<?php echo get_template_directory_uri().'/img/arrow_l.png'; ?>" width="9"/></p>
        <p class="ft21">
        	<?php 
        		if (is_product()) {
        			echo '商品详情';
        		} else if (is_cart()) {
        			echo '购物车';
        		} else if (is_checkout()) {
        			echo '结算';
        		} else if (is_account_page()) {
        			echo '我的账户';
        		} else if (is_shop()) {
        			echo '商店';
        		} else {
        			the_title();
        		}
        	?>        	
        </p>
       <p><img id="head-menu-button" src="<?php echo get_template_directory_uri().'/img/user.png'; ?>" width="20" height="20" style="margin-left:-8px;"/></p>
	</header><!-- #masthead -->
	<nav id="site-navigation" class="main-navigation bg7" role="navigation">
		<?php wp_nav_menu( array( 'theme_location' => 'primary' ) ); ?>
	</nav><!-- #site-navigation -->

<!-- 	<a class="skip-link screen-reader-text" href="#content"><?php _e( 'Skip to content', 'biwifi' ); ?></a>
 -->
	<div class="content" class="site-content">
