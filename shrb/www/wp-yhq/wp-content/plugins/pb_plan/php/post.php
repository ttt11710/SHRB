<?php
const PB_RETURN_CODE_SUCCESS = '200';
const PB_RETURN_CODE_ERROR = '500';
	
class Pb_plan_post{
	function __construct(){
	//	echo "=====";
		wp_register_script('pb_plan_public_script', plugins_url('js/public.js', __FILE__));
		wp_localize_script('pb_plan_public_script', 'myAjax', array('ajaxurl' => admin_url( 'admin-ajax.php' ))); 
		wp_enqueue_script('pb_plan_public_script');
	}
	
	//新增计划
	function pb_plan_ajax_add_plan()
	{
		global $wpdb;
		if(isset($_POST["plan_title"])){
			$plan_title = $_POST["plan_title"];
			$box_id = $_POST["box_id"];
			$plan_date = $_POST["plan_date"];
			if($plan_title=="" || $plan_date=="" || $box_id==""){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'输入参数不正确')));
			}
			$planRow = $wpdb->get_row("SELECT plan_id FROM pb_plan_list where plan_status != ".PB_PLAN_CONFIG::$PLAN_STATUS['del']['status'] ." and plan_date = '{$plan_date}' and box_id = {$box_id}");
		//	print_r($planRow);
			if($planRow != null){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'pid'=>$planRow->plan_id)));
			}
			$wpdb->query("INSERT INTO pb_plan_list (plan_title, box_id, plan_date,plan_create_time) VALUES ('{$plan_title}',{$box_id},'{$plan_date}','".current_time('mysql')."')");
			$pid = $wpdb->insert_id;
			if($pid==0){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS,'pid'=>$pid)));
		}
	}
	
	//更新计划
	function pb_plan_ajax_update_plan()
	{
		global $wpdb;
		if(isset($_POST["plan_id"])){
			$plan_id = $_POST["plan_id"];
			$plan_title = $_POST["plan_title"];
			$box_id = $_POST["box_id"];
			$plan_date = $_POST["plan_date"];
			if($plan_title=="" || $plan_date=="" || $box_id==""){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'输入参数不正确')));
			}
			$row = $wpdb->query("update pb_plan_list set plan_title = '{$plan_title}', box_id = {$box_id}, plan_date = '{$plan_date}',plan_update_time = '".current_time('mysql')."' where plan_id = {$plan_id}");
			if($row==0){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS)));
		}
	}
	//删除计划
	function pb_plan_ajax_del_plan()
	{
		global $wpdb;
		if(isset($_POST["plan_id"])){
			$plan_id = $_POST["plan_id"];
			$row = $wpdb->query("update pb_plan_list set plan_status = ".PB_PLAN_CONFIG::$PLAN_STATUS['del']['status'].",plan_update_time = '".current_time('mysql')."' where plan_id = {$plan_id}");
			if($row==0){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS)));
		}
	}

	//新增活动
	function pb_plan_ajax_add_item()
	{
		global $wpdb;
		if(isset($_POST["plan_id"])){
			$plan_id =  $_POST["plan_id"];
			$item_start_time = $_POST["item_start_time"];
			$item_type = $_POST["item_type"];
			$post_id = $_POST["post_id"];
			if($plan_id==""){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'请先保存您的新计划')));
			}
			if($item_start_time=="" || $item_type=="" || $post_id==""){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'输入参数不正确')));
			}
			$wpdb->query("INSERT INTO pb_plan_info (plan_id, plan_open_time, plan_start_time, item_type, item_id) VALUES ({$plan_id},'{$item_start_time}','{$item_start_time}','{$item_type}',{$post_id})");
			$item_id = $wpdb->insert_id;
			if($item_id==0){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			$num = $wpdb->get_var("SELECT count(*) FROM pb_plan_info where plan_info_status != ".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status'] ." and plan_id = {$plan_id}");
			$wpdb->query("update pb_plan_list set plan_item_num = {$num}, plan_update_time = '".current_time('mysql')."' where plan_id = {$plan_id}");
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS,'item_id'=>$item_id)));
		}
	}
	
	//更新活动
	function pb_plan_ajax_update_item()
	{
		global $wpdb;
		if(isset($_POST["plan_id"]) && isset($_POST["item_id"])){
			$plan_id = $_POST["plan_id"];
			$item_id = $_POST["item_id"];
			$item_start_time = $_POST["item_start_time"];
			$item_type = $_POST["item_type"];
			$post_id = $_POST["post_id"];
			if($item_start_time=="" || $item_type=="" || $post_id==""){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'输入参数不正确')));
			}
			$row = $wpdb->query("update pb_plan_info set plan_open_time = '{$item_start_time}', plan_start_time = '{$item_start_time}', item_id = {$post_id}, item_type = '{$item_type}' where plan_info_id = {$item_id} and plan_id = {$plan_id}");
			if($row==0 && isset($wpdb->last_error) && $wpdb->last_error != ""){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS)));
		}
	}
	
	//删除活动
	function pb_plan_ajax_del_item()
	{
		global $wpdb;
		if(isset($_POST["plan_id"]) && isset($_POST["item_id"])){
			$plan_id = $_POST["plan_id"];
			$item_id = $_POST["item_id"];
			$row = $wpdb->query("update pb_plan_info set plan_info_status=".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status']." where plan_info_id = {$item_id} and plan_id = {$plan_id}");
			if($row==0){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			$num=$wpdb->get_var("SELECT count(*) FROM pb_plan_info where plan_info_status != ".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status'] ." and plan_id = {$plan_id}");
			$row = $wpdb->query("update pb_plan_list set plan_item_num = {$num}, plan_update_time = '".current_time('mysql')."' where plan_id = {$plan_id}");
			if($row==0){
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>$wpdb->last_error)));
			}
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS)));
		}
	}
	
	//得到(团购，秒杀)活动列表
	function pb_plan_ajax_get_list()
	{
		global $wpdb;
		if(isset($_POST["type"])){
			$type = $_POST["type"];
			$plan_id = $_POST["plan_id"];
			$planRow = $wpdb->get_row("SELECT plan_date FROM pb_plan_list where plan_status != ".PB_PLAN_CONFIG::$PLAN_STATUS['del']['status'] ." and plan_id = {$plan_id}");
			$planStartTime = $planRow->plan_date." 00:00:00";
			$planEndTime = $planRow->plan_date." 23:59:59";
			
			$post_type = "";
			$ff_sections = Array();
			foreach(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY as $item){
				if($item['type']==$type){
					$post_type=$item['post_type'];
					$ff_sections = $item['ff_section'];
					break;
				}
			}
			$rows = get_posts("post_type=".$post_type."&post_status=publish&numberposts=-1");
		//	print_r($rows);
			$returnArray = array();
			foreach($rows as $post){
				$mateArray = Array();
				foreach($ff_sections as $ff_section){
					$mateArray = array_merge($mateArray,ff_get_all_fields_from_section($ff_section, 'meta', 'post', $post->ID));
				}
				if(strtotime($planEndTime) > strtotime($mateArray['pb_start_time']) && strtotime($planStartTime) < strtotime($mateArray['pb_end_time'])){
					$tempArray = array('id'=>$post->ID,'title'=>$post->post_title,'pb_start_time'=>$mateArray['pb_start_time'],'pb_end_time'=>$mateArray['pb_end_time']);
					$returnArray[count($returnArray)] = $tempArray;
				}
			}
			die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS,'list'=>$returnArray)));
		}
	}
	
	//生成计划文件
	function pb_plan_ajax_create_file(){
		
		if(isset($_POST["plan_id"]) && isset($_POST["box_id"])){
			$plan_id = $_POST["plan_id"];
			$box_id = $_POST["box_id"];
			$boxMate = ff_get_all_fields_from_section('pb_box_store', 'meta', 'post', $box_id);
			$box = $boxMate['pb_equipment_id'];
			$uploadDirs = wp_upload_dir();
			$rootPath = $uploadDirs['basedir'].PB_PLAN_CONFIG::$DATA_ROOT_PATH;
			pb_file_mkdir($rootPath);
			$boxPath = $rootPath."/".$box;
			pb_file_mkdir($boxPath);
			global $wpdb;
			$rows = $wpdb->get_results("SELECT l.*,i.* FROM pb_plan_list as l left join pb_plan_info as i on l.plan_id = i.plan_id and i.plan_info_status != ".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status']." where l.plan_id={$plan_id} ORDER BY i.plan_start_time");
			if(!empty($rows)){
				$package_time = current_time('mysql');
				
				if(count($rows)==0){
					die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'计划不存在')));
				}
				$datePath = $boxPath."/".$rows[0]->plan_date;
				$dataUrl = $uploadDirs['baseurl'].PB_PLAN_CONFIG::$DATA_ROOT_PATH."/".$box."/".$rows[0]->plan_date;
				pb_file_mkdir($datePath);
				//print_r($rows[0]);
				if(empty($rows[0]->item_id) || $rows[0]->item_id==""){
					die(json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'请至少添加一个活动')));
				}
				$planArray = pb_plan_formatPlan($rows);
				
				/*
				print_r($itemArray);
				for($i=0;$i<count($itemArray);$i++){
					if($itemArray[$i] != ""){
						$posts = get_posts('include='.$itemArray[$i].'&post_type='.PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['post_type']);
						$itemFilename = $datePath."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						pb_file_writefile($itemFilename,pb_plan_postToJson($posts,PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['ff_section']));
						//print_r($posts);
					}
				}
				*/
				$indexJsonArray = Array();
				//循环应用
				for($i=0;$i<count(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY);$i++){
					if($planArray[$i] == ""){
						continue;
					}
					$tempIndexArray['type'] = PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['type'];
					$tempIndexArray['createTime'] = $package_time;
					$tempDonwloadArray = Array();
					if(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['format'] == "plan_format"){
						$taskFilename = $datePath."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						$taskUrl = $dataUrl."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						pb_file_writefile($taskFilename,json_encode(Array("taskList"=>$planArray[$i])));
						$tempDonwloadArray[0] = Array("file"=>$taskUrl,"topath"=>PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['topath'].PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX);
					}
					else if(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['format'] == "singel_format"){
						$posts = get_posts('include='.$planArray[$i].'&post_type='.PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['post_type']."&post_status=publish");
						$tempMap = pb_plan_formatPostList($posts,PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['ff_section']);
						$itemFilename = $datePath."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						$postUrl = $dataUrl."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						pb_file_writefile($itemFilename,json_encode($tempMap['json']));
						$tempDonwloadArray[0] = Array("file"=>$postUrl,"topath"=>PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['topath'].PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX);
						foreach($tempMap['download'] as $imageUrl){
							$tempArray = explode("/",$imageUrl);
							$imageName = $tempArray[count($tempArray)-1];
							$tempDonwloadArray[count($tempDonwloadArray)] = Array("file"=>$imageUrl,"topath"=>PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['toimgpath'].$imageName);
						}
					}
					else{
						$posts = get_posts('include='.$planArray[$i].'&post_type='.PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['post_type']."&post_status=publish");
						$tempMap = pb_plan_formatPost($posts,PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['ff_section']);
						$itemFilename = $datePath."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						$postUrl = $dataUrl."/".PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
						pb_file_writefile($itemFilename,json_encode($tempMap['json']));
						$tempDonwloadArray[0] = Array("file"=>$postUrl,"topath"=>PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['topath'].PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['filename'].PB_PLAN_CONFIG::$DATA_FILE_SUFFIX);
						foreach($tempMap['download'] as $imageUrl){
							$tempArray = explode("/",$imageUrl);
							$imageName = $tempArray[count($tempArray)-1];
							$tempDonwloadArray[count($tempDonwloadArray)] = Array("file"=>$imageUrl,"topath"=>PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['toimgpath'].$imageName);
						}
					}
					$tempIndexArray['download'] = $tempDonwloadArray;
					$indexJsonArray[count($indexJsonArray)] = $tempIndexArray;
				}
				$indexFilename = $datePath."/".PB_PLAN_CONFIG::$DATA_DOWNLOAD_FILENAME.PB_PLAN_CONFIG::$DATA_FILE_SUFFIX;
				pb_file_writefile($indexFilename,json_encode($indexJsonArray));
				$row = $wpdb->query("update pb_plan_list set plan_status = ".PB_PLAN_CONFIG::$PLAN_STATUS['zip']['status'].",plan_package_time = '".$package_time."' where plan_id = {$plan_id}");
				pb_add_action_log($plan_id,$box_id,PB_PLAN_CONFIG::$LOG_ACTION_TYPE["create"]);
				die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS)));
			}
			else{
				die(json_encode(array('code'=>PB_RETURN_CODE_ERROR)));
			}
			
			
			
			//[{"type":"1","download":[{"file":"url","topath":"path"},{"file":"url","topath":"path"}]}]
			
			
			//die(json_encode(array('code'=>PB_RETURN_CODE_SUCCESS,'msg'=>$uploadDirs['basedir']."/pb_data")));
		}
	}
	
	//推送计划
	function pb_plan_ajax_push_box(){
		if(isset($_POST["box_id"]) && isset($_POST["plan_id"])){
			global $wpdb;
			$box_id = $_POST["box_id"];
			$plan_id = $_POST["plan_id"];
			$tempMap = ff_get_all_fields_from_section('pb_box_store', 'meta', 'post', $box_id);
			$push_key = $tempMap['pb_push_secret_key'];
			if($push_key == '0'){
				echo json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'box push key不存在'));
				exit;
			}
			$push = new XingeApp(PB_PLAN_CONFIG::$XINGE_PUSH_ID,PB_PLAN_CONFIG::$XINGE_PUSH_KEY);
			$mess = new Message();
			$mess->setTitle('push');
			$mess->setContent('content');
			$mess->setType(Message::TYPE_MESSAGE);
			/*
			$custom = array('url'=>array(
				"http://gdown.baidu.com/data/wisegame/05e08e153f1d3957/PPTVjuli_88.apk",
				"http://gdown.baidu.com/data/wisegame/4f00c99aff512120/youku_52.apk"
			));
			$mess->setCustom($custom);
			*/
			$ret = $push->PushSingleDevice($push_key, $mess);
			if($ret['ret_code'] == 0){
				$wpdb->query("update pb_plan_list set plan_push_time = '".current_time('mysql')."' where plan_id = {$plan_id}");
				pb_add_action_log($plan_id,$box_id,PB_PLAN_CONFIG::$LOG_ACTION_TYPE["push"]);
				echo json_encode(array('code'=>PB_RETURN_CODE_SUCCESS));
			}
			else{
				echo json_encode(array('code'=>PB_RETURN_CODE_ERROR));
			}
			exit;
		}
	}
	
	function pb_plan_ajax_update_box(){
		if(isset($_GET["box_id"]) && isset($_GET["url"])){
			$box_id = $_GET["box_id"];
			$url = $_GET["url"];
			$tempMap = ff_get_all_fields_from_section('pb_box_store', 'meta', 'post', $box_id);
			$push_key = $tempMap['pb_push_secret_key'];
			if($push_key == '0'){
				echo json_encode(array('code'=>PB_RETURN_CODE_ERROR,'msg'=>'box push key不存在'));
				exit;
			}
			$push = new XingeApp(PB_PLAN_CONFIG::$XINGE_PUSH_ID,PB_PLAN_CONFIG::$XINGE_PUSH_KEY);
			$mess = new Message();
			$mess->setTitle('update');
			$mess->setContent($url);
			$mess->setType(Message::TYPE_MESSAGE);
			$ret = $push->PushSingleDevice($push_key, $mess);
			if($ret['ret_code'] == 0){
				echo json_encode(array('code'=>PB_RETURN_CODE_SUCCESS));
			}
			else{
				echo json_encode(array('code'=>PB_RETURN_CODE_ERROR));
			}
			exit;
		}
	}
	
	//下载完成记录LOG
	function pb_plan_ajax_download_log(){
		if(isset($_GET["box_code"]) && $_GET["date"]){
			global $wpdb;
			$box_code = $_GET["box_code"];
			$date = $_GET["date"];
			$box_id_col = $wpdb->get_col("select p.ID from wp_posts as p left join wp_postmeta as pm on p.ID = pm.post_id where pm.meta_key = 'pb_equipment_id' and pm.meta_value = '{$box_code}'");
			$box_id = $box_id_col[0];
			$plan_id_col = $wpdb->get_col("select plan_id from pb_plan_list where box_id = {$box_id} and plan_date = '".$date."'");
			$plan_id = $plan_id_col[0];
			$wpdb->query("update pb_plan_list set plan_download_time = '".current_time('mysql')."' where plan_id = {$plan_id}");
			pb_add_action_log($plan_id,$box_id,PB_PLAN_CONFIG::$LOG_ACTION_TYPE["download"]);
			exit;
		}
	}
	
}

//返回任务
function pb_plan_formatPlan($rows){
	// print_r($rows);
	// die;
	$planArray = Array();
	for($i=0;$i<count(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY);$i++){
		$planArray[$i] = "";
	}
	foreach($rows as $row){
		if($row->plan_start_time == ""){
			return "";
		}
		$packageName = "";
		for($i=0;$i<count(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY);$i++){
			if(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['type'] == $row->item_type){
				$packageName = PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY[$i]['package'];
				if($planArray[$i] == ""){
					$planArray[$i]= $row->item_id;
				}
				else{
					$planArray[$i]= $planArray[$i].",".$row->item_id;
				}
				break;
			}
		}
		if($row->item_type==4)
		{
			// print_r($row->item_id);
			$package=ff_get_all_fields_from_section('pb_app', 'meta', 'post', $row->item_id);
			// print_r($package['pb_group_parameter_grouping']);
			$parameter_key=array();
			$parameter_value=array();
			foreach ($package['pb_group_parameter_grouping'] as $value) {
				foreach ($value as $key => $value) {
					if($key=='app_parameter_key')
					{
						$parameter_key[]=$value;
					}
					else
					{
						$parameter_value[]=$value;
					}
				}
				// print_r($parameter_key);
				// print_r($parameter_value);
			}
			$parameter_key_value=array_combine($parameter_key,$parameter_value);
			$param=array("id"=>$row->item_id);
			$param=$param+$parameter_key_value;
			// print_r($param);
			// die;
			$tempPlanArray = Array(
				"startTime"=>$row->plan_start_time,
				"itemType"=>$row->item_type,
				"packageName"=>$package['app_package'],
				"param"=>$param
			);
			$planArray[0][] = $tempPlanArray;	
		}
		else
		{
			$tempPlanArray = Array(
				"startTime"=>$row->plan_start_time,
				"itemType"=>$row->item_type,
				"packageName"=>$packageName,
				"param"=>Array("id"=>$row->item_id)
			);
			$planArray[0][] = $tempPlanArray;			
		}
	}
	// print_r($planArray);
	// die;
	return $planArray;//json_encode(Array("taskList"=>$returnArr));
}

//商品列表
function pb_plan_formatPostList($posts,$ff_sections){
	$returnArray = Array();
	$downloadImageArray = Array();
	foreach($posts as $post){
		$mateArray = Array();
		foreach($ff_sections as $ff_section){
			$mateArray = array_merge($mateArray,ff_get_all_fields_from_section($ff_section, 'meta', 'post', $post->ID));
		}
		$productArray = Array();
		foreach($mateArray["pb_select_self_product"] as $p_id){
			$tempProductMap = pb_formatProduct($p_id);
			$productArray[] = $tempProductMap['product'];
			$downloadImageArray = array_merge($downloadImageArray,$tempProductMap['download']);
		}
		$tempPlanArray = Array(
			"ID"=>$post->ID,
			"title"=>$post->post_title,
			"meta"=>$mateArray,
			"products"=> $productArray
		);
		$returnArray[count($returnArray)] = $tempPlanArray;
	}
	return Array('json'=>Array('pb_data'=>$returnArray),'download'=>$downloadImageArray);
}


//活动信息
function pb_plan_formatPost($posts,$ff_sections){
	$returnArray = Array();
	$downloadImageArray = Array();
	foreach($posts as $post){
		//$meta = get_post_meta($post->ID);
		$mateArray = Array();
		foreach($ff_sections as $ff_section){
			$mateArray = array_merge($mateArray,ff_get_all_fields_from_section($ff_section, 'meta', 'post', $post->ID));
		}
		//print_r($mateArray);$mateArray['pb_select_product']
		$tempProductMap = pb_formatProduct($mateArray['pb_select_product']);
		$downloadImageArray = array_merge($downloadImageArray,$tempProductMap['download']);
		
		//print_r($child_regular_prices);
		
		$tempPlanArray = Array(
			"ID"=>$post->ID,
			"title"=>$post->post_title,
			"meta"=>$mateArray,
			"product"=>$tempProductMap['product']
		);
		$returnArray[count($returnArray)] = $tempPlanArray;
	}
	return Array('json'=>Array('pb_data'=>$returnArray),'download'=>$downloadImageArray);//json_encode($returnArray);
}

//解析商品
function pb_formatProduct($pid){
	if(empty($pid)){
		return Array();
	}
	$returnArray = Array();
	$downloadImageArray = Array();
	
	$product = get_product($pid);//new WC_Product($mateArray['pb_select_product']);
//	print_r($product->post->post_content);
	$imageIDs = $product->get_gallery_attachment_ids();
	$phoneImageArray = Array();
	foreach($imageIDs as $imageID){
		$imageInfo = wp_get_attachment_image_src($imageID,array(PB_PLAN_CONFIG::$PRODUCT_IMAGE_WIDTH,PB_PLAN_CONFIG::$PRODUCT_IMAGE_HEIGHT,false));
		$downloadImageArray[count($downloadImageArray)] = $imageInfo[0];
		$tempArray = explode("/",$imageInfo[0]);
		$imageName = $tempArray[count($tempArray)-1];
		$phoneImageArray[count($phoneImageArray)] = $imageName;
	}
	//大屏幕图片
	$screenImagesArray = Array();
	$screenImages = ff_get_all_fields_from_section('pb_large_screen_img', 'meta', 'post', $product->post->ID);
	//print_r($screenImages);
	if(!is_array($screenImages["pb_large_screen_img_array"])){
		$screenImages["pb_large_screen_img_array"] = Array($screenImages["pb_large_screen_img_array"]);
	}
	foreach($screenImages["pb_large_screen_img_array"] as $screenImage){
		$downloadImageArray[count($downloadImageArray)] = $screenImage;
		$tempArray = explode("/",$screenImage);
		$imageName = $tempArray[count($tempArray)-1];
		$screenImagesArray[count($screenImagesArray)] = $imageName;
	}
	
	//商品基本属性
	$productBaseAttrs = ff_get_all_fields_from_section('pb_wc_product_property', 'meta', 'post', $product->post->ID);
	$baseAttrs = Array();
	foreach(array_keys(PB_PLAN_CONFIG::$PRODUCT_FORMAT_ARRAY) as $key){
		$baseAttrs[] = Array("key"=>PB_PLAN_CONFIG::$PRODUCT_FORMAT_ARRAY[$key],"value"=>$productBaseAttrs[$key]);
	}
	

	//商品可选属性
	$productAttrs = $product->get_attributes();
	$returnAttrMap = Array();
	foreach(PB_PLAN_CONFIG::$PRODUCT_ATTRIBUTES as $attr){
		$returnAttrMap[$attr] = explode("|",$productAttrs[$attr]['value']);
	}
	if($product->product_type == 'variable'){
		//原价
		//print_r($product->get_regular_price());
		foreach ($product->get_children() as $child_id )
			$child_regular_prices[] = get_post_meta( $child_id, '_regular_price', true );
		$regular_price = max($child_regular_prices);
		
		foreach ($product->get_children() as $child_id )
			$child_sale_prices[] = get_post_meta( $child_id, '_sale_price', true );
		$sale_price = min($child_sale_prices);
	}
	else{
		$regular_price = $product->get_regular_price();
		$sale_price = $product->get_sale_price();
	}
	
	$returnArray['product'] = Array("ID"=>$product->post->ID,"title"=>$product->post->post_title,"content"=>$product->post->post_content,"price"=>$regular_price,"sale_price"=>$sale_price,"baseAttributes"=>$baseAttrs,"attributes"=>$returnAttrMap,"phoneImages"=>$phoneImageArray,"screenImages"=>$screenImagesArray);
	$returnArray['download'] = $downloadImageArray;
	return $returnArray;
	
}



//添加计划操作日志
function pb_add_action_log($plan_id,$box_id,$type){
	global $wpdb;
	$wpdb->query("INSERT INTO pb_plan_log (plan_id,box_id, action_time, log_type) VALUES ({$plan_id},{$box_id},'".current_time('mysql')."',{$type})");
	return $wpdb->insert_id;
}

//得到
function pb_plan_getAllImages($post_content){
	$szSearchPattern = '~<img [^\>]*\ />~'; // 搜索所有符合的图片
	preg_match_all( $szSearchPattern, $post_content, $aPics );
	$iNumberOfPics = count($aPics[0]); // 检查一下至少有一张图片
	if ($iNumberOfPics > 0) {
		return $aPics;
	};
	return array();
}

?>