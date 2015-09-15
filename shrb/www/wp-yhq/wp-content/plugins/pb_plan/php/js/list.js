jQuery(document).ready(function(){
	jQuery("#push_plan").click(function (){
		alert("push");
		return false;
	});
});

//删除计划
function delPlan(plan_id){
	var r=confirm("是否确认删除该计划?");
	if(!r){
		return;
	}
	if(plan_id != undefined && plan_id != ""){
		var data={"plan_id":plan_id
			};
		sendAjax('pb_plan_del_plan',data,function(res){
			if(res.code == "200"){
				location.reload() ;
			}
		});
	}
}


//生成文件
function createPlanFile(plan_id,box_id){
	if(plan_id != undefined && plan_id != ""){
		var data={"plan_id":plan_id,
				"box_id":box_id
			};
		sendAjax('pb_plan_create_file',data,function(res){
			if(res.code == "200"){
				alert("生成文件成功");
				location.reload() ;
			}
			else{
				alert(res.msg);
			}
		});
	}
}

//推送到盒子
function pushToBox(plan_id,box_id){
	if(box_id != undefined && box_id != ""){
		var data={"box_id":box_id,"plan_id":plan_id};
		sendAjax('pb_plan_push_box',data,function(res){
			if(res.code == "200"){
				alert("推送成功");
			}
			else{
				alert("推送失败");
			}
		});
	}
	
}