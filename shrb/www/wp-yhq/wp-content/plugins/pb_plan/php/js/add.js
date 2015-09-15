var item_num = 0;
jQuery(document).ready(function(){
	item_num = jQuery("#items").children().length;
	
	jQuery("#plan_date").datetimepicker({
		language:'zh-CN',
		format: 'yyyy-mm-dd',
		autoclose: 1,
		todayHighlight: 1,
		startView: 2,
		minView: 2,
		forceParse: 0
	});
	jQuery(".item_start_time").datetimepicker({
		language:'zh-CN',
		format: 'hh:ii:ss',
		autoclose: 1,
		startView: 1,
		minView: 0,
		maxView: 1,
		forceParse: 0
	});
	
	
	//保存计划
	jQuery("#add_new_plan").click(function(){
		if(jQuery("#plan_title").val()==""){
			jQuery("#plan_title_tip").html(MSG_PLAN_TITLE_NULL);
			return;
		}
		if(jQuery("#plan_date").val()==""){
			jQuery("#plan_date_tip").html(MSG_PLAN_DATE_NULL);
			return;
		}
		var plan_id = jQuery("#plan_id").val();
		if(plan_id == undefined || plan_id == ""){
			//pb_plan_ajax_elevation();
			var data={"plan_title":jQuery("#plan_title").val(),
					"box_id":jQuery("#box_id").val(),
					"plan_date":jQuery("#plan_date").val(),
				};
			sendAjax('pb_plan_add_plan',data,function(res){
				if(res.code == "200"){
					jQuery("#plan_id").val(res.pid);
					jQuery("#add_btn_span").attr("style","");
					jQuery("#plan_tip").attr("style","color:green");
					jQuery("#plan_tip").html("已保存");
				}
				else if(res.code == "500"){
					if(res.pid != null && res.pid != ""){
						if(confirm(jQuery("#plan_date").val()+"日"+jQuery("#box_id").find("option:selected").text()+"计划已存在，是否跳转至该日计划进行编辑？")){
							jQuery(window).unbind('beforeunload');
							window.location.href="?page=pb_plan/php/add.php&pid="+res.pid;
						}
					}
				}
			});
		}
		else{
			var data={"plan_id":plan_id,
					"plan_title":jQuery("#plan_title").val(),
					"box_id":jQuery("#box_id").val(),
					"plan_date":jQuery("#plan_date").val()
				};
			sendAjax('pb_plan_update_plan',data,function(res){
				if(res.code == "200"){
					jQuery("#plan_tip").attr("style","color:green");
					jQuery("#plan_tip").html("已保存");
				}
			});
		}
		
		return false;
	});
	
	//保存全部任务
	jQuery("#save_all_item").click(function(){
		var plan_id = jQuery("#plan_id").val();
		if(plan_id != undefined && plan_id != ""){
			jQuery("[id^=add_item_action_]").each(function(){
				saveItem(jQuery(this));
			});
		}
		else{
			alert("请先保存计划");
		}
		return false;
	});
	
	//生成文件
	jQuery("#create_file").click(function(){
		var plan_id = jQuery("#plan_id").val();
		var box_id = jQuery("#box_id").val();
		if(plan_id != undefined && plan_id != ""){
			var data={"plan_id":plan_id,
				"box_id":box_id
				};
			sendAjax('pb_plan_create_file',data,function(res){
				if(res.code == "200"){
					alert("生成文件成功");
				}
				else{
					alert(res.msg);
				}
			});
		}
		else{
		
		}
		return false;
	});
	
	//删除计划
	jQuery("#del_plan").click(function(){
		var r=confirm("是否确认删除该计划?");
		if(!r){
			return;
		}
		var plan_id = jQuery("#plan_id").val();
		if(plan_id != undefined && plan_id != ""){
			var data={"plan_id":plan_id
				};
			sendAjax('pb_plan_del_plan',data,function(res){
				if(res.code == "200"){
					jQuery(window).unbind('beforeunload');
					window.location.href="?page=pb_plan/php/list.php";
				}
			});
		}
		else{
			jQuery(window).unbind('beforeunload');
			window.location.href="?page=pb_plan/php/list.php";
		}
	});
	
	//新增活动
	jQuery(".add_new_item").click(function(){
		addNewItem(jQuery(this));
	});
	
		
	//活动类型发生变化
	jQuery("[id^=item_type_]").change(function(){
		getPostListByType(jQuery(this))
	});
	//已存在活动保存
	jQuery("[id^=add_item_action_]").click(function(){
		saveItem(jQuery(this));
		return false;
	});
	//已存在活动删除
	jQuery("[id^=del_item_action_]").click(function(){
		delItem(jQuery(this));
		return false;
	});
	
	//提示保存计划
	jQuery(".plan_save_tip").change(function (){
		jQuery("#plan_tip").attr("style","color:red");
		jQuery("#plan_tip").html("请保存");
	});
	jQuery(".item_save_tip").change(function (){
		showSaveTip(jQuery(this),"item_tip");
	});
	
	jQuery(window).bind('beforeunload',function(){return '请确保所有活动都已保存状态后再离开,确认离开此页面吗?'; });
});

//新增新活动
function addNewItem(obj){
	var newItem = getNewItem(item_num,null);
	//alert
	jQuery(newItem).appendTo(jQuery("#items"));
	jQuery("#add_item_action_"+item_num).click(function(){
		saveItem(jQuery(this));
		return false;
	});
	jQuery("#item_start_time_"+item_num).datetimepicker({
		language:'zh-CN',
		format: 'hh:ii:ss',
		autoclose: 1,
		startView: 1,
		minView: 0,
		maxView: 1,
		forceParse: 0
	});
	jQuery("#del_item_action_"+item_num).click(function(){
		delItem(jQuery(this));
		return false;
	});
	//活动类型change事件
	jQuery("#item_type_"+item_num).change(function(){
		getPostListByType(jQuery(this))
	});
	//新增活动
	jQuery(".add_new_item").unbind("click");
	jQuery(".add_new_item").click(function(){
		addNewItem(jQuery(this));
	});
	if(item_num - 1 >= 0){
		jQuery("#add_next_item_span_" +(item_num - 1)).attr("style","display:none;");
	}
	item_num++;
	jQuery(obj).attr("href","#"+jQuery(newItem).attr("id"));
}

//得到复制的活动区块
function getNewItem(index,item){
	if(item == null){
		item = jQuery("#item").clone();
		item.attr("style","");
		item.attr("id",item.attr("id")+"_"+index);
		//保存活动
	}
	jQuery(item).children().each(function(){
		//alert(jQuery(this).attr("id"));
		if(jQuery(this).attr("id")!=undefined && typeof(jQuery(this).attr("id"))!=""){
			jQuery(this).attr("id",jQuery(this).attr("id")+"_"+index);
		}
		if(jQuery(this).children().length>0){
			getNewItem(index,jQuery(this));
		}
	});
	
	//提示保存活动
	jQuery(".item_save_tip").change(function (){
		showSaveTip(jQuery(this),"item_tip");
	});
	return item;
}

//保存活动项目
function saveItem(obj){
	var arr = jQuery(obj).attr("id").split("_");
	var index = arr[arr.length-1];
	var plan_id = jQuery("#plan_id").val();
	if(plan_id==""){
		alert("请先保存计划");
		return;
	}
	if(jQuery("#item_start_time_"+index).val()==""){
		jQuery("#item_start_time_tip_"+index).html(MSG_ITEM_TIME_NULL);
		return;
	}
	if(jQuery("#item_type_"+index).val()==0){
		jQuery("#item_type_tip_"+index).html(MSG_ITEM_TYPE_NULL);
		return;
	}
	if(jQuery("#post_id_"+index).val()==0){
		jQuery("#post_id_tip_"+index).html(MSG_ITEM_POST_NULL);
		return;
	}
	var item_id = jQuery("#item_id_"+index).val();
	if(item_id == undefined || item_id == ""){
		var data={"plan_id":plan_id,
				"item_start_time":jQuery("#item_start_time_"+index).val(),
				"item_type":jQuery("#item_type_"+index).val(),
				"post_id":jQuery("#post_id_"+index).val()
			};
		sendAjax('pb_plan_add_item',data,function(res){
			if(res.code == "200"){
				jQuery("#item_id_"+index).val(res.item_id);
				saveItemSuccessStyle(index);
				if(index == item_num-1){
					jQuery("#add_next_item_span_" +index).attr("style","");
				}
			}
			else{
				alert(res.msg);
			}
		});
	}
	else{
		var data={"plan_id":plan_id,
				"item_id":jQuery("#item_id_"+index).val(),
				"item_start_time":jQuery("#item_start_time_"+index).val(),
				"item_type":jQuery("#item_type_"+index).val(),
				"post_id":jQuery("#post_id_"+index).val()
			};
		sendAjax('pb_plan_update_item',data,function(res){
			if(res.code == "200"){
				saveItemSuccessStyle(index);
			}
			else{
				alert(res.msg);
			}
		});
	}
}


//修改活动保存成功样式
function saveItemSuccessStyle(index){
	jQuery("#item_tip_"+index).attr("style","color:green");
	jQuery("#item_tip_"+index).html("已保存");
	jQuery("#item_start_time_tip_"+index).html("");
	jQuery("#item_type_tip_"+index).html("");
	jQuery("#post_id_tip_"+index).html("");

}

//删除活动
function delItem(obj){
	var r=confirm("是否确认删除该活动?");
	if(!r){
		return;
	}
	var arr = jQuery(obj).attr("id").split("_");
	var index = arr[arr.length-1];
	var plan_id = jQuery("#plan_id").val();
	if(plan_id==""){
		alert("计划不存在");
		return;
	}
	var item_id = jQuery("#item_id_"+index).val();
	if(item_id != undefined && item_id != ""){
		var data={"plan_id":plan_id,
				"item_id":jQuery("#item_id_"+index).val()
			};
		sendAjax('pb_plan_del_item',data,function(res){
			if(res.code == "200"){
				jQuery("#item_"+index).remove();
			}
		});
	}
	else{
		jQuery("#item_"+index).remove();
	}
}

//需保存提示
function showSaveTip(obj,tipName){
	var arr = jQuery(obj).attr("id").split("_");
	var index = arr[arr.length-1];
	jQuery("#"+tipName+"_"+index).attr("style","color:red");
	jQuery("#"+tipName+"_"+index).html("请保存");
}

//得到活动SELECT
function getPostListByType(obj){
	var arr = jQuery(obj).attr("id").split("_");
	var index = arr[arr.length-1];
	if(jQuery(obj).val() == 0){
		optionStr = "<option value=0>--请选择活动类型--</option>";
		jQuery("#post_id_"+index).html(optionStr);
		return;
	}
	var plan_id = jQuery("#plan_id").val();
	var data={"plan_id":plan_id,"type":jQuery(obj).val()};
	sendAjax('pb_plan_get_list',data,function(res){
		if(res.code == "200"){
			var optionStr = "";
			if(res.list.length > 0){
				res.list.forEach(function(item){
					optionStr = optionStr+"<option value="+item.id+">"+item.title+" ["+item.pb_start_time+" -- "+item.pb_end_time+"]</option>";
				});
			}else{
				optionStr = "<option value=0>--没有该类型活动--</option>";
			}
			jQuery("#post_id_"+index).html(optionStr);
		}
		else{
			alert(res.msg);
		}
	});
}