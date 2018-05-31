<%--
 $Author: wangchw $
 $Rev: 51772 $
 $Date:: 2016-01-05 19:52:32#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ page import="com.seeyon.ctp.common.constants.LoginConstants"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:if test="${_SecuritySeed != null}">
<script type="text/javascript" src="${path}/main/common/js/crypto.js${ctp:resSuffix()}"></script>
</c:if>
<script type="text/javascript" src="${path}/main/common/js/jquery.qrcode.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/common/js/qrcode-uuid.js${ctp:resSuffix()}"></script>
<c:if test="${adSSOEnable}">
<%
if(request.getHeader("authorization")==null) {
  response.setStatus(401);
  response.setHeader("Cache-Control", "no-store");
  response.setDateHeader("Expires", 0L);
  response.addHeader("WWW-Authenticate", "Negotiate");
}
%>
</c:if>
<META HTTP-EQUIV="pragma" CONTENT="no-cache" /> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-store, must-revalidate" /> 
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT" /> 
<META HTTP-EQUIV="expires" CONTENT="0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script type="text/javascript">

	var interval;
	var sendFlag = false;
	var wechatLoginManager=RemoteJsonService.extend({
		jsonGateway : "${path}/ajax.do?method=ajaxAction&managerName=wechatLoginManager",
		isLogin: function(){
	    	return this.ajaxCall(arguments, "isLogin");
	    }
	});
		
	var ajaxWechatLoginManager = new wechatLoginManager();
	function loginForWechat(){
		var random = $("#random").val();
		ajaxWechatLoginManager.isLogin(random,{
			success : function(data) {
				if(data != "loginError"){
					$("#login_username").val(data);
					//$("#login_password").val("123456");
					$("#login_button").click();
				} else {
					sendFlag = true;
				}
			}
		});
	}

	//轮询请求，防止后台阻塞
	function intervalLogin(){
		if(sendFlag){
			sendFlag = false;
			loginForWechat();
		}
	}
	
	function hideLogin() {
		$(".maskBg").click(function() {
			$(".login_pos").hide();
			$(".maskBg").remove();
		})
	}

	function showMask(){
		var html = $('<div class="maskBg" style="background:#000; opacity: .5; filter:alpha(opacity=50); position: absolute; width:100%; height: 100%; top:0; left:0; z-index: 10; "></div>');
		$("body").append(html);
	}
	
	//二维码登陆
	function changeLoginMode () {
		$(".pwdBtn").click(function () {
			clearInterval(interval);
			$(this).hide();
			$(".qrCode_area").hide();
			$(".loginForm_area").removeClass("opacity80");
			$(".qrCodeBtn").show();
			$(".pwd_area").show();
			$("#qrcode1 .qrcode").empty();
		});
		$(".qrCodeBtn").click(function () {
			$("#login_error").hide();
			$(this).hide();
			$(".pwd_area").hide();
			$(".pwdBtn").show();
			$(".qrCode_area").show();
			var date = new Date();
			var dateNumber = date.getTime();
			var random="seeyon-" + Math.uuid() + "-" + dateNumber;
			var qrcodeRandom = "http://weixin.seeyon.com/mobilehelp.jsp?random=" + random;
			$("#random").val(random);
			//table方式进行图片渲染
      if(typeof(isA6sLoginPage)=="undefined"){
        $("#qrcode1 .qrcode").qrcode({
          render: "table", //table方式
          width: 57, //宽度
          height: 57, //高度
          text: utf16to8(qrcodeRandom) //任意内容
        });
      }else{
        $("#qrcode1 .qrcode").qrcode({
          render: "table", //table方式
          width: 114, //宽度
          height: 114, //高度
          text: utf16to8(qrcodeRandom) //任意内容
        });
      };
			
			//canvas方式进行图片渲染
			//$("#qrcode .qrcode").qrcode(utf16to8(qrcodeRandom));
			loginForWechat();
			interval = setInterval("intervalLogin()", 1000);
		});
		$("#flashQrcode").click(function(){
			$("#qrcode1 .qrcode").empty();
			var date = new Date();
			var dateNumber = date.getTime();
			var random="seeyon-" + Math.uuid() + "-" + dateNumber;
			var qrcodeRandom = "http://weixin.seeyon.com/mobilehelp.jsp?random=" + random;
			$("#random").val(random);
			//table方式进行图片渲染
			if(typeof(isA6sLoginPage)=="undefined"){
        $("#qrcode1 .qrcode").qrcode({
          render: "table", //table方式
          width: 57, //宽度
          height: 57, //高度
          text: utf16to8(qrcodeRandom) //任意内容
        });
      }else{
        $("#qrcode1 .qrcode").qrcode({
          render: "table", //table方式
          width: 114, //宽度
          height: 114, //高度
          text: utf16to8(qrcodeRandom) //任意内容
        });
      };
			//canvas方式进行图片渲染
			//$("#qrcode .qrcode").qrcode(utf16to8(qrcodeRandom));
		});
	}
	
	//识别中文，暂时未用，目前随机数不包含中文
	function utf16to8(str) {
        var out, i, len, c;
        out = "";
        len = str.length;
        for (i = 0; i < len; i++) {
            c = str.charCodeAt(i);
            if ((c >= 0x0001) && (c <= 0x007F)) {
                out += str.charAt(i);
            } else if (c > 0x07FF) {
                out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
                out += String.fromCharCode(0x80 | ((c >> 6) & 0x3F));
                out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
            } else {
                out += String.fromCharCode(0xC0 | ((c >> 6) & 0x1F));
                out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
            }
        }
        return out;
    }

	//NC Portal
	try{
		if(parent.frame_A8){
			if("${ctp:hasPlugin('nc')}" == "true"){		
			   var ncPortalUrl = "${ctp:getSystemProperty('nc.portal.url')}";
			   var ncUrl= "${ctp:getSystemProperty('nc.server.url.prefix')}";
			   if(ncPortalUrl!=null&&ncPortalUrl!=''){
			      window.location.href = ncPortalUrl+"/portal/logoutA8.jsp";
			   }else{
			     window.location.href = ncUrl+"/portal/logoutA8.jsp";
			   }
			}	
		}
	}catch(e){}
	
  $.ctx.template = <c:out value="${templatesJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.hotSpots = <c:out value="${hotSpotsJsonStr}" default="null" escapeXml="false"/>;
  var loginResult = "${sessionScope['login.result']}";
  $(function() {
	  $("#login_form").append("<input type='hidden' name='random' id='random' value='' />");
	  <c:if test="${_SecuritySeed != null}">
      //开启前端加密以后，不允许自动保存密码
      $("#login_password").attr("autocomplete","off");
      $("#login_username").val("");
      $("#login_password").val("");
      </c:if>
    if(loginResult){
      $("#login_error").html(loginResult);
      $("#login_error").show();
      if($("#login_pos").length > 0){
    	  $("#login_pos").show();
       	  showMask();
       	  hideLogin();
      }
    }else{
      $("#login_error").hide();
    }
    if(seeyonProductId == 7){
      //如果是a6s
      var localeCfg = [{"eleid":"login_locale","defaultValue":"zh_CN","options":{"zh_CN":"中文（简体）"}}];
    } else {
      var localeCfg = <c:out value="${locales}" default="null" escapeXml="false"/>;
      if(seeyonProductId == 3 || seeyonProductId == 4){
          delete localeCfg[0].options.en;
      }
    }
    $.fillOption(localeCfg);

/**
    $("#login_locale").change(function() {
      $("#login_locale").jsonSubmit({
        action : _ctxPath + '/main.do?method=changeLocale'
      });
    });**/

    var _dropdownObj =$.dropdown({
          id:'login_locale',
          onchange:function(){
              $("#login_locale").jsonSubmit({
                action : _ctxPath + '/main.do?method=changeLocale'
              });
          }
    });
    _dropdownObj.setValue(_locale);
	
    $("#login_form").submit(function() {
      //登陆请求发出后，按钮置灰
      $("#login_button").attr("disabled","disabled");
      //var _bodyWidth = document.documentElement.clientWidth;
      //var _bodyHeight = document.documentElement.clientHeight;
      var _screenWidth = window.screen.width;
      var _screenHeight = window.screen.height;
      var font_size = 12;

      /*if(_bodyWidth <= 1024){
    	  font_size = 12;
      }else if(_bodyWidth <= 1600){
    	  font_size = 14;
      }else if(_bodyWidth <= 2500){
    	  font_size = 16;
      }else{
    	  font_size = 18;
      }*/
      
      $("#login_form").append("<input type='hidden' name='fontSize' value='"+font_size+"' />").append("<input type='hidden' name='screenWidth' value='"+_screenWidth+"' />").append("<input type='hidden' name='screenHeight' value='"+_screenHeight+"' />");
      <c:if test="${_SecuritySeed != null}">
      var us = CryptoJS.enc.Utf8.parse($("#login_password").val());
      var encrypted = CryptoJS.DES.encrypt(us, '${_SecuritySeed}');
      $("#login_password").val(encrypted);
      </c:if>
      var loginFlag = true;
      if(loginCallback) {
        if(!loginCallback())
          loginFlag = false;
      }
      var hasPluginCA = ${hasPluginCA};
      var caFactory = '${caFactory}';
      if(hasPluginCA&&caFactory!=''){
        if("koal"!="${caFactory}" && "Jit"!="${caFactory}"){
          checkCaCert();
        }
        if("koal"!="${caFactory}" && isCa){
          caSign();
        }
      }
      ${activeXLoader};

      return loginFlag;
    });
    
    $("#login_password").keydown(function(event){
    	if (event.keyCode==13) {
    		$("#login_button").click();
		}
    });

    var enterSubmit = true;
    $("#login_username").keydown(function(event){
      if(event.keyCode == 229) return;
      if(event.keyCode == 40)
        enterSubmit = false;
		  if (event.keyCode==13) {
		    if(enterSubmit)
			  $("#login_button").click();
		    else
		      enterSubmit = true;
		  }
    });

    $("#login_button").keydown(function(event){
    	if (event.keyCode==13) {
    		$("#login_button").click();
		}
    });
    $("#VerifyCode").keydown(function(event){
      if (event.keyCode==13) {
          $("#login_button").click();
      }
  });
    if("true" == "${hasPluginCA}" && "Jit" == "${caFactory}"){
    	$("#login_form").append("<input type='hidden' id='signed_data' name='signed_data' value=''>")
			    		.append("<input type='hidden' id='original_jsp' name='original_jsp' value=''>")
			    		.append("<input type='hidden' id='RootCADN' name='RootCADN' value=''>");
    }
    /* if("${ServerState}" == "true"){
    	$("#messageDiv").show();
    	$("#postDiv").hide();
    	$("#messageSpn1").text("应用服务器正在停止，请您稍候再登录 。");
    	$("#messageSpn2").text("管理员附言:${ServerStateComment}");
    	$("#messageSpn3").text("当前人数:${OnlineNumber}");
    }else if("${sessionScope['com.seeyon.current_user']}" != ""){
    	$("#messageDiv").show();
    	$("#postDiv").hide();
    	$("#messageSpn1").text("当前已登录了一个用户，同一窗口中不能登录");
    	$("#messageSpn2").text("      				多个用户！");
    	$("#messageSpn3").html($("#butnFactory").html());
    }else{
    	
    } */
	
	// try{
 //    	//chrome不支持模态对话框借口
 //    	var ua = navigator.userAgent;
 //    	var isChrome = ua.indexOf('Chrome') != -1;
 //    	if(isChrome && !window.showModalDialog){
 //    		$('#loginArea').hide();
 //    		$("<div style='position:absolute;top:200px;right:100px;'>chrome最新浏览器需要设置组策略，点击<a class='padding_lr_5' href='"+_ctxPath+"/main/common/chrome-set.rar'>下载</a>设置计算机。</div>").appendTo($('body'));
 //    	}
	// }catch(e){}
	if ($.browser.msie) {
		if ($.browser.version <= 8) {
			$(".username").css("background","#fff url(/seeyon/main/login/default/images/username.png?V=V5_6_2015_03_31) 15px 10px no-repeat");
			$(".password").css("background","#fff url(/seeyon/main/login/default/images/password.png?V=V5_6_2015_03_31) 15px 10px no-repeat");
		};
	};
  });
</script>
<link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico" type="image/x-icon" rel="icon"/>
