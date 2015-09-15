<?php
// File Security Check
if ( ! empty( $_SERVER['SCRIPT_FILENAME'] ) && basename( __FILE__ ) == basename( $_SERVER['SCRIPT_FILENAME'] ) ) {
    die ( 'You do not have sufficient permissions to access this page!' );
}
?>
<?php
/**
    Template Name:show_detail
 */
	get_header();
	global $woo_options;
	global $product;
?>  
		<div id="showimgdiv" >
		<?php
				$posid = $_GET['posid'];
			    echo get_post_field('post_content',$posid);	
		?>
		</div>
        
				<?php  echo apply_filters( 'woocommerce_short_description', $post->$product->id ); ?>
              </div>
                
<?php get_footer(); ?>
