<?php
if(isset($_GET['reset']))
{
    // Header("HTTP/1.1 303 See Other"); 
    // Header("Location: http://www.baidu.com"); 
    header("Location: ".get_permalink( wc_get_page_id( 'myaccount' ) )."");
    // exit; //from www.w3sky.com 
}
/**
 * The header template.
 * @package highwind
 * @since 1.0
 */
?>
<?php if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly ?><?php highwind_html_before(); ?><!doctype html><!--[if lt IE 7 ]> <html <?php language_attributes(); ?> class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html <?php language_attributes(); ?> class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html <?php language_attributes(); ?> class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html <?php language_attributes(); ?> class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html <?php language_attributes(); ?> class="no-js"> <!--<![endif]-->
<head>

	<?php highwind_head_top(); ?>

	<meta charset="<?php bloginfo( 'charset' ); ?>" />

	<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"/>
	<title>Success</title>

	<!--  Mobile viewport optimized: j.mp/bplateviewport -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>" />
    <link rel="stylesheet" type="text/css" href="<?php echo CURRENT_TEMPLATE_DIR.'/css/font-awesome.css'?>" />
    <link rel="stylesheet" type="text/css" href="<?php echo CURRENT_TEMPLATE_DIR.'/css/font-awesome.min.css'; ?>" />
    <link rel="stylesheet" type="text/css" href="<?php echo CURRENT_TEMPLATE_DIR.'/css/pure-min.css'; ?>" />
    <link rel="stylesheet" type="text/css" href="<?php echo CURRENT_TEMPLATE_DIR.'/css/dessert.css'; ?>" />
    
	<?php highwind_head_bottom(); ?>

	<?php wp_head(); ?>

</head>

<body <?php body_class(); ?>>
<script type="text/javascript">
    var a='<?php wp_title( '/', true, 'right' ); ?>';
    document.title=a;
</script>
<div class="outer-wrap" id="top" >
    <div class="inner-wrap" style='padding-top:50px;background-color: #fff;' id="container">
            <script type="text/javascript"> 
                // (function( $ ){
                //     $(document).ready(function(){  
                //         $(document).bind("contextmenu",function(e){  
                //             return false;  
                //         });  
                //     });  
                // })( jQuery );
            </script>
	<header id="masthead" class="site-header head bg1 fc1" role="banner" style="background-image: url(<?php echo CURRENT_TEMPLATE_DIR.'/images/sk_header.png'; ?>);">
		<?php 
        // 页面跳转路径
		$homeurl=home_url();
		// $cart=$homeurl.'/cart/';
		$myaccount=$homeurl.'/myaccount/';
    		if (is_product()) {
                //商品
    			?>
    			<p id='headimg' ><a href='<?php echo $homeurl;?>'><span class="fa fa-home fa-lg"></span></a></p>
        		<p class="ft21" style="margin-left: 50px;">
	        		<?php
                    // $is_ap=json_decode(biwifi_portal_select());
                    // // print_r($is_ap);
                    // if(empty($is_ap))
                    // {
                    //     echo "<script>window.location.href='".home_url()."/?p=108';</script>";
                    // }
	    			echo '优惠券详情';
	    			?>
				</p>
				<p><a href='<?php echo $myaccount;?>'><img style="height: 25px;" src='<?php echo CURRENT_TEMPLATE_DIR."/images/my-order.png" ?>'/></a></p>
    			<?php
    		}else if (is_checkout()) {
                //支付结算
    			?>
    			<p id='headimg' ><a href='<?php echo $homeurl;?>'><span class="fa fa-home fa-lg"></span></a></p>
        		<p class="ft21">
	        		<?php
	    			// echo '结算';
	    			?>
				</p>
       			<p><a href='<?php echo $myaccount;?>'><img style="height: 25px;" src='<?php echo CURRENT_TEMPLATE_DIR."/images/my-order.png" ?>'/></a></p>
    			<?php
    		} else if (is_account_page()) {
                //我的订单
    			?>
    			<p id='headimg' ><a href='<?php echo $homeurl;?>'><span class="fa fa-home fa-lg"></span></a></p>
        		<p class="ft21">
	        		<?php
	    			echo '订单详情';
	    			?>
    			</p>
       			<p></p>
    			<?php
    		} else if (is_shop()) {
                //商店
    			?>
    			<p id='headimg' ><a href='<?php echo $homeurl;?>'><span class="fa fa-home fa-lg"></span></a></p>
        		<p class="ft21" style="margin-left: 50px;">
	        		<?php
	    			echo '商店';
	    			?>
    			</p>
       			<p><a href='<?php echo $myaccount;?>'><img style="height: 25px;" src='<?php echo CURRENT_TEMPLATE_DIR."/images/my-order.png" ?>'/></a></p>
    			<?php
    		} else if(is_home() || is_front_page()) {
                //我的订单
    			?>
    			<p id='headimg' style="margin-left: 50px;"></p>
        		<p class="ft21" >
	        		<?php
	    			echo get_the_title();
	    			?>
    			 </p>
      			 <p><a href='<?php echo $myaccount;?>'><img style="height: 25px;" src='<?php echo CURRENT_TEMPLATE_DIR."/images/my-order.png" ?>'/></a></p>
    			<?php
    		}
            else{
                ?>
                <p id='headimg' ><a href='<?php echo $homeurl;?>'><span class="fa fa-home fa-lg"></span></a></p>
                <p class="ft21">
                    <?php
                    // echo '商品列表';
                    ?>
                </p>
                <p><a href='<?php echo $myaccount;?>'><img style="height: 25px;" src='<?php echo CURRENT_TEMPLATE_DIR."/images/my-order.png" ?>'/></a></p>
                <?php
            }
        ?> 

	</header>

	<div class="content-wrapper">

	<?php highwind_header_after(); ?>