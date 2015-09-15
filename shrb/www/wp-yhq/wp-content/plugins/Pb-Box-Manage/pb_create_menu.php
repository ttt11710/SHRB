<?php
	class PB_MENU_CONFIG
	{
		public static $MENU=array(
			'box'=>array('post_type'=>'pb_box',
				'isshow'=>true,
				'title'=>'盒子',
                'post_attr'=>array('public'=>true,'show_ui'=>true,'show_in_menu'=>false,'supports' => array( 'title', 'excerpt' )),
                'menu_name'=>'盒子列表',
                'parent_name'=>'pb_box',
				'sections'=>array(
					array('section'=>'pb_box_store','title'=>'盒子','fields'=>array('pb_box_select','pb_equipment_id','pb_push_secret_key'))
				)
			),
			'store'=>array('post_type'=>'pb_store',
				'isshow'=>true,
				'title'=>'门店',
                'post_attr'=>array('public'=>true,'show_ui'=>true,'show_in_menu'=>false,'supports' => array( 'title', 'excerpt','editor', 'thumbnail', 'custom-fields','page-attributes','comments') ),
                'menu_name'=>'门店列表',
                'parent_name'=>'pb_box',
				'sections'=>array()
			),
			'group'=>array('post_type'=>'pb_group',
				'isshow'=>true,
				'title'=>'团购',
                'post_attr'=>array('public'=>true,'show_ui'=>true,'show_in_menu'=>false,'supports' => array( 'title', 'excerpt' )),
                'menu_name'=>'团购活动',
                'parent_name'=>'pb_group',
				'sections'=>array(
					array('section'=>'pb_group_buy',
						'title'=>'团购',
						'fields'=>array('pb_select_product',array('group'=>'pb_group_ladder_grouping','fields'=>array('pb_group_ladder_people','pb_group_ladder_price')),'pb_max_group_people','pb_start_time','pb_end_time','pb_latest_payment_time')
					)
				)
			),
			'flashSale'=>array("post_type"=>"pb_flashsale",
				'isshow'=>true,
				'title'=>'秒杀',
                'post_attr'=>array('public'=>true,'show_ui'=>true,'show_in_menu'=>false, 'supports' => array( 'title', 'excerpt' )),
                'menu_name'=>'秒杀活动',
                'parent_name'=>'pb_group',
				'sections'=>array(
					array('section'=>'pb_flashSale_buy',
					'title'=>'秒杀',
					'fields'=>array('pb_select_product','pb_commodity_quantity','pb_flashSale_price','pb_start_time','pb_one_flashSale_end_time','pb_one_flashSale_end_payment_time','pb_flashSale_time_interval','pb_end_time','pb_flashSale_time_duration','pb_flashSale_time_payment','pb_flashSale_frequency'))
				)
			),
			'application'=>array("post_type"=>"app",
				'isshow'=>true,
				'title'=>'应用',
				'post_attr'=>array('public'=>true,'show_ui'=>true,'show_in_menu'=>false,'supports' => array( 'title', 'excerpt' )),
				'menu_name'=>'富媒体展示',
				'parent_name'=>'pb_group',
				'sections'=>array(
					array('section'=>'pb_app',
					'title'=>'app应用',
					'fields'=>array('app_package',array('group'=>'pb_group_parameter_grouping','fields'=>array('app_parameter_key','app_parameter_value')),'pb_start_time','pb_end_time'))
				)
			),
			'sale'=>array("post_type"=>"pb_self_goods",
				'isshow'=>true,
				'title'=>'自助商品',
				'post_attr'=>array('public'=>true,'show_ui'=>true,'show_in_menu'=>false,'supports' => array( 'title', 'excerpt' )),
				'menu_name'=>'自助商品购买',
                'parent_name'=>'pb_group',
				'sections'=>array(
					array('section'=>'pb_self_product_buy',
					'title'=>'自助商品',
					'fields'=>array('pb_select_self_product','pb_start_time','pb_end_time','pb_latest_payment_time','pb_self_product_interval_time'))
				)
			),
			'product'=>array("post_type"=>"product",
				'isshow'=>false,
				'sections'=>array(
					array('section'=>'pb_large_screen_img',
						'title'=>'大屏幕显示图片',
						'fields'=>array('pb_large_screen_img_array'),
					),
					array('section'=>'pb_wc_product_property',
						'title'=>'商品',
						'fields'=>array('pb_product_item','pb_product_season','pb_product_series','pb_product_brand','pb_product_material','pb_product_pattern','pb_product_model','pb_product_weight','pb_product_size','pb_product_color')
					)
				)
			),
			
			
		);
	}
	
	//添加所需菜单
	function pb_create_menu_init(){
		foreach(array_keys(PB_MENU_CONFIG::$MENU) as $key){
			$menu = PB_MENU_CONFIG::$MENU[$key];
			if($menu['isshow']){
                $labels=array(
                    'name' => $menu['title'],
                    'add_new' => '添加',
                    'add_new_item' => '添加'.$menu['title'],
                    'edit' => '编辑',
                    'edit_item' => '编辑'.$menu['title'],
                    'new_item' => '新'.$menu['title'],
                    'view' => '预览',
                    'view_item' => '预览',
                    'search_items' => '搜索'.$menu['title'],
                    'not_found' => '未找到',
                    'not_found_in_trash' => '垃圾站中暂无'.$menu['title'],
                );
                $args=array( 'labels' => $labels,
                            'public'=>true,
                            'description' => $menu['title'],
                            'exclude_from_search' => true,
                            'supports' => $menu['supports'],
                            'has_archive' => $menu['title'], // 归档别名
                            'rewrite' => array( 'slug' =>$menu['post_type'],
                ));
                foreach($menu['post_attr'] as $key=>$value)
                {
                    if(isset($menu['post_attr'][$key]))
                    {
                        $args[$key]=$value;
                    }
                }
				register_post_type($menu['post_type'], $args);
			}
			if(count($menu['sections']) > 0){
				foreach($menu['sections'] as $section){
				//	print_r($section);
					ff_create_section($section['section'], 'post', array(
							'title' => $section['title'],
							'post_types' => array($menu['post_type']),
						)
					);
					foreach($section['fields'] as $field){
						if(is_array($field)){
							foreach($field['fields'] as $groupField){
								ff_add_field_to_field_group($field['group'], $groupField);
							}
							ff_add_field_to_section($section['section'],$field['group']);
						}
						else if(is_string($field)){
							ff_add_field_to_section($section['section'],$field);
						}
					}
				}
			}
		}
	}
    function pb_add_diy_menu() {
        add_menu_page(__('活动'),__('活动'),'administrator', 'edit.php?post_type='.PB_MENU_CONFIG::$MENU['group']['post_type'], '','', 8);
        add_menu_page(__('门店与盒子'),__('添加门店与盒子'),'administrator', 'edit.php?post_type='.PB_MENU_CONFIG::$MENU['box']['post_type'], '','', 7);
        foreach(array_keys(PB_MENU_CONFIG::$MENU) as $key){
            $menu = PB_MENU_CONFIG::$MENU[$key];
            if($menu['isshow']){
                add_submenu_page('edit.php?post_type='.$menu['parent_name'],$menu['title'],$menu['menu_name'],9,'edit.php?post_type='.$menu['post_type'],'');
            }
        }
    }
	
?>