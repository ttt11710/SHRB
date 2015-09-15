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
<!--[if (gt IE 9)|!(IE)]><!--> <html <?php language_attributes(); ?> class="no-js" style="height: 100%;background:#ff5722;"> <!--<![endif]-->
<head>


	<meta charset="<?php bloginfo( 'charset' ); ?>" />

	<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"/>
	<title>Success</title>

	<!--  Mobile viewport optimized: j.mp/bplateviewport -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php remove_action( 'wp_head', 'feed_links', 1 ); remove_action( 'wp_head', 'feed_links_extra', 3 ); //移除feed?>

	<?php wp_head(); ?>

</head>
<style type="text/css">
#header{
	margin-left: 18px;margin-right: 18px;padding: 8px 68px 6px 68px;
}
#header img{
	margin: 0 auto;width: 85%;
}
@media screen and (min-width:396px){
	#header{
		width:360px;
		margin: 0px auto;
		padding: 0px;
	}
	#header img{
		width: 85%;
		margin: 8px auto 6px auto;
	}
}
</style>
<body <?php body_class(); ?> style="background:#ff5722;height: 100%;">
<script type="text/javascript">
    var a='<?php wp_title( '/', true, 'right' ); ?>';
    document.title=a;
</script>
	<header id="header">
        <img style="" src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_salse_title.png" ?>">
	</header>
    <!-- <img style="margin:-1px auto 0 auto;width:3%;" src="<?php echo CURRENT_TEMPLATE_DIR."/images/flash_sales_j.png" ?>"> -->
	<?php highwind_header_after(); ?>