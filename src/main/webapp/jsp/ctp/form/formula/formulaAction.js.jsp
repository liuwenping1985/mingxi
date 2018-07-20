<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums.*"%>
<%@page import="com.seeyon.ctp.form.bean.FormFieldComBean.*"%>
<%@page import="com.seeyon.ctp.form.util.Enums.*"%>
<%@ page import="com.seeyon.ctp.form.bean.FormBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript">
function forMasterField(){
  if (dialogArg.otherformId || fieldTableName.indexOf("formmain") != -1){
    return true;
  }
    return false;
}
//需要主表字段
function needMasterField(needAlert){
  var result = isMasterField();
  if (!result && needAlert){
    $.alert("${ctp:i18n('form.formula.engin.selected.master.error')}");
  }
  return result;
}
//需要重复表字段
function needSubField(needAlert){
  var result = isSubField();
  if (!result && needAlert){
    $.alert("${ctp:i18n('form.formula.engin.selected.slave.error')}");
  }
  return result;
}
//需要日期字段
function needTimeStampField(needAlert){
  var result = isTimestampField();
  if (!result && needAlert){
    $.alert("${ctp:i18n('form.formula.engin.selected.slave.error')}");
  }
  return result;
}
//需要日期时间字段
function needDateTimeField(needAlert,includeSysField){
  var result = isDateTimeField(includeSysField);
  if (!result && needAlert){
    $.alert("${ctp:i18n('form.formula.engin.selected.datetime.error')}");
  }
  return result;
}

//需要日期型或者日期时间型
function needTimeStampOrDateTimeField(needAlert,includeSysField){
  if(!needTimeStampField(false) && !needDateTimeField(false,includeSysField)){
    if (needAlert){
      $.alert("${ctp:i18n('form.formula.engin.selected.datetime.error')}");
    }
    return false;
  }
    return true;
}

//判断选中字段是否是主表字段
function isMasterField(){
  if (validateFieldType(1)){
    return true;
  } else {
    return false;
  }
}

//判断选中字段是否是从表字段
function isSubField(){
  var result = validateFieldType(1);
  if (result == null || result){
    return false;
  } else {
    return true;
  }
}
//需要数字字段，字段是否需要在主表
function needNumField(needAlert,tableName){
  var result = isNumField();
  if (!result && needAlert){
    $.alert("${ctp:i18n('form.formula.engin.selected.digit.error')}");
  }
  if (tableName){
    
  }
  return result;
}

function isTimestampField(){
  if (validateFieldType(3)){
    return true;
  } else {
    return false;
  }
}
function isDateTimeField(includeSysField){
  if (includeSysField){
    var selectObj = getSelectedField();
    if (selectObj.val() == "start_date" || selectObj.val() == "modify_date"){
      return true;
    }
  }
  if (validateFieldType(4)){
    return true;
  } else {
    return false;
  }
}

//判断是否是数字字段
function isNumField(){
  if (validateFieldType(2)){
    return true;
  } else {
    return false;
  }
}

//校验选中字段是否是指定类型字段,如果选中的不是表单数据域，返回null
//type:1主从，2数字，3日期，4日期时间
function validateFieldType(type){
	var selectObj = getSelectedField();
	if (selectObj.attr("labelType") != "formField"){
	  return null;
	}
	if (type == 1){
	  if(selectObj.attr("isSubField")!="true"){
	    return true;
	  }else {
	    return false;
	  }
	}
	if (type == 2){
	  if(selectObj.attr("fieldType")=="<%=FieldType.DECIMAL.getKey()%>"){
	    return true;
	  }else {
	    return false;
	  }
	}
	if (type == 3){
	  if(selectObj.attr("fieldType")=="<%=FieldType.TIMESTAMP.getKey()%>"){
	    return true;
	  }else {
	    return false;
	  }
	}
	if (type == 4){
	  if(selectObj.attr("fieldType")=="<%=FieldType.DATETIME.getKey()%>"){
	    return true;
	  }else {
	    return false;
	  }
	}
}

//重复项求和
function sum(){
	var selectObj = getSelectedField();
	if (!needSubField(true))return;
	if (!needNumField(true))return;
	setText("<%=FunctionSymbol.sum.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
}
//重复项求平均
function aver(){
	var selectObj = getSelectedField();
    if (!needSubField(true))return;
	if (!needNumField(true))return;
	setText("<%=FunctionSymbol.aver.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
}
//重复项任意一行
function subExist(){
	setText("exist()");
}
//重复项所有行
function subAll(){
	setText("all()");
}
//插入空值
function nullValue(){
	setText("null");
}
//大写长格式
function toUpperForLong(){
	var selectObj = getSelectedField();
	if (needNumField(true)){
		setText("<%=FunctionSymbol.toUpperForLong.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
	}
}
//大写短格式
function toUpperForShort(){
	var selectObj = getSelectedField();
	if (needNumField(true)){
		setText("<%=FunctionSymbol.toUpperForShort.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
	}
}
//日期差
function differDate(){
    //fieldTableName在formula.js.jsp中定义
    var selectObj = getSelectedField();
    var fieldName = null;
    if (selectObj[0]){
      fieldName = selectObj.val();
      if (!needTimeStampOrDateTimeField(false,true)){
        //fieldName= "";
      }
    }
	var param = {};
  param.function_str = "<%=FunctionSymbol.differDate.getKey()%>";
  param.formId = formId;
  param.fieldName = fieldName;
  param.title = "${ctp:i18n('form.formula.engin.datefunction.minus.set.title')}";
  param.fieldTableName = fieldTableName;
  param.canModifyFirstField = true;
  param.canHandWritten = false;

  param.canCalcByWorkDay = conditionType.indexOf("sql") == -1;
  param.needSystemVar = true;

  param.needDateVar = !("conditionType_formula_sub" == conditionType || conditionType.indexOf("BizCheck") != -1 || (componentType == componentType_formula && "formulaType_number" == formulaType));
  param.dateVarType = "TIMESTAMP DATETIME";
  param.fieldType = "TIMESTAMP";
  function_date(param);
}
//日期时间差
function differDateTime(){
  var selectObj = getSelectedField();
  var fieldName = null;
  if (selectObj[0]){
    fieldName = selectObj.val();
    if (!needTimeStampOrDateTimeField(true,true)){
      return;
    }
  }
	var param = {};
  param.function_str = "<%=FunctionSymbol.differDateTime.getKey()%>";
  param.formId = formId;
  param.fieldName = fieldName;
  param.title = "${ctp:i18n('form.formula.engin.datetimefunction.minus.set.title')}";
  param.fieldTableName = fieldTableName;
  param.canModifyFirstField = true;
  param.canHandWritten = false;
  param.canCalcByWorkDay = true;
  if (conditionType.indexOf("sql") != -1){
  param.canCalcByWorkDay = false;
  }
  param.needSystemVar = false;
  param.needDateVar = false;
  param.fieldType = "DATETIME";
  function_date(param);
}
//时间差
function differTime(){
    var selectObj = getSelectedField();
    var fieldName = null;
    if (selectObj[0]){
      fieldName = selectObj.val();
      if (!needTimeStampOrDateTimeField(false,true)){
        //fieldName= "";
      }
    }
	var param = {};
  param.function_str = "<%=FunctionSymbol.differTime.getKey()%>";
  param.formId = formId;
  param.fieldName = fieldName;
  param.title = "${ctp:i18n('form.formula.engin.timefunction.minus.set.title')}";

  param.fieldTableName = fieldTableName;
  param.canModifyFirstField = true;
  param.canHandWritten = false;

  param.canCalcByWorkDay = conditionType.indexOf("sql") == -1;
  param.needSystemVar = true;

  param.needDateVar = !("conditionType_formula_sub" == conditionType || conditionType.indexOf("BizCheck") != -1 || (componentType == componentType_formula && "formulaType_number" == formulaType));
  param.dateVarType = "TIMESTAMP DATETIME";
  param.fieldType = "TIMESTAMP";
  function_date(param);
}
//日期加时间段计算
function dateCal(str){
	var field = getSelectedField();
	if(field.attr("id")==null){
		$.alert("${ctp:i18n('form.formula.engin.selected.formdata.error')}");
		return;
	}
  var param = {};
  param.function_str = str;
  param.formId = formId;
  param.fieldName = field.val();
  param.title = "${ctp:i18n('form.formula.engin.datefunction.set.title')}";
  param.fieldTableName = fieldTableName;
  param.canModifyFirstField = false;
  param.canHandWritten = true;
  param.canCalcByWorkDay = true;
  param.needSystemVar = false;
  param.needDateVar = false;
  param.needDateTimeVar = false;
  param.onlyFirstField = false;
  param.showUnit = true;
  param.unitType = "day";
  if (field.attr("fieldType") == "DATETIME"){
	  param.unitType = "day,hour";
  }
  param.fieldType = "DECIMAL";
  function_date(param);
}
//日期计算公用函数
function function_date(param){
  param.formId = formId;
  param.prefix = "";
  param.filterFields = "";
  if (oFormId != 0) {
    if (operationType == "relationform") {
      param.formId = oFormId;
      param.prefix = "<%=FormBean.R_PREFIX%>";
      param.fieldTableName = "";
      if ($("#tabs_head").find("li.current").attr("id") == "field_li") {
        param.formId = formId;
        param.prefix = "<%=FormBean.M_PREFIX%>";
        param.fieldTableName = fieldTableName;
        param.filterFields = filterFields;
      }
    } else {
      param.prefix = "<%=FormBean.M_PREFIX%>";
    }
  }
  param.componentType = componentType;
  param.formulaType = formulaType;
  param.conditionType = conditionType;
  param.otherformId = dialogArg.otherformId;
  if (!param.fieldTableName){
    param.fieldTableName = "";
  }
//高级权限不需要重复表字段
  if (conditionType.indexOf("hign_auth") != -1){
    param.fieldTableName = "hign_auth";
    }
	var result="";
	var url = "${path}/form/formula.do?method=dateCal&formId="+param.formId+"&function_str="+param.function_str+"&fieldName="+param.fieldName+"&fieldTableName="+param.fieldTableName+"&filterFields="+param.filterFields+"&prefix="+param.prefix+"&componentType="+componentType+"&formulaType=" + formulaType + "&conditionType=" +conditionType+"&fieldType="+param.fieldType;
	var current_dialog = $.dialog({
	url: url,
	title : param.title,
	width:400,
	height:250,
	transParams:param,
	targetWindow:getCtpTop(),
	   buttons : [{
	     text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
	     handler : function() {
	      result = current_dialog.getReturnValue();
	      if(result == undefined || result == false){
	    	  return;
	      }
	      setText(result);
	      current_dialog.close();
	     }
	   }, 
	   {
	     text : "${ctp:i18n('form.query.cancel.label')}",id:"exit",
	     handler : function() {setText("");current_dialog.close();}
	   }]
	 });
	 return result;
}
//包含
function like(param){
	function_like("<%=ConditionSymbol.like.getKey()%>",formId,"${ctp:i18n('form.formula.engin.likefunction.set.title')}",param);	
}
//不包含
function not_like(param){
	function_like("<%=ConditionSymbol.not_like.getKey()%>",formId,"${ctp:i18n('form.formula.engin.notlikefunction.set.title')}",param);
}
//包含不包含公用函数
function function_like(function_str,formId,title,param){
	if (oFormId != 0 && $("#tabs_head").find("li.current").attr("id") == "field_li") {
        $.alert("${ctp:i18n('form.create.input.relation.datafilter.error.1.label')}");
        return;
    }
	if ($("#tabs_head").find("li.current").attr("id") == "flowdata_li") {
        $.alert("${ctp:i18n('form.formula.function.extend.not.support')}");
        return;
    }
	var field = getSelectedField();
	var fieldName = field.val();
    if(field.attr("fieldType")=="<%=FieldType.VARCHAR.getKey()%>"&&(field.attr("finalInputType")=="<%=FormFieldComEnum.TEXT.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.EXTEND_QUERYTASK.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.EXTEND_EXCHANGETASK.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.CUSTOM_CONTROL.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.TEXTAREA.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.LABLE.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.RELATION.getKey()%>"||field.attr("finalInputType")=="<%=FormFieldComEnum.RELATIONFORM.getKey()%>"||(field.attr("finalInputType")=="<%=FormFieldComEnum.OUTWRITE.getKey()%>" &&(field.attr("formattype")=="" || field.attr("formattype")=="<%=FormFieldComEnum.TEXT.getKey()%>"|| field.attr("formattype")=="<%=FormFieldComEnum.TEXTAREA.getKey()%>") )||field.attr("finalInputType")=="<%=FormFieldComEnum.FLOWDEALOPITION.getKey()%>")){
		var result="";
		var qsType="0";
		if(param && param.qsType){
			qsType=param.qsType;
		}
		var current_dialog = $.dialog({
		url: "${path}/form/formula.do?method=like&formId="+formId+"&otherformId="+oFormId+"&function_str="+function_str+"&fieldName="+fieldName+"&fieldTableName="+(fieldTableName ? fieldTableName : "")+"&filterFields="+(filterFields ? filterFields : "")+"&qsType="+qsType,
		title : title,
		width:400,
		height:200,
		transParams:userVar,
		targetWindow:getCtpTop(),
		   buttons : [{
		     text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
		     handler : function() {
		      result = current_dialog.getReturnValue();
		      if(result!=null&&result!=""){
			      setText(result);
				  current_dialog.close();
		      }
		     }
		   }, 
		   {
		     text : "${ctp:i18n('form.query.cancel.label')}",id:"exit",
		     handler : function() {setText("");current_dialog.close();}
		   }]
		 });
	}else{
		$.alert("${ctp:i18n('form.formula.engin.selected.text.error')}");
		return "";
	}	
    return result;
}
function extend(){
    if (oFormId != 0 && $("#tabs_head").find("li.current").attr("id") == "field_li") {
        $.alert("${ctp:i18n('form.create.input.relation.datafilter.error.1.label')}");
        return;
    }
    if ($("#tabs_head").find("li.current").attr("id") == "flowdata_li") {
        $.alert("${ctp:i18n('form.formula.function.extend.not.support')}");
        return;
    }
	var selectObj = getSelectedField();
	var fieldName = selectObj.val();
	if((selectObj==null||selectObj.attr("displayName")==null||selectObj.attr("extend")==null||selectObj.attr("extend")=="false" || selectObj.attr("finalinputtype") === 'text' || selectObj.attr("finalinputtype") === 'textarea' || selectObj.attr("finalinputtype") === 'lable'
	             ||(selectObj.attr("inputType")==='outwrite' &&(selectObj.attr("fieldType")==='DECIMAL' ||selectObj.attr("formatType")==='text' ||selectObj.attr("formatType")==='attachment'||selectObj.attr("formatType")==='image'||!selectObj.attr("formatType")||selectObj.attr("formatType")==='document' || selectObj.attr("formatType")==='textarea' ) ))
	      &&selectObj.attr("fieldType")!="<%=FieldType.TIMESTAMP.getKey()%>"&&selectObj.attr("fieldType")!="<%=FieldType.DATETIME.getKey()%>"){
		$.alert("${ctp:i18n('form.bind.selectTo')}"+"${tipStr}!");
		return;
	}
	var result="";
	var current_dialog = $.dialog({
	url: "${path}/form/formula.do?method=extend&formId="+(formId==null?"0":formId)+"&otherformId="+oFormId+"&fieldName="+fieldName+"&fieldTableName="+(fieldTableName ? fieldTableName : "")+"&filterFields="+(filterFields ? filterFields : "")+"&extendSubDep="+extendSubDep,
	title : "${ctp:i18n('form.formula.function.extend')}",
	width:400,
	height:300,
	transParams:null,
	targetWindow:getCtpTop(),
	   buttons : [{
	     text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
	     handler : function() {
	      result = current_dialog.getReturnValue();
	      setText(result);
		  current_dialog.close();
	     }
	   }, 
	   {
	     text : "${ctp:i18n('form.query.cancel.label')}",id:"exit",
	     handler : function() {setText("");current_dialog.close();}
	   }]
	 });
    return result;
}
function showHelp(){
	var current_dialog = $.dialog({
	    url: "${path}/form/formula.do?method=formulaHelp",
	    title : "${ctp:i18n('form.formulahelp.label')}",
	    width:600,
	    height:500,
	    targetWindow:getCtpTop(),
	       buttons : [{
	         text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
	         handler : function() {
	          current_dialog.close();
	         }
	       }]
	     });
}

function max(){
	var selectObj = getSelectedField();
    if (!needSubField(true))return;
	if (!needNumField(true))return;
	setText("<%=FunctionSymbol.max.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
}

function min(){
	var selectObj = getSelectedField();
    if (!needSubField(true))return;
	if (!needNumField(true))return;
	setText("<%=FunctionSymbol.min.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
}

function getInt(){
  var selectObj = getSelectedField();
  if (!needNumField(true))return;
  if (forMasterField()){
	  if (!needMasterField(true))return;
  }
  setText("<%=FunctionSymbol.getInt.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
}

function getMod(){
  var selectObj = getSelectedField();
  if (!needNumField(true))return;
  if (forMasterField()){
	  if (!needMasterField(true))return;
  }
  var fieldName = selectObj.val();
  var current_dialog = $.dialog({
    url: "${path}/form/formula.do?method=getMod&formId="+(formId==null?"0":formId)+"&fieldName="+fieldName+"&fieldTableName="+fieldTableName +"&filterFields="+filterFields,
    title : "${ctp:i18n('form.formula.engin.datefunction.getmod.set.title')}",
    width:400,
    height:300,
    transParams:null,
    targetWindow:getCtpTop(),
       buttons : [{
         text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
         handler : function() {
          result = current_dialog.getReturnValue();
          if (result != false){
	          setText("<%=FunctionSymbol.getMod.getKey()%>("+getFieldName(selectObj.attr("displayName"))+","+result+")");
	          current_dialog.close();
          }
         }
       }, 
       {
         text : "${ctp:i18n('form.query.cancel.label')}",id:"exit",
         handler : function() {setText("");current_dialog.close();}
       }]
     });
}

function year(){
  datePart("<%=FunctionSymbol.year.getKey()%>","${ctp:i18n('form.formula.engin.datefunction.year.set.title')}");
}

function month(){
  datePart("<%=FunctionSymbol.month.getKey()%>","${ctp:i18n('form.formula.engin.datefunction.mouth.set.title')}");
}

function day(){
  datePart("<%=FunctionSymbol.day.getKey()%>","${ctp:i18n('form.formula.engin.datefunction.day.set.title')}");
}

function weekday(){
  datePart("<%=FunctionSymbol.weekday.getKey()%>","${ctp:i18n('form.formula.engin.datefunction.weekday.set.title')}");
}

function datePart(function_str,title){
  var field = getSelectedField();
  var fieldName = field.val();
  if (field[0]){
      if (!needTimeStampOrDateTimeField(false,true)){
      }
  }
  var param = {};
  param.function_str = function_str;
  param.formId = formId;
  param.fieldName = fieldName;
  param.title = title;
  param.fieldTableName = fieldTableName;
  param.canModifyFirstField = true;
  param.canHandWritten = false;
  param.canCalcByWorkDay = false;
  param.needSystemVar = true;
  param.needDateVar = true;
  param.dateVarType = "TIMESTAMP";
  param.onlyFirstField = true;
  param.fieldType = "TIMESTAMP";
  if ("conditionType_formula_sub" == conditionType || conditionType.indexOf("BizCheck") != -1 || (componentType == componentType_formula &&"formulaType_number" == formulaType)){
   param.needDateVar = false;
   }
  function_date(param);
}

function date(){
  dateTime("date");
}

function time(){
  dateTime("time");
}

function dateTime(type){
  if ($("#tabs_head").find("li.current").attr("id") == "flowdata_li") {
      $.alert("${ctp:i18n('form.formula.function.extend.not.support')}");
      return;
  }
  var selectObj = getSelectedField();
  if (needDateTimeField(true,true)){
    setText(type+"("+getFieldName(selectObj.attr("displayName"))+")");
  }
}

function toUpper(){
  var selectObj = getSelectedField();
  if (needNumField(true)){
      setText("<%=FunctionSymbol.toUpper.getKey()%>("+getFieldName(selectObj.attr("displayName"))+")");
  }
}
  
function sumif(){
	openConditionBoxByType("sumif","${ctp:i18n('form.formula.engin.condition.title')}");
}

function averif(){
	openConditionBoxByType("averif","${ctp:i18n('form.formula.engin.condition.averif.title')}");
}

function maxif(){
	openConditionBoxByType("maxif","${ctp:i18n('form.formula.engin.condition.maxif.title')}");
}

function minif(){
	openConditionBoxByType("minif","${ctp:i18n('form.formula.engin.condition.minif.title')}");
}

function openConditionBoxByType(type,title){
	var selectObj = getSelectedField();
    if (!needSubField(true))return;
	if (!needNumField(true))return;
	var param = getConditionArgs(function(val){
		setText(type+"("+getFieldName(selectObj.attr("displayName"))+","+val+")");
	},"0","conditionType_formula_sub","","");
	param.subTableName = selectObj.attr("tableName");
	param.title=title;
	if (dialogArg.otherformId){
    	param.fieldPrex=selectObj.attr("fieldPre");
	}
	param.allowSubFieldAloneUse = true;
	param.notAllowNull = true;
	showFormula(param);
}

function design(){
	var current_dialog = $.dialog({
		url: "${path}/form/formula.do?method=customFunctionList&formId="+formId+"&formulaType="+formulaType+"&fieldName="+filterFields+"&fieldTableName="+fieldTableName,
		title : "${ctp:i18n('clacType.Duplicateform.design')}",
		width:600,
		height:500,
		transParams:window,
		targetWindow:getCtpTop(),
		   buttons : [{
		     text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
		     handler : function() {
		      result = current_dialog.getReturnValue();
		      if(result!=null&&result!=""){
			      setText(result);
				  current_dialog.close();
		      }
		     }
		   }, 
		   {
		     text : "${ctp:i18n('form.query.cancel.label')}",id:"exit",
		     handler : function() {setText("");current_dialog.close();}
		   }]
		 });
}

function funin(){
    if (oFormId != 0 && $("#tabs_head").find("li.current").attr("id") == "field_li") {
        $.alert("${ctp:i18n('form.create.input.relation.datafilter.error.1.label')}");
        return;
    }
    if ($("#tabs_head").find("li.current").attr("id") == "flowdata_li") {
        $.alert("${ctp:i18n('form.formula.function.extend.not.support')}");
        return;
    }
    var field = getSelectedField();
    var fieldName = field.val();
    if((field.attr("finalinputtype") && (field.attr("finalinputtype") == 'member' ||field.attr("finalinputtype") == 'account' 
            ||field.attr("finalinputtype") == 'department' ||field.attr("finalinputtype") == 'post' 
            ||field.attr("finalinputtype") == 'level'))
        ||(fieldName && (fieldName =='org_currentUserId' || fieldName =='org_currentUserDepartmentId' 
                ||fieldName =='org_currentUserPostId' ||fieldName =='org_currentUserJobLevelId' ||fieldName =='org_currentUserUnitId' ))
        ||(field.attr("inputType") && field.attr("inputType")==='outwrite' && (field.attr("formatType") == 'member' ||field.attr("formatType") == 'account' ||field.attr("formatType") == 'department'
                ||field.attr("formatType") == 'post'||field.attr("formatType") == 'level'))){
        var result="";
        var current_dialog = $.dialog({
        url: "${path}/form/formula.do?method=in&formId="+formId+"&otherformId="+oFormId+"&fieldName="+fieldName+"&fieldTableName="+(fieldTableName ? fieldTableName : "")+"&allowSubFieldAloneUse="+allowSubFieldAloneUse+"&extendSubDep="+extendSubDep+"&extendSubDep="+extendSubDep,
        title : "${ctp:i18n('form.formula.function.in')}",
        width:400,
        height:200,
        transParams:userVar,
        targetWindow:getCtpTop(),
           buttons : [{
             text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",
             handler : function() {
              result = current_dialog.getReturnValue();
              if(result!=null&&result!=""){
                  setText(result);
                  current_dialog.close();
              }
             }
           }, 
           {
             text : "${ctp:i18n('form.query.cancel.label')}",id:"exit",
             handler : function() {setText("");current_dialog.close();}
           }]
         });
    }else{
        $.alert("${ctp:i18n('form.formula.engin.selected.in.error')}");
        return "";
    }
}

</script>