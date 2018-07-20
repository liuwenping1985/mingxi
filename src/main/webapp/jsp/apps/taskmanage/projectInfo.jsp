<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/project/js/project.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
v3x.loadLanguage("/apps_res/project/i18n");
</script>
<tr>
	<td height="60" valign="top"  class="main-bg">
		<table width="100%" height="100%" border="0"  cellpadding="0" cellspacing="0">
			<tr height="30px;">
				<td width="45" height="40" valign="top" class="page2-header-img"><div class="template"></div></td>
				<td class="page2-header-bg-p" height="40px;" style="padding-left: 5px;">
					<span style="font-size: 20px;" title="${v3x:toHTML(projectCompose.projectSummary.projectName)}"> ${v3x:toHTML(v3x:getLimitLengthString(projectCompose.projectSummary.projectName,30,"..."))} </span><br/>
					<div style="font-size: 12px;font-weight: normal; vertical-align: top">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<c:if test="${projectCompose.chargeLists != null && fn:length(projectCompose.chargeLists) > 0}">
								<tr>
									<td>
										<font color="black"><fmt:message key='project.body.manger.label' bundle='${projectI18N}' />:
										<c:forEach items="${projectCompose.chargeLists}" var="charge">
											<a class="cursor-hand" onclick="showV3XMemberCard('${charge.id}')"><c:out value="${charge.name}"></c:out></a>&nbsp;
										</c:forEach>
										</font>
									</td>
								</tr>
							</c:if>
							<tr>
								<td>
									<font color="black"><fmt:message key='project.body.responsible.label' bundle='${projectI18N}' />:
										<c:forEach items="${projectCompose.principalLists}" var="principal">
											<a class="cursor-hand" onclick="showV3XMemberCard('${principal.id}')">${principal.name}</a>
										</c:forEach>
									</font>
								</td>
							</tr>
						</table>
					</div>
				</td>
				<td align="right" valign="top" style="padding-top: 4px">
					<input type="hidden" id="hiddenProjectId" value="${projectCompose.projectSummary.id}" />
					<input type="hidden" id="projectId" name="projectId" value="${param.projectId}" />
					<input type="hidden" id="projectPhaseId" name="projectPhaseId" value="${param.projectPhaseId}" />
					<input type="hidden" id="morePro" value="projectTask" />
					<input type="hidden" id="managerFlag" value="${param.managerFlag }" />
                    <input type="hidden" name="projectState" id="projectState" value="${param.projectState}" />
					<input type="hidden" id="refreshFlag" name="refreshFlag" value="true" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
				<td width="49%" valign="top" style="padding-top: 15px;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="15%">
								<fmt:message key='project.project.label' bundle='${projectI18N}' /><fmt:message key='project.time' bundle='${projectI18N}' />:
							</td>
							<td colspan="3">
								<span style="font-size: 12px;font-weight: normal; vertical-align: top">
									<fmt:formatDate value='${projectCompose.projectSummary.begintime}' pattern='yyyy.MM.dd' /> ~ <fmt:formatDate value='${projectCompose.projectSummary.closetime}' pattern='yyyy.MM.dd' />
								</span>
							</td>
						</tr>
						<tr>
							<td width="15%">
								<fmt:message key='project.process.label' bundle='${projectI18N}' />:
							</td>
							<td width="30%">
								<div style="border: 1px solid #A4A4A4; height: 10px; overflow:hidden;">
									<img src="${pageContext.request.contextPath}/apps_res/project/images/pro_g.gif" width="${projectCompose.projectSummary.projectProcess}%" height="15">
								</div>
							</td>
							<td width="10%">
								&nbsp;${projectProcess}%&nbsp;
							</td>
							<td width="45%">&nbsp;&nbsp;
                                <c:set var="managerFlag" value="${param.managerFlag }" />
                                <c:choose>
                                    <c:when test="${managerFlag == 1 and projectCompose.projectSummary.projectState!=2}">
                                        <a onclick="javascript:showProjectInfo(1);">[<fmt:message key='project.toolbar.add.label' bundle="${projectI18N}" />]</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a onclick="javascript:showProjectInfo(2);">[<fmt:message key='project.showprojectdetail.label' bundle="${projectI18N}" />]</a>
                                    </c:otherwise>
                                </c:choose>
							</td>
						</tr>
						<tr>
							<td width="15%" valign="middle">
								<fmt:message key='project.body.phaseSwitch.label' bundle='${projectI18N}' />:
							</td>
							<td  colspan="3">
								<select name="changephase" style="width:150px" onChange="changeProjectPhase4Tasks(this)">
									<option value="1" "${phaseId == 1 ? 'selected' : ''}"><fmt:message key='common.all.label' bundle="${v3xCommonI18N}" /></option>
									<c:forEach var="phase" items='${projectCompose.projectSummary.projectPhases}'>
										<option value='${phase.id}' ${phaseId == phase.id ? 'selected' : ''}>${phase.phaseName}</option>
										<c:if test="${phase.id == projectCompose.projectSummary.phaseId}">
											<c:set value="${phase}" var="phase4Task" />
										</c:if>
									</c:forEach>
								</select>
								<input type="hidden" name="currentPhaseId" id="currentPhaseId" value="${phase4Task == null ? param.projectPhaseId : phase4Task.id}" />
								<input type="hidden" id="projectBeginTime" name="projectBeginTime" value="<fmt:formatDate value='${phase4Task == null ? projectCompose.projectSummary.begintime : phase4Task.phaseBegintime}' pattern='yyyy-MM-dd'/>" />
								<input type="hidden" id="projectEndTime" name="projectEndTime" value="<fmt:formatDate value='${phase4Task == null ? projectCompose.projectSummary.closetime : phase4Task.phaseClosetime}' pattern='yyyy-MM-dd'/>" />
							</td>
						</tr>
						<tr><td colspan="4"></td></tr>
					</table>
				</td>
				<td width="50">
<%-- 				<a href="${projectURL}?method=projectInfo&projectId=${param.projectId}&phaseId=${param.projectPhaseId}"><span class='backpage'></span></a>&nbsp;&nbsp; --%>
				</td>
			</tr>
		</table>
	</td>
</tr>
