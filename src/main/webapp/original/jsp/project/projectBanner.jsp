<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<style type="text/css">
.sectionSingleTitleLine {
	background: none;
	background-color: #daeaf1;
}
</style>
<table width="100%" height="100%" border="0" bordercolor="red" cellpadding="0" cellspacing="0"style="background:#a2d2e6;">
	<tr>
		<td width="45" height="40" valign="top" class="page2-header-img"><div class="template"></div></td>
		<td class="page2-header-bg-p border-padding" height="40">
			<div style="width:370px;font-size: 20px;overflow:hidden;text-overflow:ellipsis;word-break:keep-all;white-space:nowrap;" title="${v3x:toHTML(projectCompose.projectSummary.projectName)}"> ${v3x:toHTML(projectCompose.projectSummary.projectName)}</div>
			<span style="font-size: 12px;font-weight: normal; vertical-align: top">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<c:if test="${projectCompose.chargeLists != null && fn:length(projectCompose.chargeLists) > 0}">
						<tr>
							<td>
								<font color="black"><fmt:message key='project.body.manger.label' />:
								<c:forEach items="${projectCompose.chargeLists}" var="charge">
									<a class="cursor-hand" onclick="showV3XMemberCard('${charge.id}')"><c:out value="${charge.name}"></c:out></a>&nbsp;
								</c:forEach>
								</font>
							</td>
						</tr>
					</c:if>
					<tr>
						<td>
							<font color="black"><fmt:message key='project.body.responsible.label' />:
								<c:forEach items="${projectCompose.principalLists}" var="principal">
									<a class="cursor-hand" onclick="showV3XMemberCard('${principal.id}')">${principal.name}</a>
								</c:forEach>
							</font>
						</td>
					</tr>
				</table>
			</span>
		</td>
		<td align="right" valign="top" class="" style="padding: 2px">
			<input type="hidden" id="hiddenProjectId" value="${projectCompose.projectSummary.id}" />
			<input type="hidden" id="refreshFlag" value="true" />
			&nbsp;&nbsp;&nbsp;
		</td>
		<td class="" width="60%" valign="top" style="padding: 2px;" align="right">
			<table width="" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="15%" valign="middle" nowrap="nowrap">
						<font color="black"><fmt:message key='project.body.projectSwitch.label' />:</font>
					</td>
					<td width="25%" align="left" nowrap="nowrap">
						<select name="changeproject" style="width:150px" onChange="changeProject(this)">
							<c:forEach var="project" items='${projectSummaryList}'>
								<option value='<c:out value="${project.id}"/>' '<c:if test="${project.id==projectCompose.projectSummary.id}">' selected '</c:if>'><c:out value="${project.projectName}"/></option>
							</c:forEach>
						</select>
					</td>
					<td valign="middle" nowrap="nowrap"  align="right">
						<c:choose>
							<c:when test="${isManager and projectCompose.projectSummary.projectState!=2}">
								<a onclick="javascript:showProjectInfo(1);">[<fmt:message key='project.toolbar.add.label.new' />]</a>
							</c:when>
							<c:otherwise>
								<a onclick="javascript:showProjectInfo(2);">[<fmt:message key='project.showprojectdetail.label' />]</a>
							</c:otherwise>
						</c:choose>
						<c:set var="managerFlag" value="${isManager ? 1 : 2}" />
					</td>
					<td colspan="2" >
					&nbsp;&nbsp;
					</td>
				</tr>
				<tr><td colspan="5"></td></tr>
				<tr>
					<td width="15%" nowrap="nowrap">
						<font color="black"><fmt:message key='project.project.label' /><fmt:message key='project.time' />:</font>
					</td>
					<td width="25%" align="left" nowrap="nowrap">
						<span style="font-size: 12px;font-weight: normal; vertical-align: top">
							<font color="black"><fmt:formatDate value='${projectCompose.projectSummary.begintime}' pattern='yyyy.MM.dd' />~ <fmt:formatDate value='${projectCompose.projectSummary.closetime}' pattern='yyyy.MM.dd' /></font>
						</span>
					</td>
					<td width="15%" align="right" nowrap="nowrap">
						<font color="black"><fmt:message key='project.process.label' />:</font>
					</td>
					<td width="30%" nowrap="nowrap" align="left">
						<div style="border: 1px solid #A4A4A4; height: 10px; overflow:hidden;">
							<img src="${pageContext.request.contextPath}/apps_res/project/images/pro_g.gif" width="${projectCompose.projectSummary.projectProcess}%" height="15">
						</div>
					</td>
					<td width="15%" align="left" nowrap="nowrap">
						&nbsp;${projectProcess}%&nbsp;
						<c:if test="${isManager}">
							<a onclick="javascript:setProcess();">[<fmt:message key='common.button.modify.label' bundle='${v3xCommonI18N}' />]</a>
						</c:if>
					</td>
				</tr>
				<tr><td colspan="5"></td></tr>
				<c:if test="${projectCompose.projectSummary.projectPhases != null && fn:length(projectCompose.projectSummary.projectPhases) > 0}">
					<tr>
						<td nowrap="nowrap">
							<font color="black"><fmt:message key='project.body.phase.current.label' />:</font>
						</td>
						<td nowrap="nowrap">
							<input type="hidden" id="changecurrentphase" name="changecurrentphase" value="${projectCompose.projectSummary.phaseId}">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td align="left" nowrap="nowrap">
										<c:forEach var="phase" items='${projectCompose.projectSummary.projectPhases}'>
											<c:if test="${projectCompose.projectSummary.phaseId == phase.id}">
												${phase.phaseName}
											</c:if>
										</c:forEach>
									</td>
									<td align="right" nowrap="nowrap">
										<c:if test="${isManager}">
											<a onclick="javascript:setPhase();">[<fmt:message key='common.button.modify.label' bundle='${v3xCommonI18N}' />]&nbsp;&nbsp;&nbsp;</a>
										</c:if>
									</td>
								</tr>
							</table>


						</td>
						<td valign="middle" align="right" nowrap="nowrap">
							<font color="black"><fmt:message key='project.body.phaseSwitch.label' />:</font>
						</td>
						<td nowrap="nowrap">
							<select name="changephase" style="width:100%;" onChange="changePhase(this)">
								<option value="1"><fmt:message key='common.all.label' bundle="${v3xCommonI18N}" /></option>
								<c:forEach var="phase" items='${projectCompose.projectSummary.projectPhases}'>
									<option value='${phase.id}' ${phaseId == phase.id ? 'selected' : ''}>${phase.phaseName}</option>
									<c:if test="${phase.id == phaseId}">
										<c:set value="${phase}" var="currentPhase" />
									</c:if>
									<c:if test="${phase.id == projectCompose.projectSummary.phaseId}">
										<c:set value="${phase}" var="phase4Task" />
									</c:if>
								</c:forEach>
							</select>
						</td>
						<td></td>
					</tr>
				</c:if>
			</table>
		</td>
	</tr>
</table>