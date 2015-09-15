<?php
/**
 * My Orders
 *
 * Shows recent orders on the account page
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce;
	$current_user =  wp_get_current_user();
       $currentuser =  $current_user->display_name;
 if($currentuser == ""){
 	echo "<script language='javascript'>". 
	 "window.location.href=".get_permalink( wc_get_page_id( 'myaccount' )).
	"</script>";
}



$customer_orders = get_posts( apply_filters( 'woocommerce_my_account_my_orders_query', array(
	'numberposts' => $order_count,
	'meta_key'    => '_customer_user',
	'meta_value'  => get_current_user_id(),
	'post_type'   => 'shop_order',
	'post_status' => 'publish'
) ) );

if ( $customer_orders ) : ?>
		<?php
			foreach ( $customer_orders as $customer_order ) {
				$order = new WC_Order();
				$order->populate( $customer_order );
				$status     = get_term_by( 'slug', $order->status, 'shop_order_status' );
				$item_count = $order->get_item_count();
                $itemss = $order->get_items();
				?>
                <?php 
                    //if ($order->status == 'unpaid'):
                    if ( in_array( $order->status, apply_filters( 'woocommerce_valid_order_statuses_for_payment', array( 'processing', 'failed' ), $order ) ) ):
                ?>
                <div class="history_order">
                    <ul class="list_v">
                        <li class="borv3">
                            <ol>
                                    <?php
                                        foreach( $itemss as $it){
                                            $pro = $order->get_product_from_item( $it);
                                            $product_attribute=$pro->variation_data;
                                            // print_r($product_attribute);
                                            echo $pro->get_image();
                                        }

                                    ;?>
                            </ol>
                            <ol class="ft13">
                                <p class="lh20">
                                    <span style="text-align:left; margin-right:3px;">
                                            <?php
                                                foreach( $itemss as $it){
                                                    echo $it['name'];
                                                }
                                            ?>
                                    </span>
                                    <!--span class="quan"><img src="<?php echo bloginfo('template_url').'/img/delivery_bg1.png'; ?>" width="74" /></span-->
                                </p>
                                <p style="display:none"><?php echo $order->order_date;?></p>
                                <p class="lh20 bor_b4 wid90">价格：<?php echo strip_tags($order->get_formatted_order_total()); ?></p>
                                <p class="lh20 bor_b4 wid90">尺寸：<?php echo $product_attribute['attribute_size'];?></p>
                                <p class="lh20 bor_b4 wid90">颜色：<?php echo urldecode($product_attribute['attribute_color']);?></p>
                                <p class="lh35 wid98" ordid="<?php echo $order->id;?>" sendurl="<?php echo get_bloginfo('wpurl')?>">
                                    <span style="text-align:left;">订单号：&nbsp;&nbsp;&nbsp;<?php echo $order->get_order_number(); ?></span>
									<a style="display:none"><?php echo $order->id;?></a>
                                    <a id="order_click" class="btn_xq fc2" href=<?php echo $order->get_checkout_payment_url();?>>
                                    <?php
                                           echo "支付";
                                    ?>
                                    </a>
				     <?php if($order->status == 'unpaid') : ?>
                                     <a id="order_del"  class="btn_xq fc2"  href="javascript:void(0);">取消</a>
				     <?php endif;?>
                                    <!--span class="btn_xq fc2" id="unpay">
                                        支付
                                    </span-->
                                </p>
                            </ol>
                        </li>
                    </ul>
                </div>		
                <?php endif; ?>
        <?php } ?>


<?php endif; ?>
