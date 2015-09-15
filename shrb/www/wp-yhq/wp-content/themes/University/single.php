<?php

/**
 *
 * Single page
 *
 **/

global $gk_tpl;

gk_load('header');
gk_load('before');

?>

<section id="gk-mainbody">
	<?php while ( have_posts() ) : the_post(); ?>
		<?php if(in_category(array('events-list-1', 'events-list-2'))) : ?>
			<?php get_template_part( 'content', 'event' ); ?>
		<?php elseif(in_category('staff')) : ?>
			<?php get_template_part( 'content', 'staff' ); ?>
		<?php else : ?>
			<?php get_template_part( 'content', get_post_format() ); ?>
		<?php endif; ?>
				
		<?php comments_template( '', true ); ?>
		
		<?php gk_content_nav(); ?>
	<?php endwhile; // end of the loop. ?>
</section>

<?php

gk_load('after');
gk_load('footer');

// EOF