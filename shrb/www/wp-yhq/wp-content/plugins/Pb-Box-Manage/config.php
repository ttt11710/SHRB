<?php
	class PB_CODE
	{
		//Activities状态
		public static $CODE_RETURN=array(
			'ACT_RUNING'=>array('code'=>1001,'msg'=>'活动进行中'),
			'ACT_PAYMENT'=>array('code'=>1002,'msg'=>'付款'),
			'ACT_PENDING'=>array('code'=>1003,'msg'=>'活动等待（秒杀）'),
			'ACT_UNSTART'=>array('code'=>1004,'msg'=>'活动未开始'),
			'ACT_END'=>array('code'=>1005,'msg'=>'活动结束'),
			'ACT_PENDING_GROUP'=>array('code'=>1006,'msg'=>'等待开团（团购）'),
			'ACT_END_ROUND'=>array('code'=>1007,'msg'=>'无下轮活动'),
            'ACT_CANCEL'=>array('code'=>1008,'msg'=>'订单取消次数'),
			'ERROR_NO_STOCK'=>array('code'=>1010,'msg'=>'无库存'),
			'ERROR_AGAIN'=>array('code'=>1011,'msg'=>'您已参加过此活动'),
			'ERROR_FULL'=>array('code'=>1012,'msg'=>'人数已满')
		);
		public static $MSG=array(
			'SUCCESS'=>'成功参加活动',
			'FAIL_AGAIN'=>'您已参加过此活动',
			'FAIL_FULL'=>'活动人数已满',
			'FAIL_UNSTART'=>'活动尚未开始',
			'FAIL_END'=>'已售罄',//已售罄(团购)
			'FAIL_NO_STOCK'=>'已售罄',//已售罄(团购)
			'FAIL_FLASHSALE_PAYMENT'=>'此轮秒杀结束',
			'FAIL_FLASHSALE_NOSTART'=>'此轮秒杀结束',
			'FAIL_END_ROUND'=>'无下轮秒杀',
			'FAIL_NO_PRODUCT'=>'商品已售罄',
			'FAIL_FLASHSALE_END'=>'活动已结束',
            'FAIL_ORDER_CANCEL'=>'订单取消次数已达上限'
		);

	}
	class PB_ORDER_STATUS
	{
		public static $PB_ORDER_STATUS=array(
			'PENDING'=>array('status'=>1001,'title'=>'pending'),//
			'BOOKED'=>array('status'=>1002,'title'=>'booked'),//预约
			'PAID'=>array('status'=>1003,'title'=>'paid'),//已付款
			'CANCELLED'=>array('status'=>1004,'title'=>'cancelled'),//已取消
			'UNPAID'=>array('status'=>1005,'title'=>'unpaid')//可以付款，但未付款cancel
		);
	}
	class PB_BOX_CONFIG
	{
		public static $ORDER_LATEST_PAYMENT_TIME_KEY='pb_latest_payment_time';
		
		public static $SEND_SMS_STATUS=array(
			'unsend'=>0,
			'send'=>1,
			'nosend'=>2,
		);
		//$redirpageid=get_page_id('myorder');
	        // $redirpageurl =get_permalink($redirpageid);
		//$send_url="http://biwifi-sanfu.paybay.cn/myorder";
		public static $SEND_SMS_CONTENT='您参加的团购已成团,请点击 http://biwifi-sanfu.paybay.cn/myorder 完成付款!';
		
		//支付状态
		public static $PB_PAYMENT_STATUS=array(
			'success'=>array('pay'=>true,'code'=>'1001','msg'=>''),
			'expired'=>array('pay'=>false,'code'=>'1002','msg'=>'订单已过期'),
			'group_success'=>array('pay'=>true,'code'=>'2001','msg'=>'已达到最低团购价格'),
			'group_success_end'=>array('pay'=>true,'code'=>'2002','msg'=>'已成团,团购活动已结束,但未达到最低价格'),
			'group_success_unmin'=>array('pay'=>false,'code'=>'2003','msg'=>'已成团,但未达到最低团购价'),
			'group_fail_unmin'=>array('pay'=>false,'code'=>'2004','msg'=>'团购活动进行中,但还未成团'),
			'group_fail'=>array('pay'=>false,'code'=>'2005','msg'=>'团购活动已结束,未能成团'),
			
		);
	}


?>