
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.baseinfo.subtable.relation.data.setting.title')}</title>
<script type="text/javascript">
var selectIndex = -1;
var tablenamelst = new ArrayList();
var sign = 0;
$(document).ready(function(){
	$("div[name='matchDIV']").click(function(){
		getDataMacthIndex(this);
	});
	$("#add").click(function() {
		add(this);
	});

	$("#del").click(function() {
		del(this);
	});
	$('#up').click(function() {
		upordown(-1);
	});
	$('#down').click(function() {
		upordown(1);
	});
  	$("#select_selected").click(addToRight);
  	$("#select_unselect").click(delect);
	showRightDatas();
	showDownDatas();
});
/**
 * 获取选中的匹配项,将其中的选中项高亮显示，其它项去掉高亮显示
 */
function getDataMacthIndex(obj){
	$("#matcharea").find("div[name='matchDIV']").each(function(i){
		if(this.id == obj.id){
			selectIndex = i;
			$(this).css("background","highlight");
			$(this).css("color","highlighttext");
		}else{
			$(this).css("background","");
			$(this).css("color","");
		}
	});
}

function upordown(nDir) {
	if (selectIndex < 0)
		return;
	var selectObj = $("#matcharea").find("div[name='matchDIV']");
	var items = selectObj.find("div[id^='left']");
	if (nDir < 0) {
		if (selectIndex == 0)
			return;
	} else {
		if (selectIndex == items.length - 1)
			return;
	}
	changeValue(selectObj,nDir,"left");
	changeValue(selectObj,nDir,"right");
	selectIndex += nDir;
	$("#matcharea").find("div[name='matchDIV']").each(function(i){
		if(selectIndex == i){
			$(this).css("background","highlight");
			$(this).css("color","highlighttext");
		}else{
			$(this).css("background","");
			$(this).css("color","");
		}
	});
}

function changeValue(selectObj,nDir, lor) {
	var items = selectObj.find("div[id^='"+lor+"']");
	var opt = items.get(selectIndex);
	var otheropt = items.get(selectIndex+nDir);
	var name = opt.attributes['name'].value;
	var fieldname = opt.attributes['fieldname'].value;
	var tablename =opt.attributes['tablename'].value;
	var title=opt.attributes['title'].value;
	var text=opt.innerHTML;
	opt.attributes['name'].value=otheropt.attributes['name'].value;
	opt.attributes['fieldname'].value=otheropt.attributes['fieldname'].value;
	opt.attributes['tablename'].value=otheropt.attributes['tablename'].value;
	opt.attributes['title'].value=otheropt.attributes['title'].value;
	opt.innerHTML=otheropt.innerHTML;
	otheropt.attributes['name'].value=name;
	otheropt.attributes['fieldname'].value=fieldname;
	otheropt.attributes['tablename'].value=tablename;
	otheropt.attributes['title'].value=title;
	otheropt.innerHTML=text;
}


/**
 * 明细表和汇总表字段添加到右边框中
 */
function addToRight(){
	var fromField = $("select[name='fromField'] option:selected");
	var toField = $("select[name='toField'] option:selected");
	if (fromField.get(0) && toField.get(0)) {
		var valiOutwrite = false;
		if(fromField.attr("finalinputtype") == "outwrite" || fromField.attr("finalinputtype") == "externalwrite-ahead") {
			valiOutwrite = validateOurwrite(fromField, toField);
		}
		var valiSelect = false;
		if(fromField.attr("finalinputtype") == "select" || fromField.attr("finalinputtype") == "radio") {
			valiSelect = validateSelect(fromField, toField);
		}
		var matchInputType = fromField.attr("finalinputtype") == toField.attr("finalinputtype") && fromField.attr("externalType") == toField.attr("externalType");
		if ((fromField.attr("finalinputtype") == "outwrite" || fromField.attr("finalinputtype") == "externalwrite-ahead" ? valiOutwrite : matchInputType) && fromField.attr("finalfieldtype") == toField.attr("finalfieldtype") && (fromField.attr("finalinputtype") == "select" || fromField.attr("finalinputtype") == "radio" ? valiSelect : true)){
			var isExsit = false;
			var fromFieldIsExist = false;
			var toFieldIsExist = false;
			$("#matcharea").find("div[name='matchDIV']").each(function(){
				var fromData = $(this).find("div[id^='left']");
				var fromFieldName = fromData.attr("name");
				var toData = $(this).find("div[id^='right']");
				var toFieldName = toData.attr("name");
				if(fromFieldName == fromField.attr("tablename")+"."+fromField.val()){
					fromFieldIsExist = true;
					return false;
				}
				if(toFieldName == toField.attr("tablename")+"."+toField.val()){
					toFieldIsExist = true;
					return false;
				}
				if(fromFieldName == fromField.attr("tablename")+"."+fromField.val() && toFieldName == toField.attr("tablename")+"."+toField.val()){
					isExsit = true;
					return false;
				}
			});
			if(fromFieldIsExist) {
				$.alert("${ctp:i18n('form.baseinfo.subtable.relation.fromfieldexist.alert')}");
				return ;
			}
			if(toFieldIsExist) {
				$.alert("${ctp:i18n('form.baseinfo.subtable.relation.tofieldexist.alert')}");
				return ;
			}
			if(isExsit) {
				$.alert("${ctp:i18n('form.baseinfo.subtable.relation.exist.alert')}");
				return ;
			}
			removeFormula4field(toField.attr("tablename")+"."+toField.val());
			var id = random();
			var newdiv = $("<div id='matchDiv"+id+"' name=\"matchDIV\" class=\"w100b clearfix\" style=\"line-height: 20px;text-align: left;\"></div>");
			newdiv.append("<div id=\"left"+id+"\" class=\"left over_hidden\" style=\"width:120px\" name=\""+fromField.attr("tablename")+"."+fromField.val()+"\" fieldname=\""+fromField.attr("fieldname")+"\" tablename=\""+fromField.attr("tablename")+"\" title=\""+fromField.attr("fieldname")+"\">"+fromField.attr("fieldname")+"</div>");
			newdiv.append("<div id=\"right"+id+"\" class=\"left over_hidden\" style=\"width:120px\" name=\""+toField.attr("tablename")+"."+toField.val()+"\" fieldname=\""+toField.attr("fieldname")+"\" tablename=\""+toField.attr("tablename")+"\" title=\""+toField.attr("fieldname")+"\">"+toField.attr("fieldname")+"</div>");
			$("#matcharea").append(newdiv);
			//绑定事件，改变高亮显示
			$("#matchDiv"+id).bind("click", function(){
				getDataMacthIndex(this);
			});
			selectIndex = -1;
		}else{
			$.alert("${ctp:i18n('form.baseinfo.subtable.relation.fieldnotmatch.alert')}");
			return;
		}
	} else {
		$.alert("${ctp:i18n('form.baseinfo.subtable.relation.onetoone.alert')}");
		return;
	}
}

function validateOurwrite(fromField, toField) {
	if(fromField.attr("finalinputtype") == "outwrite"){
		if(fromField.attr("formattype") == "select"){
			if(fromField.attr("formatEnumIsFinalChild") == "true" || fromField.attr("formatEnumIsFinalChild") == true){
				return fromField.attr("formatEnumIsFinalChild") == toField.attr("isFinalChild");
			}
			if(fromField.attr("formatEnumIsFinalChild") == "false" && toField.attr("isFinalChild") == "true"){
				return false;
			}
			return fromField.attr("formatEnumId") == toField.attr("enumId");
		}else{
		    //文本类型的外部写入，需要判断显示格式是否和toField的inputType相同
		    if(fromField.attr("finalfieldtype") == "VARCHAR"){
                return fromField.attr("formattype") == toField.attr("finalinputtype");
            }else{
                return fromField.attr("finalfieldtype") == toField.attr("finalfieldtype");
            }
		}
	}else if(fromField.attr("finalinputtype") == "externalwrite-ahead") {
		return true;
	}
}

function validateSelect(fromField, toField) {
	if(fromField.attr("isFinalChild") != toField.attr("isFinalChild")) {
		return false;
	}else {
		return fromField.attr("enumId") == toField.attr("enumId");
	}
}

/**
 * 从右边移除
 */
function delect(){
	var items = $("#matcharea").find("div[name='matchDIV']");
	if (items.length == 0) {
		return;
	}
	if (selectIndex == -1) {
		//请选中一行!
		$.alert($.i18n('form.changeFormField.pleasechooseoneline'));
		return;
	}
	var item = items.get(selectIndex);
	$(item).remove();
	selectIndex = -1;
}

function showRightDatas(){
	var param = window.dialogArguments;
	if(param && param.fromFieldName && param.fromFieldName != "") {
		var selectedFromFieldNames = param.fromFieldName.split(",");
		var selectedFromFieldDisplays = param.fromFieldDisplay.split(",");
		var selectedToFieldNames = param.toFieldName.split(",");
		var selectedToFieldDisplays = param.toFieldDisplay.split(",");
		for(var i=0;i<selectedFromFieldNames.length;i++) {
			var id = random();
			var newdiv = $("<div id='matchDiv"+id+"' name=\"matchDIV\" class=\"w100b clearfix\" style=\"line-height: 20px;text-align: left;\"></div>");
			newdiv.append("<div id=\"left"+id+"\" class=\"left over_hidden\" style=\"width:120px\" name=\""+selectedFromFieldNames[i]+"\" fieldname=\""+selectedFromFieldDisplays[i]+"\" tablename=\""+selectedFromFieldNames[i]+"\" title=\""+selectedFromFieldDisplays[i]+"\">"+selectedFromFieldDisplays[i]+"</div>");
			newdiv.append("<div id=\"right"+id+"\" class=\"left over_hidden\" style=\"width:120px\" name=\""+selectedToFieldNames[i]+"\" fieldname=\""+selectedToFieldDisplays[i]+"\" tablename=\""+selectedToFieldNames[i]+"\" title=\""+selectedToFieldDisplays[i]+"\">"+selectedToFieldDisplays[i]+"</div>");
			$("#matcharea").append(newdiv);
			$("#matchDiv"+id).bind("click", function(){
				getDataMacthIndex(this);
			});
		}
	}
}

function showDownDatas(){
	var param = window.dialogArguments;
	if(param && param.fillBackKey && param.fillBackKey != "") {
		var fillBackKeys = param.fillBackKey.split(",");
		var fillBackValues = param.fillBackValue.split(",");
		var source = $("#collectField_bak").val();
		var target = $("#toField_bak").val();
		for(var i=0;i<fillBackKeys.length;i++) {
			var cTr;
			var cloneTr;
			var dataTableb = $("#dataTable");
			if (i == 0) {
				if ($("tr", dataTableb).length > 1) {
					$("tr", dataTableb).each(function(index) {
						if (index != 0) {
							$(this).remove();
						}
					});
				}
				var firstRow = $("tr:eq(0)", dataTableb);
				cloneTr = firstRow.clone(true);
				cTr = firstRow;
			} else {
				cTr = cloneTr.clone(true);
				cTr.appendTo(dataTableb);
			}
			$("#sourceTD", cTr).html(source);
			$("#targetTD", cTr).html(target);
			$("#collectField", cTr).val(fillBackKeys[i]);
			$("#formulaValue", cTr).val(fillBackValues[i]);
			cTr.comp();
		}
	}
}

function random() {
    var random = getUUID();
	return random;
}

function add(obj) {
	var currentTr = $(obj).parents("tr:eq(0)");
	var cloneObj = $.ctpClone(currentTr);
	var source = $("#collectField_bak").val();
	var target = $("#toField_bak").val();
	$("#sourceTD", cloneObj).html(source);
	$("#targetTD", cloneObj).html(target);
	$("#add", cloneObj).unbind("click").bind("click", function() {
		add(this);
	});
	$("#del", cloneObj).unbind("click").bind("click", function() {
		del(this);
	});
	$("#collectField", cloneObj).val("");
	$("#formulaValue", cloneObj).val("");
	cloneObj.insertAfter(currentTr);
	cloneObj.comp();
}

function del(obj) {
	var currentTable = $(obj).parents("table:eq(0)");
	if ($("tr", currentTable).length <= 1) {
		add(obj);
	}
	var currentTr = $(obj).parents("tr:eq(0)");
	currentTr.remove();
}

function isCollectFields(fieldName) {
	var isCollectField = false;
	$("#matcharea").find("div[name='matchDIV']").each(function(index){
		var toData = $(this).find("div[id^='right']");
		if(fieldName == toData.attr("name")) {
			isCollectField = true;
			return false;
		}
	});
	return isCollectField;
}

function removeFormula4field(fieldName) {
	$("tr", "#dataTable").each(function() {
		if($("#collectField", $(this)).val() == fieldName) {
			del($("#collectField", $(this)));
			return false;
		}
	});
}

function setFormulaByField(obj) {
	var thisObj = $(obj).parents("tr:eq(0)");
	if($(":selected[value='"+$(obj).val()+"']",$(obj).parents("#dataTable")).length > 1) {
		$.alert("${ctp:i18n('form.baseinfo.subtable.relation.duplicatesetting.alert')}");
		add(obj);
		del(obj);
		return;
	}
	if(isCollectFields(thisObj.find("#collectField").val())) {
		$.alert("${ctp:i18n('form.baseinfo.subtable.relation.issettedcollect.alert')}");
		add(obj);
		del(obj);
		return;
	}
	thisObj.find("#formulaValue").attr("onclick", "setFieldFormula(this)");
	thisObj.find("#formulaValue").val("");
}

function setFieldFormula(obj){
	var thisObj = $(obj).parents("tr:eq(0)");
	if(thisObj.find("#collectField").val() == ""){
		$.alert("${ctp:i18n('form.baseinfo.subtable.relation.selectfieldfirst.alert')}");
		return;
	}
	var formulaArgs = getFormulaArgs(function (formulaStr,formulaDes,formulaData,headHTML,forceCheck){
				$(obj).val(formulaStr);
			},'0',"formulaType_sub_summarize_number",$(obj).val(),null);
	formulaArgs.isSubRelation = true;
	formulaArgs.fieldTableName = "${fromSub}";
	formulaArgs.checkSubFieldMethod = true;
	showFormula(formulaArgs);
}

function OK(){
	var returnValue = new Array();
	var returnvalues1 = new Array();
	var returnvalues2 = new Array();
	returnValue[0] = {"relation":returnvalues1};
	returnValue[1] = {"formula":returnvalues2};
	var parentWin = window.dialogArguments.document;
	$("#matcharea").find("div[name='matchDIV']").each(function(index){
		var fromData = $(this).find("div[id^='left']");
		var fromFieldName = fromData.attr("name");
		var fromFieldDisplay = fromData.attr("fieldname");
		var toData = $(this).find("div[id^='right']");
		var toFieldName = toData.attr("name");
		var toFieldDisplay = toData.attr("fieldname");
		returnvalues1[index] = {"fromFieldName":fromFieldName,"fromFieldDisplay":fromFieldDisplay,"toFieldName":toFieldName,"toFieldDisplay":toFieldDisplay};
	});

	var n = 0;
	$("tr", "#dataTable").each(function() {
		var tempSource = $("#collectField", $(this)).val();
		var tempValue = $("#formulaValue", $(this)).val();
		if (tempSource === "" && tempValue === "") {
			return true;
		}
		if (tempSource == "" || tempValue == "") {
			return true;
		}
		returnvalues2[n] = {"fillBackKey":tempSource,"fillBackValue":tempValue};
		n ++;
	});


	if(returnvalues1.length == 0 || returnvalues2.length == 0) {
		$.alert("${ctp:i18n('form.baseinfo.subtable.relation.relationnotnull.alert')}");
		return ;
	}
	return returnValue;
}
</script>
</head>
<body style="overflow-x:hidden;overflow-y: auto;">
	<form id="datamatch" method="post" action="" onSubmit="" name="datamatch" target="" class="font_size12">
		<div id="tabs2" class="comp" comp="type:'tab',width:600,height:410">
            <div id="tabs2_body" class="common_tabs_body ">
            	<div id="tab1_div">
            		<table>
            			<tr>
            				<td width="270">
								<%-- 明细表分类项 --%>
			           			<div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.baseinfo.subtable.relation.item.label')}</div>
			           			<div class="w100b" style="height: 180px;">
					               	<select class="border_all" name="fromField" id="fromField" style="width: 100%;height: 100%;" size="11">
					                   	<c:forEach items="${fromFieldList}" var="field" varStatus="status">
											<c:if test='${field.inputType != "attachment" && field.inputType != "document" && field.inputType != "image" && field.inputType != "barcode" && field.inputType != "mapmarked" && field.inputType != "maplocate" && field.inputType != "mapphoto" && field.inputType != "multimember" && field.inputType != "multiaccount" && field.inputType != "multidepartment" && field.inputType != "multipost" && field.inputType != "multilevel" && field.inputType != "linenumber" && field.fieldType != "LONGTEXT" && field.finalInputType != "attachment" && field.finalInputType != "document" && field.finalInputType != "image" && field.finalInputType != "barcode" && field.finalInputType != "mapmarked" && field.finalInputType != "maplocate" && field.finalInputType != "mapphoto" && field.finalInputType != "multimember" && field.finalInputType != "multiaccount" && field.finalInputType != "multidepartment" && field.finalInputType != "multipost" && field.finalInputType != "multilevel" && field.finalInputType != "linenumber"}'>
												<c:if test='${field.formatType != "multiattachment" && field.formatType != "document"  && field.formatType != "image"  && field.formatType != "mapmarked"  && field.formatType != "barcode"  && field.formatType != "multimember"  && field.formatType != "multidepartment"  && field.formatType != "multipost"  && field.formatType != "multilevel"  && field.formatType != "multiaccount"  && field.formatType != "attachment" }'>
												<option formatType="${field.formatType}" formatEnumId="${field.formatEnumId}${field.formatEnumLevel }" formatEnumIsFinalChild="${field.formatEnumIsFinalChild}" isFinalChild="${field.isFinalChild}" value="${field.name}" fieldname="${field.display}" tablename="${field.ownerTableName}" inputtype="${field.inputType}"  finalinputtype="${field.finalInputType4SubRelation}" externalType="${field.externalType}" finalfieldtype="${field.finalFieldType}" enumId="${field.finalEnumIdAndLevel4SubRelation}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]${field.display}</option>
												</c:if>
											</c:if>
					                   	</c:forEach>
					               	</select>
					           </div>
					           <%-- 汇总表对应项 --%>
				           	   <div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.baseinfo.subtable.relation.collect.label')}</div>
				           	   <div class="w100b" style="height: 180px;">
				               		<select class="border_all" name="toField" id="toField" style="width: 100%;height: 100%;" size="11">
				                   		<c:forEach items="${toFieldList}" var="field" varStatus="status">
											<c:if test='${field.inputType != "attachment" && field.inputType != "document" && field.inputType != "image" && field.inputType != "barcode" && field.inputType != "mapmarked" && field.inputType != "maplocate" && field.inputType != "mapphoto" && field.inputType != "multimember" && field.inputType != "multiaccount" && field.inputType != "multidepartment" && field.inputType != "multipost" && field.inputType != "multilevel" && field.inputType != "relationform" && field.inputType != "relation" && field.inputType != "linenumber" && field.inputType != "outwrite" && field.inputType != "externalwrite-ahead" && field.fieldType != "LONGTEXT"}'>
												<option isFinalChild="${field.isFinalChild}" value="${field.name}" fieldname="${field.display}" tablename="${field.ownerTableName}" finalinputtype="${field.finalInputType}" externalType="${field.externalType}" finalfieldtype="${field.finalFieldType}" enumId="${field.enumId}${field.enumLevel }">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex }]${field.display}</option>
											</c:if>
				                   		</c:forEach>
				               		</select>
				           	   </div>
            				</td>
            				<td>
            					<span id="select_selected" class="ico16 select_selected"></span><br><br>
		           				<span id="select_unselect" class="ico16 select_unselect"></span>
            				</td>
            				<td width="270">
            					<div class="clearfix" style="line-height: 20px;">
				           		<%-- 明细表数据项 --%>
				               <div id="left0" class="left font_bold" style="width:120px" >${ctp:i18n('form.baseinfo.subtable.relation.item.data.label')}</div>
				               <%-- 汇总表数据项 --%>
				               <div id="right0" class="left font_bold" style="width:120px">${ctp:i18n('form.baseinfo.subtable.relation.collect.data.label')}</div>
				           		</div>
						       <div id="matcharea" class="border_all" style="width: 270px;height: 380px;overflow: auto;">
								   <!--
								   <div id="matchDiv" name="matchDIV" class="w100b clearfix" style="line-height: 20px;text-align: left;">
									   <div id="left" class="left over_hidden" name="a" tablename="" style="width:120px"title=""></div>
									   <div id="right" class="left over_hidden" name="b" tablename="" style="width:120px" title=""></div>
								   </div>
								   -->
						       </div>
            				</td>
							<td id="UpAndDown"  width="40" align="center" valign="middle">
								<div >
									<span id="up"  class="ico16 sort_up"></span>
									<br><br>
									<span id="down"  class="ico16 sort_down"></span>
								</div>
							</td>
            			</tr>
            		</table>
               </div>
          </div>
     </div>

     <table>
		<tr>
			<td>
				<%--汇总计算设置--%>
				<div id="formulaarea" class="border_all" style="width: 552px;height: 120px;overflow: auto;">
					<div class="w100b font_bold" style="text-align: center;line-height: 20px;">${ctp:i18n('form.baseinfo.subtable.relation.collectformula.setting.label')}</div>
					<div id="formulaDiv" class="">
						<table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="500" align="center" style="overflow: auto;">
							<tr height="22" style="margin-top: 5px;">
								<td width="35%" height="20" class="source">
									<div  id="sourceTD" style="margin-top: 5px;">
										<select style="width: 170px;margin-top: 5px;" id="collectField" name="collectField" onchange="setFormulaByField(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
											<option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
											<c:forEach items="${toFieldList}" var="field">
												<c:if test="${!field.masterField}">
													<c:if test="${field.ownerTableName eq toSub}">
														<c:if test="${field.fieldType eq 'DECIMAL' and field.inputType eq 'text'}">
														<option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
														</c:if>
													</c:if>
												</c:if>
											</c:forEach>
										</select>
									</div>
								</td>
								<td width="15%" align="center">
									<input type="hidden" id="tfillBackType" value="formula">=
								</td>
								<td width="35%" class="target" style="margin-top: 5px;">
									<div id="targetTD">
										<input type="text" id="formulaValue" name="formulaValue"  style="width: 180px;margin-top: 5px;cursor: pointer;" readonly onclick="setFieldFormula(this)" />
									</div>
								</td>
								<td width="15%">
									<span id="del" class="ico16 revoked_process_16 repeater_reduce_16"></span>
									<span id="add" class="ico16 repeater_plus_16"></span>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div style="height: 20px;margin-bottom: 0;color: green;">
					${ctp:i18n("form.baseinfo.subtable.relation.operationexplain.label")}
				</div>
			</td>
		</tr>
	</table>
</form>
	<div id="hiddenArea" class="hidden">
    <textarea id="collectField_bak">
        <select style="width: 170px;margin-top: 5px;" id="collectField" name="collectField" onchange="setFormulaByField(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
			<option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
			<c:forEach items="${toFieldList}" var="field">
				<c:if test="${!field.masterField}">
					<c:if test="${field.ownerTableName eq toSub}">
						<c:if test="${field.fieldType eq 'DECIMAL' and field.inputType eq 'text'}">
							<option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
						</c:if>
					</c:if>
				</c:if>
			</c:forEach>
		</select>
    </textarea>
    <textarea id="toField_bak">
        <input type="text" id="formulaValue" name="formulaValue"  style="width: 180px;margin-top: 5px;cursor: pointer;" readonly onclick="setFieldFormula(this)" />
    </textarea>
	</div>
</body>
<%@ include file="../../common/common.js.jsp" %>
</html>
