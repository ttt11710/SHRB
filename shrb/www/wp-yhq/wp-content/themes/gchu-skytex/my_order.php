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
                    <div id="history_order_div">
                        <?php wc_get_template( 'myaccount/my-orders.php', array( 'order_count' => $order_count ) ); ?>
                    </div>

               	</section><!-- /.entry -->
                
            </article><!-- /.post -->
            
            <?php

				} // End WHILE Loop
			} else {
		?>
        <?php } // End IF Statement ?>  
        
		</section><!-- /#main -->
		

    </div><!-- /#content -->
<?php get_footer(); ?>
