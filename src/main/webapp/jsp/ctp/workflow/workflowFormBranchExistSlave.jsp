<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>表单重复项分支条件设计</title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
<body class="h100b padding_5">
    <table width="100%" border="0" align="center">
    <tr>
        <td class="font_size12">${ctp:i18n('workflow.branch.setbranchcondition.label')}:</td>
    </tr>
    <tr>
        <td>
            <div class="common_txtbox  clearfix">
                <textarea id="conditionTextarea" name="conditionTextarea" class="padding_5" style="width:510px;height:100px;"></textarea>
            </div>
        </td>
    </tr>
    <tr></tr>
    <tr>
       <td height="260">
          <table width="100%" border="0" align="center">
            <tr>
                <td width="60%" valign="top">
                    <select id="sheetselectForm" name="sheetselectForm" size="10" ondblclick="showFormfieldExpresion()"  style="width: 300px; height: 270px;" multiple="multiple" class="font_size12">
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
                      <tr height="10"><td colspan="5" align="center"></td></tr>
                      <tr>
                          <td width="25%"><a id="bracklBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark="(" realMark=" ( "><span class="brackl_16"></span></a></td>
                          <td width="25%"><a id="brackrBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=")" realMark=" ) "><span class="brackr_16"></span></a></td>
                      </tr>
                      <tr height="10"><td colspan="5" align="center"></td></tr>
                      <tr>
                          <td width="25%"><a id="gtBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" > " realMark=" > "><span class="gt_16"></span></a></td>
                          <td width="25%"><a id="gt_eq_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" >= " realMark=" >= "><span class="gt_eq_16 w32 "></span></a></td>
                          <td width="25%"><a id="ltBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" < " realMark=" < "><span class="lt_16"></span></a></td>
                          <td width="25%"><a id="lt_eq_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" <= " realMark=" <= "><span class="lt_eq_16 w32"></span></a></td>
                      </tr>
                      <tr height="10"><td colspan="5" align="center"></td></tr>
                      <tr>
                          <td width="25%"><a id="equalBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" == " realMark=" == "><span class="equal_16"></span></a></td>
                          <td width="25%"><a id="brack_angle_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" != " realMark=" != "><span class="brack_angle_16 w32"></span></a></td>
                      </tr>
                      <tr height="10"><td colspan="5" align="center"></td></tr>
                      <tr>
                          <td width="25%"><a id="andBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" && " realMark=" && ">and</a></td>
                          <td width="25%"><a id="orBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" || " realMark=" || ">or</a></td>
                          <%--<td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_branch" defaultMark=" ^ " realMark=" ^ ">xor</a></td>--%>
                          <td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_branch" defaultMark=" !" realMark=" !">not</a></td>
                  <td width="25%"><a id="inBtn" href="javascript:void(0)" class="form_btn workflow_form_infunction" defaultMark="in" realMark=" in">in</a></td>
                      </tr>
                      <tr height="10"><td colspan="5" align="center"></td></tr>
                      <tr>
                          <td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_inexclude" functionName="include" functionText="${ctp:i18n('workflow.formCondition.includeLabel')}">${ctp:i18n('workflow.formCondition.includeLabel')}</a></td>
                          <td width="50%" colspan="2"><a id="" href="javascript:void(0)" class="form_btn w89 workflow_form_inexclude" functionName="exclude" functionText="${ctp:i18n('workflow.formCondition.excludeLabel')}">${ctp:i18n('workflow.formCondition.excludeLabel')}</a></td>
                      </tr>
                      <tr height="10"><td colspan="5" align="center"></td></tr>
                      <tr>
                          <td colspan="2" width="50%"><a id="formExtend" class="form_btn w89" href="javascript:void(0)" defaultMark="" realMark="">extend</a></td>
                      </tr>
                      <tr height="10"><td colspan="5" align="center"></td></tr><%--
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
                    </table>
                </td>
            </tr>
        </table>
       </td>
    </tr>
</table>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function(){
	//按钮事件的添加
    $("a.workflow_form_branch").click(function() {//左括号
        var realMark = $(this).attr("realMark"), defaultMark=$(this).attr("defaultMark");
        var trim = $.trim(realMark);
        if(trim=="=="||trim=="!="){
            var option = $("#sheetselectForm option:selected");
            if(option.size()>0){
                var fieldName = option.val();
                var fieldObj = fieldMap[fieldName];
                //是否允许设置文本分支条件
                if(isCannSetTextCondition(fieldObj, true)){
                    var functionName = "compareField";
                    var formsonId = fieldObj.ownerTableName.toLowerCase();
                    var formApp = "${formBean.id}";
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
	    if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.9')}");return}
	    var fieldName = option.val();
	    var fieldObj = fieldMap[fieldName];
	    //是否允许设置文本分支条件
        if(!isCannSetTextCondition(fieldObj)){
            return;
        }
	    var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText");
        var formsonId = fieldObj.ownerTableName.toLowerCase();
        var formApp = "${formBean.id}";
        var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName+"&fieldName="+fieldName;
        inExcludeFunction(appName, urlParams, functionName, formShortName, fieldObj, getFormConditionTextArea());
	});
    //取整功能
    $("a.workflow_form_im").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){$.alert("${ctp:i18n('请选择数字类型的表单域！')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var addedValue = functionName + "("+getFieldName(formShortName, fieldObj.display)+") ";
        addToTextArea(createCode, addedValue);
        createCode.focus();
    });
    //取余功能
    $("a.workflow_form_mod").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){$.alert("${ctp:i18n('请选择数字类型的表单域！')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var title = '函数设置：取余';
        var appName = "${appName}";
        var formApp = "${formBean.id}";
        getModFunction(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //取年月日功能
    $("a.workflow_form_ymrw").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        var realType = fieldObj.extraMap.realType;
        //如果不是日期或者日期时间类型，那就什么也不做
        if(realType!='date' && realType!='datetime'){$.alert("请选择日期或者日期时间类型的表单域！");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
        var addedValue = functionName + "("+getFieldName(formShortName, fieldObj.display)+") ";
        addToTextArea(createCode, addedValue);
        createCode.focus();
    });
    //日期差函数
    $("a.dateortime").click(function(){
        var appName = "${appName}";
        var formsonId = "${formsonId}";
        var formApp = "${formBean.id}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var urlParams = "formApp="+formApp+"&formsonId="+formsonId+"&formShortName="+formShortName;
        dateOrDatetimeCal(appName, urlParams, functionName, formShortName, getFormConditionTextArea());
    });
    //中文小写功能
    $("a.toUpper").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        //如果不是数字类型，那就什么也不做
        if(fieldObj.fieldType.toLowerCase()!="decimal"){$.alert("${ctp:i18n('请选择数字类型的表单域！')}");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var formApp = "${formBean.id}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var title = "中文数字";
        switch(functionName){
        	case "upUpper":{title="中文数字";break;}
        	case "date":{title="取日期";break;}
        	case "time":{title="取时间";break;}
        }
        var appName = "${appName}";
        otherTypeToStringType(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //取时间的函数
    $("a.datetime").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        var realType = fieldObj.extraMap.realType;
        //如果不是日期或者日期时间类型，那就什么也不做
        if(realType!='datetime'){$.alert("请选择日期时间类型的表单域！");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var formApp = "${formBean.id}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var title = "中文数字";
        switch(functionName){
        	case "upUpper":{title="中文数字";break;}
        	case "date":{title="取日期";break;}
        	case "time":{title="取时间";break;}
        }
        var appName = "${appName}";
        otherTypeToStringType(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    //取日期的函数
    $("a.date").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        var realType = fieldObj.extraMap.realType;
        //如果不是日期或者日期时间类型，那就什么也不做
        if(realType!='datetime'){$.alert("请选择日期时间类型的表单域！");return;}
        //添加值
        var createCode = getFormConditionTextArea();
        var formApp = "${formBean.id}";
    	var functionName = $(this).attr("functionName"), functionText = $(this).attr("functionText"), formShortName= getFormShortName();
    	var title = "取日期";
        var appName = "${appName}";
        getDateFunction(appName, title, formApp, functionName, formShortName, fieldObj, getFormConditionTextArea());
    });
    $("#inBtn").click(function(){
        //没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        //是主表表单域，什么也不做
        if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
        var realType = fieldObj.extraMap.realType;
        if(RealType_Org[realType]){
            inFunction(fieldObj, getFormShortName(), getFormConditionTextArea());
        }else{
        	$.alert("${ctp:i18n('workflow.formBranch.validate.26')}");
        }
    });
});
$("#formExtend").click(function(){
    //没有选中的表单表单域，什么也不做
    var option = $("#sheetselectForm option:selected");
    if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.10')}");return}
    var fieldName = option.val();
    var fieldObj = fieldMap[fieldName];
    //是主表表单域，什么也不做
    if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){return;}
    //是否是不允许点击extend不能设置的类型
    if(isCannotExtendFunction(fieldObj)){
        return;
    }
    //添加值
    extendFunction(fieldObj, formShortName, getFormConditionTextArea());
});
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
    createCode = null;
}

/**
 * 显示表单字段页面
 */
function showFormfieldExpresion(){
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
        return ;
    }
    if((fieldObj.inputType.toLowerCase()=="text"||fieldObj.inputType.toLowerCase()=="lable"
        ||fieldObj.inputType.toLowerCase()=="relation"
          ||fieldObj.inputType.toLowerCase()=="relationform")
        &&fieldObj.fieldType.toLowerCase()=="decimal"){
        return getFieldName(formShortName, fieldObj.display);
    } else {
        return "";
    }
}
function getFormShortName(){
	return formShortName;
}
function getFormConditionTextArea(){
	return $("#conditionTextarea")[0];
}
//表单域数据
var fieldArray = ${fieldJSON};
var fieldMap = {};
var formShortName = "${formShortName}";
if(fieldArray!=null && fieldArray.length>0){
    for(var i=0,len=fieldArray.length; i<len; i++){
        fieldMap[fieldArray[i].name] = fieldArray[i];
        fieldMap[fieldArray[i].display] = fieldArray[i];
    }
}
var appName = "${appName}";
<%@ include file="/WEB-INF/jsp/ctp/workflow/operateTextAreaApi.jsp"%>
function OK(){
	var expression = $("#conditionTextarea").val();
	var wfAjax= new WFAjax();
	//expression = expression.replace(/"/g,'\'');
	if(expression==null||$.trim(expression)==""){
		$.alert("${ctp:i18n('workflow.branch.condition.mustset')}");
		return $.toJSON({validate:false});
	}
	var resp = wfAjax.validateWorkflowAutoCondition(appName, "${formApp}", expression, false);
	if(resp!=null){
        var result = {"expression":expression,"validate":true};
		if(resp[0]!=true && resp[0]!="true"){
			if(resp[1]){
				$.alert(resp[1]);
                result.validate = false;
			}else{
				result.validate = false;
				$.alert("${ctp:i18n('workflow.formBranch.validate.11')}");
			}
		}
        return $.toJSON(result);
	}
}
</script>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
</body>
</head>