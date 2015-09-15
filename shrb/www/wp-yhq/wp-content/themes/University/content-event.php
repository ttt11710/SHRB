<?php

/**
 *
 * The default template for displaying event's content
 *
 **/

global $gk_tpl, $wp_locale; 

// get event details from custom fields
$date_start = new DateTime(get_post_meta( $post->ID, 'gkevent_date_start', true ));
$date_end = new DateTime(get_post_meta( $post->ID, 'gkevent_date_end', true ));
$counter_start = new DateTime(get_post_meta( $post->ID, 'gkevent_counter_start', true ));
$datemonth_start = $wp_locale->get_month($date_start->format('m') );
$datemonth_end = $wp_locale->get_month($date_end->format('m') );

?>

<?php if(is_single()) : ?>
<article id="post-<?php the_ID(); ?>" <?php post_class('gk-event-single'); ?>>
	<header>
		<?php get_template_part( 'layouts/content.post.header' ); ?>
	</header>

	<?php get_template_part( 'layouts/content.post.featured' ); ?>

	<section class="content">
		<div class="gk-event">
		  <h3><?php _e('Event Details: ', GKTPLNAME); ?></h3>
		  <ul>
		    <li><strong><?php _e('Date: ', GKTPLNAME); ?></strong> 
		    	<span class="gk-event-period">
	                <time datetime="<?php echo $date_start->format('d-m-Y'); ?>" class="gk-event-date-start"><?php echo $date_start->format('j ') . $datemonth_start . $date_start->format(' Y '); ?>
	                </time> - 
	                <time datetime="<?php echo $date_end->format('d-m-Y'); ?>" class="gk-event-date-end"><?php echo $date_end->format('j ') . $datemonth_end . $date_end->format(' Y '); ?></time>
               	</span>
		        <span class="gk-event-hours">
		           <time datetime="<?php echo $date_start->format('G:i'); ?>" class="gk-event-time-start"><?php echo $date_start->format('g:i a'); ?></time> - 
		           <time datetime="<?php echo $date_end->format('G:i'); ?>" class="gk-event-time-end"><?php echo $date_end->format('g:i a'); ?></time>
		        </span>
		    </li>
		    <li> <strong><?php _e('Venue: ', GKTPLNAME); ?></strong> <span><?php echo get_post_meta( $post->ID, 'gkevent_venue', true ); ?></span> </li>
		    <li class="gk-event-register"><a href="<?php echo get_post_meta( $post->ID, 'gkevent_register_url', true ); ?>"><?php _e('Register', GKTPLNAME); ?></a></li>
		  </ul>
		  <time class="gk-event-counter" datetime="<?php echo $counter_start->format('d-m-Y'); ?>"><?php _e('Time left to event: ', GKTPLNAME); ?></time>
		</div>
		
		<?php the_content( __( 'Read more...', GKTPLNAME ) ); ?>
		
		<?php gk_post_fields(); ?>
		<?php gk_post_links(); ?>
	</section>

	<?php get_template_part( 'layouts/content.post.footer' ); ?>
</article>
<?php else : ?>
<article id="post-<?php the_ID(); ?>" <?php post_class('gk-event-cat'); ?>>
	<?php if(in_category('events-list-2')) : ?>
		<?php if(get_post_meta( $post->ID, 'gkevent_date_start', true ) !== '' ) : ?>
		<time class="entry-date" datetime="<?php echo $date_start->format('c'); ?>">
				<?php echo $date_start->format('D'); ?>	
				<span><?php echo $date_start->format('M j'); ?></span>
		</time>
		<?php endif; ?>
	
	<?php else : ?>
		<?php if(has_post_thumbnail()) : ?>
		<figure class="featured-image">
			<a href="<?php the_permalink(); ?>">
				<?php the_post_thumbnail('medium'); ?>
			</a>
		</figure>
		<?php endif; ?>
	<?php endif; ?>
	
	<div class="event-description">
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
			<li><strong><?php _e( 'When: ', GKTPLNAME ); ?></strong><?php echo $date_start->format('j ') . $datemonth_start . $date_start->format(' Y '); ?> - <?php echo $date_end->format('j ') . $datemonth_end . $date_end->format(' Y '); ?> @ <?php echo $date_start->format('g:i a'); ?> - <?php echo $date_end->format('g:i a'); ?></li>
			</ul>
		</header>
		<a href="<?php echo get_permalink(get_the_ID()); ?>"><?php _e('Read more...', GKTPLNAME); ?></a>
	</div>
</article>


<?php endif; ?>