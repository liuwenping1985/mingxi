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
                <input id="textType" name="textType" type="hidden" value="${textType}"/>
            </td>
          </tr>
          <tr height="40" onclick="selectRadio1('valueType1')">
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
          <tr height="40" onclick="selectRadio1('valueType2')">
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
var textTypeVar = $("#textType").val();
if(window.dialogArguments){
    $("#valueType1Content").text(window.dialogArguments);
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
	var fieldName = $("#fieldNameSelect").val();
	var fieldObj = fieldMap[fieldName], fieldDisplay = fieldObj!=null?fieldObj.display:"";
	if(textTypeVar=="include" || textTypeVar=="exclude"){
        resultObj = {"checkForm":checkForm, 
            "text":$("#text1").val(), 
            "valueType":valueType, 
            "fieldName":fieldDisplay, 
            "textType":$("#textType").val()}
    } else if(textTypeVar=="=="||textTypeVar=="!="){
        resultObj = {"checkForm":checkForm, 
            "text":$("#text1").val(), 
            "valueType":valueType, 
            "fieldName":fieldDisplay, 
            "textType":$("#textType").val(),
            "textTypeValue":textTypeVar}
    }
    return $.toJSON(resultObj);
}

function selectRadio1(id){
  var tempObj = $("#"+id);
  if(tempObj.size()>0){
      tempObj.prop("checked", true);
  }
  tempObj = null;
}
</script>
</body>
</html>