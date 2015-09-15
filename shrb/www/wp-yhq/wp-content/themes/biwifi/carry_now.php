<?php
// File Security Check
if ( ! empty( $_SERVER['SCRIPT_FILENAME'] ) && basename( __FILE__ ) == basename( $_SERVER['SCRIPT_FILENAME'] ) ) {
    die ( 'You do not have sufficient permissions to access this page!' );
}
?>
<?php
/**
    Template Name:carry_now
 */
	get_header();
	global $woo_options;
?>
       
    <div id="content" class="page col-full">
		<section id="main" class="col-left"> 			
        <?php
        	if ( have_posts() ) { $count = 0;
        		while ( have_posts() ) { the_post(); $count++;
        ?>                                                           
            <article <?php post_class(); ?>>
				
                <section class="entry">
                	<?php //the_content(); ?>
                    <?php 
                        $order_id = "86";
                        $order = new WC_Order($order_id);
                        $item = $order->get_order_number();
                        $itemss = $order->get_items();
                        $count = $order->get_item_count(); 
                        $curre = $order->get_total();
                        $address = $order->get_formatted_billing_address();
                        foreach($itemss as $it){
                            $order_name = $it['name'] ;
                        }
                
                    ?>
                    <!--p><?php echo $order->status;?></p-->
                    <!--div class="buy_order">
                        <p id='carry_order1'>订单号:  <?php echo $item;?></p>                
                        <p id='carry_order2'>商品名称:  <?php echo $order_name?></p>
                        <p id='carry_order3'>商品数量:  <?php echo $count;?></p>
                        <p id='carry_order4'>已付金额:  ¥<?php echo $curre;?>元</p>
                        <button  id="shiyong" type="button">使用</button>
                        <input  id="carry_chakan" type="button" value="查看"/>
                        <div id="carry_shouhuo">
                            <p class="order_class">收货信息</p>
                            <p id='carry_order5' class="order_class">姓名: <?php echo $order->billing_last_name;?></p>
                            <p id='carry_order6' class="order_class">手机: <?php echo $order->billing_phone;?></p>
                            <p id='carry_order7' class="order_class">地址: <?php echo $order->billing_address_1;?></p>
                        </div>
                    </div-->

                    <div id="history_order_div">
                        <?php wc_get_template( 'myaccount/my-carry-orders.php', array( 'order_count' => $order_count ) ); ?>
                    </div>
		   <!--
                    <div id="carry_use_need_know">
                        <h3>如何使用资格券：</h3>
                        <p id="use_zigequan">
                        以下是假文忽略内容。。。快递公司:商家自行<br>
                        配送范围：全国(除港澳台、新疆、西藏)<br>
                        配送费用：本单包邮，配送范围内无需再额外支付邮费<br>
                        配送时间：购买成功后3个工作日内发货，5-7个工<br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10个工作日后未收到货，可申请退款<br>
                        查询物流：购买成功后可在我的订单中查询物流状态<br>
                        </p>
                    </div>
		  -->
               	</section><!-- /.entry -->
                
            </article><!-- /.post -->
            
            <?php
            	// Determine wether or not to display comments here, based on "Theme Options".
                
            	//if ( isset( $woo_options['woo_comments'] ) && in_array( $woo_options['woo_comments'], array( 'page', 'both' ) ) ) {
            	//	comments_template();
            	//}

				} // End WHILE Loop
			} else {
		?>
        <?php } // End IF Statement ?>  
        
		</section><!-- /#main -->
		

    </div><!-- /#content -->
<?php get_footer(); ?>
