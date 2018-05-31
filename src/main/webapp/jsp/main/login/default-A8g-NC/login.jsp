<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/main/common/login_header.jsp"%>
<html class="h100b overflow_login">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>${loginTitleName}</title>
	<script type="text/javascript">
		var sendSMSCodeTime = 119;
		function loginCallback(){
			return true;
		}
		$(function() {
			$.ctx.hotSpots = <c:out value="${hotSpotsJsonStr}" default="null" escapeXml="false"/>;
			var ischangeBgImg = false;
			if($.ctx.hotSpots){
			  for(var i = 0; i < $.ctx.hotSpots.length; i++){
		        if($.ctx.hotSpots[i].hotspotkey == "note"){
		          txtHotSpot = $.ctx.hotSpots[i];
		        } else if($.ctx.hotSpots[i].hotspotkey == "contentbgi"){
		          picHotSpot = $.ctx.hotSpots[i];
		          if(picHotSpot && picHotSpot.hotspotvalue && picHotSpot.hotspotvalue != ""){
	            	  ischangeBgImg = true;
	              }else{
	            	  continue;
	              }
		          var imgsrc = "";
		          if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
		            imgsrc = "${path}/" + picHotSpot.hotspotvalue;
		          } else {
		            imgsrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
		          }
		          $(".login_bg").css("background","url("+imgsrc+") center center");
		          if(picHotSpot.tiling==1){
		           $(".login_bg").css({ "background-repeat": "repeat" });
		          }else{
		           $(".login_bg").css({ "background-repeat": "no-repeat" });
		          }
		          if(picHotSpot.hotspotvalue != "default/images/main_content_ie6.jpg") {
		             $(".showArea_text").hide();
                 $(".logoArea").hide();
								 $("#container").remove();
		          }
		        } else if($.ctx.hotSpots[i].hotspotkey == "mainbgc") {
		          colorHotSpot = $.ctx.hotSpots[i];
		          $("#main_bg").css({"background-color":""+colorHotSpot.hotspotvalue + ""});
	            } else if($.ctx.hotSpots[i].hotspotkey == "mainbgi"){
	              //if(colorHotSpot && colorHotSpot.hotspotvalue == "#fafafa"){
	                picHotSpot = $.ctx.hotSpots[i];
	                if(picHotSpot && picHotSpot.hotspotvalue && picHotSpot.hotspotvalue != ""){
		            	  ischangeBgImg = true;
		              }else{
		            	  continue;
		              }
	                var imgsrc = "";
	                if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
	                  imgsrc = "${path}/" + picHotSpot.hotspotvalue;
	                } else {
	                  imgsrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
	                }
	                $("#main_bg").css("background-image","url("+imgsrc+")");
	                if(picHotSpot.tiling==1){
                      $("#main_bg").css({ "background-repeat": "repeat" });
                    }else{
                      $("#main_bg").css({ "background-repeat": "no-repeat" });
                    }
	              //}
		        }
						 else if($.ctx.hotSpots[i].hotspotkey == "newfeature") {
									if($.ctx.hotSpots[i].hotspotvalue=="show"){
										$(".showArea_v56").show();
									}else{
										$(".showArea_v56").hide();
									}
                }
		      }
			  if(!ischangeBgImg){
				 // $.getScript("${path}/main/login/default/lowPoly.js");
			  }else{
				  //$("#container").remove();
			  }
			}
			var changebgiIndex = 0;

			//初始化 用户名 默认出现光标
			$("#login_username").focus();

			//缩小语言选择框宽度
			$('#login_locale_dropdown').mouseenter(function(event) {
				$("#login_locale_dropdown_content").height("auto");
			});;

			//判断IE浏览器 插入 插件
			if ($.browser.msie) {
				//alert("IE");
				$(".appendObject").append('<OBJECT name="OneSetup" class="hidden" classid="clsid:6076464C-7D15-42DF-829C-7A0194D4D61E" codebase="<c:url value="/common/setup/install.cab" />#version=1,0,0,4" width=0% height=0% align=center hspace=0 vspace=0></OBJECT>');
			};

			showArea();
			$(window).resize(function(){
				showArea();
			});
			
			changeLoginMode();
		});

		//低分辨率處理
		function showArea(){
			if ($(window).width() <= 1260) {
				$(".showArea").css("left", "3%");
				$(".loginArea").css("right", "5%");
			} else if ($(window).width() >= 1550) {
				$(".showArea").css("left", "13%");
				$(".loginArea").css("right", "15%");
			} else {
				$(".showArea").css("left", "");
				$(".loginArea").css("right", "");
			};
		}
		
		function loginButtonOnClickHandler(){
			var login_username = $("#login_username").val();
			if($.trim(login_username) == ""){
				$("#submit_button").click();
			} else {
				var smsVerifyCode = "";
				if($("#smsLoginInputDiv").length == 1){
					smsVerifyCode = $.trim($("#smsVerifyCode").val());
				}
                var isCanUseSMS = ${isCanUseSMS};
                if( !isCanUseSMS || ($("#smsLoginInputDiv").length == 1 && smsVerifyCode != "")){
					$("#submit_button").click();
				} else {
				    var portalManager=RemoteJsonService.extend({
				        jsonGateway : "${path}/ajax.do?method=ajaxAction&managerName=portalManager",
				        smsLoginEnabled: function(){
				          return this.ajaxCall(arguments, "smsLoginEnabled");
				        },
				        sendSMSLoginCode: function(){
				          return this.ajaxCall(arguments, "sendSMSLoginCode");
				        }
				      });					
					//进行短信登录验证
					new portalManager().smsLoginEnabled(login_username, {
						success : function(telNumber) {
							if(telNumber && $.trim(telNumber).length > 0){
								if($("#smsLoginInputDiv").length == 0){
									var smsHtml = "<div id='smsLoginInputDiv' class='clearfix'>";
									smsHtml += "<div class='smsLogin_textbox'>";
									smsHtml += "<input title='${ctp:i18n("systemswitch.inputsmscode.prompt")}' id='smsVerifyCode' name='login.smsVerifyCode' type='text' maxlength='8' />";
									smsHtml += "</div>";
									smsHtml += "<div class='smsLogin_btn' id='sendSMSCodeButton'>${ctp:i18n("login.label.getsmscode")}</div>";
									smsHtml += "</div>";
									$(".captcha").after(smsHtml);
									$("#sendSMSCodeButton").click(function(){
										if (sendSMSCodeTime != 119) {
											return;
										};
										var login_username = $("#login_username").val();
										new portalManager().sendSMSLoginCode(login_username, {
										    success : function(msg) {
										      if(msg == "success"){
										        $("#smsVerifyCode").val("");
										        var interval = setInterval(function(){
										          sendSMSCodeTime--;
										          if (sendSMSCodeTime == 0) {
										            $("#sendSMSCodeButton").html("${ctp:i18n('login.label.getsmscode')}").removeClass('smsLogin_btn_disable');
										            sendSMSCodeTime = 119;
										            clearInterval(interval);
										          } else {
										            $("#sendSMSCodeButton").html(sendSMSCodeTime + " " + "${ctp:i18n('login.label.reget')}").addClass('smsLogin_btn_disable');
										          }
										        }, 1000);
										        $("#sendSMSCodeButton").html(sendSMSCodeTime + " " + "${ctp:i18n('login.label.reget')}").addClass('smsLogin_btn_disable');
										      } else {
										        $("#login_error").css("background-image","none");
										        $("#login_error").html(msg);
										        $("#login_error").show();
										      }
										    }
										});
									});
									$("#smsLoginInputDiv").show();
								} else {
									$("#submit_button").click();
								}
							} else {
								$("#smsVerifyCode").val("");
								$("#submit_button").click();
							}
							//当验证码和短信同时显示的时候,调整.loginArea的位置
							if ($("#smsLoginInputDiv").is(":hidden") !== true && "${verifyCode}" === "true") {
								$(".loginArea").css("margin-top", "-195px");
							}
						},
						error : function(){
							$("#submit_button").click();
						}
					});
				}
			}
		}
	</script>
	<c:if test="${includeJsp}">
		<jsp:include  page="${pageUrl}" />
	</c:if>
	<link rel="stylesheet" type="text/css" href="${path}/main/login/default-A8s-U8/css/login.css${ctp:resSuffix()}" />
</head>
<body id="main_bg" style="background-image:none">
	<div class="login_bg">
		<div class="logoArea">
			<img id="header_logo" src="${path}/main/login/default/images/logo.png${ctp:resSuffix()}">
		</div>
		<div class="showArea">
			<!--<object id="dllbMovie" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="800" height="800">
				<param name="movie" value="${path}/main/login/default/images/login_dy.swf">
				<param name="wmode" value="transparent">
				<param name="quality" value="high">
				<param name="allowScriptAccess" value="always">
				<embed wmode="transparent" src="${path}/main/login/default/images/login_dy.swf" quality="high" width="800" height="800" type="application/x-shockwave-flash" allowscriptaccess="always" name="dllbMovie">
			</object>-->
			<div class="showArea_text">&nbsp;</div>
			<!--当后台关闭了“显示V5.6全新体验”后，下面的DIV不显示
			<div class="showArea_v56"><a target="___newFeaturesPage" href="${path}/main/login/V56Show/V5.6_Intro.html" target="_blank">V5.6全新体验</a></div>
			-->
		</div>
		<form method="POST" action='${path}/main.do?method=login' id="login_form" name="loginform" >
		<input id="authorization" type="hidden" name="authorization" value="${authorization}"/>
			<c:choose>
				<c:when test="${ServerState}">
					<!-- 系统维护显示 -->		
					<div id="maintainArea" class="maintainArea">
						${ctp:i18n_2('login.label.ErrorCode.8',ServerStateComment,OnlineNumber)}
					</div>
				</c:when>
				<c:when test="${sessionScope['com.seeyon.current_user'] != null}">
					<!-- 已登录显示 -->
					<div id="loggedArea" class="loggedArea">
						${ctp:i18n('login.label.alreadyLogin')}
						<br>
						<br>
						<div class="align_right margin_t_5">
							<a onClick="getCtpTop().open('','_self','');getCtpTop().close()" class="color_blue">${ctp:i18n('common.button.close.label')}</a>
							&nbsp;&nbsp;
							<a href='${path}/main.do?method=logout' class="color_blue">${ctp:i18n('login.label.Logout')}</a>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div id="loginArea" class="loginArea">
						<div class="loginForm_area">
							<div class="pwdBtn"></div>
							<!--<div class="qrCodeBtn"></div>-->
							<div class="pic">
								<div class="pic_box"><img src="${ctp:avatarImageUrl(cookie.avatarImageUrl==null? 0 : cookie.avatarImageUrl.value)}" /></div>
								<div class="pic_box_bg"></div>
								<div class="pic_box_bg_ie8down"></div>
							</div>
							<div class="pwd_area">
								<div class="text">
									<c:if test="${serverType == 1}">
										${ctp:i18n(productCategory)} ${ctp:i18n_1("login.edition.regsiter.number",maxOnline)}
									</c:if>
									<c:if test="${serverType == 2}">
										${ctp:i18n(productCategory)} ${ctp:i18n_1("login.edition.number",maxOnline)}
									</c:if>
								</div>
								<!-- 用户名 -->
								<div class="username">
									<input id="login_username" name="login_username" type="text" style="border:0;" />
								</div>
								<!-- 密码 -->
								<div class="password">
									<input id="login_password" name="login_password" type="password" />
								</div>
								<!-- 验证码 -->
								<div class="captcha">
									<c:if test="${verifyCode }">
										<div class="captcha_box">
											<input id="VerifyCode" name="login.VerifyCode" type="text" maxlength="4" />
										</div>
										<img border="0" width="92" height="48" id="VerifyCodeImg" align="absmiddle" src="${path}/verifyCodeImage.jpg">
									</c:if>
									<c:if test="${'koal'==caFactory&&'yes'==sslVerifyCertValue&&'noKey'!=keyNum}">
										<input type="hidden" name="keyNum" value="${keyNum }">
									</c:if>
									<c:if test="${hasPluginCA}">
										<input id="caCertMark" type="hidden" name="caCertMark" value="">
									</c:if>
								</div>
								<!-- 登陆按钮 -->
								<div class="login_btn">
									<input type="button" id="login_button" class="point" value="${ctp:i18n('login.label.Login')}" onClick="loginButtonOnClickHandler();"/>
									<input id="submit_button" type="submit" style="display: none" value="" />
								</div>
							</div>
							<div class="qrCode_area">
								<div id="qrcode1">
									<div class="qrcode"><!--这里放置微信扫码登录的二维码图片--></div>
									<div class="qrtext">${ctp:i18n("portal.login.qrtext")}</div>
								</div>
								<div id="qrcode2">
									<div class="qrcode"><img src="main/login/default/images/mi-qrcode.png${ctp:resSuffix()}"></div>
									<div class="qrtext">${ctp:i18n("portal.login.qrtext2")}</div>
								</div>
								<div class="qrbootom"><a id="flashQrcode">${ctp:i18n("portal.login.flashQrcode")}</a><span class="padding_lr_10">|</span><a href="http://weixin.seeyon.com/help.jsp">${ctp:i18n("portal.login.wechat.help")}</a></div>
							</div>
						</div>
						<div class="language_area clearfix">
							<div class="fzIntall_area">
								<span class="zhixin"><a href="${path}/autoinstall/zxsetup.exe">${ctp:i18n("portal.login.zhixinclient")}</a></span>
								<c:if test="${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}">
									<span class="hand" onClick="openAssistantSetup()">[${ctp:i18n("login.tip.assistantSetup")}]</span>
								</c:if>
							</div>
							<div class="right margin_r_10" style="width:110px;">
								<select id="login_locale" ></select>
							</div>
						</div>
						<!-- 密码错误显示 -->		
						<div id="login_error" class="login_error" style="display:none">
							无效的用户名或密码
							<br>该账号仅剩下4次登录尝试机会</div>
					</div>
				</c:otherwise>
			</c:choose>
		</form>
		<div class="FullPageBackground" id="container">
					<ul class="ColorFooter">
						<li class="CF1"></li>
						<li class="CF2"></li>
						<li class="CF3"></li>
						<li class="CF4"></li>
						<li class="CF5"></li>
						<li class="CF6"></li>
						<li class="CF7"></li>
					</ul>
				</div>
		<!--<div id="container" class="mpage">
			<div id="anitOut" class="anitOut"></div>
			<div class="canvas_bgz"></div>
		</div>-->
	</div>
<script type="text/javascript">
<!--
if ($.browser.msie){
	if($.browser.version < 9){
		$(".pic_box_bg").hide();
		$(".pic_box_bg_ie8down").show();
		$(".pic_box img").css({
			width: 86,
			height: 86,
			"margin-left": 2,
			"margin-top": 3
		});
	};
};

//开始进度条
var commonProgressbar = null;
function startProc(title){
    try {
        var options = {
            title: title
        };
        if (title == undefined) {
            options = {};
        }
        if (commonProgressbar != null) {
            commonProgressbar.start();
        } else {
            commonProgressbar = new MxtProgressBar(options);
        }
    } catch (e) {
    }
}
//结束进度条
function endProc(){
    try {
        if (commonProgressbar) {
            commonProgressbar.close();
        }
        commonProgressbar = null;
    } catch (e) {
    }
}

var alterWin;
function openAssistantSetup(){
    var obj = null;
    try {
        obj = new ActiveXObject("SeeyonActivexInstall.SeeyonInstall");
        var locale = document.getElementById("login_locale").value;
        startProc("请稍候,正在初始化程序...");
        var result = obj.Startup(_ctxServer + "/autoinstall/${ctp:getSystemProperty('system.geniusFolder')}", locale+"/${ucServerIpOrPort}", "${exceptPlugin}");
        endProc();
    } catch (e) {
        alterWin = $.dialog({
            htmlId: 'alert',
            title: '自动安装',
            url: "${path}/genericController.do?ViewPage=apps/autoinstall/downLoadIESet",
            isClear : false,
            width: 420,
            height: 200
        });
    }
}
//-->
</script>
<div id="procDiv1" style="display:none;"></div>
<iframe id="procDiv1Iframe" defaulting="no" frameborder="0"  style="display:none;"></iframe>

<div class="appendObject"></div>
<script type="text/javascript">
$(function(){
	var PWidth=$(window).width();
	var LiWidth=(PWidth-12)/7;
	$(".ColorFooter li").css("width",LiWidth);
	$(".CF1,.CF2,.CF3,.CF4,.CF5,.CF6").css("margin-right","2px");
})
</script>
</body>
</html>
