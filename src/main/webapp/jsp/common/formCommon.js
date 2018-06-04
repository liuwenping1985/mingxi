var forminputdialog;
String.prototype.replaceAll = function(s1, s2) {
	return this.replace(new RegExp(s1, "gm"), s2);
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
	//执行这个方法的页面来源
	var pageFrom = $("#" + fieldId).attr("pageFrom");
	var DialogTitle = "";
	var height = 450;
	var needAttr = false; // 如果需要附件类型的字段，加判断把此值该为true，这是在之前代码上强加的一个参数
	var onlyHANDWRITE = false;//判断是否只排除签章字段，为true则只排除字段类型为签章控件的，false则排除签章，多组织
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
		onlyHANDWRITE = true;
	} else if (type == '5') {
		DialogTitle = $.i18n("form.forminputchoose.orderconfig");
	} else if (type == '11') {
		DialogTitle = $.i18n("form.report.customfield.label");
	}else if(type == '12') {
		DialogTitle = $.i18n("form.trigger.automatic.selectsamevalue.label");
	}else if(type == '13') {
		DialogTitle = $.i18n("form.formula.engin.function.preRow.set.rowCondition.title");
	}
	var urlParam = "";
	if (split && split.byInputType && split.byInputType.indexOf("relationFlow") > -1) {// 是否过滤关联表单流程名称
		urlParam = "&isRelationFlow=1";
	}
	if (customJson != null) {
		DialogTitle = customJson.DialogTitle || DialogTitle;
		if (customJson.isEchoSetting) {
			urlParam = "&isEchoSetting=1&fieldType="+customJson.fieldType+"&formatType="+customJson.formatType;
			needAttr = true;
		}
		//无流程批量修改选择框
		if (customJson.IsBathUpdate){
			urlParam = "&isBathUpdate=1";
		}
		//移动端查询设置传入pc端设置的输出项
		if(customJson.PcShowFields){
			urlParam = "&pcShowFields=" + customJson.PcShowFields;
		}
	}
	var url = _ctxPath+"/form/component.do?method=formInputChoose&needAttr=" + needAttr + "&pageFrom="+$.trim(pageFrom)+"&onlyHANDWRITE="+onlyHANDWRITE+"&choose=" + fieldId + (formId == null ? "" : "&formId=" + formId) + urlParam;
	var obj = new Array();
	obj[0] = window;
	obj[1] = split;
	obj[2] = customJson;
	forminputdialog = $.dialog({
	    id:"formInputChooseDialog",
	    url : url,
	    title : DialogTitle,
	    width : 600,
	    height : $.browser.chrome ? (height + 40) : height,
	    transParams : obj,
	    targetWindow : getCtpTop(),
	    buttons : [ {
	        text : $.i18n("form.forminputchoose.enter"),
	        id : "sure",
			isEmphasize: true,
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
 * 设置选择表单字段
 * @param selectType 选择类型，实现 接口 ComponentLeft2Right getName 的返回值 ，必须有此值，无值则方法不执行
 * @param options 接收的参数
 * 			formId：需要获取的表单字段所在表单id，默认值0，当前编辑表单
 * 			title：设置框的标题
 * 			height：设置框的搞定，默认450
 * 			min：选择结果的最小个数，默认0，不限制
 * 			max：选择结果的最大个数，默认0，不限制
 * 			paramWin：设置窗口对应父页面，如果需要设置窗口自动回填选择值，会用到此项
 * 			canSort：选择项是否支持排序
 * 			fieldTitle：备选框标题，默认表单数据域
 * 			valueTitle：已选框标题，默认已选择数据域
 * 			showSysArea：是否显示左下角系统数据域区域
 * 			sysAreaLabel：系统数据域区域标题，默认系统数据域
 * 			search：是否支持查询
 * 			delMsg: 移除不能移除项的提示语的国际化key，需要有一个参数，放置不能删除项的名称，默认：{0}不能被移除！
 * 			desc：需要显示的描述信息，如有此项，高度需要设置
 * 			reverseFilter：反向过滤，取默认过滤条件相反的过滤结果，默认fales
 * 		    needMaster:是否必须包含主表字段
 * 			filter：过滤字段条件 可以包含多个，则以逗号分隔，如datetime,timestamp，不区分大小写 edit by chenxb 2016-03-10
 * 				table：需要留存的表单字段，为空不过滤
 * 				inputType：需要留存的录入类型，为空不过滤
 * 				fieldType：需要留存的字段类型，为空不过滤
 * 				formatType：需要留存的显示格式，为空不过滤
 * 			relationSource:关联的源
 * 				value:值
 * 				display:显示值
 * 			relationValue：关联的值
 * 				value：值
 * 				display:显示值
 * 			result：回填到的单元格
 * 				value：值
 * 				display:显示值
 * 			callBack：选择值后的回调函数，需要有返回值，校验正常返回true，窗口关闭，否则返回false，窗口不关闭
 * 			sourceEvent：备选项事件
 * 				clk：单击事件
 * 				dbclk：双击事件，默认选择选中项到已选区域
 * 			valueEvent：已选项事件
 * 				clk：单击事件
 * 				dbclk：双击事件，默认从已选区域移除
 */
function selectFormField(selectType,options) {
	if (!selectType) {
		return;
	}

	var settings = {
		formId:0,
		title:"",
		height:450,
		min:0,
		max:0,
		paramWin:window,
		canSort:true,
        needMaster:true,
		fieldTitle: $.i18n('form.forminputchoose.formdata'),
		valueTitle: $.i18n('form.forminputchoose.chooseddata'),
		showSysArea:true,
		sysAreaLabel: $.i18n('form.forminputchoose.systemdata'),
		search:true,
		reverseFilter:false,
		desc:false,
		delMsg:'form.component.select.field.delMsg.default',
		filter:{
			table:'',
			inputType:'',
			fieldType:'',
			formatType:''
		},
		relationSource:{
			value:'',
			display:''
		},
		relationValue:{
			value:'',
			display:''
		},
		result:{
			value:'',
			display:''
		},
		sourceEvent:{
			clk:'',
			dbclk:'select'
		},
		valueEvent:{
			clk:'',
			dbclk:'remove'
		}
	};
	options = $.extend(settings, options);
	var url = _ctxPath + "/form/component.do?method=selectFormField&formId=" + options.formId + "&selectType=" + selectType;
	var dialog = $.dialog({
		id:"selectFormField",
		url:url,
		title:options.title,
		width:600,
		height:options.height,
		transParams : options,
		targetWindow : getCtpTop(),
		buttons:[{
			text : $.i18n("form.forminputchoose.enter"),
			id : "sure",
			isEmphasize: true,
			handler : function(){
				var result = dialog.getReturnValue();
				if (!result.ok){
					return;
				}
				if (options.callBack) {
					result = options.callBack(result);
					if (!result){
						return;
					}
				}
				dialog.close();
			}
		},{
			text : $.i18n('form.forminputchoose.cancel'),
			id : "exit",
			handler : function() {
				dialog.close();
			}
		}]
	});
}

/**
 * 获取打开无流程表单的url地址 isFullPage true moduleId 表单业务数据id，对应的是CTP_CONTENT_ALL表的id
 * moduleType 正文组件分类类型 详细查询com.seeyon.ctp.common.ModuleType枚举 rightId 权限id
 */
function getUnflowFormViewUrl(isFullPage, moduleId, moduleType, rightId, viewState, openFrom, relObjId) {
	var src = _ctxPath+"/content/content.do?method=index&isFullPage=" + isFullPage + "&moduleId=" + moduleId + "&moduleType=" + moduleType + "&rightId=" + rightId + "&contentType=20&viewState=" + viewState;
    if (openFrom) {
        src = src + "&openFrom=" + openFrom;
    }
    if (relObjId) {
        src = src + "&relObjId=" + relObjId;
    }
	return src;
}

/*
 * 穿透查询 formType 打开的表单类型 dataId 表单主表的数据ID rightId 权限 title 显示框的标题 穿透查询统计
 * 显示的是该查询统计的标题 frame 穿透后内容直接在frame中显示 formId 表单ID
 */
// rightId 视图ID.权限ID|视图id.权限id
function showFormData4Statistical(formType, dataId, rightId, title, frame, formId, relObjId) {
	rightId = rightId.replaceAll("[|]","_");
	var moduleType = "1";
	formType = "" + formType;
	switch (formType) {
	case "2":
		moduleType = "37";
		break;
	case "3":
		moduleType = "36";
		break;
	case "4":
		moduleType = "5";
		break;
	default:
		moduleType = "1";
	}
	var openFroms = "formStatistical";// 统计
	if (window.location.href.indexOf("queryResult.do") > -1) {// 查询
		openFroms = "formQuery";
	}
	if (moduleType == "1") {
		var contentManager = new ctpMainbodyManager();
		var dd = contentManager.getContentListByContentDataIdAndModuleType(moduleType, dataId);
		if (dd != null && dd.length > 0) {
			// showSummayDialog(null,dd[0].moduleId,null,"formStatistical",'6819880600370627686',"ssss");
			// 历史数据中存在数据ID重复，升级上来后会有查询出很多其他表单的数据，这里做一个循环判断
			var moduleId;
			var i = 0;
			if (formId) {
				for ( i = 0; i < dd.length; i++) {
					if (dd[i].contentTemplateId == formId && (dd[i].contentType == 20 || dd[i].contentType == '20') && (dd[i].moduleTemplateId != "-1" || dd[i].moduleTemplateId != -1)) {
						moduleId = dd[i].moduleId;
						break;
					}
				}
			} else {
				moduleId = dd[0].moduleId;
			}
			showSummayDialog(null, moduleId, null, openFroms, rightId, dd[i].title, frame, formId);
		}else{
			$.alert($.i18n("form.query.content.not.exist.label"));
		}
	} else if (moduleType == "5") {
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
			}
		}
	} else {
		if (frame) {
			frame.attr("src", getUnflowFormViewUrl(true, dataId, moduleType, rightId, 2, openFroms,relObjId));
		} else {
			//改为使用dialog而不是模态对话框，因为模态对话框下刷新页面要自己打开一个新窗口
			var dialog = $.dialog({
                url:getUnflowFormViewUrl(true, dataId, moduleType, rightId, 2, openFroms,relObjId),
                title : " ",
                targetWindow : getCtpTop(),
                width:$(getCtpTop()).width()-100,
                height:$(getCtpTop()).height()-100,
                isClear:false
                })
		}
	}
}

    /**
     *  打开正文内容
     *
     *  affairId,summaryId,processId 三个参数如果有affairId优先传affairId，如果 取不到affairId传 summaryId或者processId
     *  openFrom        从哪里打开的,用来控制协同处理界面右侧处理区域是否显示  从如下字符串中取值：
     *                  formStatistical 表单查询统计
     *                  docLib  文档中心
     *                  supervise 督办
     *                  listDone 已办列表
     *                  noNeedForAudit 需要审计
     *                  listPending 待办列表
     *  operationId     表单使用的字段，没有可以传 null
     *  title       dialog的标题，用affair的subject值
     *  frame       内容直接在frame中显示
     *  formId  表单ID
     *  parentSummaryId 当前协同summaryId
     */
     // hewanli 此方法位于 ctp/collaboration/collFaboration.js.jsp中  引入文件报错   暂时放此
    function showSummayDialog(affairId,summaryId,processId,openFrom,operationId,title,frame,formId,parentSummaryId){
        //TODO 如果title为空 aJax查询
        var url = _ctxPath + "/collaboration/collaboration.do?method=summary";
        if(parentSummaryId!=undefined&&parentSummaryId!=null){
        	url += "&baseObjectId=" + parentSummaryId + "&baseApp=1";
        }
        if(affairId!=null&&typeof(affairId)!='undefined'){
            url+="&affairId="+affairId;
        }
        if(summaryId!=null&&typeof(summaryId)!='undefined'){
            url+="&summaryId="+summaryId;
        }
        if(processId!=null&&typeof(processId)!='undefined'){
            url+="&processId="+processId;
        }
        if(openFrom!=null&&typeof(openFrom)!='undefined'){
            url+="&openFrom="+openFrom;
        }
        if(operationId!=null&&typeof(operationId)!='undefined'){
            url+="&operationId="+operationId;
        }
        if(formId){
            url+="&formId="+formId;
        }
        var width = $(getA8Top().document).width() - 100;
        var height = $(getA8Top().document).height() - 50;
        if(frame){
        	frame.attr("src",url);
        }
        else{
        	var dialogId = 'dialogDealColl'+getUUID();
	        dialogDealColl = $.dialog({
	            url: url+"&dialogId="+dialogId,
	            width: width,
	            height: height,
	            title: " ",
	            id:dialogId,
	            transParams:[$('#summary'),$('.slideDownBtn'),$('#listPending')],
	            targetWindow:getCtpTop()
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
				isEmphasize: true,
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
function setRelationAuth(moduleIds, moduleType, callBack,failCallBack) {
	// 如果只有一条，则查询出此条协同原来授权
	var oldSelect = new Object();
	oldSelect.text = "";
	oldSelect.value = "";
	if (moduleIds.length == 1) {
		var param = new Object();
		param.moduleId = moduleIds[0];
		param.moduleType = moduleType;
		callBackendMethod("formRelationManager","getRelationAuthorityBySummaryId",param, {
			success : function(_obj) {
				var resultObj = $.parseJSON(_obj);
				if (resultObj.success == "true" || resultObj.success == true) {
					oldSelect = resultObj.oldSelect;
					selectPeopleForRelationAuthority(moduleIds, moduleType, oldSelect, callBack,failCallBack);
				} else {
					$.alert(resultObj.errorMsg);
					if(failCallBack){
						failCallBack();
					}
				}
			}
		});
	} else {
		selectPeopleForRelationAuthority(moduleIds, moduleType, oldSelect, callBack,failCallBack);
	}
}

// 关联授权选人
function selectPeopleForRelationAuthority(moduleIds, moduleType, oldSelect, callBack,failCallBack) {
	$.selectPeople({
	    panels : 'Department,Team,Post,RelatePeople,Outworker',
	    selectType : 'Account,Member,Department,Team,Post,RelatePeople,Outworker',
	    hiddenPostOfDepartment: true,
	    params : oldSelect,
	    minSize : 0,
	    canclecallback : function(){
	   		if(failCallBack){
				failCallBack();
			}
	    },
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

			callBackendMethod("formRelationManager","updateRelationAuthority",summ, {
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
					    if(failCallBack){
					    	failCallBack();
					    }
				    }
			    }
		    });
	    }
	});
}

/*
 * 设置用户定义条件的输入框$对象id
 */
var editUserConditionField = function(formulaDOMId,moduleType) {
	var trObj = new Object();
	trObj.data = $("#userFields");
	trObj.moduleType = moduleType;
	// trObj.data.val("[{id:'',name:'www',title:'rrrr',inputTypeEnum:{text:'文本'},value:'222'},{id:'',name:'www2',title:'rrrr2',inputTypeEnum:{text:'文本'},value:'222'}]");
	trObj.formula = $("#" + formulaDOMId);
	var dialog = $.dialog({
	    url : _ctxPath+"/form/component.do?method=forward&source=ctp/form/component/userConditionSet",
	    title : $.i18n('form.query.user.customCotion.set.label'),
	    width : 600,
	    height : 350,
	    transParams : trObj,
	    targetWindow : getCtpTop(),
	    buttons : [ {
	        text : $.i18n('form.forminputchoose.enter'),
	        id : "sure",
			isEmphasize: true,
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
};

/**
 * 展现无流程产能占用表单列表
 * @param obj 传人参数
 *        obj.callback 确定按钮回调函数
 */
function showUnflowFormList(obj) {
    var dialog = $.dialog({
        url:_ctxPath+"/form/formList.do?method=getUnflwoFormList4Effect",
        title:"占用产能表单列表",
        width : 1000,
        height : 550,
        id:"unflowFormList",
        targetWindow : getCtpTop(),
        buttons : [{
            text : $.i18n('form.forminputchoose.enter'),
            id : "sure",
			isEmphasize: true,
            handler : function() {
                dialog.close();
                if (obj && obj.callback) {
                    obj.callback();
                }
            }
        }],
        closeParam:{
            show:true,
            handler:function() {
                if (obj && obj.callback) {
                    obj.callback();
                }
            }
        }
    });
}

function showMsg4BizValidate(obj) {
    $.messageBox({
        'type' : 5,
        'imgType' : 1,
        'msg' : obj.msg,
        'detail_fn':function(){
            showUnflowFormList(obj);
        },
        ok_fn : function() {
            if (obj && obj.ok_fn) {
                obj.ok_fn();
            }
        },
        close_fn:function(){
            if (obj && obj.ok_fn) {
                obj.ok_fn();
            }
        }
    });
}

/**
 * 判断浏览器是否是支持h5的浏览器
 */
function isH5Brose(){
    var v3x = new V3X();
    return !(v3x.isMSIE7 || v3x.isMSIE8 || v3x.isMSIE9)
}