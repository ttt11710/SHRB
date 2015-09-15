jQuery( function($){
	$('button.pb_status2paid').click( function(){
		var answer = confirm('请先确认用户是否确实已支付成功！');
		if (answer) {
			$('#order_status').val('paid');
			$('.order_actions .save_order').click();
		}
	});
	$('button.pb_status2confirmed').click( function(){
		var answer = confirm('请先确认订单支付状态及详细信息！');
		if (answer) {
			$('#order_status').val('confirmed');
			$('.order_actions .save_order').click();
		}
	});
	$('button.pb_status2shipping').click( function(){
		var answer = confirm('请先确认运单号是否正确填写！');
		if (answer) {
			$('#order_status').val('shipping');
			$('.order_actions .save_order').click();
		}
	});
	$('button.pb_status2completed').click( function(){
		var answer = confirm('请先确认送货是否完成！');
		if (answer) {
			$('#order_status').val('completed');
			$('.order_actions .save_order').click();
		}
	});
});
