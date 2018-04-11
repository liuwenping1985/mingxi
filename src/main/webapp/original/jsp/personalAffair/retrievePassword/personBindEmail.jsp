<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>${ctp:i18n('personalInfo.track.bindemail')}</title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/retrievePassword/css/common.css${v3x:resSuffix()}" />"  />
	<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/retrievePassword/css/login.css${v3x:resSuffix()}" />" />
	<style type="text/css">
	</style>
	<script src="<c:url value="/apps_res/retrievePassword/js/login.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript">
var countdown = 60;
var verificationCode=document.getElementById("verificationCode");
function sendVerificationCodeToBindEmail(){
	var email='${param.email}';
	
	$(".gray_button").show();
	$(".get_code").hide();
	resend();
	  
	$.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/personalBind.do?method=sendVerificationCodeToBindEmail",
		data: {"email": email,"type":"bind"},
		dataType : 'text',
	      success : function(data) {
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	        	 alert("发送失败");
	        }
	});
}

function validatecode(){
    var verificationCode=document.getElementById("verificationCode").value;
	 if(verificationCode.trim()==""){
		$(".step_error").show();
		$(".error_close").show();
		$(".line_4").show();
		 return;
	 }
	 
	 $.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/personalBind.do?method=validateVerificationCode",
		data: {"verificationCode": verificationCode},
		dataType : 'text',
	      success : function(data) {
	    	  var content = jQuery.parseJSON(data);
	    	  var isequals=content.equals;
	    	     if(isequals=="true"){
	    			 $(".phone_bind_1").hide();
	    			 $(".phone_bind_2").css("display","inline-block");
	    			 bindsuccess();
	    		}else{
	    			$(".step_error").show();
	    			$(".error_close").show();
	    			$(".line_4").show();
	    		}
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	        	 alert("失败");
	        }
	 });
}

function bindsuccess(){
	 $.ajax({
			sync : true,
			type: "POST",
			url: "/seeyon/personalBind.do?method=bindSuccess",
			data: {"type":"email","code":'${param.email}'},
			dataType : 'text',
		      success : function(data) {
		    	  var content = jQuery.parseJSON(data);
		    	  var success=content.success;
		    	     if(success=="true"){
		    	    	 if(getA8Top().isCtpTop){
		    	    	 }else{
		    	    		 var _win =getA8Top().window.opener.getA8Top().$("#main")[0].contentWindow;
		    	    		 var url = _win.location.href;
		                     if (url.indexOf("personalInfo") != -1) {
		                         _win.location =  _win.location;
		                     }
		    	    	 }
		    	    	 //setTimeout( function() {window.close();}, 2000 );
		    		}else{
                       alert("绑定失败");
		    		}
		        },
		        error : function(XMLHttpRequest, textStatus, errorThrown) {
		        	 alert("失败");
		        }
		 });
}

function hiddenerr(){
	$(".step_error").hide();
	$(".error_close").hide();
	$(".line_4").hide();
}


function resend(val) {
	if (countdown == 0) {
		countdown = 60;
		$(".gray_button").hide();
		$(".get_code").show();
		$(".change_second").html(countdown);
	} else {
		countdown--;
		$(".change_second").html(countdown);
	setTimeout(function() { resend()}, 1000);
	}
	
}
	</script>
</head>
	<body  onselectstart="return false">
		<div class="container">
			<img src="<c:url value="/apps_res/retrievePassword/css/images/cloud_1.png${v3x:resSuffix()}"/>" class="cloud_1" width="141" height="78">
			<img src="<c:url value="/apps_res/retrievePassword/css/images/cloud_2.png${v3x:resSuffix()}"/>" class="cloud_2" width="70" height="39">
			<div class="found_pwd_top">
				<span class="found_pwd_title">${ctp:i18n('personalInfo.track.bindemail')}</span>
				<p class="found_pwd_msg">${ctp:i18n('personalInfo.bind.emailstepts')}</p>
			</div>
			<div class="found_pwd_body">
				<div class="phone_bind_1 phone" >
					<div class="step_3_header">
						<span class="font18">${ctp:i18n('personalInfo.bind.msg1')}“<span class="step_3_type">${ctp:i18n('personalInfo.track.bindemail')}</span>”${ctp:i18n('personalInfo.bind.msg3')}</span>
					</div>
					<div class="type_code">
						<p class="padding_l_10 margin_b_15">${ctp:i18n('personalInfo.bind.verifyemail')} <span class="check_type">${param.email}</span></p>
						<span class="relative left">
							<span class="input_error margin">
								<input type="text" style="width: 236px; height: 48px;border: 1px solid #cccccc; line-height: 48px;" id="verificationCode" name="verificationCode" onmousedown="hiddenerr();">
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />"  class="error_close"  style="display:none;" onclick="hiddenerr();">
								<span class="line_4" style="display:none;"></span>
							</span>
							<span class="step_error" style="display:none;">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner">
									<span class="error_info">${ctp:i18n('personalInfo.bind.verificationcodeerror')}</span>
								</span>
							</span>
						</span>
						<a href="javascript:sendVerificationCodeToBindEmail();" class="button get_code"  onclick="hiddenerr();">${ctp:i18n('personalInfo.bind.getverificationcode')}</a>
						<!-- 重新发送 -->
						<a href="javascript:;" class="button gray_button" style="display:none;"  onclick="hiddenerr();"><span class="change_second">60</span>${ctp:i18n('personalInfo.bind.resend')}</a>
					</div>
					<a href="javascript:;" class="button margin_t_20 phone_bind_button" onclick="validatecode();">${ctp:i18n('personalInfo.bind.title')}</a>
				</div>
				<div class="phone_bind_2" style="display:none;">
					<img src="<c:url value="/apps_res/retrievePassword/css/images/finsh.jpg${v3x:resSuffix()}" />" class="left" width="95" height="95">
					<span class="left phone_bind_success">
						<span class="success_info">${ctp:i18n('personalInfo.bind.msg4')}”${ctp:i18n('personalInfo.bind.emailtitle')}”${ctp:i18n('personalInfo.bind.success')}</span>
					</span>
				</div>
			</div>
		</div>
		 <input type="hidden" name="isSuccess" id="isSuccess" value="" />
	</body>
</html>
