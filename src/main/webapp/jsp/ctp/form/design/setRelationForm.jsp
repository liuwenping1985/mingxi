<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设置关联表单</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
</head>
<body scroll="no" style="overflow: hidden;">
<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0" height="100%" class="popupTitleRight font_size12 margin_t_10">
	<tr>
		<td>
		<table cellSpacing="2" cellPadding="2" width="95%" border="0" id="rtable">
			<tr>
				<td width="10px">&nbsp;</td>
				<td colspan="3">
				<DIV class="common_checkbox_box clearfix ">
					<LABEL class="margin_t_5 hand" for=user><INPUT id=user class=radio_com name=selectType value=1 type=radio checked><span class="margin_5">${ctp:i18n('form.relation.userSelect.label') }</span></LABEL>
					<LABEL class="margin_t_5 hand" for=system><INPUT id=system class=radio_com name=selectType value=2 type=radio><span class="margin_5">${ctp:i18n('form.relation.systemSelect.label') }</span></LABEL>
				</DIV>
				</td>
				<td width="50px">&nbsp;</td>
			</tr>
			<tr  height="20px">
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
			<td align="right" width="10px" class="padding_t_10">&nbsp;</td>
				<td width="90px" align="right" class="padding_t_10">${ctp:i18n('form.create.input.relation.label') }：</td>
				<td width="300px" class="padding_t_10">
				<div class=common_txtbox_wrap>
					<input type="text" id="relFormName" name="relFormName" value="" readonly="readonly" />
					<input type="hidden" id="relFormId" name="relFormId" value=""/>
					<input type="hidden" id="viewConditionId" name="viewConditionId" value=""/>
					<input type="hidden" id="condition" name="condition" value=""/>
					<input type="hidden" id="toFieldName" name="toFieldName" value=""/>
					</div>
				</td>
				<td align="left" class="padding_t_10">
				<a id="setRelFormBtn" class="common_button common_button_gray margin_l_5" href="javascript:void(0)">${ctp:i18n('formsection.config.choose.template.set') }</a>
				</td>
				<td width="50px"></td>
			</tr>
			<tr class="relationAttr">
			<td align="right" width="10px" class="padding_t_10">&nbsp;</td>
				<td align="right" class="padding_t_10">${ctp:i18n('form.create.input.relation.att.label') }：</td>
				<td width="300px" class="padding_t_10">
				<div class=common_selectbox_wrap style="line-height: 26px;">
					<select id="refInputAttr" name="refInputAttr" style="width:300px;margin: 0px;height: 24px;">
					<c:forEach var="field" items="${toRelationAttr }">
						<option value="${field.name }" fieldType="${field.fieldType}" inputType="${field.inputType}" isMaster="${field.masterField}" tableName="${field.ownerTableName}" fieldDigitNum="${field.digitNum}" fieldLength="${field.fieldLength}">${field.display }</option>
					</c:forEach>
					</select>
					</div>
				</td>
				<td>
				</td>
				<td></td>
			</tr>
            <tr id="setDataFilterTr">
                <td align="right" width="10" class="padding_t_10">&nbsp;</td>
                <td align="right" class="padding_t_10">${ctp:i18n('form.create.input.relation.datafilter.label')}：</td>
                <td width="300" class="padding_t_10">
                    <div class="common_txtbox clearfix">
                        <textarea id="dataFilterCondition" name="dataFilterCondition" class="w100b" readonly="readonly">${formulaStr}</textarea>
                    </div>
                </td>
                <td class="padding_t_10">
                    <a id="setDataFilterBtn" class="common_button common_button_gray margin_l_5" href="javascript:void(0)">${ctp:i18n('formsection.config.choose.template.set')}</a>
                </td>
                <td></td>
            </tr>
			<tr>
			<td width="10px">&nbsp;</td>
				<td height="130px" colspan="4" width="490px" class="padding_t_10">
				<table width="100%" id="relationCondition" Grid="true" class="hidden" border="0">
				<tr>
				<td colspan="5" class="padding_l_30">${ctp:i18n('form.relation.condition.label') }：<input type="hidden" id="currentFormId" value="${formBean.id}" /></td>
				</tr>
				<tr>
				<td colspan="2" class="padding_l_30 padding_t_10">${formBean.formName}</td>
				<td colspan="3" class="padding_l_30 padding_t_10"></td>
				</tr>
				<tr>
				<td colspan="5" width="100%" class="padding_t_20">
				<div style="overflow: auto; height:120px;width:470px" id="conditionDiv">
				<table width="450" id="rCondition">
				<tr id="conditionRow" class="conditionRow">
				<td class="padding_l_5 padding_t_5" ><div class=common_selectbox_wrap style="line-height: 20px;height: 23px;"><select id="fieldName" name="fieldName" style="width:135px;margin: 0px;padding: 0px;">
					</select></div></td>
				<td class=" padding_l_5 padding_t_5"><div class=common_selectbox_wrap style="line-height: 20px;height: 23px;"><select id="operation" name="operation" style="width:50px;margin: 0px;padding: 0px;">
					<option value="=" selected>=</option></select></div></td>
				<td class=" padding_l_5 padding_t_5"><div class=common_selectbox_wrap style="line-height: 20px;height: 23px;"><select id="fieldValue" name="fieldValue" style="width:135px;margin: 0px;padding: 0px;">
					</select></div></td>
				<td class=" padding_l_5 padding_t_5"><div class=common_selectbox_wrap style="line-height: 20px;height: 23px;"><select id="rowOperation" name="rowOperation" style="width:50px;margin: 0px;padding: 0px;">
					<option value="and" selected>and</option>
					</select></div></td>
				<td class=" padding_l_5 padding_t_5" width="60"><span id="delButton" class="repeater_reduce_16 ico16 revoked_process_16"></span> <span id="addButton" class="repeater_plus_16 ico16"> </span></td>
				</tr>
				</table>
				</div>
				</td>
				</tr>
				</table>
				</td>
			</tr>
			<tr id="viewTypeTR" class="hidden">
			<td align="right" width="10px">&nbsp;</td>
				<td colspan="3" align="left">
					<label for="viewType">
						<input type="checkbox" id="viewType" name="viewType" value="1">
						<span id="flow" class="hidden">${ctp:i18n('form.base.relationForm.showform.flow') }</span>
						<span id="noFlow" class="hidden">${ctp:i18n('form.base.relationForm.showform.unflow') }</span>
					</label>
				</td>
				<td align="right" width="50px">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
</TABLE>
</BODY>
<script type="text/javascript">
var formType = "${relForm.formType}";
var uniqueFieldList=new Array();
var fieldlist = new Array();
var relation;
<c:if test="${formulaJson != null}">
relation = $.parseJSON('${formulaJson}');
</c:if>
if(window.dialogArguments[0] == "fromEchoSetting"){
    if (window.dialogArguments[1]) {
        relation = window.dialogArguments[1];
    }
}
$().ready(function() {
	if(window.dialogArguments[0] == "fromEchoSetting"){//回写
		$("#system").prop("checked",true);
		$("#system").parents("tr:eq(0)").addClass("hidden");
		$("#rtable tr").eq(1).remove();
		$(".relationAttr").addClass("hidden");
		$("#conditionDiv").css("height","210");
		$("#setDataFilterTr").hide();
	}
	$("#addButton").click(function(){
	    if(isCanChange != "false"){
		    addConditionRow($(this).parents("tr:eq(0)"));
	    }
	});
	$("#delButton").click(function(){
	    if(isCanChange != "false"){
    		if($("tr","#rCondition").length>1){
    			$(this).parents("tr:eq(0)").remove();
    		}else{
    		    $(this).parents("tr:eq(0)").remove();
    		    addConditionRow();
    		}
	    }
	});
	$(".radio_com").click(function(){
		showConditionField();
	});
	$("#refInputAttr").change(function(){
		showViewType4FormType(formType);
	});
	$("#setDataFilterBtn").click(function(){
	    if ($("#relFormId").val() == "") {
	        $.alert("${ctp:i18n('form.create.input.select.relation')}");
	        return;
	    }
	    setDataFilter();
    });
	$("body").data("conditionRow",$("#conditionRow").clone(true));
	showViewType("${relForm.id}","${relForm.formName}","${relForm.formType}");
	//showSelectValue("${relForm.id}","${relForm.formName}","${relForm.formType}");
	initRelationConditionField("${relForm.id}","${relForm.formName}","${relForm.formType}",relation);
	showConditionField();
	var isCanChange = "${ctp:escapeJavascript(isCanChange)}";
	if(isCanChange != "false"){
		//保存表单基础信息
		$("#setRelFormBtn").click(function(){
			var dialog = $.dialog({
				url:"${path}/form/fieldDesign.do?method=relationFormList&formtype=${param.formtype}&uniquetype=${param.uniquetype}",
			    title : '${ctp:i18n('form.create.input.setting.relation.label')}',
			    width:800,
			    height:400,
			    targetWindow:getCtpTop(),
			    transParams:window,
			    buttons : [{
			      text : "${ctp:i18n('common.button.ok.label')}",
			      id:"sure",
			      handler : function() {
			    	  var condi = dialog.getReturnValue();
			    	  if(condi) dialog.close();
			      }
			    }, {
			      text : "${ctp:i18n('common.button.cancel.label')}",
			      id:"exit",
			      handler : function() {
			        dialog.close();
			      }
			    }]
			  });
		});
	}
	if(isCanChange == "false"){
		$("a").attr('href','#');
		$("input").attr("disabled",true);
		$("select").attr("disabled",true);
		$("span").attr("disabled",true);
		$("#viewType").attr("disabled","disabled");
	}
});

function  OK(){
	var returnVal = "";
	if($("#relFormName").val()==""){
		$.alert("${ctp:i18n('form.create.input.select.relation')}");
		return "error";
	}
	var isMasterField = "1";
	var subTableName = "";
	var fromSubTableName = "";
	if (window.dialogArguments[0] != "fromEchoSetting" && "${fromField.masterField}" == "false") {
	    fromSubTableName = "${fromField.ownerTableName}";
	}
	if($(".radio_com:checked").val() == 2){
		var lConditionStr = "";
		var rConditionStr = "";
		$(".conditionRow").each(function(index){
		    $("select", $(this)).each(function() {
		        if ($(this).val() == "" || $(this).val() == null) {
		            returnVal = "error";
		            return false;
		        } else {
		            returnVal = returnVal + " " + $(this).val() + " ";
		        }
		        if ($(this).attr("id") == "fieldValue") {
		            if ($(":selected", $(this)).attr("isMaster") == "false") {
		                isMasterField = "0";
		                if (!subTableName) {
		                    subTableName = $(":selected", $(this)).attr("tableName");
		                } else if (subTableName != $(":selected", $(this)).attr("tableName")) {
		                    returnVal = "subTable";
		                    $.alert("${ctp:i18n('form.base.field.relation.onlyonesubTable')}");
		                    return false;
		                }
		            }
		        }
		        if ($(this).attr("id") == "fieldName") {
		            if ($(":selected", $(this)).attr("isMaster") == "false") {
		                if (!fromSubTableName) {
		                    fromSubTableName = $(":selected", $(this)).attr("tableName");
		                } else if (fromSubTableName != $(":selected", $(this)).attr("tableName")) {
		                    returnVal = "subTable";
		                    $.alert("${ctp:i18n('form.base.field.relation.onlyonesubTable')}");
		                    return false;
		                }
		            }
		        }
		    });
			if(returnVal == "error" || returnVal == "subTable"){
				return false;
			}
			//对关联条件进行判断是否类型
			var lt = $("#fieldName",this).find("option:selected").attr("fieldType");	
			var rt = $("#fieldValue",this).find("option:selected").attr("fieldType");
			var lname = $("#fieldName",this).find("option:selected").val();
			var rname = $("#fieldValue",this).find("option:selected").val();
			var lnameStr = "&" + lname + "&";
			var rnameStr = "&" + rname + "&";
			if(lConditionStr.indexOf(lnameStr) > -1){
				$.alert("${ctp:i18n('form.relation.condition.exit')}");
				returnVal = "errortype";
				return false;
			}else if(rConditionStr.indexOf(rnameStr) > -1){
				$.alert("${ctp:i18n('form.relation.condition.exit')}");
				returnVal = "errortype";
				return false;
			}else{
				lConditionStr = lConditionStr + lnameStr;
				rConditionStr = rConditionStr + rnameStr;
			}
			if(lt!=rt){
				var rownumber = index + 1;
				$.alert("${ctp:i18n_1('form.relation.condition.error.2.label', '" + rownumber + "')}");
				returnVal = "errortype";
				return false;
			}
		});
		if(returnVal == "errortype" || returnVal == "subTable"){
			return "error";
		}
		if(returnVal == "error"||returnVal == ""){
			$.alert("${ctp:i18n('form.relation.condition.error.1.label')}");
			return "error";
		}
	}
	if(window.dialogArguments[0] == "fromEchoSetting"){//回写
		var ret = new Object();
		ret.formId = $("#relFormId").val();
		ret.formName = $("#relFormName").val();
		ret.condition = returnVal.substring(0,returnVal.length-4);
		ret.isMasterField = isMasterField;
		ret.subTableName = subTableName;
		ret.fromSubTableName = fromSubTableName;
		return ret;
	}else{
		var currentFieldType = $("#refInputAttr").find("option:selected").attr("fieldType");
	    var currentFieldLength = $("#refInputAttr").find("option:selected").attr("fieldLength");
	    var currentFieldDigitNum = $("#refInputAttr").find("option:selected").attr("fieldDigitNum");
	    var relationFieldType =  $("#refInputAttr").find("option:selected").attr("isMaster");
	    var currentInputType = $("#refInputAttr").find("option:selected").attr("inputType");
	    var tableName =  $("#refInputAttr").find("option:selected").attr("tableName");
	    var index = window.dialogArguments[1];
	    var parentDoc = window.dialogArguments[0].document;
		if(isAccordUniqueMarked($("#fieldName"+index,$(parentDoc)).attr("value"),$("#refInputAttr").val(),$("#uniquedatafield",$(parentDoc)).val())){
			$.alert("该字段已经被设置成唯一标示字段，关联属性不能选择流程名称！请重新设置！");
			return "error";
		}else{
			$("#fieldType"+index,$(parentDoc)).val(currentFieldType);
			$("#fieldType"+index,$(parentDoc)).attr("oldFieldType",currentFieldType);
			if(currentFieldType == "DECIMAL"){
                $("#fieldLength"+index,$(parentDoc)).attr("validate","");
				$("#fieldLength"+index,$(parentDoc)).val(currentFieldLength);
				$("#fieldLength"+index,$(parentDoc)).attr("readonly","readonly");
				$("#digitNum"+index,$(parentDoc)).attr("readonly","readonly");
				var validateName = "${ctp:i18n('form.field.digit.length.label')}";
				$("#fieldLength"+index,$(parentDoc)).attr("validate","name:'"+validateName+"',notNull:true,isInteger:true,maxValue:30");
				$("#fieldLength"+index,$(parentDoc)).show();
			}else if(currentFieldType == "VARCHAR"){
                $("#fieldLength"+index,$(parentDoc)).attr("validate","");
				$("#fieldLength"+index,$(parentDoc)).val(currentFieldLength);
				$("#fieldLength"+index,$(parentDoc)).attr("readonly","readonly");
				var validateName = "${ctp:i18n('form.field.string.length.label')}";
				$("#fieldLength"+index,$(parentDoc)).attr("validate","name:'"+validateName+"',notNull:true,isInteger:true,maxValue:4000");
				$("#fieldLength"+index,$(parentDoc)).show();
			}else{
				$("#fieldLength"+index,$(parentDoc)).val("");
				$("#fieldLength"+index,$(parentDoc)).hide();
			}
			if(currentFieldType == "DECIMAL"){
				//$("#formatType"+index,$(parentDoc)).show();
				$("#formatType"+index,$(parentDoc)).empty();
				$("#formatType"+index,$(parentDoc)).append("<option value=\"\"></option><option value='<%=FormConstant.ThousandTag%>'>${ctp:i18n('form.input.format.qianfen.label')}</option>" 
						+"<option value='<%=FormConstant.HundredTag%>'>${ctp:i18n('form.input.format.baifenhao.label')}</option><option value='<%=FormConstant.DateTime%>'>${ctp:i18n('form.format.dayhourminute')}</option>"
						+"<option value='<%=FormConstant.Day%>'>×${ctp:i18n('form.compute.day.label')}</option>");
				if(currentFieldDigitNum != "undefined" && currentFieldDigitNum != "null"){
					$("#digitNum"+index,$(parentDoc)).val(currentFieldDigitNum);
				}
				$("#digitNum"+index,$(parentDoc)).show();
			}else{
				$("#digitNum"+index,$(parentDoc)).val("");
				$("#formatType"+index,$(parentDoc)).empty();
				$("#formatType"+index,$(parentDoc)).hide();
				$("#digitNum"+index,$(parentDoc)).hide();
			}
		}
		//alert($.toJSON($("body").formobj({domains:[ 'rtable', 'relationCondition']})));
		var formulaStr = "";
		if($(".radio_com:checked").val() == 2){
			formulaStr = returnVal.substring(0,returnVal.length-4);
			$("#condition").val(formulaStr);
		}else{
		    formulaStr = $("#dataFilterCondition").val();
		}
		var manager = new formFieldDesignManager();
		manager.saveOrUpdateRelationForm($("body").formobj({domains:[ 'rtable', 'relationCondition']}));
        $("#bindSetAttr"+index,$(parentDoc)).attr("viewCondition",formulaStr);
		$("#bindSetAttr"+index,$(parentDoc)).attr("selectType",$('input:radio[name="selectType"]:checked').val());
		$("#bindSetAttr"+index,$(parentDoc)).attr("bindObjId",$("#relFormId").val());
		$("#bindSetAttr"+index,$(parentDoc)).attr("isMaster",relationFieldType);
		$("#bindSetAttr"+index,$(parentDoc)).attr("tableName",tableName);
		$("#bindSetAttr"+index,$(parentDoc)).attr("bindAttr",$("#refInputAttr").val());
		var relFormName = $("#relFormName").val()+"-"+$("#refInputAttr").find("option:selected").text();
		$("#selectBindInput"+index,$(parentDoc)).val(relFormName);
	}
}

function showSelectValue(id,name,formType){
	if(!id || id==null) return;
  var fdManager = new formFieldDesignManager();
  var returnObj = fdManager.getRelationFormField(id);
  var refInput = $("#refInputAttr");
  refInput.empty();
  for(var k=0;k<returnObj.length;k++){
	  refInput.append('<option value="'+returnObj[k].name+'" fieldType="'+returnObj[k].fieldType+'" inputType="'+returnObj[k].inputType+'" isMaster="'+returnObj[k].masterField+'" tableName="'+returnObj[k].ownerTableName+'" fieldDigitNum="'+returnObj[k].digitNum+'" fieldLength="'+returnObj[k].fieldLength+'">'+returnObj[k].display+'</option>');
  }
  if($(".relationAttr").hasClass("hidden")){//ie6下 会显示出来
	  $(".relationAttr").removeClass("hidden").addClass("hidden");
  }
} 

//是否是主表字段
function isMasterField(oo){
	if(oo.ownerTableName.indexOf("formmain_")>-1){
		return true;
	}
	return false;
}
function isAccordUniqueMarked(fieldName,refAttr,fieldStr){
	var isAccord = false;
	if(fieldStr != undefined){
		var fieldArray = fieldStr.split(",");
		for(var i=0;i < fieldArray.length;i++){
			if(fieldArray[i] == fieldName && refAttr == "flowName"){
				isAccord = true;
				break;
			}
		}
	}
	return isAccord;
}
function showViewType(id,name,formType,isSelected){
	if(!id || id==null) return;
	$("#relFormId").val(id);
	$("#relFormName").val(name);
	showViewType4FormType(formType);
	if(isSelected){
        $("#viewType").prop("checked",false);
	    $("#dataFilterCondition").val("");
	}
}
function showViewType4FormType(ft){
	if(formType==1){
		  if($("#refInputAttr").val()=="flowName"){
			  $("#viewTypeTR").removeClass("hidden");
			  $("#flow").removeClass("hidden");
			  $("#noFlow").removeClass("hidden").addClass("hidden");
		  }else{
			  $("#viewTypeTR").removeClass("hidden").addClass("hidden");
			  $("#flow").removeClass("hidden").addClass("hidden");
			  $("#noFlow").removeClass("hidden").addClass("hidden");
			  $("#viewType").attr("checked",false);
		  }
	  }else{
		  $("#viewTypeTR").removeClass("hidden");
		  $("#flow").removeClass("hidden").addClass("hidden");
		  $("#noFlow").removeClass("hidden");
	  }
	  if($(".radio_com:checked").val() == 2){
		  $("#viewTypeTR").removeClass("hidden").addClass("hidden");
	  }
}
function addConditionRow(obj){
	var cRow = $("body").data("conditionRow").clone(true);
	if(obj){
		cRow.insertAfter($(obj));
	}else{
		$("#rCondition").append(cRow);
	}
	return cRow;
}

function initRelationConditionField(id,name,formType,hasConList){
	if(id==null||id==""||id==" ")return;
	var fdManager = new formFieldDesignManager();
	var o = fdManager.getRelationUniqueField(id);
	uniqueFieldList = o.uniqueField;
	fieldlist = o.srcField;
	var obj = $("body").data("conditionRow");
	var srcF = $("#fieldName",obj);
	if(fieldlist.length>0){
		srcF.empty();
		srcF.append('<option value=""></option>');
		var currentFieldName;
		if(window.dialogArguments[0]!="fromEchoSetting"){//不是回写选择的表单才需要验证
		    var index = window.dialogArguments[1];
		    var parentDoc = window.dialogArguments[0].document;
		    currentFieldName = $("#fieldName"+index,parentDoc).attr("value");
		}
		for(var k=0;k<fieldlist.length;k++){
			//过滤流程处理意见字段,过滤本身
			if(fieldlist[k].ownerTableName != undefined && fieldlist[k].inputType != "flowdealoption" && fieldlist[k].name != currentFieldName){
				var val = ("{a"+fieldlist[k].ownerTableName.substring(fieldlist[k].ownerTableName.indexOf("_")+1))+"."+fieldlist[k].display+"}";
				srcF.append('<option tableName="'+fieldlist[k].ownerTableName+'" value="'+val+'" fieldType="'+fieldlist[k].fieldType+'" inputType="'+fieldlist[k].inputType+'" isMaster="'+isMasterField(fieldlist[k])+'">'+fieldlist[k].display+'</option>');
			}
		}
	}else{
		srcF.empty();
		srcF.append('<option value=""></option>');
	}
	var tarF = $("#fieldValue",obj);
	if(uniqueFieldList.length>0){
		tarF.empty();
		for (var k = 0; k < uniqueFieldList.length; k++) {
		    //联动-汇总：只显示主表唯一字段
		    if ("${param.uniquetype}" == "master" && !isMasterField(uniqueFieldList[k])) {
		        continue;
		    }
		    var val = ("{b" + uniqueFieldList[k].ownerTableName.substring(uniqueFieldList[k].ownerTableName.indexOf("_") + 1)) + "." + uniqueFieldList[k].display + "}";
		    tarF.append('<option tableName="' + uniqueFieldList[k].ownerTableName + '" value="' + val + '" fieldType="' + uniqueFieldList[k].fieldType + '" inputType="' + uniqueFieldList[k].inputType + '" isMaster="' + isMasterField(uniqueFieldList[k]) + '">' + uniqueFieldList[k].display + '</option>');
		}
		if(o.unList.length>0){
			for(var k=0;k<o.unList.length;k++){
				var val = ("{b"+o.unList[k].ownerTableName.substring(o.unList[k].ownerTableName.indexOf("_")+1))+"."+o.unList[k].display+"}";
				tarF.append('<option tableName="'+o.unList[k].ownerTableName+'" value="'+val+'" fieldType="'+o.unList[k].fieldType+'" inputType="'+o.unList[k].inputType+'" isMaster="'+isMasterField(o.unList[k])+'">'+o.unList[k].display+'</option>');
			}
		}
	}else{
		tarF.empty();
		tarF.append('<option value=""></option>');
	}
	var formNameTd = $("td",$("tr:eq(1)","#relationCondition"));
	formNameTd.eq(0).text("${formBean.formName}");
	formNameTd.eq(1).text(name);
	if(hasConList&&hasConList.length>0){
		$(".conditionRow").remove();
		for(var i=0;i<hasConList.length;i++){
			var obj = addConditionRow();
			for(var s in hasConList[i]){
				$("#"+s,obj).val(hasConList[i][s]);
			}
		}
	}else{
		setConditionField();
	}
}

function setConditionField(){
	$(".conditionRow").remove();
	if(uniqueFieldList.length>0){
	    for (var i = 0; i < uniqueFieldList.length; i++) {
	        //联动-汇总：只显示主表唯一字段
	        if ("${param.uniquetype}" == "master" && !isMasterField(uniqueFieldList[i])) {
	            continue;
	        }
	        var obj = addConditionRow();
	        var val = ("{b" + uniqueFieldList[i].ownerTableName.substring(uniqueFieldList[i].ownerTableName.indexOf("_") + 1)) + "." + uniqueFieldList[i].display + "}";
	        $("#fieldValue", obj).val(val);
	    }
	}else{
		addConditionRow();
	}
}
function showConditionField(){
	if($(".radio_com:checked").val() == 1){
		$("#relationCondition").removeClass("hidden").addClass("hidden");
		$("#setDataFilterTr").show();
		if($("#relFormName").val()!="" && (formType == 2 || formType==3)){
			$("#viewTypeTR").removeClass("hidden");
			$("#flow").removeClass("hidden").addClass("hidden");
			$("#noFlow").removeClass("hidden");
		}
	}else{
		if($("#relFormId").val()!=""&&(formType==1||uniqueFieldList==null||uniqueFieldList.length==0)){
			$.alert({
        	    'msg' : "${ctp:i18n('form.base.field.set.relation.needunique.label')}",
        	    ok_fn : function() {
        	    	$("#relFormId").val("");
        	    	$("#relFormName").val("");
        	    	$("#refInputAttr").empty();
        	    	var formNameTd = $("td",$("tr:eq(1)","#relationCondition"));
        	    	formNameTd.eq(0).text("");
        	    	formNameTd.eq(1).text("");
        	    	$(".conditionRow").remove();
        	    	var currentRow = addConditionRow();
        	    	$("#fieldName",currentRow).empty();
        	    	$("#dataFilterCondition").val("");
        	    }
        	  });
		}
		$("#relationCondition").removeClass("hidden");
		$("#setDataFilterTr").hide();
		$("#viewTypeTR").removeClass("hidden").addClass("hidden");
	}
	
}

/**
 * 数据过滤
 */
function setDataFilter(){
    var formulaArgs = getConditionArgs(
        function(formulaStr){
            $("#dataFilterCondition").val(formulaStr);
            return true;
        }, '0', 'conditionType_sql', $("#dataFilterCondition").val(), null);
    formulaArgs.title = "${ctp:i18n('form.create.input.relation.datafilter.condition.label')}";
    formulaArgs.allowSubFieldAloneUse = true;
    formulaArgs.allowSubFieldAloneUse4A = "${fromField.masterField}" == "true" ? false : true;
    formulaArgs.allowSubFieldAloneUse4B = true;
    formulaArgs.fieldTableName = "${fromField.ownerTableName}";
    formulaArgs.filterFields = "${fromField.name}";
    formulaArgs.operationType = "relationform";
    formulaArgs.tabindex = 1;
    formulaArgs.otherformId = $("#relFormId").val();
    showFormula(formulaArgs);
}
</script>
</HTML>