<script>
	var CONST_PHONE_HOST="<?php echo $_GET['cb']?>";
	//$(document).ready(function(){
		$("body").append('<img src="<?php echo bloginfo('template_directory');?>/ugen/img/lh-refresh.png" id="sf_sync_logo" style="height: 60px;width: 60px;position: fixed;right: 10px;z-index:999;top: 204px;">');
		$("#sf_sync_logo").bind("click",function(){
			//同步 大屏幕商品
			$.ajax({
				type:"GET",
				url:CONST_PHONE_HOST+"/goodsSync",
				dataType:"json",
				success: function(data){
					var url=CONST_PHONE_HOST+"/"+data.show+"/phoneGetGoods?id="+data.id;
					var pid=data.pid;
					if(pid){
						window.location.href=url+"&pid="+data.pid;
					}else{
						window.location.href=url;
					}
				}
			});
		});
//	});
</script>
