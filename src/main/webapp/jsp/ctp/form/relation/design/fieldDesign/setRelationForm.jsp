<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page
		import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>设置关联表单</title>
</head>
<body scroll="no" style="overflow: hidden;" class="hidden">
<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0"
	   height="100%" class="popupTitleRight font_size12 margin_t_10">
	<tr>
		<td>
			<table cellSpacing="2" cellPadding="2" width="95%" border="0" id="rtable">
				<tr>
					<td width="10px">&nbsp;</td>
					<td colspan="3" class="hidden">
						<DIV class="common_checkbox_box clearfix ">
							<input type="text" class="hidden" id="oldSelectType">
							<LABEL class="margin_t_5 hand" for=user>
								<INPUT id=user class=radio_com name=selectType value=1 type=radio checked>
								<span class="margin_5">${ctp:i18n('form.relation.userSelect.label') }</span>
							</LABEL>
							<LABEL class="margin_t_5 hand" for=system>
								<INPUT id=system class=radio_com name=selectType value=2 type=radio>
								<span class="margin_5">${ctp:i18n('form.relation.systemSelect.label') }</span>
							</LABEL>
						</DIV>
					</td>
					<td width="50px">&nbsp;</td>
				</tr>
                <tr id="setDataFilterTr">
                    <td width="10px">&nbsp;</td>
                    <td  colspan="4" width="490px" class="padding_t_10">
                        <table width="100%" border="0">
                            <tr>
                                <td colspan="5" class="padding_l_30">${ctp:i18n('form.operhigh.dataarea.label')}：</td>
                            </tr>
                            <tr>
                                <td colspan="5" width="100%" class="padding_t_10" style="padding-left:24px;">
                                    <div style="overflow: auto; height: 220px; width: 470px">
                                        <table>
                                            <tr><td colspan="5" class="padding_l_30"></td></tr>
                                            <tr><td colspan="5" width="100%" class="padding_t_10" style="padding-left:24px;">${formulaStr}</td></tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>

                </tr>
				<tr>
					<td  colspan="5" width="440px" class="">
						<fieldset style="margin-left:32px;margin-right:30px" class="form_area padding_5 margin_t_5">
							<legend>&nbsp;${ctp:i18n('form.relation.condition.label') }&nbsp;</legend>
						<table width="100%" id="relationCondition" Grid="true" border="0">
							<tr>
								<td colspan="5" class="padding_l_30"><input type="hidden" id="currentFormId" value="${formBean.id}" /></td>
							</tr>
							<tr>
								<td colspan="5">
									<table width="460" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="67%" align="left" class="padding_l_15 padding_t_10" title="${formBean.formName}">${ctp:getLimitLengthString(formBean.formName, 28, '...')}</td>
											<td width="33%"align="left"  class="padding_t_10"></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="5" width="100%" class="padding_t_10" style="">
									<div style="overflow-y: auto; overflow-x: hidden; width: 470px" id="conditionDiv">
										<table width="460" id="rCondition" align="center">
											<tr id="conditionRow" class="conditionRow" height="22" style="margin-top: 5px;">
												<td class="padding_l_5 padding_t_5" width="35%" height="20" >
													<div class=common_selectbox_wrap style="line-height: 20px; height: 26px;"title="">
														<select id="fieldName" name="fieldName" style="width: 155px; margin: 0px; padding: 0px;">
														</select>
													</div>
												</td>
												<td class=" padding_l_5 padding_t_5" align="center">
													<div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
														<select id="operation" name="operation" style="width: 50px; margin: 0px; padding: 0px;">
														<option value="=" selected>=</option>
														</select>
													</div>
												</td>
												<td class=" padding_l_5 padding_t_5" width="35%">
													<div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
													<select id="fieldValue" name="fieldValue" style="width: 135px; margin: 0px; padding: 0px;">
													</select>
													</div>
												</td>
												<%--<td class=" padding_l_5 padding_t_5">
													<div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
														<select id="rowOperation" name="rowOperation" style="width: 50px; margin: 0px; padding: 0px;">
															<option value="and" selected>and</option>
														</select>
													</div>
												</td>--%>

											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
						</fieldset>
					</td>
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
	var isCanChange = "${ctp:escapeJavascript(isCanChange)}";

	function isEchoStting(){
		if(window.dialogArguments[0] && window.dialogArguments[0] === "fromEchoSetting")
		{
			return true;
		}
		return false;
	}
	$().ready(function() {
		
		if(isEchoStting()){//回写
			$("#system").prop("checked",true);
			$("#system").parents("tr:eq(0)").addClass("hidden");
			//$("#rtable tr").eq(1).remove();
			$(".relationAttr").addClass("hidden");
			$("#conditionDiv").css("height","250");
			$("#setDataFilterTr").hide();
			$("#viewTypeTR").addClass("hidden");
			$("#viewTypeTR2").addClass("hidden");
		}
		$("body").show();
		if($.browser.msie || $.browser.mozilla){
			$("label>span").css("vertical-align", "middle");
		}
/*		$("#addButton").click(function(){
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
		});*/
	/*	$(".radio_com").click(function(){
			selectTypeChange();
		});
		$("#setDataFilterBtn").click(function(){
			if ($("#relFormId").val() == "") {
				$.alert("${ctp:i18n('form.create.input.select.relation')}");
				return;
			}
			setDataFilter();
		});*/
		$("body").data("conditionRow",$("#conditionRow").clone(true));
		showViewType("${relForm.id}","${relForm.formName}","${relForm.formType}");
		<%--showSelectValue("${relForm.id}","${relForm.formName}","${relForm.formType}");--%>
		initRelationConditionField("${formBean.id}","${relForm.id}","${relForm.formName}","${relForm.formType}",relation);
		showConditionField();
		if(isCanChange != "false"){
			//保存表单基础信息
			$("#setRelFormBtn").click(function(){
				var dialog = $.dialog({
					url:"${path}/form/fieldDesign.do?method=relationFormList&formtype=${param.formtype}&uniquetype=${param.uniquetype}",
					title : '${ctp:i18n('form.create.input.setting.relation.label')}',
					width:800,
					height:480,
					targetWindow:getCtpTop(),
					transParams:window,
					buttons : [{
						text : "${ctp:i18n('common.button.ok.label')}",
						id:"sure",
						isEmphasize: true,
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
			$("#viewTypeTR").attr("disabled",false);
			$("input","#viewTypeTR").attr("disabled",false);
			$("span","#viewTypeTR").attr("disabled",false);
			$("#viewTypeTR2").attr("disabled",false);
			$("input","#viewTypeTR2").attr("disabled",false);
			$("span","#viewTypeTR2").attr("disabled",false);
		}
		var x=$("#rCondition tr#conditionRow");
		x.each(function () {
			var s=$("div",this);
			s.each(function () {
				var select=$("select",$(this));
				var title=$("option:selected",select).text();
				$(this).attr("title",title);
			});
		});
	});

	function OK(){
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
			var result;
			if(isCanChange != "false"){
				result = isFormFieldChangeError(index,parentDoc,currentFieldType,currentInputType);
			}
			if(isAccordUniqueMarked($("#fieldName"+index,$(parentDoc)).attr("value"),$("#refInputAttr").val(),$("#uniquedatafield",$(parentDoc)).val())){
				$.alert("该字段已经被设置成唯一标示字段，关联属性不能选择流程名称！请重新设置！");
				return "error";
			}else if(result && result.value != "1"){
				$.alert(result.error);
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

	function isFormFieldChangeError(index,parentDoc,currentFieldType,currentInputType) {
		var options = getParentValidateFieldOptions(index,parentDoc,currentFieldType,currentInputType);
		var result = vlidateFormFieldChange(options);
		return result;
	}

	function getParentValidateFieldOptions(index,parentDoc,currentFieldType,currentInputType){
		var options = new Object();
		options.fieldName = $("#fieldName"+index,$(parentDoc)).attr("value");
		options.fieldType = currentFieldType;
		options.oldFieldType = $("#fieldType"+index,$(parentDoc)).attr("oldFieldType");
		options.fieldLength = $("#fieldLength"+index,$(parentDoc)).val();
		options.digitNum = $("#digitNum"+index,$(parentDoc)).val();
		options.inputType = currentInputType;
		options.oldInputType = $("#inputType"+index,$(parentDoc)).attr("oldInputType");
		options.display = $("#fieldName"+index,$(parentDoc)).attr("display");
		return options;
	}

	function showSelectValue(id,name,formType){
		if(!id || id==null) return;
		var fdManager = new formFieldDesignManager();
		var returnObj = fdManager.getRelationFormField(id);
		var refInput = $("#refInputAttr");
		var div = $("#refInputAttrDiv");
		div.html("");
		refInput.empty();
		div.append(refInput);
		for(var k=0;k<returnObj.length;k++){
			refInput.append('<option value="'+returnObj[k].name+'" fieldType="'+returnObj[k].fieldType+'" inputType="'+returnObj[k].inputType+'" isMaster="'+returnObj[k].masterField+'" tableName="'+returnObj[k].ownerTableName+'" fieldDigitNum="'+returnObj[k].digitNum+'" fieldLength="'+returnObj[k].fieldLength+'">'+returnObj[k].display+'</option>');
		}
		if($(".relationAttr").hasClass("hidden")){//ie6下 会显示出来
			$(".relationAttr").removeClass("hidden").addClass("hidden");
		}
		refInput.comp();
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
		return isAccord;
	}
	function showViewType(id,name,formType,isSelected){
		if(!id || id==null) return;
		$("#relFormId").val(id);
		$("#relFormName").val(name);
		showViewType4FormType(formType);
		if(isSelected){
			$("#viewType").prop("checked",false);
			$("#refreshRelation").prop("checked",false);
			$("#showView").prop("checked",false);
			$("#dataFilterCondition").val("");
		}
	}
	function showViewType4FormType(ft){
		if(formType==1){//流程表单
			if($("#refInputAttr").val()=="flowName"){
				$("#flow").removeClass("hidden");
				$("#viewType").removeClass("hidden");
			}else{
				$("#flow").removeClass("hidden").addClass("hidden");
				$("#viewType").attr("checked",false).addClass("hidden");
				$("#refreshRelation").attr("checked",false);
			}
			$("#noFlow").removeClass("hidden").addClass("hidden");
		}else{
			$("#viewType").removeClass("hidden");
			$("#flow").removeClass("hidden").addClass("hidden");
			$("#noFlow").removeClass("hidden");
		}
		$("#viewTypeTR").removeClass("hidden");
		if($(".radio_com:checked").val() == 2){
			$("#viewType").removeClass("hidden").addClass("hidden");
			$("#flow").removeClass("hidden").addClass("hidden");
			$("#noFlow").removeClass("hidden").addClass("hidden");
			$("#showView").removeClass("hidden").addClass("hidden");
			$("#showViewSpan").removeClass("hidden").addClass("hidden");
		}else{
			$("#showView").removeClass("hidden");
			$("#showViewSpan").removeClass("hidden");
		}
		//无流程到无流程，才显示关联同步 add by chenxb 2016-03-03 bug OA-89122
		var ffy = ${formBean.formType};
		var value = $("#refInputAttr").find("option:selected").attr("ismaster");
		if((ffy == 2 || ffy == 3) && (formType == 2 || formType == 3) && value == "true"){
			$("#viewTypeTR2").removeClass("hidden");
		}else{
			$("#viewTypeTR2").removeClass("hidden").addClass("hidden");
		}
	}
	function addConditionRow(obj, comp){
		var cRow = $("body").data("conditionRow").clone(true);
		if (!comp) {
			cRow.comp();
		}
		if(obj){
			cRow.insertAfter($(obj));
		}else{
			$("#rCondition").append(cRow);
		}
		//设置关联表单下拉框(系统自动增加的控件)样式的高度
		$(":input[name='acToggle']").css("height", "26px");
		return cRow;
	}

	function initRelationConditionField(srcFormId, tarFormId, name,formType,hasConList){
		if(tarFormId==null||tarFormId==""||tarFormId==" ")return;
		var fdManager = new formFieldDesignManager();
		var o = fdManager.getRelationUniqueField(srcFormId, tarFormId);
		uniqueFieldList = o.uniqueField;
		fieldlist = o.srcField;
		var obj = $("body").data("conditionRow");
		var srcF = $("#fieldName",obj);
		srcF.addClass("validate comp enumselect common_drop_down").attr("comp","type:'autocomplete',autoSize:true,change:'showViewType4FormType'").attr("comptype","autocomplete");
		if(fieldlist.length>0){
			srcF.empty();
			//srcF.append('<option value=""></option>');
			var currentFieldName;
			if(window.dialogArguments[0]!="fromEchoSetting"){//不是回写选择的表单才需要验证
				var index = window.dialogArguments[1];
				var parentDoc = window.dialogArguments[0].document;
				currentFieldName = $("#fieldName"+index,parentDoc).attr("value");
			}
			for(var k=0;k<fieldlist.length;k++){
				//过滤流程处理意见字段,过滤本身
				if(fieldlist[k].ownerTableName != undefined &&
						fieldlist[k].inputType != "flowdealoption" &&
						fieldlist[k].name != currentFieldName){
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
				<%--//联动-汇总：只显示主表唯一字段--%>
				<%--if ("${param.uniquetype}" == "master" && !isMasterField(uniqueFieldList[k])) {--%>
					<%--continue;--%>
				<%--}--%>
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
		var formNameTd = $("td table tr td",$("tr:eq(1)","#relationCondition"));
		formNameTd.eq(0).text("${ctp:getLimitLengthString(formBean.formName, 27, '...')}");
        var bytes=name.replace(/[^\x00-\xff]/g,'**').length;// 字节长度
        function cutStr(str,L){
            var result = '',
                    strlen = str.length,
                    chrlen = str.replace(/[^\x00-\xff]/g,'**').length;

            if(chrlen<=L){return str;}
            for(var i=0,j=0;i<strlen;i++){
                var chr = str.charAt(i);
                if(/[\x00-\xff]/.test(chr)){
                    j++;
                }else{
                    j+=2;
                }
                if(j<=L){
                    result += chr;
                }else{
                    return result;
                }
            }
        }
		if(bytes>22){
			formNameTd.eq(1).text(cutStr(name,22)+"...");
		}else{
			formNameTd.eq(1).text(name);
		}
		formNameTd.eq(1).attr("title",name);
		if(hasConList&&hasConList.length>0){
			$(".conditionRow").remove();
			for(var i=0;i<hasConList.length;i++){
				var row = addConditionRow(null, true);
				for(var s in hasConList[i]){
					if(s == "rowOperation") {
						//OA-89355 ie11下这里给and赋值后，保存时取到的为null。
					}else{
						$("#"+s,row).val(hasConList[i][s]);
					}
				}
				row.comp();
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
				<%--var srcFiled = "${fromRelationAttr}";--%>
				$("#fieldValue", obj).val(val);
			}
		}else{
			addConditionRow();
		}
	}
	function showConditionField() {
		if ($(".radio_com:checked").val() == 1) {
			$("#relationCondition").removeClass("hidden").addClass("hidden");
			$("#setDataFilterTr").show();
			if ($("#relFormName").val() != "" && (formType == 2 || formType == 3)) {
				$("#viewTypeTR").removeClass("hidden");
				$("#flow").removeClass("hidden").addClass("hidden");
				$("#noFlow").removeClass("hidden");
				$("#viewType").removeClass("hidden");
			}
		} else {
			if ($("#relFormId").val() && (formType == 1 || uniqueFieldList == null || uniqueFieldList.length == 0)) {
				$.alert({
					'msg': "${ctp:i18n('form.base.field.set.relation.needunique.label')}",
					ok_fn: function () {
						$("#relFormId").val("");
						$("#relFormName").val("");
						$("#refInputAttr").empty();
						var formNameTd = $("td", $("tr:eq(1)", "#relationCondition"));
						formNameTd.eq(0).text("");
						formNameTd.eq(1).text("");
						$(".conditionRow").remove();
						var currentRow = addConditionRow();
						$("#fieldName", currentRow).empty();
						$("#dataFilterCondition").val("");
					}
				});
			}
			$("#relationCondition").removeClass("hidden");
			$("#setDataFilterTr").hide();
			$("#viewTypeTR").removeClass("hidden").addClass("hidden");
			$("#viewType").removeClass("hidden").addClass("hidden");
			$("#flow").removeClass("hidden").addClass("hidden");
			$("#noFlow").removeClass("hidden").addClass("hidden");
		}
		//设置关联表单下拉框(系统自动增加的控件)样式的高度
		$(":input[name='acToggle']").css("height", "26px");
	}

	function selectTypeChange(){
		var oldType = $("#oldSelectType").val();
		if(oldType != $(".radio_com:checked").val()) {
			var needToTips = false;
			var refInputAttr = $("#refInputAttr").val();
			if(refInputAttr){
				needToTips = true;
			}
			if(needToTips){
				$.confirm({
					'msg': '${ctp:i18n("form.relation.formula.change.tips.label")}',
					ok_fn: function () {
						clearRelationAttr();
						showConditionField();
					},
					cancel_fn:function(){
						if($(".radio_com:checked").val() == "2"){
							$("#user").attr("checked",true);
						}else{
							$("#system").attr("checked",true);
						}
					}
				});
			}else{
				clearRelationAttr();
				showConditionField();
			}
		}
	}
	function clearRelationAttr(){
		$("#oldSelectType").val($(".radio_com:checked").val());
		//清空关联表单
		$("#relFormName").val("");
		$("#relFormId").val("");
		$("#viewConditionId").val("");
		$("#condition").val("");
		//$("#toFieldName").val("");
		//清空关联属性
		var refInput = $("#refInputAttr");
		var div = $("#refInputAttrDiv");
		div.html("");
		refInput.empty();
		div.append(refInput);
		refInput.comp();
		//关联条件
		var formNameTd = $("td", $("tr:eq(1)", "#relationCondition"));
		formNameTd.eq(1).text("");
		var obj = $("body").data("conditionRow");
		var srcF = $("#fieldName", obj);
		srcF.empty();
		srcF.append('<option value=""></option>');
		var tarF = $("#fieldValue", obj);
		tarF.empty();
		tarF.append('<option value=""></option>');
		$(".conditionRow").remove();
		addConditionRow(null, true);
		//数据过滤
		$("#dataFilterCondition").val("");
		//其他相关属性
		$("#viewType").val("1");
		$("#showView").val("0");
		$("#refreshRelation").val("1");
		$("#showView").prop("checked", false);
		$("#viewType").prop("checked", false);
		$("#refreshRelation").prop("checked", false);
		$("#viewTypeTR2").removeClass("hidden").addClass("hidden");
		$("#showView").removeClass("hidden").addClass("hidden");
		$("#showViewSpan").removeClass("hidden").addClass("hidden");
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
<script type="text/javascript" src="${path}/common/form/design/designBaseInfo.js${ctp:resSuffix()}"></script>
</HTML>