<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
var oldEnableNodeArray = [];
var oldUnableNodeArray = [];
var selectedType = "";
var newNode = {};
var allData = {head:${head},body:[]};
//保存外部单位标记，key是外部单位id，value是true
var outFlagMap = ${outFlagMap};
$(function(){
	$("#selectRedPeople").click(selectRedPeopleFunction);
	$("#btnsearch").click(showResultFunction);
	$("#selectDelRedPeople").click(selectDelRedPeopleFunction);
	$("#btnreset").click(resetFunction);
	controlDisableBtn(false);
	$("#toExcelBtn").click(function(){
		if(allData.body==null || allData.body.length==0){
			$.alert("${ctp:i18n('workflow.replaceNode.20')}!");
			return;
		}
		var form = $("#downLoadForm");
		var action = form.attr("action");
		form.attr("action", "${path}/workflow/replace.do");
		form.find("#data").val($.toJSON(allData));
		form.find("#searchText").val(getOldNodeArrayText());
		form.submit();
		form = null;
		//$("#downLoadIframe").attr("src", "${path}/workflow/replace.do?method=toExcelDownload");
	});
	
	//默认查询一下，显示表头
	showListTitleFunction();
	
	//初始化数据
	var parentDialog = window.parentDialogObj["templateReplaceNode"]; 
    if(parentDialog){
       var initParam = parentDialog.transParams;
       if(initParam){
           var type, datas;
           type = initParam.initType;
           datas = initParam.initData;
           if(type == "DelRed" && datas){
               var jsonDatas = $.parseJSON(datas);
               if(jsonDatas.length>0){
                   _handDelRedSelect(jsonDatas);
                   showResultFunction();
               }
           }
       }
    }
    
});
function getOldNodeArray(){
	var result = [].concat(oldEnableNodeArray, oldUnableNodeArray);
	if(result.length==1){
		selectedType = result[0].eleType;
		if(result[0].eleType == 'Department'){
			if(outFlagMap[result[0].eleId]==true){
				selectedType = 'Outworker';
			}
		}
	}
	return result;
}
function isCanReplace(){
	var result = getOldNodeArray();
	var canReplace = false;
	if(result.length==1 && allData.body && allData.body.length>0){
		if(result[0].eleType == 'Department'){
			if(outFlagMap[result[0].eleId]==true){
				selectedType = 'Outworker';
			}
		}
		canReplace = true;
	}else{
		canReplace = false;
	}
	result = null;
	return canReplace;
}
function getOldNodeArrayText(){
	var enables = oldEnableNodeArray;
	var nuables = oldUnableNodeArray;
	if(enables.length>0 || nuables.length>0){
		var text = [];
		for(var i=0,len=enables.length; i<len; i++){
			text.push(enables[i].eleName);
		}
		for(var i=0,len=nuables.length; i<len; i++){
			text.push(nuables[i].eleName+"(${ctp:i18n('workflow.replaceNode.21')})");
		}
		return text.join("、");
	}
	return "";
}
function resetFunction(){
	$("#replacedArea").val("<${ctp:i18n('workflow.replaceNode.22')}!>");
    oldEnableNodeArray.length = 0;
    oldUnableNodeArray.length = 0;
	resetOtherFunction();
}
function resetOtherFunction(){
	$("#replaceArea").val("<${ctp:i18n('workflow.replaceNode.08')}>");
	$("#btnreplace").removeClass("common_button_disable");
	$("#resultListArea").html('<table id="resultList" class="flexme3" style="display: none;"></table>');
//	$("#resultTitle").css("display","none");
//	$("#resultListArea").css("display","none");
    if(allData.body){
        allData.body.length = 0;
    }
    newNode = {};
    selectedType = "";
    controlDisableBtn(false);
    showListTitleFunction();
}
function controlDisableBtn(flag){
    var replaceBtn = $("#btnreplace");
    var selectRePeopleBtn = $("#selectRePeople");
    if("${canReplace}"=="true"){
	    if(flag){
	    	replaceBtn.removeClass("common_button_disable");
	    	selectRePeopleBtn.removeClass("opacity_20");
			replaceBtn.unbind("click").click(replaceFunction);
			selectRePeopleBtn.unbind("click").click(selectRePeopleFunction);
	    }else{
	    	if(!replaceBtn.hasClass("common_button_disable")){
	    		replaceBtn.addClass("common_button_disable");
	    	}
	    	if(!selectRePeopleBtn.hasClass("opacity_20")){
		    	selectRePeopleBtn.addClass("opacity_20");
	    	}
			replaceBtn.unbind("click");
			selectRePeopleBtn.unbind("click");
		}
    }else{
    	if(!replaceBtn.hasClass("common_button_disable")){
    		replaceBtn.addClass("common_button_disable");
    	}
    	if(!selectRePeopleBtn.hasClass("opacity_20")){
	    	selectRePeopleBtn.addClass("opacity_20");
    	}
		replaceBtn.unbind("click");
		selectRePeopleBtn.unbind("click");
    }
	replaceBtn = selectRePeopleBtn = null;
}
function render(text, row, rowIndex, colIndex,col){
	return text;
}
function selectDelRedPeopleFunction(){
    var tempDialog = $.dialog({
            id : "findDeleteNodePeople",
            url : _ctxPath+'/workflow/replace.do?method=enabledPeople',
            width : 470,
            height : 300,
            title : "${ctp:i18n('workflow.replaceNode.24')}",
            minParam:{show:false},
            maxParam:{show:false},
            transParams:{
                allSize : (10-oldUnableNodeArray.length)
            },
            close_fn:function(){
            },
            targetWindow: getCtpTop()
            ,buttons:[ {
                  isEmphasize:true,
                  text : $.i18n('workflow.designer.page.button.ok'),
                  handler : function() {
                    var result = tempDialog.getReturnValue();
                    if(result!=null){
                        var peopleArray = $.parseJSON(result);
                        if(peopleArray!=null && peopleArray.length>0){
                            _handDelRedSelect(peopleArray);
                            tempDialog.close();
                        }
                    }
                  }
                }, {
                  text : $.i18n('workflow.designer.page.button.cancel'),
                  handler : function() {
                    tempDialog.close();
                  }
                }
            ]
        });
}

/**
 * 处理选择无效节点数据
 */
function _handDelRedSelect(peopleArray){
    resetOtherFunction();
    oldEnableNodeArray.length=0;
//  oldUnableNodeArray.length=0;
    //使用一个map保存现有的停用人员。
    var temp = {};
    for(var i=0, len=oldUnableNodeArray.length; i<len; i++){
        temp[oldUnableNodeArray[i].eleId] = oldUnableNodeArray[i];
    }
    for(var i=0, len=peopleArray.length; i<len; i++){
        if(temp[peopleArray[i].id]==null){//重复的人员就不再放进去
            var temp = {};
            temp.eleId = (peopleArray[i].id);
            temp.eleName = (peopleArray[i].name);
            temp.eleType = (peopleArray[i].type);
            temp.accountId = (peopleArray[i].accountId);
            temp.accountShortName = (peopleArray[i].accountShortname);
            oldUnableNodeArray.push(temp);
        }
    }
    var text = getOldNodeArrayText();
    $("#replacedArea").val(text).parent().attr("title", text);
    hasSelectedPeople= true;
    controlDisableBtn(isCanReplace());
}
function changeTemplate(obj,rowIndex){
	var appName = "${ctp:escapeJavascript(appName)}";
	var formId = obj.formApp;
	var workflowId = obj.id;
	var currentUserId = "${currentUser.name}";
	var currentUserAccountName = "${currentUser.loginAccountName}";
	var moduleType = obj.moduleType;
	$("#resultList tr").eq(rowIndex).find("div").css("color", "#808080");
	if("${canEdit}"=="true"){
		var data = wfAjax.getEditTemplateParams(appName,formId, workflowId, moduleType, {
			oldEleList:getOldNodeArray(),
			newEle:newNode,
			flag:(oldEnableNodeArray==null||oldEnableNodeArray.length==0)?true:false
		});
		editTemplate(data);
	}else{
		var data = wfAjax.getEditTemplateParams(appName,formId, workflowId, moduleType, {
			oldEleList:getOldNodeArray(),
			newEle:newNode,
			flag:(oldEnableNodeArray==null||oldEnableNodeArray.length==0)?true:false
		});
		showTemplate(data);
	}
}
function selectRedPeopleFunction(){
	var selectValues = "", selectTexts = "";
	if(oldEnableNodeArray.length>0){
		var tempA = oldEnableNodeArray;
		var tids = [], ttexts = [];
		for(var i=0,len=tempA.length; i<len; i++){
			tids.push(tempA[i].eleType+"|"+tempA[i].eleId);
			ttexts.push(tempA[i].eleName);
		}
		selectValues = tids.join(",");
		selectTexts = ttexts.join("、");
	}
	var paramObj = {
        type:'selectPeople'
        ,text:"${ctp:i18n('workflow.replaceNode.25')}"
        ,showFlowTypeRadio: false
        ,isConfirmExcludeSubDepartment:false
		,isNotShowNoMemberConfirm:true
        ,isNotCheckDuplicateData:true
        ,isNeedCheckLevelScope:false
        ,maxSize:10
        ,params : {
            text : selectTexts,
            value : selectValues
	    }
        ,targetWindow:getCtpTop()
        ,callback : function(res){
            //showFlowTypeRadio: true，需要显示串行、并行、会签等选项
            //res有三个属性obj(选人结果Array,size=3）、text（选的人名，顿号分隔，String）、value（选的人类型|Id，顿号分隔）
            //obj[0]表示选人结果Array，obj[1]表示flowType1穿行、2并行、3会签，obj[2]表示是否显示单位简称。
            //showFlowTypeRadio: false，需要显示串行、并行、会签等选项
            //res有三个属性obj（选人结果Array）、text（选的人名，顿号分隔，String）、value（选的人类型|Id，顿号分隔）
            if(res && res.obj && res.obj.length>0){
            	resetOtherFunction();
                var flag = false, peopleArray = res.obj;
                oldEnableNodeArray.length=0;
                oldUnableNodeArray.length=0;
                for(var i=0, len=peopleArray.length; i<len; i++){
               		var temp = {};
                    temp.eleId = (peopleArray[i].id);
	                temp.eleName = (peopleArray[i].name);
	                temp.eleType = (peopleArray[i].type);
	                temp.accountId = (peopleArray[i].accountId);
	                temp.accountShortName = (peopleArray[i].accountShortname);
	                oldEnableNodeArray.push(temp);
                }
//                var text = getOldNodeArrayText();
				var text = res.text;
                $("#replacedArea").val(text).parent().attr("title", text);
                controlDisableBtn(isCanReplace());
                hasSelectedPeople= true;
            }
        }
    }
    paramObj.panels = 'Department,Team,Post,Level,Node,Account,Outworker';
    paramObj.selectType = 'Member,Department,Team,Role,Post,Level,Node,Account,Outworker';
    $.selectPeople(paramObj);
}
function selectRePeopleFunction(){
	if(getOldNodeArray()==null || getOldNodeArray().length==0){
		$.alert("${ctp:i18n('workflow.replaceNode.26')}");
		return;
	}
	if(!isCanReplace()){
		$.alert("${ctp:i18n('workflow.replaceNode.08')}");
		return;
	}
	var selectValues = "", selectTexts = "";
	var paramObj = {
        type:'selectPeople'
        ,text:"${ctp:i18n('workflow.replaceNode.27')}"
        ,showFlowTypeRadio: false
        ,isConfirmExcludeSubDepartment:false
        ,isNeedCheckLevelScope:false
        ,maxSize:1
        ,params : {
            text : selectTexts,
            value : selectValues
	    }
        ,targetWindow:getCtpTop()
        ,callback : function(res){
            //showFlowTypeRadio: true，需要显示串行、并行、会签等选项
            //res有三个属性obj(选人结果Array,size=3）、text（选的人名，顿号分隔，String）、value（选的人类型|Id，顿号分隔）
            //obj[0]表示选人结果Array，obj[1]表示flowType1穿行、2并行、3会签，obj[2]表示是否显示单位简称。
            //showFlowTypeRadio: false，需要显示串行、并行、会签等选项
            //res有三个属性obj（选人结果Array）、text（选的人名，顿号分隔，String）、value（选的人类型|Id，顿号分隔）
            if(res && res.obj && res.obj.length>0){
                var flag = false, peopleArray = res.obj;
                newNode.eleId = (peopleArray[0].id);
                newNode.eleName = (peopleArray[0].name);
                newNode.eleType = (peopleArray[0].type);
                newNode.accountId = (peopleArray[0].accountId);
                newNode.accountShortName = (peopleArray[0].accountShortname);
                $("#replaceArea").val(res.text).parent().attr("title",res.text);
            }
        	controlDisableBtn(isCanReplace());
        }
    }
	//paramObj.panels = 'Department,Team,Post,Level,Node,Account,Outworker'
	var isGroupVer = ${ctp:isGroupVer()};
	if("Department_Role" == selectedType){
		paramObj.panels = 'Department,Node';
		paramObj.selectType = "Role,Node";
	}else if("Department_Post" == selectedType){
		paramObj.panels = 'Department,Post';
		paramObj.selectType = "Post";
	}else if('Member'==selectedType){
		paramObj.panels = 'Department,Team,Post,Level,Outworker';
    	paramObj.selectType = 'Member';
	}else if('Post'==selectedType){
		paramObj.panels = 'Department,Post';
    	paramObj.selectType = 'Post';
	}else if('Node'==selectedType){
		paramObj.panels = 'Department,Node';
    	paramObj.selectType = 'Role,Node';
	}else if('Role'==selectedType){
		paramObj.panels = 'Node';
    	paramObj.selectType = 'Role,Node';
	}else if('Account'==selectedType && isGroupVer){
		paramObj.panels = 'Account';
    	paramObj.selectType = 'Account';
	}else if('Department'==selectedType || ('Account'==selectedType && !isGroupVer)){
		paramObj.panels = 'Department';
    	paramObj.selectType = 'Department';
	}else if('Outworker'==selectedType){
		paramObj.panels = 'Outworker';
    	paramObj.selectType = 'Department';
	}else{
		paramObj.panels = selectedType;
		paramObj.selectType = selectedType;
	}
    $.selectPeople(paramObj);
}
function replaceFunction(){
	var result = getOldNodeArray();
	if(result.length==0){
		$.alert("${ctp:i18n('workflow.replaceNode.26')}!");
		return;
	}
	if(result.length>1){
		$.alert("${ctp:i18n('workflow.replaceNode.08')}");
		return;
	}
	if(newNode.eleId==null){
		$.alert("${ctp:i18n('workflow.replaceNode.28')}!");
		return;
	}
	if(newNode.eleId=='BlankNode'){
		$.alert('${ctp:i18n("workflow.replaceNode.29")}!');
		return;
	}
	var indexArray = [];
	if(allData.body!=null && allData.body.length>=0){
		var checkboxObj = $("#resultList").find(":checkbox");
		checkboxObj.each(function(index){
			if($(this).attr("checked")){
				indexArray.push(index);
			}
		});
		checkboxObj = null;
		if(indexArray.length==0){
			$.alert("${ctp:i18n('workflow.replaceNode.30')}!");
			return;
		}
		var templateIds = [], formIds = [];
		for(var i=0,len=indexArray.length; i<len; i++){
			var index = indexArray[i];
			var temp = allData.body[index];
			templateIds.push(temp.id);
			if(temp.formApp){
				formIds.push(temp.formApp);
			}
		}
		if(result[0].eleType=='Post'&&newNode.eleType=='Department_Post'){
			$.alert({
				msg:'${ctp:i18n("workflow.replaceNode.31")}!'
				,ok_fn:function(){
					var dialog = $.confirm({
						msg:"${ctp:i18n('workflow.replaceNode.32')}?"
						,ok_fn: function() {
				      		var data = wfAjax.repalceTemplateList(templateIds,{
								oldEleList:getOldNodeArray(),
								newEle:newNode,
								formIds:formIds
							}, "${ctp:escapeJavascript(replaceType)}");
							$.infor("${ctp:i18n('workflow.replaceNode.33')}".replace("xxxx", data));
				          	dialog.close();
							showResultFunction();
				          }
					});
				}
			});
			return;
		}
		var dialog = $.confirm({
			msg:"${ctp:i18n('workflow.replaceNode.32')}?"
			,ok_fn: function() {
	      		var data = wfAjax.repalceTemplateList(templateIds,{
					oldEleList:getOldNodeArray(),
					newEle:newNode,
					formIds:formIds
				}, "${ctp:escapeJavascript(replaceType)}");
				$.infor("${ctp:i18n('workflow.replaceNode.33')}".replace("xxxx", data));
	          	dialog.close();
				showResultFunction();
	          }
		});
	}
}


function showResultFunction(onlyTitle){
	
	$("#resultTitle").css("display","");
	$("#resultListArea").css("display","");
	var oldNodeArray = getOldNodeArray();
	if(oldNodeArray.length>10){
		$.alert("${ctp:i18n('workflow.replaceNode.34')}!");
		return;
	}
	
	var proce = $.progressBar({text:"${ctp:i18n('org.select.people.searching')}"});//"查询中..."
	var wfAjax= new WFAjax();
	wfAjax.getNeedRepalceTemplateList({
		oldEleList:oldNodeArray,
		newEle:newNode,
		flag:(oldEnableNodeArray==null||oldEnableNodeArray.length==0)?true:false
	}, "${ctp:escapeJavascript(appName)}",{success: function(data) {
			if(data==null){
				data = {body:[]};
			}
			if(data.body && data.body.length>0){
				//有查询结果，才可以替换
				controlDisableBtn(true);
			}else{
				data.body= [];
			}
			allData.body = data.body;
			$("#resultListArea").html('<table id="resultList" class="flexme3" style="display: none;"></table>');
			var t1 = t2 = t3 = t4 = '';
			if(allData.head!=null && allData.head.length>0){
				t1 = allData.head[0];
				t2 = allData.head[1];
				t3 = allData.head[2];
				t4 = allData.head[3];
			}
			var ss = $("#resultList").ajaxgrid({
							usepager:false,
							click: changeTemplate,
							render: render,
							datas: {
								rows:data.body
							},
							colModel: [{
								display: 'id',
								name: 'id',
								width: '7%',
								sortable: false,
								align: 'left',
								type: 'checkbox',
								isToggleHideShow:true
							}, {
								display: t1,
								name: 'name',
								width: '48%',
								sortable: true,
								align: 'left',
								isToggleHideShow:false
							}, {
								display: t2,
								name: 'formname',
								width: '15%',
								sortable: true,
								align: 'left'
							}, {
								display: t3,
								name: 'muduleMemberName',
								width: '15%',
								sortable: true,
								align: 'left'
							}, {
								display: t4,
								name: 'muduleTypeName',
								width: '15%',
								sortable: true,
								align: 'left'
							}],
							sortname: "id",
							sortorder: "asc",
							showTableToggleBtn: false,
							parentId: "resultListArea",
							hChange: false,
							vChange: true,
							vChangeParam: {
								overflow: "hidden",
								autoResize:true
							},
							slideToggleBtn: false,
							resizable: false
						});
			proce.close();
		}});
	
}
function showListTitleFunction(){
	$("#resultTitle").css("display","");
	$("#resultListArea").css("display","");
	var t1 = t2 = t3 = t4 = '';
	if(allData.head!=null && allData.head.length>0){
		t1 = allData.head[0];
		t2 = allData.head[1];
		t3 = allData.head[2];
		t4 = allData.head[3];
	}
	var ss = $("#resultList").ajaxgrid({
		usepager:false,
        click: changeTemplate,
        render: render,
        datas: {
        	rows:[]
        },
        colModel: [{
            display: 'id',
            name: 'id',
            width: '7%',
            sortable: false,
            align: 'left',
            type: 'checkbox',
			isToggleHideShow:true
        }, {
            display: t1,
            name: 'name',
            width: '48%',
            sortable: true,
            align: 'left',
			isToggleHideShow:false
        }, {
            display: t2,
            name: 'formname',
            width: '15%',
            sortable: true,
            align: 'left'
        }, {
            display: t3,
            name: 'muduleMemberName',
            width: '15%',
            sortable: true,
            align: 'left'
        }, {
            display: t4,
            name: 'muduleTypeName',
            width: '15%',
            sortable: true,
            align: 'left'
        }],
        sortname: "id",
        sortorder: "asc",
        showTableToggleBtn: false,
        parentId: "resultListArea",
        hChange: false,
        vChange: true,
		vChangeParam: {
            overflow: "hidden",
			autoResize:true
        },
        slideToggleBtn: false,
        resizable: false
    });
}
function showTemplate(param){
	var tWindow = getCtpTop();
	var ptemplateId = param[3] || "";
	var vWindow = window;
	var currentUserName = "";//param[6] || "";;
	var currentUserAccountName = "";//param[7] || "";;
	var returnValueWindow= tWindow;
    if(vWindow){
      returnValueWindow= vWindow;
    }
    currentUserName= currentUserName==undefined?'':currentUserName;
    currentUserAccountName= currentUserAccountName==undefined?'':currentUserAccountName;
    var dwidth= $(tWindow).width();
    var dheight= $(tWindow).height();
    workfowFlashDialog = $.dialog({
      isHide : true,
      url : _wfctxPath+'/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=true&processId='+ptemplateId
      + '&currentUserName='+ escapeSpecialChar(encodeURIComponent(currentUserName))+ '&currentUserAccountName='+ escapeSpecialChar(encodeURIComponent(currentUserAccountName)),
      width : dwidth-30, 
      height : dheight-100,
      title : $.i18n('workflow.designer.title.readonly'),
      transParams : {
        dwidths: dwidth,
        dheights: dheight,
        verifyResultXml:param[13]||"",
        returnValueWindow:returnValueWindow
      },
      minParam:{show:false},
      maxParam:{show:false},
      buttons : [ {
        text : $.i18n('workflow.designer.page.button.close'),
        handler : function() {
          workfowFlashDialog.close();
        }
      } ],
      targetWindow: tWindow
    });
}
var workfowFlashDialog = null;
function editTemplate(param){
	var tWindow = getCtpTop();
	var vWindow = window;
	if(param==null || param.length==0){
		return;
	}
	var appName = param[0] || "";
	var formApp = param[1] || "";
	var formName = param[2] || "";
	var ptemplateId = param[3] || "";
	var defaultPolicyId = param[4] || "";
	var currentUserId = param[5] || "";
    var currentUserName = "";//param[6] || "";
    var currentUserAccountName = "";//param[7] || "";
    var flowPermAccountId = param[8] || "";
    var operationId = param[9] || "";
    var startOperationId = param[10] || "";
    var defaultPolicyName = param[11] || "";
    var wendanId = param[12] || "";
	var returnValueWindow= tWindow;
    if(vWindow){
		returnValueWindow= vWindow;
    }
    if(workfowFlashDialog){
		workfowFlashDialog.isHide = false;
		workfowFlashDialog.close(workfowFlashDialog.index);
    }
    var dwidth= $(tWindow).width();
    var dheight= $(tWindow).height();
    workfowFlashDialog = $.dialog({
          isHide : true,
          url : _wfctxPath+'/workflow/designer.do?method=showDiagram&isDebugger=false&scene=0&isModalDialog=true'
              + '&formApp='
              + formApp
              + '&formName='
              + encodeURIComponent(formName)
              + '&appName='
              + appName
              + '&processId='
              + ptemplateId
              + '&currentUserId='
              + currentUserId
              + '&currentUserName='
              + escapeSpecialChar(encodeURIComponent(currentUserName))
              + '&currentUserAccountName='
              + escapeSpecialChar(encodeURIComponent(currentUserAccountName))
              + '&defaultPolicyId='+escapeSpecialChar(encodeURIComponent(defaultPolicyId))
              + '&defaultPolicyName='+escapeSpecialChar(encodeURIComponent(defaultPolicyName))
              + '&flowPermAccountId='+flowPermAccountId
              + '&operationName='+operationId
              + '&startOperationName='+startOperationId
              + '&wendanId='+(wendanId||"-1")
              + '&isvalidate=false'
              + '&canAddSubProcess=false'
              + '&canDrSet=false',
          width : dwidth-20,
          height : dheight-100,
          title : $.i18n('workflow.designer.title'),
          targetWindow: tWindow,
          transParams : {
            subProcessJson : "",
            formId : formApp,
            dwidths: dwidth,
            dheights: dheight-20,
            workflowRule: "",
            verifyResultXml:param[13]||"",
            returnValueWindow:returnValueWindow,
            appName: appName,
            formApp: formApp||wendanId||"",
            isClone: true
          },
          closeParam : {
            'show' : true
            ,handler : function(){
            }
          },
          minParam:{show:false},
          maxParam:{show:false},
          buttons : [ {
          	isEmphasize:true,
            text : $.i18n('common.toolbar.save.label'),
            handler : function() {
              var returnValue = workfowFlashDialog.getReturnValue({"innerButtonId":"ok"});
              if(returnValue){
              	var dialog = $.confirm({
					msg:"${ctp:i18n('workflow.replaceNode.39')}"
					,ok_fn: function() {
		                var result = wfAjax.updateTemplateList(appName,ptemplateId, formApp, returnValue[1], returnValue[3]);
		                if(result!=null){
			                if(result.success){
				                workfowFlashDialog.close();
				                workfowFlashDialog.transParams.returnValueWindow = null;
				                workfowFlashDialog.transParams = null;
					          	dialog.close();
			                }else{
			                	$.alert(result.msg);
			                }
		                }
			          }
				});
              }
            }
          }, {
            text : $.i18n('workflow.designer.page.button.cancel'),
            handler : function() {
                workfowFlashDialog.close();
            }
		} ]
	});
}

function escapeSpecialChar(str){
    if(!str){
        return str;
    }
    str= str.replace(/\&/g, "&amp;").replace(/\</g, "&lt;").replace(/\>/g, "&gt;").replace(/\"/g, "&quot;");
    str= str.replace(/\'/g,"&#039;").replace(/"/g,"&#034;");
    return str;
}
</script>