<?php
/**
 * Variable product add to cart
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce, $product, $post;
?>

<script type="text/javascript">
    var product_variations_<?php echo $post->ID; ?> = <?php echo json_encode( $available_variations ) ?>;
</script>

<?php do_action( 'woocommerce_before_add_to_cart_form' ); ?>

<form class="variations_form cart" method="post" enctype='multipart/form-data' data-product_id="<?php echo $post->ID; ?>" data-product_variations="<?php echo esc_attr( json_encode( $available_variations ) ) ?>">
	<?php if ( ! empty( $available_variations ) ) : ?>
		<table class="variations" cellspacing="0">
			<tbody>
				<?php $loop = 0; foreach ( $attributes as $name => $options ) : $loop++; ?>
					<tr>
						<td class="label"><?php
                                            $attr=sanitize_title($name);
                                            if(sanitize_title($name)=='color')
                                            {
                                                $attr='重量';
                                            }
                                            else if(sanitize_title($name)=='size')
                                            {
                                                $attr='规格';
                                            }
                                            else
                                            {
                                                $attr='提货';
                                            }
                                            ?>
                            <label for=""><?php echo $attr; ?></label></td>
						<td class="value"><fieldset>
                        <?php
                            if ( is_array( $options ) ) {
                                if ( empty( $_POST ) ){
                                    $selected_value = ( isset( $selected_attributes[ sanitize_title( $name ) ] ) ) ? $selected_attributes[ sanitize_title( $name ) ] : '';
                                }
                                else{

                                    $selected_value = isset( $_POST[ 'attribute_' . sanitize_title( $name ) ] ) ? $_POST[ 'attribute_' . sanitize_title( $name ) ] : '';
                                }
                                	
								//echo   $selected_value;
                                // Get terms if this is a taxonomy - ordered
                                if ( taxonomy_exists( sanitize_title( $name ) ) ) {
 
                                    $terms = get_terms( sanitize_title($name), array('menu_order' => 'ASC') );
									// print_r($terms);
                                    foreach ( $terms as $term ) {
                                        if ( ! in_array( $term->slug, $options ) ) continue;
                                        echo '<input class="choose" type="radio" value="' . strtolower($term->slug) . '" ' . checked( strtolower ($selected_value), strtolower ($term->slug), false ) . ' id="'. esc_attr( sanitize_title($name."_".strtolower($term->slug)) ) .'" name="attribute_'. sanitize_title($name).'">';
                                        echo '<label for="'.esc_attr( sanitize_title($name)."_".strtolower($term->slug) ).'">'. apply_filters( 'woocommerce_variation_option_name', $term->name ).'</label>';
                                    }
                                } else {

                                    foreach ( $options as $option ) {
                                    	if($option=='送货')
                                    	{
                                    		echo '<input class="choose" type="radio" value="' .esc_attr( sanitize_title( $option ) ) . '" ' . checked( sanitize_title( $selected_value ), sanitize_title( $option ), false ) . ' id="'. esc_attr( sanitize_title($name."_".$option) ) .'" name="attribute_'. sanitize_title($name).'" checked="checked">';
                                        	echo '<label for="'.esc_attr( sanitize_title($name."_".$option) ).'">'. apply_filters( 'woocommerce_variation_option_name', $option ) .'</label>';
                                    	}
                                        else
                                        {
                                        	echo '<input class="choose" type="radio" value="' .esc_attr( sanitize_title( $option ) ) . '" ' . checked( sanitize_title( $selected_value ), sanitize_title( $option ), false ) . ' id="'. esc_attr( sanitize_title($name."_".$option) ) .'" name="attribute_'. sanitize_title($name).'">';
                                        	echo '<label for="'.esc_attr( sanitize_title($name."_".$option) ).'">'. apply_filters( 'woocommerce_variation_option_name', $option ) .'</label>';
                                        }
                                    }
                                }
                            }
                        ?>
                    </fieldset> <?php
							if ( sizeof($attributes) == $loop )
								//echo '<a class="reset_variations" href="#reset">' . __( 'Clear selection', 'woocommerce' ) . '</a>';
						?></td>
					</tr>
		        <?php endforeach;?>
			</tbody>
		</table>

		<?php do_action( 'woocommerce_before_add_to_cart_button' ); ?>

		<div class="single_variation_wrap">
			<?php do_action( 'woocommerce_before_single_variation' ); ?>

			<div class="single_variation"></div>

			<div class="variations_button">
				<?php woocommerce_quantity_input(); ?>
				<button type="submit" class="single_add_to_cart_button button alt"><?php echo $product->single_add_to_cart_text(); ?></button>
			</div>

			<input type="hidden" name="add-to-cart" value="<?php echo $product->id; ?>" />
			<input type="hidden" name="product_id" value="<?php echo esc_attr( $post->ID ); ?>" />
			<input type="hidden" name="variation_id" value="" />

			<?php do_action( 'woocommerce_after_single_variation' ); ?>
		</div>

		<?php do_action( 'woocommerce_after_add_to_cart_button' ); ?>

	<?php else : ?>

		<p class="stock out-of-stock"><?php _e( 'This product is currently out of stock and unavailable.', 'woocommerce' ); ?></p>

	<?php endif; ?>

</form>

<?php do_action( 'woocommerce_after_add_to_cart_form' ); ?>
