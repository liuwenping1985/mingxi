<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<%
response.setHeader("Cache-Control", "Public");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><fmt:message key='project.toolbar.add.label' /></title>
	<style>
		#color_wheel td{ padding:5px; width:40px;height: 50px; vertical-align: top; text-align: right;}
		#color_wheel .ok{ display: block; width: 15px; height: 14px; background: url(./apps_res/project/images/ok.png);}
	</style>
<c:set value="${v3x:parseElements(projectCompose.principalLists,'id','entityType')}" var="managerList" />
<c:set value="${v3x:parseElements(projectCompose.assistantLists,'id','entityType')}" var="assistantList" />
<c:set value="${v3x:parseElements(projectCompose.memberLists,'id','entityType')}" var="memberLists" />
<c:set value="${v3x:parseElements(projectCompose.interfixLists,'id','entityType')}" var="interfixLists" />
<c:set value="${v3x:parseElements(projectCompose.chargeLists,'id','entityType')}" var="chargeLists" />

<v3x:selectPeople id="manage" panels="Department,Outworker" selectType="Member" originalElements="${managerList}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsManage(elements)" maxSize="5" />
<v3x:selectPeople id="assistant" panels="Department,Outworker" selectType="Member" originalElements="${assistantList}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsAssistant(elements)" maxSize="5" minSize="0" />
<v3x:selectPeople id="member" panels="Department,Outworker" selectType="Member" originalElements="${memberLists}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsMember(elements)" minSize="0" />
<v3x:selectPeople id="interfix" panels="Department,Outworker" selectType="Member" originalElements="${interfixLists}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsInterfix(elements)" minSize="0" />
<v3x:selectPeople id="charge" panels="Department,Outworker" selectType="Member" originalElements="${chargeLists}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsCharge(elements)" minSize="0" maxSize="50" />
<v3x:selectPeople id="department" panels="Department" selectType="Department" originalElements="Department|${projectCompose.deparment.id}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsDepartment(elements)" maxSize="1" />

<script>
<!--
	var excludeElements_manageArray = elements_manage;
	var excludeElements_assistantArray = elements_assistant;
	var excludeElements_memberArray = elements_member;
	var excludeElements_chargeArray = elements_charge;
	var excludeElements_interfixArray = elements_interfix;
	
	//不进行职务级别的筛选(工作范围限制)
	isNeedCheckLevelScope_manage = false;
	isNeedCheckLevelScope_assistant = false;
	isNeedCheckLevelScope_member = false;
	isNeedCheckLevelScope_charge = false;
	isNeedCheckLevelScope_interfix = false;

	//处理提交操作
	function submitForm(){
		var templatesContent =$("#templatesWeb")[0].value;
		if(templates != templatesContent){
			$("#changeFlag").val("true");
		}
		//验证是否有改动,IE才有效,只验证弹出窗口修改页面
		if(v3x.isMSIE && ${showModalWindows != 'showWindows'}){
			if($("#changeFlag").val() != "true") {
// 				window.close();
				return true;
			}
		}

	    if(!checkThisForm(projectForm)){
		    return false;
	    }
	    if(${showModalWindows == 'showWindows'}){
	    	projectForm.action = projectUrl + "?method=updateProject&showModalWindows=showWindows";
		}else{
			projectForm.action = projectUrl + "?method=updateProject";
			projectForm.target = "hiddenFrame";
		}
		projectForm.submit();
		var curUserID = getA8Top().curUserID;
		var persons = "";
        var curManagers = projectForm.managers.value;
        var curAssistants = projectForm.assistants.value;
        var curMembers = projectForm.members.value;
        var curCharges = projectForm.charges.value;
        var curInterfixs = projectForm.interfixs.value;
        persons = curManagers + "," + curAssistants + "," + curMembers + "," + curCharges + "," + curInterfixs;
        if(persons.indexOf(curUserID)<0){
          setTimeout("getA8Top().refreshNavigation()",0);
        }
		return true;
	}
	<%-- 用于记录项目信息是否有变化，如果所有属性都没有变化，就不做无谓的重置、更新操作 --%>
	function setChangeFlag() {
		//$("#changeFlag").val("true");
	}

	//项目阶段
	var projectArr = new Properties();
	//模板
	var paramValue = "${projectCompose.projectSummary.templates}";

	function OK(){
		return submitForm();
	}
	function doResize(){
		var clientHeight,clientHeight1,clientHeight2;
		clientHeight1 = document.documentElement.clientHeight;
		clientHeight2 = document.body.clientHeight;
		//取小的一个
		if(clientHeight1>clientHeight2&&clientHeight2!=0){
			clientHeight = clientHeight2;
		}else{
			clientHeight = clientHeight1>clientHeight2 ? clientHeight1 : clientHeight2;
		}
		var oHeight = parseInt(clientHeight)-100;
		if(oHeight < 0) {
			oHeight = 0;
		}
		//document.getElementById("scrollListDiv").style.height = oHeight+"px";
		if($("#categorySet-body")){
			<c:if test="${showModalWindows == 'showWindows'}">
				$("#categorySet-body").css("height",oHeight+"px");
			</c:if>
		}
		//initFFScroll('scrollListDiv',oHeight);
	}
	var templates = "";
	function initTemplates(){
		templates = $("#templatesWeb")[0].value;
	}
//-->
	$(function () {
			$("#color_wheel td").click(function () {
				$("#color_wheel .ok").hide();
				$(this).find(".ok").show();
				$("#backGround").val($(this).attr("color"));
			});
		})
</script>

</head>

<body scroll='auto' onresize="doResize();" onload="initTemplates();">
<%
	request.setAttribute("pop", request.getParameter("listorpop"));
%>
<iframe id="hiddenFrame" name="hiddenFrame" width="0" height="0"></iframe>
<form id="projectForm" name="projectForm" style="margin-top:-5px;" method="post" action="">
<input type='hidden' name='changeFlag' id='changeFlag' value='true' />
<c:choose>
	<c:when test="${pop==0}">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
			<tr align="center">
				<td height="8" class="detail-top">
					<div id="divA"><script type="text/javascript">getDetailPageBreak();</script></div>
				</td>
			</tr>
			<tr>
				<td class="categorySet-4" height="8"></td>
			</tr>
			<tr>
				<td class="categorySet-head">
				<div style="width:99%" class="categorySet-body" id="categorySet-body" style="overflow:auto;">
	</c:when>
	<c:otherwise>
		<table class="popupTitleRight" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
			<tr>
				<td class="PopupTitle"><fmt:message key='project.toolbar.update.label' /> <font color="red">*</font><fmt:message key='common.notnull.label' bundle='${v3xCommonI18N}' /></td>
			</tr>
			<tr>
				<td class="categorySet-head">
				<div class="" style="overflow:auto;">
	</c:otherwise>
</c:choose>
	<table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr height="0">
            <td width="3%"></td>
            <td width="15%"></td>
            <td width="30%"></td>
            <td width="19%"></td>
            <td width="30%"></td>
            <td width="3%"></td>
        </tr>
		<tr>
			<td></td>
			<td class="bg-gray" align="right" height="25"><font color="red">*</font><fmt:message key='project.body.projectName.label' />:</td>
			<td width="20%" colspan="3">
				<input type="hidden" name="projectId" value="${projectCompose.projectSummary.id}">
				<input ${ isManager ? "" : "disabled" } class="input-100per" type="text" name="projectName" validate="notNull" maxlength="100" onchange="setChangeFlag()" inputName="<fmt:message key='project.body.projectName.label' />" value="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectName)}" title="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectName)}" />
			</td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td class="bg-gray" align="right"><fmt:message key='project.body.projectType.label' />:</td>
			<td>
				<select id="projectTypeId" name="projectTypeId" onchange="syncProjectTypeName(this);setChangeFlag();" style="font-size: 12px; width: 100%;" ${ isManager  ? "" : "disabled" }>
					<c:forEach items="${pTypeList}" var="type">
						<option value="${type.id}" ${projectCompose.projectSummary.projectTypeId==type.id ? 'selected' : '' }>${v3x:toHTMLWithoutSpace(type.name)}</option>
					</c:forEach>
				</select>
				<input type="hidden" name="projectType" id="projectType" value="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectTypeName)}" />
				<c:forEach items="${pTypeList}" var="type">
					<input type="hidden" name="projectType_${type.id}" id="projectType_${type.id}" value="${v3x:toHTMLWithoutSpace(type.name)}" />
				</c:forEach>
			</td>
            <td class="bg-gray" align="right" style="padding-right:0;white-space:nowrap;"><fmt:message key='project.body.projectNum.label' />:</td>
            <td>
                <input ${ isManager ? "" : "disabled" } class="input-100per" type="text" onchange="setChangeFlag()" name="projectNum" id="projectNum" maxlength="40" inputName="<fmt:message key='project.body.projectNum.label'/>" value="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectNumber)}" title="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectNumber)}" />
            </td>
			<td></td>
		</tr>
		<tr><td></td>
			<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.startdate.label' />:</td>
			<td>
				<input ${ isManager  ? "" : "disabled" }  class="input-100per" type="text" name="begintime" id="begintime" readonly="readonly" onpropertychange="setChangeFlag()" onclick="selectProjectDate('start', '${pageContext.request.contextPath}', this)" validate="notNull" maxlength="50" inputName="<fmt:message key='project.body.startdate.label' />" value="<fmt:formatDate value='${projectCompose.projectSummary.begintime}' pattern='yyyy-MM-dd'/>" />
			</td>
			<td class="bg-gray" align="right" style="white-space:nowrap;"><font color="red">*</font><fmt:message key='project.body.enddate.label' />:</td>
			<td>
				<input ${ isManager ? "" : "disabled" } class="input-100per" type="text" name="closetime" id="closetime" readonly="readonly" onclick="selectProjectDate('end', '${pageContext.request.contextPath}', this)" validate="notNull" maxlength="50" onpropertychange="setChangeFlag()" inputName="<fmt:message key='project.body.enddate.label' />" value="<fmt:formatDate value='${projectCompose.projectSummary.closetime}' pattern='yyyy-MM-dd'/>" />
			</td><td></td>
		</tr>
		<tr><td></td>
			<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.responsible.label' />:</td>
			<td colspan="3">
				<input type="text" name="managerWeb" id="managerWeb" readonly="readonly" class="input-100per" onclick="isSelectManager()" onpropertychange="setChangeFlag()" inputName="<fmt:message key='project.body.responsible.label' />" value="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" />
				<input type="hidden" name="manager" id="managers" value="${v3x:joinWithSpecialSeparator(projectCompose.principalLists, 'id', ',')}">
				<input type="hidden" name="member_back" id="member_back" value="${v3x:joinWithSpecialSeparator(projectCompose.principalLists, 'id', ',')}">
			</td><td></td>
		</tr>
		
		<tr><td></td>
			<td class="bg-gray" align="right"><fmt:message key='project.body.assistant.label' />:</td>
			<td colspan="3">
				<input ${isManager ? "" : "disabled"} class="input-100per" type="text" name="assistantWeb" id="assistantWeb" readonly="readonly" onclick="isSelectAssistant()" onpropertychange="setChangeFlag()" inputName="<fmt:message key='project.body.assistant.label' />" value="${v3x:showOrgEntities(projectCompose.assistantLists, 'id', 'entityType', pageContext)}" />
				<input type="hidden" name="assistant" id="assistants" value="${v3x:joinWithSpecialSeparator(projectCompose.assistantLists, 'id', ',')}">
				<input type="hidden" name="assistant_back" id="assistant_back" value="${v3x:joinWithSpecialSeparator(projectCompose.assistantLists, 'id', ',')}">
			</td><td></td>
		</tr>

		<tr><td></td>
			<td class="bg-gray" align="right"><fmt:message key='project.body.members.label' />:</td>
			<td colspan="3">
				<textarea ${isManager ? "" : "disabled"} type="text" name="memberWeb" id="memberWeb" rows="2" validate="maxLength" style="resize: none;width: 100%; height: 32px" class="font-12px" onclick="isSelectMember()" value="" readonly="readonly" onpropertychange="setChangeFlag()" inputName="<fmt:message key='project.body.members.label' />" /><c:forEach items='${projectCompose.memberLists}' var='member' varStatus="s">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				<input type="hidden" name="member" id="members" value="${v3x:joinWithSpecialSeparator(projectCompose.memberLists, 'id', ',')}">
				<input type="hidden" name="member_back" id="member_back" value="${v3x:joinWithSpecialSeparator(projectCompose.memberLists, 'id', ',')}">
			</td><td></td>
		</tr>

		<tr><td></td>
			<td class="bg-gray" align="right"><fmt:message key='project.body.manger.label' />:</td>
			<td colspan="3">
				<textarea ${isManager ? "" : "disabled"} type="text" name="chargeWeb" id="chargeWeb" rows="2" validate="maxLength" onpropertychange="setChangeFlag()" style="resize: none;width: 100%; height: 32px" class="font-12px" onclick="isSelectCharge()" value="" readonly="readonly" inputName="<fmt:message key='project.body.manger.label' />" /><c:forEach items='${projectCompose.chargeLists}' var='member' varStatus="s">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				<input type="hidden" name="charge" id="charges" value="${v3x:joinWithSpecialSeparator(projectCompose.chargeLists, 'id', ',')}">
				<input type="hidden" name="charge_back" id="charge_back" value="${v3x:joinWithSpecialSeparator(projectCompose.chargeLists, 'id', ',')}">
			</td><td></td>

		</tr>
		<tr><td></td>

			<td class="bg-gray" align="right"><fmt:message key='project.body.related.label' />:</td>
			<td colspan="3">
				<textarea ${isManager ? "" : "disabled"} type="text" name="interfixWeb" id="interfixWeb" rows="2" onpropertychange="setChangeFlag()" validate="maxLength" style="resize: none;width: 100%; height: 32px" class="font-12px" onclick="isSelectInterfix()" value="" readonly="readonly" inputName="<fmt:message key='project.body.related.label' />" /><c:forEach items='${projectCompose.interfixLists}' var='member' varStatus="s">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				<input type="hidden" name="interfix" id="interfixs" value="${v3x:joinWithSpecialSeparator(projectCompose.interfixLists, 'id', ',')}">
				<input type="hidden" name="interfix_back" id="interfix" value="${v3x:joinWithSpecialSeparator(projectCompose.interfixLists, 'id', ',')}">
			</td>
      <td style="vertical-align: bottom;"  nowrap="nowrap">
                                [<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]
                            </td>
		</tr>
<!-- 		<tr> -->
<!-- 			<td></td><td></td> -->
<%-- 			<td colspan="2">[<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]</td> --%>
<!-- 			<td></td> -->
<!-- 		</tr> -->
		<tr><td></td>
			<td class="bg-gray"></td>
			<td colspan="3">
				<input type="button" value="<fmt:message key='project.phase.add.title.label' />" class="button-default-2" onclick="setChangeFlag();addPhases('add')">
				<input type="button" value="<fmt:message key='phrase.title.edit.label' bundle='${v3xMainI18N}' />" class="button-default-2" onclick="setChangeFlag();addPhases('update')">
				<input type="button" value="<fmt:message key='phrase.title.delete.label' bundle='${v3xMainI18N}' />" class="button-default-2" onclick="setChangeFlag();deletePhases()">
			</td><td></td>
		</tr>
		
		<tr><td></td>
			<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.phase.label' />:</td>
			<td colspan="3">
				<div class="${showModalWindows == 'showWindows' ? 'phaseDiv' : 'phaseWindowDiv'} ">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="phasesTable">
						<tr>
							<td width="5%" style="border-bottom: 1px solid #CCC; border-right: 1px solid #CCC;" align="center"><input type="checkbox" onclick="selectAll(this, 'id')"></td>
							<td width="45%" style="border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; padding-left: 10px;"><fmt:message key='project.docment.title' /></td>
							<td width="50%" style="border-bottom: 1px solid #CCC; padding-left: 10px;"><fmt:message key='project.time' /></td>
						</tr>
						<c:forEach items="${projectCompose.projectSummary.projectPhases}" var="phase">
							<c:if test="${phase.id == projectCompose.projectSummary.phaseId}">
								<c:set value="${phase.phaseName}" var="currentPhaseName"/>
							</c:if>
							<fmt:formatDate value="${phase.phaseBegintime}" pattern="yyyy-MM-dd" var="pTime" />
							<fmt:formatDate value="${phase.phaseClosetime}" pattern="yyyy-MM-dd" var="eTime" />
							<script type="text/javascript">
								var phase = new Phase("${phase.id}", "${phase.phaseName}", "${pTime}", "${eTime}", "${phase.beforeAlarmDate}", "${phase.endAlarmDate}", "${v3x:escapeJavascript(phase.phaseDesc)}");
								projectArr.put("${phase.id}", phase);
							</script>
							<tr id='${phase.id}Tr'>
								<td align='center' class='phaseBox'><input type='checkbox' name='id' value='${phase.id}'/><input type='hidden' id='updateProjectPhases' name='updateProjectPhases' value='${phase.id}-phaseSplit-${phase.phaseName}-phaseSplit-${pTime}-phaseSplit-${eTime}-phaseSplit-${phase.beforeAlarmDate}-phaseSplit-${phase.endAlarmDate}-phaseSplit-${phase.phaseDesc}' /></td>
								<td class='phaseTd' style="white-space:nowrap;">${phase.phaseName}</td>
								<td class='phaseTd' style="white-space:nowrap;">${pTime} ~ ${eTime}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</td><td></td>
		</tr>
		
		<tr class="${projectCompose.projectSummary.phaseId != null && projectCompose.projectSummary.phaseId != '1' ? '' : 'hidden'}" id="currentPhaseTr">
			<td></td>
			<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.phase.current.label' />:</td>
			<td colspan="3">
				<input type="hidden" id="currentPhaseId" name="currentPhaseId" value="${projectCompose.projectSummary.phaseId}"/>
				<input id="currentPhaseName" name="currentPhaseName" value="${currentPhaseName}" readonly style="width: 200px;"/>
				&nbsp;&nbsp;
				<a onclick="javascript:setPhaseForCreate();">[<fmt:message key='common.button.modify.label' bundle='${v3xCommonI18N}' />]</a>
			</td>
			<td></td>
		</tr>
		
		<tr>
		<td></td>
			<td class="bg-gray" align="right" style="padding-top: 7px;" nowrap><font color="red">*</font><fmt:message key='project.body.teamopen.label.new' />:</td>
			<td colspan="3">
				<label for="team_radio">
					<input ${ isManager  ? "" : "disabled" } type="radio" id="team_radio" name="publicGroup" value="0" onpropertychange="setChangeFlag()"  <c:if test="${projectCompose.projectSummary.publicState =='0'}">checked</c:if> /><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
				</label>
				<label for="team_radio1">
					<input ${ isManager  ? "" : "disabled" } type="radio" id="team_radio1" name="publicGroup" value="1" onpropertychange="setChangeFlag()" <c:if test="${projectCompose.projectSummary.publicState =='1'}">checked</c:if> /><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
				</label>
			</td><td></td>
		</tr>
		<tr><td></td>
			<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="project.body.state.label" />:</td>
			<td nowrap colspan="2">
				<label for="lable_idstart">
					<c:if test="${projectCompose.projectSummary.projectState =='0'}">
						<input ${ isManager  ? "" : "disabled" } type="radio" id="lable_idstart" name="projectState" value="0" onpropertychange="setChangeFlag()" <c:if test="${projectCompose.projectSummary.projectState =='0'}">checked</c:if> /><fmt:message key="project.body.projectstate.0" />
					</c:if>
				</label>
				<label for="lable_idend">
					<input ${ isManager  ? "" : "disabled" } type="radio" name="projectState" id="lable_idend" value="2" onpropertychange="setChangeFlag()" <c:if test="${projectCompose.projectSummary.projectState =='2'}">checked</c:if> /><fmt:message key="project.body.projectstate.2" />
				</label>
			</td><td></td>
		</tr>
		<tr><td></td>
			<td class="bg-gray" align="right" valign="top"><fmt:message key="project.body.desc.label" />:</td>
			<td colspan="3" align="left" valign="top" ${ isManager  ? "" : "disabled" }>
				<textarea name="projectDesc" style="resize: none;" cols="" rows="3" onchange="setChangeFlag()" inputName="<fmt:message key='project.body.desc.label' />" validate="maxLength" maxSize="1000" class="font-12px breakWord">${projectCompose.projectSummary.projectDesc}</textarea>
			</td><td></td>
		</tr>
		<tr><td></td>
			<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.templates.label' />:</td>
			<td colspan="3">
				<input type="hidden" name="templates" id="templates" value="${projectCompose.projectSummary.templates}">
				<textarea name="templatesWeb" style="resize: none;" id="templatesWeb" rows="3" onpropertychange="setChangeFlag()" class="font-12px breakWord" onclick="setProjectTemplete('false')" readonly="readonly" inputName="<fmt:message key='project.body.templates.label' /> ">${v3x:showTempleteName(projectCompose.projectSummary.templates)}</textarea>
			</td><td></td>
		</tr>
		<tr style="vertical-align: top;">
							<td><input type="hidden" name="backGround" id="backGround" value="${projectCompose.projectSummary.backGround}"></td>
							<td class="bg-gray" align="right" valign="top" nowrap><fmt:message key='project.body.backGround.label' />:</td>
							<td colspan="3" align="left">
	<table id="color_wheel" align="left" cellspacing="9" cellpadding="0" border="0" class="">
		<tr>
			<td color="#006aff" style="background:#006aff;"><span class="ok" style="display:<c:choose><c:when test="${projectCompose.projectSummary.backGround == '#006aff'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;"></span>&nbsp;</td>
			<td color="#15a4fa" style="background:#15a4fa;"><span class="ok" style="display:<c:choose><c:when test="${projectCompose.projectSummary.backGround == '#15a4fa'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;"></span>&nbsp;</td>
			<td color="#06a8a9" style="background:#06a8a9;"><span class="ok" style="display:<c:choose><c:when test="${projectCompose.projectSummary.backGround == '#06a8a9'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;"></span>&nbsp;</td>
			<td color="#0dab60" style="background:#0dab60;"><span class="ok" style="display:<c:choose><c:when test="${projectCompose.projectSummary.backGround == '#0dab60'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;"></span>&nbsp;</td>
			<td color="#18a10f" style="background:#18a10f;"><span class="ok" style="display:<c:choose><c:when test="${projectCompose.projectSummary.backGround == '#18a10f'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;"></span>&nbsp;</td>
			<td color="#dd0865" style="background:#dd0865;"><span class="ok" style="display:<c:choose><c:when test="${projectCompose.projectSummary.backGround == '#dd0865'}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;"></span>&nbsp;</td>
		</tr>
	</table>
			 				</td>
			 				<td></td>
						</tr>
        <tr height="10px">
            <td>&nbsp;</td>
        </tr>
	</table>
</div>
</td>
</tr>
<tr>
<c:if test="${showModalWindows == 'showWindows'}">
	<td height="42" align="center" class="bg-advance-bottom">
		<c:if test="${isManager}">
			
				
				<c:if test="${projectCompose.projectSummary.projectState !='2' }">
					<input id="b1" name="b1" type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2" style="cursor: pointer;background-color:rgb(66, 179, 229);background-repeat:repeat-x;">&nbsp;
				</c:if>
				<c:choose>
					<c:when test="${showModalWindows=='showWindows'}">
						<input id="b2" name="b2" type="button" onclick="window.parent.location.reload();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</c:when>
					<c:otherwise>
						<input id="b2" name="b2" type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</c:otherwise>
				</c:choose>
			</c:if>
		</td>
		</c:if>
	</tr>
</table>
<div style="visibility: hidden" id="insterLocationDiv" name="insterLocationDiv"></div>
</form>
</body>
<script>
if(window.dialogArguments){
	var divA = document.getElementById("divA");
	if(divA){
		divA.style.display = "none";
	}
}
doResize();
</script>
</html>