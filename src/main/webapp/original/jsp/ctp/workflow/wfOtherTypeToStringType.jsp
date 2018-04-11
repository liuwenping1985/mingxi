<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title><%-- 包含/不包含条件设置 --%></title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
<body class="h100b over_hidden">
<div class="form_area padding_5">
        <table border="0" cellSpacing="0" cellPadding="0" width="100%">
          <tbody>
          <tr height="40">
            <td>
                <div class="common_radio_box clearfix align_right">
                    <label class="margin_r_10 hand">
                         ${ctp:i18n('workflow.formBranch.formdatafield') }
                    </label>
                </div>
            </td>
            <td width="70%">
	            <div id="valueType1Content" class="common_radio_box clearfix">
	                
	            </div>
            </td>
          </tr>
          <tr id="operationTr">
       		<th nowrap="nowrap">
              <label class="margin_r_10" for="text">${ctp:i18n('workflow.formBranch.operator') }:</label></th>
              <td width="70%">
                  <div class="common_selectbox_wrap">
                      <select id="textType">
                      		<option value="include">${ctp:i18n("workflow.designer.include")}<!-- 包含 --></option>
                      		<option value="exclude">${ctp:i18n("workflow.designer.exclude")}<!-- 不包含 --></option>
                      		<option value="==">=</option>
                          	<option value="!=">&lt;&gt;</option>
                      </select>
                  </div>
              </td>
          </tr>
          <tr height="40">
            <td>
                <div class="common_radio_box clearfix align_right">
                    <label class="margin_r_10 hand" for="valueType1">
                        <input id="valueType1" class="radio_com" name="type" value="1" type="radio" checked="checked">${ctp:i18n('workflow.formBranch.manualInput') }
                    </label>
                </div>
            </td>
            <td width="70%">
            <div id="type1Content" class="common_txtbox_wrap">
                <input id="text1" name="text1" value="" class="validate" validate="type:'string',name:'${ctp:i18n('workflow.formBranch.manualInput.vLabel') }',notNull:false,isDeaultValue:true,character:'~!@#$%^&*()_+=&#34;\'{}[]\\/?|:\'&#34;',maxLength:255">
            </div>
            </td>
          </tr>
          <tr height="40">
            <td>
                <div class="common_radio_box clearfix align_right">
                    <label class="margin_r_10 hand" for="valueType2">
                        <input id="valueType2" class="radio_com" name="type" value="2" type="radio">${ctp:i18n('workflow.formBranch.formfield') }
                    </label> 
                </div>
            </td>
            <td width="70%"><div id="type2Content" class="common_selectbox_wrap">
                <select id="fieldNameSelect" name="fieldName">
                    <option value="">&nbsp;</option>
                    <c:forEach items="${fieldList}" var="field">
                         <option value="${field[1]}">${field[0]}</option>
                    </c:forEach>
                </select>
            </div>
            </td>
          </tr>
          </tbody>
         </table>
    </div>
<script type="text/javascript">
$("#text1").focus();
if(window.dialogArguments){
	var functionName = window.dialogArguments.functionName;
	var display = window.dialogArguments.display;
	var string = functionName+'('+display+')';
    $("#valueType1Content").text(string);
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
function OK(){
	var checkForm = true;
	var valueType = $("#valueType1").prop("checked")?$("#valueType1").val():$("#valueType2").val();
	if(valueType==1){
	    if(!$("#type1Content").validate({})){
	        checkForm = false;
	        return $.toJSON({"checkForm":checkForm});
	    }
	}else{
        if($("#fieldNameSelect").val()==""){
            //$.alert("没有同类型的表单域，请设置值！");
            $.alert("${ctp:i18n('workflow.formBranch.validate.1') }");
            checkForm = false;
            return $.toJSON({"checkForm":checkForm});
        }
	}
	var resultObj = {};
	resultObj.checkForm = checkForm;
	resultObj.valueType = valueType;
	resultObj.textType = $("#textType").val();
	resultObj.text = $("#text1").val();
	var secondFieldName = $("#fieldNameSelect").val();
	var secondFieldObj = fieldMap[secondFieldName];
	if(secondFieldObj!=null){
		resultObj.display = secondFieldObj.display;
	}
    return $.toJSON(resultObj);
}
</script>
</body>
</html>