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
//$order_ids = array();
$order_ids='';
function send_post($url,$array_id){
    $postdata = http_build_query(
        $array_id
    );
    //$postdata = $array_id;
    $opts = array('http' =>
                  array(
                      'method'  => 'POST',
                      'header'  => 'Content-type: application/x-www-form-urlencoded',
                      'content' => $postdata
                  )
    );
    $context = stream_context_create($opts);
    $result = file_get_contents($url, false, $context);
    return $result;
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
                $order_ids = $order->get_order_number().','.$order_ids;
                //array_push($order_ids,$order->get_order_number());
            }
            $orders_data = array(
                'orders'=>$order_ids
            );
	    //无打印状态下不发送post请求
            //$ret = send_post("http://sanfuprint.paybay.cn/if_print",$orders_data);
            //$ret = json_decode($ret,true);

			foreach ( $customer_orders as $customer_order ) {
				$order = new WC_Order();

				$order->populate( $customer_order );

				$status     = get_term_by( 'slug', $order->status, 'shop_order_status' );
				$item_count = $order->get_item_count();
                $itemss = $order->get_items();
                $item = $order->get_order_number();
				?>
                <?php 
					$aaa='';
		    //无打印状态下不使用
                    //foreach($ret as $ret_order){
                    //    if ($ret_order[$item]){
                    //        $aaa='exist';
                    //    }
                   // }
                    if($order->status == "paid" and $aaa==''):
                    //if($order->status == "processing"):
                ?>
                        <div class="history_order">
                            <!--div id='order_image'>
                                <?php
                                    foreach( $itemss as $it){
                                        $pro = $order->get_product_from_item( $it);
                                        echo $pro->get_image();
                                    }

                                ;?>
                            </div-->

                            <ul class="list_v">
                                <li class="borv1">
                                    <ol>
                                            <?php
                                                foreach( $itemss as $it){
                                                    $pro = $order->get_product_from_item( $it);
                                                    $product_attribute=$pro->variation_data;
                                                    echo $pro->get_image();
                                                }

                                            ;?>

                                    </ol>
                                    <ol class="ft13">
                                        <p class="lh20">
                                            <span id="productname1">
                                                    <?php
                                                        foreach( $itemss as $it){
                                                            echo $it['name'];
                                                        }
                                                    ?>
                                            </span>
                                            <span class="quan"><img src="<?php echo bloginfo('template_url').'/img/delivery_bg1.png'; ?>" width="74" /></span>
                                        </p>
                                        <p id="order_data" style="display:none"><?php echo $order->order_date;?></p>
                                        <p class="history_order3" style="display:none">商品数量: <?php echo $item_count;?></p>
                                        <p class="history_order4" style="display:none">已付金额：<?php echo $order->get_formatted_order_total();?></p>
                                        <p id="unit_price" style="display:none"><?php echo($order->get_total()/$order->get_item_count());?>
                                        <p class="lh20 bor_b4 wid90">价格：<?php echo strip_tags($order->get_formatted_order_total()); ?></p>
                                        <p class="lh20 bor_b4 wid90">尺寸：<?php echo urldecode($product_attribute['attribute_size']);?></p>
                                        <p class="lh20 bor_b4 wid90">颜色：<?php echo urldecode($product_attribute['attribute_color']);?></p>
                                        <p class="lh20 bor_b4 wid90" style='border-bottom:0px'>订单号：<?php echo strip_tags($order->get_order_number()); ?></p>
                                        <p class="lh35 wid98">
                                            <span id="orderid1" style="display:none">订单号：<?php echo strip_tags($order->get_order_number()); ?></span>
                                            <span id="orderid2" style="display:none"><?php echo $order->get_order_number(); ?></span>
                                            <span class="btn_xq fc2" id="more" onclick="">详情</span>
                                        </p>
                                            <!--button  id="shiyong" type="button">提货</button-->
                                        <div class="sanfu_shouhuo" style="display:none">
                                            <p class="order_class">收货信息</p>
                                            <p class="order_class">姓名: <?php echo $order->shipping_first_name;?></p>
                                            <p class="order_class">手机: <?php echo $order->shipping_phone;?></p>
                                            <p class="order_class">地址: <?php echo $order->shipping_address_1;?></p>
                                            <p class="order_class">发票抬头: <?php 
                                                                                if(empty($order->billing_invoice_name))
                                                                                {
                                                                                    echo '不需要发票';
                                                                                }
                                                                                else{
                                                                                    echo $order->billing_invoice_name;
                                                                                }
                                                                            ?></p>
                                            <p class="order_class">备注信息: <?php echo $order->order_comment; echo $order->customer_note;?></p>
                                            <p class="order_class"><hr/></p>
                        <p class="order_class">快递公司:默认申通或中通 </p>
                        <p class="order_class">配送范围:全国地区(不含港澳台)</p>
                        <p class="order_class">配送费用:本单包邮 无须额外支付邮费 </p>
                        <p class="order_class">配送时间:正常地区3至5天  偏远地区5至10天</p>
                        <p class="order_class">查询物流:登陆百联官网(www.blemall.com)会员中心，在我的订单状况中查询物流单号 </p>
                        <p class="order_class">售后服务:售后服务正常与官网售后服务政策一致，具体详情可咨询官网客服</p>
                        <p class="order_class">退款方式:拨打400-893-9833客服电话,拨打时间 8:30-24:00 点 </p>
                                        </div>
                                        <!--span class="btn_xq fc2" id='shiyong' onclick="" style="display:none">打印</span-->
                                    </ol>
                                </li>


                                <!--li class="borv2">
                                    <ol>
                                            <?php
                                                foreach( $itemss as $it){
                                                    $pro = $order->get_product_from_item( $it);
                                                    echo $pro->get_image();
                                                }

                                            ;?>

                                    </ol>
                                    <ol class="ft13">
                                        <p class="lh20">
                                            <span>
                                                    <?php
                                                        foreach( $itemss as $it){
                                                            echo $it['name'];
                                                        }
                                                    ?>
                                            </span>
                                            <span class="quan"><img src="<?php echo bloginfo('template_url').'/images/social_bg1.png'; ?>" width="74" /></span>
                                        </p>
                                        <p class="lh20 bor_b4 wid90">价格：<?php echo $order->get_formatted_order_total() ?></p>
                                        <p class="lh35 wid98">
                                            <span>券号：<?php echo $order->get_order_number(); ?></span>
                                            <span class="btn_xq fc2">详情</span>
                                        </p>
                                    </ol>
                                </li-->
                                
                            </ul>

                            <!--

                            <p class="history_order1">订单号: <?php echo $order->get_order_number(); ?></p>
                            <p id="order_data" style="display:none"><?php echo $order->order_date;?></p>
                            <p class="history_order2">商品名称: <?php 
                            
                                foreach( $itemss as $it){
                                    echo $it['name'];
                                }
                            ?></p>
                            <p id="unit_price" style="display:none"><?php echo($order->get_total()/$order->get_item_count());?>
                            <p class="history_order3">商品数量: <?php echo $item_count;?></p>
                            <p class="history_order4">已付金额：<?php echo $order->get_formatted_order_total();?></p>
                            -->
                            <!--input type="button" class="history_more" value="查看单品详情页"/-->

                            <!--
                            <button  id="shiyong" type="button">提货</button>
                            <input  id="carry_chakan" type="button" value="查看"/>
                            <div class="history_shouhuo">
                                <p class="order_class">收货信息</p>
                                <p class="order_class">姓名: <?php echo $order->billing_last_name;?></p>
                                <p class="order_class">手机: <?php echo $order->billing_phone;?></p>
                                <p class="order_class">地址: <?php echo $order->billing_address_1;?></p>
                            </div>
                            -->


                    </div>
                <?php endif; ?>
        <?php } ?>

<?php endif; ?>
