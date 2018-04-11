<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<head>
	<style>
		#color_wheel td{ padding:5px; width:40px;height: 50px; vertical-align: top; text-align: right;}
		#color_wheel .ok{ display: block; width: 15px; height: 14px; background: url(./apps_res/project/images/ok.png);}
	</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><fmt:message key='project.showprojectdetail.label' /></title>
<script type="text/javascript">
<!--
//不进行职务级别的筛选(工作范围限制)
isNeedCheckLevelScope_manage = false;
onlyLoginAccount_manage = true;

<c:set value="${v3x:parseElements(memberList,'id','entityType')}" var="memberList" />
excludeElements_manage = parseElements('${memberList}');

<c:set value="${v3x:parseElements(projectCompose.principalLists,'id','entityType')}" var="managerList" />
   
/**
 * 修改项目负责人
 */
function selectManger(){
	if(${!readnOnly}){
		selectPeopleFun_manage();
	}
}
function doResize(){
	var clientHeight,clientHeight1,clientHeight2;
	clientHeight1 = document.documentElement.clientHeight;
	clientHeight2 = document.body.clientHeight;
	//取小的一个
	if(clientHeight1>clientHeight2&&clientHeight2!=0){
		clientHeight = clientHeight2;
	}else{        
		clientHeight = clientHeight1>clientHeight2 ? clientHeight2: clientHeight1==0?clientHeight2:clientHeight1 ;
	}
	var oHeight = parseInt(clientHeight)-35;
	//var oHeight = parseInt(document.documentElement.clientHeight)-35;
	if(document.getElementById("bottonArea")){
		oHeight = oHeight-52;
	}
	try{
	    document.getElementById("scrollListDiv").style.height = oHeight+"px";
	} catch(e){}
	initFFScroll('scrollListDiv',oHeight);
}
//项目阶段
var projectArr = new Properties();
//-->
</script>
<v3x:selectPeople id="manage" panels="Department,Outworker" selectType="Member" maxSize="5" originalElements="${managerList}" departmentId="${currentUserDepartmentId}" jsFunction="setPeopleFieldsManage(elements)" />
<script>
//允许跨单位选人
onlyLoginAccount_manage = false;
</script>
</head>
<body scroll='no' onresize="doResize();">
<form id="projectForm" name="projectForm" method="post" action="${detailURL}?method=updateProject&from=1" onSubmit="return checkThisForm(this)">
<input type="hidden" value="${projectCompose.projectSummary.id}" name="projectId">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak(); 
			</script>
		</td>
	</tr>		
	<tr>
		<td class="categorySet-4" height="0"></td>
	</tr> 
	<tr>
		<td class="">
		<div class="categorySet-body" id="scrollListDiv" style="padding:10px 0;overflow:auto;">
		<center>
		<table width="85%" border="0" align="center" cellpadding="0" cellspacing="5">
			<tr height="0">
            <td width="8%"></td>
            <td width="12%"></td>
            <td width="30%"></td>
            <td width="10%"></td>
            <td width="30%"></td>
            <td width="10%"></td>
        </tr>
					
			<tr>
                <td></td>
				<td class="bg-gray" align="right" height="25"><font color="red">*</font><fmt:message key='project.body.projectName.label' />:</td>
				<td colspan="3">
					<input class="input-100per" type="text" disabled name="projectName" validate="notNull" maxlength="50" value="${v3x:toHTML(projectCompose.projectSummary.projectName)}" inputName="<fmt:message key='project.body.projectName.label' />" />
				</td>
                <td></td>
			</tr>
			
			<tr>
                <td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.projectType.label' />:</td>
				<td>
					<input class="input-100per" type="text" disabled name="projectType" value="${v3x:toHTML(projectCompose.projectSummary.projectTypeName)}" inputName="<fmt:message key='project.body.projectType.label' />" />
				</td>
                <td class="bg-gray" align="right"><fmt:message key='project.body.projectNum.label' />:</td>
                <td>
                    <input class="input-100per" type="text" disabled name="projectNum" id="projectNum" maxlength="40" value="${v3x:toHTML(projectCompose.projectSummary.projectNumber)}" inputName="<fmt:message key='project.body.projectNum.label' />" />
                </td>
                <td></td>
			</tr>
						
			<tr><td></td>
				<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.startdate.label' />:</td>
				<td>
					<input class="input-100per" type="text" name="begintime" id="begintime" disabled validate="notNull" maxlength="50" value="<fmt:formatDate value='${projectCompose.projectSummary.begintime}' pattern='yyyy-MM-dd'/>" inputName="<fmt:message key='project.body.startdate.label' />" />
				</td>
				<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.enddate.label' />:</td>
				<td>
					<input class="input-100per" type="text" name="closetime" id="closetime" disabled validate="notNull" maxlength="50" value="<fmt:formatDate value='${projectCompose.projectSummary.closetime}' pattern='yyyy-MM-dd'/>" inputName="<fmt:message key='project.body.enddate.label' />" />
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.responsible.label' />:</td>
				<td colspan="3">
					<input type="hidden" name="manager" id="managers" value="${v3x:joinWithSpecialSeparator(projectCompose.principalLists, 'id', ',')}">
					<input ${!readnOnly ? "" : "disabled"} class="input-100per" type="text" name="managerWeb" id="managerWeb" readonly="readonly" value="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" validate="notNull" onclick="selectManger()" inputName="<fmt:message key='project.body.responsible.label' />" />
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.assistant.label' />:</td>
				<td colspan="3">
					<input class="input-100per" type="text" name="assistantWeb" id="assistantWeb" disabled value="${v3x:showOrgEntities(projectCompose.assistantLists, 'id', 'entityType', pageContext)}" inputName="<fmt:message key='project.body.assistant.label' />" />
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.members.label' />:</td>
				<td colspan="3" align="right" >
                    <textarea align="right"	name="memberWeb"  id="memberWeb" rows="2" validate="maxLength" style="width: 100%;resize: none;height: 40px" class="font-12px" readonly="readonly" inputName="<fmt:message key='project.body.members.label' />"/><c:forEach items="${projectCompose.memberLists}" varStatus="s" var="member"> ${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				</td><td></td>
			</tr>
	
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.manger.label' />:</td>
				<td colspan="3">
					 <textarea align="top" name="chargeWeb" rows="2" validate="maxLength" style="width: 100%;resize: none;height: 32px" class="font-12px" readonly="readonly" inputName="<fmt:message key='project.body.manger.label' />"/><c:forEach items="${projectCompose.chargeLists}" varStatus="s" var="member">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.related.label' />:</td>
				<td colspan="3">
					<textarea name="interfixWeb"  rows="2" validate="maxLength" style="width: 100%;resize: none;height: 40px" class="font-12px" readonly="readonly" inputName="<fmt:message key='project.body.related.label' />"/><c:forEach items="${projectCompose.interfixLists}" varStatus="s" var="member">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				</td><td style="vertical-align: bottom;"  nowrap="nowrap">
                                [<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]
                            </td>
			</tr>
			
<!-- 			<tr> -->
<!-- 				<td></td> -->
<%-- 				<td nowrap="nowrap">[<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]</td> --%>
<!-- 			</tr> -->
			
			<tr><td></td>
				<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.phase.label' />:</td>
				<td colspan="4">
					<div class="phaseDiv">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" id="phasesTable">
							<tr>
								<td width="40%" style="border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; padding-left: 10px;"><fmt:message key='project.docment.title' /></td>
								<td width="60%" style="border-bottom: 1px solid #CCC; padding-left: 10px;"><fmt:message key='project.time' /></td>
							</tr>
							<c:forEach items="${projectCompose.projectSummary.projectPhases}" var="phase">
								<c:if test="${phase.id == projectCompose.projectSummary.phaseId}">
									<c:set value="${phase.phaseName}" var="currentPhaseName"/>
								</c:if>
								<tr>
									<td class='phaseTd'>${phase.phaseName}</td>
									<td class='phaseTd'><fmt:formatDate value="${phase.phaseBegintime}" pattern="yyyy-MM-dd" /> ~ <fmt:formatDate value="${phase.phaseClosetime}" pattern="yyyy-MM-dd" /></td>
								</tr>
							</c:forEach>
						</table>
					</div>
 				</td>
			</tr>
			
			<c:if test="${projectCompose.projectSummary.phaseId != null && projectCompose.projectSummary.phaseId != '1'}">
				<tr><td></td>
					<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.phase.current.label' />:</td>
					<td colspan="3">
						<input type="hidden" id="currentPhaseId" name="currentPhaseId" value="${projectCompose.projectSummary.phaseId}"/>
						<input id="currentPhaseName" name="currentPhaseName" value="${currentPhaseName}" disabled style="width: 200px;"/>
					</td><td></td>
				</tr>
			</c:if>
			
			<tr><td></td>
				<td class="bg-gray" align="right" style="padding-top:7px;"><font color="red">*</font><fmt:message key='project.body.teamopen.label.new' />:</td>
				<td>
					<label for="publicGroup1">
						<input type="radio" id="publicGroup1" disabled name="publicGroup" value="0"  <c:if test="${projectCompose.projectSummary.publicState =='0'}">checked</c:if>/><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
					</label>
					<label for="publicGroup2">
						 <input type="radio" id="publicGroup2" disabled name="publicGroup" value="1" <c:if test="${projectCompose.projectSummary.publicState =='1'}">checked</c:if>  /><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
					</label>
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="project.body.state.label" />:</td>
				<td colspan="3">
					<label for="projectState1">
						<input type="radio" id="projectState1" name="projectState"	value="0" disabled  <c:if test="${projectCompose.projectSummary.projectState =='0'}"> checked </c:if> /><fmt:message key="project.body.projectstate.0" /> 
					</label>
					<label for="projectState2">
						<input type="radio" id="projectState2" disabled	name="projectState"  value="2" <c:if test="${projectCompose.projectSummary.projectState =='2'}">checked</c:if>/><fmt:message key="project.body.projectstate.2" />
					</label>
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.desc.label' />:</td>
				<td colspan="3" align="left" valign="top">
					<textarea style="resize: none;" readonly="readonly" name="projectDesc" cols="" rows="3" validate="maxLength" maxSize="1000" class="font-12px breakWord" inputName="<fmt:message key='project.body.desc.label' />">${projectCompose.projectSummary.projectDesc}</textarea>
				</td><td></td>
			</tr>
			
			<tr><td></td>
				<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.templates.label' />:</td>
				<td colspan="3" align="left" valign="top">
					<textarea style="resize: none;" readonly="readonly" name="templatesWeb" id="templatesWeb" rows="3" class="font-12px breakWord" inputName="<fmt:message key='project.body.templates.label' />" />${v3x:showTempleteName(projectCompose.projectSummary.templates)}</textarea>
 				</td><td></td>
			</tr>
			<tr style="vertical-align: top;">
							<td><input type="hidden" name="backGround" id="backGround" value="${projectCompose.projectSummary.backGround}"></td>
							<td class="bg-gray" align="right" valign="top" nowrap><fmt:message key='project.body.backGround.label' />:</td>
							<td colspan="3" align="left">
	<table id="color_wheel" align="left" cellspacing="9" cellpadding="0" border="0" class="">
		<tr>
		<c:choose>
		<c:when test="${projectCompose.projectSummary.backGround == '#006aff'}">
			<td color="#006aff" style="background:#006aff;">&nbsp;</td></c:when>
		<c:when test="${projectCompose.projectSummary.backGround == '#15a4fa'}">
			<td color="#15a4fa" style="background:#15a4fa;">&nbsp;</td></c:when>
		<c:when test="${projectCompose.projectSummary.backGround == '#06a8a9'}">
			<td color="#06a8a9" style="background:#06a8a9;">&nbsp;</td></c:when>
		<c:when test="${projectCompose.projectSummary.backGround == '#0dab60'}">
			<td color="#0dab60" style="background:#0dab60;">&nbsp;</td></c:when>
		<c:when test="${projectCompose.projectSummary.backGround == '#18a10f'}">
			<td color="#18a10f" style="background:#18a10f;">&nbsp;</td></c:when>
		<c:when test="${projectCompose.projectSummary.backGround == '#dd0865'}">
			<td color="#dd0865" style="background:#dd0865;">&nbsp;</td></c:when>
		<c:otherwise>
			<td color="${projectCompose.projectSummary.backGround}" style="background:${projectCompose.projectSummary.backGround};">&nbsp;</td>
		</c:otherwise>
		</c:choose>
		</tr>
	</table>
			 				</td>
			 				<td></td>
						</tr>			
			<tr><td colspan="6">&nbsp;</td></tr>
		</table>
		</center>
		</div>
		</td>
	</tr>
	<c:if test="${!readnOnly}">
		<tr height="42px;" id="bottonArea">
			<td height="100%" align="center" class="bg-advance-bottom">
				<input id="okButton"  type="submit" id="submit" name="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input id="cancelButton" type="reset" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="cancelOk()">
			</td>
		</tr>
	</c:if>
</table>
</form>
<script>
	doResize();
</script>
</body>
</html>
