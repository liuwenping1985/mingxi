//<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
/**
 * 修改textArea中的value
 */
function addToTextArea(textAreaObj, addedValue){
    if(textAreaObj==null || addedValue==null){return;}
    var startPos = 0, endPos = 0;
    //设置分支条件
    if (document.selection){//IE浏览器
        //这个focus不能去掉，否则文本添加的位置会出错。
        textAreaObj.focus();
        var sel = textAreaObj.ownerDocument.selection.createRange();
        sel.text = addedValue;
        sel.select();
        sel = null;
    }else if(textAreaObj.selectionStart || textAreaObj.selectionStart == '0'){//火狐/网景 浏览器
        //得到光标前的位置
        startPos = textAreaObj.selectionStart;
        //得到光标后的位置
        endPos = textAreaObj.selectionEnd;
        // 在加入数据之前获得滚动条的高度 
        var restoreTop = textAreaObj.scrollTop, createCodeValue = textAreaObj.value; 
        textAreaObj.value = createCodeValue.substring(0, startPos) + addedValue + createCodeValue.substring(endPos, textAreaObj.value.length);
        //如果滚动条高度大于0
        if (restoreTop > 0) {
            textAreaObj.scrollTop = restoreTop;
        }
        textAreaObj.selectionStart = startPos + addedValue.length;
        textAreaObj.selectionEnd = endPos + addedValue.length;
    }else{
        textAreaObj.value = createCodeValue + addValue;
    }
    textAreaObj = null;
    
}

/**
 * 获取textArea中光标的位置
 */
function getTextAreaPosition(t){
    var startPos = 0, endPos = 0;
    if(t!=null){
       if (t.ownerDocument.selection) {
            t.focus();
            var ds = t.ownerDocument.selection;
            var range = ds.createRange();
            var stored_range = range.duplicate();
            stored_range.moveToElementText(t);
            stored_range.setEndPoint("EndToEnd", range);
            startPos = t.selectionStart = stored_range.text.length - range.text.length;
            endPos = t.selectionEnd = t.selectionStart + range.text.length;
            ds = range = null;
        } else if(t.selectionStart) {
            startPos = t.selectionStart;
            endPos = t.selectionEnd;
        } else {
            startPos = endPos = 0;
        }
    }
    return {"startPos":startPos, "endPos":endPos};
}

/**
 * 设置textArea光标的位置
 */
function setTextAreaPosition(t,number){
    if(t==null || number==null){return;}
    selectTextAreaValue(t,number,number);
}

/**
 * 选中textArea中的文字
 */
function selectTextAreaValue(t, s, z){
    if(t==null || s==null || z==null){return;}
    if(t.ownerDocument && t.ownerDocument.selection){
        var range = t.createTextRange();
        range.moveEnd('character', -t.value.length);
        range.moveEnd('character', z);
        range.moveStart('character', s);
        range.select();
    }else if(t.setSelectionRange){
        t.setSelectionRange(s,z);
        t.focus();
    }
    t = null;
}

/**
 * 将单个的等号替换成双个的等号
 */
function replateEqualAndNotEqual(result){
	var temp = "", result = " "+result+" ";
	for(var i=0,len=result.length; i<len;i++){
		var c = result.charAt(i);
		if(c=='='){
			var next = result.charAt(i+1), last = result.charAt(i-1);
			if(last!='<' && last!='>' && last!='!' && next!="="){
				temp = temp + "=" + result.substr(i);
				break;
			}
		}else if(c=='<'){
			var next = result.charAt(i+1);
			if(next=='>'){
				temp = temp + "!=" + result.substr(i+2);
				break;
			}
		}
        temp = temp+c; 
	}
	temp = temp.substr(1, result.length-1)
	return temp;
}

/**
 * 综合办公的extend方法
 */
function officeExtend(fieldObj, formShortName, createCode){
	//修改条件选择框的光标
    var startPos = 0, endPos = 0;
    var result = getTextAreaPosition(createCode);
    startPos = result.startPos;
    endPos = result.endPos;
    window.extendDialog = $.dialog({
        url:"<c:url value='/workflow/designer.do?method=wfextend'/>&inputType="+fieldObj.inputType+"&textType="+fieldObj.textType+"&enumId="+(fieldObj.enumId||""),
        //title : 'extend设置',
        title : '${ctp:i18n("workflow.formBranch.validate.18")}',
        width:500,
        height:300,
        targetWindow:getCtpTop(),
        transParams:{
        	display:fieldObj.display
        },
        buttons : [{
          text : "${ctp:i18n('workflow.designer.page.button.ok')}",
          handler : function() {
              var result = extendDialog.getReturnValue();
              result = $.parseJSON(result);
              if(result.length>0){
                setTextAreaPosition(createCode,startPos);
                var text = "";
                if(fieldObj.inputType=='text'){
                	condition = [];
                		if(fieldObj.textType=="include"||fieldObj.textType=="exclude"){
	                        condition.push(fieldObj.textType);
	                        condition.push("(");
		                    condition.push("'text'");
		                    condition.push(","+fieldObj.display);
		                    condition.push(",'"+result[1]+"'");
                        }else if(fieldObj.textType=="=="||fieldObj.textType=="!="){
                            condition.push("compareField");
                            condition.push("(");
                            condition.push("'"+result[0]+"'");
                            condition.push(","+fieldObj.display);
                            condition.push(",'"+result[1]+"'");
                        }
                        condition.push(")");
                    text = condition.join("");
                }else{
                	var temp = [],realType = fieldObj.inputType;
    				temp.push("compareField('");
    				temp.push(result[0]);
       			 	temp.push("',");
       			 	temp.push(fieldObj.display);
            		temp.push(", '");
            		temp.push(result[1]);
            		temp.push("'");
    				temp.push(")");
    				text = temp.join("");
                }
                addToTextArea(createCode, text);
                handInvokeTranslate();
                createCode = null;
                extendDialog.close();
                extendDialog.transParams = null;
              }
          }
        }, {
          text : "${ctp:i18n('workflow.designer.page.button.cancel')}",
          handler : function() {
          	createCode = null;
            extendDialog.close();
            extendDialog.transParams = null;
          }
        }]
      });
}
var RealType_Org = {
    "member":true,
    "department":true,
    "account":true,
    "post":true,
    "level":true
}
function inFunction(fieldObj, formShortName, createCode){
    //修改条件选择框的光标
    var startPos = 0, endPos = 0;
    var result = getTextAreaPosition(createCode);
    var realType = fieldObj.extraMap.realType;
    startPos = result.startPos;
    endPos = result.endPos;
    dialogUrl = "<c:url value='/workflow/designer.do?method=inFunc'/>&fieldName="+fieldObj.name;
    window.inDialog = $.dialog({
        url:dialogUrl,
        title : 'in设置',
        //title : '${ctp:i18n("workflow.formBranch.validate.18")}',
        width:500,
        height:300,
        targetWindow:getCtpTop(),
        transParams:window,
        buttons : [{
          text : "${ctp:i18n('workflow.designer.page.button.ok')}",
          handler : function() {debugger
              var result = inDialog.getReturnValue();
              result = $.parseJSON(result);
              if(result.length>0){
                setTextAreaPosition(createCode,startPos);
                var text = getInFunctionText(formShortName, fieldObj, result);
                addToTextArea(createCode, text);
                handInvokeTranslate();
                createCode = null;
                inDialog.close();
                inDialog.transParams = null;
              }
          }
        }, {
          text : "${ctp:i18n('workflow.designer.page.button.cancel')}",
          handler : function() {
            createCode = null;
            inDialog.close();
            inDialog.transParams = null;
          }
        }]
      });
}

/**
 * extend功能
 */
var RealType_Multi = {
	"multimember":true,
	"accountAndDepartment":true,
	"multidepartment":true,
	"multiaccount":true,
	"multipost":true,
	"multilevel":true
}
function extendFunction(fieldObj, formShortName, createCode){
	//修改条件选择框的光标
    var startPos = 0, endPos = 0;
    var result = getTextAreaPosition(createCode);
    var realType = fieldObj.extraMap.realType;
    startPos = result.startPos;
    endPos = result.endPos;
    if(RealType_Multi[realType]){
        dialogUrl = "<c:url value='/workflow/designer.do?method=formulaExtendMulti'/>&fieldName="+fieldObj.name+"&formApp=${formBean.id}";
    }else{
        dialogUrl = "<c:url value='/workflow/designer.do?method=formulaExtend'/>&fieldName="+fieldObj.name+"&formApp=${formBean.id}";
    }
    window.extendDialog = $.dialog({
        url:dialogUrl,
        //title : 'extend设置',
        title : '${ctp:i18n("workflow.formBranch.validate.18")}',
        width:500,
        height:300,
        targetWindow:getCtpTop(),
        transParams:window,
        buttons : [{
          text : "${ctp:i18n('workflow.designer.page.button.ok')}",
          handler : function() {
              var result = extendDialog.getReturnValue();
              result = $.parseJSON(result);
              if(result.length>0){
                setTextAreaPosition(createCode,startPos);
                var text = formResulttoText(formShortName, fieldObj, result);
                addToTextArea(createCode, text);
                handInvokeTranslate();
                createCode = null;
                extendDialog.close();
                extendDialog.transParams = null;
              }
          }
        }, {
          text : "${ctp:i18n('workflow.designer.page.button.cancel')}",
          handler : function() {
          	createCode = null;
            extendDialog.close();
            extendDialog.transParams = null;
          }
        }]
      });
}

/**
 * 将调用extend方法的结果转换为一个分支表达式
 */
function formResulttoText(formShortName, fieldObj, result){
	var condition = "";
	if(result!=null){
		formShortName = formShortName || "";
		var inputType = $.trim(fieldObj.inputType.toLowerCase()), fieldType = $.trim(fieldObj.fieldType.toUpperCase());
		var realType = fieldObj.extraMap.realType;
		if(inputType=="date" || inputType=="datetime" || fieldType=="TIMESTAMP" || fieldType=="DATETIME"){
			condition = getDateOrTimeConditionValue(formShortName, fieldObj, result);
		}else if(RealType_Multi[realType]){
		    condition = getMultiConditionValue(formShortName, fieldObj, result);
		}else{
			condition = getNormalConditionValue(formShortName, fieldObj, result);
		}
	}
	return condition;
}
function getInFunctionText(formShortName, fieldObj, result){
    var condition = "";
    if(result[1]==null || $.trim(result[1])=="{}"){
        //$.alert("请设置有效的值！");
        $.alert('${ctp:i18n("workflow.formBranch.validate.19")}');
        return condition;
    }
    var temp = [];
    temp.push("compareMultiField('in',");
    temp.push(getFieldName(formShortName, fieldObj.display));
    if(result[2]=="1"){
        temp.push(", '");
        temp.push(result[1]);
        temp.push("'");
    }else if(result[2]=="2"){
        temp.push(", ");
        temp.push(result[1]);
    }
    temp.push(")");
    condition = temp.join("");
    return condition;
}
function getDateOrTimeConditionValue(formShortName, fieldObj, result){
    var condition = "";
    var operator = $.trim(result[0]);
    if(operator == '='){operator = "==";}
    if(operator=="<>"){operator = "!=";}
    if(result[1]==null || $.trim(result[1])=="{}"){
    	//$.alert("请设置有效的值！");
    	$.alert('${ctp:i18n("workflow.formBranch.validate.19")}');
    	return condition;
    }
    var temp = [];
    temp.push("compareDate('");
    temp.push(operator);
    temp.push("',");
    temp.push(getFieldName(formShortName, fieldObj.display));
    if(result[2]=="1"){
        temp.push(", '");
        temp.push(result[1]);
        temp.push("'");
    }else if(result[2]=="2"){
        temp.push(", ");
        temp.push(result[1]);
    }
    temp.push(")");
    condition = temp.join("");
    return condition;
}
function getMultiConditionValue(formShortName, fieldObj, result){
    var condition = "";
    var operator = $.trim(result[0]);
    if(operator == '='){operator = "==";}
    if(operator=="<>"){operator = "!=";}
    if(result[1]!=null && $.trim(result[1])!="{}"){
        var temp = [],realType = fieldObj.extraMap.realType || fieldObj.inputType, isCompareLevel = false;
        temp.push("compareMultiField('");
        temp.push(operator);
        temp.push("',");
        temp.push(getFieldName(formShortName, fieldObj.display));
        if(result[2]=="1"){
            temp.push(", '");
            temp.push(result[1]);
            temp.push("'");
        } else if(result[2]=="2"){
            temp.push(", ");
            temp.push(result[1]);
        }
        temp.push(")");
        condition = temp.join("");
    }else{
        //$.alert("请设置有效的值！");
        $.alert('${ctp:i18n("workflow.formBranch.validate.19")}');
    }
    return condition;
}
function getNormalConditionValue(formShortName, fieldObj, result){
    var condition = "";
    var operator = $.trim(result[0]);
    if(operator == '='){operator = "==";}
    if(operator=="<>"){operator = "!=";}
    if(result[1]!=null && $.trim(result[1])!="{}"){
    	var temp = [],realType = fieldObj.extraMap.realType || fieldObj.inputType, isCompareLevel = false;
    	if((operator=='>>' || operator=='<<' || operator=='--') && realType=='level'){
    		temp.push("compareLevel('");
    		isCompareLevel = true;
    	}else{
    		temp.push("compareField('");
    	}
    	temp.push(operator);
        temp.push("',");
        temp.push(getFieldName(formShortName, fieldObj.display));
    	if(result[2]=="1"){
            temp.push(", '");
            temp.push(result[1]);
            temp.push("'");
    	} else if(result[2]=="2"){
            temp.push(", ");
            temp.push(result[1]);
    	}
    	//如果是集团基准岗或者是集团职务级别，那么加上一个参数
    	if(result[3]==true && isCompareLevel==false){
            temp.push(", true");
    	}
    	temp.push(")");
    	condition = temp.join("");
    }else{
        //$.alert("请设置有效的值！");
    	$.alert('${ctp:i18n("workflow.formBranch.validate.19")}');
    }
    return condition;
}

function getFieldName(formShortName, fieldName){
	return "{"+formShortName+fieldName+"}";
}
/**
 * 日期与日期时间差函数
 */
function dateOrDatetimeCal(appName, urlParams, type, formShortName, createCode, paramObj){
	//var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0, title = '日期差设置';
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0, title = '日期差设置';
    startPos = result.startPos;
    endPos = result.endPos;
	var dialog = $.dialog({
        url : "<c:url value='/workflow/designer.do?method=dateOrDatetimeCal'/>&appName="+appName+"&type="+type+"&"+urlParams
        ,width : 300
        ,height : 200
        ,title : title
        ,targetWindow: getCtpTop()
        ,transParams:null
        ,minParam:{show:false}
        ,maxParam:{show:false}
        ,buttons : [ {
            text : "${ctp:i18n('workflow.designer.page.button.ok')}"
            ,handler : function() {
                var text = dialog.getReturnValue();
                try{
	                var result = $.parseJSON(text), condition = [];
	                if(result.checkForm){
	                	var functionName='', byWorkDay=result.byWorkDay;
   						if(type=='date'){
   							if(!byWorkDay){functionName='differDate';}
   							else{functionName='differDateByWorkDay';}
   						}else{
   							if(!byWorkDay){functionName='differDateTime';}
   							else{functionName='differDateTimeByWorkDay';}
   						}
	                    condition.push(functionName);
	                    condition.push("(");
		                if(result.valueType=="1"){
		                    condition.push(getFieldName(formShortName, result.display1));
		                    condition.push(",'"+result.display2+"'");
		                }else if(result.valueType==2){
		                    condition.push(getFieldName(formShortName, result.display1));
		                    condition.push(","+getFieldName(formShortName, result.display2));
		                }
                        condition.push(")");
	                    setTextAreaPosition(createCode,startPos);
	                    addToTextArea(getFormConditionTextArea(), condition.join(""));
	                    handInvokeTranslate();
	                    createCode.focus();
	                    createCode = null;
                        dialog.close();
	                }
	            }catch(e){$.alert(e.message);}
            }
        }, {
            text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
            ,handler : function() {
                createCode.focus();
                createCode = null;
                dialog.close();
            }
        } ]
    });
}

/**
 * 重复表分类合计、分类平均、分类最大、分类最小公共函数。
 */
function sammIfFunction(appName, formApp, formShortName, title, fieldObj, functionName, createCode){
	//修改条件选择框的光标
		var formsonId = fieldObj.ownerTableName.toLowerCase();
        var startPos = 0, endPos = 0;
        var result = getTextAreaPosition(createCode);
        startPos = result.startPos;
        endPos = result.endPos;
        var height = $(getCtpTop().document.body).height();
        if(height-80<460){
            height = height-80;
        }else{
            height = 460;
        }
    	var dialog = $.dialog({
            url : "<c:url value='/workflow/designer.do?method=showWorkflowFormBranchExistSlave'/>&appName=${ctp:escapeJavascript(appName)}&formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName
            ,width : 550
            ,height : height
            ,title : title
            ,targetWindow: getCtpTop()
            ,minParam:{show:false}
            ,maxParam:{show:false}
            ,buttons : [ {
                text : "${ctp:i18n('workflow.designer.page.button.ok')}"
                ,handler : function() {
                    var obj = dialog.getReturnValue();
                    try{
                    	var result = $.parseJSON(obj);
                    	if(result.validate){
                    		setTextAreaPosition(createCode,startPos);
                            addToTextArea(getFormConditionTextArea(), functionName+"('"+getFieldName(formShortName, fieldObj.display)+"',\""+result.expression+"\")");
                            handInvokeTranslate();
                            createCode = null;
                            dialog.close();
                    	}
                    }catch(e){$.alert(e.message);}
                }
            }, {
                text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
                ,handler : function() {
                	createCode = null;
                    dialog.close();
                }
            } ]
        });
}


/**
 * 中文小写和取时间功能
 */
function otherTypeToStringType(appName, title, formApp, functionName, formShortName, fieldObj, createCode){
    //var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    startPos = result.startPos;
    endPos = result.endPos;
    var formsonId = fieldObj.ownerTableName.toLowerCase();
    var fieldName = fieldObj.name;
    var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName+"&fieldName="+fieldName;
	var dialog = $.dialog({
        url : "<c:url value='/workflow/designer.do?method=otherTypeToStringType'/>&appName="+appName+"&"+urlParams
        ,width : 300
        ,height : 200
        ,title : title
        ,targetWindow: getCtpTop()
        ,transParams:{
        	display:fieldObj.display
        	,functionName:functionName
        }
        ,minParam:{show:false}
        ,maxParam:{show:false}
        ,buttons : [ {
            text : "${ctp:i18n('workflow.designer.page.button.ok')}"
            ,handler : function() {
                var text = dialog.getReturnValue();
                try{
	                var result = $.parseJSON(text), condition = [];
	                if(result.checkForm){
                        if(result.textType=="include"||result.textType=="exclude"){
	                        condition.push(result.textType);
	                        condition.push("(");
		                    if(result.valueType=="1"){
		                        condition.push("'text'");
		                        condition.push(","+functionName+"("+getFieldName(formShortName, fieldObj.display)+")");
		                        condition.push(",'"+result.text+"'");
		                    }else if(result.valueType==2){
		                        condition.push("'field'");
		                        condition.push(","+functionName+"("+getFieldName(formShortName, fieldObj.display)+")");
		                        condition.push(","+getFieldName(formShortName, result.display));
		                    }
                        }else if(result.textType=="=="||result.textType=="!="){
                            condition.push("compareField");
                            condition.push("(");
                        	if(result.valueType=="1"){
                                condition.push("'"+result.textType+"'");
                                condition.push(","+functionName+"("+getFieldName(formShortName, fieldObj.display)+")");
                                condition.push(",'"+result.text+"'");
                            }else if(result.valueType==2){
                                condition.push("'"+result.textType+"'");
                                condition.push(","+functionName+"("+getFieldName(formShortName, fieldObj.display)+")");
                                condition.push(","+getFieldName(formShortName, result.display));
                            }
                        }
                        condition.push(")");
	                    setTextAreaPosition(createCode,startPos);
	                    addToTextArea(getFormConditionTextArea(), condition.join(""));
	                    createCode.focus();
	                    handInvokeTranslate();
	                    createCode = null;
                        dialog.close();
	                }
	            }catch(e){$.alert(e.message);}
            }
        }, {
            text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
            ,handler : function() {
                createCode.focus();
                createCode = null;
                dialog.close();
            }
        } ]
    });
}

/**
 * 取日期功能
 */
function getDateFunction(appName, title, formApp, functionName, formShortName, fieldObj, createCode){
    //var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    startPos = result.startPos;
    endPos = result.endPos;
    var formsonId = fieldObj.ownerTableName.toLowerCase();
    var fieldName = fieldObj.name;
    var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName+"&fieldName="+fieldName;
	var dialog = $.dialog({
        url : "<c:url value='/workflow/designer.do?method=getDate'/>&appName="+appName+"&"+urlParams
        ,width : 300
        ,height : 200
        ,title : title
        ,targetWindow: getCtpTop()
        ,transParams:{
        	display:fieldObj.display
        	,functionName:functionName
        }
        ,minParam:{show:false}
        ,maxParam:{show:false}
        ,buttons : [ {
            text : "${ctp:i18n('workflow.designer.page.button.ok')}"
            ,handler : function() {
                var text = dialog.getReturnValue();
                try{
	                var result = $.parseJSON(text), condition = [];
	                if(result.checkForm){
                        if(result.textType=="=="||result.textType=="!="){
                            condition.push("compareDate");
                            condition.push("(");
                        	if(result.valueType=="1"){
                                condition.push("'"+result.textType+"'");
                                condition.push(","+functionName+"("+getFieldName(formShortName, fieldObj.display)+")");
                                condition.push(",'"+result.text+"'");
                            }else if(result.valueType==2){
                                condition.push("'"+result.textType+"'");
                                condition.push(","+functionName+"("+getFieldName(formShortName, fieldObj.display)+")");
                                condition.push(","+getFieldName(formShortName, result.display));
                            }
                        }
                        condition.push(")");
	                    setTextAreaPosition(createCode,startPos);
	                    addToTextArea(getFormConditionTextArea(), condition.join(""));
	                    createCode.focus();
	                    handInvokeTranslate();
	                    createCode = null;
                        dialog.close();
	                }
	            }catch(e){$.alert(e.message);}
            }
        }, {
            text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
            ,handler : function() {
                createCode.focus();
                createCode = null;
                dialog.close();
            }
        } ]
    });
}

/**
 * include和exclude功能，以及== !=功能
 */
function inExcludeFunction(appName, urlParams, functionName, formShortName, fieldObj, createCode, paramObj){
    //var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0, title = '表单文本分支条件设置';
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0, title = '${ctp:i18n("workflow.formBranch.validate.20")}';
    startPos = result.startPos;
    endPos = result.endPos;
    if(functionName=="include"){
    	//title = "包含设置";
    	title = '${ctp:i18n("workflow.formBranch.validate.21")}';
    }else if(functionName=="exclude"){
    	//title = "不包含设置";
    	title = '${ctp:i18n("workflow.formBranch.validate.22")}';
    }else if(functionName=="=="){
        //title = "等于设置";
    	title = '${ctp:i18n("workflow.formBranch.validate.23")}';
    }else if(functionName=="!="){
        //title = "不等于设置";
    	title = '${ctp:i18n("workflow.formBranch.validate.24")}';
    }
	var dialog = $.dialog({
        url : "<c:url value='/workflow/designer.do?method=showWorkflowFormBranchInExcludeFunction'/>&appName="+appName+"&textType="+functionName+"&"+urlParams
        ,width : 300
        ,height : 200
        ,title : title
        ,targetWindow: getCtpTop()
        ,transParams:fieldObj.display
        ,minParam:{show:false}
        ,maxParam:{show:false}
        ,buttons : [ {
            text : "${ctp:i18n('workflow.designer.page.button.ok')}"
            ,handler : function() {
                var text = dialog.getReturnValue();
                try{
	                var result = $.parseJSON(text), condition = [];
	                if(result.checkForm){
                        if(result.textType=="include"||result.textType=="exclude"){
	                        condition.push(result.textType);
	                        condition.push("(");
		                    if(result.valueType=="1"){
		                        condition.push("'text'");
		                        condition.push(","+getFieldName(formShortName, fieldObj.display));
		                        condition.push(",'"+result.text+"'");
		                    }else if(result.valueType==2){
		                        condition.push("'field'");
		                        condition.push(","+getFieldName(formShortName, fieldObj.display));
		                        condition.push(","+getFieldName(formShortName, result.fieldName));
		                    }
                        }else if(result.textType=="=="||result.textType=="!="){
                            condition.push("compareField");
                            condition.push("(");
                        	if(result.valueType=="1"){
                                condition.push("'"+result.textTypeValue+"'");
                                condition.push(","+getFieldName(formShortName, fieldObj.display));
                                condition.push(",'"+result.text+"'");
                            }else if(result.valueType==2){
                                condition.push("'"+result.textTypeValue+"'");
                                condition.push(","+getFieldName(formShortName, fieldObj.display));
                                condition.push(","+getFieldName(formShortName, result.fieldName));
                            }
                        }
                        condition.push(")");
	                    setTextAreaPosition(createCode,startPos);
	                    addToTextArea(getFormConditionTextArea(), condition.join(""));
	                    createCode.focus();
	                    handInvokeTranslate();
	                    createCode = null;
                        dialog.close();
	                }
	            }catch(e){$.alert(e.message);}
            }
        }, {
            text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
            ,handler : function() {
                createCode.focus();
                createCode = null;
                dialog.close();
            }
        } ]
    });
}

/**
 * 取余
 */
function getModFunction(appName, title, formApp, functionName, formShortName, fieldObj, createCode, paramObj){debugger
    //var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    startPos = result.startPos;
    endPos = result.endPos;
    var formsonId = fieldObj.ownerTableName.toLowerCase();
    var fieldName = fieldObj.name;
    var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName+"&fieldName="+fieldName;
	var dialog = $.dialog({
        url : "<c:url value='/workflow/designer.do?method=getMod'/>&appName="+appName+"&"+urlParams
        ,width : 300
        ,height : 200
        ,title : title
        ,targetWindow: getCtpTop()
        ,transParams:fieldObj.display
        ,minParam:{show:false}
        ,maxParam:{show:false}
        ,buttons : [ {
            text : "${ctp:i18n('workflow.designer.page.button.ok')}"
            ,handler : function() {
                var text = dialog.getReturnValue();
                try{
	                var result = $.parseJSON(text), condition = [];
	                if(result.checkForm){
                        condition.push("getMod");
                        condition.push("(");
                        if(result.valueType=="1"){
                            condition.push(getFieldName(formShortName, fieldObj.display));
                            condition.push(","+result.text+"");
                        }else if(result.valueType==2){
                            condition.push(getFieldName(formShortName, fieldObj.display));
                            condition.push(","+getFieldName(formShortName, result.display));
                        }
                        condition.push(")");
	                    setTextAreaPosition(createCode,startPos);
	                    addToTextArea(getFormConditionTextArea(), condition.join(""));
	                    createCode.focus();
	                    handInvokeTranslate();
	                    createCode = null;
                        dialog.close();
	                }
	            }catch(e){$.alert(e.message);}
            }
        }, {
            text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
            ,handler : function() {
                createCode.focus();
                createCode = null;
                dialog.close();
            }
        } ]
    });
}
/**
 * 是否可以设置文本分支条件
 * 文本框、文本标签的文本类型可以，文本域可以
 */
function isCannSetTextCondition(fieldObj, notShowError){
	//var result = false, text = "请选择文本（非数字类型）、文本标签、文本域、文本格式数据关联/关联表单类型的表单域！";
	var result = false, text = "${ctp:i18n('workflow.formBranch.validate.14')}";
	goodFlag : if(fieldObj!=null){
	    var inputType = fieldObj.inputType, fieldType=fieldObj.fieldType.toUpperCase()
        ,toInputType = "", relation="", toFieldType="";
		//如果不是文本型表单域、文本型文本域、文本型标签，那就什么也不做
	    if((inputType=='text' || inputType=='lable' || inputType=='flowdealoption'
	    	|| inputType=="exchangetask" || inputType=="querytask") && (fieldType=='VARCHAR' || fieldType=='LONGTEXT')){
	        result = true;
            break goodFlag;
	    }
	    if(inputType=='textarea'){
	    	result = true;
            break goodFlag;
	    }
        if(inputType=='flowdealoption'){
            result = true;
            break goodFlag;
        }
	    if(isTextRelationOrFormRelationField(fieldObj) && (fieldType=='VARCHAR' || fieldType=='LONGTEXT')){
            result = true;
            break goodFlag;
	    }
	}
    if(result==false && (notShowError==null || notShowError==false)){
        $.alert(text);
    }
	return result;
}
/**
 * 是否不允许拥有点击extend的功能，不允许返回true，允许返回false
 * 数字不允许（数字类型的枚举不可以），文本类型数据关联、关联表单不允许，普通文本不允许，文本域不允许
 */
function isCannotExtendFunction(fieldObj){
	//var result = false,text = "请选择单选、复选、下拉、日期、日期时间、选人、选单位、选部门、选岗位、选职务级别、关联表单(非文本、非数字类型）、数据关联（非文本、非数字类型）类型的表单域!";
	var result = false, text = "${ctp:i18n('workflow.formBranch.validate.15')}";
	if(fieldObj!=null){
		var inputType = fieldObj.inputType, fieldType = fieldObj.fieldType, realType = fieldObj.extraMap.realType;
		if(inputType=='text' || inputType=='lable' || inputType=='textarea'
			|| ((inputType=="exchangetask" || inputType=="querytask") && (fieldType=='VARCHAR' || fieldType=='LONGTEXT'))){
			result = true;
		}
		if((realType=="text" || realType=="lable" || realType=='textarea' || realType=="exchangetask" || realType=="querytask")
          	&& (fieldType=='DECIMAL'||fieldType=='VARCHAR'||fieldType=='LONGTEXT')){
			result = true;
		}
		if(result==false && inputType=='flowdealoption'){
			result = true;
		}
		if(result==false && isTextRelationOrFormRelationField(fieldObj)){
	        result = true;
	    }
	}else{
		result = true;
	}
    if(result){
    	$.alert(text);
    }
	return result;
}
/**
 * 是否是文本、文本域格式的数据关联/表单关联类型的表单域
 */
function isTextRelationOrFormRelationField(fieldObj){
	if(fieldObj){
		var relation, realType;
        if(fieldObj.inputType=='relation' || fieldObj.inputType=='relationform'){
            relation = fieldObj.extraMap.relation;
            realType = fieldObj.extraMap.realType;
           	switch(realType){
           		case 'text':
                case 'textarea':
                case 'lable':
           		case 'exchangetask':
           		case 'querytask':
           		case 'relation':{
           			var fieldType = fieldObj.fieldType;
           			if(fieldType=='VARCHAR' || fieldType=='LONGTEXT'){
                    	return true;
                    }else{
                    	return false;
                    }
           		}
           		default:{
           			return false;
           		}
           	}
        }
	}
	return false;
}
function handInvokeTranslate(){
    if($.browser.chrome && parent.translateBranchInfo){//chrome浏览器，手动调用下这个方法
        parent.translateBranchInfo();
    }
}