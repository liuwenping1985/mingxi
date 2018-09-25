var wfcontext= null;
/**
 * 移动端协同【确定】提交入口方法
 * 
 * @returns
 */
function submitFunc_Next_rest(_dataParam) {
	var preSubmitResult = preSubmit_wf_rest();
	var dataParamObj = JSON.parse(_dataParam);
	if (preSubmitResult) {
	  var formResult = getFormData(true);// 获取表单预提交数据+分支人员匹配
		var contentData = formResult["contentData"];// 表单数据
		var options = {
			"workflow_data":{"workitemId" : dataParamObj.subObjectId,
				"processTemplateId" : "",
				"processId" : dataParamObj.processId,
				"activityId" : dataParamObj.activityId,
				"performer" : dataParamObj.userId,
				"caseId" : dataParamObj.caseId,
				"currentAccountId" : "",
				"formData" : "",
				"appName" : "collaboration",
				"processXml" : "",
				"affairId" : dataParamObj.affairId
			},
			"contentData" : contentData,
			"contentType" : dataParamObj.contentType
		};
		submit_rest(options);
		return true;
	}else{
		if(dataParamObj.contentType=="20"){
			//TODO 删除缓存
			//deleteContentById();
		}
		return false;
	}
}

/**
 * 移动端协同【暂存待办】提交入口方法
 * 
 * @returns
 */

function zcdbFunc_rest(_dataParam) {
	var domains = [];
	$.content.getWorkflowDomains($("#moduleType").val(), domains);
	var formResult = getFormData(false);// 获取表单预提交数据+分支人员匹配
	if (formResult["result"] == "false") {
		return "false";
	} else {
		var contentData = formResult["contentData"];// 表单数据
		var dataParamObj = JSON.parse(_dataParam);
		var options = {
			"workflow_data":{"workitemId" : dataParamObj.subObjectId,
				"processTemplateId" : "",
				"processId" : dataParamObj.processId,
				"activityId" : dataParamObj.activityId,
				"performer" : dataParamObj.userId,
				"caseId" : dataParamObj.caseId,
				"currentAccountId" : "",
				"formData" : dataParamObj.masterId,
				"appName" : "collaboration",
				"processXml" : "",
				"affairId" : dataParamObj.affairId
			},
			"contentData" : contentData,
			"contentType" : dataParamObj.contentType
		};
		zcdb_rest(options);
	}
}

function zcdb_rest(options) {
	var domains = [];
	// 保存ISignaturehtml专业签章
	if (!saveISignature(1)) {
		enableOperation();
		setButtonCanUseReady();
		subCount = 0;
		try {
			hideMask();
		} catch (e) {
		}
		return;
	}
	// OFFICE正文中直接点修改按钮，不是“正文修改”菜单进去的，这种情况下会这种contentUpdate变量为true;
	if (contentUpdate) {
		$("#viewState").val("1");
	}
	if (nodePolicy == "bulletionaudit") {
		alert("不支持!");
		return;
	} else if (nodePolicy == "newsaudit") {
		alert("不支持!");
		return;
	} else {
		var _returnValue = $.content.getContentDealDomains(domains);
		if (_returnValue) {
			domains.push('colSummaryData');
			domains.push('trackDiv_detail');
			domains.push('superviseDiv');
			domains.push('workflow_definition');
			domains.push('attFileDomain');
			domains.push('assDocDomain');
			domains.push('attActionLogDomain');
			domains.push("_currentDiv");
			domains.push(getMainBodyDataDiv());
			//将表单内容数据提交到后台
			var contentDataArr = options.contentData;
			if(contentDataArr){
				for(var i=0;i<contentDataArr.length;i++){
					domains.push(contentDataArr[i]);
				}
			}
			var jsonSubmitCallBack = function() {
				// mergeMesPushFun($("#dealMsgPush"),
				// 		$('#comment_deal #pushMessageToMembers'),
				// 		$("#content_deal_comment"));
				var domainsObj = $("body").formobj({
					domains : domains
				});
				var domainsObjStr = $.toJSON(domainsObj);
				var workflowData= options.workflow_data;
				var workitemId = workflowData.workitemId;
				var processTemplateId = workflowData.processTemplateId;
				var processId = workflowData.processId;
				var activityId = workflowData.activityId;
				var performer = workflowData.performer;
				var caseId = workflowData.caseId;
				var currentAccountId = workflowData.currentAccountId;
				var formData = workflowData.formData;
				var appName = workflowData.appName;
				var processXml = workflowData.processXml;
				var affairId = workflowData.affairId;

				var context = new Object();
				context["appName"] = appName;
				context["processXml"] = processXml;
				context["processId"] = processId;
				context["caseId"] = caseId;
				context["currentActivityId"] = activityId;
				context["currentWorkitemId"] = workitemId;
				context["currentUserId"] = performer;
				context["currentAccountId"] = currentAccountId;
				context["formData"] = formData;
				context["mastrid"] = formData;
				context["debugMode"] = false;
				context["processTemplateId"] = processTemplateId;
				context["affairId"] = affairId;
				// viewState 查看模式 1 可编辑状态  2不可编辑状态 3 可编辑但没有JS事件状态 4 表单设计态
				var _viewState = "2";
				if(islightForm){
					_viewState = "1";
				}
				var obj= { "viewState": _viewState,"contentType":options.contentType,"context": JSON.stringify(context),"contentData": domainsObjStr} ;
				$.ajax({
					type : "POST",
					data : JSON.stringify({
						"_json_params" : obj
					}),
					url : '/seeyon/rest/collaboration/zcdb',
					async : false,
					headers : {
						"Accept" : "application/json; charset=utf-8",
						"Content-Type" : "application/json; charset=utf-8"
					},
					success : function(data) {
						var result = data.success;
						if(result == "false"){
							alert(data.errorMsg);
						}
					}
				});
			}

			var attitudeArray = document.getElementsByName("attitude");
			for (var i = 0; i < attitudeArray.length; i++) {
				if (attitudeArray[i].checked) {
					attitudeArray = attitudeArray[i].value;
					break;
				}
			}
			// V50_SP2_NC业务集成插件_001_表单开发高级
			// 表单相关的第三方系统的交换，协同事件的处理，在提交之前
			/*formDevelopAdance4ThirdParty(bodyType, affairId, attitudeArray, $(
					"#content_deal_comment").val(), null, jsonSubmitCallBack);*/

			jsonSubmitCallBack();
		}
	}
}


/**
 * 移动端协同【提交】提交入口方法
 * 
 * @returns
 */
function submitFunc_rest(_dataParam) {
	var domains = [];
	$.content.getWorkflowDomains($("#moduleType").val(), domains);
	var formResult = getFormData(true);// 获取表单预提交数据+分支人员匹配
	if (formResult["result"] == "false") {
		var temp_comment = $("#content_deal_comment").val();
		$("#content_deal_comment").val(temp_comment.substr(0,temp_comment.length-7));
		//alert(formResult["errorMsg"]);
		return;
	} else {
		var contentData = formResult["contentData"];// 表单数据
		var dataParamObj = JSON.parse(_dataParam);
		var options = {
			"workflow_data":{"workitemId" : dataParamObj.subObjectId,
				"processTemplateId" : "",
				"processId" : dataParamObj.processId,
				"activityId" : dataParamObj.activityId,
				"performer" : dataParamObj.userId,
				"caseId" : dataParamObj.caseId,
				"currentAccountId" : "",
				"formData" : dataParamObj.masterId,
				"appName" : "collaboration",
				"processXml" : "",
				"affairId" : dataParamObj.affairId
			},
			"contentData" : contentData,
			"contentType" : dataParamObj.contentType
		};
		//$.extend(false,_dataParam,JSON.stringify(options));
		var preSubmitResult = preSubmit_rest(options);
		// 提交处理
		if (preSubmitResult && preSubmitResult["result"] == "true" && preSubmitResult["isContinue"] ) {
			var result = submit_rest(options);
			return result;
		}else{
		  if(preSubmitResult && preSubmitResult["result"] == "false"){
		    if(dataParamObj.contentType=="20"){
          //TODO 删除缓存
          //deleteContentById();
        }
		    
		    var jsonObj= preSubmitResult["jsonObj"];
        if(jsonObj.errorMsg){
          alert(jsonObj.errorMsg);
        }
		  }
		}
	}
}

/**
 * 预提交数据
 */
function getFormData(checkNull, needCheckRule) {
	var retrunObj = new Object();
	retrunObj["result"] = "true";
	if ($("#contentType", getMainBodyDataDiv$()).val() == "20") {// 表单才预提交
		retrunObj["isForm"] = "true";
		return saveOrUpdate_rest({
			"mainbodyDomains" : null,
			"needSubmit" : true,
			"saveDB" : false,
			"checkNull" : checkNull,
			"needCheckRule" : needCheckRule,
			"needCheckRepeatData" : false
		});
	} else {
		retrunObj["isForm"] = "false";
	}
	return retrunObj;
}

/**
 * 表单数据
 * 
 * @param mainbodyArgs
 * @returns
 */
function saveOrUpdate_rest(mainbodyArgs) {
	var retrunObj = new Object();
	retrunObj["result"] = "true";
	if (_contentError == 2) {
		retrunObj["result"] = "false";
		retrunObj["errorMsg"] = "当前表单计算公式存在循环嵌套，不允许提交，请于管理员联系!";
		return retrunObj;
	}
	var contentDiv = getMainBodyDataDiv$();// 当前选项卡的DIV,多正文时区分当前正文
	var mainbodyDomains = mainbodyArgs.mainbodyDomains;// 传入的正文数据
	var needSubmit = mainbodyArgs.needSubmit == null ? true
			: mainbodyArgs.needSubmit;// 是否需要提交数据(有些业务模块正文不单独提交，随着业务整体入库)
	var saveDB = mainbodyArgs.saveDB == null ? true : mainbodyArgs.saveDB;// 提交后是否要保存数据到数据库
	var checkNull = mainbodyArgs.checkNull == null ? true
			: mainbodyArgs.checkNull;// 是否需要校验必填
	var needCheckRule = mainbodyArgs.needCheckRule == null ? true
			: mainbodyArgs.needCheckRule;// 是否需要校验表单业务规则
	var isCheckRepeatData = $.trim(mainbodyArgs.needCheckRepeatData) == "" ? true
			: mainbodyArgs.needCheckRepeatData;// 是否校验重复表存在重复数据
	if ($("#viewState", contentDiv).val() != "1") {
		return retrunObj;
	}// 不是可编辑状态直接返回

	var contentData = [];// 正文数据
	if (mainbodyDomains) {// 如果传入了正文数据，就使用传入的
		contentData = mainbodyDomains;
	}
	contentData.push("_currentDiv");
	contentData.push(getMainBodyDataDiv());
	var contentType = $("#contentType", contentDiv).val();// 正文类型
	if (contentType == 10) {// HTML正文
		var val = $.content.getContent();
		$("#content", contentDiv).val(val);
	} else if (contentType == 20) {// 表单正文
		var validateOpt = new Object();// 表单验证参数
		validateOpt['errorAlert'] = mainbodyArgs.errorAlert == null ? true
				: mainbodyArgs.errorAlert;
		validateOpt['errorBg'] = true;
		validateOpt['errorIcon'] = false;
		validateOpt['validateHidden'] = true;
		validateOpt['checkNull'] = checkNull;
		if (!getMainBodyHTMLDiv$().validate(validateOpt)) {// 验证失败调用 ，执行失败的回调函数
			retrunObj["result"] = "false";
			retrunObj["errorMsg"] = "data check failed!";
			return retrunObj;
		} else if (isCheckRepeatData
				&& isLegalDataOfRepeatingTable(getMainBodyHTMLDiv$())) {
			// 判断重复表中是否存在相同的数据行
			var confirm = $.confirm({
				'msg' : $.i18n('form.repeatdata.same.error.label'),
				ok_fn : function() {
					// 验证通过，组装表单数据到正文数据中
					if (checkNull && !checkHW(getMainBodyHTMLDiv$())) {
						retrunObj["result"] = "false";
						retrunObj["errorMsg"] = "data check failed!";
						return retrunObj;
					}
					for (var i = 0; i < form.tableList.length; i++) {
						var tempTable = $("#" + form.tableList[i].tableName);
						if (tempTable.length > 0) {
							contentData.push(form.tableList[i].tableName);
						}
					}
					if ((typeof (saveHwData) == "function") && !saveHwData()) {// 保存签章单元格
						retrunObj["result"] = "false";
						retrunObj["errorMsg"] = "saveHwData failed!";
						return retrunObj;
					}
					if (needSubmit) {// 是否需要提交数据
						retrunObj["contentData"] = contentData;
						return retrunObj;
					} else {// 不保存数据库
						return retrunObj;
					}
				},
				cancel_fn : function() {
					// 调用错误回调函数，关闭进度条
					confirm.close();
					retrunObj["result"] = "false";
					retrunObj["errorMsg"] = "data check failed!";
					return retrunObj;
				},
				close_fn : function() {
					// 调用错误回调函数，关闭进度条
					confirm.close();
					retrunObj["result"] = "false";
					retrunObj["errorMsg"] = "data check failed!";
					return retrunObj;
				}
			});
		} else {
			// 验证通过，组装表单数据到正文数据中
			if (checkNull && !checkHW(getMainBodyHTMLDiv$())) {
				retrunObj["result"] = "false";
				retrunObj["errorMsg"] = "data check failed!";
				return retrunObj;
			}
			for (var i = 0; i < form.tableList.length; i++) {
				var tempTable = $("#" + form.tableList[i].tableName);
				if (tempTable.length > 0) {
					contentData.push(form.tableList[i].tableName);
				}
			}
			if ((typeof (saveHwData) == "function") && !saveHwData()) {// 保存签章单元格
				retrunObj["result"] = "false";
				retrunObj["errorMsg"] = "saveHwData failed!";
				return retrunObj;
			}
			if (needSubmit) {// 是否需要提交数据
				retrunObj["contentData"] = contentData;
				return retrunObj;
			} else {// 不保存数据库
				return retrunObj;
			}
		}

	} else if (contentType > 40 && contentType < 50) {// OFFICE正文
		if (contentType == 45) {
			if (!savePdf()) { // 保存pdf文件
				retrunObj["result"] = "false";
				retrunObj["errorMsg"] = "saveOffice failed!";
				return retrunObj;
			}
		} else if (!saveOffice()) {// 保存OFFICE文件
			retrunObj["result"] = "false";
			retrunObj["errorMsg"] = "saveOffice failed!";
			return retrunObj;
		}
	}
	// 表单的单独在上面逻辑中处理，因为考虑到confirm组件是异步的，所以把这点逻辑提到表单逻辑分支里
	if (contentType != 20) {
		if (needSubmit) {// 是否需要提交数据
			retrunObj["contentData"] = contentData;
			return retrunObj;
		} else {// 不保存数据库
			return retrunObj;
		}
	}
}

/**
 * 提交协同
 * 
 * @param contentData
 * @returns
 */
function submit_rest(options) {
	var domains = [];
	var result;
	// 保存ISignaturehtml专业签章
	if (!saveISignature(1)) {
		enableOperation();
		setButtonCanUseReady();
		subCount = 0;
		try {
			hideMask();
		} catch (e) {
		}
		return;
	}
	// OFFICE正文中直接点修改按钮，不是“正文修改”菜单进去的，这种情况下会这种contentUpdate变量为true;
	if (contentUpdate) {
		$("#viewState").val("1");
	}
	if (nodePolicy == "bulletionaudit") {
		alert("不支持!");
		return;
	} else if (nodePolicy == "newsaudit") {
		alert("不支持!");
		return;
	} else {
		var _returnValue = $.content.getContentDealDomains(domains);
		if (_returnValue) {
			domains.push('colSummaryData');
			domains.push('trackDiv_detail');
			domains.push('superviseDiv');
			domains.push('workflow_definition');
			domains.push('attFileDomain');
			domains.push('assDocDomain');
			domains.push('attActionLogDomain');
			domains.push("_currentDiv");
			domains.push(getMainBodyDataDiv());

			var jsonSubmitCallBack = function() {
				// mergeMesPushFun($("#dealMsgPush"),
				// 		$('#comment_deal #pushMessageToMembers'),
				// 		$("#content_deal_comment"));
				var domainsObj = $("body").formobj({
					domains : domains
				});
				var domainsObjStr = $.toJSON(domainsObj);
				var workflowData= options.workflow_data;
				var workitemId = workflowData.workitemId;
				var processTemplateId = workflowData.processTemplateId;
				var processId = workflowData.processId;
				var activityId = workflowData.activityId;
				var performer = workflowData.performer;
				var caseId = workflowData.caseId;
				var currentAccountId = workflowData.currentAccountId;
				var formData = workflowData.formData;
				var appName = workflowData.appName;
				var processXml = workflowData.processXml;
				var affairId = workflowData.affairId;

				var context = new Object();
				context["appName"] = appName;
				context["processXml"] = processXml;
				context["processId"] = processId;
				context["caseId"] = caseId;
				context["currentActivityId"] = activityId;
				context["currentWorkitemId"] = workitemId;
				context["currentUserId"] = performer;
				context["currentAccountId"] = currentAccountId;
				context["formData"] = formData;
				context["mastrid"] = formData;
				context["debugMode"] = false;
				context["processTemplateId"] = processTemplateId;
				context["affairId"] = affairId;
				// viewState 查看模式 1 可编辑状态  2不可编辑状态 3 可编辑但没有JS事件状态 4 表单设计态
				var obj= { "viewState": "2","contentType":options.contentType,"context": JSON.stringify(context),"contentData": domainsObjStr} ;
				$.ajax({
					type : "POST",
					data : JSON.stringify({
						"_json_params" : obj
					}),
					url : '/seeyon/rest/collaboration/submit',
					async : false,
					headers : {
						"Accept" : "application/json; charset=utf-8",
						"Content-Type" : "application/json; charset=utf-8"
					},
					success : function(data) {
						result = "success";
						// TODO
					}
				});
			}

			var attitudeArray = document.getElementsByName("attitude");
			for (var i = 0; i < attitudeArray.length; i++) {
				if (attitudeArray[i].checked) {
					attitudeArray = attitudeArray[i].value;
					break;
				}
			}
			// V50_SP2_NC业务集成插件_001_表单开发高级
			// 表单相关的第三方系统的交换，协同事件的处理，在提交之前
			/*formDevelopAdance4ThirdParty(bodyType, affairId, attitudeArray, $(
					"#content_deal_comment").val(), null, jsonSubmitCallBack);*/

			jsonSubmitCallBack();
		}
	}
	return result;
}

/**
 * 预提交
 */
function preSubmit_rest(options) {
	var preSubmitResult= new Object();
	preSubmitResult["result"]="true";
	
	var workflowData= options.workflow_data;
	var workitemId = workflowData.workitemId;
	var processTemplateId = workflowData.processTemplateId;
	var processId = workflowData.processId;
	var activityId = workflowData.activityId;
	var performer = workflowData.performer;
	var caseId = workflowData.caseId;
	var currentAccountId = workflowData.currentAccountId;
	var formData = workflowData.formData;
	var appName = workflowData.appName;
	var processXml = workflowData.processXml;
	var affairId = workflowData.affairId;
	var vWindow = options.vWindow;
	var contentData= options.contentData;
	var contentType = options.contentType;

	var context = new Object();
	context["appName"] = appName;
	context["processXml"] = processXml;
	context["processId"] = processId;
	context["caseId"] = caseId;
	context["currentActivityId"] = activityId;
	context["currentWorkitemId"] = workitemId;
	context["currentUserId"] = performer;
	context["currentAccountId"] = currentAccountId;
	context["formData"] = formData;
	context["mastrid"] = formData;
	context["debugMode"] = false;
	context["processTemplateId"] = processTemplateId;
	context["affairId"] = affairId;
	context["contentType"] = contentType;
	
  var cpMatchResult1= new Object();
  var allNotSelectNodes_I= new Array();
  var allSelectNodes_I= new Array();
  var allSelectInformNodes_I= new Array();
  cpMatchResult1["allNotSelectNodes"]= allNotSelectNodes_I;
  cpMatchResult1["allSelectNodes"]= allSelectNodes_I;
  cpMatchResult1["allSelectInformNodes"]= allSelectInformNodes_I;
  cpMatchResult1["pop"]= false;
  cpMatchResult1["token"]= "";
  cpMatchResult1["last"]= "false";
  cpMatchResult1["alreadyChecked"]= "false";
	
	// 提交数据
	var url = '/seeyon/rest/collaboration/presubmit';
	var domains = [];
	var _returnValue = $.content.getContentDealDomains(domains);
  if (_returnValue) {
    domains.push('colSummaryData');
    domains.push('trackDiv_detail');
    domains.push('superviseDiv');
    domains.push('workflow_definition');
    domains.push('attFileDomain');
    domains.push('assDocDomain');
    domains.push('attActionLogDomain');
    domains.push("_currentDiv");
    domains.push(getMainBodyDataDiv());
	//将表单内容数据提交到后台
	var contentDataArr = options.contentData;
	if(contentDataArr){
		for(var i=0;i<contentDataArr.length;i++){
			domains.push(contentDataArr[i]);
		}
	}
  }
  var domainsObj = $("body").formobj({
    domains : domains
  });
	var domainsObjStr = $.toJSON(domainsObj);
	var obj= { "context": JSON.stringify(context) , "cpMatchResult" : JSON.stringify(cpMatchResult1),"step":"0","contentData": domainsObjStr} ;
	
	$.ajax({
		type : "POST",
		data : JSON.stringify({
			"_json_params" : obj
		}),
		url : url,
		async : false,
		headers : {
			"Accept" : "application/json; charset=utf-8",
			"Content-Type" : "application/json; charset=utf-8"
		},
		success : function(jsonObj) {
			var ok = handleSuccess_rest(jsonObj);
			if (!ok) {
				preSubmitResult["result"] = "false";
			}else{
			  preSubmitResult["result"] = jsonObj.success;
			}
			preSubmitResult["jsonObj"] = jsonObj;
			currentAccountID = jsonObj.accountId;
		}
	});
	if(preSubmitResult["result"]=="false"){
		return preSubmitResult;
	}else{
		var jsonObj = preSubmitResult["jsonObj"];
		var cpMatchResult = jsonObj["cpMatchResult"];
		var isPop = cpMatchResult["pop"];
		preSubmitResult["isContinue"]= true;
		if (isPop) {
			wfcontext= context;
			preSubmitResult = doWorkflowPop_mobile(context,cpMatchResult);
			preSubmitResult["result"] = "false";
			preSubmitResult["isContinue"] = false;
		} else {
			doWorkflowValue_mobile(cpMatchResult);
			preSubmitResult["result"] = "true";
		}
	}
	return preSubmitResult;
}

/**
 * 正文提交成功提示
 * 
 * @param jsonObj
 * @returns
 */
function handleSuccess_rest(returnObj) {
	if(returnObj.isForm=="false"){//非表单
			return true;
	}
	try {
		if (returnObj.success == "true") {// 返回值证明是操作成功
			if (returnObj.sn != null) {// 如果产生了流水号需要给出提示
				var snMsg = "";
				var snObj = returnObj.sn;
				for ( var snField in snObj) {
					snMsg += "已在{" + snField + "}项上生成流水号:" + snObj[snField]
							+ "\n";
				}
				alert(snMsg);
			}
			return true;
		} else { // 返回值证明操作失败，解析错误信息
			var errorMessage = "";
			try {
				errorMessage = $.parseJSON(returnObj.errorMsg);
				if (errorMessage.ruleError) {
					alert(errorMessage.ruleError);
					var fields = errorMessage.fields;
					for (var i = 0; i < fields.length; i++) {
						changeValidateColor(fields[i]);
					}
				}
			} catch (e) {
				errorMessage = returnObj.errorMsg;
				alert(errorMessage);
			}
			return false;
		}
	} catch (e) {
		alert("error:" + e);
		return false;
	}
}

//保存 ISiginature HTML 专业签章
function saveISignature(){
    try{
        var bodyTypeStr = $("#bodyType").val();
        var flag = true;
        if(bodyTypeStr == '10' || bodyTypeStr == '20'){
        	flag = saveISignatureHtml();
        }
        return flag;
    }catch(e){
        return false;
    }
    return true;
}

/**
 * @param $delMesPush 意见栏a的人员
 * @param $oldMesPush 原来的消息推送功能放的文本域
 * @param $textArea   意见框
 * @return
 */
function mergeMesPushFun($delMesPush,$oldMesPush,$textArea){
	//alert($delMesPush.val()+"**"+$oldMesPush.val()+"**"+$textArea.val());
	//$delMesPush 转换成数组
	var d1 = $delMesPush.val();
	if(d1 && d1 != '') {
		d1 = $.parseJSON(d1);
	}
	
	var d2 = $oldMesPush.val();
	if(d2 && d2 != ''){
		d2 = $.parseJSON(d2);
	}
	
	var val = $textArea.val();
	 
	var all =[];
	if(d2.length > 0){
		all = d2;
	}
	
	if(d1.length > 0){
		for(var i =0; i < d1.length; i++){
			var v=[];
			if($textArea.val().indexOf(d1[i][2]) > -1){
				v.push(d1[i][0]);
				v.push(d1[i][1]);
				all.push(v);
			}
		}
	}
	$oldMesPush.val($.toJSON(all));
}
