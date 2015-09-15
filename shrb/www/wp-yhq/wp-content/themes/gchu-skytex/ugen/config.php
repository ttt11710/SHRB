<?php
	//配置文件
	// 访问wordpress里面的ajaxURL
	// define("PUBLIC_PB_AJAX_url",'http://192.168.2.92/ubox');//92服务器ip
	// define("PUBLIC_PB_AJAX_url",'http://192.168.2.77/wordpress');//本地
	// define("PUBLIC_PB_AJAX_url",'http://sanfudev.paybay.cn');//外网




	//支付更改http:
	// define("PUBLIC_PB_PAY_MONEY",'http://wx.u-gen.net/pay/Ali/wappay/');//本地测试
	// define("PUBLIC_PB_PAY_MONEY",'http://192.168.2.95/pay/Ali/wappay/');//92测试?
	
	define("PUBLIC_PB_PAY_MONEY",'/myaccount/view-order/');//放到外网


	//图片长度
	define("PRODUCT_IMAGE_HEIGHT",360);
	//图片宽度
	define("PRODUCT_IMAGE_WIDTH",320);


?>