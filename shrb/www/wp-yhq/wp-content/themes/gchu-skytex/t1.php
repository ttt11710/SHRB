<?php 
//"orderId=".$wechat_orderId;
	$url = "http://bankcomm.paybay.cn/wp-admin/admin-ajax.php";
	$post_data =array('action'=>'flashsale_product_info','id'=>'27');
	send_test($url,$post_data);
	print_r('expression');
	function send_test($url,$post_data){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		// post数据
		curl_setopt($ch, CURLOPT_POST, 1);
		// post的变量
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		$output = curl_exec($ch);
		curl_close($ch);
		print_r('aa');
		return $output;
	}
?>