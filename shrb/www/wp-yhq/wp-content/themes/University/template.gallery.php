<?php
/*
Template Name: Gallery Page
*/

global $gk_tpl;

gk_load(
	'header', 
	array(
		'css' => gavern_file_uri('css/templates/gallery.css'),
		'js' => gavern_file_uri('js/templates/gallery.js')
	)
);
gk_load('before');

?>

<section id="gk-mainbody">
	<?php the_post(); ?>
	
	<h1 class="page-title"><?php the_title(); ?></h1>
	
	<article class="gallery-page">
		<section class="intro">
			<?php
				// Load images
				$images = get_children(
					array(
						'numberposts' => -1, // Load all posts
						'orderby' => 'menu_order', // Images will be loaded in the order set in the page media manager
						'order'=> 'ASC', // Use ascending order
						'post_mime_type' => 'image', // Loads only images
						'post_parent' => $post->ID, // Loads only images associated with the specific page
						'post_status' => null, // No status
						'post_type' => 'attachment' // Type of the posts to load - attachments
					)
				);
			?>
			
			<?php if($images): ?>
			<section id="gallery">
				<?php 
					$firstFlag = true;
					$counter = 0;
					foreach($images as $image) : 
				?>
				<figure<?php if($firstFlag) echo ' class="active"'; ?>>
					<img src="<?php echo $image->guid; ?>" alt="<?php echo $image->post_title; ?>" title="<?php echo $image->post_title; ?>" />
					
					<?php if($image->post_content != '') : ?>
					<figcaption>
						<h3><?php echo $image->post_title; // get the attachment title ?></h3>
						<p><?php echo $image->post_content; // get the attachment description ?></p>
					</figcaption>
					<?php endif; ?>
				</figure>
				<?php 
					$firstFlag = false;
					$counter++;
					endforeach;
				?>
				
				<a href="#" class="gallery-btn-prev"><span>&laquo;</span></a>	
				<a href="#" class="gallery-btn-next"><span>&raquo;</span></a>
			</section>
		  	<?php endif; ?>
		</section>
		
		<section class="content">
			<?php the_content(); ?>
		</section>
	</article>
</section>

<?php

gk_load('after');
gk_load('footer');

// EOF