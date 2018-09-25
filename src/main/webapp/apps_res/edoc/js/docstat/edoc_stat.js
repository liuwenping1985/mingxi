var layout;
$(document).ready(function () {
	layout = $('#layout').layout();
	loadClick();
	setStartTimeLabel();
	setDefaultValueWhenIsNull();
	setGridHeight();
	executeStatistics();//页面加载成功后初始化统计
 });

var sendTypeDialog;
var unitLevelDialog;
function loadClick() {
	$("#rangeNames").click(function() {
		openPersonDialog($("#rangeIds").val(), $("#rangeNames"), $("#rangeIds"));
	});
	$("#templateName").click(function(){
		var modelType = $("#edocType").children("option[selected]").attr("modelType");
    	templateChoose(templateChooseCallback, modelType, true,"","MaxScope","",null);
   });
	$("#edocType").change(function() {
		setStartTimeLabel();
	});
	$("#unitLevelName").click(function() {
		unitLevelDialog = $.dialog({
	        url: edocStatUrl + "?method=openUnitLevelDialog&enumitemIds="+$("#unitLevelId").val(),
	        width: 300,
	        height: 350,
	        title: $.i18n("edoc.stat.condition.unitLevel.dialogTitle"),
	        id:'unitLevelDialog',
	        targetWindow:getCtpTop(),
	        transParams: {'parentWin':window},
	        closeParam: {
	        	'show':true,
	        	autoClose:false,
	        	handler:function() {
	        		if(unitLevelDialog) {
	        			unitLevelDialog.close();
	        		}
	        	}
	        },
	        buttons: [{
	            id : "okButton",
	            text: $.i18n("common.button.ok.label"),
	            handler: function () {
	            	var returnObj = unitLevelDialog.getReturnValue();
	            	$("#unitLevelName").val(returnObj.enumitemLabels);
	            	$("#unitLevelId").val(returnObj.enumitemIds);
	            	if(returnObj.enumitemLabels != "") {
	            		$("#unitLevelName").removeClass("color_gray");
	            	}
	            	unitLevelDialog.close();
	            }
	        }, {
	            id:"cancelButton",
	            text: $.i18n("common.button.cancel.label"),
	            handler: function () {
	            	unitLevelDialog.close();
	            }
	        }]
	    });
	});
	$("#sendTypeName").click(function() {
		sendTypeDialog = $.dialog({
	        url: edocStatUrl + "?method=openSendTypeDialog&enumitemIds="+$("#sendTypeId").val(),
	        width: 300,
	        height: 350,
	        title: $.i18n("edoc.stat.condition.docType.dialogTitle"),
	        id:'sendTypeDialog',
	        targetWindow:getCtpTop(),
	        transParams: {'parentWin':window},
	        closeParam: {
	        	'show':true,
	        	autoClose:false,
	        	handler:function() {
	        		if(sendTypeDialog) {
	        			sendTypeDialog.close();
	        		}
	        	}
	        },
	        buttons: [{
	            id : "okButton",
	            text: $.i18n("common.button.ok.label"),
	            handler: function () {
	            	var returnObj = sendTypeDialog.getReturnValue();
	            	$("#sendTypeName").val(returnObj.enumitemLabels);
	            	$("#sendTypeId").val(returnObj.enumitemIds);
	            	if(returnObj.enumitemLabels != "") {
	            		$("#sendTypeName").removeClass("color_gray");
	            	}
	            	sendTypeDialog.close();
	            }
	        }, {
	            id:"cancelButton",
	            text: $.i18n("common.button.cancel.label"),
	            handler: function () {
	            	sendTypeDialog.close();
	            }
	        }]
	    });
	});
} 

function setStartTimeLabel() {
	var edocType = $("#edocType").val();
	if(edocType == 1) {
		$("#startTimeLabel").html(startTimeLabel_1);
		$("#startTimeLabel").attr("rangeTimeLabelTitle", startTimeTitleLabel_1);
	} else {
		$("#startTimeLabel").html(startTimeLabel_0);
		$("#startTimeLabel").attr("rangeTimeLabelTitle", startTimeTitleLabel_0);
	}
}

function setDefaultValueWhenIsNull() {
	new inputChange($("#rangeNames"), $("#rangeNames").attr("defaultValue"));
	new inputChange($("#unitLevelName"), $("#unitLevelName").attr("defaultValue"));
	new inputChange($("#templateName"), $("#templateName").attr("defaultValue"));
	new inputChange($("#sendTypeName"), $("#sendTypeName").attr("defaultValue"));
}

function templateChooseCallback(ids,names){
	if(names && names!="") {
		$("#templateName").removeClass("color_gray");
	}
	$("#templateName").val(names);
	$("#operationTypeIds").val(ids);
}

function openPersonDialog(selectMembers, memberNameObj, memberIdObj) {
	var selectTypes = "Department,Member";
	if(isAccountExchange) {
		selectTypes = "Account,Department,Member";
	}
	var options = {
		onlyLoginAccount:true,
		showRecent:false,
        type:'selectPeople',
        panels:"Department",
        minSize : 1,
        selectType:selectTypes,
        text:$.i18n('common.default.selectPeople.value'),
        hiddenPostOfDepartment:true,
        hiddenRoleOfDepartment:true,
        excludeChildDepartment:false,
        showFlowTypeRadio:false,
        returnValueNeedType: true,
        isConfirmExcludeSubDepartment:true,
        params:{
           value: selectMembers
        },
        targetWindow:window.top,
        callback : function(res) {
            if(res && res.obj) {
            	var selPeopleId = "";
            	var selPeopleId_child = "";
            	var selPeopleName_child = "";
            	var selPeopleName = "";
            	if(res.obj.length>0) {
            		var noRoleDeptName = "";
            		for(var i=0; i<res.obj.length; i++) {
            			if(!isAccountExchange && res.obj[i].type=="Department" 
            				&& allDeptIds!="" && allDeptIds.indexOf(res.obj[i].id+",")<0) {
            				noRoleDeptName += res.obj[i].name + "、";
            			} else {
            				selPeopleId_child += res.obj[i].type+"|"+res.obj[i].id;
            				if(res.obj[i].excludeChildDepartment) {
            					selPeopleId_child += "|1";
            				}
            				selPeopleId_child += ",";
            				selPeopleName_child += res.obj[i].name + "、";
                    	}
            		}
            		if(noRoleDeptName != "") {
            			noRoleDeptName = noRoleDeptName.substring(0, noRoleDeptName.length-1);
            			alert("您无权统计部门："+noRoleDeptName+"，请重新选择！");
            		}
            		if(selPeopleId_child != "") {
            			selPeopleId_child = selPeopleId_child.substring(0, selPeopleId_child.length-1);
            		}
            		if(selPeopleName_child != "") {
            			selPeopleName_child = selPeopleName_child.substring(0, selPeopleName_child.length-1);
            		}
            		selPeopleId = selPeopleId_child;
                	selPeopleName = selPeopleName_child;
            		//selPeopleId = res.value;
                	//selPeopleName = res.text;
                	memberNameObj.removeClass("color_gray");
            	}
            	if(memberNameObj)
            		memberNameObj.val(selPeopleName);
            	if(memberIdObj)
            		memberIdObj.val(selPeopleId);
            	selectMembers = selPeopleId;
            }
        }
	};
	options.isNeedCheckLevelScope = false;
	if(isAccountExchange==false && isDeptExchange) {
		options.showDepartmentsOfTree = currentDeptIds;
	}
	$.selectPeople(options);
}

function fnGetParams () {
	var obj = new Object();
	var edocType = $("#edocType").val();
	obj.edocType = edocType;
	obj.startRangeTime = $("#startRangeTime").val();
	obj.endRangeTime = $("#endRangeTime").val();
	obj.rangeIds = $("#rangeIds").val();
	obj.displayType = $("input[name='displayType']:checked").val();
	obj.displayTimeType = $("#displayTimeType").val();
	obj.operationTypeIds = $("#operationTypeIds").val();
	obj.sendTypeId  = $("#sendTypeId").val();
	obj.unitLevelId  = $("#unitLevelId").val();
	$("#operationType").val("");
	if($("#workflowByPersonal").attr("checked")=="checked" || $("#workflowBySystem").attr("checked")=="checked") {
		if($("#workflowByPersonal").attr("checked")=="checked" && $("#workflowBySystem").attr("checked")!="checked") {
			$("#operationType").val($("#workflowByPersonal").val());
		} else if($("#workflowByPersonal").attr("checked")!="checked" && $("#workflowBySystem").attr("checked")=="checked") {
			$("#operationType").val($("#workflowBySystem").val());
		} else {
			$("#operationType").val($("#workflowByPersonal").val()+","+$("#workflowBySystem").val());
		}
	}
	obj.operationType = $("#operationType").val();
	return obj;
}

function executeStatistics() {
	if(!checkRangeTime()) {
		return;
	}
	if($("#rangeNames").val() == "" || $("#rangeNames").val()==$("#rangeNames").attr("defaultValue")) {
		$.alert($.i18n("edoc.stat.condition.range.isnull"));
		return;
	}
	if($("#workflowByPersonal").attr("checked")!="checked" && $("#workflowBySystem").attr("checked")!="checked") {
		$.alert($.i18n("edoc.stat.condition.workflow.isnull"));
		return;
	}
	$("#resultFrame").attr("src", edocStatUrl+"?method=edocStatResult&edocType="+$("#edocType").val());
}

function resetResult() {
	$("#startRangeTime").val(startRangeTime);
	$("#endRangeTime").val(endRangeTime);
	$("#edocType").val("1");
	$("#rangeNames").val(defaultRangeNames);
	$("#rangeIds").val(defaultRangeIds);
	$("input[name='displayType']").eq(0).attr("checked", true);//重置后默认部门被选中
	$("#displayTimeType").val("1");//重置后默认年被选中
	$("#unitLevelName").val("");
	$("#unitLevelId").val("");
	$("#sendTypeName").val($("#sendTypeName").attr("defaultValue")).addClass("color_gray");
	$("#sendTypeId").val("");
	$("#unitLevelName").val($("#unitLevelName").attr("defaultValue")).addClass("color_gray");
	$("#displayTimeType").val("1");
	$("#workflowByPersonal").attr("checked", "checked");
	$("#workflowBySystem").attr("checked", "checked");
	$("#templateName").val($("#templateName").attr("defaultValue")).addClass("color_gray");
	$("#operationTypeIds").val("");
	$("#operationType").val("");
	if(typeof(templateOrginalData)!='undefined' && templateOrginalData != null ){ 
  	  templateOrginalData["ids"] = "";
  	  templateOrginalData["names"] = "";
    }
}

function setGridHeight() {
	 $(".bDiv").css("height", $("#tabs").height() - 35);
 }

//检查督办时间设置
function checkAwakeDate() {
	/*if(!checkRangeTime()) {
		return;
	}*/
}

function checkRangeTime() {
	var startRangeTime = $("#startRangeTime").val();
	var endRangeTime = $("#endRangeTime").val();
	if(startRangeTime == "" || endRangeTime=="") {
		$.alert($.i18n("edoc.stat.condition.rangeTime.isnull", $("#startTimeLabel").attr("rangeTimeLabelTitle")));
		return false;
	}
	if(startRangeTime > endRangeTime) {
		$("#startRangeTime").val($("#startRangeTime").attr("lastTime"));
		$("#endRangeTime").val($("#endRangeTime").attr("lastTime"));
		$.alert($.i18n("edoc.stat.condition.rangeTime.startGtend"));
		return false;
	}
	var displayType = $("input[name='displayType']:checked").val();
	//if(displayType == "3") {//按时间统计
		var displayTimeType = $("#displayTimeType").val();
		//if(displayTimeType == "4") {//按日统计
			var isMoreOneYear = false;
			var startY = parseInt(startRangeTime.split("-")[0], 10);
			var endY = parseInt(endRangeTime.split("-")[0], 10);
			if(endY - startY > 1) {
				isMoreOneYear = true;
			} else if(endY - startY == 1) {
				var startM = parseInt(startRangeTime.split("-")[1], 10);
				var endM = parseInt(endRangeTime.split("-")[1], 10);
				if(endM > startM) {
					isMoreOneYear = true;
				} else if(endM == startM) {
					var startD = parseInt(startRangeTime.split("-")[2], 10);
					var endD = parseInt(endRangeTime.split("-")[2], 10);
					if(endD > startD) {
						isMoreOneYear = true;
					}
				}
			}
			if(displayType=="3" && displayTimeType=="1") {
				isMoreOneYear = false;
			}
			if(isMoreOneYear == true) {
				$("#startRangeTime").val($("#startRangeTime").attr("lastTime"));
				$("#endRangeTime").val($("#endRangeTime").attr("lastTime"));
				$.alert($.i18n("edoc.stat.condition.rangeTime.moreOneYear"));
				return false;
			}			
		//}
	//}
	$("#startRangeTime").attr("lastTime", $("#startRangeTime").val());
	$("#endRangeTime").attr("lastTime", $("#endRangeTime").val());
	return true;
}


/**
 * 弹出框, 这个方法可以的话可以升级成组件
 * @param config = {title:dialog的标题，callbackFn:点确认后回调方法，msg:input上的提示语句，initValue:初始化值}
 */
function doPrompt(config){
    
    var title = config.title || " ";
    var callbackFn = config.callbackFn;
    var msg = config.msg;
    var initValue = config.initValue;
    
    var promptPageParams = {
            initValue : initValue,
            msg : msg
    }
    
    var prompWin = $.dialog({
        
        url: _ctxPath + '/edocController.do?method=showPromptPage',
        width: 360,
        height: 148,
        title: title,//
        transParams : promptPageParams,
        targetWindow:getCtpTop(),
        closeParam:{
            'show':true,
            autoClose:false,
            handler:function(){
                prompWin.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            handler: function () {
                if(callbackFn){
                    var retValue = prompWin.getReturnValue();
                    callbackFn(retValue);
                }else{
                    prompWin.close();
                }
            }
         }, {
             id:"cancelButton",
             text: $.i18n("common.button.cancel.label"),
             handler: function () {
                 prompWin.close();
             }
        }]
    }); 
    
    return prompWin;
}

//推送首页
function pushStatResult() {
    
    var promptObj = doPrompt({
        title : $.i18n('common.search.PushHome.label'),// 推送首页
        callbackFn : function(value){
            
            if(value == ""){//提示名称为空
                $.alert($.i18n("edoc.alert.fillPushName"));//请输入推送名称
                return;
            }
            
            if(value.length > 85){//标题最长85
                $.alert($.i18n("edoc.alert.pushNameMaxSize", 85));//推送名称最大长度为85
                return;
            }
            
            promptObj.close();
            
            
            $("#statTitle").val(value);
            var domains = [];
            domains.push('statConditionForm');
            var url = edocStatUrl + "?method=pushStatResult";
            $("#statConditionForm").jsonSubmit({
                domains : domains,
                debug : false,
                action : url,
                callback: function(data){
                    //alert(data);
                    $.infor($.i18n('edoc.push.success'));//推送成功!
                }
            });
        },
        msg : $.i18n('edoc.confirm.regiester.push', $.i18n("edoc.stat.label")),//您确认推送以下内容至首页空间的公文统计栏目吗？
        initValue : $.i18n("edoc.stat.result.title", $("#startRangeTime").val(), $("#endRangeTime").val())//默认推送标题
    });
}

//导出Excel
function fnDownExcel() {
	$("#resultFrame")[0].contentWindow.statResultToExcel(); 
}

//打印
function printColl() {
	$("#resultFrame")[0].contentWindow.printStatResult(); 
}
function cleaTtemplate(){
	$("#templateName").val("请点击选择").addClass("color_gray");
	$("#operationTypeIds").val("");
	$("#operationType").val("");
	templateOrginalData = null;
}
