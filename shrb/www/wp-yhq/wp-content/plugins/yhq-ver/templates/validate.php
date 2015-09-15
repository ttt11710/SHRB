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
if(!isset($_SESSION['store_user']))
{
	//不存在session页面跳转回去
	header("location:".HOME_URL."/validate_log/");
	exit;
}
// print_r($_SESSION);
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
<body <?php body_class(); ?>>
<div class="outer-wrap" id="top" style="background: #b5b5b5;">

	<div class="inner-wrap" style="background: #b5b5b5;">

		<div class="content-wrapper">
			<img style="width:100%" src="<?php echo plugins_url('/yhq-ver/images/login_logo.jpg'); ?>" />
			<form style="text-align: center;margin-top:30px;background: #fff;padding:10px;" id="from_var" >
				<p class="form-row form-row-wide" style="border-bottom: 0px solid #c8c7cc !important;margin:10px 0!important;">
					验证码：<input type="text" id='code' style="background: rgba(0, 0, 0, 0.05) !important;" name='val' placeholder="请输入验证码" />
				</p>
				<p class="form-row form-row-wide" style="border-bottom: 0px solid #c8c7cc !important;margin:10px 0!important;">
					<input style="margin-right:30px" type="button" id='log_out' value='退出' /><input style="margin-left:30px" type="button" id='get_code' value='验证' />
				</p>
				<p><a style="width: 90%;" class="button" href="<?php echo HOME_URL; ?>/report">查看历史订单</a></p>
			</form>

			<div id="yhq_info" style="display:none;background: #fff;padding:10px; margin-top:10px;">
				<p>优惠券名称：<span id='name'></span></p>
				<p>金额：<span id='price'></span></p>
				<p>状态：<span id='status'></span></p>
				<p>订单时间：<span id='time'></span></p>
				<p>数量：<span id='qty'></span></p>
				<input type="hidden" id="order_id" value="" />
				<input type="button" id='user_code' value='使用优惠券' />

			</div>
		</div><!-- /.content-wrapper -->
		
	</div><!-- /.inner-wrap -->
	<script type="text/javascript">
		//查询事件

		var ajax_url="<?php echo admin_url('admin-ajax.php');?>";
		jQuery("#get_code").click(function(){
			// alert('aaa');
			var code=jQuery('#code').val();
			var store_id=<?php echo $_SESSION['store_id']; ?>;
			var yhq_info=jQuery('#yhq_info');
			var name=jQuery('#name');
			var price=jQuery('#price');
			var status=jQuery('#status');
			var time=jQuery('#time');
			var qty=jQuery('#qty');
			var user_code=jQuery('#user_code');
			var order_id=jQuery('#order_id');
			var from_var=jQuery('#from_var');
			console.log(store_id);
			console.log(code);
			console.log(ajax_url);
			jQuery.ajax({
				type:'POST',
				url:ajax_url,
				data:{'action':'verification_yhq','qid':code,'store_id':store_id},
				dataType:'json',
				success:function(data){
					// alert(data);
					console.log(data);
					time.text(data.time);
					name.text(data.name);
					price.text(data.price);
					status.text(data.status);
					qty.text(data.qty);
					order_id.val(data.order_id);
					if(data.code=='1000')
					{	
						yhq_info.show();
						user_code.show();
						from_var.hide();
					}
					else{
						alert('优惠券不可使用');
					}
				}
			});
		});

		//验证事件
		jQuery("#user_code").click(function(){
			var order_id=jQuery('#order_id').val();
			var storename='<?php echo $_SESSION['store_user']; ?>';
			console.log(order_id);
			console.log(storename);
			jQuery.ajax({
				type:'post',
				url:ajax_url,
				data:{'action':'update_yhq','storename':storename,'order_id':order_id},
				dataType:'json',
				success:function(data){
					console.log(data);
					if(data.code=='1000'){
						alert('验证成功');
						location.reload();
					}
					else{
						alert('验证失败');
					}
				}
			});
		});


		//log_out
		jQuery("#log_out").click(function(){
			var url='<?php echo HOME_URL; ?>';
			location.href = url+'/validate_log';
		});
	</script>

</div><!-- /.outer-wrap -->

<?php wp_footer(); ?>

</body>
</html>