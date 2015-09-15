function sendAjax(action,data,fn){
		data.action = action;
		jQuery.ajax({
			type: "POST",
			url: myAjax.ajaxurl,
			dataType :"json",
			data: data
		})
		.done(fn);
}