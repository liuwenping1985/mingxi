<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="./header.jsp"%>
<c:set value="${v3x:currentUser().loginAccount}" var='currentAccountId'/>
<script type="text/javascript">
<!--
getA8Top().showLocation(1505);

//选择查看人
function setRefUserId(elements){		
	if(elements){
		document.getElementById("memberIds").value = getIdsString(elements,false);
		document.getElementById("memberNames").value = getNamesString(elements);
	}
}

function openTemplate() {
	var url = "templete.do?method=showTempleteFrame&isMultiSelect=true&isWorkflowAnalysiszPage=false&isComprehensivePage=false&data=MemberAnalysis";
	v3x.openWindow({
		url		: url,
		width	: 600,
		height	: 417,
		resizable	: "false"
	});
}

function refreshFrame() {
	alert("<fmt:message key='common.successfully.saved.label' bundle='${v3xCommonI18N}'/>");
	window.parent.frames.location.reload();
}

function submitData() {
	try {
		var memberNames = getDocValue("memberNames");
		var type = document.getElementsByName("type");
		
		var flowstateFlag = false;
		for (var i = 0 ; i < type.length ; i ++) {
			if (type[i].checked)
				flowstateFlag = true ;
		}
		if (memberNames == "") {
			alert(v3x.getMessage("V3XLang.common_select_the_authorized_personnel_label"));
			return ;
		}
		if (!flowstateFlag) {
			alert(v3x.getMessage("V3XLang.common_select_a_view_template_label"));
			return ;
		}
		var dataForm = document.getElementById("dataForm");
		dataForm.target="listFrame";
		dataForm.submit();
	} catch(e) {
		alert("${ctp:i18n('performanceReport.workFlowAnalysis.analysisError')}:"+e.message);
	} 
}

function selectAllTemplete() {
	document.getElementById("templeteName").value="";
}
//-->
</script>
</head>
<body scroll="no" style="overflow: no">
<form id="dataForm" method="post" action="${workFlowAnalysisURL}?method=saveOrUpdateAuthorization">
<input type="hidden" name="isModifyOrAdd" value="${isModifyOrAdd }">
<input type="hidden" name="authrizationId" value="${workFlowAnalysisAcl.id }">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8">
			<script type="text/javascript">
				getDetailPageBreak();
			</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='common.process.analysis.settings' bundle="${v3xMainI18N }"/></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key="system.signet.title.must" bundle="${v3xSysMgrI18N }"/></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
		    <div class="categorySet-body">
			<table>
				<tr>
					<td height="40"></td>
				</tr>
			</table>
			<table width="45%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="name"> <font color="red">*</font><fmt:message key='common.authorized.personnel.label' bundle='${v3xCommonI18N}'/>：</label></td>
					<td class="new-column" width="80%">
						<v3x:selectPeople id="signetId"  panels="Department" selectType="Member"
									 	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
									 	jsFunction="setRefUserId(elements)" originalElements="${v3x:parseElementsOfIds(workFlowAnalysisAcl.memberIds,'Member') }" />
						<script type="text/javascript">
						<!--
							onlyLoginAccount_signetId= true;
						//-->
						</script>
						<input name="memberNames" ${!isModifyOrAdd ? 'disabled' : ""} type="text" id="memberNames" onclick="selectPeopleFun_signetId()" value="${workFlowAnalysisAcl.memberNames }" readonly="readonly" class="input-100per" />
						<input id="memberIds" name="memberIds" type="hidden" value="${workFlowAnalysisAcl.memberIds }">
					</td>
				</tr>
				<tr height="30px" valign="middle">
					<td class="bg-gray" width="20%" nowrap="nowrap">
						<label for="name"> <font color="red">*</font><fmt:message key='common.see.template.label' bundle='${v3xCommonI18N}'/>：</label></td>
					</td>
					<td class="new-column" width="80%">
						<c:if test="${!isModifyOrAdd}">
							<c:set var="disabled" value="disabled"></c:set>
						</c:if>
						<c:if test="${workFlowAnalysisAcl.templeteIds == 1 or empty workFlowAnalysisAcl.templeteIds}">
								<c:set var="checkedAll" value="checked"></c:set>
						</c:if>
						<c:if test="${workFlowAnalysisAcl.templeteIds != 1 && not empty workFlowAnalysisAcl.templeteIds}">
								<c:set var="checkedPart" value="checked"></c:set>
						</c:if>
						<label id="type1">
							<input type="radio" id="type1" name="type"  ${checkedAll} ${disabled} onclick="selectAllTemplete()" value="all">
								<fmt:message key='common.all.templete.label' bundle='${v3xCommonI18N}'/>
						</label>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<label id="type2">
							<input type="radio" id="type2" name="type" ${checkedPart} ${disabled} onclick="openTemplate()">
							 	<fmt:message key='common.specific.template.label' bundle='${v3xCommonI18N}'/>
						</label>
					</td>
				</tr>
				<tr>
					<td class="bg-gray" width="20%" nowrap="nowrap">
					</td>
					<td class="new-column" width="80%">
						<c:set value="${not empty workFlowAnalysisAcl.templeteNames }" var="isEmptyTempletesName" />
						<textarea rows="5" cols="60" id="templeteName" name="templeteName" ${!isModifyOrAdd ? 'disabled' : ""} value="${ isEmptyTempletesName ? '' : workFlowAnalysisAcl.templeteNames }" readonly="readonly" style="width: 100%;">${workFlowAnalysisAcl.templeteNames }</textarea>
						<input type="hidden" id="templeteId" name="templeteId" value="${workFlowAnalysisAcl.templeteIds }">
					</td>
				</tr>
			</table>
			</div>
		</td>
	</tr>
	<c:if test="${isModifyOrAdd}">
		<tr>
			<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" onclick="submitData()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
		    <input type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2"></td>
		</tr>
	</c:if>
</table>
</form>
</body>
</html>