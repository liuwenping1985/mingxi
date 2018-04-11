<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
<meta charset="utf-8">
<title>${ctp:i18n('personalInfo.bind.retrievepassword')}</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/retrievePassword/css/common.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/retrievePassword/css/login.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<style type="text/css">
.phcolor{color:#999;}
</style>
<script src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script src="<c:url value="/apps_res/retrievePassword/js/login.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var countdown = 60;
var o = new Object();
var supportPlaceholder=true;

$().ready(function() {
	initdate(null);
    //判断浏览器是否支持placeholder属性
    supportPlaceholder='placeholder'in document.createElement('input'),
    placeholder=function(input){
        var text = input.attr('placeholder'),
        defaultValue = input.defaultValue;
        if(!defaultValue){
            input.val(text).addClass("phcolor");
        }
        input.focus(function(){
            if(input.val() == text){
                $(this).val("");
            }
        });

        input.blur(function(){
            if(input.val() == ""){
                $(this).val(text).addClass("phcolor");
            }
        });
        //输入的字符不为灰色
        input.keydown(function(){
            $(this).removeClass("phcolor");
        });
    };
    
    placeholderpwd=function(input){
    	 var nowpwdtext = $("#nowpwdtext");
    	 var nowpwd = $("#nowpwd");
    	 
    	 var nowpwdconfirmtext = $("#nowpwdconfirmtext");
    	 var nowpwdconfirm = $("#nowpwdconfirm");
    	 
    	 nowpwdtext.focus(function(){
	    	 nowpwdtext.hide();
	    	 nowpwd.show().focus();
    	 });
    	 
    	 nowpwdconfirmtext.focus(function(){
    		 nowpwdconfirmtext.hide();
    		 nowpwdconfirm.show().focus();
         });
    	 
    	 nowpwd.focusout(function(){
    	 if(nowpwd.val().trim() === ""){
    		 nowpwd.hide();
    	 	 nowpwdtext.show();
    	 }
    	 });
    	 
    	 nowpwdconfirm.focusout(function(){
        	 if(nowpwdconfirm.val().trim() === ""){
        		 nowpwdconfirm.hide();
        		 nowpwdconfirmtext.show();
        	 }
         });
    };

    //当浏览器不支持placeholder属性时，调用placeholder函数
    if(!supportPlaceholder){
        $('input').each(function(){
            text = $(this).attr("placeholder");
            if($(this).attr("type") == "text"){
                placeholder($(this));
            }
            if($(this).attr("type") == "password"){
            	placeholderpwd($(this));
            }
        });
    }
});

//初始化人员绑定信息
function initdate(date){
	if(date==null){
		o.memberIsExist="false";
		o.loginName="";
		o.bindphonenumberEnable="false";
		o.telNumber="";
		o.bindemailEnable="false";
		o.email="";
		o.emailSetEnable="false"
		o.smsSetEnable="false";
		o.pwd_strong_require="weak";
		o.imgCodeEquals="false";
		o.pwd_strength_validation_enable="disable";
	}else{
		o.memberIsExist=date.memberIsExist;
		o.loginName=date.loginName;
		o.bindphonenumberEnable=date.bindphonenumberEnable;
		o.telNumber=date.telNumber;
		o.bindemailEnable=date.bindemailEnable;
		o.email=date.email;
		o.emailSetEnable=date.emailSetEnable;
		o.smsSetEnable=date.smsSetEnable;
		o.pwd_strong_require=date.pwd_strong_require;
		o.imgCodeEquals=date.imgCodeEquals;
		o.pwd_strength_validation_enable=date.pwd_strength_validation_enable;
	}
}

//图片验证码
function refreshImg(){
	hiddenerr_2();
	var verifyCodeImage=document.getElementById("verifyCodeImageId");
	verifyCodeImage.src="";
	$.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/main.do",
		data: {},
		dataType : 'text',
	      success : function(data) {
	    		verifyCodeImage.src="${path}/verifyCodeImage.jpg";
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	        	alert("失败");
	        }
	});

}


//获取已绑定方式
function getBindTypeByLoginName(){
	var loginName=document.getElementById("loginName").value;
	loginName = escapeStringToHTML(loginName);
	var img_verifyCode=document.getElementById("img_verifyCode").value;
	initdate(null);
	$.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/personalBind.do?method=getBindTypeByLoginName",
		data: {"loginName": loginName,"img_verifyCode": img_verifyCode},
		dataType : 'text',
	      success : function(data) {
	    	  var content = jQuery.parseJSON(data);
	    	  initdate(content);
	    	  refreshImg();
	    	  if(o.imgCodeEquals=="false"){
	    		  showerr_2();
	    		  return false;
	    	  }else if(o.memberIsExist=="false"){
	    		  showerr_1();
	    		  return false;
	    	  }else{
	    		  var emailCanUse = false;
	    		  var numCanUse = false;
	    		  //显示下一页
    			  $(".step_1").hide();
   				  $(".step_2").css("display","inline-block");
    			  $(".step_info_2").addClass("current");
    			  $(".step_info_2 img").attr("src","<c:url value="/apps_res/retrievePassword/css/images/current_2.jpg${v3x:resSuffix()}" />");

  	    		  //绑定了手机
  	    		  if( o.bindphonenumberEnable=='true' && o.smsSetEnable=='true'){
  		    		    $("#email_check2").show();
  		    		    $("#phone_bind2").hide();
  		    		    $("#your_phone").html(o.telNumber);
  		    		    $("#check_type_num").html(o.telNumber);
  		    		    numCanUse = true;
  		    		  }else{
  		    		    $("#email_check2").hide();
  		    		    $("#phone_bind2").show();
  		    		    numCanUse = false;
  	    		  }
  	    		  
  	    		  //绑定了邮箱
  	    		  if( o.emailSetEnable=='true' && o.bindemailEnable=='true'){
  	    		    $("#email_check1").show();
  	    		    $("#phone_bind1").hide();
  	    		    $("#your_email").html(o.email);
  	    		    $("#check_type_email").html(o.email);
  	    		    emailCanUse = true;
  	    		  }else{
  	    		    $("#email_check1").hide();
  	    		    $("#phone_bind1").show();
  	    		    emailCanUse = false;
  	    		  }
  	    		
	    		  if(!emailCanUse && !numCanUse){
  	    			  //提示没有可用方式
  	    			$("#isCanNotUse").show();
  	    		  }else{
  	    			$("#isCanNotUse").hide();
  	    		  } 
  	    		  
	    	  }
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	        	 initdate(null);
	        	 alert("失败");
	        }
	});
	
	//在第三步重新选择验证方式时，隐藏第三步页面
	$(".step_3").hide();
	hiddenerr_3();
	hiddenerr_4();
}


//重新选择验证方式
function reSelect(){
 var emailCanUse = false;
 var numCanUse = false;
 //显示下一页
 $(".step_1").hide();
 $(".step_2").css("display","inline-block");
 $(".step_info_2").addClass("current");
 $(".step_info_2 img").attr("src","<c:url value="/apps_res/retrievePassword/css/images/current_2.jpg${v3x:resSuffix()}" />");

	  //绑定了手机
	  if( o.bindphonenumberEnable=='true' && o.smsSetEnable=='true'){
		    $("#email_check2").show();
		    $("#phone_bind2").hide();
		    $("#your_phone").html(o.telNumber);
		    $("#check_type_num").html(o.telNumber);
		    numCanUse = true;
		  }else{
		    $("#email_check2").hide();
		    $("#phone_bind2").show();
		    numCanUse = false;
	  }
	  
	  //绑定了邮箱
	  if( o.emailSetEnable=='true' && o.bindemailEnable=='true'){
	    $("#email_check1").show();
	    $("#phone_bind1").hide();
	    $("#your_email").html(o.email);
	    $("#check_type_email").html(o.email);
	    emailCanUse = true;
	  }else{
	    $("#email_check1").hide();
	    $("#phone_bind1").show();
	    emailCanUse = false;
	  }
	
 if(!emailCanUse && !numCanUse){
		  //提示没有可用方式
		$("#isCanNotUse").show();
	  }else{
		$("#isCanNotUse").hide();
	  } 
	
	//在第三步重新选择验证方式时，隐藏第三步页面
	$(".step_3").hide();
	hiddenerr_3();
	hiddenerr_4();
}

//选择验证方式，进入具体验证页面
function immidiatevalidate(type){
	$(".step_2").hide();
	if(type=="email"){
		$("#step_3_email").show();
		$("#step_3_phone").hide();
	}
	if(type=="num"){
		$("#step_3_email").hide();
		$("#step_3_phone").show();
	}
	$(".step_info_3").addClass("current");
	$(".step_info_3 img").attr("src","<c:url value="/apps_res/retrievePassword/css/images/current_3.jpg${v3x:resSuffix()}" />");
	
}
 
 //进行验证
function sendVerificationCodeToBind(type){
	if(type=="email"){
		$("#gray_button_2").show();
		$("#get_code_2").hide();
	}else if(type=="num"){
		$("#gray_button_1").show();
		$("#get_code_1").hide();
	}
		
	 var method="";
	if(type=="email"){
	  method="sendVerificationCodeToBindEmail";
	}else if(type=="num"){
	  method="sendVerificationCodeToBindNum";
	}
	
	 resend(type);
	$.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/personalBind.do?method="+method,
		data: {"loginName":o.loginName,"type":"validate"},
		dataType : 'text',
	      success : function() {
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	        	 alert("发送失败");
	        }
	});
}

 //校验验证码
function validatecode(type){
     var verificationCode="";
	 if(type=='email'){
		 verificationCode=$("#verificationCode_email").val();
	 }else if(type=='num'){
		 verificationCode=$("#verificationCode_num").val();
	 }
	 
	 if(verificationCode.trim()==""){
		 if(type=='email'){
			 showerr_4();
		 }else if(type=='num'){
			 showerr_3();
		 }
		 return;
	 }
	 
	 $.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/personalBind.do?method=validateVerificationCode",
		data: {"loginName":o.loginName,"verificationCode": verificationCode},
		dataType : 'text',
	      success : function(data) {
	    	  var content = jQuery.parseJSON(data);
	    	  var isequals=content.equals;
	    	     if(isequals=="true"){
	    	 		$(".step_3").hide();
	    			$(".step_4").css("display","inline-block");
	    			$(".step_info_4").addClass("current");
	    			$(".step_info_4 img").attr("src","<c:url value="/apps_res/retrievePassword/css/images/current_4.jpg${v3x:resSuffix()}" />");
	    			if(o.pwd_strength_validation_enable=="enable"){
	    				$("#pwdStrengthId").show();
	    			}else{
	    				$("#pwdStrengthId").hide();
	    			}
	    			
	    			hiddenerr_5();
	    			hiddenerr_6();
	    			
	    			if(!supportPlaceholder){
	    				 $("#nowpwdtext").show();
	    				 $("#nowpwd").hide();
	    				 $("#nowpwdconfirmtext").show();
	    				 $("#nowpwdconfirm").hide();
	    				
	    			}
	    		}else{
	    			 if(type=='email'){
	    				 showerr_4();
	    			 }else if(type=='num'){
	    				 showerr_3();
	    			 }
	    		}
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	        	 alert("失败");
	        }
	 });

}
 
//登录名
function hiddenerr_1(){
	$("#step_error_1").hide();
	$("#error_close_1").hide();
	$("#line_4_1").hide();
}

function showerr_1(){
	$("#step_error_1").show();
	$("#error_close_1").show();
	$("#line_4_1").show();
}

//图片验证码
function hiddenerr_2(){
	$("#step_error_2").hide();
	$("#error_close_2").hide();
	$("#line_4_2").hide();
}

function showerr_2(){
	$("#step_error_2").show();
	$("#error_close_2").show();
	$("#line_4_2").show();
}

 //短信验证码
function hiddenerr_3(){
	$("#step_error_3").hide();
	$("#error_close_3").hide();
	$("#line_4_3").hide();
}

function showerr_3(){
	$("#step_error_3").show();
	$("#error_close_3").show();
	$("#line_4_3").show();
}

//邮箱验证码
function hiddenerr_4(){
	$("#step_error_4").hide();
	$("#error_close_4").hide();
	$("#line_4_4").hide();
}

function showerr_4(){
	$("#step_error_4").show();
	$("#error_close_4").show();
	$("#line_4_4").show();
}

//密码
function hiddenerr_5(){
	$("#step_error_5").hide();
	$("#error_close_5").hide();
	$("#line_4_5").hide();
}

function showerr_5(){
	$("#step_error_5").show();
	$("#error_close_5").show();
	$("#line_4_5").show();
}

//确认密码
function hiddenerr_6(){
	$("#step_error_6").hide();
	$("#error_close_6").hide();
	$("#line_4_6").hide();
}

function showerr_6(){
	$("#step_error_6").show();
	$("#error_close_6").show();
	$("#line_4_6").show();
}

function resend(type) {
	if (countdown == 0) {
		countdown = 60;
  		if(type=="email"){
			$("#gray_button_2").hide();
			$("#get_code_2").show();
		}else if(type=="num"){
			$("#gray_button_1").hide();
			$("#get_code_1").show();
		}
  		$(".change_second").html(countdown);
	} else {
		countdown--;
		$(".change_second").html(countdown);
	setTimeout(function() { resend(type)}, 1000);
	}
	
}

function resetPwd(){
	var errmsg=$("#errmsg");
	errmsg.html("");
	errmsg.hide();
	hiddenerr_5();
	hiddenerr_6();
	var nowpwd=$("#nowpwd").val();
	var nowpwdconfirm=$("#nowpwdconfirm").val()
	if(pwdvalidate(nowpwd,nowpwdconfirm) && pwdlength(nowpwd) && pwdStrong(nowpwd)){
		$.ajax({
			sync : true,
			type: "POST",
			url: "/seeyon/individualManager.do?method=resetPassword",
			data: {"nowpwd": nowpwd},
			dataType : 'text',
		      success : function(data) {
		    	  if(data=="true"){
			  		$(".step_4").hide();
					$(".step_5").css("display","inline-block");
					$(".step_info_5").addClass("current");
					$(".step_info_5 img").attr("src","<c:url value="/apps_res/retrievePassword/css/images/current_5.jpg${v3x:resSuffix()}" />");
		    	  }else{
		    		  alert("重置失败");
		    	  }
		        },
		        error : function(XMLHttpRequest, textStatus, errorThrown) {
		        	 alert("重置失败");
		        }
		});
	}

}

function pwdvalidate(nowpwd,nowpwdconfirm){
	if(nowpwd==""){
		showerr_5();
		return false;
	}

	if(nowpwdconfirm=="" || nowpwd!=nowpwdconfirm){
		showerr_6();
		return false;
	}
	return true;
}

function pwdlength(nowpwd){
	var errmsg=$("#errmsg");
	errmsg.html("");
	errmsg.hide();
	if(nowpwd.length<6){
		errmsg.html("${ctp:i18n('manager.vaildate.length.rep.lable')}");
		errmsg.show();
		return false;
	}
	return true;
}

//密碼強度必須在系统设置的密码强度以上
function pwdStrong(nowpwd) {
	var errmsg=$("#errmsg");
	errmsg.html("");
	errmsg.hide();
	
	if(o.pwd_strong_require=='medium'){
		if (!ClientSideMediumPassword(nowpwd, gSimilarityMap,gDictionary)
				&& !ClientSideStrongPassword(nowpwd, gSimilarityMap,gDictionary)
				&& !ClientSideBestPassword(nowpwd, gSimilarityMap, gDictionary)){
			errmsg.html("${ctp:i18n('manager.pwdStrength.medium')}</br>${ctp:i18n('manager.pwdStrength.mediumrule')}");
			errmsg.show();
			return false;
		}
	}else if(o.pwd_strong_require=='strong'){
		if (!ClientSideStrongPassword(nowpwd, gSimilarityMap,gDictionary)
				&& !ClientSideBestPassword(nowpwd, gSimilarityMap, gDictionary)){
			errmsg.html("${ctp:i18n('manager.pwdStrength.strong')}</br>${ctp:i18n('manager.pwdStrength.strongrule')}");
			errmsg.show();
			return false;
		}
	}else if(o.pwd_strong_require=='best'){
		if (!ClientSideBestPassword(nowpwd, gSimilarityMap, gDictionary)){
			errmsg.html("${ctp:i18n('manager.pwdStrength.best')}</br>${ctp:i18n('manager.pwdStrength.bestrule')}");
			errmsg.show();
			return false;
		}
	}
	return true;
}


	</script>
	</head>
	<body  onselectstart="return false">
		<div class="container" style="overflow:auto;">
			<div style="position:relative;z-index:1">
			<img src="<c:url value="/apps_res/retrievePassword/css/images/cloud_1.png${v3x:resSuffix()}" />" class="cloud_1" width="141" height="78">
			<img src="<c:url value="/apps_res/retrievePassword/css/images/cloud_2.png${v3x:resSuffix()}" />" class="cloud_2" width="70" height="39">
			</div>
			<div class="found_pwd_top" style="position: relative;z-index:2;">
				<span class="found_pwd_title">${ctp:i18n('personalInfo.bind.retrievepassword')}</span>
				<p class="found_pwd_msg">${ctp:i18n('personalInfo.bind.operationsteps')}</p>
			</div>
			<div class="found_pwd_body">
				<div class="steps">
					<span class=" step_info step_info_1 current">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/current_1.jpg${v3x:resSuffix()}" />">
						<span class="step_name">${ctp:i18n('personalInfo.bind.retrievepassword')}</span>
					</span>
					<span class="step_info step_info_2">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/2.jpg${v3x:resSuffix()}" />">
						<span class="step_name">${ctp:i18n('personalInfo.bind.selectverificationmode')}</span>
					</span>
					<span class="step_info step_info_3">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/3.jpg${v3x:resSuffix()}" />">
						<span class="step_name">${ctp:i18n('personalInfo.bind.validate')}</span>
					</span>
					<span class="step_info step_info_4">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/4.jpg${v3x:resSuffix()}" />">
						<span class="step_name">${ctp:i18n('personalInfo.bind.resetpassword')}</span>
					</span>
					<span class="step_info step_info_5">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/5.jpg${v3x:resSuffix()}" />">
						<span class="step_name">${ctp:i18n('personalInfo.bind.resetfinish')}</span>
					</span>
				</div>
				<div class="step_1">
					<span class="input_info ">
						<span class="relative">
							<span class="input_error found_input_info ">
								<input type="text" id="loginName" name="loginName" onmousedown="hiddenerr_1();" placeholder="${ctp:i18n('personalInfo.bind.enterloginname')}" style="width:360px;height: 48px;border: 1px solid #eceef0;padding-left: 20px;display: inline-block; line-height: 48px;">
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />" class="error_close" style="display:none;" id="error_close_1">
								<span class="line_4" style="display:none;" id="line_4_1"></span>
							</span>
							<span class="step_error" style="display:none;" id="step_error_1">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner" >
									<span class="error_info">${ctp:i18n('personalInfo.bind.invalidusername')}</span>
								</span>
							</span>
						</span>
						
					</span>
					<span class="code_info">
						<span class="relative">
							<span class="input_error margin">
								<input type="text" id="img_verifyCode" onmousedown="hiddenerr_2();" placeholder="${ctp:i18n('personalInfo.bind.verificationcode')}" style="width: 180px;height: 48px;padding-left: 20px;float: left;border: 1px solid #eceef0;display: inline-block; line-height: 48px;">
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />" class="error_close" style="display:none;" id="error_close_2">
								<span class="line_4" style="display:none;" id="line_4_2"></span>
							</span>
							<span class="step_error" style="display:none;" id="step_error_2">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner">
									<span class="error_info">${ctp:i18n('personalInfo.bind.verificationcodeerror')}</span>
								</span>
							</span>
						</span>
						
						<span class="code">
							<img src="${path}/verifyCodeImage.jpg" id="verifyCodeImageId"  width="120" onclick="refreshImg();">
						</span>
					</span>
					<a href="javascript:;" class="button next_button" onclick="getBindTypeByLoginName();">${ctp:i18n('personalInfo.bind.next')}</a>
				</div>
				<div class="step_2" style="display:none;">
					<div id="isCanNotUse" style="text-align:center;margin-bottom:20px;">
						<span style="color:#fe4800;">${ctp:i18n('personalInfo.bind.cannotretrieve')}</span>
					</div>
					<div class="email_check" style="display:none;margin-bottom:20px;" id="email_check1">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/email.jpg${v3x:resSuffix()}" />" width="113" height="71" class="left_img">
						<span class="step_2_center">
							<p class="step_2_title">${ctp:i18n('personalInfo.bind.mailboxretrieve')}</p>
							<p class="step_2_content">${ctp:i18n('personalInfo.bind.msg5')}  <span class="your_email" id="your_email"></span>  ${ctp:i18n('personalInfo.bind.msg6')}</p>
						</span>
						<a href="javascript:;" class="min_button check_button" onclick="immidiatevalidate('email');">${ctp:i18n('personalInfo.bind.immediatevalidate')} <img src="<c:url value="/apps_res/retrievePassword/css/images/right.png${v3x:resSuffix()}" />" class="min_button_right" width="8" height="12"></a>
					</div>
					<div class="phone_bind" style="display:none;margin-bottom:20px;" id="phone_bind1">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/email.jpg${v3x:resSuffix()}" />" width="106" height="74" class="left_img">
						<span class="step_2_center">
							<p class="step_2_title">${ctp:i18n('personalInfo.bind.mailboxretrieve')}</p>
							<p class="step_2_content">${ctp:i18n('personalInfo.bind.noretrievefromemil')}</p>
						</span>
						<a href="javascript:;" class="no_bind">${ctp:i18n('personalInfo.bind.notbound')}</a>
					</div>
					
					<div class="email_check" style="display:none;margin-bottom:20px;" id="email_check2">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/phone.jpg${v3x:resSuffix()}" />" width="113" height="71" class="left_img">
						<span class="step_2_center">
							<p class="step_2_title">${ctp:i18n('personalInfo.bind.phoneretrieve')}</p>
							<p class="step_2_content">${ctp:i18n('personalInfo.bind.msg5')}<span class="your_email" id="your_phone"></span>${ctp:i18n('personalInfo.bind.msg7')}</p>
						</span>
						<a href="javascript:;" class="min_button check_button" onclick="immidiatevalidate('num');">${ctp:i18n('personalInfo.bind.immediatevalidate')} <img src="<c:url value="/apps_res/retrievePassword/css/images/right.png${v3x:resSuffix()}" />" class="min_button_right" width="8" height="12"></a>
					</div>
					<div class="phone_bind" style="display:none;margin-bottom:20px;" id="phone_bind2">
						<img src="<c:url value="/apps_res/retrievePassword/css/images/phone_nobind.jpg${v3x:resSuffix()}" />" width="106" height="74" class="left_img">
						<span class="step_2_center">
							<p class="step_2_title">${ctp:i18n('personalInfo.bind.phoneretrieve')}</p>
							<p class="step_2_content">${ctp:i18n('personalInfo.bind.noretrievefromnum')}</p>
						</span>
						<a href="javascript:;" class="no_bind">${ctp:i18n('personalInfo.bind.notbound')}</a>
					</div>
				</div>
				<div class="step_3 phone" style="display:none;" id="step_3_phone">
					<div class="step_3_header">
						<span class="font18">${ctp:i18n('personalInfo.bind.msg1')}“<span class="step_3_type">${ctp:i18n('personalInfo.bind.phonenumtitle')}</span>”${ctp:i18n('personalInfo.bind.msg8')}</span>
					</div>
					<div class="type_code">
						<p class="padding_l_10 margin_b_15">${ctp:i18n('personalInfo.bind.verifynumber')} <span class="check_type" id="check_type_num"></span></p>
						<span class="relative left">
							<span class="input_error margin">
								<input type="text" style="width: 236px;height: 48px;border: 1px solid #cccccc; line-height: 48px;" id="verificationCode_num" name="verificationCode_num" onmousedown="hiddenerr_3();" >
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />" class="error_close" id="error_close_3" style="display:none;" onclick="hiddenerr_3();">
								<span class="line_4" style="display:none;" id="line_4_3"></span>
							</span>
							<span class="step_error" style="display:none;" id="step_error_3">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner">
									<span class="error_info">${ctp:i18n('personalInfo.bind.verificationcodeerror')}</span>
								</span>
							</span>
						</span>
						<a href="javascript:sendVerificationCodeToBind('num');" class="button get_code"  onclick="hiddenerr_3();" id="get_code_1">${ctp:i18n('personalInfo.bind.getverificationcode')}</a>
						<!-- 重新发送 -->
						<a href="javascript:hiddenerr_3();" class="button gray_button" style="display:none;" id="gray_button_1"><span class="change_second">60</span>${ctp:i18n('personalInfo.bind.resend')}</a>
					</div>
					<a href="javascript:validatecode('num');" class="button margin_t_20 step_3_next">${ctp:i18n('personalInfo.bind.next')}</a>
					<a href="javascript:reSelect();" class="choose_new">${ctp:i18n('personalInfo.bind.reselect')}</a>
				</div>
				<div class="step_3 email" style="display:none;" id="step_3_email">
					<div class="step_3_header">
						<span class="font18">${ctp:i18n('personalInfo.bind.msg1')}“<span class="step_3_type">${ctp:i18n('personalInfo.bind.emailtitle')}</span>”${ctp:i18n('personalInfo.bind.msg9')}</span>
					</div>
					<div class="type_code">
						<p class="padding_l_10 margin_b_15">${ctp:i18n('personalInfo.bind.verifyemail')}<span class="check_type" id="check_type_email"></span></p>
						<span class="relative left">
							<span class="input_error margin">
								<input type="text" style="width: 236px;height: 48px;border: 1px solid #cccccc;line-height: 48px;" id="verificationCode_email" name="verificationCode_email" onmousedown="hiddenerr_4();">
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />" class="error_close" id="error_close_4"  style="display:none;" onclick="hiddenerr_4();">
								<span class="line_4" style="display:none;" id="line_4_4"></span>
							</span>
							<span class="step_error" style="display:none;" id="step_error_4">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner">
									<span class="error_info">${ctp:i18n('personalInfo.bind.verificationcodeerror')}</span>
								</span>
							</span>
						</span>
						<a href="javascript:sendVerificationCodeToBind('email');" class="button get_code" onclick="hiddenerr_4();" id="get_code_2">${ctp:i18n('personalInfo.bind.getverificationcode')}</a>
						<!-- 重新发送 -->
						<a href="javascript:hiddenerr_4();" class="button gray_button" style="display:none;" id="gray_button_2"><span class="change_second">60</span>${ctp:i18n('personalInfo.bind.resend')}</a>
					</div>
					<a href="javascript:validatecode('email');" class="button margin_t_20 step_3_next">${ctp:i18n('personalInfo.bind.next')}</a>
					<a href="javascript:reSelect();" class="choose_new">${ctp:i18n('personalInfo.bind.reselect')}</a>
				</div>
				<div class="step_4" style="display:none;">
					<span class="step_4_input">
						<span class="relative">
							<span class="input_error found_input_info ">
								<input type="password" placeholder="${ctp:i18n('personalInfo.bind.newpwd')}" id="nowpwd" style="width: 360px;height: 48px;border: 1px solid #eceef0;padding-left: 20px;display: inline-block;line-height: 48px;" onKeyUp="EvalPwdStrength(null,this.value);" onmousemove="EvalPwdStrength(null,this.value);" onmousedown="hiddenerr_5();" >
								<input type="text" placeholder="${ctp:i18n('personalInfo.bind.newpwd')}" id="nowpwdtext" style="width: 360px;height: 48px;border: 1px solid #eceef0;padding-left: 20px;display: none;line-height: 48px;" >
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />" class="error_close"  style="display:none;" id="error_close_5">
								<span class="line_4" style="display:none;" id="line_4_5"></span>
							</span>
							<span class="step_error" style="display:none;" id="step_error_5">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner">
									<span class="error_info">${ctp:i18n('personalInfo.bind.invalidpassword')}</span>
								</span>
							</span>
						</span>
						
					</span>
					</span>
					<p style="width: 360px;height: 30px;padding-left: 0px;display: none; color: red" id="errmsg" align="left"></p>
					<span id="pwdStrengthId">
					<tr>
							<td class="bg-gray" width="10%" nowrap="nowrap"><label
									for="post.code">${ctp:i18n('common.pwd.pwdStrength.label')}:</label></td>
							<td class="new-column" width="80%">
							<table cellpadding="0" cellspacing="0" class="pwdChkTbl2">
								<tr>
									<td id="idSM1" width="25%" class="pwdChkCon0" align="center"><span
										style="font-size:1px">&nbsp;</span><span id="idSMT1"
										style="display:none;">${ctp:i18n('common.pwd.pwdStrength.value1')}</span></td>
									<td id="idSM2" width="25%" class="pwdChkCon0" align="center"
										style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span>
										<span id="idSMT0" style="display:inline;font-weight:normal;color:#666">${ctp:i18n('common.pwd.pwdStrength.value0')}</span>
										<span id="idSMT2" style="display:none;">${ctp:i18n('common.pwd.pwdStrength.value2')}</span></td>
									<td id="idSM3" width="25%" class="pwdChkCon0" align="center"
										style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span
										id="idSMT3" style="display:none;">${ctp:i18n('common.pwd.pwdStrength.value3')}</span></td>
									<td id="idSM4" width="25%" class="pwdChkCon0" align="center"
										style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span
										id="idSMT4" style="display:none;">${ctp:i18n('common.pwd.pwdStrength.value4')}</span></td>
								</tr>
							</table>
						</td>
					</tr>
					</span>
					
					<span class="step_4_input">
						<span class="relative">
							<span class="input_error found_input_info ">
								<input type="password" placeholder="${ctp:i18n('personalInfo.bind.confirmpwd')}" id="nowpwdconfirm" style="width: 360px;height: 48px;border: 1px solid #eceef0;padding-left: 20px;display: inline-block;line-height: 48px;" onmousedown="hiddenerr_6();">
								<input type="text" placeholder="${ctp:i18n('personalInfo.bind.confirmpwd')}"  id="nowpwdconfirmtext" style="width: 360px;height: 48px;border: 1px solid #eceef0;padding-left: 20px;display: none;line-height: 48px;">
								<img src="<c:url value="/apps_res/retrievePassword/css/images/error_close.png${v3x:resSuffix()}" />" class="error_close" style="display:none;" id="error_close_6">
								<span class="line_4" style="display:none;" id="line_4_6"></span>
							</span>
							<span class="step_error" style="display:none;" id="step_error_6">
								<span class="error_msg">
									<img src="<c:url value="/apps_res/retrievePassword/css/images/error_corner.png${v3x:resSuffix()}" />" class="error_corner">
									<span class="error_info">${ctp:i18n('personalInfo.bind.invalidrepassword')}</span>
								</span>
							</span>
						</span>
						
					</span>
					<a href="javascript:resetPwd();" class="button reset_button">${ctp:i18n('personalInfo.bind.immediatereset')}</a>
				</div>
				<div class="step_5" style="display:none;">
					<img src="<c:url value="/apps_res/retrievePassword/css/images/finsh.jpg${v3x:resSuffix()}" />" class="left" width="95" height="95">
					<span class="left step_5_success">
						<span class="success_info margin_tb_15">${ctp:i18n('personalInfo.bind.resetsuccess')}</span>
						<a class="login_now" target="_self" href="/seeyon/main.do">${ctp:i18n('personalInfo.bind.immediatelogin')}</a>
					</span>
				</div>
			</div>
		</div>
	</body>
</html>