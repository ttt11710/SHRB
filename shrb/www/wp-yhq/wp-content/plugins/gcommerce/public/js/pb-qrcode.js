jQuery( function($){
	$(document).ready(function(){
		var oid=$("#qrcode").data('id');
		console.log(oid);
		$("#qrcode").qrcode(""+oid+"");
	});
});
