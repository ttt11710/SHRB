<?php
//发送消息
class pb_sendMsg
{
	private static $url = "http://testwww.sanfu.com:8080/sanfuinterface.php?";
	private static $app_secret = "sanfu_sign_rfw32423e";
	private static $is_debug = true;
	
	//发送消息 $mobile 手机号码； $content 消息内容；
	public function send_message($mobile,$content){
		$params = array("func"=>"sms","mobile"=>$mobile,"content"=>urlencode($content));
		$sign = pb_sendMsg::getSign($params);
		$send_url = pb_sendMsg::$url."sign=".$sign;
		foreach ($params as $k => $v) {
			$send_url.="&".$k."=".$v;
		}
		$html = file_get_contents($send_url);
		pb_logResult('消息下发至:'.$mobile);
		if(pb_sendMsg::$is_debug)
			return true;
		if($html == "success"){
			return true;
		}
		return false;
	}
	
	//获得签名
	private function getSign($params){
		ksort($params);
		$stringToBeSigned = pb_sendMsg::$app_secret;
		foreach ($params as $k => $v) {
			$stringToBeSigned .= "$k$v";
		}
		unset($k, $v);
		$stringToBeSigned .= pb_sendMsg::$app_secret;
		return strtoupper(md5($stringToBeSigned));
	}
}

//异步发送请求
class pb_asyn_action{
	private static $timeout = 10;
	//发送本地请求 $action action；$params 参数
	function requestLocal($action,$params) {
		$host = $_SERVER["HTTP_HOST"];
		$port = $_SERVER["SERVER_PORT"];
		$tempArr = array_slice(explode("/",admin_url('admin-ajax.php')),3);
		$path = "/".implode("/",$tempArr);
		$path .= "?action=".$action;
		foreach($params as $k => $v){
			$path .= "&".$k."=".$v;
		}
		$timeout = pb_asyn_action::$timeout;
		try {
			# Open our socket to the API Server.
			$socket = fsockopen($host,$port,$errno, $errstr, $timeout);
			# Create the request body, and make the request.
			$out = "GET /".$path."  / HTTP/1.1\r\n";
			$out .= "Host: ".$host."\r\n";
			$out .= "Connection: Close\r\n\r\n";
			fwrite($socket, $out);
			# ...
		}
		catch (Exception $e) {# ...
		}
	}
	//发送远程请求 $host 域名；$port 端口；$path 请求地址，$params 参数；
	function request($host,$port,$path,$params) {
		if($port = "")
			$port = 80;
		if(count($params) > 0){
			$path .= "?";
		}
		foreach($params as $k => $v){
			$path .= "&".$k."=".$v;
		}
		$timeout = pb_asyn_action::$timeout;
		try
        {
			# Open our socket to the API Server.
			$socket = fsockopen($host,$port,$errno, $errstr, $timeout);
			# Create the request body, and make the request.
			$out = "GET /".$path."  / HTTP/1.1\r\n";
			$out .= "Host: ".$host."\r\n";
			$out .= "Connection: Close\r\n\r\n";
			fwrite($socket, $out);
			# ...
		}
		catch (Exception $e) {# ...

		}
	}
}

//定时任务
class pb_timingTasks{
	function __construct() {
		if (!wp_next_scheduled('pb_task_hook')) {
			wp_schedule_event( time(), 'hourly', 'pb_task_hook' );
		}
		add_action( 'pb_task_hook', array($this,'task_hourly_function'));
	}
	
	
	//每小时定时任务
	function task_hourly_function() {
		pb_logResult("in task");
		pb_asyn_action::requestLocal("taskSendMsg",array());
		pb_asyn_action::requestLocal("taskCancelUnpaidOrder",array());
	}
}



function pb_logResult($word='') {
	$fp = fopen(plugin_dir_path( __FILE__ )."log.txt","a");
	flock($fp, LOCK_EX) ;
	fwrite($fp,"执行日期：".strftime("%Y%m%d%H%M%S",current_time('timestamp'))."\n".$word."\n");
	flock($fp, LOCK_UN);
	fclose($fp);
}

//function pb_setting(){
//    $flag==null;
//    $url=bloginfo('url');
//    if(strstr($url,"demo") || strstr($url,"test") )
//    {
//        $flag=true;
//    }
//    else
//    {
//        $flag=pb_sendMsg::send_message($obj->phone,PB_BOX_CONFIG::$SEND_SMS_CONTENT);
//    }
//}



/*
add_filter('cron_schedules', 'cron_add_seconds'); 
function cron_add_seconds( $schedules )
{
	// Adds once weekly to the existing schedules.
	$schedules['seconds'] = array(
		'interval' => 10, // 1周 = 60秒 * 60分钟 * 24小时 * 7天
		'display' => __('10 seconds')
	);
	return $schedules;
}

//通知发送消息
function pb_notificationToSendMsg($mobileArr){
	//print_r(wp_get_schedules());
	$sendTime = current_time('timestamp') + 5;
	echo strftime("%Y%m%d%H%M%S",$sendTime);
	wp_clear_scheduled_hook("pb_sendMsgByMobileArr_event");
	print_r(wp_get_schedule("pb_sendMsgByMobileArr_event"));
	wp_schedule_event($sendTime, "seconds", "pb_sendMsgByMobileArr_event");
	echo "|";
	print_r(wp_get_schedule("pb_sendMsgByMobileArr_event"));
}

//定时发送消息
function pb_timeToSendMsg($sendTime,$id){
	wp_schedule_event($sendTime, "hourly", "pb_sendMsgByID", $id);
}

function pb_logResult($word='') {
	$fp = fopen(plugin_dir_path( __FILE__ )."log.txt","a");
	flock($fp, LOCK_EX) ;
	fwrite($fp,"执行日期：".strftime("%Y%m%d%H%M%S",current_time('timestamp'))."\n".$word."\n");
	flock($fp, LOCK_UN);
	fclose($fp);
}


add_action( 'pb_sendMsgByMobileArr_event', 'pb_sendMsgByMobileArr' );
//根据手机号码发送消息
function pb_sendMsgByMobileArr(){
	pb_logResult("===inin=====");
	global $wpdb;
	$wpdb->query("update pb_group_message set status = 1 where message_id = 1");
//	foreach($args as $mobile){
//		pb_logResult("========".$mobile);
//	}
}

//根据ID发送消息
function pb_sendMsgByID($args){
	
}
*/

?>