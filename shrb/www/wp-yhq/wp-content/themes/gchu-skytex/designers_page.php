<?php
// File Security Check
if ( ! empty( $_SERVER['SCRIPT_FILENAME'] ) && basename( __FILE__ ) == basename( $_SERVER['SCRIPT_FILENAME'] ) ) {
    die ( 'You do not have sufficient permissions to access this page!' );
}
?>
<?php
/**
    Template Name:designers_page
 */
	get_header();

?>
<section class="content" role="main">

	<?php highwind_content_top(); ?>

	<?php while ( have_posts() ) : the_post(); ?>

		<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
			<?php 
				//特色图像
				$full_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($post->ID), 'full');
				echo "<img src='".$full_image_url[0]."' style='margin-bottom: 10px;'";
				the_content(); 
			?>
		</article><!-- #post-<?php the_ID(); ?> -->

	<?php endwhile; // end of the loop. ?>

	<?php highwind_content_bottom(); ?>

</section><!-- /.content -->
<?php get_footer(); ?>
