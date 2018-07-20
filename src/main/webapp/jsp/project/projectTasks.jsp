<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/taskmanage/js/taskmanage.js${v3x:resSuffix()}" />"></script>
<div class="portal-layout-cell_head">
<div class="portal-layout-cell_head_l"></div>
<div class="portal-layout-cell_head_r"></div>
</div>
<table border="0" cellSpacing="0" cellPadding="0" width="100%"  class="portal-layout-cell-right">
	<tbody>
		<tr>
			<td class="sectionTitleLine sectionTitleLineBackground">
				<div class=sectionSingleTitleLine>
					<div class=sectionTitleLeft></div>
					<div class=sectionTitleMiddel>
					<div class=sectionTitlediv>
						<SPAN class=sectionTitle>
							<fmt:message key="project.info.myProjectTasks" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder">
				<v3x:table htmlId="pending3" className="dotted" dragable="false" leastSize="8" data="projectTasks" var="task" pageSize="8" showHeader="false" showPager="false" size="1">
					<v3x:column  width="32%" align="left" type="String" className="sort height24" hasAttachments="${task.hasAttachments}" label="common.name.label" alt="${task.subject}" nowarp="true">
						
						<c:if test="${task.importantLevel > 1}">
                          <img src="<c:url value="/common/images/importance_${task.importantLevel}.gif" />" />
                        </c:if>
                        <c:if test="${task.milestone == 1 }">
                            <span class="milestone"></span>
                        </c:if>
                        <c:if test="${task.riskLevel > 0}">
						  <img src="<c:url value="/apps_res/taskmanage/images/risk${task.riskLevel}.gif" />" />
						</c:if>
						<a href="javascript:viewTaskInfo('${task.id}')" title="${v3x:toHTML(task.subject)}" class="title-more">${v3x:toHTML(v3x:getLimitLengthString(task.subject, 23, '...'))}</a>
					</v3x:column>
					
					<c:set value="${v3x:showOrgEntitiesOfIds(task.managers, 'Member', pageContext)}" var="managersName" />
					<v3x:column  width="10%" align="left" type="String" value="${v3x:getLimitLengthString(managersName, 10,'...')}" alt="${v3x:toHTMLWithoutSpace(managersName)}" nowarp="true"/>
					
					<v3x:column width="13%" type="Date" align="left" nowarp="true" className="sort height24">
                        <c:choose>
                            <c:when test="${task.fullTime == true}">
                                <fmt:formatDate value='${task.plannedStartTime}' pattern='MM/dd' />
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate value='${task.plannedStartTime}' pattern='MM/dd HH:mm' />
                            </c:otherwise>
                        </c:choose>
					</v3x:column>
					<c:if test="${task.canAddfeedback==true}">
					<v3x:column type="String" width="15%" align="center" onClick="addReport('${task.id}')" label="task.status" className="cursor-hand sort" nowarp="true">
						<c:if test="${task.status==1}">${ctp:i18n("taskmanage.status.notstarted")}</c:if>
						<c:if test="${task.status==2}">${ctp:i18n("taskmanage.status.marching")}</c:if>
						<c:if test="${task.status==3}">${ctp:i18n("taskmanage.status.delayed")}</c:if>
						<c:if test="${task.status==4}">${ctp:i18n("taskmanage.status.finished")}</c:if>
						<c:if test="${task.status==5}">${ctp:i18n("taskmanage.status.canceled")}</c:if>
					</v3x:column>
					</c:if>
					<c:if test="${task.canAddfeedback==false}">
					<v3x:column type="String" width="15%" align="center" label="task.status" className="sort" nowarp="true" >
						<c:if test="${task.status==1}"><font color="gray">${ctp:i18n("taskmanage.status.notstarted")}</font></c:if>
						<c:if test="${task.status==2}"><font color="gray">${ctp:i18n("taskmanage.status.marching")}</font></c:if>
						<c:if test="${task.status==3}"><font color="gray">${ctp:i18n("taskmanage.status.delayed")}</font></c:if>
						<c:if test="${task.status==4}"><font color="gray">${ctp:i18n("taskmanage.status.finished")}</font></c:if>
						<c:if test="${task.status==5}"><font color="gray">${ctp:i18n("taskmanage.status.canceled")}</font></c:if>
					</v3x:column>
					</c:if>
				    <v3x:column width="20%" onClick="${onClick}" align="left" label="task.finishrate" className="cursor-hand sort" nowarp="true">
					    <div style="border: 1px solid #A4A4A4; height: 10px; overflow:hidden;">
<%-- 							<img src="${pageContext.request.contextPath}/apps_res/project/images/pro_g.gif" width="${task.finishRate}%" height="15"> --%>
                            <c:if test="${task.status==1}">
                                <div class="project_progress_bar_nostart" style="width:${task.finishRate}%; height:15px;">&nbsp;</div> 
                            </c:if>
                            <c:if test="${task.status==2}">
                                <div class="project_progress_bar_process" style="width:${task.finishRate}%; height:15px;">&nbsp;</div> 
                            </c:if>
                            <c:if test="${task.status==3}">
                                <div class="project_progress_bar_delay" style="width:${task.finishRate}%; height:15px;">&nbsp;</div> 
                            </c:if>
                            <c:if test="${task.status==4}">
                                <div class="project_progress_bar_filish" style="width:${task.finishRate}%; height:15px;">&nbsp;</div> 
                            </c:if>
                            <c:if test="${task.status==5}">
                                <div class="project_progress_bar_cancel" style="width:${task.finishRate}%; height:15px;">&nbsp;</div> 
                            </c:if>
						</div>
				    </v3x:column>
				    <v3x:column width="7%" type="String" onClick="${onClick}" align="left" label="task.finishrate2" className="cursor-hand sort" nowarp="true">
					    <span class="right margin_l_5">${task.finishRateStr}%</span>
				    </v3x:column>
						
				</v3x:table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="align_right">
					<c:if test="${hasNewTask==true and relat!=true and hasAuthForNew == true}">
						<c:if test="${projectState==true}">
                            <c:set value="true" var="isNewTask" />
							[&nbsp;<a href="javascript:addProjectTask('${param.projectId}', '${projectCompose.projectSummary.phaseId }', '<fmt:formatDate value="${phase4Task == null ? projectCompose.projectSummary.begintime : phase4Task.phaseBegintime}" pattern='yyyy-MM-dd'/>', '<fmt:formatDate value="${phase4Task == null ? projectCompose.projectSummary.closetime : phase4Task.phaseClosetime}" pattern='yyyy-MM-dd'/>','new')"><fmt:message key='menu.taskmanage.new' bundle='${v3xMainI18N}' /></a>&nbsp;]
						</c:if>
						<c:if test="${projectState==false}">
							[&nbsp;<font color="gray"><fmt:message key='menu.taskmanage.new' bundle='${v3xMainI18N}' /></font>&nbsp;]
						</c:if>
					</c:if>
					[&nbsp;<a href="javascript:moreProjectTasks('${param.projectId}', '${phaseId}', ${managerFlag},${projectState},${empty isNewTask ? false : isNewTask});"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="portal-layout-cell_footer">
	<div class="portal-layout-cell_footer_l"></div>
	<div class="portal-layout-cell_footer_r"></div>
</div>