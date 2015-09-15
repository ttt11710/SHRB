<?php
/**
 * The page template.
 * @package highwind
 * @since 1.0
 *
 * Template name: Blank
 */
global $wpdb;
include_once('public_function.php');
session_start();
if(!isset($_SESSION['store_user']))
{
	//不存在session页面跳转回去
	header("location:".home_url()."/validate_log/");
	exit;
}

$all_count=$wpdb->get_results("select count(*) as all_count from wp_posts 
	left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id 
	where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name' and wp_postmeta.meta_value='".$_SESSION['store_user']."';");
$stime;
$etime;
if(isset($_POST['stime']) || isset($_POST['etime'])){
	$stime=$_POST['stime'];
	$etime=$_POST['etime'];
}
else{
	$stime=date('Y-m-d');
	$etime=date('Y-m-d');
}
// print_r("select wp_posts.ID,wp_postmeta.meta_value from wp_posts
// left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id
// where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name' and wp_postmeta.meta_value='".$_SESSION['store_user']."';");
$stoe_name=$wpdb->get_results($wpdb->prepare("select wp_posts.ID,wp_postmeta.meta_value from wp_posts
left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id
where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='store_name' and wp_postmeta.meta_value='".$_SESSION['store_user']."';"),ARRAY_A);
//查询订单时间
$store_time=$wpdb->get_results("select wp_posts.ID,wp_postmeta.meta_value from wp_posts 
	left join wp_postmeta on wp_posts.ID=wp_postmeta.post_id 
	where wp_posts.post_type='shop_order' and wp_postmeta.meta_key='_completed_date' 
	and meta_value between '".$stime." 00:00:00' and '".$etime." 23:59:59' 
	group by wp_postmeta.meta_value ;",ARRAY_A);
// print_r($stoe_name);
// print_r($store_time);
$newstore=array();
foreach ($stoe_name as $key=>$value) {
	// print_r($value);
	foreach ($store_time as $time) {
		if($value['ID']==$time['ID'])
		{
			$newstore[$key]['id']=$value['ID'];
			$order = new WC_Order($value['ID']);
			$items=$order->get_items();
			$order_name=null;
			foreach ($items as $it) {
				$order_name=$it['name'];
				$product_id=$it['product_id'];
			}
			$newstore[$key]['name']=$order_name;
			$newstore[$key]['time']=$time['meta_value'];
		}
	}
}
?>

<?php
if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly
?>

<!doctype html><!--[if lt IE 7 ]> <html <?php language_attributes(); ?> class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html <?php language_attributes(); ?> class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html <?php language_attributes(); ?> class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html <?php language_attributes(); ?> class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html <?php language_attributes(); ?> class="no-js" style="background: #b5b5b5;"> <!--<![endif]-->
<head>

	<meta charset="<?php bloginfo( 'charset' ); ?>" />

	<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<title><?php echo $title; ?></title>

	<!--  Mobile viewport optimized: j.mp/bplateviewport -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- <?php print_r(YHQ_VALIDATE); ?> -->

	<?php wp_head(); ?>

</head>
<style TYPE="text/css">
/*div{
	border:1px solid red;
}*/
td{
	vertical-align:middle; 
	text-align:center;
}
</style>
<body <?php body_class(); ?>>
<div class="outer-wrap" id="top" style="background: #b5b5b5;">

	<div class="inner-wrap" style="background: #b5b5b5;">
		<img style="width:100%" src="<?php echo plugins_url('/yhq-ver/images/login_logo.jpg'); ?>" />
		
		<div class="content-wrapper" style="margin-top:10px;background: #fff;padding: 10px;">
			<p>当前用户：<?php echo $_SESSION['store_user']; ?></p>
			<p><span>当前验证数量：<?php echo count($newstore); ?></span><span style="margin-left:30px">累计验证数量：<?php echo $all_count[0]->all_count; ?></span></p>
			<section class="content" role="main">
				<form action="#" method="post">
					<input type="date" name='stime' value="<?php echo $stime; ?>" >&nbsp;&nbsp;至&nbsp;&nbsp;<input type="date" name='etime' value="<?php echo $etime; ?>" >&nbsp;&nbsp;<input type='submit' value='筛选'>
				</form>
				<table border="1">
					<tr><td>订单号</td><td>优惠券名称</td><td>验证时间</td><td>数量</td></tr>
					<?php 
						foreach ($newstore as $value) {
							echo "<tr><td>".$value['id']."</td><td>".$value['name']."</td><td>".$value['time']."</td><td>1</td></tr>";
						}
					?>
				</table>	
				<p>统计时间：<?php echo $stime.'至'.$etime; ?></p>
				<a href="<?php echo HOME_URL; ?>/validate">返回</a>
			</section><!-- /.content -->
	
		</div>
	</div><!-- /.inner-wrap -->
</div><!-- /.outer-wrap -->

<?php wp_footer(); ?>

</body>
</html>