
<?php
//	$myposts = get_posts('numberposts=5&offset=1&category=1'); 
//	wp_register_script('pb_plan_jquery_script', plugins_url('js/jquery.js', __FILE__));
//	wp_enqueue_script('pb_plan_jquery_script');
	wp_register_script('pb_plan_message_script', plugins_url('js/message.js', __FILE__));
	wp_enqueue_script('pb_plan_message_script');
	wp_register_script('pb_plan_list_script', plugins_url('js/list.js', __FILE__),array('pb_plan_message_script'));
	wp_enqueue_script('pb_plan_list_script');

	global $wpdb;
	$numofpage = 10;
	$page = isset( $_GET['paged'] ) ? absint( $_GET['paged'] ) : 0;
	if(empty($page)){
		$page = 1; 
	}
	
	$rows = $wpdb->get_results("SELECT l.*,p.post_title FROM pb_plan_list as l left join wp_posts as p on l.box_id = p.ID where l.plan_status != ".PB_PLAN_CONFIG::$PLAN_STATUS['del']['status']." ORDER BY plan_date DESC limit ".($page-1)*$numofpage .",".$numofpage );
	//echo "SELECT l.*,count(i.plan_id) as count FROM pb_plan_list as l left join pb_plan_info as i on l.plan_id = i.plan_id and i.plan_info_status = ".PB_ITEM_STATUS_SAVE." where l.plan_status = ".PB_PLAN_STATUS_SAVE." GROUP BY i.plan_id limit ".($page-1)*$numofpage .",".$numofpage;
	$totalnum=$wpdb->get_var("SELECT count(*) FROM pb_plan_list where plan_status != ".PB_PLAN_CONFIG::$ITEM_STATUS['del']['status']);
	$totalpage = ceil($totalnum/$numofpage);
	//print_r($rows);
	//print_r(wp_upload_dir());
?>

<div class="wrap">
	<div id="icon-edit-pages" class="icon32"><br /></div>
	<h2><?php echo $title;?><a href="?page=<?php echo MENU_PB_PLAN_ADD?>" class="add-new-h2">新增</a></h2><br />

			<table class="wp-list-table widefat fixed posts" cellspacing="0">
				<thead>
					<tr>
						<th scope="col" class="manage-column column-tags">
							标题
						</th>
						<th scope="col" class="manage-column column-tags">
							盒子
						</th>
						<th scope="col" class="manage-column column-tags">
							计划日期
						</th>
						<th scope="col" class="manage-column column-tags">
							活动数量
						</th>
						<th scope="col" class="manage-column column-tags">
							状态
						</th>
						<th scope="col" class="manage-column column-tags" style="width:200px;">
							最后操作时间
						</th>
						<th scope="col" class="manage-column column-tags"  style="width:200px;">
							操作
						</th>
					</tr>
				</thead>
				<tbody>
				
				<?php foreach($rows as $row){
						$statusTitle = "";
						foreach(PB_PLAN_CONFIG::$PLAN_STATUS as $status){
							if($status['status'] == $row->plan_status){
								$statusTitle = $status['title'];
								break;
							}
						}
					//	echo date('Y-m-d',current_time('timestamp'));
						$pushLink = "";
						//判断推送
						if($row->plan_date == date('Y-m-d',current_time('timestamp')) && $row->plan_status == PB_PLAN_CONFIG::$PLAN_STATUS['zip']['status']){
							$pushLink = "|<a href='#' onclick='pushToBox(".$row->plan_id.",".$row->box_id.");return false;'>推送</a>";
						}
						
				echo '<tr >
					<td style="height:60px;line-height:60px;"><a href="?page=pb_plan/php/add.php&pid='.$row->plan_id.'">'.$row->plan_title.'</a></td>
					<td style="height:60px;line-height:60px;"><a href="'.admin_url().'post.php?post='.$row->box_id.'&action=edit">'.$row->post_title.'</a></td>
					<td style="height:60px;line-height:60px;">'.$row->plan_date.'</td>
					<td style="height:60px;line-height:60px;">'.$row->plan_item_num.'</td>
					<td style="height:60px;line-height:60px;">'.$statusTitle.'</td>
					<td>生成时间:'.$row->plan_package_time.'
					<br />推送时间:'.$row->plan_push_time.'
					<br />下载时间:'.$row->plan_download_time.'</td>
					<td style="height:60px;line-height:60px;"><a href="?page=pb_plan/php/add.php&pid='.$row->plan_id.'">编辑</a>|<a href="?page=pb_plan/php/add.php&copyPid='.$row->plan_id.'">复制</a>|<a href="#" onclick="createPlanFile('.$row->plan_id.','.$row->box_id.');return false;">生成文件</a>'.$pushLink.'|<a href="#" onclick="delPlan('.$row->plan_id.');return false;">删除</a></td>
					</tr>';
				}?>
				</tbody>
			</table>
<?php
	$page_links = paginate_links( array(
		'base' => add_query_arg( 'paged', '%#%' ),
		'format' => '',
		'prev_text' => '&laquo;',
		'next_text' => '&raquo;',
		'total' => $totalpage,
		'current' => $page,
	));
	echo $page_links;
?>

</div>