<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('office.template.branch.js')}</title>
</head>
<script type="text/javascript">
$(function() {
    $("a.workflow_form_branch").click(function() {//左括号
        var realMark = $(this).attr("realMark"), defaultMark=$(this).attr("defaultMark");
        var trim = $.trim(realMark);
        if(trim=="=="||trim=="!="){
            var option = $("#sheetselectForm option:selected");
            if(option.size()>0){
                var fieldName = option.val();
                var fieldObj = fieldMap[fieldName];
                if(fieldObj.inputType != "text"){
                  $.alert($.i18n('office.template.branch.validate0.js'));
                  return;
                }
                fieldObj.textType = trim;
                officeExtend(fieldObj, getFormShortName(), getFormConditionTextArea());
                return;
            }
        }
        appendOperationMarkToCreateCode(defaultMark, realMark);
    });
    
    //include/exclude功能
    $("a.workflow_form_inexclude").click(function(){
    	var option = $("#sheetselectForm option:selected");
    	if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.5')}");return;}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        if(fieldObj.inputType != "text"){
          $.alert($.i18n('office.template.branch.validate0.js'));
          return;
        }
        var functionName = $(this).attr("functionName");
        var trim = $.trim(functionName);
        fieldObj.textType = functionName;
        officeExtend(fieldObj, getFormShortName(), getFormConditionTextArea());
    });
    
    $("#formExtend").click(function(){
    	//没有选中的表单表单域，什么也不做
        var option = $("#sheetselectForm option:selected");
        if(option.size()<=0){$.alert("${ctp:i18n('workflow.formBranch.validate.8')}");return;}
        var fieldName = option.val();
        var fieldObj = fieldMap[fieldName];
        if(fieldObj.inputType == "text"){
          $.alert($.i18n('office.template.branch.validate1.js'));
          return;
        }
        //调用extend功能函数
        officeExtend(fieldObj, getFormShortName(), getFormConditionTextArea());
    });
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
}

function getFormShortName(){
	return "";
}

function getFormConditionTextArea(){
    return $("#creatcode",window.parent.document)[0];
}

//表单域数据
var fieldArray = [];
<c:forEach items="${officeFields}" var="field">
    fieldArray[fieldArray.length] = {"name":"${field.name}","display":"${field.display}","fieldType":"${field.fieldType}","inputType":"${field.inputType}","textType":"${field.textType}","enumId":"${field.enumId}"};
</c:forEach>
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
  <form id="myform" name="myform" action="<c:url value='/workflow/designer.do?method=showWorkflowFormBranchSettingPage'/>" method="post">
    <table width="100%" border="0" align="center">
      <tr>
        <td width="60%" valign="top">
          <select id="sheetselectForm" name="sheetselectForm" size="10" style="width: 300px; height: 230px;" multiple="multiple" class="font_size12">
            <c:forEach items="${officeFields}" var="field">
              <option value="${field.name}">${field.inputTypeDisplay}</option>
            </c:forEach>
          </select>
        </td>
        <td width="40%" valign="top">
          <table align="center" border="0" width="90%">
            <tr>
              <td width="25%"><a id="bracklBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark="(" realMark=" ( "><span class="brackl_16"></span></a></td>
              <td width="25%"><a id="brackrBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=")" realMark=" ) "><span class="brackr_16"></span></a></td>
            </tr>
            <tr height="3">
              <td colspan="5" align="center"></td>
            </tr>
            <tr>
              <td width="25%"><a id="equalBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" == " realMark=" == "><span class="equal_16"></span></a></td>
              <td width="25%"><a id="brack_angle_Btn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" != " realMark=" != "><span class="brack_angle_16 w32"></span></a></td>
            </tr>
            <tr height="3">
              <td colspan="5" align="center"></td>
            </tr>
            <tr>
              <td width="25%"><a id="andBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" && " realMark=" && ">and</a></td>
              <td width="25%"><a id="orBtn" class="form_btn workflow_form_branch" href="javascript:void(0)" defaultMark=" || " realMark=" || ">or</a></td>
            </tr>
            <tr height="3">
              <td colspan="5" align="center"></td>
            </tr>
            <tr>
              <td width="25%"><a id="" href="javascript:void(0)" class="form_btn workflow_form_inexclude" functionName="include" functionText="${ctp:i18n('workflow.formCondition.includeLabel')}">${ctp:i18n('workflow.formCondition.includeLabel')}</a></td>
              <td width="50%" colspan="2"><a id="" href="javascript:void(0)" class="form_btn w89 workflow_form_inexclude" functionName="exclude" functionText="${ctp:i18n('workflow.formCondition.excludeLabel')}">${ctp:i18n('workflow.formCondition.excludeLabel')}</a></td>
            </tr>
            <tr height="3">
              <td colspan="5" align="center"></td>
            </tr>
            <tr>
              <td colspan="2" width="50%"><a id="formExtend" class="form_btn w89" href="javascript:void(0)" defaultMark="" realMark="">extend</a></td>
              <td colspan="2" width="50%">&nbsp;</td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </form>
</body>
</html>