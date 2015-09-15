<?php
	//this_rul:当前页面url
	//$url:域名
	//$pb_cb:callback地址
	function pb_login_determine($callback_url)
	{
		// print_r($this_url.$url.$pb_cb);
		if(!is_user_logged_in())
		{
			//登入后跳转之前页面
			$url= home_url();
			$url=$url.'/myaccount/'.'?redirect='.$callback_url;
			// print_r($login_url);
			// die;
			header("location:".$url."");
			exit();
		}
	}
?>