<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.bean.FormBean"%>
<%@ page import="com.seeyon.ctp.form.bean.FormFieldBean"%>
<HTML>
<HEAD>
<TITLE>包含与不包含函数设置</TITLE>
<script type="text/javascript">
var userVar = window.dialogArguments;
function OK(){
	var formulaStr="";
	var function_str = $("#function_str").val();
	var field1 = $("#field1").val();
	if($("#radio1").attr("checked")!=null){
		if($("#field2value1").val()==""){$.alert("${ctp:i18n('form.formula.function.like.notnull')}");return false;}
        if($("#field2value1").val().length > 20000){$.alert("${ctp:i18n('form.formula.engin.formulaset.length.error')}");return false;}
        formulaStr=function_str+"("+field1+",'"+$("#field2value1").val()+"')";
	}else if($("#radio2").attr("checked")!=null){
		formulaStr=function_str+"("+field1+","+$("#field2value2").val()+")";
	}else if($("#radio3").attr("checked")!=null){
	    if (!$("#field2value3").val()) {
	        $.alert("${ctp:i18n('form.formula.function.in.notnull')}");
	        return false;
	    }
        formulaStr=function_str+"("+field1+","+$("#field2value3").val()+")";
    }else if($("#radio4").attr("checked")!=null){
        formulaStr=function_str+"("+field1+","+$("#field2value4").val()+")";
    }
	return formulaStr;
}
function setDisabled(id){
	$(".field2value").prop("disabled",true);
	$("#" + id).prop("disabled",false);
}
function init(){
	if(userVar!=null&&userVar.length>0){
		$("#input2Div").css("display","block");	
		var opt = "";
		for(var i =0;i<userVar.length;i++){
			opt += "<option value='["+userVar[i].name+"]'>"+userVar[i].name+"</option>";
		}
		$("#field2value2").html(opt);
	}
	$("#field2value1").focus();
	
	<c:if test="${otherForm ne null}">
    	var fieldTableName = "${param.fieldTableName}";
    	if (fieldTableName) {
    	    if (fieldTableName.indexOf("formmain") != -1) {
    	        $("#field2value3").find("option[tableName!='" + fieldTableName + "']").remove();
    	    }
    	    if (fieldTableName.indexOf("formson") != -1) {
    	        $("#field2value3").find("option[tableName!='" + fieldTableName + "'][tableName^='formson']").remove();
            }
        }
    	var filterFields = "${param.filterFields}";
    	if (filterFields) {
    	    $("#field2value3").find("option[name='" + filterFields + "']").remove();
    	}
	</c:if>
}
</script>
</HEAD>
<BODY scroll=no onload="init()">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="clearfix margin_t_5">
                <div id = "field1Label" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.formdata.label')}：
                </div>
                <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input id="field1" name ="field1" value="${fieldDisplay}" type="text" readOnly style="width: 200px;"></div>
                    </div>
                </div>
            </div>
            <div class="clearfix margin_t_5">
                <div id = "operatorLabel" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.operator.label')}：
                </div>
                <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input id="function_str" value="${function_str }" type="text" readOnly style="width: 200px;"></div>
                    </div>
                </div>
            </div>
            
            <div id="input1Div" class="clearfix margin_t_5">
                <div id = "inputTypeLabe1" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio1">
                        <input type="radio" id="radio1" name="radio" class="radio_com"  checked=true value="1" onclick="setDisabled('field2value1')">${ctp:i18n('form.formula.engin.value.label')}：
                    </label>
                </div>
                <div class="left" style="width: 200px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_txtbox_wrap"><input class="field2value" id="field2value1" name="field2value1"  value="" type="text" style="width: 200px;"></div>
                    </div>
                </div>
            </div>
  
            <div id="input2Div" class="clearfix margin_t_5" style="display:none">
                <div id = "inputTypeLabe2" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio2">
                        <input type="radio" id="radio2" name="radio" class="radio_com"  value="2" onclick="setDisabled('field2value2')">${ctp:i18n('form.formula.engin.uservar.label')}：
                    </label>
                </div>
                <div class="left " style="width: 200px;">
                    <select class="field2value" id="field2value2" name="field2value2" style="width: 200px;" disabled>
                    </select>
                </div>
            </div>
            
            <c:if test="${otherForm ne null}">
            <div id="otherField_div" class="clearfix margin_t_5">
                <div class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio3">
                        <input type="radio" id="radio3" name="radio" class="radio_com" value="3" onclick="setDisabled('field2value3')">a.${ctp:i18n('form.formula.engin.formdata.label')}：
                    </label>
                </div>
                <div class="left" style="width: 200px;">
                    <select class="field2value" id="field2value3" name="field2value3" style="width: 200px;" disabled>
                    <c:forEach items="${fieldList}" var="obj" varStatus="status">
                        <option id="${obj['id']}" name="${obj['name']}" value="{<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}" tableName="${obj['ownerTableName']}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${obj['display']}</option>
                    </c:forEach>
                    </select>
                </div>
            </div>
            </c:if>
            
            <%--单据填写值--%>
            <div id="input4Div" class="clearfix margin_t_5" <c:if test="${empty masterCalcFields or qsType eq '0'}">style="display:none"</c:if>>
                <div id = "inputTypeLabe4" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio4">
                        <input type="radio" id="radio4" name="radio" class="radio_com"  value="4" onclick="setDisabled('field2value4')">${ctp:i18n('form.formula.engin.flowformvar.label')}：
                    </label>
                </div>
                <div class="left " style="width: 200px;">
                    <select class="field2value" id="field2value4" name="field2value4" style="width: 200px;" disabled>
                        <c:forEach items="${masterCalcFields}" var="obj" varStatus="status">
                          <option value="[<%=FormBean.FLOW_PREFIX%>${obj['display']}]"><%=FormBean.FLOW_PREFIX%>[${ctp:i18n('form.base.mastertable.label')}]${obj['display']}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
     </form>
</BODY>
</HTML>
