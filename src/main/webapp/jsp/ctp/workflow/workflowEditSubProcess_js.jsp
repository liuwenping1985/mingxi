<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
//页面初始化开始
var defaultShowCondition = "${ctp:i18n('subflow.condition.tip')}";
(function(){
	$("input[id=subFlowName]").click(selectFormTemplate);
	$("label.forinput").click(function(){
	    $(this).find("input:radio").prop("checked",true);
	});
//	$("input.forsingle").click(function(){
//		$(this).prop("checked",true).closest("tr").find("input.forsingle").not($(this)).prop("checked",false).removeAttr("checked","checked");
//	});
    $("label.clearRed").click(function(){
    	$(this).closest("tr").removeClass("color_red").find("input.color_red").removeClass("color_red");
    });
	$("input.selectPeople").click(function(){
		var thisId = $(this).prop("id");
		var temp = $(this).prop("checked",true).closest("tr");
        temp.find("input.forsingle").not($(this)).prop("checked",false).removeAttr("checked","checked");
        if(thisId=="sender3Value"){
            temp.find("#sender3Name").click();
        }else{
        	temp.find("#sender3Name").val("${ctp:i18n('common.default.selectPeople.value')}");
            temp.find("#sender3Value").val("");
        }
        temp = null;
	});
	if(window.dialogArguments && window.dialogArguments.subProcessJson){
		var subProcessObj = null, nodeId = window.dialogArguments.nodeId;
	    try{
	        subProcessObj = $.parseJSON(window.dialogArguments.subProcessJson);
	    }catch(e){subProcessObj = {}}
	    if(subProcessObj[nodeId] && subProcessObj[nodeId].length>0){
	    	var subArray = subProcessObj[nodeId];
	    	var container = $("#NewflowContainer"), element = $("#newflow1");
		    var size = container.children("fieldset").size();
		    var subPageObj = setSubPageObjValue(element, subArray[0]);
		    container.append(subPageObj);
	    	if(subArray.length>1){
		    	for(var i=1,len=subArray.length; i<len; i++){
		    		subPageObj = setSubPageObjValue(cloneSubElement(i), subArray[i]);
		    		container.append(subPageObj);
		    	}
	    	}
            container = null;
	    }
	}
})();
//绑定选人事件
$("input[id=sender3Name]").click(function(){
	var tempThis = $(this);
	var text = tempThis.attr("selectedText") || "", value = tempThis.attr("selectedValue") || "";
	$.selectPeople({
        type:'selectPeople'
        ,panels:'Department,Post,Level,FormField,Team,Outworker,JoinOrganization,JoinAccountTag,JoinPost'
        ,selectType:'Department,Post,Level,Member,FormField,Team,Outworker,JoinAccountTag'
        ,maxSize:1
        ,extParameters:'${formId},333300'
        ,text:"${ctp:i18n('common.default.selectPeople.value')}"
        ,showFlowTypeRadio: false
        ,isConfirmExcludeSubDepartment:true
        ,isNeedCheckLevelScope:false
        ,showAllOuterDepartment:true
        ,params:{
        	text:text
            ,value: value
        }
        ,targetWindow:getCtpTop()
        ,callback : function(res){
            if(res && res.obj && res.obj.length>0){
            	tempThis.attr("selectedText", res.text).attr("selectedValue", res.value);
            	tempThis.val(res.text);
            	/*if(res.obj[0].type=="FormField"){
            	   var tempId = res.obj[0].id;
            	   var index1 = tempId.indexOf("@"), index2 = tempId.indexOf("#");
            	   if(index1>-1 && index2>-1){
            	       res.obj[0].id = tempId.substr(0,index1)+"|"+tempId.substr(index2+1);
            	   }
            	}*/
            	if(res.obj[0].type=="Department"){
                    tempThis.closest("td").find("#sender3Value").prop("checked", true).val(res.obj[0].type + "|" + res.obj[0].excludeChildDepartment + "|" + res.obj[0].id);
            	}else{
            		tempThis.closest("td").find("#sender3Value").prop("checked", true).val(res.obj[0].type + "|" + res.obj[0].id);
            	}
                tempThis.closest("tr").removeClass("color_red").find("input.color_red").removeClass("color_red");
	            tempThis = null;
            } else {
                $("#collSelectPeopleInput").val("<${ctp:i18n('workflow.insertPeople.urgerAlt')}>");
            }
        }
    });
});
//绑定分支设置事件
$("input.condition").click(setConFunction);
//$("label.condition").click(setConFunction);
//页面初始化结束
var isIE6or7 = false;
if($.browser.msie){
	if($.browser.version=='6.0' || $.browser.version=='7.0'){
		isIE6or7 = true;
	}
}
function cloneSubElement(size){
	var index = size+1, element = $("#newflow1Copy");
	var result = element.clone(true,true).prop("id",("newflow"+index));
	result.find("input:radio").each(function(jndex){
		var oldName = $(this).prop("name"), newName = oldName+index, id = $(this).prop("id");
		if(isIE6or7){//IE6与IE7下input框的name属性无法修改，所以用outerHTML属性来修改
			$(this).val(element.find("#"+id).val());
			var tempThisDom = $(this)[0];
			tempThisDom.outerHTML = tempThisDom.outerHTML.replace(/name\s*=\s*"?[\w]+"?/,"name='"+newName+"'")
			tempThisDom = null;
		}else{
			$(this).prop("name", newName).val(element.find("#"+id).val());
		}
	});
	return result;
}
//选择表单模版
function selectFormTemplate(){
	var thisObj = $(this), formId = "${formId}";
    var dialog = $.dialog({
        url : '<c:url value="/workflow/subProcess.do?method=selectTemplate"/>&formId='+formId+'&oldProcessTemplateId=${ctp:escapeJavascript(oldProcessTemplateId) }&subProcessTempleteId='+$(this).next("input").val(),
        transParams : {
        },
        width : 480,
        height : 400,
        title : '${ctp:i18n("subflow.setting.title")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.ok.label") }',
				btnType : 1,
                handler : function(){
                	var json = dialog.getReturnValue();
                    try{
                        var result = $.parseJSON(json);
                        if(result.canBeSub){
                            thisObj.val(result.subName).attr("value", result.subName).next("input").val(result.subId).attr("value", result.subId);
                            thisObj = null;dialog.close();
                        }
                    }catch(e){$.alert(e.message);dialog.close();}
            }},
            {
                text : '${ctp:i18n("common.button.cancel.label") }',
                handler : function(){
                	thisObj = null;
                    dialog.close();
            }}
        ],
        targetWindow: getCtpTop()
    });
}
//添加一个新的设置子流程区域
function addANewFlow(){
    var container = $("#NewflowContainer");
    var size = container.children("fieldset").size();
    container.append(cloneSubElement(size));
    /*if(size<${maxNewflowNum}){
	    container.append(cloneSubElement(size));
    }else{
    	$.alert("当前表单只有"+${maxNewflowNum}+"个模版(不包括当前正在编辑的模版)，不能再添加子流程了！");
    }*/
    container = null;
}
//删除最后一个设置子流程区域
function removeANewFlow(){
	var container = $("#NewflowContainer");
	var size = container.children("fieldset").size();
	if(size>1){
        container.children("fieldset").last().remove();
	}else{
        $.alert("${ctp:i18n('workflow.label.dialog.cannotDelLastNode')}");// "已经是最后一个，不能删除了！"
	}
	container = null;
}
//设置初始值
function setSubPageObjValue(element, param){
    if(element!=null && element.size()>0 && param!=null){
        var result = element;
        result.find("#newflowTempleteId").val(param.newflowTempleteId);
        result.find("#subFlowName").val(param.subject);
        if('CurrentNode'==param.newflowSender){
            result.find("#sender1").prop("checked", true);
            result.find("#sender2").prop("checked", false);
            result.find("#sender3Value").prop("checked", false);
        } else if('CurrentSender'==param.newflowSender){
            result.find("#sender1").prop("checked", false);
        	result.find("#sender2").prop("checked", true);
            result.find("#sender3Value").prop("checked", false);
        } else {
            result.find("#sender1").prop("checked", false);
            result.find("#sender2").prop("checked", false);
        	result.find("#sender3Value").val(param.newflowSender).prop("checked", true);
        	var senderName = result.find("#sender3Name");
        	//var text = tempThis.attr("selectedText") || "", value = tempThis.attr("selectedValue") || "";
        	senderName.val(param.senderName).attr("selectedText",param.senderName).attr("selectedValue",param.newflowSender);
        	if(param.vs==false){
                senderName.addClass("color_red").closest("tr").addClass("color_red");
        	}
        	senderName = null;
        }
        if(param.triggerCondition && param.triggerCondition.length>0  && $.trim(param.triggerCondition)!="null"){
	        result.find("#formFlowCondition1NameRadio2").prop("checked", true);
	        result.find("#formFlowCondition1Value").val(param.triggerCondition);
	        result.find("#formFlowCondition1Title").val(param.conditionTitle);
	        var conditionName = result.find("#formFlowCondition1Name");
	        conditionName.val(param.conditionTitle).attr("title", param.conditionTitle);
	        result.find("#formFlowCondition1Base").val(param.conditionBase);
            if(param.isForce || param.isForce=="true"){
	            result.find("#formFlowCondition1IsForce").val("1");
            }else{
                result.find("#formFlowCondition1IsForce").val("0");
            }
	        if(param.vc==false){
                conditionName.addClass("color_red").closest("tr").addClass("color_red");
            }
            conditionName = null;
        }else{
	        result.find("#formFlowCondition1NameRadio1").prop("checked", true);
	        result.find("#formFlowCondition1Title").val("");
	        result.find("#formFlowCondition1IsForce").val("0");
	        result.find("#formFlowCondition1Base").val("currentNode");
	        result.find("#formFlowCondition1Value").val("");
        }
//        result.find("#formFlowCondition1Id").val("");
//        result.find("#formFlowCondition1IdAdd").val("");
        if('1'==param.flowRelateType){
            result.find("#flowRelateType11").prop("checked", false);
            result.find("#flowRelateType12").prop("checked", true);
        }
        if(false==param.isCanViewMainFlow || "false"==param.isCanViewMainFlow){
            result.find("#isCanViewMainFlow11").prop("checked", false);
            result.find("#isCanViewMainFlow12").prop("checked", true);
        }
        if(false==param.isCanViewByMainFlow || "false"==param.isCanViewByMainFlow){
            result.find("#isCanViewByMainFlow11").prop("checked", false);
            result.find("#isCanViewByMainFlow12").prop("checked", true);
        }
        element = null;
        return result;
	}
	return null;
}
function OK(){
	var formFlowIds = [];
    var formFlowIdsStr = "";
    var hiddenInputs = [];
    var nodeId = window.dialogArguments.nodeId;
    var checkForm = true;
    var teIdObj = {};
    //判断有没有选择重复的子流程模版
    $("input[name=newflowTempleteId]").each(function(){
    	var value = $(this).val();
    	if(value!=""){
    		if(teIdObj[value]==true){
                $.alert("${ctp:i18n('subflow.setting.subflowDuple')}("+$(this).prev("input").val()+")!")
                checkForm = false;
                return false;
    		}else{
    			teIdObj[value] = true;
    		}
    	}
    });
    //判断校验失败的子流程是否已重新选过人或者设置分支条件
    if($("tr.color_red,input.color_red").size()>0){
    	$.alert("${ctp:i18n('workflow.label.dialog.select4SubFlowBranch')}");//"校验失败的子流程尚未重新选人或者分支！"
    	return false;
    }
    if(checkForm==false){return null;}
    $("#NewflowContainer").children("fieldset").each(function(){
    	var thisObj = $(this);
    	if(!thisObj.validate({})){
    		checkForm = false;
    		return;
    	}
        var subTemplateIdObj = thisObj.find("#newflowTempleteId");
        var obj1Name = thisObj.find("#subFlowName").val();
        var conditionValueObj = thisObj.find("#formFlowCondition1Value");
        //条件触发的第一个checkbox:无条件触发
        var formFlowConditionIndexNameRadio1= thisObj.find("#formFlowCondition1NameRadio1");
        //条件出发的第二个checkbox:有条件触发
        var formFlowConditionIndexNameRadio2= document.getElementById("#formFlowCondition1NameRadio2");
        //恢复无条件的初始值
        if(formFlowConditionIndexNameRadio1.prop("checked") ==true){
            conditionValueObj.val("");
            thisObj.find("#formFlowCondition1Title").val("");
            thisObj.find("#formFlowCondition1IsForce").val("0");
            thisObj.find("#formFlowCondition1Base").val("currentNode");
//            thisObj.find("#formFlowCondition1Id").val("");
//            thisObj.find("#formFlowCondition1IdAdd").val("");
        }else{
        	var conditionTitleObj = thisObj.find("#formFlowCondition1Name");
        	var conditionTitle = conditionTitleObj.val();
        	if(conditionTitle=="" || conditionTitle==conditionTitleObj.attr("deaultValue")){
        		//$.alert("请选择分支条件！");
        		$.alert("${ctp:i18n('subflow.setting.noSelectCondition')}");
                checkForm = false;
                return false;
        	}
        }
        var conditionValue = ""; //默认无条件
        if(conditionValueObj && conditionValueObj.val() != defaultShowCondition){
            conditionValue = conditionValueObj.val();//.replace(/\"/gi,"\'").replace(/&quot;/gi,"\'");
        }
        var senderName = "";
        var senderValue = "";
        var senderNameObj = thisObj.find("#sender3Name");
        var senderValueObj = thisObj.find("#sender3Value");
        if(senderValueObj.prop("checked")){
            if(senderValueObj.val() =="" || senderNameObj.val() == senderNameObj.attr("deaultValue")){
                $.alert("${ctp:i18n('workflow.newflow_setting_noSelectSender')}");
                checkForm = false;
                return false;
            }
            senderValue = senderValueObj.val();
            senderName = senderNameObj.val();
        }
        else{
            var senderObjs1 = thisObj.find("#sender1");
            var senderObjs2 = thisObj.find("#sender2");
            if(senderObjs1.prop("checked")){
                senderValue = senderObjs1.val();
            }else if(senderObjs2.prop("checked")){
            	senderValue = senderObjs2.val();
            }
            senderObjs = null;
        }
        try{
            var cTitle =thisObj.find("#formFlowCondition1Title").val();
            //if(cTitle){
                //cTitle = cTitle.replace(/\"/gi,"\'").replace(/&quot;/gi,"\'");
            //}
            var conditionBase = thisObj.find("#formFlowCondition1Base").val();
            var isForce = ("1" == thisObj.find("#formFlowCondition1IsForce").val());
            var flowRelateType = thisObj.find("#flowRelateType11").prop("checked")? 0:1;
            var isCanViewMainFlow = thisObj.find("#isCanViewMainFlow11").prop("checked");
            var isCanViewByMainFlow = thisObj.find("#isCanViewByMainFlow11").prop("checked");
            //hiddenInputs[hiddenInputs.length] = "<input id=\"NF" + nodeId + "\" type=\"hidden\" name=\"NewflowSettings\" value=\"" + nodeId +"@"+ subTemplateIdObj.val() +"@"+ senderValue +"@"+ conditionValue +"@"+ cTitle +"@"+ conditionBase +"@"+ isForce +"@"+ flowRelateType +"@"+ isCanViewMainFlow +"@"+ isCanViewByMainFlow + "\" TName=\""+ obj1Name +"\" SenderName=\"" + senderName + "\" />";
            var obj = {
            	"nodeId" : nodeId
            	,"newflowTempleteId" : subTemplateIdObj.val()
                ,"newflowSender" : senderValue
                ,"triggerCondition" : conditionValue
                ,"conditionTitle" : cTitle
                ,"conditionBase" : conditionBase
                ,"isForce" : isForce
                ,"flowRelateType" : flowRelateType
                ,"isCanViewMainFlow" : isCanViewMainFlow
                ,"isCanViewByMainFlow" : isCanViewByMainFlow
                ,"subject" : obj1Name
                ,"senderName" : senderName
            }
            hiddenInputs.push(obj);
            //hiddenInputs.push(nodeId +"@"+ subTemplateIdObj.val() +"@"+ senderValue +"@"+ conditionValue +"@"+ cTitle +"@"+ conditionBase +"@"+ isForce +"@"+ flowRelateType +"@"+ isCanViewMainFlow +"@"+ isCanViewByMainFlow);
        }
        catch(e){$.alert(e)}
        thisObj = subTemplateIdObj = conditionValueObj = formFlowConditionIndexNameRadio1 = formFlowConditionIndexNameRadio2 = senderNameObj = senderValueObj = null;
    });
    if(checkForm==false){return null;}
    return $.toJSON({
    	"nodeId" : nodeId
    	,"subs" : hiddenInputs
    });
}
function setConFunction(){
	var tempThisTd = $(this).closest("tr");
    var conditionTitle = tempThisTd.find("#formFlowCondition1Title").val();
    var isForce = tempThisTd.find("#formFlowCondition1IsForce").val() || "0";
    var conditionBase = tempThisTd.find("#formFlowCondition1Base").val();
    var formCondition = tempThisTd.find("#formFlowCondition1Value").val();
    var conditionDesc = "", appName = "form", isNew = formCondition==""?1:0, conditionType=1;
    var height = $(getCtpTop().document.body).height();
	  if(height-80<520){
	    height = height-80;
	  }else{
	    height = 520;
	  }
	var dialog = $.dialog({
    url : "<c:url value='/workflow/designer.do?method=showWorkflowBranchSettingPage&appName='/>"+appName+"&isNew="+isNew+"&conditionBase="+conditionBase+"&formApp=${formId}",
		width : 560,
		height : height,
		title : "${ctp:i18n('workflow.formBranch.validate.16')}",//"分支条件设置"
		transParams :{
			"appName":appName,
			//"linkId":linkId,**可以不传
			"isNew":isNew,
			//"conditionId":conditionId,**可以不传
			"formCondition":formCondition,//**分支表达式
			"conditionTitle":conditionTitle,
			"conditionType":conditionType,//**1或者4
			"isForce":isForce,
			"conditionBase":conditionBase,
			"conditionDesc":conditionDesc
        },
		targetWindow: window.parent,
		buttons : [
            {
              text : $.i18n('common.button.reset.label'),
              handler : function() {
                dialog.getReturnValue({"reset":true});
              }
            },
            {
			text : "${ctp:i18n('workflow.designer.page.button.ok')}",
            isEmphasize: true,
			handler : function() {
				var condition = dialog.getReturnValue({"innerButtonId":"ok"});
				try{
        			condition = $.parseJSON(condition);
        		}catch(e){condition = null;}
				if(condition){
					if(condition[5]!=true){
		                $.alert("${ctp:i18n('workflow.formBranch.validate.25')}");//"校验失败，请重新设置分支条件或者点击取消！"
		                return;
		            }
			        tempThisTd.find("#formFlowCondition1NameRadio2").prop("checked", true);
                    tempThisTd.find("#formFlowCondition1Value").val(condition[1]);
			        tempThisTd.find("#formFlowCondition1Title").val(condition[2]);
                    tempThisTd.find("#formFlowCondition1Name").val(condition[2]).attr("title",condition[2]);
                    tempThisTd.find("#formFlowCondition1Base").val(condition[3]);
			        tempThisTd.find("#formFlowCondition1IsForce").val(condition[4]);
			        tempThisTd.removeClass("color_red").find("input.color_red").removeClass("color_red");
                    tempThisTd = null;
	                dialog.close();
	            }else{
                    tempThisTd.find("#formFlowCondition1NameRadio1").prop("checked", true);
	            }
	        }
        }, {
            text : "${ctp:i18n('workflow.designer.page.button.cancel')}",
            handler : function() {
                dialog.close();
            }
        }]
});
}
</script>