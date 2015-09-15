<?php
	function pb_box_fff_fields_framework() 
	{
        
        //团购人数和价格的分组
        // ff_create_field('pb_group_test', 'group', array(
        //         'id' => 5,
        //         'label' => '团购人数',
        //         'repeatable' => true,
        //     )
        // );
        //人数与价格数组
        // ff_create_field('number_of_people', 'select', array(
        //         'label' => '人数',
        //         'options' => array('10' => '50', '20' => '45', '30' => '40'),
        //         'repeatable' => true,
        //     )
        // );
        //阶梯价格人数的输入框
        ff_create_field('pb_group_ladder_people', 'text', array(
                'label' => '人数',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //阶梯价格输入框
        ff_create_field('pb_group_ladder_price', 'text', array(
                'label' => '团购价格',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //阶梯价格分组
        ff_create_field('pb_group_ladder_grouping', 'group', array(
                'label' => '参团人数价格',
                'repeatable' => true,
            )
        );


        //搜索商品，已经有搜索商品自定义插件暂不需要
        ff_create_field('pb_select_product', 'select_posts', array(
                'label' => '商品列表',
                // 'parameters' => array('post_type' => 'product'),
                'parameters' => 'post_type=product&posts_per_page=-1',
            )
        );

        //最大团购人数
        ff_create_field('pb_max_group_people', 'text', array(
                'label' => '最大团购人数',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );        

        //开始时间控件
	    ff_create_field('pb_start_time', 'datetime', array(
	            'label' => '活动开始时间',
	            'date_format' => 'yy/mm/dd',
	            'time_format' => 'HH:mm:ss',
                'default_value' => date('Y/m/d 00:00:00',time()),
                'validator' => array('validation-engine' => 'validate[required]'),
	        )
	    );
	    //结束时间
	    ff_create_field('pb_end_time', 'datetime', array(
	            'label' => '活动结束时间',
	            'date_format' => 'yy/mm/dd',
	            'time_format' => 'HH:mm:ss',
                'default_value' => '2020/12/31 00:00:00',
                'validator' => array('validation-engine' => 'validate[required]'),
	        )
	    );
	    //付款时间
	    ff_create_field('pb_latest_payment_time', 'datetime', array(
	            'label' => '最晚付款时间',
	            'date_format' => 'yy/mm/dd',
	            'time_format' => 'HH:mm:ss',
                'validator' => array('validation-engine' => 'validate[required]'),
	        )
	    );
	    //定时任务
	    // ff_create_field('pb_timing_task', 'datetime', array(
	    //         'label' => '定时任务',
	    //         'date_format' => 'yy/mm/dd',
	    //         'time_format' => 'hh:mm:ss',
	    //     )
	    // );
        //秒杀
        ff_create_field('pb_commodity_quantity', 'text', array(
                'label' => '商品数量',
            )
        );
        ff_create_field('pb_flashSale_price', 'text', array(
                'label' => '秒杀价格',
            )
        );
        
        // ff_create_field('pb_flashSale_time_duration', 'text', array(
        //         'label' => '秒杀持续时间（分钟）',
        //         'validator' => array('validation-engine' => 'validate[required]'),
        //     )
        // );
        // ff_create_field('pb_flashSale_time_payment', 'text', array(
        //         'label' => '付款持续时间（分钟）',
        //         'validator' => array('validation-engine' => 'validate[required]'),
        //     )
        // );
        ff_create_field('pb_flashSale_time_interval', 'text', array(
                'label' => '间隔时间（上轮秒杀付款结束时间到下轮开始时间）单位：分钟',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        // //第一轮秒杀开始时间
        // ff_create_field('pb_one_flashSale_start_time', 'datetime', array(
        //         'label' => '秒杀开始时间(第一轮)',
        //         'date_format' => 'yy/mm/dd',
        //         'time_format' => 'HH:mm:ss',
        //         'validator' => array('validation-engine' => 'validate[required]'),
        //     )
        // );
        //第一轮秒杀结束时间
        ff_create_field('pb_one_flashSale_end_time', 'datetime', array(
                'label' => '秒杀结束时间(第一轮)',
                'date_format' => 'yy/mm/dd',
                'time_format' => 'HH:mm:ss',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //第一轮秒杀付款时间
        ff_create_field('pb_one_flashSale_end_payment_time', 'datetime', array(
                'label' => '最后付款时间(第一轮)',
                'date_format' => 'yy/mm/dd',
                'time_format' => 'HH:mm:ss',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );

        //秒杀时长
        ff_create_field('pb_flashSale_time_duration', 'hidden', array(
                'name' => 'pb_flashSale_time_duration',
            )
        );
        //付款时长
        ff_create_field('pb_flashSale_time_payment', 'hidden', array(
                'name' => 'pb_flashSale_time_payment',
            )
        );
        //秒杀轮数
        ff_create_field('pb_flashSale_frequency', 'hidden', array(
                'name' => 'pb_flashSale_frequency',
            )
        );



        //盒子
        //搜索下拉框
        ff_create_field('pb_box_select', 'select_posts', array(
                'id' => 88,
                'label' => '选择门店',
                'parameters' => array('post_type' => 'pb_store'),
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //设备编号输入框
        ff_create_field('pb_equipment_id', 'text', array(
                'id' => 10,
                'label' => '设备编号',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //秘钥
        ff_create_field('pb_push_secret_key', 'hidden', array(
                'default_value' => 0,
                'name' => 'pb_push_secret_key',
            )
        );

        //大屏幕显示图片
        ff_create_field('pb_large_screen_img_array', 'media', array(
                'label' => '大屏幕显示图片',
                'repeatable' => true,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );

        //自助商品价格
        ff_create_field('pb_self_product_price', 'text', array(
                'label' => '商品价格',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //单个商品列表
        ff_create_field('pb_select_self_product', 'select_posts', array(
                'label' => '商品列表',
                'parameters' => 'post_type=product&posts_per_page=-1',
                'repeatable' => true,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //自助商品列表与价格
        ff_create_field('pb_self_product_group', 'group', array(
                'label' => '自助商品列表与价格',
                'repeatable' => true,
            )
        );
        //展示商品间隔时间
        ff_create_field('pb_self_product_interval_time', 'text', array(
                'label' => '自助商品展示间隔时间(分钟)',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );



        //wc商品属性
        //商品货号
        ff_create_field('pb_product_item', 'text', array(
                'label' => '商品货号',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //季节
        ff_create_field('pb_product_season', 'text', array(
                'label' => '季节',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        //系列series
        ff_create_field('pb_product_series', 'text', array(
                'label' => '系列',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );     
        //品牌brand
        ff_create_field('pb_product_brand', 'text', array(
                'label' => '品牌',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );   
        //材质material
        ff_create_field('pb_product_material', 'text', array(
                'label' => '材质',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );   
        //图案pattern  
        ff_create_field('pb_product_pattern', 'text', array(
                'label' => '图案',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );   
        //商品型号model
        ff_create_field('pb_product_model', 'text', array(
                'label' => '商品型号',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );  
        //重量weight  
        ff_create_field('pb_product_weight', 'text', array(
                'label' => '重量',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );  
        //尺码SIZE 
        ff_create_field('pb_product_size', 'text', array(
                'label' => '尺码',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );  
        //颜色COLOR
        ff_create_field('pb_product_color', 'text', array(
                'label' => '颜色',
                'repeatable' => false,
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );

        //app应用
        ff_create_field('pb_video', 'media', array(
                'id' => 'video',
                'label' => '视频',
            )
        );
        ff_create_field('app_package', 'text', array(
                'id' => 'package',
                'label' => '应用包名',
            )
        );
        ff_create_field('app_parameter_key', 'text', array(
                'id' => 'parameter_key',
                'label' => '应用参数名称',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        ff_create_field('app_parameter_value', 'text', array(
                'id' => 'parameter_value',
                'label' => '应用参数值',
                'validator' => array('validation-engine' => 'validate[required]'),
            )
        );
        ff_create_field('pb_group_parameter_grouping', 'group', array(
                'label' => '应用参数名称和值',
                'repeatable' => true,
            )
        );




	}
?>