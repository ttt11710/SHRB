<?php
	include_once('config.php');
	//开始时间，结束时间，次数，秒杀持续时间，秒杀付款时间，2次秒间隔时间
	function pb_check_time($flashSale_start_time,$flashSale_end_time,$flashSale_frequency,$flashSale_time_duration,$flashSale_time_payment,$flashSale_time_interval)
	{
		// print_r(strtotime("+5".$kill_time_duration." minutes");
		// print_r(strtotime("+20 minutes")-date(time()));
		// return PB_KILL_CONFIG::$KILL_ORDER_RETURN['SUCCESS'];
		// print_r(strtotime(current_time('mysql')).'|');

		// print_r(current_time('timestamp').'|');
		// print_r(time().'|');
		// print_r(date('Y-m-d H:i:s',time()).'|');
		// print_r(date('Y-m-d H:i:s',current_time('timestamp')));
		// print_r(current_time('timestamp').'-'.strtotime($flashSale_end_time).'=====');
		// print_r(date('Y-m-d H:i:s',current_time('timestamp')).'-'.$flashSale_end_time);
		$status_code=null;
		if(current_time('timestamp')<strtotime($flashSale_start_time))
		{
			$status_code=PB_CODE::$CODE_RETURN['ACT_UNSTART'];//秒杀未开始'
			return $status_code;
		}
		if(current_time('timestamp')>strtotime($flashSale_end_time))
		{
			$status_code=PB_CODE::$CODE_RETURN['ACT_END'];//'秒杀已结束'
			return $status_code;
		}
		$time=strtotime($flashSale_start_time);
		if(current_time('timestamp')>($time+($flashSale_time_payment+$flashSale_time_duration+$flashSale_time_interval*60)*$flashSale_frequency))
		{
			$status_code=PB_CODE::$CODE_RETURN['ACT_END_ROUND'];//无轮数
			return $status_code;
		}
		// print_r(date('Y-m-d H:i:s',strtotime($flashSale_start_time)+600));
		for($i=1;$i<=$flashSale_frequency;$i++)
		{
			//开始秒杀
			$time=$time+$flashSale_time_duration;
			if(current_time('timestamp')<$time)
			{
				$status_code=PB_CODE::$CODE_RETURN['ACT_RUNING'];//秒杀成功
				$status_code['round']=$i;
				break;
			}
			// echo date("Y-m-d H:i:s", $time).'->';
			//付款
			$time=$time+($flashSale_time_payment);
			if(current_time('timestamp')<$time)
			{
				$status_code=PB_CODE::$CODE_RETURN['ACT_PAYMENT'];//此轮秒杀结束
				$status_code['round']=$i;
				break;
			}
			// echo date("Y-m-d H:i:s", $time).'->';
			//秒杀间隔时间
			$time=$time+($flashSale_time_interval*60);
			if(current_time('timestamp')<$time)
			{
				$status_code=PB_CODE::$CODE_RETURN['ACT_PENDING'];//'下轮秒杀未开始'
				$status_code['round']=$i;
				break;
			}
			// echo date("Y-m-d H:i:s", $time).'-------->';
		}
		return $status_code;

	}

	//添加订单(商品id，活动价格，活动id，用户id，活动类型，订单状态)
	function createOrder($pb_variation_id,$pb_activity_price,$activity_id,$uid,$activity_type,$order_status,$latest_payment_time)
	{
		$_product = get_product($pb_variation_id);
		// print_r($_product->variation_id);
		// die();
		$item = array();
		//商品id 
		$item['product_id']        = $_product->variation_id;
		$item['variation_id']      = isset( $_product->variation_id ) ? $_product->variation_id : '';
		$item['variation_data']    = isset( $_product->variation_data ) ? $_product->variation_data : '';
		$item['name']              = $_product->get_title();
		$item['tax_class']         = $_product->get_tax_class();
		$item['qty']               = 1;
		$item['line_subtotal']     = wc_format_decimal( $_product->get_price_excluding_tax() );
		$item['line_subtotal_tax'] = '';
		//价格需要根据团购人数获取价格
		$item['line_total']        = $pb_activity_price;
		$item['line_tax']          = '';
		$item[$activity_type]      = $activity_id;
		//      实例化订单对象
		$checkout = new WC_Checkout();
		$order_id = $checkout->create_order();
		$order = new WC_Order( $order_id );
		// 创建订单item
		$item_id = wc_add_order_item( $order_id, array(
			'order_item_name'       => $item['name'],
			'order_item_type'       => 'line_item'
		));
//        print_r($order->get_items());
//        $cartid=array_keys($order->get_items());
//        print_r($cartid[0]);
//        wc_delete_order_item($cartid[0]);
//        print_r($cartid);
		//      增加订单子商品信息
		if ($item_id) 
		{
			wc_add_order_item_meta( $item_id, '_qty', $item['qty'] );
			wc_add_order_item_meta( $item_id, '_tax_class', $item['tax_class'] );
			wc_add_order_item_meta( $item_id, '_product_id', $item['product_id'] );
			wc_add_order_item_meta( $item_id, '_variation_id', $item['variation_id'] );
			wc_add_order_item_meta( $item_id, '_line_subtotal', $item['line_subtotal'] );
			wc_add_order_item_meta( $item_id, '_line_subtotal_tax', $item['line_subtotal_tax'] );
			wc_add_order_item_meta( $item_id, '_line_total', $item['line_total'] );
			wc_add_order_item_meta( $item_id, '_line_tax', $item['line_tax'] );
			wc_add_order_item_meta( $item_id, '_'.$activity_type, $item[$activity_type] );
			//将团购id与order_id进行关联
			if ( $item['variation_data'] && is_array( $item['variation_data'] ) ) 
			{
				foreach ( $item['variation_data'] as $key => $value ) {
					wc_add_order_item_meta( $item_id, str_replace( 'attribute_', '', $key ), $value );
				}
			}
		}
		// 修改订单状态
		// print_r($order);
		$order->update_status( $order_status );
		// $order->update_status( 'completed' );
		// 修改商品库存
		$order->reduce_order_stock();
		// 修改订单总金额
		// 由于订单总金额是根据，子商品金额、运费、税收等计算而来，所以这里就直接更改了
		update_post_meta( $order->id, '_order_total',  $item['line_total'] );
		//需要加入用户id
		update_post_meta($order->id,'_customer_user',$uid);
		add_post_meta($order->id,'_'.PB_BOX_CONFIG::$ORDER_LATEST_PAYMENT_TIME_KEY.'',$latest_payment_time);
		// add_post_meta( $order->id, '_group_id', $item['group_id'] );
		// print_r($order->id);
		// echo "==create ok=";
		return $order;
	}
	//根据订单状态查询参与团购活动人数
	function pb_select_activity_people($pb_activity_id,$activity_type,$order_status)
	{
		global $wpdb;
//		$condition='(wp_terms.name = ';
//		for($i=0;$i<count($order_status);$i++)
//		{
//
//			if($i==0)
//			{
//				$condition=$condition."'".$order_status[$i]."'";
//			}
//			else
//			{
//				$condition=$condition.' or wp_terms.name ='."'".$order_status[$i]."'";
//			}
//		}
//		$condition=$condition.')';
        $condition='wp_terms.name !='."'".$order_status[0]."'".'' ;
		$pb_activity_people=$wpdb->get_var("SELECT count(*) FROM wp_woocommerce_order_items "
			."left join wp_woocommerce_order_itemmeta ON (wp_woocommerce_order_itemmeta.order_item_id = wp_woocommerce_order_items.order_item_id) " 
			."left JOIN wp_term_relationships ON (wp_term_relationships.object_id = wp_woocommerce_order_items.order_id) " 
			."left join wp_terms ON (wp_terms.term_id = wp_term_relationships.term_taxonomy_id) "
			."where wp_woocommerce_order_itemmeta.meta_key = '_{$activity_type}' and wp_woocommerce_order_itemmeta.meta_value = '{$pb_activity_id}' and ".$condition);
        $pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $pb_activity_id);
        //最大人数
        if($pb_post_data['pb_max_group_people']<7){
            $pb_activity_people=$pb_post_data['pb_max_group_people'];
        }
        else
        {
            $pb_activity_people+=7;
        }
		return $pb_activity_people;
	}
	//根据秒杀开始时间查询参与活动有效人数
	function pb_select_flashSale_people($pb_activity_id,$activity_type,$this_start_time)
	{
		global $wpdb;
		$condition='((wp_terms.name = ';
		$condition=$condition."'".PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title']."'and wp_postmeta.meta_value>{$this_start_time})";
		$condition=$condition.' or wp_terms.name ='."'".PB_ORDER_STATUS::$PB_ORDER_STATUS['PAID']['title']."'";
		$condition=$condition.')';
		$pb_activity_people=$wpdb->get_var($wpdb->prepare("SELECT "
										    ."count(*) "
										."FROM "
										    ."wp_woocommerce_order_items "
										        ."left join "
										    ."wp_woocommerce_order_itemmeta ON (wp_woocommerce_order_itemmeta.order_item_id = wp_woocommerce_order_items.order_item_id) "
										       ." left JOIN "
										    ."wp_term_relationships ON (wp_term_relationships.object_id = wp_woocommerce_order_items.order_id) "
										        ."left join "
										    ."wp_terms ON (wp_terms.term_id = wp_term_relationships.term_taxonomy_id) "
												."left join "
											."wp_postmeta on (wp_woocommerce_order_items.order_id=wp_postmeta.post_id) "
										."where "
										    ."wp_woocommerce_order_itemmeta.meta_key = '_{$activity_type}' "
										        ."and wp_woocommerce_order_itemmeta.meta_value = '{$pb_activity_id}' "
												."and wp_postmeta.meta_key='_pb_latest_payment_time' "
										        ."and ".$condition.""));
		return $pb_activity_people;
	}
	//获取最晚付款时间
	function pb_get_latest_payment_time($round,$pb_post_data)
	{
		$state_time=strtotime($pb_post_data['pb_start_time']);
		$one_time=$pb_post_data['pb_flashSale_time_duration']+$pb_post_data['pb_flashSale_time_payment']+$pb_post_data['pb_flashSale_time_interval']*60;
		$latest_payment_time=$state_time+$one_time*($round)-$pb_post_data['pb_flashSale_time_interval']*60;
		return $latest_payment_time;
	}
	//获取此轮开始时间
	function pb_get_this_round_start_time($round,$pb_post_data)
	{
		$state_time=strtotime($pb_post_data['pb_start_time']);
		$one_time=$pb_post_data['pb_flashSale_time_duration']+$pb_post_data['pb_flashSale_time_payment']+$pb_post_data['pb_flashSale_time_interval']*60;
		$this_round_start_time=$state_time+$one_time*($round-1);
		return $this_round_start_time;
	}
	//查询用户是否参加过活动
	function pb_select_group_user($pb_activity_id,$uid,$activity_type,$order_status)
	{
		//获得用户
		global $wpdb;
		//查询用户试过参加过活动	
		$condition='(wp_terms.name = ';
		for($i=0;$i<count($order_status);$i++)
		{
			
			if($i==0)
			{
				$condition=$condition."'".$order_status[$i]."'";
			}
			else
			{
				$condition=$condition.' or wp_terms.name ='."'".$order_status[$i]."'";
			}
		}
		$condition=$condition.')';
		$pb_activity_opportunity=$wpdb->get_var($wpdb->prepare("SELECT count(*) from wp_woocommerce_order_items left join wp_postmeta ON (wp_postmeta.post_id = wp_woocommerce_order_items.order_id) left JOIN wp_woocommerce_order_itemmeta ON (wp_woocommerce_order_items.order_item_id = wp_woocommerce_order_itemmeta.order_item_id) left join wp_term_relationships ON (wp_term_relationships.object_id = wp_woocommerce_order_items.order_id) left JOIN wp_terms ON (wp_terms.term_id = wp_term_relationships.term_taxonomy_id) where wp_postmeta.meta_key = '_customer_user' and wp_postmeta.meta_value = {$uid} and wp_woocommerce_order_itemmeta.meta_key = '_{$activity_type}' and wp_woocommerce_order_itemmeta.meta_value = '{$pb_activity_id}' and ".$condition.""));
		return $pb_activity_opportunity;
	}
	//根据团购人数获得实际团购价格
	function pb_selsct_groupPrice($price_array,$pb_people)
	{
		$pb_group_price=$price_array[0]['pb_group_ladder_price'];
		for($i=count($price_array)-1;$i>=0;$i--)
		{
			if($pb_people>=$price_array[$i]['pb_group_ladder_people'])
			{
				$pb_group_price=$price_array[$i]['pb_group_ladder_price'];
				break;
			}
		}
		return $pb_group_price;
	}
	//获取商品子id
	function getChildProductAttribute($pb_stock,$pb_color,$pb_size,$pb_mode)
	{
        $stock=array();
		foreach ($pb_stock as $value) 
		{
			if(strtoupper($pb_color)==strtoupper(urldecode($value['attributes']['attribute_color'])) && strtoupper($pb_size)==strtoupper(urldecode($value['attributes']['attribute_size']))  && strtoupper($pb_mode)==strtoupper(urldecode($value['attributes']['attribute_delivery'])))
			{
                $stock= $value;
			}
		}
        if(count($pb_stock)==1 && empty($stock))
        {

            $stock= -1;
        }
        else if(empty($stock))
        {
            $stock= -2;
        }
        return $stock;
	}
	//审核是否可以团购付款
	function pb_check_group_order_payment($order,$active_id)
	{
		//团购信息
		$pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $active_id);
		$pb_people=array();
		$pb_group_type=count($pb_post_data['pb_group_ladder_grouping']);
		foreach ($pb_post_data['pb_group_ladder_grouping'] as $value) {
			$pb_people[]=$value['pb_group_ladder_people'];
		} 
		$max_num = max($pb_people);
		$min_num = min($pb_people);
		$group_num = pb_select_activity_people($active_id,PB_MENU_CONFIG::$MENU['group']['post_type'],array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
		//print_r($group_num);
		if($group_num >= $max_num){
			// 已到最低价
			return PB_BOX_CONFIG::$PB_PAYMENT_STATUS['group_success'];
		}
		if(current_time('timestamp') > strtotime($pb_post_data['pb_end_time']))
		{
			if($group_num >= $min_num){
				//已成团,但未到最低价,活动已结束,可付款
				return PB_BOX_CONFIG::$PB_PAYMENT_STATUS['group_success_end'];
			}
			else{
				//未成团,不可付款
				//$order->update_status(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']);
				pb_cancelUnpaidOrder($order);
				return PB_BOX_CONFIG::$PB_PAYMENT_STATUS['group_fail'];
			}
		}
		else{
			if($group_num >= $min_num){
				//已成团,但未到最低价,活动进行中,不可付款
				return PB_BOX_CONFIG::$PB_PAYMENT_STATUS['group_success_unmin'];
			}
			else{
				//还未成团,活动进行中,不可付款
				return PB_BOX_CONFIG::$PB_PAYMENT_STATUS['group_fail_unmin'];
			}
		}
		return false;
	}
    //审核订单能否付款（订单id）
	function pb_check_order_payment($order_id)
	{
		$latest_payment_time_arr = get_post_meta($order_id,'_'.PB_BOX_CONFIG::$ORDER_LATEST_PAYMENT_TIME_KEY);
		$order_payment_status=PB_BOX_CONFIG::$PB_PAYMENT_STATUS['success'];
		if(count($latest_payment_time_arr)>0)
		{
			$order = new WC_Order($order_id);
			$latest_payment_time = $latest_payment_time_arr[0];
			if(current_time('timestamp')>$latest_payment_time)
			{
				//$order->update_status(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']);
				pb_cancelUnpaidOrder($order);
				$order_payment_status=PB_BOX_CONFIG::$PB_PAYMENT_STATUS['expired'];
			}
			else{
				$orderItems = $order->get_items();
				foreach($orderItems as $orderItem){
					if(isset($orderItem['item_meta']['_'.PB_MENU_CONFIG::$MENU['group']['post_type']])){
						$gourp_id = $orderItem['item_meta']['_'.PB_MENU_CONFIG::$MENU['group']['post_type']][0];
						$order_payment_status=pb_check_group_order_payment($order,$gourp_id);
					}
				}
			}
		}
		return $order_payment_status;
	}
	//团购审核
	function check_group_status($pb_post_data,$childProductAttribute,$uid,$pb_group_id)
	{
		$pb_post_type= PB_MENU_CONFIG::$MENU['group']['post_type'];
		$pb_people=array();
		$pb_group_type=count($pb_post_data['pb_group_ladder_grouping']);
		foreach ($pb_post_data['pb_group_ladder_grouping'] as $value) {
			$pb_people[]=$value['pb_group_ladder_people'];
		} 
		//最小人数
		$pb_people_max=max($pb_people);
		// print_r($childProductAttribute);
		if($childProductAttribute['max_qty']<=0 || $childProductAttribute==-2)
		{
			//没有库存
			return PB_CODE::$CODE_RETURN['ERROR_NO_STOCK'];
		}
		// 团购时间未开始
		if(current_time('timestamp')<strtotime($pb_post_data['pb_start_time']))
		{
			return PB_CODE::$CODE_RETURN['ACT_UNSTART'];
		}
		// 团购时间结束
		if(strtotime($pb_post_data['pb_end_time'])<current_time('timestamp'))
		{
			return PB_CODE::$CODE_RETURN['ACT_END'];
		}
		//重复参团
		$pb_group_opportunity=pb_select_group_user($pb_group_id,$uid,$pb_post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title'],PB_ORDER_STATUS::$PB_ORDER_STATUS['PAID']['title'],PB_ORDER_STATUS::$PB_ORDER_STATUS['BOOKED']['title'],PB_ORDER_STATUS::$PB_ORDER_STATUS['PENDING']['title']));
		// print_r($pb_group_opportunity);
		if($pb_group_opportunity>0)
		{
			return PB_CODE::$CODE_RETURN['ERROR_AGAIN'];
		}
        if(!(pb_select_group_user($pb_group_id,$uid,$pb_post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']))<3))
        {
            return  PB_CODE::$CODE_RETURN['ACT_CANCEL'];
        }
		//查询团购人数是否已满
		$pb_group_count = pb_select_activity_people($pb_group_id,$pb_post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
        if($pb_group_count>=$pb_post_data['pb_max_group_people'])
		{
			return PB_CODE::$CODE_RETURN['ERROR_FULL'];
		}
		if($pb_group_count<($pb_people_max-1))//预约付款1006
		{
			return PB_CODE::$CODE_RETURN['ACT_PENDING_GROUP'];
		}
		else//可付款1001
		{
			return PB_CODE::$CODE_RETURN['ACT_RUNING'];
		}
	}
	//秒杀审核
	function check_flashSale_status($pb_post_data,$childProductAttribute,$uid,$pb_flashSale_id)
	{
		$pb_post_type= PB_MENU_CONFIG::$MENU['flashSale']['post_type'];

		$pb_start_time = $pb_post_data['pb_start_time'];
		$pb_end_time=$pb_post_data['pb_end_time'];
		$pb_flashSale_frequency=$pb_post_data['pb_flashSale_frequency'];
		$pb_flashSale_time_duration=$pb_post_data['pb_flashSale_time_duration'];
		$pb_flashSale_time_payment=$pb_post_data['pb_flashSale_time_payment'];
		$pb_flashSale_time_interval=$pb_post_data['pb_flashSale_time_interval'];
		$pb_check_time=pb_check_time($pb_start_time,$pb_end_time,$pb_flashSale_frequency,$pb_flashSale_time_duration,$pb_flashSale_time_payment,$pb_flashSale_time_interval);
		if($pb_check_time['code']==1001)
		{
			if($childProductAttribute['max_qty']<=0 || $childProductAttribute==-2)
			{
				return PB_CODE::$CODE_RETURN['ERROR_NO_STOCK'];
			}
			//判断商品是否秒杀完(获取当前轮数开始时间)
			$this_round_start_time=pb_get_this_round_start_time($pb_check_time['round'],$pb_post_data);
			// print_r(date('Y-m-d H:i:s',1401211800));
			$flashSale_num=pb_select_flashSale_people($pb_flashSale_id,$pb_post_type,$this_round_start_time);
			if($flashSale_num>=$pb_post_data['pb_commodity_quantity'])
			{
				return PB_CODE::$CODE_RETURN['ERROR_FULL'];
			}
			// 重复秒杀
			if(pb_select_group_user($pb_flashSale_id,$uid,$pb_post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['PAID']['title'],PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title']))>0)
			{
				return PB_CODE::$CODE_RETURN['ERROR_AGAIN'];
			}
            //取消订单次数
            if(!(pb_select_group_user($pb_flashSale_id,$uid,$pb_post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']))<3))
            {
                return  PB_CODE::$CODE_RETURN['ACT_CANCEL'];
            }
		}
		return $pb_check_time;
	}


	//取消未支付(UNPAID)状态的订单
	function pb_cancelUnpaidOrder($order){
		if($order->status == PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title'])
		{
			$order->update_status(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']);
			foreach ( $order->get_items() as $item ) {
				if ( $item['product_id'] > 0 ) {
					$_product = $order->get_product_from_item( $item );
					if ( $_product && $_product->exists() && $_product->managing_stock() ) {
						$old_stock = $_product->stock;
						$qty = apply_filters( 'woocommerce_order_item_quantity', $item['qty'], $order, $item );
						$new_quantity = $old_stock + $qty;
						$_product->set_stock($new_quantity);
					}
				}
			}
		}
	}
    //根据人数判断大屏幕显示的价格
    function pb_show_group_price($post_date,$user_count)
    {
        $pb_group_price=$post_date[0]['pb_group_ladder_price'];
        for($i=count($post_date)-1;$i>=0;$i--)
        {
            if(($user_count+1)>=$post_date[$i]['pb_group_ladder_people'])
            {
                $pb_group_price=$post_date[$i]['pb_group_ladder_price'];
                break;
            }
        }
        return $pb_group_price;
    }
    //判断当前服务器环境
    function pb_server()
    {
        $url=home_url();
        if(strstr($url,"biwifi-sanfu"))
        {
             return true;
        }
        else
        {
            return false;
        }

    }


?>