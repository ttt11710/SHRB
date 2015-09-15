<?php
/**
 * The page template.
 * @package highwind
 * @since 1.0
 *
 * Template name: Blank
 */
	include_once('public_function.php');
	session_start();
	// print_r($_SESSION);
	if(isset($_POST['user']) || isset($_POST['pwd'])){

		$url = HOME_URL."/wp-admin/admin-ajax.php";
		$post_data = array ("action" => "store_login","store_name" => $_POST['user'],"pwd"=>$_POST['pwd']);
		$a=json_decode(pb_send_var($url,$post_data));
		// print_r($a->status);
		// print_r($a);
		// die;
		if($a->status=='1000'){
			//跳转到页面传递参数
			// $key=md5('paybay123');
			$_SESSION['store_id']= $a->store_id;
			$_SESSION['store_user']= $_POST['user'];
			// print_r($_SESSION);
			header('location: '.HOME_URL.'/validate');
		}
		else{
			echo '账号或者密码错误';
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
	<?php
		$url=plugins_url().'/yhq-ver/';
		// echo $url; 
	?>
	<!--  Mobile viewport optimized: j.mp/bplateviewport -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<script type="text/javascript" src="<?php echo $url; ?>js/zepto.min.js"></script>
		
	<?php wp_head(); ?>

</head>
<style TYPE="text/css">
</style>

<body <?php body_class(); ?>>
<div class="outer-wrap" id="top" style="background: #b5b5b5;" >

			<img style="margin:10px auto;width:320px;" src="<?php echo plugins_url('/yhq-ver/images/logo.jpg'); ?>" />
			<!-- <?php print_r(home_url().'/validate');?> -->
			<div style="width:320px;margin:0 auto;">
				<form method="post" action='#' style="margin:0 !important;background: #fff;padding:30px;" >
					<div>
						<p>用户名：<input type='text' name='user' class="input-text" style="width:70%;padding:0.5em;background: rgba(0, 0, 0, 0.05) !important;"   /></p>
						<p>&nbsp;&nbsp;&nbsp;密码：<input type='password' name='pwd' class="input-text" style="width:70%;padding:0.5em;" /></p>
						<p style="margin-bottom:20px; font-size:15px"><input type="checkbox"/>记住我的登入信息<input style="width:70px !important;padding:10px; !important;margin-left: 15px;" type='submit' value="登录"/><p>
					</div>
				</form>
			</div>
		</div><!-- /.content-wrapper -->


<?php wp_footer(); ?>

</body>
</html>