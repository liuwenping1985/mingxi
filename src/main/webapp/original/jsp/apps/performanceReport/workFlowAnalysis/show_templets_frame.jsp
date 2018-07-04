<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.formbizconfig.resources.i18n.FormBizConfigResources" var="forBizConfig"/>

<html>
<head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/agent/js/agent.js${v3x:resSuffix()}" />"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='bizconfig.selectformtemps.label' bundle="${forBizConfig }"/></title>
<script type="text/javascript">
v3x.loadLanguage("/apps_res/agent/js/i18n");

function searchTempWithKey(type) {
	if(window.event.keyCode==13)
		searchTemp(type);
}

function searchTemp() {
	var theForm = document.getElementById("searchForm");
	var category = '${param.category}';
	var url = detailURL+"?method=showSystemTemplets&expand=true&category="+category;
	theForm.action = url;
	theForm.submit();
}

var detailURL="<c:url value="/templete.do"/>";
function OK(){
	var select = document.getElementById("selectNode");
	var opins = select.options;
	var returnValue =[];
	for (var i = 0; i < opins.length; i++) {
		var type = opins[i].getAttribute("type");
		returnValue[returnValue.length] = opins[i].value+"_"+type;
	}
	return [returnValue];
}

function setTempsBack() {
	
// 	var namess = v3x.getParentWindow().document.getElementById("viewRangeNames").value;
// 	var idss = v3x.getParentWindow().document.getElementById("viewRangeIds").value;
	
	var parentObj = self.dialogArguments;
	var list3Object = document.getElementById("selectNode");
	var list3Items = list3Object.options;
	if(list3Items.length < 1) {
		alert(v3x.getMessage("agentLang.pls_select_at_lease_one_templete"));
		return false;
	}
	var ids = "";
	var names = "";
	for(var i=0;i<list3Items.length;i++) {
		ids += list3Items[i].value;
		names += list3Items[i].text;
		if(i!=list3Items.length-1){
			ids += ',';
			names += '、';
		}
	}
	
	v3x.getParentWindow().document.getElementById("templeteName").value=names;
	v3x.getParentWindow().document.getElementById("templeteId").value=ids;
	
	if (${param.isComprehensivePage != null && param.isComprehensivePage}) {
		var name = v3x.getParentWindow().document.getElementById("templeteName");
		if (name.style.display == 'none') {
			name.style.display = "block";
		}
	}
	
	//selectNode
	
	var templateIds = parentObj.document.getElementById("templateIds");
	if(templateIds){
		templateIds.value = ids;
	}
	var templateSelect = parentObj.document.getElementById("templateSelect");
	if(templateSelect){
		var option;
		if(templateSelect.options && templateSelect.options.length==3)
			option = templateSelect.options[2];
		else{
			option = parentObj.document.createElement("OPTION");
			templateSelect.add(option);
		}
		option.text = names;
		templateSelect.options[2].selected = true;
	}
	window.returnValue = "OK";
	window.close();
}

// 是否支持多选    true/false
function isMultiSelect(isMultiSelect) {
	if (isMultiSelect != null && !isMultiSelect) {
		var oTargetSel = document.getElementById('selectNode');
		if (oTargetSel.options.length >= 1) {
			alert(v3x.getMessage("V3XLang.common_most_select_one_templete_label"));
			return ;
		}
		selectOne();
	} else {
		selectOne();
	}
}

</script>
</head>
<body onkeypress="listenerKeyESC()" scroll="no" >
<table border="0" cellpadding="0" cellspacing="0" width="100%"	height="100%" align="center" class="popupTitleRight">
	<tr>
		<td class="PopupTitle">
			<fmt:message key='bizconfig.selecttemps.label' bundle="${forBizConfig}"/>&nbsp;
		</td>
	</tr>
	<tr>
		<td class="padding10" style="padding-top: 0">
		<div class="scrollList">
			<table border="0" cellpadding="0" cellspacing="0" width="100%"	height="100%" align="center" class="page-border-A4">
				<tr>
					<td colspan="4" class="border-bottom webfx-menu-bar-gray" style="padding-left: 10px;">
						<table cellpadding="0" cellspacing="0" width="100%" border="0">
							<tr>
								<td nowrap="nowrap" width="50"><fmt:message key='bizconfig.search.label' bundle="${forBizConfig}"/>:</td>
								<td>
									<form name="searchForm" id="searchForm" method="post" target="formTemps" style="margin: 0px">
									<div class="">
										<div class="div-float">
											<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
										    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
											    <option value="subject"><fmt:message key="bizconfig.tempname1.label" bundle="${forBizConfig}"/></option>
											    <option value="category"><fmt:message key="bizconfig.tempcategory.label"  bundle="${forBizConfig}"/></option>
										  	</select>
									  	</div>
									  	<div id="subjectDiv" class="div-float hidden">
											<input type="text" name="textfield" id="subjectInput" class="condition">
										</div>
										<div id="categoryDiv" class="div-float hidden">
											<select name="categoryId" style="max-width: 100%;">
											<c:if test="${v3x:isEnableEdoc()}">
											<option value="2">&nbsp;<fmt:message key='templete.category.type.2' /></option>
											<option value="3">&nbsp;<fmt:message key='templete.category.type.3' /></option>
											<option value="5">&nbsp;<fmt:message key='templete.category.type.4' /></option>
											</c:if>
											${categoryHTML}
											</select> 
										</div>
									  	<div onclick="javascript:searchTemp()" class="condition-search-button"></div>
								  	</div>
								  	</form>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="padding10">
						<table border="0" cellpadding="0" cellspacing="0" width="100%"	height="100%" align="center">
							<tr>
								<td width="300" nowrap="nowrap">
									<fmt:message key='bizconfig.canbeselected.label'  bundle="${forBizConfig}"/>
								</td>
								<td></td>
								<td><fmt:message key='bizconfig.selected.label'  bundle="${forBizConfig}"/></td>
								<td></td>
							</tr>
							<tr>
								<td valign="top" width="50%">
									<iframe id="formTemps" name="formTemps" height="100%" width="100%" src="<c:url value="/templete.do?method=showSystemTempletsWorkFlowAnalysis&isWorkflowAnalysiszPage=${param.isWorkflowAnalysiszPage }&isMultiSelect=${param.isMultiSelect }&appType=${param.appType }"/>"></iframe>">
								</td>
								<td width="30" align="center">
									<p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
										alt='<fmt:message key="selectPeople.alt.select" bundle="${v3xMainI18N}"/>' width="24"
										height="24" class="cursor-hand" onClick="isMultiSelect(${param.isMultiSelect})"></p>
									<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
										alt='<fmt:message key="selectPeople.alt.unselect" bundle="${v3xMainI18N}"/>' width="24"
										height=24 class="cursor-hand" onClick="removeOne()"></p>				
								</td>
								<td valign="top"  width="50%">
									<select multiple="multiple" size="16" id="selectNode" class="input-100per" ondblclick="removeOne()" >
									</select>
								</td>
								<td width="30" align="center">
									<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
										alt='<fmt:message key="selectPeople.alt.up" bundle="${v3xMainI18N}" />'width="24"
										height="24" class="cursor-hand" onClick="move('up')"></p>
									<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
										alt='<fmt:message key="selectPeople.alt.down" bundle="${v3xMainI18N}"/>' width="24"
										height="24" class="cursor-hand" onClick="move('down')"></p>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-bottom" align="right" height="42">
		  <input type="button" name="submit" onclick="setTempsBack()" class="button-default-2" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />&nbsp;
		  <input type="button" name="cancel" onclick="javascript:window.close();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2" />
		</td>
	</tr>
</table>
<%-- 浮动帮助信息 --%>
<div id="operInstructionDiv" class="oper-instruction" onMouseOver="javascript:showOrHideOperInstruction('true');"  onMouseOut="javascript:showOrHideOperInstruction('false');" >
</div>
<script type="text/javascript">
function initSelectedFormTempletes(){
	var templetesNames = v3x.getParentWindow().document.getElementById("templeteName").value;
	var templetesIds = v3x.getParentWindow().document.getElementById("templeteId").value;

	//得到模板 然后显示。
	if (templetesNames!="" && templetesNames.length>0) {
		templetesNames = templetesNames.split("、");
		templetesIds = templetesIds.split(",");
	} else {return ;}
	
	if(templetesNames.length>0) {
		var selectNode = document.getElementById("selectNode").options;
		for (var i = 0; i < templetesNames.length; i++) {
				var op = new Option(templetesNames[i], templetesIds[i]);
				selectNode.add(op);
// 			}
		}
	}
}
</script>
</body>
</html>
