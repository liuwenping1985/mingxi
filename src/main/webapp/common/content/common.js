var forminputdialog;
String.prototype.replaceAll = function(s1, s2) {
	return this.replace(new RegExp(s1, "gm"), s2);
}
/**
 * 调用公式组件函数
 * 
 * @param formulaStr
 *            公式字符串
 * @param fieldName
 *            鼠标选择的表单控件的数据库字段名!!
 * @param title
 *            弹出窗口的标题
 * @param user
 *            用户自定义对象列表
 */
function selectFormula(formulaStr, fieldName, title, user) {
	var newFormulaStr = formulaStr.replaceAll("'", "\"");
	var transPa = {
		"formula" : eval("(" + formulaStr + ")")
	};
	var formId = transPa.formula.formId;
	var obj = new Array();
	obj[0] = window;
	obj[1] = transPa;
	obj[2] = user;
	if (!title) {
		title = '计算公式设置';
	}
	var dialog = $.dialog({
	    url : _ctxPath+"/form/component.do?method=formula&fieldName=" + fieldName + "&formula=" + newFormulaStr + (formId == null ? "" : ("&formId=" + formId)),
	    title : title,
	    width : 600,
	    height : 500,
	    transParams : obj,
	    targetWindow : getCtpTop(),
	    buttons : [ {
	        text : $.i18n('form.forminputchoose.enter'),
	        id : "sure",
	        handler : function() {
		        var result = dialog.getReturnValue();
		        if (result) {
			        dialog.close();
		        }
	        }
	    }, {
	        text : $.i18n("form.forminputchoose.cancel"),
	        id : "exit",
	        handler : function() {
		        dialog.close();
	        }
	    } ]
	});
	return dialog;
}
function selectChoose(fieldId, formId, split, customJson, callBack) {
	// 现修改为dialog方式打开,传入的split和customJson都为json对象
	// mytype说明:1==>自定义查询项, 2==>统计分组项,3==>统计项,4===>输出数据项,5==>排序设置
	// datafiledId说明:相关联的textid,在排序时有用到,作为左上区域的数据
	// hideText说明:用来存放返回的值的Key的text的id
	// splitObj说明:过滤条件
	// var
	// splitObj"{'byTable':'wee','byInputType':'handwrite,attachment,document,image,textarea'}"
	// customerJson说明:用户自定义选择框
	// var
	// customJson="{'DialogTitle':'用户输入条件1','ShowTitle':'自定义查询设置1','LeftUpTitle':'表单数据域1','LeftDownTitle':'系统数据域1','RightTitle':'自定义查询域1','IsShowLeftDown':false,'IsShowSearch':false}";
	var type = $("#" + fieldId).attr("mytype");
	var DialogTitle = "";
	var height = 450;
	var needAttr = false; // 如果需要附件类型的字段，加判断把此值该为true，这是在之前代码上强加的一个参数
	if (type == '1') {
		DialogTitle = $.i18n("form.forminputchoose.userinputconditon");
	} else if (type == '2') {
		DialogTitle = $.i18n("form.forminputchoose.reportgroup");
	} else if (type == '4') {
		DialogTitle = $.i18n("form.forminputchoose.outputdata");
	} else if (type == '3') {
		DialogTitle = $.i18n("form.forminputchoose.reportdata");
	} else if (type == '6') {
		height = 500;
		DialogTitle = $.i18n("form.forminputchoose.logconfig");
		callBack = setLogs;
	} else if (type == '5') {
		DialogTitle = $.i18n("form.forminputchoose.orderconfig");
	} else if (type == '11') {
		DialogTitle = $.i18n("form.report.customfield.label");
	}
	var urlParam = "";
	if (split && split.byInputType && split.byInputType.indexOf("relationFlow") > -1) {// 是否过滤关联表单流程名称
		urlParam = "&isRelationFlow=1";
	}
	if (customJson != null) {
		DialogTitle = customJson.DialogTitle || DialogTitle;
		if (customJson.isEchoSetting) {
			urlParam = "&isEchoSetting=1";
			needAttr = true;
		}
	}
	var url = _ctxPath+"/form/component.do?method=formInputChoose&needAttr=" + needAttr + "&choose=" + fieldId + (formId == null ? "" : "&formId=" + formId) + urlParam;
	var obj = new Array();
	obj[0] = window;
	obj[1] = split;
	obj[2] = customJson;
	forminputdialog = $.dialog({
	    url : url,
	    title : DialogTitle,
	    width : 600,
	    height : $.browser.chrome ? (height + 40) : height,
	    transParams : obj,
	    targetWindow : getCtpTop(),
	    buttons : [ {
	        text : $.i18n("form.forminputchoose.enter"),
	        id : "sure",
	        handler : function() {
		        var result = forminputdialog.getReturnValue();
		        if (result) {
			        if ($("#" + fieldId).attr("mytype") == 4 && result == 'false') {
				        $.alert($.i18n("form.forminputchoose.canonlyonesontable"));
			        } else {
				        if (callBack != null) {
					        var c = callBack(result);
					        if (c != null && c == false) {
						        return;
					        }
				        }
				        forminputdialog.close();
			        }
		        }
	        }
	    }, {
	        text : $.i18n('form.forminputchoose.cancel'),
	        id : "exit",
	        handler : function() {
		        forminputdialog.close();
	        }
	    } ]
	});
	return forminputdialog;
}
function selectAll(obj, contain) {
	if ($(obj).prop("checked")) {
		$(":checkbox", "#" + contain).prop("checked", true);
	} else {
		$(":checkbox", "#" + contain).prop("checked", false);
	}
}

/**
 * 获取打开无流程表单的url地址 isFullPage true moduleId 表单业务数据id，对应的是CTP_CONTENT_ALL表的id
 * moduleType 正文组件分类类型 详细查询com.seeyon.ctp.common.ModuleType枚举 rightId 权限id
 */
function getUnflowFormViewUrl(isFullPage, moduleId, moduleType, rightId, viewState) {
	var src = _ctxPath+"/content/content.do?method=index&isFullPage=" + isFullPage + "&moduleId=" + moduleId + "&moduleType=" + moduleType + "&rightId=" + rightId + "&contentType=20&viewState=" + viewState;
	return src;
}

/*
 * 穿透查询 formType 打开的表单类型 dataId 表单主表的数据ID rightId 权限 title 显示框的标题 穿透查询统计
 * 显示的是该查询统计的标题 frame 穿透后内容直接在frame中显示 formId 表单ID
 */
// rightId 视图ID.权限ID|视图id.权限id
function showFormData4Statistical(formType, dataId, rightId, title, frame, formId) {
	var moduleType = enu.ModuleType.collaboration;
	switch (formType) {
	case enu.Enums$FormType.manageInfo:
		moduleType = enu.ModuleType.unflowInfo;
		break;
	case enu.Enums$FormType.baseInfo:
		moduleType = enu.ModuleType.unflowBasic;
		break;
	case enu.Enums$FormType.planForm:
		moduleType = enu.ModuleType.plan;
		break;
	default:
		moduleType = enu.ModuleType.collaboration;
	}
	var openFroms = "formStatistical";// 统计
	if (window.location.href.indexOf("queryResult.do") > -1) {// 查询
		openFroms = "formQuery";
	}
	if (moduleType == enu.ModuleType.collaboration) {
		var contentManager = new ctpMainbodyManager();
		var dd = contentManager.getContentListByContentDataIdAndModuleType(moduleType, dataId);
		if (dd != null && dd.length > 0) {
			// showSummayDialog(null,dd[0].moduleId,null,"formStatistical",'6819880600370627686',"ssss");
			// 历史数据中存在数据ID重复，升级上来后会有查询出很多其他表单的数据，这里做一个循环判断
			var moduleId;
			if (formId) {
				for ( var i = 0; i < dd.length; i++) {
					if (dd[i].contentTemplateId == formId) {
						moduleId = dd[i].moduleId;
						break;
					}
				}
			} else {
				moduleId = dd[0].moduleId;
			}
			showSummayDialog(null, moduleId, null, openFroms, rightId, title, frame, formId);
		}
	} else if (moduleType == enu.ModuleType.plan) {
		var contentManager = new ctpMainbodyManager();
		var dd = contentManager.getContentListByContentDataIdAndModuleType(moduleType, dataId);
		if (dd != null && dd.length > 0) {
			if (frame) {
				frame.attr("src", _ctxPath + "/plan/plan.do?method=initPlanDetailFrame&isFromRefer=true&readOnly=true&planId=" + dd[0].moduleId + "&openFrom=" + openFroms);
			} else {
				var dialog = $.dialog({
				    url : _ctxPath + "/plan/plan.do?method=initPlanDetailFrame&isFromRefer=true&readOnly=true&planId=" + dd[0].moduleId + "&openFrom=" + openFroms,
				    title : title,
				    width : screen.availWidth - 100,
				    height : screen.availHeight - 150,
				    transParams : this,
				    targetWindow : getCtpTop()
				});
				// window.showModalDialog(,this,'dialogWidth:'+
				// screen.availWidth+'px;dialogHeight:'+screen.availHeight+'px;center:yes;');
			}
		}
	} else {
		if (frame) {
			frame.attr("src", getUnflowFormViewUrl(true, dataId, moduleType, rightId, 2));
		} else {
			window.showModalDialog(getUnflowFormViewUrl(true, dataId, moduleType, rightId, 2), this, 'dialogWidth:' + screen.availWidth + 'px;dialogHeight:' + screen.availHeight + 'px;center:yes;');
		}
	}
}

/**
 * 打开正文内容
 * 
 * affairId,summaryId,processId 三个参数如果有affairId优先传affairId，如果 取不到affairId传
 * summaryId或者processId openFrom 从哪里打开的,用来控制协同处理界面右侧处理区域是否显示 从如下字符串中取值：
 * formStatistical 表单查询统计 docLib 文档中心 supervise 督办 listDone 已办列表 noNeedForAudit
 * 需要审计 listPending 待办列表 operationId 表单使用的字段，没有可以传 null title
 * dialog的标题，用affair的subject值 frame 内容直接在frame中显示 formId 表单ID
 */
// hewanli 此方法位于 ctp/collaboration/collFaboration.js.jsp中 引入文件报错 暂时放此
function showSummayDialog(affairId, summaryId, processId, openFrom, operationId, title, frame, formId) {
	// TODO 如果title为空 aJax查询
	var url = _ctxPath + "/collaboration/collaboration.do?method=summary";
	if (affairId != null && typeof (affairId) != 'undefined') {
		url += "&affairId=" + affairId;
	}
	if (summaryId != null && typeof (summaryId) != 'undefined') {
		url += "&summaryId=" + summaryId;
	}
	if (processId != null && typeof (processId) != 'undefined') {
		url += "&processId=" + processId;
	}
	if (openFrom != null && typeof (openFrom) != 'undefined') {
		url += "&openFrom=" + openFrom;
	}
	if (operationId != null && typeof (operationId) != 'undefined') {
		url += "&operationId=" + operationId;
	}
	if (formId) {
		url += "&formId=" + formId;
	}
	var width = $(getA8Top().document).width() - 100;
	var height = $(getA8Top().document).height() - 50;
	if (frame) {
		frame.attr("src", url);
	} else {
		dialogDealColl = $.dialog({
		    url : url,
		    width : width,
		    height : height,
		    title : title,
		    id : 'dialogDealColl',
		    transParams : [ $('#summary'), $('.slideDownBtn'), $('#listPending') ],
		    targetWindow : getCtpTop()
		});
	}
}

/**
 * 打开extend设置
 * 
 * @param obj
 *            要把公式回写的区域(暂不用了)
 * @param selectObj
 *            鼠标选择的表单控件的数据库字段名!!
 * @param fieldInputType
 *            表单控件的录入类型
 * @param fieldType
 *            表单控件的字段类型
 * @param isShowRadio
 *            是否显示本表单其它日期类型控件boolean：true显示,false不显示,默认不显示
 * @param calllbackFuncion
 *            回调函数
 * @return result数组
 *         isShowSelfDate=true,calllbackFuncion存在的时候:返回一个数组rev[0]:操作符;rev[1]对应re[2]为1则为日期字符串否则'｛表单控件名}'
 *         rev[2]:值为1手填写,2表单域名称; 其它：同上,但是只有两个值
 * 
 */
function extendCommon(obj, selectedField, fieldInputType, fieldType, isShowRadio, calllbackFuncion) {
	if (selectedField && (fieldInputType == "checkbox" || fieldInputType == "radio" || fieldInputType == "select" || fieldInputType == "member" || fieldInputType == "date" || fieldInputType == "datetime" || fieldInputType == "project" || fieldInputType == "account" || fieldInputType == "department" || fieldInputType == "post" || fieldInputType == "level" || fieldInputType == "relationform" || fieldInputType == "relation" || fieldType == "TIMESTAMP" || fieldType == "DATETIME" || selectedField == "start_member_id" || selectedField == "modify_date" || selectedField == "start_date")) {
		var dialog = $.dialog({
		    url : _ctxPath+"/form/component.do?method=formulaExtend&field=" + selectedField + "&fieldType=" + fieldType + "&fieldInputType=" + fieldInputType + "&isShowRadio=" + isShowRadio + "&calllbackFuncion=" + calllbackFuncion,
		    title : '',
		    width : 500,
		    height : 300,
		    targetWindow : getCtpTop(),
		    buttons : [ {
		        text : $.i18n('form.forminputchoose.enter'),
		        id : "sure",
		        handler : function() {
			        var result = dialog.getReturnValue();
			        if (calllbackFuncion) {
				        if (result.length > 0) {
					        calllbackFuncion(result);
				        }
			        }
			        dialog.close();
		        }
		    }, {
		        text : $.i18n('form.forminputchoose.cancel'),
		        id : "exit",
		        handler : function() {
			        dialog.close();
		        }
		    } ]
		});
	} else {
		$.alert("请选择单选、复选、下拉、日期、日期时间、选人、选单位、选部门、选岗位、选职务级别、选择关联表、选关联项目、数据关联类型表单数据!");
	}
}
/**
 * 移动光标函数
 * 
 * @param obj
 *            选择对象
 * @param point
 *            光标移动位置
 * @return void
 */
function moveCursor(obj, point) {
	if (document.all) {
		var range = $('#' + obj)[0].createTextRange();
		range.moveStart("textedit")
		range.moveStart("word", point);
		range.moveEnd("word", point);
		range.select();
	} else {
		$('#' + obj)[0].setSelectionRange(point, point);
		$('#' + obj)[0].focus();
	}
}
/**
 * 表单授权按钮onclick响应 moduleIds:所选表单协同id数组 moduleType:模块类型
 * 使用请参考com.seeyon.ctp.common.ModuleType枚举
 * callBack：授权成功之后的回调方法，可执行刷新页面或者在所选表单协同title之后添加已经授权的图标设置
 */
function setRelationAuth(moduleIds, moduleType, callBack) {
	// 如果只有一条，则查询出此条协同原来授权
	var tempFormRelationManager = new formRelationManager();
	var oldSelect = new Object();
	oldSelect.text = "";
	oldSelect.value = "";
	if (moduleIds.length == 1) {
		var param = new Object();
		param.moduleId = moduleIds[0];
		param.moduleType = moduleType;
		tempFormRelationManager.getRelationAuthorityBySummaryId(param, {
			success : function(_obj) {
				var resultObj = $.parseJSON(_obj);
				if (resultObj.success == "true" || resultObj.success == true) {
					oldSelect = resultObj.oldSelect;
					selectPeopleForRelationAuthority(moduleIds, moduleType, oldSelect, callBack);
				} else {
					$.alert(resultObj.errorMsg);
				}
			}
		});
	} else {
		selectPeopleForRelationAuthority(moduleIds, moduleType, oldSelect, callBack);
	}
}

// 关联授权选人
function selectPeopleForRelationAuthority(moduleIds, moduleType, oldSelect, callBack) {
	$.selectPeople({
	    panels : 'Department,Team,Post,RelatePeople,Outworker',
	    selectType : 'Member,Department,Team,Post,RelatePeople,Outworker',
	    params : oldSelect,
	    minSize : 0,
	    callback : function(ret) {
		    var summ = new Object();
		    if (ret.value == undefined || ret.value == '') {
			    summ.text = '';
			    summ.value = '';
		    } else {
			    summ.text = ret.text;
			    summ.value = ret.value;
		    }
		    summ.moduleIds = moduleIds.join(",");
		    summ.moduleType = moduleType;

		    var tempFormRelationManager = new formRelationManager();
		    tempFormRelationManager.updateRelationAuthority(summ, {
			    success : function(_obj) {
				    var resultObj = $.parseJSON(_obj);
				    if (resultObj.success == "true" || resultObj.success == true) {
					    if (summ.value == '') {
						    callBack(false);
					    } else {
						    callBack(true);
					    }
				    } else {
					    $.alert(resultObj.errorMsg);
				    }
			    }
		    });
	    }
	});
}

/*
 * 设置用户定义条件的输入框$对象id
 */
var editUserConditionField = function(formulaDOMId) {
	var trObj = new Object();
	trObj.data = $("#userFields");
	// trObj.data.val("[{id:'',name:'www',title:'rrrr',inputTypeEnum:{text:'文本'},value:'222'},{id:'',name:'www2',title:'rrrr2',inputTypeEnum:{text:'文本'},value:'222'}]");
	trObj.formula = $("#" + formulaDOMId);
	var dialog = $.dialog({
	    url : _ctxPath+"/form/component.do?method=forward&source=ctp/form/component/userConditionSet",
	    title : '用户自定义条件控件',
	    width : 600,
	    height : 350,
	    transParams : trObj,
	    targetWindow : getCtpTop(),
	    buttons : [ {
	        text : $.i18n('form.forminputchoose.enter'),
	        id : "sure",
	        handler : function() {
		        var result = dialog.getReturnValue();
		        dialog.close();
	        }
	    }, {
	        text : $.i18n('form.forminputchoose.cancel'),
	        id : "exit",
	        handler : function() {
		        dialog.close();
	        }
	    } ]
	});
}