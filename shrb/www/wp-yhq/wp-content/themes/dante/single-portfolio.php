<?php get_header(); ?>
	
<?php
	$options = get_option('sf_dante_options');
	$default_show_page_heading = $options['default_show_page_heading'];
	$default_page_heading_bg_alt = $options['default_page_heading_bg_alt'];
	$enable_portfolio_stickydetails = $options['enable_portfolio_stickydetails'];
	
	$portfolio_data = sf_get_post_meta($post->ID, 'portfolio', true);
	$current_item_id = $post->ID;
	$pb_active = sf_get_post_meta($post->ID, '_spb_js_status', true);
	$show_page_title = sf_get_post_meta($post->ID, 'sf_page_title', true);
	$page_title_style = sf_get_post_meta($post->ID, 'sf_page_title_style', true);
	$page_title = sf_get_post_meta($post->ID, 'sf_page_title_one', true);
	$page_subtitle = sf_get_post_meta($post->ID, 'sf_page_subtitle', true);
	$item_sidebar_content = sf_get_post_meta($post->ID, 'sf_item_sidebar_content', true);
	$page_title_bg = sf_get_post_meta($post->ID, 'sf_page_title_bg', true);
	$fancy_title_image = rwmb_meta('sf_page_title_image', 'type=image&size=full');
	$page_title_text_style = sf_get_post_meta($post->ID, 'sf_page_title_text_style', true);
	$fancy_title_image_url = $share_image_url = "";
	
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
									
	if (!$fancy_title_image) {
		$fancy_title_image = get_post_thumbnail_id();
		$fancy_title_image_url = wp_get_attachment_url( $fancy_title_image, 'full' );
	}
	
	$remove_breadcrumbs = sf_get_post_meta($post->ID, 'sf_no_breadcrumbs', true);
    $portfolio_page = __($options['portfolio_page'], 'swiftframework');
?>

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
	
	<?php
		
		$media_type = $media_image = $media_video = $media_gallery = '';
		 
		$fw_media_display = sf_get_post_meta($post->ID, 'sf_fw_media_display', true);
		$use_thumb_content = sf_get_post_meta($post->ID, 'sf_thumbnail_content_main_detail', true);
		$hide_details = sf_get_post_meta($post->ID, 'sf_hide_details', true);
		$show_social = sf_get_post_meta($post->ID, 'sf_social_sharing', true);
		$item_categories = get_the_term_list($post->ID, 'portfolio-category', '<li>', '</li><li>', '</li>');
		$item_link = sf_get_post_meta($post->ID, 'sf_portfolio_external_link', true);
		
		if ($use_thumb_content) {
		$media_type = sf_get_post_meta($post->ID, 'sf_thumbnail_type', true);
		$media_image = rwmb_meta('sf_thumbnail_image', 'type=image&size=full');
		$media_video = sf_get_post_meta($post->ID, 'sf_thumbnail_video_url', true);
		$media_gallery = rwmb_meta( 'sf_thumbnail_gallery', 'type=image&size=thumb-image-onecol' );
		} else {
		$media_type = sf_get_post_meta($post->ID, 'sf_detail_type', true);
		$media_image = rwmb_meta('sf_detail_image', 'type=image&size=full');
		$media_video = sf_get_post_meta($post->ID, 'sf_detail_video_url', true);
		$media_gallery = rwmb_meta( 'sf_detail_gallery', 'type=image&size=thumb-image-onecol' );
		$media_slider = sf_get_post_meta($post->ID, 'sf_detail_rev_slider_alias', true);
		$media_layerslider = sf_get_post_meta($post->ID, 'sf_detail_layer_slider_alias', true);
		$custom_media = sf_get_post_meta($post->ID, 'sf_custom_media', true);
		}
		
		foreach ($media_image as $detail_image) {
			$media_image_url = $detail_image['url'];
			$share_image_url = $media_image_url;
			break;
		}
										
		if (!$media_image) {
			$media_image = get_post_thumbnail_id();
			$media_image_url = wp_get_attachment_url( $media_image, 'full' );
			$share_image_url = $media_image_url;
		}
												
		// META VARIABLES
		$media_width = 850;
		$video_height = 638;
		if ($fw_media_display) {
		$media_width = 2000;
		$video_height = 800;
		}
		$media_height = NULL;
	?>
	
	<?php if ($fw_media_display == "fw-media" && $media_type != "none") { ?>
	
	<div class="full-width-display-wrap">
	
		<div class="container">
			<div class="portfolio-options-bar row">
				
				<ul class="pagination-wrap bar-styling portfolio-pagination clearfix">
					<li class="prev"><?php next_post_link('%link', '<i class="ss-navigateleft"></i>'); ?></li>
					<?php if ($portfolio_page) { ?>
					<li class="index"><a href="<?php echo get_permalink($portfolio_page); ?>"><i class="ss-layergroup"></i></a></li>
					<?php } ?>
					<li class="next"><?php previous_post_link('%link', '<i class="ss-navigateright"></i>'); ?></li>
				</ul>
				
				<?php if ($show_social) { ?>
				
				<div class="share-links clearfix">
					<ul class="bar-styling">
						<li class="sf-love">
							<div class="comments-likes">
							<?php if (function_exists( 'lip_love_it_link' )) {
								echo lip_love_it_link(get_the_ID(), '<i class="ss-heart"></i>', '<i class="ss-heart"></i>', false);
							} ?>
							</div>
						</li>
					    <li class="facebook"><a href="http://www.facebook.com/sharer.php?u=<?php the_permalink(); ?>" class="product_share_facebook" onclick="javascript:window.open(this.href,
					      '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=220,width=600');return false;"><i class="fa-facebook"></i></a></li>
					    <li class="twitter"><a href="https://twitter.com/share?url=<?php the_permalink(); ?>&text=<?php echo urlencode(get_the_title()); ?>" onclick="javascript:window.open(this.href,
					      '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=260,width=600');return false;" class="product_share_twitter"><i class="fa-twitter"></i></a></li>   
					    <li class="google-plus"><a href="https://plus.google.com/share?url=<?php the_permalink(); ?>" onclick="javascript:window.open(this.href,
					      '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;"><i class="fa-google-plus"></i></a></li>
					    <?php if ($share_image_url != "") { ?>
					    <li class="pinterest"><a href="//pinterest.com/pin/create/button/?url=<?php the_permalink(); ?>&media=<?php echo $share_image_url; ?>&description=<?php echo $page_title; ?>" onclick="javascript:window.open(this.href,
					      '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=320,width=600');return false;" class="product_share_pinterest"><i class="fa-pinterest"></i></a></li>
					    <?php } else { ?>
					    <li class="pinterest"><a href="//pinterest.com/pin/create/button/?url=<?php the_permalink(); ?>&description=<?php echo $page_title; ?>" onclick="javascript:window.open(this.href,
					      '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=320,width=600');return false;" class="product_share_pinterest"><i class="fa-pinterest"></i></a></li>
					    <?php } ?>
					    <li class="mail"><a href="mailto:?subject=<?php echo $page_title; ?>&body=<?php echo strip_tags(get_the_excerpt()); ?> <?php the_permalink(); ?>" class="product_share_email"><i class="ss-mail"></i></a></li>
					</ul>						
				</div>
				
				<?php } ?>
			</div>
		</div>
									
		<figure class="media-wrap fw-media-wrap">
				
		<?php if ($media_type == "video") { ?>
			
			<?php echo sf_video_embed($media_video, $media_width, $video_height); ?>
			
		<?php } else if ($media_type == "slider") { ?>
			
			<div class="flexslider item-slider">
				
				<ul class="slides">
						
				<?php foreach ( $media_gallery as $image ) {
					echo "<li>";
					if (!empty($image['caption'])) {
					echo "<p class='flex-caption'>{$image['caption']}</p>";
					}
					echo "<img src='{$image['url']}' width='{$image['width']}' height='{$image['height']}' alt='{$image['alt']}' />";
					echo "</li>";
				} ?>
															
				</ul>
			
			</div>
			
		<?php } else if ($media_type == "layer-slider") { ?>
			
			<div class="layerslider">
				
				<?php if ($media_slider != "") {
				
						echo do_shortcode('[rev_slider '.$media_slider.']');
					
					} else {
					
						echo do_shortcode('[layerslider id="'.$media_layerslider.'"]');
						
					} ?>
				
			</div>
				
		<?php } else if ($media_type == "custom") {
									
			echo $custom_media;					
			
		} else { ?>
			
			<?php 
				if ($media_type == "image" && $media_image_url == "") {
					$media_image_url = "default";
				}
				$detail_image = sf_aq_resize( $media_image_url, $media_width, $media_height, true, false);
			?>
			
			<?php if ($detail_image) { ?>
				
				<img itemprop="image" src="<?php echo $detail_image[0]; ?>" width="<?php echo $detail_image[1]; ?>" height="<?php echo $detail_image[2]; ?>" />
				
			<?php } ?>
			
		<?php } ?>
		
		</figure>
	
	</div>
		
	<?php } ?>
	
	
	<?php if ($pb_active != "true" || ($pb_active == "true" && ($fw_media_display == "split" || $fw_media_display == "standard"))) { ?>
		<div class="container">
	<?php } ?>
	
	<div class="inner-page-wrap has-no-sidebar portfolio-type-<?php echo $fw_media_display; ?> row clearfix">
			
		<!-- OPEN article -->
		<article <?php post_class('portfolio-article col-sm-12 clearfix'); ?> id="<?php the_ID(); ?>" itemscope itemtype="http://schema.org/CreativeWork">
			
			<div class="entry-title"><?php echo $page_title; ?></div>
			
			<?php if ($fw_media_display == "fw-media") { ?>
							
				<section class="article-body-wrap row">
										
					<?php if (!$hide_details) { ?>
					
						<?php if ($pb_active == "true") { ?>
						<div class="container">
						<?php } ?>
						
						<section class="portfolio-detail-description col-sm-9">
							<div class="body-text clearfix" itemprop="description">
								<?php the_content(); ?>
							</div>
						</section>
					
						<?php if ($enable_portfolio_stickydetails) { ?>
						<div class="portfolio-details-wrap sticky-details col-sm-3">
						<?php } else { ?>
						<div class="portfolio-details-wrap col-sm-3">
						<?php } ?>
							<?php if ($item_sidebar_content != "") { ?>
							<div class="sidebar-content">
								<?php echo do_shortcode($item_sidebar_content); ?>
							</div>
							<?php } ?>
							<div class="date updated">
								<?php echo get_the_date();?>
							</div>
							<?php if ($item_link) { ?>
							<a class="item-link" href="<?php echo $item_link; ?>" target="_blank"><i class="ss-link"></i><?php _e("View Project", "swiftframework"); ?></a>
							<?php } ?>
							<?php if ($item_categories != "") { ?>
							<ul class="portfolio-categories">
								<?php echo $item_categories; ?>
							</ul>
							<?php } ?>
						</div>
						
						<?php if ($pb_active == "true") { ?>
						</div>
						<?php } ?>
					
					<?php } else { ?>
					
						<?php if ($pb_active != "true" || ($pb_active == "true" && $fw_media_display == "split")) { ?>
						<div class="container">
						<?php } ?>
						
						<section class="portfolio-detail-description col-sm-12">
							<div class="body-text clearfix" itemprop="description">
								<?php the_content(); ?>
							</div>
						</section>
						
						<?php if ($pb_active != "true" || ($pb_active == "true" && $fw_media_display == "split")) { ?>
						</div>
						<?php } ?>
					
					<?php } ?>
					
				</section>
						
			<?php } else { ?>
				
				<?php if ($pb_active == "true") { ?>
				<div class="container">
				<?php } ?>
			
				<div class="portfolio-options-bar">
					
					<ul class="pagination-wrap bar-styling portfolio-pagination clearfix">
						<li class="prev"><?php next_post_link('%link', '<i class="ss-navigateleft"></i>'); ?></li>
						<?php if ($portfolio_page) { ?>
						<li class="index"><a href="<?php echo get_permalink($portfolio_page); ?>"><i class="ss-layergroup"></i></a></li>
						<?php } ?>
						<li class="next"><?php previous_post_link('%link', '<i class="ss-navigateright"></i>'); ?></li>
					</ul>
					
					<?php if ($show_social) { ?>
					
					<div class="share-links clearfix">
						<ul class="bar-styling">
							<li class="sf-love">
								<div class="comments-likes">
								<?php if (function_exists( 'lip_love_it_link' )) {
									echo lip_love_it_link(get_the_ID(), '<i class="ss-heart"></i>', '<i class="ss-heart"></i>', false);
								} ?>
								</div>
							</li>
							<li class="facebook"><a href="http://www.facebook.com/sharer.php?u=<?php the_permalink(); ?>" class="product_share_facebook" onclick="javascript:window.open(this.href,
							  '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=400,width=600');return false;"><i class="fa-facebook"></i></a></li>
							<li class="twitter"><a href="https://twitter.com/share?url=<?php the_permalink(); ?>&text=<?php echo urlencode(get_the_title()); ?>" onclick="javascript:window.open(this.href,
							  '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=400,width=600');return false;" class="product_share_twitter"><i class="fa-twitter"></i></a></li>   
							<li class="google-plus"><a href="https://plus.google.com/share?url=<?php the_permalink(); ?>" onclick="javascript:window.open(this.href,
							  '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;"><i class="fa-google-plus"></i></a></li>
							<?php if ($share_image_url != "") { ?>
							<li class="pinterest"><a href="//pinterest.com/pin/create/button/?url=<?php the_permalink(); ?>&media=<?php echo $share_image_url; ?>&description=<?php echo $page_title; ?>" onclick="javascript:window.open(this.href,
							  '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=320,width=600');return false;" class="product_share_pinterest"><i class="fa-pinterest"></i></a></li>
							<?php } else { ?>
							<li class="pinterest"><a href="//pinterest.com/pin/create/button/?url=<?php the_permalink(); ?>&description=<?php echo $page_title; ?>" onclick="javascript:window.open(this.href,
							  '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=320,width=600');return false;" class="product_share_pinterest"><i class="fa-pinterest"></i></a></li>
							<?php } ?>
							<li class="mail"><a href="mailto:?subject=<?php echo $page_title; ?>&body=<?php echo strip_tags(get_the_excerpt()); ?> <?php the_permalink(); ?>" class="product_share_email"><i class="ss-mail"></i></a></li>
						</ul>						
					</div>
					
					<?php } ?>
				</div>
				
				<?php if ($pb_active == "true") { ?>
				</div>
				<?php } ?>
								
				<div class="portfolio-item-content row">
				
					<?php if ($media_type != "none") { ?>
						<?php if ($fw_media_display == "split") { ?>
						<figure class="media-wrap col-sm-9">
						<?php } else { ?>
						<figure class="media-wrap col-sm-12">
						<?php } ?>
								
						<?php if ($media_type == "video") { ?>
							
							<?php echo sf_video_embed($media_video, $media_width, $video_height); ?>
							
						<?php } else if ($media_type == "slider") { ?>
							
							<div class="flexslider item-slider">
								
								<ul class="slides">
										
								<?php foreach ( $media_gallery as $image ) {
							    	echo "<li>";
							    	if (!empty($image['caption'])) {
							    	echo "<p class='flex-caption'>{$image['caption']}</p>";
							    	}
							    	echo "<img src='{$image['url']}' width='{$image['width']}' height='{$image['height']}' alt='{$image['alt']}' />";
							    	echo "</li>";
								} ?>
																			
								</ul>
							
							</div>
							
						<?php } else if ($media_type == "layer-slider") { ?>
							
							<div class="layerslider">
								
								<?php echo do_shortcode('[rev_slider '.$media_slider.']'); ?>
							
							</div>
								
						<?php } else if ($media_type == "custom") {
													
							echo $custom_media;					
							
						} else { ?>
							
							<?php 
								if ($media_type == "image" && $media_image_url == "") {
									$media_image_url = "default";
								}
								
								$detail_image = sf_aq_resize( $media_image_url, $media_width, $media_height, true, false); 
							?>
							
							<?php if ($detail_image) { ?>
								
								<img itemprop="image" src="<?php echo $detail_image[0]; ?>" width="<?php echo $detail_image[1]; ?>" height="<?php echo $detail_image[2]; ?>" />
								
							<?php } ?>
							
						<?php } ?>
					
						</figure>
					
					<?php } ?>
					
					<?php if ($media_type != "none" && $fw_media_display == "split") { ?>
					
					<section class="article-body-wrap col-sm-3">
					
						<section class="portfolio-detail-description">
							<div class="body-text clearfix" itemprop="description">
								<?php the_content(); ?>
								<?php if ($item_link) { ?>
								<a class="item-link" href="<?php echo $item_link; ?>" target="_blank"><i class="ss-link"></i><?php _e("View Project", "swiftframework"); ?></a>
								<?php } ?>
							</div>
						</section>
						
						<?php if (!$hide_details) { ?>
						
						<div class="portfolio-details-wrap">
							<?php if ($item_sidebar_content != "") { ?>
							<div class="sidebar-content">
								<?php echo do_shortcode($item_sidebar_content); ?>
							</div>
							<?php } ?>
							<div class="date updated">
								<?php echo get_the_date();?>
							</div>
							<?php if ($item_categories != "") { ?>
							<ul class="portfolio-categories">
								<?php echo $item_categories; ?>
							</ul>
							<?php } ?>
						</div>
						
						<?php } ?>
						
					</section>
					
					<?php } else if ($fw_media_display == "standard" && $hide_details) { ?>
					
					</div>
					<div class="row">
					<section class="article-body-wrap col-sm-12">
					
						<section class="portfolio-detail-description">
							<div class="body-text clearfix" itemprop="description">
								<?php the_content(); ?>
								<?php if ($item_link) { ?>
								<a class="item-link" href="<?php echo $item_link; ?>" target="_blank"><i class="ss-link"></i><?php _e("View Project", "swiftframework"); ?></a>
								<?php } ?>
							</div>
						</section>
						
					</section>
					
					<?php } else if ($fw_media_display == "standard") { ?>
					
					</div>
					<div class="row">
					<section class="article-body-wrap col-sm-9">
						<section class="portfolio-detail-description">
							<div class="body-text clearfix" itemprop="description">
								<?php the_content(); ?>
							</div>
						</section>
					</section>
					
					<?php if ($enable_portfolio_stickydetails) { ?>
					<div class="portfolio-details-wrap sticky-details col-sm-3">
					<?php } else { ?>
					<div class="portfolio-details-wrap col-sm-3">
					<?php } ?>
					
						<?php if ($item_sidebar_content != "") { ?>
						<div class="sidebar-content">
							<?php echo do_shortcode($item_sidebar_content); ?>
						</div>
						<?php } ?>
						<div class="date updated">
							<?php echo get_the_date();?>
						</div>
						<?php if ($item_link) { ?>
						<a class="item-link" href="<?php echo $item_link; ?>" target="_blank"><i class="ss-link"></i><?php _e("View Project", "swiftframework"); ?></a>
						<?php } ?>
						<?php if ($item_categories != "") { ?>
						<ul class="portfolio-categories">
							<?php echo $item_categories; ?>
						</ul>
						<?php } ?>
					</div>
					
					<?php } else { ?>
					
					<section class="article-body-wrap col-sm-12">
						<section class="portfolio-detail-description">
							<div class="body-text clearfix" itemprop="description">
								<?php the_content(); ?>
								<?php if ($item_link) { ?>
								<a class="item-link" href="<?php echo $item_link; ?>" target="_blank"><i class="ss-link"></i><?php _e("View Project", "swiftframework"); ?></a>
								<?php } ?>
							</div>
						</section>
						
						<?php if (!$hide_details) { ?>
						
						<div class="portfolio-details-wrap">
							<div class="date updated">
								<?php echo get_the_date();?>
							</div>
							<?php if ($item_categories != "") { ?>
							<ul class="portfolio-categories">
								<?php echo $item_categories; ?>
							</ul>
							<?php } ?>
						</div>
						
						<?php } ?>
						
					</section>
					
					<?php } ?>
				
				</div>
			
			<?php } ?>
			
			<?php 
				$related =  sf_portfolio_related_posts( $post->ID );
				if ($related->have_posts()) { 
			?>
			
			<?php if ($pb_active == "true") { ?>
			<div class="container">
			<?php } ?>
			
			<div class="related-projects clearfix">
				
				<h3 class="spb-heading"><span><?php _e("Related Projects", "swiftframework"); ?></span></h3>
				
				<ul class="row">
				<?php while ( $related->have_posts() ): $related->the_post(); ?>
				    	<?php
				    		$item_title = get_the_title();
				    		$thumb_image = "";
				    		$thumb_image = sf_get_post_meta($post->ID, 'sf_thumbnail_image', true);
				    		if ($thumb_image == "") {
				    			$thumb_image = get_post_thumbnail_id($post->ID);
				    		}
				    		$thumb_img_url = wp_get_attachment_url( $thumb_image, 'full' );
				    		if ($thumb_img_url == "") {
				    			$thumb_img_url = "default";
				    		}
				    		$image = sf_aq_resize( $thumb_img_url, 300, 225, true, false);
				    	?>
				    	
				        <li class="col-sm-3">
				        	<figure class="animated-overlay">
				        		<img src="<?php echo $image[0]; ?>" width="<?php echo $image[1]; ?>" height="<?php echo $image[2]; ?>" alt="<?php echo $item_title; ?>" />
				        		<a href="<?php the_permalink(); ?>"></a>
				        		<figcaption>
				        			<div class="thumb-info">						
				        				<h4><?php echo $item_title; ?></h4>
			        					<i class="ss-navigateright"></i>
				        			</div>
				        		</figcaption>
				        	</figure>
				        </li>
				    <?php endwhile; ?>
				</ul>
				
			</div>
			
			<?php if ($pb_active == "true") { ?>
			</div>
			<?php } ?>
			
			<?php } ?>		
					
		<!-- CLOSE article -->
		</article>
	
	</div>
	
	<?php if ($pb_active != "true" || ($pb_active == "true" && ($fw_media_display == "split" || $fw_media_display == "standard"))) { ?>
		</div>
	<?php } ?>
	
<?php endif; ?>

<!--// WordPress Hook //-->
<?php get_footer(); ?>