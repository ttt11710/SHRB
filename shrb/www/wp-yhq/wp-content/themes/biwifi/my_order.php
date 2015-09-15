<?php
// File Security Check
if ( ! empty( $_SERVER['SCRIPT_FILENAME'] ) && basename( __FILE__ ) == basename( $_SERVER['SCRIPT_FILENAME'] ) ) {
    die ( 'You do not have sufficient permissions to access this page!' );
}
?>
<?php
/**
    Template Name:my_order
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

                    <p style="display:none" id='order_url'><?php echo $_GET['need_what'];?></p>
                    <p style="display:none" id='back_url'><?php echo $_SERVER['REQUEST_URI'];?></p>
                    <!--h2 id='order_h2'>已购买订单</h2-->
                    <!--p id="current_user" style="display:none">
                        <?php
                            $current  = wp_get_current_user();
                            echo $current->display_name;
                        ?>
                    </p-->

                    <?php 
                        $order_id = $_GET['out_trade_no'];
                        if (strlen($order_id)>5)
                            $order_id = substr($order_id,5);
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
                    <!--div class="buy_order">
                        <p id='order1'>订单号:  <?php echo $item;?></p>                
                        <p id='order2'>商品名称:  <?php echo $order_name?></p>
                        <p id='order3'>商品数量:  <?php echo $count;?></p>
                        <p id='order4'>已付金额:  ¥<?php echo $curre;?>元</p>
                        <input  id="chakan" type="button" value="查看"/>
                        <div id="shouhuo">
                            <p class="order_class">收货信息</p>
                            <p id='order5' class="order_class">姓名: <?php echo $order->billing_last_name;?></p>
                            <p id='order6' class="order_class">手机: <?php echo $order->billing_phone;?></p>
                            <p id='order7' class="order_class">地址: <?php echo $order->billing_address_1;?></p>
                        </div>
                        <div id="use_need_know">
                        使用须知：<br>
                        请前往本店收银台，扫描专用二维码，
                        在打开的网页中，点击"提货"按钮,
                        并与工作人员确认，完成提货。

                        </div>
                        <img id="success_img" src="http://192.168.0.122/wp-content/themes/my_hellokitty/images/success.png" />
                    </div-->

                    <!--h2 id='history_order_h2' style="display:none">历史订单</h2-->
                    <div id="history_order_div">
                        <?php wc_get_template( 'myaccount/my-orders.php', array( 'order_count' => $order_count ) ); ?>
                    </div>

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
