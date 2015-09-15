<?php

/**
 *
 * The default template for displaying staff content
 *
 **/

global $gk_tpl; 

?>

<?php if(is_single()) : ?>
<article id="post-<?php the_ID(); ?>" <?php post_class('gk-staff-single'); ?>>
	<header>
		<?php if(get_the_title() != '') : ?>
		<h2>
			<a href="<?php the_permalink(); ?>" title="<?php printf( esc_attr__( 'Permalink to %s', GKTPLNAME ), the_title_attribute( 'echo=0' ) ); ?>" rel="bookmark"><?php the_title(); ?>
			</a>
			
			<?php if(is_sticky()) : ?>
			<sup>
				<?php _e( 'Featured', GKTPLNAME ); ?>
			</sup>
			<?php endif; ?>
		</h2>
		<?php endif; ?>
		<ul>
			<li class="category">
				<?php _e('Published in', GKTPLNAME); ?>
				<?php echo get_the_category_list( __(', ', GKTPLNAME )); ?>
			</li>
		</ul>
	</header>

	<div class="gk-image-block">
		<?php if(has_post_thumbnail()) : ?>
		<figure class="featured-image">
			<?php the_post_thumbnail('medium'); ?>
		</figure>
		<?php endif; ?>
	</div>
	<div class="gk-extra-fields">
		<?php gk_post_fields(); ?>
	</div>

	<section class="content">
		<?php the_content( __( 'Read more...', GKTPLNAME ) ); ?>
		<?php gk_post_links(); ?>
	</section>

	<?php 
		// variable for the social API HTML output
		$social_api_output = gk_social_api(get_the_title(), get_the_ID()); 
	?>
	
	<?php if($social_api_output != '' ): ?>
		<footer>
			<?php echo $social_api_output; ?>
		</footer>
	<?php endif; ?>
	
</article>
<?php else : ?>
<article id="post-<?php the_ID(); ?>" <?php post_class('gk-staff-cat'); ?>>
	
	<?php if(has_post_thumbnail()) : ?>
	<figure class="featured-image">
		<a href="<?php the_permalink(); ?>">
			<?php the_post_thumbnail('medium'); ?>
		</a>
	</figure>
	<?php endif; ?>

	<header>
		<?php if(get_the_title() != '') : ?>
		<h2>
			<a href="<?php the_permalink(); ?>" title="<?php printf( esc_attr__( 'Permalink to %s', GKTPLNAME ), the_title_attribute( 'echo=0' ) ); ?>" rel="bookmark"><?php the_title(); ?>
			</a>

		</h2>
		<?php endif; ?>
	</header>
</article>
<?php endif; ?>