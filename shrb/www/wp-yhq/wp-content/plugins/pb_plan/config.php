<?php
	class PB_PLAN_CONFIG{
		public static $ITEM_TYPE_ARRAY = array(
			array('type'=>'0',
				'title'=>'计划',
				'post_type'=>'',
				'filename'=>'task',
				'topath'=>'/paybay/',
				'toimgpath'=>'/paybay/img/',
				'visible'=>false,
				'format'=>'plan_format',
				'package'=>'net.ugen.ubox.main',
				'ff_section'=>array()
			),
			array('type'=>'1',
				'title'=>'团购',
				'post_type'=>'pb_group',
				'filename'=>'group',
				'topath'=>'/paybay/sanfu/db/',
				'toimgpath'=>'/paybay/sanfu/public/group/img/',
				'visible'=>true,
				'format'=>'default_fortmat',
				'package'=>'net.ugen.ubox.hk.group',
				'ff_section'=>array('pb_group_buy')
			),
			array('type'=>'2',
				'title'=>'秒杀',
				'post_type'=>'pb_flashsale',
				'filename'=>'flashSale',
				'topath'=>'/paybay/sanfu/db/',
				'toimgpath'=>'/paybay/sanfu/public/flashSale/img/',
				'visible'=>true,
				'format'=>'default_fortmat',
				'package'=>'net.ugen.ubox.hk.flashsale',
				'ff_section'=>array('pb_flashSale_buy')
			),
			array('type'=>'3',
				'title'=>'单品',
				'post_type'=>'pb_self_goods',
				'filename'=>'buy',
				'topath'=>'/paybay/sanfu/db/',
				'toimgpath'=>'/paybay/sanfu/public/buy/img/',
				'visible'=>true,
				'format'=>'singel_format',
				'package'=>'net.ugen.ubox.hk.buy',
				'ff_section'=>array('pb_self_product_buy')
			),
			array('type'=>'4',
				'title'=>'富媒体展示',
				'post_type'=>'app',
				'filename'=>'app',
				'topath'=>'paybaymiaosha',
				'toimgpath'=>'/paybay/sanfu/public/app/img/',
				'visible'=>true,
				'format'=>'default_fortmat',
				'package'=>'net.ugen.ubox.hk.app',
				'ff_section'=>array('pb_app')
			)
		);
		
		//商品简要信息所需字段
		public static $PRODUCT_FORMAT_ARRAY = array(
			'pb_product_item'=>'商品货号',
			'pb_product_season'=>'季节',
			'pb_product_series'=>'系列',
			'pb_product_brand'=>'品牌',
			'pb_product_material'=>'材质',
			'pb_product_pattern'=>'图案',
			'pb_product_model'=>'商品型号',
			'pb_product_weight'=>'重量',
			'pb_product_size'=>'尺码',
			'pb_product_color'=>'颜色',
		);
		
		//相册图片大小(手机显示)
		public static $PRODUCT_IMAGE_WIDTH= 360;
		public static $PRODUCT_IMAGE_HEIGHT = 360;
		
		//生成文件地址
		public static $DATA_ROOT_PATH = "/pb_data";
		public static $DATA_DOWNLOAD_FILENAME = "download";
		
		public static $DATA_FILE_SUFFIX = ".json";
	
	
		//计划状态
		public static $PLAN_STATUS = Array(
				"save"=>Array("status"=>0,"title"=>"已保存"),
				"zip"=>Array("status"=>1,"title"=>"已生成"),
				"del"=>Array("status"=>2,"title"=>"已删除")
		);
	
	
		//活动状态
		public static $ITEM_STATUS = Array(
				"save"=>Array("status"=>0,"title"=>"已保存"),
				"del"=>Array("status"=>2,"title"=>"已删除")
		);
			
		
		public static $PRODUCT_ATTRIBUTES = Array("color","size","delivery");
		
		
		public static $XINGE_PUSH_ID = 2100026076;
		public static $XINGE_PUSH_KEY = '24bf039d215d123773eaa9c6fe707b4d';
		
		
		//日志操作类型 create 生成 push 推送 download 下载
		public static $LOG_ACTION_TYPE = Array(
				"create"=>0,
				"push"=>1,
				"download"=>2
		);
		
		//计划状态
		/*
		public static $PLAN_STATUS_SAVE = 0;	//保存
		public static $PLAN_STATUS_ZIP = 1;		//打包
		public static $PLAN_STATUS_DEL = 2;		//删除
		
		//活动状态
		public static $ITEM_STATUS_SAVE = 0;	//保存
		public static $ITEM_STATUS_DEL = 2;		//删除
		*/
	
	}

?>