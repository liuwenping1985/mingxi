<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%--表单分支条件设置 --%></title>
</head>
<script type="text/javascript">
function showFormFieldsByFormAppId(selectObj){
    $("#myform")[0].submit();
}

$(function() {
    $("#formApp").val("${formBeanId}");
    $("a.workflow_form_branch").click(function() {//左括号
        var realMark = $(this).attr("realMark"), defaultMark=$(this).attr("defaultMark");
        var trim = $.trim(realMark);
        if(trim=="=="||trim=="!="){
            var option = $("#sheetselectForm option:selected");
            if(option.size()>0){
                var fieldName = option.val();
                var fieldObj = fieldMap[fieldName];
                //是重复项表单域，就直接显示出等于号或者不等于号
                if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){
                    appendOperationMarkToCreateCode(defaultMark, realMark);
                    return;
                }
                //是否允许设置文本分支条件
                if(isCannSetTextCondition(fieldObj, true)){
                    var appName = "${ctp:escapeJavascript(appName)}";
                    var formsonId = fieldObj.ownerTableName.toLowerCase();
                    var formApp = "${formBeanId}";
                    var functionName = "compareField", formShortName= getFormShortName();
                    var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName+"&fieldName="+fieldName;
                    inExcludeFunction(appName, urlParams, trim, formShortName, fieldObj, getFormConditionTextArea());
                    return;
                }
            }
        }
        appendOperationMarkToCreateCode(defaultMark, realMark);
    });
    //include/exclude功能
    $("a.workflow_form_inexclude").click(function(){
    	//没有选中的表单表单域，什么也不做
    	var option = $("#sheetselectForm option:selected");
    	if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.5')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.5')}");return;}
        //是否允许设置文本分支条件
        if(!isCannSetTextCondition(fieldObj)){
            return;
        }
        var appName = "${ctp:escapeJavascript(appName)}";
        var formsonId = fieldObj.ownerTableName.toLowerCase();
        var formApp = "${formBeanId}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName+"&fieldName="+fieldName;
    	inExcludeFunction(appName, urlParams, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //sum、aver、max、min功能
    $("a.workflow_form_sumaver").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){
            $.alert("${ctp:i18n('workflow.formBranch.validate.7')}");
            return;
        }
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var addedValue = functionName + "("+getFieldName(formShortName, fieldObj.display)+") ";
        addToTextArea(createCode, addedValue);
        createCode.focus();
        handInvokeTranslate();
    });
    //重复表分类合计、分类平均、分类最大、分类最小
    $("a.workflow_form_sammif").click(function(){
    	//没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){
            $.alert("${ctp:i18n('workflow.formBranch.validate.7')}");
            return;
        }
        //添加值
        var appName = "${ctp:escapeJavascript(appName)}";
        var formApp = "${formBeanId}";
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var title = "${ctp:i18n('workflow.label.branch.repeatTableSum')}";//"重复表分类求和";
        switch(functionName){
        	case "sumif":{title="${ctp:i18n('workflow.formCondition.sumIfLabel')}"/* "重复表分类合计" */;break;}
        	case "averif":{title="${ctp:i18n('workflow.formCondition.averIfLabel')}"/* "重复表分类平均" */;break;}
        	case "maxif":{title="${ctp:i18n('workflow.formCondition.maxIfLabel')}"/* "重复表分类最大" */;break;}
        	case "minif":{title="${ctp:i18n('workflow.formCondition.minIfLabel')}"/* "重复表分类最小" */;break;}
        }
        //调用extend功能函数
        sammIfFunction(appName, formApp, formShortName, title, fieldObj, functionName, getFormConditionTextArea());
    });
    //取整功能
    $("a.workflow_form_im").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){$.alert("${ctp:i18n('workflow.label.dialog.selectDigitField')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var addedValue = functionName + "("+getFieldName(formShortName, fieldObj.display)+") ";
        addToTextArea(createCode, addedValue);
        createCode.focus();
        handInvokeTranslate();
    });
    //取余功能
    $("a.workflow_form_mod").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){$.alert("${ctp:i18n('workflow.label.dialog.selectDigitField')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var title = "${ctp:i18n('form.formula.engin.datefunction.getmod.set.title')}";//'函数设置：取余';
        var appName = "${ctp:escapeJavascript(appName)}";
        var formApp = "${formBeanId}";
        getModFunction(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //中文小写功能
    $("a.toUpper").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){$.alert("${ctp:i18n('workflow.label.dialog.selectDigitField')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var formApp = "${formBeanId}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var title = "${ctp:i18n('workflow.label.branch.upperNumber')}";//"中文数字";
        switch(functionName){
        	case "upUpper":{title="${ctp:i18n('workflow.label.branch.upperNumber')}"/* "中文数字" */;break;}
        	case "date":{title="${ctp:i18n('form.formula.engin.function.help.function.date')}"/* "取日期" */;break;}
        	case "time":{title="${ctp:i18n('form.formula.engin.function.help.function.time')}"/* "取时间" */;break;}
        }
        var appName = "${ctp:escapeJavascript(appName)}";
        otherTypeToStringType(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //取时间的函数
    $("a.datetime").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        var realType = fieldObj.extraMap.realType;
        //如果不是日期或者日期时间类型，那就什么也不做
        //"请选择日期时间类型的表单域！"
        if(realType!='datetime'){$.alert("${ctp:i18n('workflow.label.dialog.selectDateField')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var formApp = "${formBeanId}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var title = "${ctp:i18n('workflow.label.branch.upperNumber')}";//"中文数字";
        switch(functionName){
        	case "upUpper":{title="${ctp:i18n('workflow.label.branch.upperNumber')}";/* "中文数字"; */break;}
        	case "date":{title="${ctp:i18n('form.formula.engin.function.help.function.date')}"/* "取日期" */;break;}
            case "time":{title="${ctp:i18n('form.formula.engin.function.help.function.time')}"/* "取时间" */;break;}
        }
        var appName = "${ctp:escapeJavascript(appName)}";
        otherTypeToStringType(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //取日期的函数
    $("a.date").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        var realType = fieldObj.extraMap.realType;
        //如果不是日期或者日期时间类型，那就什么也不做
        if(realType!='datetime'){$.alert("${ctp:i18n('workflow.label.dialog.selectDateField')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var formApp = "${formBeanId}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var title = "${ctp:i18n('form.formula.engin.function.help.function.date')}";//"取日期";
        var appName = "${ctp:escapeJavascript(appName)}";
        getDateFunction(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //取年月日功能
    $("a.workflow_form_ymrw").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        //"请选择主表的表单域！"
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.label.dialog.selectMainField')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.5')}");return;}
        var realType = fieldObj.extraMap.realType;
        //如果不是日期或者日期时间类型，那就什么也不做
        //"请选择日期或者日期时间类型的表单域！"
        if(realType!='date' && realType!='datetime'){$.alert("${ctp:i18n('workflow.label.dialog.selectDateOrDataTimeField')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var addedValue = functionName + "("+getFieldName(formShortName, fieldObj.display)+") ";
        addToTextArea(createCode, addedValue);
        createCode.focus();
        handInvokeTranslate();
    });
    //日期差函数
    $("a.dateortime").click(function(){
        var appName = "${ctp:escapeJavascript(appName)}";
        var formApp = "${formBeanId}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var urlParams = "formApp="+formApp+"&formsonId=&formShortName="+formShortName;
        dateOrDatetimeCal(appName, urlParams, functionName, formShortName, getFormConditionTextArea());
    });
    $("#formExtend").click(function(){
    	//没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        //是否是不允许点击extend不能设置的类型
        if(isCannotExtendFunction(fieldObj)){
            return;
        }
        //调用extend功能函数
        extendFunction(fieldObj, getFormShortName(), getFormConditionTextArea());
    });
    $("#inBtn").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是重复项表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formson')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        var realType = fieldObj.extraMap.realType;
        if(RealType_Org[realType]){
            inFunction(fieldObj, getFormShortName(), getFormConditionTextArea());
        }else{
        	$.alert("${ctp:i18n('workflow.formBranch.validate.26')}");
        }
    });
    //exist功能
    $("#existFunctionButton").click(function(){
    	//没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        var formsonId = fieldObj.ownerTableName.toLowerCase();
        var formApp = "${formBeanId}";
        var formShortName = getFormShortName();
        //修改条件选择框的光标
        var startPos = 0, endPos = 0, createCode = getFormConditionTextArea();
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
            ,title : "${ctp:i18n('workflow.branch.exist.title')}"
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
                            addToTextArea(getFormConditionTextArea(), "exist(\""+result.expression+"\")");
                            handInvokeTranslate();
                            createCode = null;
                            dialog.close();
                    	}
                    }catch(e){$.alert(e.message);}
                }
            }, {
                text : "${ctp:i18n('workflow.designer.page.button.cancel')}"
                ,handler : function() {
                    dialog.close();
                }
            } ]
        });
    });
    
    $("#userDefinedFunction").click(function(){
        var createCode = getFormConditionTextArea();
        var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
        startPos = result.startPos;
        endPos = result.endPos;
        $.callFormula({
        	appName:'form',
        	catagory:'2',
        	templateCode:'${templateCode}',
        	returnType:'Bool',
            formulaType:'GroovyFunction,JavaFunction',
            formApp : "${formBeanId}",
            onOk:function(v){
                setTextAreaPosition(createCode,startPos);
                addToTextArea(getFormConditionTextArea(), v);
                createCode.focus();
                handInvokeTranslate();
                createCode = null;
            }
        });
    });
    
    
    //查询框
    $('#searchbtn').click(function() {
        search();
    });
    $("#searchtext").keyup(function(event) {
        if (event.keyCode == 13) {
            search();
        }
    });
    //缓存表单字段
    $("#sheetselectForm option").each(function(){
        var text = this.text;
        var oValue = this.value;
        var op = [];
        op[0] = oValue;
        op[1] = text;
        formFieldDatas[formFieldDatas.length] = op;
    });
});

//IE不支持displayNone， 只能进行页面缓存
var formFieldDatas = [];


//查询表单域
function search(){
    var searchText =$("#searchtext").val();
    var newHtml = "";
    for(var i = 0, len = formFieldDatas.length; i < len; i++){
        var op = formFieldDatas[i];
        if(searchText == "" || op[1].indexOf(searchText) != -1){
            newHtml += '<option value="'+op[0]+'">'+op[1]+'</option>';
        }
    }
    $("#sheetselectForm").html(newHtml);
}


/**
 * 添加操作符号到表达式中
 */
function appendOperationMarkToCreateCode(defaultMark,realMark){
    var createCode = getFormConditionTextArea();
    var createCodeValue = createCode.value.trim();
    var startPos = 0, endPos = 0;
    var addedValue = "";
    if(createCodeValue==""){
        addedValue = defaultMark;
    }else{
        addedValue = realMark;
    }
    addToTextArea(createCode, addedValue);
    var result = getTextAreaPosition(createCode);
    startPos = result.startPos;
    endPos = result.endPos;
    var index = addedValue.indexOf("()");
    if(addedValue!=null && index>=0){
        var newIndex = startPos - (addedValue.length-index)+1;
        setTextAreaPosition(createCode,newIndex);
    }
    createCode.focus();
}

/**
 * 显示表单字段页面
 */
function showFormfieldExpresion(){
    var formShortName= getFormShortName();
    $("#sheetselectForm option:selected").each(function(){
    	var fieldName = $(this).val();
    	var fieldObj = fieldMap[fieldName];
	  	var createCode = getFormConditionTextArea();
        var createCodeValue = createCode.value.trim();
        var startPos = 0, endPos = 0;
        var addedValue = "";
        addedValue = openWindowByType(fieldObj,formShortName);
        if(addedValue!=""){
	        addToTextArea(createCode, addedValue);
	        if($.browser.chrome && parent.translateBranchInfo){//chrome浏览器，手动调用下这个方法
                parent.translateBranchInfo();
            }
	        var result = getTextAreaPosition(createCode);
		    startPos = result.startPos;
		    endPos = result.endPos;
	        createCode.selectionStart= startPos;
	        createCode.selectionEnd= endPos;
        }
        createCode.focus();
        tempThis = createCode = null;
    });
}

function openWindowByType(fieldObj,formShortName){
    if(!fieldObj){
        return "";
    }
    //只有主表字段才能直接显示在条件设置框里
    var tempInputType = fieldObj.inputType.toLowerCase(), tempFieldType = fieldObj.fieldType.toLowerCase(),realType= fieldObj.extraMap.realType.toLowerCase();
    if((realType=="text" || tempInputType=="text"||tempInputType=="lable"||tempInputType=="relation"
        ||tempInputType=="relationform" || tempInputType=="customcontrol")
        &&tempFieldType=="decimal" && fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){
        return getFieldName(formShortName, fieldObj.display);
    } else {
    	return "";
    }
}
function getFormConditionTextArea(){
    return $("#creatcode",window.parent.document)[0];
}
function getFormShortName(){
	return "";//$("#formApp option:selected").attr("shortName")+"_";
}
//表单域数据
var fieldArray = ${fieldJSON};
var fieldMap = {};
if(fieldArray!=null && fieldArray.length>0){
	for(var i=0,len=fieldArray.length; i<len; i++){
		fieldMap[fieldArray[i].name] = fieldArray[i];
        fieldMap[fieldArray[i].display] = fieldArray[i];
	}
}
</script>
<%@ include file="/WEB-INF/jsp/ctp/workflow/operateTextAreaApi.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<body>
<form id="myform" name="myform" action="<c:url value='/workflow/designer.do?method=showWorkflowFormBranchSettingPage&formApp=${formBean.id}'/>" method="post">
<table width="100%" border="0" align="center">
    <tr>
    <td width="60%" class="margin_t_5">
            <span id="showsearch">
                <input type="text" id="searchtext" style="width:40%;"/>
                <span class="ico16 search_16" id="searchbtn" href="javascript:void(0)"></span> 
            </span>
        </td>  
      <td>&nbsp;</td>
    </tr>
    <tr>
        
        <td width="60%" valign="top">
            <select id="sheetselectForm" name="sheetselectForm" size="10" ondblclick="showFormfieldExpresion()"  style="width: 300px; height: 368px;" multiple="multiple" class="font_size12">
                <c:forEach items="${fieldList}" var="field">
                    <option value="${field[1]}">${field[0]}</option>
                </c:forEach>
            </select>
        </td>
        <td width="40%" valign="top">
            <table align="center" border="0" width="90%">
              <tr>
                  <td width="25%"><a id="plusBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" + " realMark=" + "><span class="plus_16"></span></a></td>
                  <td width="25%"><a id="minusBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" - " realMark=" - "><span class="minus_16"></span></a></td>
                  <td width="25%"><a id="multiplyBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark="*" realMark="*"><span class="multiply_16"></span></a></td>
                  <td width="25%"><a id="divideBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark="/" realMark="/"><span class="divide_16"></span></a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td width="25%"><a id="bracklBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark="(" realMark=" ( "><span class="brackl_16"></span></a></td>
                  <td width="25%"><a id="brackrBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=")" realMark=" ) "><span class="brackr_16"></span></a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td width="25%"><a id="gtBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" > " realMark=" > "><span class="gt_16"></span></a></td>
                  <td width="25%"><a id="gt_eq_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" >= " realMark=" >= "><span class="gt_eq_16 w32 "></span></a></td>
                  <td width="25%"><a id="ltBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" < " realMark=" < "><span class="lt_16"></span></a></td>
                  <td width="25%"><a id="lt_eq_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" <= " realMark=" <= "><span class="lt_eq_16 w32"></span></a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td width="25%"><a id="equalBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" == " realMark=" == "><span class="equal_16"></span></a></td>
                  <td width="25%"><a id="brack_angle_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" != " realMark=" != "><span class="brack_angle_16 w32"></span></a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td width="25%"><a id="andBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" && " realMark=" && ">and</a></td>
                  <td width="25%"><a id="orBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" || " realMark=" || ">or</a></td>
                  <%--<td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_branch" defaultMark=" ^ " realMark=" ^ ">xor</a></td>--%>
                  <td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_branch" defaultMark=" !" realMark=" !">not</a></td>
                  <td width="25%"><a id="inBtn" href="javascript:void(0)" class="form_btn workflow_form_infunction" defaultMark="in" realMark=" in">in</a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_inexclude" functionName="include" functionText="${ctp:i18n('workflow.formCondition.includeLabel')}">${ctp:i18n('workflow.formCondition.includeLabel')}</a></td>
                  <td width="50%" colspan="2"><a id="" href="javascript:void(0)" class="form_btn w89 workflow_form_inexclude" functionName="exclude" functionText="${ctp:i18n('workflow.formCondition.excludeLabel')}">${ctp:i18n('workflow.formCondition.excludeLabel')}</a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td colspan="2" width="50%"><a id="formExtend" class="form_btn w89" href="javascript:void(0)" defaultMark="" realMark="">extend</a></td>
                  <td colspan="2" width="50%"><a id="existFunctionButton" class="form_btn w89" href="javascript:void(0)" defaultMark="exist()" realMark=" exist() ">${ctp:i18n('workflow.formCondition.existLabel')}</a></td>
              </tr>
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_sumaver" href="javascript:void(0)" functionName="sum" >${ctp:i18n('workflow.formCondition.sumLabel')}</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_sumaver" href="javascript:void(0)" functionName="aver">${ctp:i18n('workflow.formCondition.averLabel')}</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_sumaver" href="javascript:void(0)" functionName="max" >${ctp:i18n('workflow.formCondition.maxLabel')}</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_sumaver" href="javascript:void(0)" functionName="min">${ctp:i18n('workflow.formCondition.minLabel')}</a></td>
              </tr><c:if test="${isA6!=true }">
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_sammif" href="javascript:void(0)" functionName="sumif" >${ctp:i18n('workflow.formCondition.sumIfLabel')}</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_sammif" href="javascript:void(0)" functionName="averif">${ctp:i18n('workflow.formCondition.averIfLabel')}</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_sammif" href="javascript:void(0)" functionName="maxif" >${ctp:i18n('workflow.formCondition.maxIfLabel')}</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_sammif" href="javascript:void(0)" functionName="minif">${ctp:i18n('workflow.formCondition.minIfLabel')}</a></td>
              </tr></c:if>
              <%--
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_im" href="javascript:void(0)" functionName="getInt" >取整数</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_mod" href="javascript:void(0)" functionName="getMod">取余数</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_ymrw" href="javascript:void(0)" functionName="year" >取年</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_ymrw" href="javascript:void(0)" functionName="month">取月</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 workflow_form_ymrw" href="javascript:void(0)" functionName="day" >取日</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 workflow_form_ymrw" href="javascript:void(0)" functionName="weekday">取星期几</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 dateortime" href="javascript:void(0)" functionName="date" >日期差</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 dateortime" href="javascript:void(0)" functionName="datetime">日期时间差</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 toUpper" href="javascript:void(0)" functionName="toUpper">中文小写</a></td>
              </tr>
              <tr>
                  <td colspan="2" width="50%"><a id="sumBtn" class="form_btn w89 date" href="javascript:void(0)" functionName="date" >取日期</a></td>
                  <td colspan="2" width="50%"><a id="averBtn" class="form_btn w89 datetime" href="javascript:void(0)" functionName="time">取时间</a></td>
              </tr>--%>
              <c:if test="${hasUserDefinedFunction == true}">
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                <td colspan="4"><a id="userDefinedFunction" class="form_btn w89" title="${ctp:i18n('workflow.formCondition.customfunctionLabel')}" href="javascript:void(0)">${ctp:i18n('workflow.formCondition.customfunctionLabel')}</td>
              </tr>
              </c:if>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>