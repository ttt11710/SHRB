<?php
/**
 * Single Product Price, including microdata for SEO
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     1.6.4
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $post, $product;

// Step 1: Get product varations
$available_variations = $product->get_available_variations();

// Step 2: Get product variation id
$variation_id=$available_variations[0]['variation_id']; // Getting the variable id of just the 1st product. You can loop $available_variations to get info about each variation.

// Step 3: Create the variable product object
$variable_product1= new WC_Product_Variation( $variation_id );

// Step 4: You have the data. Have fun :)
$regular_price = $variable_product1 ->regular_price;
$sales_price = $variable_product1 ->sale_price;


?>
<div class="price pure-g ft17">
    <div class="pure-u-2-5 fc5 ">商品原价<br/><span class="ft21"><del id="cost">￥<?php echo $regular_price; ?></del></span></div>
    <div class="pure-u-1-5 fc2">
        商&nbsp;&nbsp;品<br />
        <span>促销价</span>
    </div>
    <div class="pure-u-2-5 ft43 fc2 lh40" id="price">￥<?php echo $sales_price; ?></div>
</div>
