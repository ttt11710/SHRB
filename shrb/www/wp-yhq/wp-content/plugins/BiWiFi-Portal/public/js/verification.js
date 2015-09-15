(function( $ ) {
	$(document).ready(function(){
		var ajax_url = '/wp-admin/admin-ajax.php';
		$("#get_code").click(function(){
			var phone=$("#portal_phone").val();
			var yz=/^(13[0-9]|15[0-35-9]|18[0-9]|14[57])+\d{8}$/;
			if(!yz.test(phone))
			{
				alert('手机号码错误');
				return;
			}
			$.ajax({
				type:'get',
				url:ajax_url+"?action=get_verification&phone="+phone,
				dataType:'json',
				success:function(data){
					console.log(data.status);
					if(data.status==200)
					{
						alert(data.msg);
					}
					else
					{
						alert(data.msg);
					}
				}
			});
		});
		$("#verification").click(function(){
			var phone=$("#portal_phone").val();
			var verification=$("#portal_code").val();
			
			$.ajax({
				type:'get',
				url:ajax_url+"?action=is_by&phone="+phone+"&code="+verification,
				dataType:'json',
				success:function(data){
					console.log(data.status);
					if(data.status==200)
					{
						var url=$("#sms").val();
						window.location.href=url;
					}
					else
					{
						alert('验证码错误');
					}
				}
			});
		});
	});

})( jQuery );
