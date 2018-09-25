/**
 * Author:muyx 函数命名规范：pub結尾 综合办公，工具性函数，所有页面通用，不含具体的业务 全局变量请加上页面id，例如：车辆申请，审核界面需要的全局变量为_gApplyAudit(g全局，apply申请，audit审核)
 * 
 */
/**
 * 车辆管理业务上共用的js,
 */
function fnAutoOpenWindow(options) {
	var topWindow = getCtpTop();
	var defaultSet = {
		id:'_office_auto_dialog',
		btnOk : $.i18n('office.auto.ok.js'),
		btnCancel : $.i18n('office.auto.cancel.js'),
		width : 850,
		height : 730,
		hasBtn : true
	};
	
	var opt = $.extend(true, defaultSet, options);
	var transParams = "";
	if (opt.transParams && opt.transParams != null) {
		transParams = opt.transParams;
	}

	var windowParam = {
		id : opt.id,
		url : _path + opt.url,
		targetWindow : topWindow,
		width : opt.width,
		height : opt.height,
		top:opt.top,
		title : opt.title,
		transParams : transParams 
	};

	if (opt.hasBtn) {
		windowParam.buttons = [ {
			text : opt.btnOk,
			isEmphasize:true,
			handler : function() {
				if (typeof (fnOK) !== 'undefined') {
					fnOK({
						dialog : topWindow._officeWin,
						okParam : topWindow._officeWin.getReturnValue()
					});
				}
			}
		}, {
			text : opt.btnCancel,
			handler : function() {
				if (typeof (fnCancel) !== 'undefined') {
					fnCancel({
						dialog : topWindow._officeWin
					});
				}
			}
		} ];
	}
	topWindow._officeWin = $.dialog(windowParam);
}

/**
 * 关闭窗口
 */
function fnAutoCloseWindow() {
	var dialog = null;
	var topWin = getCtpTop();
	if(topWin._officeWin){
		dialog = topWin._officeWin;
		topWin._officeWin = null;
	}
	
	if (window.parentDialogObj) {
		if(!dialog){
			dialog = window.parentDialogObj["_office_auto_dialog"];
		}
	}
	
	if (dialog) {
		try {
			dialog.close();
		} catch (e) {
		}
	}else{
		try {//刷新栏目
			if(window.opener && window.opener.getCtpTop() && window.opener.getCtpTop().main.sectionHandler && window.opener.getCtpTop().main.sectionHandler.reload) {
				window.opener.getCtpTop().main.sectionHandler.reload("pendingSection", true);
			}else if(window.opener && window.opener.getCtpTop().main 
					&& (window.opener.getCtpTop().main.location.href.indexOf("Agent")!=-1
				  ||window.opener.getCtpTop().main.location.href.indexOf("morePending")!=-1)){//刷新代理
				window.opener.getCtpTop().main.location.reload(true);
			}
			//关闭打开窗口
			if(topWin._officeWinW){
				topWin._officeWinW.opener = null;
				topWin._officeWinW.close();
			}else{
				parent.window.close();
				window.close();
			}
		} catch (e) {
		}
	}
}

/**
 * 判断事项是否可用
 * @param affairId
 * @param colManager 必须在调用页面存在
 * @returns 列表页面iframe的id
 */
function isAffairValidPub(affairId,iframeId) {
	var cm = null;
	if(colManager){
		cm = new colManager();
	}else{
		$.alert('请在jsp页面配置colManager!');
		return false;
	}
	
  var msg = cm.checkAffairValid(affairId);
  if ($.trim(msg) != '') {
      $.messageBox({
          'title':$.i18n('collaboration.system.prompt.js'),
          'type':0,
          'imgType':2,
          'msg':msg,
          ok_fn:function() {
          	fnMsgBoxPub(msg, "alert", function() {
          		//刷新页面
    					fnReloadPagePub({page : iframeId});
    					//关闭窗口
    					fnAutoCloseWindow();
    				});
          }
      });
      return false;
  }
  return true;
}

//0-ok,1-error,2alert-感叹号,del3-删除,confirm-询问
function fnMsgBoxPub(msg,type,fn){
	var opt = {ok:0,error:1,alert:2,del:3,confirm:4};
	var _type = 0;
	if (type && opt[type] != undefined) {
		_type = opt[type];
	}
	var msbox = getA8Top().$.messageBox({
		'type' : 100,
		'msg' : msg,
		title:$.i18n('office.system.title.js'),
		imgType : _type,
		buttons : [ {
			id : 'btn1008',
			text : $.i18n('office.auto.ok.js'),
			handler : fn
		} ]
	});
}

/**
 * 刷新列表页面
 * {page:pageId,args:args}
 */
function fnReloadPagePub(opt) {
	var main = getCtpTop().frames["main"];
	var targetWin = null;
	if (main) {
		targetWin = main;
		if (opt.page) {
			var index = opt.page.indexOf("Edit");
			if (index != -1 && ((index + 4) == opt.page.length)){
				var listWin = targetWin.frames[opt.page.substr(0, index)];
				if(listWin && listWin.frames[opt.page] 
					&& listWin.frames[opt.page].fnPageReload){
					listWin.frames[opt.page].fnPageReload();
				}
			}else if (targetWin.frames && targetWin.frames[opt.page]&& targetWin.frames[opt.page].fnPageReload) {//ie
				targetWin.frames[opt.page].fnPageReload(opt.args);
			}else if(targetWin.contentWindow && targetWin.contentWindow.frames[opt.page]&& targetWin.contentWindow.frames[opt.page].contentWindow.fnPageReload){//fireFox,google
				targetWin.contentWindow.frames[opt.page].contentWindow.fnPageReload(opt.args);
			}else if(targetWin.frames[opt.page]&& targetWin.frames[opt.page].contentWindow.fnPageReload){
				targetWin.frames[opt.page].contentWindow.fnPageReload(opt.args);
			}
		} else if (targetWin.fnPageReload) {
			targetWin.fnPageReload(opt.args);
		}
	}
}

/**
 * 隐藏左边导航
 */
function hideLeftNavigationPub() {
	if (getA8Top()) {
		if (getA8Top().hideLeftNavigation) {
			getA8Top().hideLeftNavigation();
		}
	}
}

/**
 * JS对象深度克隆对象
 */
function clonePub(obj) {
	var o = obj.constructor === Array ? [] : {};
	for ( var i in obj) {
		if (obj.hasOwnProperty(i)) {
			o[i] = typeof obj[i] === "object" ? cloneObject(obj[i]) : obj[i];
		}
	}
	return o;
}


/**
 * 关闭滚动条
 */
function endProcePub() {
	try {
		if (getCtpTop().proce) {
			getCtpTop().proce.close();
		}
		getCtpTop().proce = null;
	} catch (e) {
	}
}

/**
 * 开启进度条
 */
function openProcePub() {
	try {
		if (getCtpTop().proce === null) {
			getCtpTop().proce = $.progressBar();
		}
	} catch (e) {
	}
}

/**
 * 获取URL参数指定的name的值
 */
function getURLParamPub(name) {
	var value = window.location.search.match(new RegExp("[?&]" + name
			+ "=([^&]*)(&?)", "i"));
	return value ? decodeURIComponent(value[1]) : value;
}

function setURLParamPub(name, value, url) {
	var newUrl = new String();
	var _url = url;
	if (_url.indexOf("?") != -1) {
		_url = _url.substr(_url.indexOf("?") + 1);
		if (_url.toLowerCase().indexOf(name.toLowerCase()) == -1) {
			newUrl = url + "&" + name + "=" + value;
			return newUrl;
		} else {
			var aParam = _url.split("&");
			for ( var i = 0; i < aParam.length; i++) {
				if (aParam[i].substr(0, aParam[i].indexOf("=")).toLowerCase() == name
						.toLowerCase()) {
					aParam[i] = aParam[i].substr(0, aParam[i].indexOf("=")) + "=" + value;
				}
			}
			newUrl = url.substr(0, url.indexOf("?") + 1) + aParam.join("&");
			return newUrl;
		}
	} else {
		_url += "?" + name + "=" + value;
		return _url
	}
}

/**
 * 新建option
 * @param items 对象数组[{value:xx,txt:xx},..]
 * <option value='value'>text</option>
 * @param 显示最大长度
 */
function fnNewOptionPub(items,option,fn) {
	var options = "";
	var opt = {
		maxLen : 47,
		hasNullOption : true,
		nullOptionValue : "-1",
		nullOptionText : "--"+$.i18n('office.asset.query.select.js')+"--"
	}
	
	var _opt = $.extend(true, opt, option);
	
	var onclick =''
	if(fn){
		onclick = "onclick='"+fn+"(this);'";
	}
	
	if (_opt.hasNullOption) {
		options += "<option value='" + _opt.nullOptionValue + "' "+onclick+">" + _opt.nullOptionText + "</option>";
	}
	
	if(items && $.isArray(items)) {
		for ( var i = 0; i < items.length; i++) {
			var txt = items[i].text;
			if (txt == null) {
				txt = "";
			}
			options += "<option value='" + items[i].value + "' title='"+txt+"' "+onclick+">" 
			+ txt.getLimitLength(_opt.maxLen,'..') + "</option>";
		}
	}
	
	return options;
}

/**
 * @param $div radio的jquery对象
 * @param fdata 填写的数据
 */
function fnFillRadioPub($div, fdata) {
	$div.find(":radio").each(
			function() {
				if ((fdata[this.id] != null || fdata[this.name] != null)
						&& (fdata[this.id] == this.value || fdata[this.name] == this.value)
						&& !this.checked) {
					this.checked = true;
				}
			});
}


/**
 * 人员卡片
 */
function fnPeopleCardPub(userId) {
	$.PeopleCard({
		targetWindow : getCtpTop(),
		memberId : userId
	});
}

/**
 * 字符串转换成日期对象
 */
function fnParseDatePub(str) {
	var date = new Date();
	try {
		if (str instanceof Date) {
			return str;
		} else {
			var year = 1900, month = 0, day = 1, hour = 0, minute = 0, second = 0, dateStrs = '', timeStrs = '';
			var tempStrs = str.split(" ");
			if (tempStrs.length >= 1 && tempStrs[0].length == 10) {
				dateStrs = tempStrs[0].split("-");
				year = parseInt(dateStrs[0], 10);
				month = parseInt(dateStrs[1], 10) - 1;
				day = parseInt(dateStrs[2], 10);
			}
			
			if (tempStrs.length >= 2 && (tempStrs[1].length == 5 || tempStrs[1].length == 8)) {
				timeStrs = tempStrs[1].split(":");
				hour = parseInt(timeStrs[0], 10);
				minute = parseInt(timeStrs[1], 10);
				if (tempStrs[1].length == 8) {
					second = parseInt(timeStrs[2], 10);
				}
			}
		}
		date = new Date(year, month, day, hour, minute, second);
	} catch (e) {
	}
	return date;
}

/**
 * 工作流审核人选人界面取消的回调函数，解决遮罩不关闭问题
 */
function releaseApplicationButtons(){
	endProcePub();
}