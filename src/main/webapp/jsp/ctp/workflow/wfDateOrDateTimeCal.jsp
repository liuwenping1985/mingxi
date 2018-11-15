<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title><%-- 日期差设置--%></title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
<body class="h100b over_hidden">
<div class="form_area padding_5">
        <table border="0" cellSpacing="0" cellPadding="0" width="100%">
          <tbody>
            <td>
                <div class="common_radio_box clearfix align_right">
                    <label class="margin_r_10" for="text">${ctp:i18n('workflow.formBranch.operator') }:</label>
                </div>
            </td>
            <td width="70%"><div id="type2Content" class="common_selectbox_wrap">
                <select id="fieldName1" name="fieldName">
                    <c:forEach items="${fieldList}" var="field">
                         <option value="${field[1]}">${field[0]}</option>
                    </c:forEach>
                </select>
            </div>
            </td>
          </tr>
          <tr height="40">
            <td>
                <div class="common_radio_box clearfix align_right">
                    <label class="margin_r_10" for="text">${ctp:i18n('workflow.formBranch.operator') }:</label>
                </div>
            </td>
            <td width="70%">
            <div id="type1Content" class="common_txtbox_wrap">
                <input id="operator" name="text1" value="-" readonly="readonly">
            </div>
            </td>
          </tr>
          <tr>
            <td>
                <div class="common_radio_box clearfix align_right">
                    <label class="margin_r_10 hand" for="valueType2">
                        <input id="valueType2" class="radio_com" name="type" value="2" checked="checked" type="radio">${ctp:i18n('workflow.formBranch.formfield') }
                    </label> 
                </div>
            </td>
            <td width="70%"><div id="type2Content" class="common_selectbox_wrap">
                <select id="fieldName2" name="fieldName">
                    <c:forEach items="${fieldList}" var="field">
                         <option value="${field[1]}">${field[0]}</option>
                    </c:forEach>
                </select>
            </div>
            </td>
          <tr height="40">
            <td>
                &nbsp;
            </td>
            <td width="70%"><div class="common_checkbox_box clearfix">
                <input id="byWorkDay" class="radio_com" name="byWorkDay" value="ByWorkDay" type="checkbox">${ctp:i18n("workflow.label.branch.calculatedByWorkday") }<!-- 按工作日计算 -->
            </div>
            </td>
          </tr>
          </tbody>
         </table>
    </div>
<script type="text/javascript">
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
	var resultObj = {};
	resultObj.valueType = 2;
	resultObj.checkForm = true;
	var fieldName1 = $("#fieldName1").val(), fieldName2 = $("#fieldName2").val();
	if(fieldName1==null || fieldName1=='' || fieldName2==null || fieldName2==''){
		resultObj.checkForm = false;
	}else{
		var fieldObj1 = fieldMap[fieldName1], display1 = fieldObj1!=null?fieldObj1.display:"";
		var fieldObj2 = fieldMap[fieldName2], display2 = fieldObj2!=null?fieldObj2.display:"";
		resultObj.display1 = display1;
		resultObj.display2 = display2;
		if($("#byWorkDay").prop("checked")){
			resultObj.byWorkDay = true;
		}else{
			resultObj.byWorkDay = false;
		}
	}
    return $.toJSON(resultObj);
}
</script>
</body>
</html>