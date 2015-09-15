<?php
/**
 * Pay for order form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     1.6.4
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce;
?>

<form id="order_review" method="post">
	<?php 
		$ret = pb_check_order_payment($order->id);
		if ($ret['pay']){
		}else{
			?>
			<style type="text/css">
			    #round{
			        padding:10px; width:300px; height:50px;
			        border: 5px solid #dedede;
			        -moz-border-radius: 15px;      /* Gecko browsers */
			        -webkit-border-radius: 15px;   /* Webkit browsers */
			        border-radius:15px;            /* W3C syntax */
			    }
			</style>
			<div id="round" style="width:290px;height:160px;text-align:center;margin:15px auto;border:2px solid #ccc;">
			<p style="font-size:38px;color:blue;font-weight:bold;margin:15px auto 15px auto;">恭喜您！</p>
			<p style="font-size:18px;font-weight:bold;">以成功参加团购活动，请留意查收订单支付短信</p>
			</div>
			<div style='text-align:center;margin-top:15px'>
			    <table style='margin:0px auto;'>
			        <tr><td colspan="2" style="font-size:18px;font-weight:bold;">您还可以领取下方优惠券</td></tr>
			        <tr><td><a href="http://yhqdemo.paybay.cn/p/h4jawxxj"><img src="<?php echo get_template_directory_uri().'/img/gwq.jpg'; ?>"/></a></td><td><a href="http://yhqdemo.paybay.cn/xrniuv3b"><img src="<?php echo get_template_directory_uri().'/img/yhq.jpg'; ?>"/></a></td></tr>
			    </table>
			</div>
			<hr style="width:90%;color:blue;margin-left:auto;margin-right:auto;margin-top:15px;border:1px solid blue;"/>
			<div style='text-align:center;margin-top:20px;'>
			    <table style='margin:0px auto;'>
			        <tr><td colspan="2" style="font-size:18px;font-weight:bold;line-height:3em;">下载交通银行客户端，更多好礼等你拿</td></tr>
			        <tr><td rowspan="2"><img src="<?php echo get_template_directory_uri().'/img/jh_logo.jpg'; ?>"/></td><td style="line-height:2em;"><a href="http://s.gchu.cn/yhh9j7cj"><img src="<?php echo get_template_directory_uri().'/img/android_d.jpg'; ?>"/></a></td></tr>
			        <tr><td style="line-height:2em;"><a href="https://itunes.apple.com/cn/app/jiao-tong-yin-xing/id337876534?mt=8&uo=4"><img src="<?php echo get_template_directory_uri().'/img/ios_d.jpg'; ?>"/></a></td></tr>
			    </table>
			</div>
			<?php
			return false;
		}
	?>
	<div class="checkout_msg">
		<div class="checkout_image">
			<?php
			$itemss = $order->get_items();
			foreach( $itemss as $it){
				$pro = $order->get_product_from_item( $it);
				$product_id = $it['product_id'];
				echo $pro->get_image();
			}

			;?>
		</div>

		<div class='paynow_more'>
			<table class="shop_table">
				<thead>
					<!--tr>
						<th class="product-name"><?php _e( 'Product', 'woocommerce' ); ?></th>
						<th class="product-quantity"><?php _e( 'Qty', 'woocommerce' ); ?></th>
						<th class="product-total"><?php _e( 'Totals', 'woocommerce' ); ?></th>
					</tr-->
				</thead>
				<!--tfoot>
				<?php
					if ( $totals = $order->get_order_item_totals() ) foreach ( $totals as $total ) :
						?>
						<tr>
							<th scope="row" colspan="2"><?php echo $total['label']; ?></th>
							<td class="product-total"><?php echo $total['value']; ?></td>
						</tr>
						<?php
					endforeach;
				?>
				</tfoot-->
				<tbody>
					<?php
					if ( sizeof( $order->get_items() ) > 0 ) :
						foreach ( $order->get_items() as $item ) :
						//	echo '
						//		<tr>
						//			<td class="product-name">品名：' . $item['name'].'</td>
						//			<td class="product-quantity">数量：' . $item['qty'].'</td>
						//			<td class="product-subtotal">价格：' . $order->get_formatted_line_subtotal( $item ) . '</td>
						//		</tr>';
							
							echo '<p id="judge_order_status" style="display:none">'.$order->status.'</p>';
							echo
								'
								<p>订单号:'.$order->get_order_number().'</p>
								<p>品名:'.$item['name'].'</p>
								<p>数量:'.$item['qty'].'</p>
								';
							echo   '<p>color:'.urldecode($item['color']).'</p>';	
							echo   '<p>size:'.$item['size'].'</p>';	
							echo   '<p>delivery:'.urldecode($item['delivery']).'</p>';	
							echo   '<p>价格:'.$order->get_total().'</p>';
						endforeach;
					endif;
					?>
				</tbody>
			</table>
		</div>
	</div>

	<?php 
		if ($order->status == "unpaid") : 
			$checkout = WC_Checkout::instance();
			$checkoutfield = $checkout->checkout_fields;

			//var_dump($checkout->checkout_fields['shipping']);
			//do_action( 'woocommerce_checkout_shipping' );
			?>
		<?php
			if ( empty( $_POST ) ) {

				$ship_to_different_address = get_option( 'woocommerce_ship_to_billing' ) === 'no' ? 1 : 0;
				$ship_to_different_address = apply_filters( 'woocommerce_ship_to_different_address_checked', $ship_to_different_address );

			} else {

				$ship_to_different_address = $checkout->get_value( 'ship_to_different_address' );

			}
		?>

		<h3 id="ship-to-different-address">
			<!--label for="ship-to-different-address-checkbox" class="checkbox"><?php _e( 'Ship to a different address?', 'woocommerce' ); ?></label-->
			<!--input id="ship-to-different-address-checkbox" class="input-checkbox" <?php checked( $ship_to_different_address, 1 ); ?> type="checkbox" name="ship_to_different_address" value="1" /-->
			<input id="ship-to-different-address-checkbox" style="display:none" class="input-checkbox" <?php checked( $ship_to_different_address, 1 ); ?> type="checkbox" name="ship_to_different_address" value="1" />
		</h3>

		<div class="shipping_address paynow_address_more">
			<?php do_action( 'woocommerce_before_checkout_shipping_form', $checkout ); ?>
			 <?php ?>
                        <!-- <div id ="is_need_billing">
                        <?php  foreach ( $checkout->checkout_fields['billing'] as $key => $field ) : ?>
                                <?php  woocommerce_form_field( $key, $field, $checkout->get_value( $key ) );?>
                        <?php endforeach?>
                        </div> -->

			<?php foreach ( $checkout->checkout_fields['shipping'] as $key => $field ) : ?>

				<?php woocommerce_form_field( $key, $field, $checkout->get_value( $key ) ); ?>

			<?php endforeach; ?>
		
			<?php foreach ( $checkout->checkout_fields['order'] as $key => $field ) : ?>

                                <?php woocommerce_form_field( $key, $field, $checkout->get_value( $key ) ); ?>
                        <?php endforeach; ?>





			<?php do_action( 'woocommerce_after_checkout_shipping_form', $checkout ); ?>

		</div>
	<?php endif; ?>
	
	<div id="payment">
		<?php if ( $order->needs_payment() ) : ?>
		<h3><?php _e( 'Payment', 'woocommerce' ); ?></h3>
		<ul class="payment_methods methods yincang">
			<?php
				if ( $available_gateways = WC()->payment_gateways->get_available_payment_gateways() ) {
					// Chosen Method
					if ( sizeof( $available_gateways ) )
						current( $available_gateways )->set_current();

					foreach ( $available_gateways as $gateway ) {
						?>
						<li class="payment_method_<?php echo $gateway->id; ?>">
							<input id="payment_method_<?php echo $gateway->id; ?>" type="radio" class="input-radio" name="payment_method" value="<?php echo esc_attr( $gateway->id ); ?>" <?php checked( $gateway->chosen, true ); ?> data-order_button_text="<?php echo esc_attr( $gateway->order_button_text ); ?>" />
							<label for="payment_method_<?php echo $gateway->id; ?>"><?php echo $gateway->get_title(); ?> <?php echo $gateway->get_icon(); ?></label>
							<?php
								if ( $gateway->has_fields() || $gateway->get_description() ) {
									echo '<div class="payment_box payment_method_' . $gateway->id . '" style="display:none;">';
									$gateway->payment_fields();
									echo '</div>';
								}
							?>
						</li>
						<?php
					}
				} else {

					echo '<p>' . __( 'Sorry, it seems that there are no available payment methods for your location. Please contact us if you require assistance or wish to make alternate arrangements.', 'woocommerce' ) . '</p>';

				}
			?>
		</ul>
		<?php endif; ?>

		<div class="form-row">
			<?php wp_nonce_field( 'woocommerce-pay' ); ?>
			<?php
				$pay_order_button_text = apply_filters( 'woocommerce_pay_order_button_text', __( 'Pay for order', 'woocommerce' ) );
				
				
				//echo '<hr class="payline" width=100% height=2>';
				// print_r($pay_order_button_text);
				echo apply_filters( 'woocommerce_pay_order_button_html', '<input type="submit" class="button alt paynow2" id="place_order" value="' . esc_attr( $pay_order_button_text ) . '" data-value="' . esc_attr( $pay_order_button_text ) . '" />' );
			?>			
			<input type="hidden" name="woocommerce_pay" value="1" />
		</div>

	</div>
</form>
