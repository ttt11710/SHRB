<?php
/**
 * Single Product Image
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.0.14
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $post, $woocommerce, $product;

?>
<?php

	// if(!is_user_logged_in())
	// {
	// 	//登入后跳转之前页面
	// 	ob_end_clean();
	// 	$url= home_url();
	// 	$url=$url.'/myaccount/'.'?redirect='.$callback_url;
	// 	print_r($url);
	// 	header("location:".$url."");
	// 	exit();
	// }
?>
<div id="wrapper">
	<div id="scroller">
		<ul>
<!-- 			<li>
 -->
			<?php
				// if ( has_post_thumbnail() ) {
				// 	$image_title = esc_attr( get_the_title( get_post_thumbnail_id() ) );
				// 	$image_link  = wp_get_attachment_url( get_post_thumbnail_id() );
				// 	$image       = get_the_post_thumbnail( $post->ID, apply_filters( 'single_product_large_thumbnail_size', 'shop_single' ), array(
				// 		'title' => $image_title
				// 		) );
				// 	echo $image;
				// } else {
				// 	echo sprintf( '<img src="%s" alt="%s" />', wc_placeholder_img_src(), "Placeholder");
				// }
			?>

<!-- 			</li>
 -->
			<?php 
				$attachment_ids = $product->get_gallery_attachment_ids();
				if ( $attachment_ids ) {
					$loop = 0;
					foreach ( $attachment_ids as $attachment_id ) {
						$image_link = wp_get_attachment_url( $attachment_id );
						if ( ! $image_link )
							continue;

						$image       = wp_get_attachment_image( $attachment_id, apply_filters( 'single_product_large_thumbnail_size', 'shop_single' ) );
						$image_title = esc_attr( get_the_title( $attachment_id ) );
						echo "<li>";
							echo $image;
						echo "</li>";
						$loop++;
					}
				}
			?>
		</ul>
	</div>
</div>
        <div class="line pure-g">
            <div class="indicator cl"></div>
            <div class="indicator"></div>
            <div class="indicator"></div>
        </div>

