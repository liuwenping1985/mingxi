<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/main/common/login_header.jsp"%>
<html class="h100b overflow_login">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>${loginTitleName}</title>
		<script type="text/javascript" src="${path}/common/js/passwdcheck.js${ctp:resSuffix()}"></script>
		<script type="text/javascript" charset="UTF-8" src="${path}/main/login/scroll/js/scroll.js${ctp:resSuffix()}"></script>
		<script type="text/javascript">
	
		var sendSMSCodeTime = 119;
		function loginCallback(){
		  return true;
		}
		$().ready(
		function() {
		  $.ctx.hotSpots = <c:out value="${hotSpotsJsonStr}" default="null" escapeXml="false"/>;
		  var changebgiIndex = 0;
		  if($.ctx.hotSpots){
			for(var i = 0; i < $.ctx.hotSpots.length; i++){
				var scroll_div = $("#scroll_div");
				var picHotSpot = $.ctx.hotSpots[i];
				var hotspotkey = picHotSpot.hotspotkey;
				if(hotspotkey == "note"){
				  txtHotSpot = $.ctx.hotSpots[i];
				} else if(hotspotkey == "topbgi"){
				  var imgsrc = "";
				  if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
				    imgsrc = "${path}/" + picHotSpot.hotspotvalue;
				  } else {
				    imgsrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
				  }
				  $(".header_logo").html("<img id='header_logo' src='"+imgsrc+"' alt=''>");
				} else if(hotspotkey == "topbgc"){
				  $(".login_header").css({"background":"" + picHotSpot.hotspotvalue+""});
				} else if(hotspotkey == "changebgi1"){
				  var changebgi1ImgSrc = "";
				  if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
				    changebgi1ImgSrc = "${path}/" + picHotSpot.hotspotvalue;
				  } else {
				    changebgi1ImgSrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
				  }
				  if(picHotSpot.display == "1"){
				    scroll_div.append("<div class=\"scroll_div_box scroll_div_box" + changebgiIndex + " current left\" uid='" + changebgiIndex + "' style=\"background: url("+changebgi1ImgSrc+") center center repeat;\"></div>");
				    changebgiIndex++;
				  }
				} else if(hotspotkey == "changebgi2"){
				  var changebgi2ImgSrc = "";
				  if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
				    changebgi2ImgSrc = "${path}/" + picHotSpot.hotspotvalue;
				  } else {
				    changebgi2ImgSrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
				  }
			      if(picHotSpot.display == "1"){
				    scroll_div.append("<div class=\"scroll_div_box scroll_div_box" + changebgiIndex + " current left\" uid='" + changebgiIndex + "' style=\"background: url("+changebgi2ImgSrc+") center center repeat;\"></div>");
				    changebgiIndex++;
			      }
				} else if(hotspotkey == "changebgi3"){
				  var changebgi3ImgSrc = "";
				  if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
				    changebgi3ImgSrc = "${path}/" + picHotSpot.hotspotvalue;
				  } else {
				    changebgi3ImgSrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
				  }
				  if(picHotSpot.display == "1"){
				    scroll_div.append("<div class=\"scroll_div_box scroll_div_box" + changebgiIndex + " current left\" uid='" + changebgiIndex + "' style=\"background: url("+changebgi3ImgSrc+") center center repeat;\"></div>");
				    changebgiIndex++;
				  }
				} else if(hotspotkey == "changebgi4"){
				  var changebgi4ImgSrc = "";
				  if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
				    changebgi4ImgSrc = "${path}/" + picHotSpot.hotspotvalue;
				  } else {
				    changebgi4ImgSrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
				  }
				  if(picHotSpot.display == "1"){
				    scroll_div.append("<div class=\"scroll_div_box scroll_div_box" + changebgiIndex + " current left\" uid='" + changebgiIndex + "' style=\"background: url("+changebgi4ImgSrc+") center center repeat;\"></div>");
				    changebgiIndex++;
				  }
				} else if(hotspotkey == "changebgi5"){
				  var changebgi5ImgSrc = "";
				  if(picHotSpot.hotspotvalue.indexOf("fileUpload.do") != -1){
				    changebgi5ImgSrc = "${path}/" + picHotSpot.hotspotvalue;
				  } else {
				    changebgi5ImgSrc = "${path}/main/login/" + picHotSpot.hotspotvalue + "${ctp:resSuffix()}";
				  }
				  if(picHotSpot.display == "1"){
				    scroll_div.append("<div class=\"scroll_div_box scroll_div_box" + changebgiIndex + " current left\" uid='" + changebgiIndex + "' style=\"background: url("+changebgi5ImgSrc+") center center repeat;\"></div>");
				    changebgiIndex++;
				  }
				} else if(hotspotkey == "changebgispeed") {
				  //调用scroll.js里的方法，设置切换图片间隔
				  setTimeOutSpeed(parseInt(picHotSpot.hotspotvalue));
			    } else if(hotspotkey == "bottombgc") {
				  $(".login_footer").css({"background":""+picHotSpot.hotspotvalue+""});
				}else if($.ctx.hotSpots[i].hotspotkey == "newfeature") {
						if($.ctx.hotSpots[i].hotspotvalue=="show"){
							$(".showArea_v56").show();
						}else{
							$(".showArea_v56").hide();
						}
					}
			}
		  }
		  //初始化 用户名 默认出现光标
		  $("#login_username").focus();
		  //缩小语言选择框宽度
		  $('#login_locale_dropdown').width("98%");

			imgRoll(); //计算个元素初始值
			$(".scroll_radio_box_img").bind("mouseover", scrollRadioRoxMouseOver);
			$(".scroll_radio_box img").bind("mouseout", scrollRadioRoxMouseOut);


			//判断IE浏览器 插入 插件
			if ($.browser.msie) {
				//alert("IE");
				$(".appendObject").append('<OBJECT name="OneSetup" class="hidden" classid="clsid:6076464C-7D15-42DF-829C-7A0194D4D61E" codebase="<c:url value="/common/setup/install.cab" />#version=1,0,0,4" width=0% height=0% align=center hspace=0 vspace=0></OBJECT>');
			};
			
			changeLoginMode();
			//U8下屏蔽二维码功能
			var checkU8="${ctp:getSystemProperty('portal.favicon')}";
			if(checkU8=="U8"){
				$(".qrCodeBtn").hide();
			}
		});
		
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
									<c:if test="${verifyCode}">
					                //当验证码和短信验证，同时显示的时候
					                $(".login_box").css({ height: "310px", top: "-380px" });
				                    $(".smsLogin_area").css({ top: "185px"});
				                    $(".login_button").css({ top: "245px"});
					                </c:if>
									var smsHtml = "<div id='smsLoginInputDiv' class='smsLogin_area clearfix'>";
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
		
		 function checkPwd() {
	      try {
	        var login_password = $("#login_password").val();
	        //默认密码强度弱：1
	        var power = 1;
	        if ($.trim(login_password) == "") {
	        } else {
	          power = EvalPwdStrength1("", login_password);
	        }
	        $("#power").val(power);
	      } catch (e) {
	      }
	      return true;

	    }
		</script>
		<c:if test="${includeJsp}">
		  <jsp:include  page="${pageUrl}" />
		</c:if>
		<link rel="stylesheet" type="text/css" href="${path}/main/login/scroll/css/css.css${ctp:resSuffix()}" />
	</head>
	<body style="background:#fff;">
		<!--header Start-->
		<div class="login_header header_bgcolor marginTop">

				<div class="header_logo"><!--logo-->
					<!-- <img id="header_logo" src="" alt=""> -->
				</div>
				<div><!--预留,如不添加新元素可删除-->

				</div>
		</div>
		<!--header End-->

		<!--content Start-->
		<div class="login_content">
			<!--当后台关闭了“显示V5.6全新体验”后，下面的DIV不显示-->
			<div class="showArea_v56"><a target="___newFeaturesPage" href="${path}/main/login/V56Show/V5.6_Intro.html" target="_blank">V5.6全新体验</a></div>
			<div class="scroll_div"><!--banner滚动图，3s切换一次，滚动图显示区域。-->
				<div id="scroll_div" class="scroll_div_width"><!--滚动图区域-->
					<!-- <div class="scroll_div_box scroll_div_box0 current left" uid="0" style="background: url(${path}/main/login/scroll/css/images/banner.jpg) center center repeat;"></div>
					<div class="scroll_div_box scroll_div_box1 left" uid="1" style="background: url(${path}/main/login/scroll/css/images/banner_2.jpg) center center repeat;"></div>
					<div class="scroll_div_box scroll_div_box2 left" uid="2" style="background: url(${path}/main/login/scroll/css/images/banner_3.jpg) center center repeat;"></div>
					<div class="scroll_div_box scroll_div_box3 left" uid="3" style="background: url(${path}/main/login/scroll/css/images/banner_4.jpg) center center repeat;"></div>
					<div class="scroll_div_box scroll_div_box4 left" uid="4" style="background: url(${path}/main/login/scroll/css/images/banner_5.jpg) center center repeat;"></div> -->
				</div>

				<div class="scroll_radio_box"><!--点-->
					<div class="scroll_radio_box_img left" uid="0"><img class="left" src="${path}/main/login/scroll/css/images/radio_2.png${ctp:resSuffix()}"></div>
					<div class="scroll_radio_box_img left" uid="1"><img class="left" src="${path}/main/login/scroll/css/images/radio_1.png${ctp:resSuffix()}"></div>
					<div class="scroll_radio_box_img left" uid="2"><img class="left" src="${path}/main/login/scroll/css/images/radio_1.png${ctp:resSuffix()}"></div>
					<div class="scroll_radio_box_img left" uid="3"><img class="left" src="${path}/main/login/scroll/css/images/radio_1.png${ctp:resSuffix()}"></div>
					<div class="scroll_radio_box_img left" uid="4"><img class="left" src="${path}/main/login/scroll/css/images/radio_1.png${ctp:resSuffix()}"></div>
				</div>
			</div>
			<div class="center_div">
				
					<form method="POST" action='${path}/main.do?method=login' id="login_form" name="loginform" onsubmit="checkPwd();">
					<input id="authorization" type="hidden" name="authorization" value="${authorization}"/>
					<input id="power" type="hidden" name="power" value="1"/>
					   <c:choose>
					   	<c:when test="${ServerState}">
						
						<div class="login_box_nobg">
					   	<table  class="login_form_layout" cellpadding="0" cellspacing="0" valign="center">
					   		<tr>
								<td colspan="2" align="left" height=35 width=310 class="font_size12" style="line-height:24px">
									<div class="login_error" style="top:40px; left:-135px;">
										${ctp:i18n_2('login.label.ErrorCode.8',ServerStateComment,OnlineNumber)}
									</div>
								</td>
							</tr>
						</table>
					   	</c:when>
					   	<c:when test="${sessionScope['com.seeyon.current_user'] != null}">
						<div class="login_box_nobg">
					   	<table  class="login_form_layout" cellpadding="0" cellspacing="0" >
			                <tr>
			                    <td colspan="2"  height="80" valign="top" class="font_size12 ">
			                    	<div class="login_error" style="top:40px; left:-135px;">
				                        ${ctp:i18n('login.label.alreadyLogin')}
				                        <br><br>
				                        <div style="text-align:right; margin-right:7px;">
					                        <a onClick="getCtpTop().open('','_self','');getCtpTop().close()" >${ctp:i18n('common.button.close.label')}</a>
					                        &nbsp;&nbsp;
					                        <a href='${path}/main.do?method=logout'>${ctp:i18n('login.label.Logout')}</a>
				                    	</div>
			                    	</div>
			                    </td>
			                </tr>
			            </table>
			            </c:when>
					   	<c:otherwise>
						<div class="login_box">
							<div class="qrCodeBtn"></div>
							<div class="pwdBtn"></div>
							<div class="pwd_area">
								<!--logoin输入框-->
								<div class="login_box_title">
									<c:if test="${serverType == 1}">
						              ${ctp:i18n(productCategory)} ${ctp:i18n_1("login.edition.regsiter.number",maxOnline)}
					                </c:if>
						            <c:if test="${serverType == 2}">
						               ${ctp:i18n(productCategory)} ${ctp:i18n_1("login.edition.number",maxOnline)}
						            </c:if>
								</div>
							
								<!-- 用户名 -->
								<div class="login_box_admin">
									<input id="login_username" name="login_username" type="text" style="border:0;" />
								</div>

								<!-- 密码 -->
								<div class="login_box_password">
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

								<!-- 提交按钮 -->
								<div class="login_button">
									<input type="button" id="login_button" class="point"  onclick="loginButtonOnClickHandler();" value="${ctp:i18n('login.label.Login')}" style="background:#3BC650;width:100%;height:100%;border:0; color:#fff; font-size:22px; letter-spacing:10px;padding-left:3px; font-family:'黑体';">
									<input id="submit_button" type="submit" style="display: none" value="" />
								</div>
							</div>
							<div class="qrCode_area">
								<div id="qrcode1">
									<div class="qrcode"><!--这里放置微信扫码登录的二维码图片--></div>
									<div class="qrtext">${ctp:i18n("portal.login.qrtext")}</div>
								</div>
								<div id="qrcode2">
									<div class="qrcode"><img src="main/login/default/images/mi-qrcode.png"></div>
									<div class="qrtext">${ctp:i18n("portal.login.qrtext2")}</div>
								</div>
								<div class="qrbootom"><a id="flashQrcode">${ctp:i18n("portal.login.flashQrcode")}</a><span class="padding_lr_10">|</span><a href="http://weixin.seeyon.com/help.jsp">${ctp:i18n("portal.login.wechat.help")}</a></div>
							</div>
						</c:otherwise>
						</c:choose>
					
					<!-- 错误提示框 -->
					<div id="login_error" class="login_error" style="display:none">
			            <img src="${path}/main/login/default/images/error.png${ctp:resSuffix()}"  height="14" width="16" align="absmiddle" border="0" style="vertical-align:text-bottom;"/>
						<span id="error_text" class="error_text" style="line-height:150%"></span>
					</div>
				</div>
				</form>



				<div class="fuzhu_area">
				<div class="footer_anzh">
					<span class="zhixin"><a href="${path}/autoinstall/zxsetup.exe">${ctp:i18n("portal.login.zhixinclient")}</a></span>
					<c:if test="${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}">
						<span class="assist_set point" onClick="openAssistantSetup()">[${ctp:i18n("login.tip.assistantSetup")}]</span>
					</c:if>
				</div>
				<div class="footer_select">
					<div class="right" style="width:110px;">
					<select id="login_locale" ></select>
					</div>
					<div style="clear:both;">&nbsp;</div>
				</div>
			</div>
				<div class="fuzhu_area_bg"></div>
			</div>
		</div>
		<!--content End-->
		<!-- 分割线 Start -->
		<div class="dividing_line">
		</div>
		<!-- 分割线 End -->
		<!--footer Start-->
		<div class="login_footer footer_bgcolor">
		</div>
		<!--footer End-->


	
<script type="text/javascript">
<!--
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
<iframe id="procDiv1Iframe" scrolling="no" frameborder="0"  style="display:none;"></iframe>

<div class="appendObject"></div>
</body>
</html>