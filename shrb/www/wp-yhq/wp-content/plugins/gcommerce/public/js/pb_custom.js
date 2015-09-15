(function( $ ){
	if ($('body.page-id-35').length ) {
		$('body.page-id-35 .stage-slider .image-wrapper').click(function(){
			pbhref = $(this).parent().find('.caption-wrap a').attr("href");
			if (pbhref.length) {
				window.location = pbhref;
			}
		});
		$('.stage-slider-wrap.islider,.post-gallery-wrap,.group-slider.shortcode,.gallery-wrap.vertical').off( "mouseenter mouseleave" );
	} else if ($('body.page-id-11').length || $('body.page-id-10').length){
		console.log('aa');
		$('body.page-id-10 #gotoSignup, body.page-id-10 #gotoLogin').click(function(){
			$('body.page-id-10 .flip-front').toggle();
			$('body.page-id-10 .flip-back').toggle();
		});
		$('body.page-id-10 .login,body.page-id-11 .login').validate({
			rules: {
				username: "required",
				password: "required"
			},
			messages: {
				username: "请输入用户名",
				password: "请输入密码"
			},
			submitHandler: function(form) {
   				form.submit();
  			}
		});
		$('body.page-id-10 .register,body.page-id-11 .register').validate({
			rules: {
				username: {
					required:true,
					digits:true,
					minlength:11
				},
				vcode: {
					required:true,
					minlength:6
				},
				password: {
					required:true,
					minlength:6
				},
				password2: {
					required:true,
					minlength:6,
					equalTo: "#reg_password"
				},
				regagreement: {
					required:true
				}
			},
			messages: {
				username: {
					required:"请输入用户名",
					digits:"请使用手机号作为用户名",
					minlength:"请使用手机号作为用户名"
				},
				vcoed: {
					required:"请输入验证码",
					minlength:"验证码要6位"
				},
				password: {
					required:"请输入密码",
					minlength:"密码至少需要6位"
				},
				password2: {
					required:"请输入密码",
					minlength:"密码至少需要6位",
					equalTo: "两次输入密码不一致"
				},
				regagreement: {
					required:"您必须阅读并同意《感触服务协议》才可以注册"
				}
			},
			submitHandler: function(form) {
   				form.submit();
  			}
		});
		//lost_reset_password
		$('body.page-id-11 .input_phone_num').validate({
			rules: {
				user_login:  {
					required:true,
					digits:true,
					minlength:11
				}
			},
			messages: {
				user_login: {
					required:"请输入手机号",
					digits:"请输入手机号",
					minlength:"请输入手机号"
				}
			},
			submitHandler: function(form) {
   				form.submit();
  			}
		});
		$('body.page-id-11 .input_verify_code').validate({
			rules: {
				ver_key:  {
					required:true
					//digits:true,
					//minlength:11
				}
			},
			messages: {
				ver_key: {
					required:"请输入验证码"
					//digits:"请输入手机号",
					//minlength:"请输入手机号"
				}
			},
			submitHandler: function(form) {
				newRef = window.location + '?key=' + $('#ver_key').val() + '&login=' + $('#ver_phone').val();
				//alert(newRef);
				if ( (navigator.userAgent.indexOf('Android') != -1) ) {
					document.location = newRef;
				} else {
					window.location = newRef;					
				}
   				return false;
  			}
		});
		$('body.page-id-11 .input_new_password').validate({
			rules: {
				password_1: {
					required:true,
					minlength:6
				},
				password_2: {
					required:true,
					minlength:6,
					equalTo: "#password_1"
				}
			},
			messages: {
				password_1: {
					required:"请输入密码",
					minlength:"密码至少需要6位"
				},
				password_2: {
					required:"请输入密码",
					minlength:"密码至少需要6位",
					equalTo: "两次输入密码不一致"
				}
			},
			submitHandler: function(form) {
   				form.submit();
  			}
		});
		// $('body.page-id-14 #regagreetext').colorbox(
		// 	{
		// 		title: "拍贝服务协议",
		// 		width: "90%",
		// 		height: "90%",
		// 		initialWidth: 200,
		// 		initialHeight: 400				
		// 	}
		// );
		//reset_pw_btn		
		// $('body.page-id-14 #reset_pw_btn').click(function(){
		// 	pbhref = $(this).parent().find('.caption-wrap a').attr("href");
		// 	if (pbhref.length) {
		// 		window.location = pbhref;
		// 	}			
		// 	return false;
		// });


	} else if ($('body.page-id-74').length){
		// $('body.page-id-74 #billing_invoice_checkbox').click(function(){
		// 	if(this.checked) {
		// 		$('body.page-id-74 #billing_invoice_name_field').show();				
		// 	} else {
		// 		$('body.page-id-74 #billing_invoice_name_field').hide();								
		// 	}
		// });
	} else {
		// $( '#simple-menu' ).click(
		// 	function(){
		//  		$( '#responsive-menu' ).css( 'height', $( document ).height() );
		//  		if( !isOpen ) {
		//  			openRM();
		//  			isOpen = true;
		//  		}else{
		//  			closeRM();
		//  		isOpen = false
		//  		}
		//  	});		
		//$('#simple-menu').sidr({'side':'right'});
	}
	if (history.length) {
		$('#pb-back').click(function(){
			window.history.back(-1);
			return false;
			// history.back();
		});			
	} else {
		$('#pb-back').hide();
	}

})( jQuery );
