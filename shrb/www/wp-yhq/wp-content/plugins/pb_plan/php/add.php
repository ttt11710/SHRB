<?php
//	wp_register_script('pb_plan_jquery_script', plugins_url('js/jquery.js', __FILE__));
//	wp_enqueue_script('pb_plan_jquery_script');
	wp_register_script('pb_plan_message_script', plugins_url('js/message.js', __FILE__));
	wp_enqueue_script('pb_plan_message_script');
	wp_register_script('pb_plan_add_script', plugins_url('js/add.js', __FILE__),array('pb_plan_message_script'));
	wp_enqueue_script('pb_plan_add_script');
	wp_register_style('pb_plan_bootstrap_style', plugins_url('css/bootstrap.css', __FILE__));
	wp_enqueue_style('pb_plan_bootstrap_style');
	wp_register_style('pb_plan_datetimepicker_style', plugins_url('css/bootstrap-datetimepicker.min.css', __FILE__));
	wp_enqueue_style('pb_plan_datetimepicker_style');
	wp_register_script('pb_plan_datetimepicker_script', plugins_url('js/bootstrap-datetimepicker.min.js', __FILE__));
	wp_enqueue_script('pb_plan_datetimepicker_script');
	wp_register_script('pb_plan_datetimepicker_cn_script', plugins_url('js/locales/bootstrap-datetimepicker.zh-CN.js', __FILE__));
	wp_enqueue_script('pb_plan_datetimepicker_cn_script');
		
		$plan_id ="";
		$plan_title ="";
		$plan_date =date('Y-m-d');
		$add_item_style ="display:none";
		$plan_span_tip ='<span id="plan_tip" style="color:red">请保存</span>';
		if(isset($_GET["pid"]) && $_GET["pid"]!=""){
			global $wpdb;
			$rows = $wpdb->get_results("SELECT l.*,i.* FROM pb_plan_list as l left join pb_plan_info as i on l.plan_id = i.plan_id and i.plan_info_status != ".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status']." where l.plan_id=".$_GET["pid"]." ORDER BY i.plan_start_time");
			if(!empty($rows)){
				$plan_id = $_GET["pid"];
				$plan_title = $rows[0]->plan_title;
				$plan_date = $rows[0]->plan_date;
				$box_id = $rows[0]->box_id;
				$add_item_style="";
				$plan_span_tip ='<span id="plan_tip" style="color:green">已保存</span>';
				$title = "编辑计划";
				//$item_rows = $wpdb->get_row("SELECT * FROM pb_plan_info where plan_id=".$plan_id);
			}
		}
		else if(isset($_GET["copyPid"]) && $_GET["copyPid"]!=""){
			global $wpdb;
			$rows = $wpdb->get_results("SELECT l.*,i.* FROM pb_plan_list as l left join pb_plan_info as i on l.plan_id = i.plan_id and i.plan_info_status != ".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status']." where l.plan_id=".$_GET["copyPid"]." ORDER BY i.plan_start_time");
			$plan_title = $rows[0]->plan_title.'(复制)';
			$box_id = $rows[0]->box_id;
			$add_item_style="";
			$plan_span_tip ='<span id="plan_tip" style="color:red">请保存</span>';
		}
		$boxPosts = get_posts("post_type=pb_box&post_status=publish&numberposts=-1");

?>

<div class="wrap">
	<div id="icon-edit-pages" class="icon32"><br /></div>
	<h2><?php echo $title;?></h2><br />
	<div id="poststuff">
		<div class="postbox ">
			<h3 class="hndle">计划&nbsp;&nbsp;[<?php echo $plan_span_tip;?>]<div class="handlediv" style="width:230px;"><a href="#" id="add_new_plan">保存计划</a>|<a href="#" id="save_all_item">保存全部任务</a>|<a href="#"  id="create_file">生成文件</a>|<a href="#"  id="del_plan">删除</a></div></h3>
			<input type="hidden" id="plan_id" value="<?php echo $plan_id;?>" />
			<table class="optiontable">
				<tr style="height:30px">
					<td align="center" style="width:80px;">计划标题</td>
					<td><input class="plan_save_tip" type="text" size="30" id="plan_title" name="plan_title" value="<?php echo $plan_title;?>" width="20%"/><font color="red">*</font></td>
					<td><span id="plan_title_tip" style="color:red"></span></td>
				</tr>
				<tr style="height:30px">
					<td align="center">选择盒子</td>
					<td><select class="plan_save_tip" id="box_id" >
						<?php foreach($boxPosts as $post):
							$boxSelected = "";
							if($post->ID == $box_id)
								$boxSelected = "selected";
						?>
							<option value="<?php the_id();?>" <?php echo $boxSelected;?>><?php the_title();?></option>
						<?php endforeach; ?>
						</select><font color="red">*</font></td>
					<td><span></span></td>
				</tr>
				<tr style="height:30px">
					<td align="center">计划日期</td>
					<td><input data-date="<?php echo $plan_date;?>"  class="plan_save_tip" id="plan_date" type="text" size="30" name="plan_date" value="<?php echo $plan_date;?>" width="20%"/><font color="red">*</font></td>
					<td><span id="plan_date_tip" style="color:red"></span></td>
				</tr>
				<tr style="height:30px">
					<td></td>
					<td><span id="add_btn_span" style="<?php echo $add_item_style;?>"><a href="#" id="add_item" class="add_new_item" >添加活动</a></span></td>
				</tr>
			</table>
		</div>
		<div class="" id="items">
			<?php
				$item_index = 0; 
				foreach($rows as $row){
				if(!empty($row->item_id)){
					$add_next_span_style = "display:none";
					if($item_index == count($rows)-1){
						$add_next_span_style = "";
					}
					
					$select_post_type = "";
					$ff_sections = Array();
					$item_type_option = "";
					foreach(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY as $item){
						if($item['visible']){
							if($item['type']==$row->item_type){
								$item_type_option = $item_type_option."<option selected value=".$item['type'].">".$item['title']."</option>";
								$select_post_type = $item["post_type"];
								$ff_sections = $item["ff_section"];
							}else{
								$item_type_option = $item_type_option."<option value=".$item['type'].">".$item['title']."</option>";

							}
						}
					}
					// print_r($item['title']);
					$planStartTime = $plan_date." 00:00:00";
					$planEndTime = $plan_date." 23:59:59";

					$item_rows = get_posts("post_type=".$select_post_type."&post_status=publish&numberposts=-1");
					// print_r($item_rows);
					$item_option = "";
					$item_span_tip ='<span id="item_tip_'.$item_index.'" style="color:green">已保存</span>';
					foreach($item_rows as $item_row){
						$mateArray = Array();
						foreach($ff_sections as $ff_section){
							$mateArray = array_merge($mateArray,ff_get_all_fields_from_section($ff_section, 'meta', 'post', $item_row->ID));
						}
						if(strtotime($planEndTime) > strtotime($mateArray['pb_start_time']) && strtotime($planStartTime) < strtotime($mateArray['pb_end_time'])){
							if($item_row->ID==$row->item_id){
								// print_r($item_row->post_title);
								$meta_package=get_post_meta($item_row->ID, 'app_package');
								// print_r($meta_package[0]);
								if(isset($meta_package[0]))
								{
									// print_r('a');
									$item['title']=$meta_package[0];
								}
								else
								{
									$item['title']=$item_row->post_title;
								}
								$item_option = $item_option."<option selected value=".$item_row->ID.">".$item_row->post_title." [".$mateArray['pb_start_time']." -- ".$mateArray['pb_end_time']."]</option>";
							}else{

								$item_option = $item_option."<option value=".$item_row->ID.">".$item_row->post_title." [".$mateArray['pb_start_time']." -- ".$mateArray['pb_end_time']."]</option>";
							}
						}
						else{
							if($item_row->ID==$row->item_id){
								$item_option = $item_option."<option style='color:red' selected value=".$item_row->ID.">".$item_row->post_title." [已过期]</option>";
								$item_span_tip ='<span id="item_tip_'.$item_index.'" style="color:red">请保存</span>';
							}
						}
					}
					$plan_info_id = $row->plan_info_id;
					//复制计划
					if($plan_id == ""){
						$plan_info_id = "";
						$item_span_tip ='<span id="item_tip_'.$item_index.'" style="color:red">请保存</span>';
					}
					
				echo '<div id="item_'.$item_index.'" class="postbox ">
						<h3 class="hndle">活动&nbsp;&nbsp;['.$item_span_tip.']<div class="handlediv"  style="width: 60px;"><a href="#" id="add_item_action_'.$item_index.'" class="add_item">保存</a><a href="#" style="display:none;" id="edit_item_action_'.$item_index.'" class="edit_item">编辑</a>|<a href="#" id="del_item_action_'.$item_index.'" class="del_item">删除</a></div></h3>
						<input id="item_id_'.$item_index.'" value="'.$plan_info_id.'" type="hidden" />
						<table class="optiontable">
							<tr  style="height:30px">
								<td align="center" style="width:80px;">开始时间</td>
								<td><input data-date="'.$plan_date.'" class="item_save_tip item_start_time" id="item_start_time_'.$item_index.'" type="text" size="30" name="plan_box" value="'.$row->plan_start_time.'" width="20%"/><font color="red">*</font></td>
								<td><span id="item_start_time_tip_'.$item_index.'" style="color:red"></span></td>
							</tr>
							<tr style="height:30px">
								<td align="center">活动类型</td>
								<td><select class="item_save_tip"  id="item_type_'.$item_index.'">'.$item_type_option.'</select><font color="red">*</font></td>
								<td><span id="item_type_tip_'.$item_index.'" style="color:red"></span></td>
							</tr>
							<tr style="height:30px">
								<td align="center">活动</td>
								<td><select class="item_save_tip"  id="post_id_'.$item_index.'">'.$item_option.'</select><font color="red">*</font></td>
								<td><span id="post_id_tip_'.$item_index.'" style="color:red"></span></td>
							</tr>
							<tr style="height:30px">
								<td></td>
								<td><span id="add_next_item_span_'.$item_index.'" style="'.$add_next_span_style.'"><a href="#"  class="add_new_item" >添加下一个</a></span></td>
							</tr>
						</table>
					</div>';
					$item_index++;

				}
			}?>
		</div>
	</div>
</div>
<div id="item" class="postbox " style="display:none">
	<h3 class="hndle">活动&nbsp;&nbsp;[<span id="item_tip" style="color:red">请保存</span>]<div class="handlediv"  style="width: 60px;"><a href="#" id="add_item_action" class="add_item">保存</a><a href="#" style="display:none;" id="edit_item_action" class="edit_item">编辑</a>|<a href="#" id="del_item_action" class="del_item">删除</a></div></h3>
	<input id="item_id" value="" type="hidden" />
	<table class="optiontable">
		<tr style="height:30px">
			<td align="center" style="width:80px;">开始时间</td>
			<td><input data-date="<?php echo $plan_date;?>" class="item_start_time" id="item_start_time" type="text" size="30" name="plan_box" value="00:00:00" width="20%"/><font color="red">*</font></td>
			<td><span id="item_start_time_tip" style="color:red"></span></td>
		</tr>
		<tr style="height:30px">
			<td align="center">活动类型</td>
			<td><select  id="item_type">
					<option value="0">--选择活动类型--</option>
					<?php foreach(PB_PLAN_CONFIG::$ITEM_TYPE_ARRAY as $item): 
							if($item['visible']){?>
					<option value="<?php echo $item['type'];?>"><?php echo $item['title'];?></option>
					<?php } endforeach; ?>
			</select><font color="red">*</font></td>
			<td><span id="item_type_tip" style="color:red"></span></td>
		</tr>
		<tr style="height:30px">
			<td align="center">活动</td>
			<td><select  id="post_id"><option value="0">--请先选择活动类型--</option></select><font color="red">*</font></td>
			<td><span id="post_id_tip" style="color:red"></span></td>
		</tr>
		<tr style="height:30px">
			<td></td>
			<td><span id="add_next_item_span" style="display:none"><a href="#" class="add_new_item" >添加下一个</a></span></td>
		</tr>
	</table>
</div>
<?php
	
	
?>