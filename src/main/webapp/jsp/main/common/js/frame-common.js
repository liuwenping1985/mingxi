/**
 * @author macj
 */

$.ctx.handleMenu = function(handle) {
  var mu = $.ctx.menu;
  if (mu) {
    for ( var i = 0; i < mu.length; i++) {
      _hd(mu[i], handle);
    }
  }
  return mu;
}

function _hd(mu, handle) {
  handle(mu);
  var cm = mu.items;
  if (cm) {
    for ( var i = 0; i < cm.length; i++) {
      var c = cm[i];
      _hd(c, handle);
    }
  }
}

//菜单数据
var menu = $.ctx.menu;
var memberMenus = $.ctx.menu;
//菜单默认显示个数
var _default = 8;
var currentSpaceId = null;
//当前空间类型，用于当前位置图标显示
var currentSpaceType = "personal";
//多窗口缓存
var _windowsMap = new Properties();
//主页面刷新控制变量
var isOpenCloseWindow = true;
var hasShowSpaceOwnerMenu = false;
var isCtpTop = true;
var isOffice = false;
var officeObj = null;
//快速选人开关
var distroy_token = false;
//个人左导航设置
var _judgeNum = $.ctx.customize.left_panel_set ? $.ctx.customize.left_panel_set : "1";
//当前首页模板变量,默认首页：default，工作桌面：desktop
var defaultPortalTemplate = !$.ctx.customize.default_page ? "default" : $.ctx.customize.default_page;
//工作桌面背景图
var desk_background_image = $.ctx.customize.desk_background_image;
//工作桌面背景色
var desktop_background_color = $.ctx.customize.desktop_background_color;
var productView_check = $.ctx.customize.productView;
var productView_Obj;
function showProductView(){
  productView_Obj = $.dialog({
    id:'productView',
      width: 1000,
      height: 640,
      checkMax : false,
      type: 'panel',
      url: _ctxPath + "/portal/portalController.do?method=showProductView",
      shadow:true,
      showMask:true,
      panelParam:{
        'show':false,
        'margins':false
      }
  });
}

function logout(closeAll) {
  for ( var p = 0; p < _windowsMap.keys().size(); p++) {
    var _kkk = _windowsMap.keys().get(p);
    try {
      var _fff = _windowsMap.get(_kkk);
      var _dd = _fff.document;
      if (_dd) {
        var _p = parseInt(_dd.body.clientHeight);
        if (_p == 0) {
			_fff = null;
          _windowsMap.remove(_kkk);
          p--;
        }
      }
    } catch (e) {
    	_fff = null;
      _windowsMap.remove(_kkk);
      p--;
    }
  }

  if (closeAll) {
    if (_windowsMap && _windowsMap.size() > 0) {
      alert($.i18n("window.genius.isClose"));
      return;
    }
    isDirectClose = false;
    window.open("closeIE7.htm", "_self");
  } else {
    // UC中心
    if (hasPluginUC == "true" && isCurrentUserAdmin != "true") {
      var isExit = clickCloseUC();
      if (!isExit) {
        return;
      }
    }
    var closeMessage = "";
    if (_windowsMap.size() > 0) {
      if (confirm($.i18n("window.exit.isClose"))) {
        var _keys = _windowsMap.keys();
        for ( var i = 0; i < _keys.size(); i++) {
          var _k = _keys.get(i);
          var _tp = _windowsMap.get(_k);
          if (_tp)
            _tp.close();
        }
        $.confirm({
          'type' : 1,
          'msg' : logoutConfirm_I18n,
          ok_fn : function() {
            isDirectClose = false;
            if (hasPluginUC == "true" && isCurrentUserAdmin != "true") {
              closeUC();// 关闭UC
            }
            // 结束精灵
            unloadA8genius = true;
            endA8genius();
            try { // OA-19281
                  // 修复IE下点击退出，但触发iframe工作区内的onbeforeunload事件并选择留在当前页面时，此跳转会出现js异常的问题，通过忽略异常的方式处理
              window.location.href = _ctxPath + "/main.do?method=logout";
            } catch (e) {
            }
          },
          cancel_fn : function() {
            isDirectClose = true;
          }
        });
      } else {
        /*
         * closeMessage = $.i18n("portal.multiWindow.close"); $.confirm({ 'type' :
         * 1, 'msg': closeMessage+"${ctp:i18n('system.logout.confirm')}", ok_fn:
         * function () { isDirectClose = false; if("${ctp:hasPlugin('uc')}" ==
         * "true" && "${CurrentUser.admin}" != "true"){ closeUC();//关闭UC }
         * //结束精灵 unloadA8genius = true; endA8genius(); try { //OA-19281
         * 修复IE下点击退出，但触发iframe工作区内的onbeforeunload事件并选择留在当前页面时，此跳转会出现js异常的问题，通过忽略异常的方式处理
         * window.location.href = _ctxPath+"/main.do?method=logout"; }catch(e){} },
         * cancel_fn:function(){ isDirectClose = true; } });
         */
      }
    } else {
      $.confirm({
        'type' : 1,
        'msg' : logoutConfirm_I18n,
        ok_fn : function() {
          isDirectClose = false;
          if (hasPluginUC == "true" && isCurrentUserAdmin != "true") {
            closeUC();// 关闭UC
          }
          // 结束精灵
          unloadA8genius = true;
          endA8genius();
          try { // OA-19281
                // 修复IE下点击退出，但触发iframe工作区内的onbeforeunload事件并选择留在当前页面时，此跳转会出现js异常的问题，通过忽略异常的方式处理
            window.location.href = _ctxPath + "/main.do?method=logout";
          } catch (e) {
          }
        },
        cancel_fn : function() {
          isDirectClose = true;
        }
      });
    }
  }
}

function chanageLoginAccount(accountId){
  var accountList = $.ctx.concurrentAccount;
  var chgAccountName = null;
  for(var i=0 ; i < accountList.length; i++){
    if(accountList[i].id == accountId){
      chgAccountName = accountList[i].shortName;
    }
  }
	var _wmp = _windowsMap;
	for(var p = 0;p<_wmp.keys().size();p++){
		var _kkk = _wmp.keys().get(p);
		try{
			var _fff = _wmp.get(_kkk);
			var _dd = _fff.document;
			if(_dd){
				var _p = parseInt(_dd.body.clientHeight);
				if(_p == 0){
					_dd.write('');
					_fff.close();
					_fff = null;
					_wmp.remove(_kkk);
					p--;
				}
			}else{
				_fff = null;
				_wmp.remove(_kkk);
				p--;
			}
		}catch(e){
			_fff = null;
			_wmp.remove(_kkk);
			p--;
		}
	}
  
  if (_windowsMap.size() > 0) {
      if (confirm($.i18n("window.exit.isClose"))) {
        var _keys = _windowsMap.keys();
        for ( var i = 0; i < _keys.size(); i++) {
          var _k = _keys.get(i);
          var _tp = _windowsMap.get(_k);
          if (_tp)
            _tp.close();
        }
      } else {
    	  return;
      }
  }
  
  $.confirm({
    'type' : 1,
    'msg': $.i18n('system.changeAccount.label', chgAccountName),
    ok_fn: function () {
      var isExceedMaxLoginNumber = new portalManager().isExceedMaxLoginNumberServerInAccount(accountId);
        
      if(true != isExceedMaxLoginNumber){
        isOpenCloseWindow = false;
            isDirectClose = false;
            window.location.href = _ctxPath+"/main.do?method=changeLoginAccount&login.accountId="+accountId;
      }else{
        $.alert($.i18n('login.label.ErrorCode.31', chgAccountName));
      }
    },
    cancel_fn:function(){
      isDirectClose = true;
      $("#chanageLoginAccount").find("option").each(function(i,obj){
          if(obj.value == $.ctx.CurrentUser.loginAccount){
            obj.selected = true;
          }else{
            obj.selected = false;
          }
      });
      $(".account_container").hide();
    }
  });
}

var enterCount = 0;
//狗头ID
var dogHeadId = "";
//校验狗头通过标记
var passedCheck = false;
//系统消息是否已关闭
var isSysMessageWindowEyeable = false;
//在线消息是否已关闭
var isPerMessageWindowEyeable = false;
//存储消息
var msgProperties = new Properties();
//总共消息个数
var msgTotalCount = 0;
//是否为精灵消息
var isA8geniusMsg = false;
//当前密码复杂度
var checkpwdpower=0;
/**
 * 密码强度
 * @returns
 */
function checkStrengthValidation(){
	if(loginAuthentication=="DefaultLoginAuthentication"){
	  if(power != ""){
	    checkpwdpower=power;
	  }
	 var pwdStrength="";
		if(power<PwdStrengthValidationValue){
		if(PwdStrengthValidationValue==1){
		pwdStrength= $.i18n("manager.vaildate.strength1.js");
		}else if(PwdStrengthValidationValue==2){
		pwdStrength= $.i18n("manager.vaildate.strength2.js");
		}else if(PwdStrengthValidationValue==3){
		pwdStrength= $.i18n("manager.vaildate.strength3.js");
		}
		 $(document).off().on("keydown", function(event) {
		    	var e = event || window.event;
		    	if(e && e.keyCode==27||e.keyCode==116){ // esc 键
		    		window.event.keyCode=0;
		    		event.returnValue = false; 
		    		isDirectClose = false;  
		    		window.location.href = _ctxPath+"/main.do?method=logout";
		          }
			})
       toModifyPasswd();
	   $.alert(pwdStrength);
	   return 1;
	 }else{
		 return 0;
		 }
	}else{
		return 0;
	}
}
/**
 * 密码超期提醒
 * @returns
 */
function checkPwdIsExpired(){
	  //提示密码过期
	  //&& !v3x.isIpad
	  if(pwd_needUpdate==0||loginAuthentication!="DefaultLoginAuthentication"){
	  if(isPwdExpirationInfoNotEmpty){
	    if(isPwdExpirationInfo1Empty && (isCurrentUserSystemAdmin == "true" || isCurrentUserAuditAdmin == "true" || isCurrentUserGroupAdmin == "true" || isCurrentUserAdministrator == "true")){
	            var pwdMsg = $.messageBox({
	                'type': 100,
	                'msg': "<div class='msgbox_img_2' style='float:left'></div><div class='margin_t_5 margin_l_5' style='float:left'>" + $.i18n("message.pwd.expired") + "</div>",
	                'title': $.i18n("system.prompt.js"),
	                close_fn:function (){
	                  toModifyPasswd(); 
	                },
	                buttons: [{
	                    id:'btn1',
	                    text: $.i18n("message.pwd.ok"),
	                    handler: function () {
	                        toModifyPasswd(); 
	                    }
	                }]
	            });
	    } else if(isPwdExpirationInfo1Empty){
	          if(isNotPersonModifyPwd){
	            var pwdMsg = $.messageBox({
	                'type': 100,
	                'msg': "<div class='msgbox_img_2' style='float:left'></div><div class='margin_t_5 margin_l_5' style='float:left'>" + $.i18n("message.pwd.expired") + "</div>",
	                'title': $.i18n("system.prompt.js"),
	                buttons: [{
	                    id:'btn1',
	                    text: $.i18n("message.pwd.ok"),
	                    handler: function () { toModifyPasswd();pwdMsg.close(); }
	                }, {
	                    id:'btn2',
	                    text: $.i18n("message.pwd.cancle"),
	                    handler: function () { pwdMsg.close(); }
	                }]
	            });
	          }
	    } else {
	      if(isCurrentUserAdmin == "true" || isNotPersonModifyPwd){
	            var pwdMsg = $.messageBox({
	                'type': 100,
	                'msg': "<div class='msgbox_img_2' style='float:left'></div><div style='margin-left:30px;margin-top:5px;'>" + $.i18n("message.pwd.expired") + "<br>" + $.i18n('message.pwd.expiredappend', datePwd) + "</div>",
	                'title': $.i18n("system.prompt.js"),
	                buttons: [{
	                    id:'btn1',
	                    text: $.i18n("message.pwd.ok"),
	                    handler: function () { toModifyPasswd();pwdMsg.close(); }
	                }, {
	                    id:'btn2',
	                    text: $.i18n("message.pwd.cancle"),
	                    handler: function () { pwdMsg.close(); }
	                }]
	            });
	      }
	    }
	   }
	  }else{
		  if(isPwdExpirationInfoNotEmpty){
	    if(isPwdExpirationInfo1Empty && (isCurrentUserSystemAdmin == "true" || isCurrentUserAuditAdmin == "true" || isCurrentUserGroupAdmin == "true" || isCurrentUserAdministrator == "true")){
	            var pwdMsg = $.messageBox({
	                'type': 100,
	                'msg': "<div class='msgbox_img_2' style='float:left'></div><div class='margin_t_5 margin_l_5' style='float:left'>" + $.i18n("message.pwd.expired") + "</div>",
	                'title': $.i18n("system.prompt.js"),
	                close_fn:function (){
	                  toModifyPasswd(); 
	                },
	                buttons: [{
	                    id:'btn1',
	                    text: $.i18n("message.pwd.ok"),
	                    handler: function () {
	                        toModifyPasswd(); 
	                    }
	                }]
	            });
	    } else if(isPwdExpirationInfo1Empty){
	          if(isNotPersonModifyPwd){
	            var pwdMsg = $.messageBox({
	                'type': 100,
	                'msg': "<div class='msgbox_img_2' style='float:left'></div><div class='margin_t_5 margin_l_5' style='float:left'>" + $.i18n("message.pwd.expired") + "</div>",
	                'title': $.i18n("system.prompt.js"),
						 close_fn:function (){
	                  toModifyPasswd(); 
	                },
	                buttons: [{
	                    id:'btn1',
	                    text: $.i18n("message.pwd.ok"),
	                    handler: function () { toModifyPasswd();pwdMsg.close(); }
	                }]
	            });
	          }
	    } else {
	      if(isCurrentUserAdmin == "true" || isNotPersonModifyPwd){
	            var pwdMsg = $.messageBox({
	                'type': 100,
	                'msg': "<div class='msgbox_img_2' style='float:left'></div><div style='margin-left:30px;margin-top:5px;'>" + $.i18n("message.pwd.expired") + "<br>" + $.i18n('message.pwd.expiredappend', datePwd) + "</div>",
	                'title': $.i18n("system.prompt.js"),
						 close_fn:function (){
	                  toModifyPasswd(); 
	                },
	                buttons: [{
	                    id:'btn1',
	                    text: $.i18n("message.pwd.ok"),
	                    handler: function () { toModifyPasswd();pwdMsg.close(); }
	                }]
	            });
	      }
	    }
	   }
	  }
	}

function toModifyPasswd(){
	  if(isCurrentUserSystemAdmin == "true"){
	    //系统管理员
		 alterPwdWin=getA8Top().$.dialog({
				id:"alert",
				//htmlId:'configPanel',
				title:$.i18n("system.prompt.js"),
				url : _ctxPath + "/manager.do?method=managerFrame&result=true&checkpwdpower="+checkpwdpower,
				width: 800,
				height: 500,
				isDrag:false,
				closeParam:{
					'show':false,
					autoClose:true
				}
			});
	  }else if(isCurrentUserAuditAdmin == "true"){
	    //审计管理员
		alterPwdWin=getA8Top().$.dialog({
				id:"alert",
				//htmlId:'configPanel',
				title:$.i18n("system.prompt.js"),
				url : _ctxPath + "/manager.do?method=managerFrame&from=audit&result=true&checkpwdpower="+checkpwdpower,
				width: 800,
				height: 500,
				isDrag:false,
				closeParam:{
					'show':false,
					autoClose:false
				}
			});
	   
	  }else if(isCurrentUserGroupAdmin == "true"){
	    //集团管理员
		alterPwdWin=getA8Top().$.dialog({
				id:"alert",
				//htmlId:'configPanel',
				title:$.i18n("system.prompt.js"),
				url :_ctxPath + "/accountManager.do?method=groupManagerFrame&result=true&checkpwdpower="+checkpwdpower,
				width: 800,
				height: 500,
				isDrag:false,
				closeParam:{
					'show':false,
					autoClose:false
				}
			});
	  }else if(isCurrentUserAdministrator == "true"){
	    //单位管理员
		alterPwdWin=getA8Top().$.dialog({
				id:"alert",
				//htmlId:'configPanel',
				title:$.i18n("system.prompt.js"),
				url : _ctxPath + "/accountManager.do?method=managerFrame&result=true&checkpwdpower="+checkpwdpower,
				width: 800,
				height: 500,
				isDrag:false,
				closeParam:{
					'show':false,
					autoClose:false
				}
			});
	  }else {
		  alterPwdWin=getA8Top().$.dialog({
				id:"alert",
				//htmlId:'configPanel',
				title:$.i18n("system.prompt.js"),
				url : _ctxPath + "/individualManager.do?method=managerFrame&checkpwdpower="+checkpwdpower,
				width:800,
				height: 500,
				isDrag:false,
				closeParam:{
					'show':false,
					autoClose:false
				}
			});
	  }
	  
	}

function agentAlert(){
  //必须放在iframe前面，应用Iframe要调用
  if(isMessageForAgentAlertNotEmpty && isIdsForAgentAlertNotEmpty){
      var dialogAgent = $.dialog({
          id: 'dialogAgent',
          url: _ctxPath + '/agent.do?method=agentAlert&ids=' + idsForAgentAlert + '&message=' + messageForAgentAlert,
          title: $.i18n("common.prompt"),
          width: 410,
          height: 200
      });
  }
}

//引入v3x.js及相关国际化js文件
//返回个人空间首页
function backToPersonalSpace(){

}
//更新个人空间链接地址
function updatePersonalSpaceByUrl(path,newLink){

}
//更新个人空间链接地址,并返回个人空间--领导空间
function updatePersonalSpaceURL(newLink){

}
//返回到当前选择的空间首页
function back(){
  var spaces = $.ctx.space;
  if(spaces){
	  if(spaces.length == 0){
		  $("#main").attr("src",_ctxPath+"/portal/portalController.do?method=showSystemNavigation");
	  }else{
		  for (var i = 0; i < spaces.length; i++) {
		      if(currentSpaceId == spaces[i][0]){
		        showSpace(i,spaces[i][0],spaces[i][2]);
		      }
		    }
	  }
  }
}
//重新排列空间菜单，个人空间设置更改排序后调用
function realignSpaceMenu(accountId){

}
function reFlesh(){
  var mainsrc = $("#main").attr("src");
  if(mainsrc.indexOf(".psml") > 0){
	  $("#main").attr("src",mainsrc);
  }else{
	  document.getElementById("main").contentWindow.location.reload();
  }
  if(isAdmin != "true"){
    timeLineObjReset(timeLineObj);
  }
}
//开始进度条
var commonProgressbar = null;
function startProc(title){
  try{
    var options={
      text:title
    };
    if(title == undefined){
      options = {};
    }
    if(commonProgressbar!=null){
      commonProgressbar.start();
    }else{
        commonProgressbar = new MxtProgressBar(options);
    }
  }catch(e){}
}
//结束进度条
function endProc(){
  try{
    if(commonProgressbar)commonProgressbar.close();
    commonProgressbar = null;
  }catch(e){}
}
/**
* 重新载入菜单
*/
function reloadMenu(path, type){

}
//后台管理界面　返回首页
function backToHome(){
  //window.location.href = _ctxPath+"/main.do?method=main";
  $("#main").attr("src",_ctxPath+"/portal/portalController.do?method=showSystemNavigation");
}
function showContentPage(count){

}
var showLogoutMsgFlag = true;
function showLogoutMsg(msg){
  if(showLogoutMsgFlag){
    try{
      showLogoutMsgFlag = false;
      alert(msg);
      window.location.href = _ctxPath+"/main.do?method=logout";
    }
    catch(e){
      showLogoutMsgFlag = true;
    }
  }
}
//后退按钮事件
function historyBack(url){
  showLeftNavigation();
  try{
		document.getElementById('main').contentWindow.history.back();
		window.setTimeout(function(){
			showTopNavigation();
		},500);
  }catch(e){}
}
//前进按钮事件
function historyForward(){
  showLeftNavigation();
  try{
		document.getElementById('main').contentWindow.history.forward();
		window.setTimeout(function(){
			showTopNavigation();
		},500);
  }catch(e){}
}
//显示当前位置
function showLocation(html){
  var div = $("#nowLocation");
  //$('#content_layout_body_left_content').addClass('border_all');
  if(div){
    $(div).html(html);
    $(div).show();
    $('#nowLocationDiv').show();
    $("#main_div").css("top","20px");
  	if ($.browser.msie) {
  		if ($.browser.version == '6.0' || $.browser.version == '7.0') {
  			var isShowLoaction = $('#main').attr('isShowLoaction');
  			if(isShowLoaction == undefined || isShowLoaction == 'false'){
  			   $('#main').attr('isShowLoaction','true');
  				 //$('#main').height($('#main').height()-20);
  			}
  		}
	}
  }
  if($.ctx.hotspots.breadFontColor){
	  $(".nowLocation_content, .nowLocation_content a").css({"color" : $.ctx.hotspots.breadFontColor.hotspotvalue});
  }
}
function showMainBorder(){
  //$('#content_layout_body_left_content').addClass('border_all');
}
function hideMainBorder(){
  $('#content_layout_body_left_content').removeClass('border_all');
}
//隐藏当前位置
function hideLocation(){
  var div = $("#nowLocation"); 
  //人员卡片点击发送协同，调用hideLocation
  if($('.mask').size()==0){
    $('#content_layout_body_left_content').removeClass('border_all');
  }
  if(div){
    $(div).html("");
    $(div).hide();
    $('#nowLocationDiv').hide();
    $("#main_div").css("top",0);
  	if ($.browser.msie) {
  		if ($.browser.version == '6.0' || $.browser.version == '7.0') {
  			var isShowLoaction = $('#main').attr('isShowLoaction');
  			if(isShowLoaction == 'true'){
  			   $('#main').attr('isShowLoaction','false');
  				 //$('#main').height($('#main').height()+20);
  			}
  		}
		}
  }
}
function showTopNavigation(){
  $(".nav_center").removeClass("nav_center_current nav_top_current");
  $(".nav_center_currentIco:visible").parent(".nav_center").addClass("nav_center_current nav_top_current");
}
function showLeftNavigation(){
  $("#main_layout_left").width(130);
  $("#frount_nav_div").show();
  $("#content_layout").css({'margin-left':""});
  $('#closeopenleft').removeClass('openLeft').addClass('closeLeft').show();
}
function hideLeftNavigation(){
  $("#main_layout_left").width(10);
  $("#frount_nav_div").hide();
  $("#content_layout").css({'margin-left':"5px"});
  $('#closeopenleft').removeClass('closeLeft').addClass('openLeft');
}
function showTimeLine(){
  $('#content_layout_body_right').show();
  $('#content_layout_body_left_content').css('marginRight',48);
  timeLineObjReset(timeLineObj);
}
function hideTimeLine(){
  $('#content_layout_body_right').hide();
  $('#timeLine_time_line_date_set_tooltip').hide();
  $('#content_layout_body_left_content').css('marginRight',10);
}
function showMainMenu(){
  $('#menuDiv').show();
  $('#content_layout_top').height(60);
  $('#content_layout_body').css('top',60);
}
function hideMainMenu(){
  $('#menuDiv').hide();
  $('#content_layout_top').height(0);
  $('#content_layout_body').css('top',0);
}
function hideLogo(){
  $('#logo').remove();
  $('#accountNameDiv').remove();
  $('#accountSecondNameDiv').remove();
}
function hideLogoutButton(){
  $("#logout").hide();
}
function showCurrentPage(pagePath){
  $("#main").attr("src",pagePath);
}
function setonbeforeunload(){
  try{
   var _mainsrc = $('#main').attr('src');
   if(_mainsrc != ''){
     var func = document.getElementById("main").contentWindow.onbeforeunload;
     var _fun = function(){
       if(func!=null) func();
       getCtpTop().$('.mask').remove();
	   var _dialog_box = getCtpTop().$('.dialog_box');
	   if(_dialog_box.size()>0){
		   var _iframes = getCtpTop().$('.dialog_box .dialog_main_content iframe');
		   if(_iframes.size()>0){
			   for(var k=0;k<_iframes.size();k++){
				   try{
					   _iframes[k].contentWindow.document.write('');
						_iframes[k].contentWindow.close();
				   }catch(e){
					   
				   }
			   }
			 _iframes.remove();
		   }
		_dialog_box.remove();
	   }
       getCtpTop().$('.shield').remove();
       getCtpTop().$('.mxt-window').remove();
	}
 	if(document.all){
 		document.getElementById("main").contentWindow.attachEvent('onbeforeunload', _fun);
	}else{
		document.getElementById("main").contentWindow.addEventListener("beforeunload",_fun,false);
	}
   }
  }catch(e){}
}
function removeAllWindow(){
	try{
	    getCtpTop().$('.mask').remove();
		   var _dialog_box = getCtpTop().$('.dialog_box');
		   if(_dialog_box.size()>0){
			   var _iframes = getCtpTop().$('.dialog_box .dialog_main_content iframe');
			   if(_iframes.size()>0){
				   for(var k=0;k<_iframes.size();k++){
						_iframes[k].contentWindow.document.write('');
						_iframes[k].contentWindow.close();
				   }
				 _iframes.remove();
			   }
			_dialog_box.remove();
		   }
	    getCtpTop().$('.shield').remove();
	    getCtpTop().$('.mxt-window').remove();
	}catch(e){}
}
function refreshShortcuts(){
  new portalManager().getCustomizeShortcutsOfMember({
    success : function(shortcuts){
      if(shortcuts){
        $.ctx.shortcut = shortcuts;
        $.initMyShortcut(shortcuts);
      }
    }
  });
}
function refreshMenus(){
  new portalManager().getCustomizeMenusOfMember({
    success : function(menus){
      if(menus){
        $.ctx.menu = menus;
        $.pageMenu(menus);
      }
    }
  });
}
function refreshNavigation(redirectSpaceId){
  new portalManager().getSpaceSort({
    success : function(space){
      if(space){
        $.ctx.space = space;
        $.initSpace(space,null,redirectSpaceId);
      }
    }
  });
}
function initSpaceNavigationNoDisplay(){
  var spaceSort= new portalManager().getSpaceSort({
    success : function(space){
      if(space){
        $.ctx.space = space;
        $.initSpace(space,null,null,true);
      }
    }
  });
}
function refreshAccountName(accountName,secondName){
  portalTemplateManagerObject.getCurrentPortalTemplateAndHotSpots({
	success : function(data){
	  getCtpTop().$.ctx.template = $.parseJSON(data);
	  getCtpTop().refreshCtxHotSpotsData();
	  getCtpTop().$.initHotspots();
	}
  });
}
function refreshHomePageForNC(){
  isOpenCloseWindow = false;
  window.location.href = _ctxPath+"/main.do?method=main&currentSpaceForNC="+currentSpaceId;
}
function changeFunction(ch){
  var result = "";
  switch(ch){
    case '（':{
      result = '︵';
      break;
    }
    case '）':{
      result = '︶';
      break;
    }
    case '{':{
      result = '︷';
      break;
    }
    case '}':{
      result = '︸';
      break;
    }
    case '<':{
      result = '︿';
      break;
    }
    case '>':{
      result = '﹀';
      break;
    }
    case '(':{
      result = '︵';
      break;
    }
    case ')':{
      result = '︶';
      break;
    }
    case '《':{
      result = '︽';
      break;
    }
    case '》':{
      result = '︾';
      break;
    }
    case '【':{
      result = '︻';
      break;
    }
    case '】':{
      result = '︼';
      break;
    }
  }
  return result;
}

//空间名称字符串替换
function replaceSpaceName(spaceName){
  spaceName = spaceName.replace(/(（|）|\{|\}|<|>|\(|\)|《|》|【|】)/g,changeFunction);
  return spaceName;
}
function saveWaitSendSuccessTip(content){
  var htmlContent="<div id='saveTip' class='align_center over_auto padding_5' style='color:#ffffff;width:130px; z-index:900; background-color:#85c93a;'>"+content+"</div>";
  var _left=($("#content_layout_body").width()-130)/2;
  var _top=$("#content_layout_body").offset().top;
  var panel = $.dialog({
      id:'saveTip',
      width: 140,
      height: 24,
      type: 'panel',
      html: htmlContent,
      left:_left,
      top:_top,
      shadow:false,
      panelParam:{
          show:false,
          margins:false
      }
  });
  setTimeout(function(){
      panel.close();
  },2000)
}
function getMainMenuObj(menu,_mainMenuId,_clickMenuId){
  //alert(_mainMenuId+"==="+_clickMenuId)
  var _menu = null;
  var _menu2 = null;
  var _menu3 = null;
  var _menuCurrent = null;
  
  var step;
  
  for (var j=0; j<menu.length; j++) {
    var _temp = menu[j];
    if(_temp.id == _mainMenuId){
      _menu = _temp;
      step = 1;
      break; 
    }
  };
  //alert(_menu.name)
  if(_menu!=null && _menu.items){
    for (var h=0; h<_menu.items.length; h++) {
      var _temp = _menu.items[h];
      if(_temp.id == _clickMenuId){
        _menuCurrent = _temp;
        step = 2;
        break;
      }else{
        if(_temp.items){
          for (var t=0; t<_temp.items.length; t++) {
            var _tempTemp = _temp.items[t];
            if(_tempTemp.id == _clickMenuId){
              _menuCurrent = _tempTemp;
              step = 3;
              break;
            }
          }
        }
      }
    }
  }
  
  if(_menuCurrent!= null){
    return {'menuObj':_menuCurrent,'step':step};
  }else{
    return null;
  }
  
}


var locationCount = 0;
var onbeforunloadFlag = true;
function reloadPage(id,currentId){
	return;
  //ie 6 7 计数  空间第一个 全刷 
  if(locationCount == 10){
    locationCount = 0;//count重置
    spaceReloadPage(id,currentId,"true");
  }
  locationCount++;
}
function spaceReloadPage(id,currentId,shortCutId){
	try{
		if(winUC || winIM){
			return
		}
	}catch(e){}
  if ($.browser.msie) {
    //if ($.browser.version == '6.0' || $.browser.version == '7.0') {
      isDirectClose = false;
      onbeforunloadFlag = false;
      try{
    	  window.location.href = _ctxPath+"/main.do?method=main&mainMenuId="+currentId+"&clickMenuId="+id+"&mainSpaceId=&shortCutId="+shortCutId;
      }catch(e){}
    //}  
  }
}
function winopen(url){
  var targeturl = url;
  if(LoginOpenWindow){
    var isMSIE = (navigator.appName == "Microsoft Internet Explorer");
    if(isMSIE){
      var newwin = window.open('', '', 'resizable=true,status=no');
      try{
        newwin.focus();
      }
      catch(e){
        alert("您打开了窗口拦截的功能，请先关闭该功能。 \n请点击首页的《辅助程序安装》。");
        self.history.back();
        return;
      }
            var _subHeight = 25;
            var sUserAgent = navigator.userAgent;
            var isWinVista = sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1;
            var isWin7 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
            var isWin8 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 8") > -1;
            if(isWinVista || isWin7 || isWin8){
              _subHeight = 38;
            }
      if(newwin != null && document.all){
        newwin.moveTo(0, 0);
        newwin.resizeTo(screen.width, screen.height - _subHeight);
      }
  
      newwin.location.href = targeturl;
      closeIt();
    }
    else{
      window.open (targeturl, '', 'height='+window.screen.height+', width='+window.screen.width+', top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no')
      window.close();
    }
  }
  else{
    self.location.href = targeturl;
  }
}

function closeIt(){
  var nAppName = navigator.appName;
  var nAppVersion = navigator.appVersion;

  if(nAppName=="Netscape"){
    nVersionNum  = nAppVersion.substring(0,2);
  }
  else{
    var startPoint = nAppVersion.indexOf("MSIE ")+5;
    nVersionNum = nAppVersion.substring(startPoint,startPoint+3);
  }
  
  try{
    if(nVersionNum >= 7){
      window.open("closeIE7.htm", "_self");
    }
    else if(nVersionNum > 5.5){
      window.opener = null;
      window.close();
    }
    else{//IE5.5以下的
      document.write("<object classid=clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11 id=closes><param name=Command value=Close></object>");
      closes.Click();
    }
  }
  catch(e){
  }
}

/**
 * 协同调用外框架方法
 * @param objJson json对象
 * @return
 */
function callTopFrameMethod(objJson){
    //新建会议
    if (objJson.openPage == "createMeeting") {
        if (typeof(objJson.frameObj.dialogDealColl)!='undefined' && objJson.frameObj.dialogDealColl!=null) {
            objJson.frameObj.dialogDealColl.close();
        }
        objJson.frameObj.location.href = objJson.url;
    }
}
//返回默认首页
function gotoDefaultPortal(){
	if("desktop" == currentPortalTemplate){
		$(".return_ioc2").click();
	}
}
function refreshAllSection(){
	var _mainSrc = $("#main").attr("src");
	if(_mainSrc.indexOf(".psml")>0){
		var _win = $("#main")[0].contentWindow;
		if(_win.sectionHandler){
			_win.sectionHandler.reloadAllSection();
		}
	}
}

//平台可视化
function showPingTaiKeShiHua(obj, objId){
	if(objId == "pingtaikeshihua"){
		$("#layout_nav").hide();
		$(".layout_left").hide();
		getCtpTop().onbeforunloadFlag = false;
	    getCtpTop().isOpenCloseWindow = false;
	    getCtpTop().isDirectClose = false;
	    getCtpTop().location.href = _ctxPath + "/platview.do";
	}
	/*
	else {
		$("#layout_nav").show();
		$(".layout_left").show();
		refreshSpaceCurrentClass("tuichupingtaikeshihua");
		hideLocation();
		$("#main").attr("src", _ctxPath + "/portal/portalController.do?method=showSystemNavigation");
	}
	*/
}

//工作桌面进入首页时,进行定位
function refreshSpaceCurrentClass(spaceId){
  $(".nav_center_currentIco").each(function(i,obj){
    if($(obj).attr("id") == ("_currentIco_"+spaceId)){
      $(obj).show();
    }else{
      $(obj).hide();
    }
  });
}
//栏目更多页面现在当前位置方法
function showMoreSectionLocation(text){
  var html = '<span class="nowLocation_ico"><img src="'+_ctxPath+'/main/skin/frame/'+skinPathKey+'/menuIcon/moresectionicon.png"></span>';
      html += '<span class="nowLocation_content">';
      html += '<a>' + escapeStringToHTML(text,false) + '</a>';
      html += '</span>';
      getCtpTop().showLocation(html);
}
//刷新工作桌面待办列表
function refreshDeskTopPendingList(){
	var _mainSrc = $("#desktopIframe").attr("src");
	if(_mainSrc && _mainSrc.indexOf("deskTopController.do")>0){
		var _win = $("#desktopIframe")[0].contentWindow;
		if(_win.$.initDeskPending){
			_win.$.initDeskPending();
		}
	}
}

//随OA启动精灵
var isNeedEndA8genius = true;

//延迟1秒加载精灵控件
var ufa = null;
var unloadA8genius = false;
var isGeniusReady = 0;
function initGenius(){
    try {
        // 加载精灵控件前已经登出，停止加载控件
        if (unloadA8genius) {
            return;
        }
        
        if (hasPluginUC != "true" && v3x.isMSIE && (ufa == null || typeof(ufa) == 'undefined')) {
            ufa = new ActiveXObject("UFIDA_IE_Addin.Assistance");
            var topA8 = document.getElementById('about_ioc');
            if (topA8) {
                topA8.setAttribute("title", v3x.getMessage("V3XLang.genius"));
            }
            if (isCurrentUserAdmin == "false") {
                ufa.StartupAssistance(requestSchemeServerName, requestServerPort, currentUserLoginName, currentUserName, sessionId);
            }
        }
    } catch (e) {}
    
    isGeniusReady = 1;
    showDowloadPicture("quartz");
}

/**
 * 批量下载图标控制
 */
var flag = true;
function showDowloadPicture(type){
    if (flag) {
        var downloadDiv = document.getElementById("download-td");
        if (downloadDiv) {
            if ("doc" == type) {
                downloadDiv.style.display = "";
                flag = false;
            } else {
                if (getCtpTop().xmlDoc) {
                    var result = getCtpTop().xmlDoc.GetDownloadState($.ctx.CurrentUser.id);
                    if (result == "FD_STATE_DOWNLOADING") {
                        downloadDiv.style.display = "";
                        flag = false;
                    }
                }
            }
        }
    }
}

/**
 * 批量下载窗口
 */
function showDownloadFile(){
    try {
        getCtpTop().xmlDoc.ShowWindow($.ctx.CurrentUser.id);
    } catch (e) {
        alert(v3x.getMessage("V3XLang.batch_download_control_error"));
    }
}

function checkGeniusVersion(){
  try {
      var geniusVersion = ufa.getGeniusVersion();
      if (geniusVersion == null || geniusVersion != geniusVersion_sysProperty) {
        alert(v3x.getMessage("V3XLang.genius_version"));
          return false;
      }
  } catch (e) {
    alert(v3x.getMessage("V3XLang.genius_version"));
      return false;
  }
  return true;
}

/**
 * 有精灵时切换到精灵,没精灵时弹出关于;
 */
function startA8genius(){
    if (isGeniusReady < 1) {
      return;
    }
    
    try {
        if (ufa == null || typeof(ufa) == 'undefined') {
            showAbout();
        } else {
            if (!checkGeniusVersion()) {
                return;
            }

          // UC中心
      var isExit = true;
            if(hasPluginUC == "true" && isCurrentUserAdmin != "true"){
              isExit = clickCloseUC();
            }
            if (isExit) {
              if(hasPluginUC == "true" && isCurrentUserAdmin != "true"){
                closeUC();// 关闭UC
              }
              isNeedEndA8genius = false;
              logout(true);
            }
        }
    } catch (e) {
        showAbout();
    }
}

function endA8genius(){
  if (isNeedEndA8genius) {
      try {
        if (v3x.isMSIE && (ufa == null || typeof(ufa) == 'undefined')) {
              ufa = new ActiveXObject("UFIDA_IE_Addin.Assistance");
          }
          ufa.LogoutUser(sessionId);
      } catch (e) {}
  } else {
      if (!checkGeniusVersion()) {
          return;
      }
      ufa.DisplayAssistanceWindow(sessionId);
  }
}

//关于弹出窗口
function showAbout(){
    var dialog = $.dialog({
        id: "showAbout",
        url: _ctxPath + "/main.do?method=showAbout",
        width: 504,
        height: 303,
        title: $.i18n("product.about.title"),
        buttons: [{
            text: $.i18n("common.button.close.label"),
            handler: function () {
                dialog.close();
            }
        }]
    });
}

//系统帮助弹出窗口
function showHelp(){
  var url = _ctxPath + "/help/user_" + systemHelp_sysProperty + ".html";
  if (isCurrentUserAdmin == "true") {
    url = _ctxPath + "/help/admin_" + systemHelp_sysProperty + ".html";
  }
  v3x.openWindow({
    url: url,
    width:"700",
    height:"640",
    scrollbars:"yes",
    resizable:"yes",
    dialogType:"open"
  });
}

var xmlDoc = null;
if(isCurrentUserSystemAdmin != "true"){
    getDom();
}

function getDom(){
  if(xmlDoc == null){
      try{
          xmlDoc = new ActiveXObject( "SeeyonFileDownloadLib.SeeyonFileDownload");
          xmlDoc.AddUserParam(currentUserLocale, currentUserLoginName, sessionId, $.ctx.CurrentUser.id);
      }catch(ex1){
        /**
         * TODO:暂时屏蔽控件加载异常
         */
          //alert("批量下载控件加载错误 : " + ex1.message);
      }
  }
  return xmlDoc;
}

var isDirectClose = true;
var firstLeave = 0;

window.onbeforeunload = function(){
  firstLeave++;
  function getActiveElement(win){
    try{
      var currentWin = win.document.activeElement;
      if(currentWin == null){return currentWin;}
      for(var i = 0; i < 7; i++){
        var _tg = currentWin.tagName.toLowerCase();
        if(_tg!= 'iframe'){
          return currentWin;
        } else {
          currentWin = currentWin.contentWindow.document.activeElement;
        }
      }
     }catch(e){
    
     }
  }
  var closeMessage = "";
  if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
    closeMessage=" ";
  }
  if(isDirectClose){
    for(var p = 0;p<_windowsMap.keys().size();p++){
      var _kkk = _windowsMap.keys().get(p);
      try{
        var _fff = _windowsMap.get(_kkk);
        var _dd = _fff.document;
        if(_dd){
          var _p = parseInt(_dd.body.clientHeight);
          if(_p == 0){
        	  _fff = null;
            _windowsMap.remove(_kkk);
          }
        }
      } catch(e) {
    	  _fff = null;
        _windowsMap.remove(_kkk);
      }
    }
    if(_windowsMap.size()>0){
      if(confirm($.i18n("window.exit.isClose"))){
        var _keys = _windowsMap.keys();
        for(var i = 0;i<_keys.size();i++){
          var _k = _keys.get(i);
          var _tp = _windowsMap.get(_k);
          if(_tp)_tp.close();
        }
      }else{
        closeMessage = $.i18n("portal.multiWindow.close");
      }
    }
    if(document.all){
      var event = event = window.event || event;
      var _activeElement = getActiveElement(window);
      if((firstLeave == 1)||(_activeElement == null) || (_activeElement!=null && _activeElement.tagName.toLowerCase() != 'a')){
        window.event.returnValue = closeMessage;
      }
    } else {
      return closeMessage;
    }
  }
}

if(window.attachEvent){
  window.attachEvent('onunload', onbeforeunload_handler);
}else{
  window.addEventListener("unload",onbeforeunload_handler,false);
}

function onbeforeunload_handler(){
  if(!onbeforunloadFlag){return;}
  if(browserFlagByUser && (typeof(isOpenCloseWindow) == "undefined" || isOpenCloseWindow)) {
    isOpenCloseWindow = false;    
    //关闭UC
    if(hasPluginUC == "true" && isCurrentUserAdmin != "true"){
        closeUC();
    }
    //切换精灵
    endA8genius();
    if (!isNeedEndA8genius) {
        return;
    }    
    var ua = navigator.userAgent;
    if(ua.indexOf('Chrome') == -1) {
      $.ajax({
        url : _ctxPath + "/main.do?method=logout",
        async : true
      });
      //OA-27717 IE10暂不做alert处理，可能会产生退出请求发送失败，但不存在大的安全隐患（因为系统具有定时检测机制，30秒左右不操作会自动掉线处理）
      //if(navigator.appName == "Microsoft Internet Explorer" && ua.indexOf('MSIE 10') != -1)
      //alert("${ctp:i18n('loginUserState.hasLogout')}");
    }    
  }
}
/*
if(isTopFrameNameNotNull == "true"){
  hideLogo();
  hideLogoutButton();
  $("#collapse_banner").click();
}
*/