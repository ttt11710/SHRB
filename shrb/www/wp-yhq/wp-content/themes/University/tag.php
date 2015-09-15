<?php

/**
 *
 * Tag page
 *
 **/

global $gk_tpl;

gk_load('header');
gk_load('before');

?>

<section id="gk-mainbody" class="tag-page">
	<h1 class="page-title">
		<?php
			printf( __( 'Tag Archives: %s', GKTPLNAME ), '<i>' . single_tag_title( '', false ) . '</i>' );
		?>
	</h1>
	
	<?php if ( have_posts() ) : ?>		
		<?php do_action('gavernwp_before_loop'); ?>
		
		<?php 
			$iter = 0;
			while ( have_posts() ) : the_post(); 
		?>
			<?php $iter++; ?>
			
			<?php get_template_part( 'content', get_post_format() ); ?>
			
			<?php if($iter > 0 && $iter % 2 == 0) : ?>
			<hr />
			<?php endif; ?>
		<?php endwhile; ?>
		
		<?php gk_content_nav(); ?>
		
		<?php do_action('gavernwp_after_loop'); ?>
		
	<?php else : ?>
		<h1 class="page-title">
			<?php _e( 'Nothing Found', GKTPLNAME ); ?>
		</h1>
	
		<section class="intro">
			<?php _e( 'Apologies, but no results were found for the requested archive. Perhaps searching will help find a related post.', GKTPLNAME ); ?>
		</section>
		
		<?php get_search_form(); ?>
	<?php endif; ?>
</section>

<?php

gk_load('after');
gk_load('footer');

// EOF