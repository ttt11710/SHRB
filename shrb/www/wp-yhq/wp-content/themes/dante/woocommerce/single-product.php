<?php	
	/**
	 * The Template for displaying all single products.
	 *
	 * Override this template by copying it to yourtheme/woocommerce/single-product.php
	 *
	 * @author 		WooThemes
	 * @package 	WooCommerce/Templates
	 * @version     2.1.2
	 */	
	 
	$options = get_option('sf_dante_options');
	$default_show_page_heading = $options['default_show_page_heading'];
	$default_page_heading_bg_alt = $options['woo_page_heading_bg_alt'];
	$default_sidebar_config = $options['default_product_sidebar_config'];
	$default_left_sidebar = $options['default_product_left_sidebar'];
	$default_right_sidebar = $options['default_product_right_sidebar'];
	
	$pb_active = sf_get_post_meta($post->ID, '_spb_js_status', true);
	if (!$options['enable_pb_product_pages']) {
	$pb_active = false;
	}
	
	$show_page_title = sf_get_post_meta($post->ID, 'sf_page_title', true);
	$page_title_style = sf_get_post_meta($post->ID, 'sf_page_title_style', true);
	$page_title = sf_get_post_meta($post->ID, 'sf_page_title_one', true);
	$page_subtitle = sf_get_post_meta($post->ID, 'sf_page_subtitle', true);
	$page_title_bg = sf_get_post_meta($post->ID, 'sf_page_title_bg', true);
	$fancy_title_image = rwmb_meta('sf_page_title_image', 'type=image&size=full');
	$page_title_text_style = sf_get_post_meta($post->ID, 'sf_page_title_text_style', true);
	$remove_breadcrumbs = sf_get_post_meta($post->ID, 'sf_no_breadcrumbs', true);
	$fancy_title_image_url = "";
	
	if ($show_page_title == "") {
		$show_page_title = $default_show_page_heading;
	}
	if ($page_title_bg == "") {
		$page_title_bg = $default_page_heading_bg_alt;
	}
	if ($page_title == "") {
		$page_title = get_the_title();
	}
	
	foreach ($fancy_title_image as $detail_image) {
		$fancy_title_image_url = $detail_image['url'];
		break;
	}
	
	$sidebar_config = sf_get_post_meta($post->ID, 'sf_sidebar_config', true);
	$left_sidebar = sf_get_post_meta($post->ID, 'sf_left_sidebar', true);
	$right_sidebar = sf_get_post_meta($post->ID, 'sf_right_sidebar', true);
	
	if ($sidebar_config == "") {
		$sidebar_config = $default_sidebar_config;
	}
	if ($left_sidebar == "") {
		$left_sidebar = $default_left_sidebar;
	}
	if ($right_sidebar == "") {
		$right_sidebar = $default_right_sidebar;
	}
	
	sf_set_sidebar_global($sidebar_config);
		
	$page_wrap_class = '';
	if ($sidebar_config == "left-sidebar") {
	$page_wrap_class = 'has-left-sidebar has-one-sidebar row';
	} else if ($sidebar_config == "right-sidebar") {
	$page_wrap_class = 'has-right-sidebar has-one-sidebar row';
	} else if ($sidebar_config == "both-sidebars") {
	$page_wrap_class = 'has-both-sidebars';
	} else {
	$page_wrap_class = 'has-no-sidebar';
	}
	
	global $sf_has_products, $sf_include_isotope;
	$sf_has_products = true;
	$sf_include_isotope = true;
?>

<?php get_header('shop'); ?>

<?php if (have_posts()) : the_post(); ?>

<?php if ($show_page_title) { ?>	
<div class="container">
	<div class="row">
		<?php if ($page_title_style == "fancy") { ?>
		<?php if ($fancy_title_image_url != "") { ?>
		<div class="page-heading fancy-heading col-sm-12 clearfix alt-bg <?php echo $page_title_text_style; ?>-style fancy-image" style="background-image: url(<?php echo $fancy_title_image_url; ?>);">
		<?php } else { ?>
		<div class="page-heading fancy-heading col-sm-12 clearfix alt-bg <?php echo $page_title_bg; ?>">
		<?php } ?>
			<div class="heading-text">
				<h1><?php echo $page_title; ?></h1>
				<?php if ($page_subtitle) { ?>
				<h3><?php echo $page_subtitle; ?></h3>
				<?php } ?>
			</div>
		</div>
		<?php } else { ?>
		<div class="page-heading col-sm-12 clearfix alt-bg <?php echo $page_title_bg; ?>">
			<div class="heading-text">
				<h1><?php echo $page_title; ?></h1>
			</div>
			<?php 
				// BREADCRUMBS
				if (!$remove_breadcrumbs) {
					echo sf_breadcrumbs();
				}
			?>
		</div>
		<?php } ?>
	</div>
</div>
<?php } ?>

<?php if ($sidebar_config != "no-sidebars" || $pb_active != "true") { ?>
<div class="container">
<?php } ?>
	
	<div class="inner-page-wrap <?php echo $page_wrap_class; ?> clearfix">
	
		<!-- OPEN article -->
		<?php if ($sidebar_config == "left-sidebar") { ?>
		<article class="clearfix col-sm-8">
		<?php } elseif ($sidebar_config == "right-sidebar") { ?>
		<article class="clearfix col-sm-8">
		<?php } else { ?>
		<article class="clearfix row">
		<?php } ?>
		
		<?php if ($sidebar_config == "both-sidebars") { ?>
			<div class="page-content col-sm-6 clearfix">
		<?php } else if ($sidebar_config == "no-sidebars") { ?>
			<div class="page-content col-sm-12 clearfix">
		<?php } else { ?>
			<div class="page-content clearfix">
		<?php } ?>
											
				<section class="article-body-wrap">
					
					<?php woocommerce_get_template_part( 'content', 'single-product' ); ?>
						
				</section>
				
			</div>
			
			<?php if ($sidebar_config == "both-sidebars") { ?>
			<aside class="sidebar left-sidebar col-sm-3">
				<?php dynamic_sidebar($left_sidebar); ?>
			</aside>
			<?php } ?>
		
		<!-- CLOSE article -->
		</article>
	
		<?php if ($sidebar_config == "left-sidebar") { ?>
				
			<aside class="sidebar left-sidebar col-sm-4">
				<?php dynamic_sidebar($left_sidebar); ?>
			</aside>
	
		<?php } else if ($sidebar_config == "right-sidebar") { ?>
			
			<aside class="sidebar right-sidebar col-sm-4">
				<?php dynamic_sidebar($right_sidebar); ?>
			</aside>
			
		<?php } else if ($sidebar_config == "both-sidebars") { ?>
	
			<aside class="sidebar right-sidebar col-sm-3">
				<?php dynamic_sidebar($right_sidebar); ?>
			</aside>
		
		<?php } ?>
				
	</div>

<?php if ($sidebar_config != "no-sidebars" || $pb_active != "true") { ?>
</div>
<?php } ?>

<?php endif; ?>

<?php get_footer('shop'); ?>