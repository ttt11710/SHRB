<?php
// File Security Check
if ( ! empty( $_SERVER['SCRIPT_FILENAME'] ) && basename( __FILE__ ) == basename( $_SERVER['SCRIPT_FILENAME'] ) ) {
    die ( 'You do not have sufficient permissions to access this page!' );
}
?>
<?php
/**
    Template Name:pay_complete
 */
	get_header();
	global $woo_options;
?>
<style type="text/css">
    #round{
        padding:10px; width:300px; height:50px;
        border: 5px solid #dedede;
        -moz-border-radius: 15px;      /* Gecko browsers */
        -webkit-border-radius: 15px;   /* Webkit browsers */
        border-radius:15px;            /* W3C syntax */
    }
</style>
<div id="round" style="width:290px;height:160px;text-align:center;margin:15px auto;border:2px solid #ccc;">
<p style="font-size:38px;color:blue;font-weight:bold;margin:15px auto 15px auto;">恭喜您！</p>
<p style="font-size:18px;font-weight:bold;">支付已成功，我们将在24小时内为您发货，请注意查收</p>
</div>
<div style='text-align:center;margin-top:15px'>
    <table style='margin:0px auto;'>
        <tr><td colspan="2" style="font-size:18px;font-weight:bold;">您还可以领取下方优惠券</td></tr>
        <tr><td><a href="http://yhqdemo.paybay.cn/p/h4jawxxj"><img src="<?php echo get_template_directory_uri().'/img/gwq.jpg'; ?>"/></a></td><td><a href="http://yhqdemo.paybay.cn/xrniuv3b"><img src="<?php echo get_template_directory_uri().'/img/yhq.jpg'; ?>"/></a></td></tr>
    </table>
</div>
<hr style="width:90%;color:blue;margin-left:auto;margin-right:auto;margin-top:15px;border:1px solid blue;"/>
<div style='text-align:center;margin-top:20px;'>
    <table style='margin:0px auto;'>
        <tr><td colspan="2" style="font-size:18px;font-weight:bold;line-height:3em;">下载交通银行客户端，更多好礼等你拿</td></tr>
        <tr><td rowspan="2"><img src="<?php echo get_template_directory_uri().'/img/jh_logo.jpg'; ?>"/></td><td style="line-height:2em;"><a href="http://s.gchu.cn/yhh9j7cj"><img src="<?php echo get_template_directory_uri().'/img/android_d.jpg'; ?>"/></a></td></tr>
        <tr><td style="line-height:2em;"><a href="https://itunes.apple.com/cn/app/jiao-tong-yin-xing/id337876534?mt=8&uo=4"><img src="<?php echo get_template_directory_uri().'/img/ios_d.jpg'; ?>"/></a></td></tr>
    </table>
</div>