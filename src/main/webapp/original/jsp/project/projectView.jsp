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
<body scroll="auto">
<form id="projectForm" name="projectForm" method="post">
<table class="popupTitleRight" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td class="PopupTitle" height="8"><fmt:message key='project.showprojectdetail.label' /></td>
	</tr> 
	<tr>
		<td>
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				 <td width="3%"></td>
                  <td width="16%"></td>
                  <td width="30%"></td>
                  <td width="15%"></td>
                  <td width="30%"></td>
                  <td width="5%"></td>
			</tr>			
			<tr><td></td>
				<td class="bg-gray" align="right" height="25"><font color="red">*</font><fmt:message key='project.body.projectName.label' />:</td>
				<td colspan="3">
					<input class="input-100per" type="text" name="projectName" validate="notNull,isWord" maxlength="50" disabled  value="${v3x:toHTML(projectCompose.projectSummary.projectName)}" inputName="<fmt:message key='project.body.projectName.label' />" />
				</td><td></td>
			</tr>
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.projectType.label' />:</td>
				<td>
					<input class="input-100per" type="text" name="projectType"  disabled  value="${v3x:toHTML(projectCompose.projectSummary.projectTypeName)}" inputName="<fmt:message key='project.body.projectType.label' />" />
				</td>
                <td class="bg-gray" align="right"><fmt:message key='project.body.projectNum.label' />:</td>
                <td>
                    <input class="input-100per" type="text" name="projectNum" id="projectNum" disabled  value="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectNumber)}" title="${v3x:toHTMLWithoutSpace(projectCompose.projectSummary.projectNumber)}" inputName="<fmt:message key='project.body.projectNum.label'/>"/>
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
					<input class="input-100per" type="text" name="managerWeb" disabled value="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" validate="notNull" inputName="<fmt:message key='project.body.responsible.label' />" />
				</td><td></td>
			</tr>
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.assistant.label' />:</td>
				<td colspan="3">
					<input class="input-100per" type="text" name="assistantWeb" id="assistantWeb" disabled value="${v3x:showOrgEntities(projectCompose.assistantLists, 'id', 'entityType', pageContext)}" inputName="<fmt:message key='project.body.assistant.label' />" />
				</td><td></td>
			</tr>
			<tr height="40"><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.members.label' />:</td>
				<td colspan="3" align="right" >
                    <textarea 	align="right"	name="memberWeb"  rows="2" validate="maxLength" style="resize: none;width: 100%;height: 40px" class="font-12px"  disabled  inputName="<fmt:message key='project.body.members.label' />"/><c:forEach items="${projectCompose.memberLists}" varStatus="s" var="member">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				</td><td></td>
			</tr>
			<tr height="40"><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.manger.label' />:</td>
				<td colspan="3">
					 <textarea   align="top" name="chargeWeb"  rows="2" validate="maxLength" maxSize="500" style="resize: none;width: 100%;height: 32px" class="font-12px"  disabled inputName="<fmt:message key='project.body.manger.label' />"/><c:forEach items="${projectCompose.chargeLists}" varStatus="s" var="member">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				</td><td></td>
			</tr>
			<tr><td></td>
				<td class="bg-gray" align="right"><fmt:message key='project.body.related.label' />:</td>
				<td colspan="3">
					<textarea 	name="interfixWeb" disabled rows="2" validate="maxLength" maxSize="500"   style="resize: none;width: 100%;height: 40px" class="font-12px"  inputName="<fmt:message key='project.body.related.label' />"/><c:forEach items="${projectCompose.interfixLists}" varStatus="s" var="member">${v3x:showMemberName(member.id)}<c:if test="${!s.last}">、</c:if></c:forEach></textarea>
				</td><td style="vertical-align: bottom;"  nowrap="nowrap">
                                [<a href="###" onclick="javascript:showDescription();"><fmt:message key="project.toolbar.comment.label" /></a>]
                            </td>
			</tr>				
			<tr><td></td>
				<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.phase.label' />:</td>
				<td colspan="3">
					<div class="phaseWindowDiv">
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
 				</td><td></td>
			</tr>
			<c:if test="${projectCompose.projectSummary.phaseId != null && projectCompose.projectSummary.phaseId != '1'}">
				<tr><td></td>
					<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key='project.body.phase.current.label' />:</td>
					<td colspan="3">
						<input id="currentPhaseName" name="currentPhaseName" value="${currentPhaseName}" disabled style="width: 200px;"/>
					</td><td></td>
				</tr>
			</c:if>
			<tr><td></td>
				<td class="bg-gray" align="right" style="padding-top:7px;"><font color="red">*</font><fmt:message key='project.body.teamopen.label.new' />:</td>
				<td colspan="3">
					<label for="publicGroup1">
						<input type="radio" id="publicGroup1" disabled name="publicGroup" value="0"  <c:if test="${projectCompose.projectSummary.publicState =='0'}">checked </c:if>/><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
					</label>
					<label for="publicGroup2">
						<input type="radio" id="publicGroup2"  disabled name="publicGroup" value="1" <c:if test="${projectCompose.projectSummary.publicState =='1'}">checked</c:if>  /><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
					</label>
				</td><td></td>
			</tr>
			<tr><td></td>
				<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="project.body.state.label" />:</td>
				<td colspan="3">
					<label for="projectState1">
						<input type="radio" id="projectState1" name="projectState"	value="0" disabled  <c:if test="${projectCompose.projectSummary.projectState =='0'}">checked</c:if> /><fmt:message key="project.body.projectstate.0" />
					</label>
					<label for="projectState2">
						<input type="radio" id="projectState2" disabled	name="projectState"  value="2" <c:if test="${projectCompose.projectSummary.projectState =='2'}">checked</c:if>/><fmt:message key="project.body.projectstate.2" />
					</label>
				</td><td></td>
			</tr>
			<tr height="70"><td></td>
				<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.desc.label' />:</td>
				<td colspan="3" align="left" valign="top">
					<textarea name="projectDesc" style="resize: none;" cols="" rows="3" validate="maxLength" maxSize="200" class="font-12px breakWord" disabled inputName="<fmt:message key='project.body.desc.label' />">${projectCompose.projectSummary.projectDesc}</textarea>
				</td><td></td>
			</tr>
			<tr><td></td>
				<td class="bg-gray" align="right" valign="top"><fmt:message key='project.body.templates.label' />:</td>
				<td colspan="3" align="left" valign="top">
					<textarea disabled name="templatesWeb" id="templatesWeb" style="resize: none;" rows="3" class="font-12px breakWord" inputName="<fmt:message key='project.body.templates.label' />" /></textarea>
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
		<c:otherwise></c:otherwise>
		</c:choose>
		</tr>
	</table>
			 				</td>
			 				<td></td>
						</tr>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
<!--	<tr height="3%">-->
<!--		<td height="100%" align="right" class="bg-advance-bottom">-->
<!--			<input type="button" id="submit" onclick="window.close();" value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;-->
<!--		</td> -->
<!--	</tr>-->
</table>
</form>
</body>
</html>