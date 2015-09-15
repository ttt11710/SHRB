<?php get_header();?>
<?php
/**
    Template Name:index-j
 */
?>
<div id='abc' style='margin:10px auto'><?php echo do_shortcode("[layerslider id='1']"); ?></div>
<?php while ( have_posts() ) : the_post(); print_r(the_content());?>


<?php endwhile; // end of the loop. ?>