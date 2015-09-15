<?php
	/**
	 * The Template for displaying product archives, including the main shop page which is a post type archive.
	 *
	 * Override this template by copying it to yourtheme/woocommerce/archive-product.php
	 *
	 * @author 		WooThemes
	 * @package 	WooCommerce/Templates
	 * @version     2.0.0
	 */
	
	if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly
	
	$options = get_option('sf_dante_options');
	
	$default_show_page_heading = $options['default_show_page_heading'];

	$show_page_title = $options['woo_show_page_heading'];
	$page_title_style = $options['woo_page_heading_style'];
	$page_title_bg = $options['woo_page_heading_bg_alt'];
	$fancy_title_image = $options['woo_page_heading_image'];
	$page_title_text_style = $options['woo_page_heading_text_style'];
	
	if ($show_page_title == "") {
		$show_page_title = $default_show_page_heading;
	}
	
	$sidebar_config = $options['woo_sidebar_config'];
	$left_sidebar = $options['woo_left_sidebar'];
	$right_sidebar = $options['woo_right_sidebar'];
	
	if ($sidebar_config == "") {
		$sidebar_config = 'right-sidebar';
	}
	if ($left_sidebar == "") {
		$left_sidebar = 'woocommerce-sidebar';
	}
	if ($right_sidebar == "") {
		$right_sidebar = 'woocommerce-sidebar';
	}
	
	if (isset($_GET['sidebar'])) {
		$sidebar_config = $_GET['sidebar'];
	}
	
	sf_set_sidebar_global($sidebar_config);
	
	global $sf_sidebar_config, $woocommerce_loop;
	
	$columns = 4;
	
	$page_wrap_class = $page_class = $content_class = '';
	$page_wrap_class = "woocommerce-shop-page ";
	if ($sidebar_config == "left-sidebar") {
	$page_wrap_class .= 'has-left-sidebar has-one-sidebar row';
	$page_class = "col-sm-9 col-sm-push-3 clearfix";
	$content_class = "clearfix";
	} else if ($sidebar_config == "right-sidebar") {
	$page_wrap_class .= 'has-right-sidebar has-one-sidebar row';
	$page_class = "col-sm-9 clearfix";
	$content_class = "clearfix";
	} else if ($sidebar_config == "both-sidebars") {
	$page_wrap_class .= 'has-both-sidebars row';
	$page_class = "col-sm-9 clearfix";
	$content_class = "col-sm-8 clearfix";
	} else {
	$page_wrap_class .= 'has-no-sidebar';
	$page_class = "row clearfix";
	$content_class = "col-sm-12 clearfix";
	}
	
	global $sf_include_isotope, $sf_has_products;
	$sf_include_isotope = true;
	$sf_has_products = true;
		
	get_header('shop');	?>

	<?php
		/**
		 * woocommerce_before_main_content hook
		 *
		 * @hooked woocommerce_output_content_wrapper - 10 (outputs opening divs for the content)
		 * @hooked woocommerce_breadcrumb - 20
		 */
		do_action('woocommerce_before_main_content');
	?>

	<?php if ( apply_filters( 'woocommerce_show_page_title', true )  && $show_page_title) : ?>

	<div class="container">	
		<div class="row">
			<?php if ($page_title_style == "fancy") { ?>
				<?php if ($fancy_title_image != "") { ?>
				<div class="page-heading fancy-heading col-sm-12 clearfix alt-bg <?php echo $page_title_text_style; ?>-style fancy-image" style="background-image: url(<?php echo $fancy_title_image; ?>);">
				<?php } else { ?>
				<div class="page-heading fancy-heading col-sm-12 clearfix alt-bg <?php echo $page_title_bg; ?>">
				<?php } ?>
			<?php } else { ?>
				<div class="page-heading col-sm-12 clearfix alt-bg <?php echo $page_title_bg; ?>">
			<?php } ?>
		
				<div class="heading-text">
				
				<?php if ( version_compare( WOOCOMMERCE_VERSION, "2.0.0" ) >= 0 ) { ?>
					<h1><?php woocommerce_page_title(); ?></h1>
				<?php } else {
					echo '<h1>';
					if ( is_search() ) {
						printf( __( 'Search Results: &ldquo;%s&rdquo;', 'woocommerce' ), get_search_query() );
						if ( get_query_var( 'paged' ) ) {
							printf( __( '&nbsp;&ndash; Page %s', 'woocommerce' ), get_query_var( 'paged' ) );
						}
					} elseif ( is_tax() ) {
						echo single_term_title( "", false );
					} else {
						$shop_page = "";
						if ( version_compare( WOOCOMMERCE_VERSION, "2.1.0" ) >= 0 ) {
							$shop_page = get_post( wc_get_page_id( 'shop' ) );
						} else {
							$shop_page = get_post( woocommerce_get_page_id( 'shop' ) );
						}
						
						echo apply_filters( 'the_title', ( $shop_page_title = get_option( 'woocommerce_shop_page_title' ) ) ? $shop_page_title : $shop_page->post_title );
					}
					echo '</h1>';								
				} ?>
				</div>
			<?php if ($page_title_style != "fancy") {
				// BREADCRUMBS
				echo sf_breadcrumbs();
			} ?>
			</div>
		</div>
	</div>
	
	<?php endif; ?>
	
	<div class="container">
	
		<div class="inner-page-wrap <?php echo $page_wrap_class; ?> clearfix">
			
			<!-- OPEN section -->
			<section class="<?php echo $page_class; ?>">
			
				<div class="page-content <?php echo $content_class; ?>">
				
				<?php
					/**
					 * woocommerce_before_shop_loop hook
					 *
					 * @hooked woocommerce_result_count - 20
					 * @hooked woocommerce_catalog_ordering - 30
					 */
					do_action( 'woocommerce_before_shop_loop' );
				?>
				
				<?php do_action( 'woocommerce_archive_description' ); ?>
				
				<?php
					if ($sf_sidebar_config == "no-sidebars") {
						$woocommerce_loop['columns'] = apply_filters( 'loop_shop_columns', 4 );
					} else if ($sf_sidebar_config == "both-sidebars") {
						$woocommerce_loop['columns'] = apply_filters( 'loop_shop_columns', 2 );
						$columns = 2;
					} else {
						$woocommerce_loop['columns'] = apply_filters( 'loop_shop_columns', 3 );
						$columns = 3;
					}	
				?>
					
				<?php if ( have_posts() ) : ?>
					
					<?php if ( version_compare( WOOCOMMERCE_VERSION, "2.1.0" ) >= 0 ) { ?>
						
						<?php woocommerce_product_loop_start(); ?>
			
							<?php woocommerce_product_subcategories(); ?>
			
							<?php while ( have_posts() ) : the_post(); ?>
			
								<?php wc_get_template_part( 'content', 'product' ); ?>
			
							<?php endwhile; // end of the loop. ?>
			
						<?php woocommerce_product_loop_end(); ?>
					
					<?php } else if ( version_compare( WOOCOMMERCE_VERSION, "2.0.0" ) >= 0 ) { ?>
		
						<?php woocommerce_product_loop_start(); ?>
			
							<?php woocommerce_product_subcategories(); ?>
			
							<?php while ( have_posts() ) : the_post(); ?>
			
								<?php woocommerce_get_template_part( 'content', 'product' ); ?>
			
							<?php endwhile; // end of the loop. ?>
			
						<?php woocommerce_product_loop_end(); ?>
					
					<?php } else { ?>
					
						<ul class="products">
					
						<?php woocommerce_product_subcategories(); ?>
						
						<?php while ( have_posts() ) : the_post(); ?>
						
							<?php woocommerce_get_template_part( 'content', 'product' ); ?>
		
						<?php endwhile; // end of the loop. ?>
						
						</ul>
					
					<?php } ?>
		
					<?php
						/**
						 * woocommerce_after_shop_loop hook
						 *
						 * @hooked woocommerce_pagination - 10
						 */
						do_action( 'woocommerce_after_shop_loop' );
					?>
		
				<?php elseif ( ! woocommerce_product_subcategories( array( 'before' => woocommerce_product_loop_start( false ), 'after' => woocommerce_product_loop_end( false ) ) ) ) : ?>
		
					<?php woocommerce_get_template( 'loop/no-products-found.php' ); ?>
		
				<?php endif; ?>
				
				</div>
		
				<?php if ($sidebar_config == "both-sidebars") { ?>
				<aside class="sidebar left-sidebar col-sm-4">
					<?php dynamic_sidebar($left_sidebar); ?>
				</aside>
				<?php } ?>
			
			<!-- CLOSE section -->
			</section>
		
			<?php if ($sidebar_config == "left-sidebar") { ?>
					
			<aside class="sidebar left-sidebar col-sm-3 col-sm-pull-9">
				<?php dynamic_sidebar($left_sidebar); ?>
			</aside>
		
			<?php } else if ($sidebar_config == "right-sidebar") { ?>
				
			<aside class="sidebar right-sidebar col-sm-3">
				<?php dynamic_sidebar($right_sidebar); ?>
			</aside>
			
			<?php } else if ($sidebar_config == "both-sidebars") { ?>
		
			<aside class="sidebar right-sidebar col-sm-3">
				<?php dynamic_sidebar($right_sidebar); ?>
			</aside>
			
			<?php } ?>
				
		</div>

	</div>
	
	<?php
		/**
		 * woocommerce_after_main_content hook
		 *
		 * @hooked woocommerce_output_content_wrapper_end - 10 (outputs closing divs for the content)
		 */
		do_action( 'woocommerce_after_main_content' );
	?>
	
<?php get_footer('shop'); ?>