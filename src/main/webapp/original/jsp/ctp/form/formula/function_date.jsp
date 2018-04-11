<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.*"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums"%>
<%@ page import="com.seeyon.ctp.form.bean.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>设置界面</title>
<script>
var function_str = "${function_str}";
//组件类型
var componentType_formula="<%=FormulaEnums.componentType_formula%>";//公式组件
var componentType_condition="<%=FormulaEnums.componentType_condition%>";//条件组件
//公式组件类型
var formulaType_number = "<%=FormulaEnums.formulaType_number%>";//数字类型公式
var formulaType_varchar = "<%=FormulaEnums.formulaType_varchar%>";//字符串类型公式(动态组合)
var formulaType_date = "<%=FormulaEnums.formulaType_date%>";//日期类型公式
var formulaType_datetime = "<%=FormulaEnums.formulaType_datetime%>";//日期时间类型公式
//条件组件类型
var conditionType_BizCheck = "<%=FormulaEnums.conditionType_BizCheck%>";//业务规则校验
var conditionType_noFunction = "<%=FormulaEnums.conditionType_noFunction%>";//不需要函数
var conditionType_all = "<%=FormulaEnums.conditionType_all%>";//所有界面元素
//配置参数
var dialogArg = window.dialogArguments;//所有参数
var formId = ""+dialogArg.formId;//表单ID
var componentType = dialogArg.componentType?dialogArg.componentType:componentType_condition;//组件类型公式，条件
var formulaType = dialogArg.formulaType?dialogArg.formulaType:formulaType_number;//需要设置的公式类型(数字，文本，日期类)
var conditionType = dialogArg.conditionType?dialogArg.conditionType:conditionType_noFunction;//需要设置的条件类型(有函数，无函数)
var fieldName = dialogArg.fieldName;//选中的字段，如果存在需要显示让该字段处于选中状态
var fieldTableName = dialogArg.fieldTableName;//计算式对应字段所在表中
var canModifyFirstField = dialogArg.canModifyFirstField == null ? false : dialogArg.canModifyFirstField;//第一个表单域能否允许修改，如果不允许修改，则以文本框形式展示，允许修改则展示为下拉框
var canHandWritten = dialogArg.canHandWritten == null ? false : dialogArg.canHandWritten;;//是否需要显示手动录入框
var canCalcByWorkDay = dialogArg.canCalcByWorkDay == null ? true : dialogArg.canCalcByWorkDay;//是否需要显示能否参与工作日计算
var needSystemVar = dialogArg.needSystemVar == null ? false : dialogArg.needSystemVar;//是否需要系统变量
var needDateVar = dialogArg.needDateVar == null ? false : dialogArg.needDateVar;//是否需要日期变量
var dateVarType = dialogArg.dateVarType == null ? "TIMESTAMP" : dialogArg.dateVarType;//是否需要日期时间变量
var onlyFirstField = dialogArg.onlyFirstField == null ? false : dialogArg.onlyFirstField;;//是否只显示第一个表单域
var currentValue = dialogArg.currentValue == null ? false : dialogArg.currentValue;;//是否只显示第一个表单域
var showUnit = dialogArg.showUnit == null ? false : dialogArg.showUnit;//显示单位
var unitType = dialogArg.unitType == null ? "day" : dialogArg.unitType;//显示单位
var fieldType = dialogArg.fieldType == null ? "TIMESTAMP" : dialogArg.fieldType;//字段类型

function  OK(){
	var function_str = $("#function_str").val();//函数
	var function_end = $("#byWorkDay").attr("checked")==null?"":$("#byWorkDay").val();//函数后缀，是否含工作日
	var select1 = $("#field1 :selected");
	var select2 = $("#radio1").attr("checked")==null ? null :$("#field2value2 :selected");
	var field1 = $("#field1 :selected").attr("displayName") == null ? $("#field1").val() : $("#field1 :selected").attr("displayName");
	var field2 = getField2Value();
	if (!onlyFirstField){
		if(!field1 || !field2){
		  $.alert("表单域或者手工录入值不能为空！");
		  return false;
		}
	}
	if (select2 != null){
	  if (select1.attr("isSubField") == "true" && select2.attr("isSubField") == "true"){
	    if (select1.attr("tableName") != select2.attr("tableName")){
	      $.alert("不是同一个重复表字段！");
	      return false;
	    }
	  }
	}
	if(!onlyFirstField && $("#radio1").attr("checked")==null){
		if(parseInt($("#field2Value2").val()) > 1825){
			$.alert("${ctp:i18n('form.formula.engin.datefunction.maxvalue.label')}");
			return null;
		}
	}
	if((function_str=="<%=FunctionSymbol.calcDate.getKey()%>"||function_str=="<%=FunctionSymbol.calcDateTime.getKey()%>")&&$("#function_display").val()=="-"){
		field2 = "-"+field2;
	}
	//增加判断数字单位 
    if(function_str === 'calcDateTime'){
        var dayOrHour = $('input[name=dayOrHour]:checked').val();
        if(dayOrHour === 'Hour'){
            if(function_end !== ''){
                function_str += function_end+dayOrHour;
            }else{
                function_str +='By'+dayOrHour;
            }
        }else{
            if(function_end !== ''){
                function_str += function_end;
            }
        }
    }else{
        function_str = function_str+function_end;
    }
	var formulaStr=function_str+"("+field1+","+field2+")";
	if (onlyFirstField){
	 formulaStr=function_str+"("+$("#field1 :selected").attr("displayName")+")";
	}
	return formulaStr;
}

function getField2Value(){
    var val = $("input[name=radio]:checked").val();
    if (val=="1"){
        return $("#field2value"+val).val();
    }
    return $("#field2value"+val+" :selected").attr("displayName");
}

$(document).ready(function(){
  if (fieldName && !(fieldName.indexOf("f.")==0)){
  $("#field1").find("#"+fieldName).prop("selected",true);
  }
  $(".canntmodify"+(!canModifyFirstField)).remove();
  if (!canHandWritten){
    $(".handWritten").each(function(){
      $(this).remove();
    });
  }
    $("#radio1").prop("checked",true);
    setDisabled();
    if (!canCalcByWorkDay){
    $(".workday").remove();
  }
  if (!needSystemVar){
    $(".sysvar").each(function(){
      $(this).remove();
    });
  }
  if (needDateVar){
    $(".datevar").each(function(){
      if (dateVarType.indexOf($(this).attr("fieldType")) == -1){
        $(this).remove();
      }
    });
  } else {
    $(".datevar").each(function(){
      $(this).remove();
    });
  }
    if (!currentValue) {
        $(".currentValue").each(function(){
            $(this).remove();
        });
    }
  if (onlyFirstField){
    $(".onlyFirstField").each(function(){
      $(this).remove();
    });
  }
  if (showUnit){
    var types = unitType.split(',');
    for(var i=0; i < types.length; i++){
    $(".unitType"+types[i]).removeClass("hidden");
    if (i==0){
	    $("#"+unitType).prop("checked",true);
    }
    }
  } else{
    $(".showUnit").remove();
  }
  if (fieldTableName){
    $(".field").each(function(){
      if ($(this).attr("isSubField") == true){
        if ($(this).attr("tableName") != fieldTableName){
          $(this).remove();
        }
      }
    });
  }
  
  var filterFields = "${param.filterFields}";
  if (filterFields) {
      $("#field1,#field2value1").find("option[name='" + filterFields + "']").remove();
  }
  
  //取消下面的焦点事件
  $("#function_display").focus();
});
function setDisabled(obj){
    disableAll();
    if (obj) {
        disabeldSelect($(obj).val());
    } else {
        disabeldSelect(2);
    }
}
function disableAll(){
    for(var i = 1; i <= 3; i++) {
        $("#field2value" + i).attr("disabled", true);
    }
}
    function disabeldSelect(val){
        for(var i = 1; i <= 3; i++) {
            $("#field2value" + i).attr("disabled", i!=val);
        }
    }
</script>
</head>
<body scroll="no">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="clearfix margin_t_5">
                <div id = "field1Label" class="left" style="width: 110px;text-align: right;line-height: 26px;">${ctp:i18n('form.formula.engin.formdata.label')}：</div>
               	<div class="left common_selectbox_wrap canntmodifytrue" style="width: 212px;">
                    <select id="field1" name="field1" style="width: 212px;">
                        <c:forEach items="${fieldList}" var="obj" varStatus="status">
    					    <option class="field" displayName="<c:if test="${!param.isAutoupdate}" ><c:if test="${not empty param.prefix}">{${param.prefix}${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}</c:if><c:if test="${empty param.prefix}">{${obj['display']}}</c:if></c:if><c:if test="${param.isAutoupdate}" >[<%=FormBean.FLOW_PREFIX%>${obj['display']}]</c:if>" id="${obj['name']}" name="${obj['name']}" value="{${obj['display']}}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" tableName="${obj['ownerTableName']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if><c:if test="${!obj['masterField']}">isSubField=true</c:if>>
    						<c:choose>
    						    <c:when test="${fn:indexOf(obj['name'],'field') eq -1 }">
    						        [${ctp:i18n('form.compute.systemdata.label')}]
    						    </c:when>
    						    <c:otherwise>
    						        <c:if test="${not empty param.prefix}">${param.prefix}<c:if test="${!param.isAutoupdate}" >${fn:substringAfter(obj['ownerTableName'],'_')}.</c:if></c:if><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.ownerTableIndex}]</c:if>
    						    </c:otherwise>
    						</c:choose>
    						${obj['display']}
    					    </option>
                        </c:forEach>
                        <c:forEach items="${date}" var="obj" varStatus="status">
                            <option class="datevar ${obj.fieldType}" value="[${obj.text}]" id="${obj.key}" displayName="[${obj.text}]" inputType="" fieldType="${obj.fieldType}" extend="false" title="[${ctp:i18n('form.formula.engin.datevar.label')}]${obj.text}">[${ctp:i18n('form.formula.engin.datevar.label')}]${obj.text}</option>
                        </c:forEach>
                        <option class="sysvar" id="start_date" value="{${ctp:i18n('form.log.createtime')}}" displayName="<c:if test="${not empty param.prefix}">{${param.prefix}${fn:substringAfter(form.masterTableBean.tableName,'_')}.${ctp:i18n('form.log.createtime')}}</c:if><c:if test="${empty param.prefix}">{${ctp:i18n('form.log.createtime')}}</c:if>" inputType="" fieldType="" extend="false" isMasterField=true title="[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.log.createtime')}">[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.log.createtime')}</option>
                        <option class="sysvar" id="modify_date" value="{${ctp:i18n('form.base.modifytime')}}" displayName="<c:if test="${not empty param.prefix}">{${param.prefix}${fn:substringAfter(form.masterTableBean.tableName,'_')}.${ctp:i18n('form.base.modifytime')}}</c:if><c:if test="${empty param.prefix}">{${ctp:i18n('form.base.modifytime')}}</c:if>" inputType="" fieldType="" extend="false" isMasterField=true title="[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.base.modifytime')}">[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.base.modifytime')}</option>
                    </select>
                </div>
                <c:if test="${field ne null}">
                    <div class="left common_txtbox_wrap canntmodifyfalse" style="width: 200px;">
                    	<input id="field1" name="field1" value="<c:if test="${!param.isAutoupdate}" >{${field['display']}}</c:if><c:if test="${param.isAutoupdate}" >[<%=FormBean.FLOW_PREFIX%>${field['display']}]</c:if>" type="text" readOnly style="width: 200px;">
                    </div>
                </c:if>
            </div>
            <input id="function_str" name="function_str" value="${function_str}" type="hidden">
            <div class="clearfix margin_t_5 onlyFirstField">
                <div id = "operatorLabel" class="left" style="width: 110px;text-align: right;line-height: 26px;">${ctp:i18n('form.formula.engin.operator.label')}：</div>
                <div class="left common_txtbox_wrap" style="width: 200px;">
                    <input id="function_display" name="function_display" value="${function_display}" type="text" readOnly style="width: 200px;">
                </div>
            </div>
            <div class="clearfix margin_t_5 onlyFirstField">
                <div id = "inputTypeLabe2 handWritten" class="left" style="width: 110px;text-align: right;line-height: 26px;">
                    <label class="hand" for="radio1">
                        <input type="radio" id="radio1" name="radio" class="radio_com"  value="2" checked="checked" onclick="setDisabled(this)">${ctp:i18n('form.formula.engin.formdata.label')}：
                    </label>
                </div>
                <div class="left common_selectbox_wrap" style="width: 212px;">
                    <select id="field2value2" name="field2value1" style="width: 212px;">
                        <c:forEach items="${fieldList}" var="obj" varStatus="status">
                            <option class="field" displayName="<c:if test="${!param.isAutoupdate}" ><c:if test="${not empty param.prefix}">{${param.prefix}${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}</c:if><c:if test="${empty param.prefix}">{${obj['display']}}</c:if></c:if><c:if test="${param.isAutoupdate}" >[<%=FormBean.FLOW_PREFIX%>${obj['display']}]</c:if>" id="${obj['id']}" name="${obj['name']}" value="{${obj['display']}}" tableName="${obj['ownerTableName']}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if><c:if test="${!obj['masterField']}">isSubField=true</c:if>>
                                <c:choose>
                                    <c:when test="${fn:indexOf(obj['name'],'field') eq -1 }">
                                        [${ctp:i18n('form.compute.systemdata.label')}]
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty param.prefix}">${param.prefix}<c:if test="${!param.isAutoupdate}" >${fn:substringAfter(obj['ownerTableName'],'_')}.</c:if></c:if><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.ownerTableIndex}]</c:if>
                                    </c:otherwise>
                                </c:choose>
                                ${obj['display']}
                            </option>
                        </c:forEach>
                        <c:forEach items="${date}" var="obj" varStatus="status">
                            <option class="datevar ${obj.fieldType }" value="[${obj.text}]" displayName="[${obj.text}]" inputType="" fieldType="${obj.fieldType}" extend="false" title="[${ctp:i18n('form.formula.engin.datevar.label')}]${obj.text}">[${ctp:i18n('form.formula.engin.datevar.label')}]${obj.text}</option>
                        </c:forEach>
                        <option class="sysvar" value="{${ctp:i18n('form.log.createtime')}}" displayName="<c:if test="${not empty param.prefix}">{${param.prefix}${fn:substringAfter(form.masterTableBean.tableName,'_')}.${ctp:i18n('form.log.createtime')}}</c:if><c:if test="${empty param.prefix}">{${ctp:i18n('form.log.createtime')}}</c:if>" inputType="" fieldType="" extend="false" isMasterField=true title="[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.log.createtime')}">[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.log.createtime')}</option>
                        <option class="sysvar" value="{${ctp:i18n('form.base.modifytime')}}" displayName="<c:if test="${not empty param.prefix}">{${param.prefix}${fn:substringAfter(form.masterTableBean.tableName,'_')}.${ctp:i18n('form.base.modifytime')}}</c:if><c:if test="${empty param.prefix}">{${ctp:i18n('form.base.modifytime')}}</c:if>" inputType="" fieldType="" extend="false" isMasterField=true title="[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.base.modifytime')}">[${ctp:i18n('form.compute.systemdata.label')}]${ctp:i18n('form.base.modifytime')}</option>
                    </select>
                </div>
            </div>
            <div class="clearfix margin_t_5 onlyFirstField currentValue">
                <div id = "inputTypeLabe3" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio3">
                        <input type="radio" id="radio3" name="radio" class="radio_com"  value="3" checked="checked" onclick="setDisabled(this)">${ctp:i18n('form.formula.engin.formvalue.label')}：
                    </label>
                </div>
                <div class="left common_selectbox_wrap" style="width: 212px;">
                    <select id="field2value3" name="field2value3" style="width: 212px;">
                        <c:forEach items="${fieldList}" var="obj" varStatus="status">
                            <option class="field" displayName="[f.${obj['display']}]" id="${obj['id']}" name="${obj['name']}" value="{${obj['display']}}" tableName="${obj['ownerTableName']}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if><c:if test="${!obj['masterField']}">isSubField=true</c:if>>
                                <c:choose>
                                    <c:when test="${fn:indexOf(obj['name'],'field') eq -1 }">
                                        [${ctp:i18n('form.compute.systemdata.label')}]
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty param.prefix}">${param.prefix}${fn:substringAfter(obj['ownerTableName'],'_')}.</c:if><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.ownerTableIndex}]</c:if>
                                    </c:otherwise>
                                </c:choose>
                                    ${obj['display']}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="clearfix margin_t_5 onlyFirstField handWritten">
                <div id = "inputTypeLabe1" class="left" style="width: 110px;text-align: right;">
                    <label class="hand" for="radio2">
                        <input type="radio" id="radio2" name="radio" class="radio_com"   value="1" onclick="setDisabled(this)">${ctp:i18n('form.formula.engin.manualinput.label')}：
                    </label>
                </div>
                <div class="left common_txtbox_wrap" style="width: 200px;">
                    <input type="text" id="field2value1" name="field2value1" class="comp" comp="type:'onlyNumber',numberType:'int'" disabled value="" style="width: 200px;">
                </div>
            </div>
            <div class="clearfix margin_t_5 onlyFirstField showUnit">
                <div id = "dayOrHourLabel" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.digitalunit')}：</div>
                <div id = "dayLabel" class="left unitTypeday hidden" style="width: 100px;text-align: left;">
                    <label class="hand" for="day">
                        <input type="radio" id="day" name="dayOrHour" class="radio_com"   value="Day" >${ctp:i18n('form.formula.engin.digitalunit.day')}
                    </label>
                </div>
                <div id = "hourLabel" class="left unitTypehour hidden" style="width: 100px;text-align: left;">
                    <label class="hand" for="hour">
                        <input type="radio" id="hour" name="dayOrHour" class="radio_com"   value="Hour" >${ctp:i18n('form.formula.engin.digitalunit.hour')}
                    </label>
                </div>
            </div>
            <div class="clearfix margin_t_5 onlyFirstField workday">
                <div id = "" class="left" style="width: 110px;text-align: right;">&nbsp;</div>
                <div class="left" style="width: 200px;">
                    <div class="common_checkbox_box clearfix ">
                        <input id="byWorkDay" class="radio_com" name="byWorkDay" value="ByWorkDay" type="checkbox">${ctp:i18n('form.formula.engin.workday.label')}
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
