<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%-- 公文分支条件设置 --%></title>
</head>
<body>
<table width="100%" border="0" align="center">
    <tr>
        <td width="60%" valign="top">
            <select id="edocFieldSelect" style="width: 300px; height: 260px;" multiple="multiple" class="font_size12" onclick="showFormfieldExpresion()">
                <c:forEach items="${fieldList}" var="field">
                    <option value="${field.display}">${field.display}<c:if test="${field.inputType=='select'}">(${ctp:i18n('workflow.label.branch.enumType')}<%--枚举类型--%>)</c:if></option>
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
              </tr>
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
<script type="text/javascript">
//单元格数据
var fieldArray = ${fieldJSON};
var fieldMap = {};
if(fieldArray!=null && fieldArray.length>0){
    for(var i=0,len=fieldArray.length; i<len; i++){
        fieldMap[fieldArray[i].name] = fieldArray[i];
        fieldMap[fieldArray[i].display] = fieldArray[i];
    }
}
$("a.workflow_form_branch").click(function() {//左括号
    appendOperationMarkToCreateCode($(this).attr("defaultMark"),$(this).attr("realMark"));
});
//sum、aver功能
$("a.workflow_form_sumaver").click(function(){
    //没有选中的表单单元格，什么也不做
    var option = $("#sheetselectForm option:selected");
    if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return}
    var fieldName = option.val();
    var fieldObj = fieldMap[fieldName];
    //是主表单元格，什么也不做
    if(fieldObj.ownerTableName.toLowerCase().indexOf('formmain')>-1){$.alert("${ctp:i18n('workflow.formBranch.validate.6')}");return;}
    //如果不是数字类型，那就什么也不做
    if(fieldObj.fieldType.toLowerCase()!="decimal"){
        $.alert("${ctp:i18n('workflow.formBranch.validate.7')}");
        return;
    }
    //添加值
    var createCode = getFormConditionTextArea();
    var functionName = $(this).attr("functionName"), formShortName= getFormShortName();
    var addedValue = functionName + "("+formShortName+fieldObj.display+") ";
    addToTextArea(createCode, addedValue);
    createCode.focus();
    handInvokeTranslate();
});

function showFormfieldExpresion(){
    var selectedOption = $("#edocFieldSelect option:selected");
    if(selectedOption.size()==0){
        $.alert("${ctp:i18n('workflow.formBranch.validate.12')}");
        return;
    }
    var fieldName = selectedOption.val();
    var fieldObj = fieldMap[fieldName];
    if(fieldObj==null){
        return;
    }
    if(fieldObj.inputType!='select'){
        var createCode = getFormConditionTextArea();
        var createCodeValue = createCode.value.trim();
        var startPos = 0, endPos = 0;
        var addedValue = "";
        addedValue = openWindowByType(fieldObj,getFormShortName());
        if(addedValue!=""){
            addToTextArea(createCode, addedValue);
            var result = getTextAreaPosition(createCode);
            startPos = result.startPos;
            endPos = result.endPos;
            createCode.selectionStart= startPos;
            createCode.selectionEnd= endPos;
        }
        createCode.focus();
        handInvokeTranslate();
        tempThis = createCode = null;
        return;
    }
    //修改条件选择框的光标
    var startPos = 0, endPos = 0, createCode = getFormConditionTextArea();
    var result = getTextAreaPosition(createCode);
    startPos = result.startPos;
    endPos = result.endPos;
    if(fieldObj!=null){
        var dialog = $.dialog({
            url : "<c:url value='/workflow/designer.do?method=showWorkflowEdocBranchEnumPage'/>&enumId="+fieldObj.enumId
            ,width : 300
            ,height : 200
            ,title : "${ctp:i18n('workflow.formBranch.validate.13')}"
            ,targetWindow: getCtpTop()
            ,minParam:{show:false}
            ,maxParam:{show:false}
            ,buttons : [ {
                text : "${ctp:i18n('workflow.designer.page.button.ok')}"
                ,handler : function() {
                    var text = dialog.getReturnValue();
                    if(text!=null){
                        try{
                            setTextAreaPosition(createCode,startPos);
                            addToTextArea(getFormConditionTextArea(), "{"+getFormShortName()+fieldName+"}" + text);
                            dialog.close();
                            createCode.focus();
                            handInvokeTranslate();
                            createCode = null;
                        }catch(e){$.alert(e.message);}
                    }
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
    handInvokeTranslate();
}
function getFormConditionTextArea(){
	return $("#creatcode",window.parent.document)[0];
}

function openWindowByType(fieldObj,formShortName){
    if(!fieldObj){
        return ;
    }
    //只有主表字段才能直接显示在条件设置框里
    if(fieldObj.fieldType.toLowerCase()=="decimal"){
        return "{"+formShortName+fieldObj.display+"}";
    } else {
        return "";
    }
}
function getFormShortName(){
    return "";
}

$("#userDefinedFunction").click(function(){
    var createCode = getFormConditionTextArea();
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    startPos = result.startPos;
    endPos = result.endPos;
    $.callFormula({
    	appName:'edoc',
    	catagory:'3',
    	templateCode:'${templateCode}',
    	returnType:'Bool',
        formulaType:'GroovyFunction,JavaFunction',
        formApp : "${formAppId}",
        onOk:function(v){
            setTextAreaPosition(createCode,startPos);
            addToTextArea(getFormConditionTextArea(), v);
            createCode.focus();
            handInvokeTranslate();
            createCode = null;
        }
    });
});
</script>
<%@ include file="/WEB-INF/jsp/ctp/workflow/operateTextAreaApi.jsp"%>
</body>
</html>