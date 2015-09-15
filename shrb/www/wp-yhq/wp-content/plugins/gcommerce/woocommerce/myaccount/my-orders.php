<?php
/**
 * My Orders
 *
 * Shows recent orders on the account page
 *
 * @author      WooThemes
 * @package     WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}
$customer_orders = get_posts( apply_filters( 'woocommerce_my_account_my_orders_query', array(
    'numberposts' => $order_count,
    'meta_key'    => '_customer_user',
    'meta_value'  => get_current_user_id(),
    'post_type'   => 'shop_order',
    'post_status' => 'publish'
) ) );

if ( $customer_orders ) { ?>

    <h2 style="margin-left:15px;font-size:13px;color(0,0,0,0.87);">我的订单</h2>

    <!-- <ul class="order-list shop_table my_account_orders"> -->

            <?php
            foreach ( $customer_orders as $customer_order ) {
                $order = new WC_Order();

                $order->populate( $customer_order );
                $status     = get_term_by( 'slug', $order->status, 'shop_order_status' );
                $item_count = $order->get_item_count();
                foreach( $order->get_items() as $item ) {
                    $product_id = $item['product_id'];
                    $pb_product=get_product($product_id,$fields = null);
                    $medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($product_id), 'medium');
                    // print_r( $medium_image_url);
                }
                // print_r($order->id);
                $total=get_post_meta($order->id,'_order_total',ture);
                // print_r($total);
                // print_r($order->status);
                $img;
                if ($order->status == 'processing' || $order->status == 'pending') {
                    if($total=='0.00'){
                        $act_img=CURRENT_TEMPLATE_DIR."/images/no_act.png";  
                    }else{
                        $act_img=CURRENT_TEMPLATE_DIR."/images/no_pay.png";
                    }
                } else if ($order->status == 'paid') {
                    $act_img=CURRENT_TEMPLATE_DIR."/images/no_act.png";                        
                }else if($order->status == 'cancelled'){
                    $act_img=CURRENT_TEMPLATE_DIR."/images/order-ca1.png";
                } else {
                    $act_img=CURRENT_TEMPLATE_DIR."/images/yes_act1.png";                         
                }
                $actions = array();
                $actions['view'] = array(
                    'url'  => $order->get_view_order_url(),
                    'name' => '查看'
                );
                // if ( in_array( $order->status, apply_filters( 'woocommerce_valid_order_statuses_for_cancel', array( 'pending', 'failed' ), $order ) ) ) {
                //     $actions['cancel'] = array(
                //         'url'  => $order->get_cancel_order_url( get_permalink( wc_get_page_id( 'myaccount' ) ) ),
                //         'name' => __( 'Cancel', 'woocommerce' )
                //     );
                // }
                if ( in_array( $order->status, apply_filters( 'woocommerce_valid_order_statuses_for_payment', array( 'pending', 'failed' ), $order ) ) ) {
                    $actions['pay'] = array(
                        'url'  => $order->get_checkout_payment_url(),
                        'name' => __( '去付款', 'woocommerce' )
                    );
                }
                $actions = apply_filters( 'woocommerce_my_account_my_orders_actions', $actions, $order );
                ?>
                    <ul style="margin: 10px 13px !important;text-align: left;border: 1px solid rgba(0,0,0,0.12);">
                        <li style="padding-top: 5px;overflow: hidden;">
                            <div style="display: inline-block;margin-left:3px;">
                                <div style="float:left; width:30%;">
                                    <img src="<?php echo $medium_image_url[0]; ?>" />
                                </div>
                                <div style="margin-left:13px;width:45%;float:left;">
                                    <span style="font-size:13px;color:rgba(0,0,0,0.87)"><?php echo $pb_product->post->post_title; ?></span>
                                    </br>
                                    <span style="color:#fe5722;font-size:11px;">实付款:<?php echo '￥'.$total; ?></span>
                                    </br>
<!--                                     <a style="background: #ff6088;padding: 1px 15px;color: #ffffff;border-radius: 5px;" href="<?php echo home_url().'/?p='.$value?>">去购买</a> -->
                                </div>
                            </div>
                            <?php
                                if ($actions) {
                                    foreach ( $actions as $key => $action ) {
                                        if(count($actions)==1){
                                            echo '<a href="' . esc_url( $action['url'] ) . '" class=" ' . sanitize_html_class( $key ) . '" style="color:rgba(0,0,0,0.87);"><div style="text-align: center;width:100%;float:left;background: rgba(0,0,0,0.05);padding-top: 13px;padding-bottom: 13px;border-top:1px solid rgba(0,0,0,0.12);border-left:1px solid rgba(0,0,0,0.12);">' . esc_html( $action['name'] ) . '</div></a>';
                                        }
                                        else
                                        {
                                            echo '<a href="' . esc_url( $action['url'] ) . '" class=" ' . sanitize_html_class( $key ) . '" style="color:rgba(0,0,0,0.87);"><div style="text-align: center;-webkit-box-sizing: border-box;box-sizing: border-box;width:50%;float:left;background: rgba(0,0,0,0.05);padding-top: 13px;padding-bottom: 13px;border-top:1px solid rgba(0,0,0,0.12);border-left:1px solid rgba(0,0,0,0.12);">' . esc_html( $action['name'] ) . '</div></a>';
                                        }
                                    }
                                }
                            ?>
                        </li>
<!--                         <li style="width:100%;height:auto;padding-top: 2px;position:relative">
                            <img style="position:absolute;left:5px;width:30%" src='<?php echo $act_img; ?>'/>
                            <?php
                                if ($actions) {
                                    $img_url;
                                    foreach ( $actions as $key => $action ) {
                                        $img_url=$action['url'];
                                    }
                                }
                            ?>
                            <a href="<?php echo $img_url; ?>"><img style="margin:5px auto;border-radius:10px;width:90%" src="<?php echo $medium_image_url[0];?>" /></a>
                            <?php

                            ?>
                        </li>
                        <li class="order-actions">
                            <?php
                                if ($actions) {
                                    foreach ( $actions as $key => $action ) {
                                        echo '<a href="' . esc_url( $action['url'] ) . '" class=" ' . sanitize_html_class( $key ) . '" style="margin-bottom:10px;margin-right:40px;margin-left:40px;color:#ffffff">' . esc_html( $action['name'] ) . '</a>';
                                    }
                                }
                            ?>
                        </li> -->
                    </ul>

                <?php
            }
        ?>
    <!-- </ul> -->
    <div style="width:100%">
        <p style="text-align: center;margin:10px 0;"><a href="<?php echo home_url(); ?>"><button style="width:50%;margin:0 auto;" type="submit" class="single_add_to_cart_button button alt">去购物</button></a></p>
    </div>
<?php }else{
   ?>
    <div style="width:100%">
        <p style="text-align: center;margin:0;font-size: 20px;">亲，您还没购买过商品哦！</p>
        <p style="text-align: center;margin:10px 0;"><a href="<?php echo home_url(); ?>"><button style="width:50%;margin:0 auto;" type="submit" class="single_add_to_cart_button button alt">去购物</button></a></p>
    </div>
   <?php
} 

?>
