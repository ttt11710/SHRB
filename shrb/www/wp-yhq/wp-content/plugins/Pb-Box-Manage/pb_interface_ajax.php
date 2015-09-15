<?php

include_once('pb_check_order.php');

function pb_intface_ajax_init()
{
	$intface=new pb_interface_ajax;
	add_action('wp_ajax_nopriv_getGroupNum', array($intface,'getGroupNum'));
	add_action('wp_ajax_nopriv_setPushSecretKey', array($intface,'setPushSecretKey'));
	add_action('wp_ajax_nopriv_getSystemTime', array($intface,'getSystemTime'));
	add_action('wp_ajax_nopriv_getFlashSaleInfo', array($intface,'getFlashSaleInfo'));
	add_action('wp_ajax_nopriv_changeOrderStatusToUnpiad', array($intface,'changeOrderStatusToUnpiad'));
	add_action('wp_ajax_nopriv_taskCancelUnpaidOrder', array($intface,'taskCancelUnpaidOrder'));
	add_action('wp_ajax_nopriv_taskSendMsg', array($intface,'taskSendMsg'));
    add_action('wp_ajax_nopriv_changeGroupOrderPrice', array($intface,'changeGroupOrderPrice'));
	//登入后ajax
	add_action('wp_ajax_changeOrderStatusToUnpiad', array($intface,'changeOrderStatusToUnpiad'));
	add_action('wp_ajax_get_group_create_order', array($intface,'get_group_create_order'));
	add_action('wp_ajax_get_flashSale_create_order', array($intface,'get_flashSale_create_order'));
	add_action('wp_ajax_checkOrderPayment', array($intface,'checkOrderPayment'));
	add_action('wp_ajax_taskCancelUnpaidOrder', array($intface,'taskCancelUnpaidOrder'));
	add_action('wp_ajax_taskSendMsg', array($intface,'taskSendMsg'));
	add_action('wp_ajax_getProductStock', array($intface,'getProductStock'));
	add_action('wp_ajax_changeGroupOrderPrice', array($intface,'changeGroupOrderPrice'));
	
	//测试用
	add_action('wp_ajax_nopriv_pbTestPayment', array($intface,'pbTestPayment'));
	add_action('wp_ajax_pbTestPayment', array($intface,'pbTestPayment'));
}

class pb_interface_ajax
{
	//测试用
	function pbTestPayment()
	{
		$order_id = $_GET['oid'];
		$res = pb_check_order_payment($order_id);
		if($res['pay']){
			echo "可支付<br />";
		}else{
			echo "不可支付<br />";
		}
		print_r($res);
		exit;
	}
	
	
	//定时任务,团购结束,开团成功,发送消息
	function taskSendMsg(){
		pb_logResult("in task send msg");
		global $wpdb;
		$sendMsgList=$wpdb->get_results("select * from pb_group_message where plan_send_time < '".current_time('mysql')."' and status = ".PB_BOX_CONFIG::$SEND_SMS_STATUS['unsend']);
		$groupMap = Array();
		foreach ($sendMsgList as $obj) {
			if(!isset($groupMap[$obj->group_id])){
				pb_logResult("group_id:".$obj->group_id);
				$pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $obj->group_id);
				$pb_people=array();
				$pb_group_type=count($pb_post_data['pb_group_ladder_grouping']);
				foreach ($pb_post_data['pb_group_ladder_grouping'] as $value) {
					$pb_people[]=$value['pb_group_ladder_people'];
				} 
				//最小成团人数
				$pb_people_min=min($pb_people);
				$groupNum = pb_select_activity_people($obj->group_id,PB_MENU_CONFIG::$MENU['group']['post_type'],array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
				$groupMap[$obj->group_id] = false;
				if($groupNum >= $pb_people_min){
					$groupMap[$obj->group_id] = true;
				}
			}
			if($groupMap[$obj->group_id]){
                $flag=pb_server();
                if($flag)
                {
                    if(pb_sendMsg::send_message($obj->phone,PB_BOX_CONFIG::$SEND_SMS_CONTENT)){
                        $wpdb->query('update pb_group_message set status ='.PB_BOX_CONFIG::$SEND_SMS_STATUS['send'].',send_time = "'.current_time('mysql').'" where message_id = '.$obj->message_id);
                    }
                }
                else{
                    $wpdb->query('update pb_group_message set status ='.PB_BOX_CONFIG::$SEND_SMS_STATUS['send'].',send_time = "'.current_time('mysql').'" where message_id = '.$obj->message_id);
                }
			}
			else{
				$wpdb->query('update pb_group_message set status ='.PB_BOX_CONFIG::$SEND_SMS_STATUS['nosend'].' where message_id = '.$obj->message_id);
			}
		}
		
		exit;
	}
	
	//定时任务,检查订单是否过期,并取消过期订单
	function taskCancelUnpaidOrder(){
		pb_logResult("in task cancelUnpaidOrder");
		global $wpdb;
		$col = $wpdb->get_col( 'select ID from wp_posts as p left join wp_postmeta as pm on p.ID = pm.post_id  '
								.'left join wp_term_relationships as tr ON (tr.object_id = p.ID) '
								.'left JOIN wp_terms as t ON (t.term_id = tr.term_taxonomy_id)'
								.'where p.post_type = "shop_order"'
								.' and pm.meta_key = "_'.PB_BOX_CONFIG::$ORDER_LATEST_PAYMENT_TIME_KEY.'" and pm.meta_value < '.current_time('timestamp')
								.' and t.name = "'.PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title'].'"' );
		
		foreach($col as $order_id){
			$order = new WC_Order($order_id);
			pb_cancelUnpaidOrder($order);
		}
		exit;
	}
	
	
	//检查订单是否可以支付
	function checkOrderPayment()
	{
		if(!isset($_GET['oid']))
		{
			exit;
		}
		$order_id = $_GET['oid'];
		$res = pb_check_order_payment($order_id);
		echo json_encode($res);
		exit;
	}
	
	
	//修改订单状态
	function changeOrderStatusToUnpiad()
	{
		global $wpdb;
		if(!isset($_GET['group_id']))
		{
			exit;
		}
		$group_id=$_GET['group_id'];
		$sendMsgList=$wpdb->get_results("select * from pb_group_message where group_id = {$group_id} and status = ".PB_BOX_CONFIG::$SEND_SMS_STATUS['unsend']);
		foreach ($sendMsgList as $obj) {
            $flag=pb_server();
            if($flag)
            {
                if(pb_sendMsg::send_message($obj->phone,PB_BOX_CONFIG::$SEND_SMS_CONTENT)){
                    $wpdb->query('update pb_group_message set status ='.PB_BOX_CONFIG::$SEND_SMS_STATUS['send'].',send_time = "'.current_time('mysql').'" where message_id = '.$obj->message_id);
                }
            }
            else{
                $wpdb->query('update pb_group_message set status ='.PB_BOX_CONFIG::$SEND_SMS_STATUS['send'].',send_time = "'.current_time('mysql').'" where message_id = '.$obj->message_id);
            }
		}
		exit;
	}

    function changeGroupOrderPrice()
    {
        global $wpdb;
        if(!isset($_GET['group_id']))
        {
            exit;
        }
        $group_id=$_GET['group_id'];
        $pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $group_id);
        $pb_group_count=pb_select_activity_people($group_id,PB_MENU_CONFIG::$MENU['group']['post_type'],array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
        $price=pb_selsct_groupPrice($pb_post_data['pb_group_ladder_grouping'],$pb_group_count);
         $order_id=$wpdb->get_col("select id from wp_posts left join wp_woocommerce_order_items on (wp_posts.id=wp_woocommerce_order_items.order_id)
left join wp_woocommerce_order_itemmeta on (wp_woocommerce_order_items.order_item_id=wp_woocommerce_order_itemmeta.order_item_id)
where wp_woocommerce_order_itemmeta.meta_key='_".PB_MENU_CONFIG::$MENU['group']['post_type']."' and wp_woocommerce_order_itemmeta.meta_value={$group_id}");
        foreach($order_id as $v){
            update_post_meta($v,'_order_total',$price);
        }
        $items=array();
        foreach($order_id as $order_id)
        {
            $order=new WC_Order($order_id);
            $items[]=array_keys($order->get_items());
        }
        foreach($items as $value)
        {
            wc_update_order_item_meta($value[0],'_line_total',$price);
        }
        exit;

    }
	//获取系统时间
	function getSystemTime()
	{
		echo json_encode(array('systemTime'=>current_time('mysql')));
		exit;
	}
	//大屏幕开启请求获得人数
	function getGroupNum()
	{
		if(!isset($_GET['id']) && !isset($_GET['type']))
		{
			exit;
		}
		$pb_screen_activity_id=$_GET['id'];
		$pb_screen_type=$_GET['type'];
		$pb_screen_activity_people=pb_select_activity_people($pb_screen_activity_id,$pb_screen_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
        $pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $pb_screen_activity_id);
        $pb_group_price=pb_show_group_price($pb_post_data['pb_group_ladder_grouping'],$pb_screen_activity_people);
        header("Content-Type: application/json");
		echo json_encode(array('groupNum'=>$pb_screen_activity_people,'groupPrice'=>$pb_group_price));
		exit;
	}
	//盒子获取推送秘钥
	function setPushSecretKey()
	{
		$equipment_id=$_GET['code'];
		$push_secret_key=$_GET['key'];
		global $wpdb;
		$pb_box_id=$wpdb->get_var($wpdb->prepare("SELECT post_id FROM wp_postmeta where meta_key='pb_equipment_id' and meta_value='{$equipment_id}'"));
		update_post_meta($pb_box_id, 'pb_push_secret_key', $push_secret_key);
		exit;
	}
	//大屏幕请求获得是否有下一轮秒杀
	function getFlashSaleInfo()
	{
		if(!isset($_GET['id']) && !isset($_GET['type']))
		{
			exit;
		}
		$pb_flashSale_id=$_GET['id'];
		$type=$_GET['type'];
		$pb_post_data=ff_get_all_fields_from_section('pb_flashSale_buy', 'meta', 'post', $pb_flashSale_id);
		$pb_check_time=pb_check_time($pb_post_data['pb_start_time'],$pb_post_data['pb_end_time'],$pb_post_data['pb_flashSale_frequency'],$pb_post_data['pb_flashSale_time_duration'],$pb_post_data['pb_flashSale_time_payment'],$pb_post_data['pb_flashSale_time_interval']);
        $state=true;
		if($pb_check_time['code']==1007)
		{
			$state=false;
		}
		$sale=pb_select_flashSale_people($pb_flashSale_id,$type,current_time('timestamp'));
		echo json_encode(array('state'=>$state,'sale'=>$sale));
		exit;
	}

	//团购购买ajax请求
	function get_group_create_order()
	{
		// check_active_type(178);
		// die;
		if(!isset($_GET['choose_color']) && !isset($_GET['choose_size']) && !isset($_GET['choose_mode']) && !isset($_GET['group_id']))
		{
			exit();
		}
	    $pb_color=$_GET['choose_color'];
		$pb_size=$_GET['choose_size'];
		$pb_mode=$_GET['choose_mode'];
		$pb_group_id=$_GET['group_id'];
		$pb_post_type= PB_MENU_CONFIG::$MENU['group']['post_type'];
		global $current_user;
		get_currentuserinfo();
		//$current_user->ID
		//团购信息
		$pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $pb_group_id);
		//商品信息
		$pb_group_product=get_product($pb_post_data['pb_select_product'],$fields = null);
		//最晚付款时间
		$pb_latest_payment_time=strtotime($pb_post_data['pb_latest_payment_time']);
		$pb_stock=$pb_group_product->get_available_variations();
		//子商品信息
		$childProductAttribute=getChildProductAttribute($pb_stock,$pb_color,$pb_size,$pb_mode);
		$check_group_status_code=check_group_status($pb_post_data,$childProductAttribute,$current_user->ID,$pb_group_id);
		$pb_people=array();
		$pb_group_type=count($pb_post_data['pb_group_ladder_grouping']);
		foreach ($pb_post_data['pb_group_ladder_grouping'] as $value) {
			$pb_people[]=$value['pb_group_ladder_people'];
		}
		//最小人数
		$pb_people_max=max($pb_people);
		header("Content-Type: application/json");
		$pb_group_count=pb_select_activity_people($pb_group_id,$pb_post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
		$pb_group_status=false;
		//根据人数获取价格
		$pb_group_price=pb_selsct_groupPrice($pb_post_data['pb_group_ladder_grouping'],$pb_group_count);
//        print_r($check_group_status_code['code']);
//        print_r($pb_group_price);
        //清空购物车
        wc_empty_cart();
		switch ($check_group_status_code['code'])
		{
			case 1001:

				$order=createOrder($childProductAttribute['variation_id'],$pb_group_price,$pb_group_id,$current_user->ID,$pb_post_type,PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title'],$pb_latest_payment_time);
				$pb_group_status=true;
				$pb_group_count_people = $pb_group_count+1;
				if($pb_people_max == $pb_group_count_people){
                    include_once('class/publicClass.php');
					pb_asyn_action::requestLocal("changeOrderStatusToUnpiad",array("group_id"=>$pb_group_id));
				}
                foreach($pb_people as $value)
                {
                    if($value==$pb_group_count_people)
                    {
                        include_once('class/publicClass.php');
                        pb_asyn_action::requestLocal("changeGroupOrderPrice",array("group_id"=>$pb_group_id));
                    }
                }
                $pb_groupprice=pb_show_group_price($pb_post_data['pb_group_ladder_grouping'],$pb_group_count_people);
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['SUCCESS'],'people'=>$pb_group_count_people,'status'=>$pb_group_status,'pay_url'=>$order->get_checkout_payment_url(),'price'=>$pb_groupprice));
				break;
			case 1004:
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_UNSTART']));
				break;
			case 1005:
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_END']));
				break;
			case 1006:
				global $wpdb;
				$order=createOrder($childProductAttribute['variation_id'],$pb_group_price,$pb_group_id,$current_user->ID,$pb_post_type,PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title'],$pb_latest_payment_time);
				//这里需要判断用户名是否为手机号码??????????????????????????????????????
				$wpdb->query("INSERT INTO pb_group_message (uid, phone, group_id,create_time,plan_send_time) VALUES ({$current_user->ID},'{$current_user->data->user_login}',{$pb_group_id},now(),'{$pb_post_data['pb_end_time']}')");

				$pb_group_count_people = $pb_group_count+1;
                foreach($pb_people as $value)
                {
                    if($value==$pb_group_count_people)
                    {
                        include_once('class/publicClass.php');
                        pb_asyn_action::requestLocal("changeGroupOrderPrice",array("group_id"=>$pb_group_id));
                    }
                }
                $pb_groupprice=pb_show_group_price($pb_post_data['pb_group_ladder_grouping'],$pb_group_count_people);
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['SUCCESS'],'people'=>$pb_group_count_people,'status'=>$pb_group_status,'pay_url'=>$order->get_checkout_payment_url(),'price'=>$pb_groupprice));
				break;
			case 1007:
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_NO_STOCK']));
				break;
            case 1008:
                echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_ORDER_CANCEL']));
                break;
			case 1010:
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_NO_STOCK']));
				break;
			case 1011:
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_AGAIN']));
				break;
			case 1012:
				echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_FULL']));
				break;
			default:exit;break;
		}
		exit;	
	}
	//参与秒杀ajax
	function get_flashSale_create_order()
	{
		// pb_check_order_payment(772);
		// die;
		if(!isset($_GET['choose_color']) && !isset($_GET['choose_size']) && !isset($_GET['choose_mode']) && !isset($_GET['flashSale_id']))
		{
			exit();
		}
		global $wpdb;
		global $current_user;
		get_currentuserinfo();
		//$current_user->ID
		$pb_color=$_GET['choose_color'];
		$pb_size=$_GET['choose_size'];
		$pb_mode=$_GET['choose_mode'];
		$pb_flashSale_id=$_GET['flashSale_id'];
		$pb_post_type= PB_MENU_CONFIG::$MENU['flashSale']['post_type'];
		//秒杀信息
		$pb_post_data=ff_get_all_fields_from_section('pb_flashSale_buy', 'meta', 'post', $pb_flashSale_id);
		$pb_flashSale_product=get_product($pb_post_data['pb_select_product'],$fields = null);
		//商品信息
		$pb_stock=$pb_flashSale_product->get_available_variations();
		//子商品信息
		$childProductAttribute=getChildProductAttribute($pb_stock,$pb_color,$pb_size,$pb_mode);
		$check_flashSale_status_code=check_flashSale_status($pb_post_data,$childProductAttribute,$current_user->ID,$pb_flashSale_id);
		// print_r($check_flashSale_status_code);
		if(isset($check_flashSale_status_code['round']))
		{
			$latest_payment_time=pb_get_latest_payment_time($check_flashSale_status_code['round'],$pb_post_data);
			$this_start_time=pb_get_this_round_start_time($check_flashSale_status_code['round'],$pb_post_data);
		}
		// print_r(date('Y-m-d H:i:s', $time));
		header("Content-Type: application/json");

        //清空购物车
        wc_empty_cart();
        //秒杀最大次数（整数）
		switch($check_flashSale_status_code['code'])
		{
			case 1001:
				$pb_flashSale_price=$pb_post_data['pb_flashSale_price'];
				$order=createOrder($childProductAttribute['variation_id'],$pb_flashSale_price,$pb_flashSale_id,$current_user->ID,$pb_post_type,PB_ORDER_STATUS::$PB_ORDER_STATUS['UNPAID']['title'],$latest_payment_time);
				$flashSale_num=pb_select_flashSale_people($pb_flashSale_id,$pb_post_type,$this_start_time);
				echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['SUCCESS'],'people'=>$flashSale_num,'pay_url'=>$order->get_checkout_payment_url()));
				break;
			case 1002:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_FLASHSALE_PAYMENT']));
				break;
			case 1003:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_FLASHSALE_NOSTART']));
				break;
			case 1004:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_UNSTART']));
				break;
			case 1005:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_FLASHSALE_END']));
				break;
			case 1007:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_FLASHSALE_END']));
				break;
            case 1008:
                echo json_encode(array('code'=>$check_group_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_ORDER_CANCEL']));
                break;
			case 1010:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_NO_PRODUCT']));
				break;
			case 1011:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_AGAIN']));
				break;
			case 1012:echo json_encode(array('code'=>$check_flashSale_status_code['code'],'msg'=>PB_CODE::$MSG['FAIL_FULL']));
				break;
			default:exit;break;
		}
		exit;
	}
	function getProductStock()
	{
		header("Content-Type: application/json");
		if(!isset($_GET['choose_color']) && !isset($_GET['choose_size']) && !isset($_GET['choose_mode']) && !isset($_GET['product_id']))
		{
			exit();
		}
	    $pb_color=$_GET['choose_color'];
		$pb_size=$_GET['choose_size'];
		$pb_mode=$_GET['choose_mode'];
		$product_id=$_GET['product_id'];
		//商品信息
		$pb_group_product=get_product($product_id,$fields = null);
		$pb_stock=$pb_group_product->get_available_variations();
		//子商品信息

		$childProductAttribute=getChildProductAttribute($pb_stock,$pb_color,$pb_size,$pb_mode);

        if($childProductAttribute==-1){
            echo json_encode(array('stock'=>-1));
        }
        else if($childProductAttribute==-2){
            echo json_encode(array('stock'=>-2));
        }
        else
        {
            echo json_encode(array('stock'=>(int)$childProductAttribute['max_qty']));
        }
		exit;
	}
}
//修改订单状态
// function changeOrderStatus_()
// {
// 	//un
// }












?>