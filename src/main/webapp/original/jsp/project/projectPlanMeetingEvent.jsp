<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
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
							<fmt:message key="project.info.myProjectPlanAndMeeting"/>
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder">
				<v3x:table htmlId="plans" className="dotted"  dragable="false" leastSize="8" data="mtAndPlanList" var="col" pageSize="8" showHeader="false" showPager="false" size="1">
					<v3x:column width="1%" align="right">
					</v3x:column>
					<v3x:column align="left" width="37%" alt="${v3x:toHTML(col.subject)}" bodyType="${col.bodyType}" hasAttachments="${col.attsFlag}">
						<c:choose>
							<c:when test="${col.app==5 }">
								<a class="title-more" href="javascript:openDetailURL('${planURL}?method=initPlanDetailFrame&dataSource=project&editType=${sessionScope['com.seeyon.current_user'].id==col.memberId ? 'summary' : 'reply' }&planId=${col.objectId }')" title="${v3x:toHTML(col.subject)}">
								${v3x:toHTML(v3x:getLimitLengthString(col.subject,18,"..."))}</a>
							</c:when>
							<c:when test="${col.app==6 }">
								<a class="title-more" href="javascript:openDetailURL('${mtURL}?method=myDetailFrame&id=${col.objectId }&state=${col.state}')" title="${v3x:toHTML(col.subject)}">
								${v3x:toHTML(v3x:getLimitLengthString(col.subject,18,"..."))}</a>
								<c:if test="${col.meetingType eq  '2' }">
									<span class="bodyType_videoConf inline-block"></span>
								</c:if>
							</c:when>
							<c:when test="${col.app==11}">
<%-- 								<a class="title-more" href="javascript:openCal('${col.objectId}')" title="${v3x:toHTML(col.subject)}"> --%>
                                    <a class="title-more" href="javascript:addCal('1','${col.objectId}','${calEventUpdateMap[col.objectId]||col.memberId==CurrentUser.id}')" title="${col.subject}">
                                    ${v3x:getLimitLengthString(col.subject,18,"...")}</a>
							</c:when>
							<c:otherwise>
								<a href="#" class="title-more">${v3x:toHTML(v3x:getLimitLengthString(col.subject,18,"..."))}</a>
							</c:otherwise>
						</c:choose>
						
					</v3x:column>
					<v3x:column width="18%" alt="${(col.app != '')?v3x:showOrgEntitiesOfIds(col.memberId, 'Member', pageContext):col.addition}"> ${v3x:getLimitLengthString(v3x:showOrgEntitiesOfIds(col.memberId, "Member", pageContext),14,"....")}</v3x:column>
					<v3x:column align="right" width="20%"  nowarp="true">
						<fmt:formatDate value='${col.createDate}' pattern='MM/dd HH:mm' />
					</v3x:column>
					<v3x:column align="right" width="10%" nowarp="true">
						<c:choose>
							<c:when test="${col.app==5 }">
								<a href="<html:link renderURL='/plan/plan.do?method=planListHome' />"><fmt:message key="application.${col.app}.label" bundle="${v3xCommonI18N}" /></a>
							</c:when>
							<c:when test="${col.app==6 }">
								<c:set value="javascript:void(0);" var="meetingListUrl"/>
								<c:if test="${hasMeetingPending}">
									<c:set value="meetingNavigation.do?method=entryManager&entry=meetingPending&listMethod=listPendingMeeting" var="meetingListUrl" />
								</c:if>
								<c:if test="${col.state!=10 && col.state!=20 && hasMeetingDone}">
									<c:set value="meetingNavigation.do?method=entryManager&entry=meetingDone&listMethod=listDoneMeeting" var="meetingListUrl" />
								</c:if>
								<a href="${meetingListUrl }"><fmt:message key="application.${col.app}.label" bundle="${v3xCommonI18N}" /></a>
							</c:when>
							<c:when test="${col.app==11 }">
								<a href="${calEventURL}?method=calEventIndex&from=project&projectId=${projectCompose.projectSummary.id}"><fmt:message key="project.affair.label"/></a>
							</c:when>
						</c:choose>
					</v3x:column>
					<v3x:column align="right" width="15%"  nowarp="true">
						<c:choose>
							<c:when test="${col.app==5 }">
							   <c:if test="${col.state==1}"><fmt:message key="plan.status.beforeBeginning"/></c:if>
							   <c:if test="${col.state==2}"><fmt:message key="plan.status.ongoing"/></c:if>
                               <c:if test="${col.state==3}"><fmt:message key="plan.status.finished"/></c:if>
                               <c:if test="${col.state==4}"><fmt:message key="plan.status.cancelled"/></c:if>
                               <c:if test="${col.state==5}"><fmt:message key="plan.status.postponed"/></c:if>
							</c:when>
							<c:when test="${col.app==6 }">
							   <c:if test="${col.state==10}"><fmt:message key="mt.mtMeeting.state.10"/></c:if>
							   <c:if test="${col.state==20}"><fmt:message key="mt.mtMeeting.state.20"/></c:if>
                               <c:if test="${col.state==30}"><fmt:message key="mt.mtMeeting.state.30"/></c:if>
							   <c:if test="${col.state==40}"><fmt:message key="mt.mtMeeting.state.40"/></c:if>
							</c:when>
							<c:when test="${col.app==11 }">
							   <c:if test="${col.state==1}"><fmt:message key="cal.event.states.1"/></c:if>
							   <c:if test="${col.state==2}"><fmt:message key="cal.event.states.2"/></c:if>
                               <c:if test="${col.state==3}"><fmt:message key="cal.event.states.3"/></c:if>
                               <c:if test="${col.state==4}"><fmt:message key="cal.event.states.4"/></c:if>
							</c:when>
						</c:choose>
					</v3x:column>
				</v3x:table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="align_right">
					<c:if test="${relat != true and hasAuthForNew == true }">
						<c:if test="${hasNewPlan == true and projectState == true}">
							[&nbsp;<a onmouseout="autoReply_moveOut('divAutoReply2')" onMouseOver="javascript:autoReply_m(this,'divAutoReply2',2)"> <fmt:message key="project.info.newPlan" /> </a>] 
						</c:if>
						<c:if test="${hasNewPlan == true and projectState == false}">
							[&nbsp;<font color="gray"> <fmt:message key="project.info.newPlan" /> </font>] 
						</c:if>
						
						<c:if test="${hasNewMeeting == true  and projectState == true}">
							[&nbsp;<a href="meetingNavigation.do?method=entryManager&entry=meetingArrange&listMethod=create&projectId=${projectCompose.projectSummary.id}"><fmt:message key="project.info.newMeeting" /> </a>]  
						</c:if>
						<c:if test="${hasNewMeeting == true and projectState != true}">
							[&nbsp;<font color="gray"><fmt:message key="project.info.newMeeting" /> </font>]  
						</c:if>
						
						<c:if test="${hasNewCal == true and projectState == true}">
							[&nbsp;<a href="javascript:addCal('0','0')"> <fmt:message key="project.info.newCal" /> </a>]  
						</c:if>
						<c:if test="${hasNewCal == true and projectState != true}">
							[&nbsp;<font color="gray"> <fmt:message key="project.info.newCal" /> </font>]  
						</c:if>
					</c:if>
					[&nbsp;<a href="${basicURL}?method=moreProjectPlanAndMeeting&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="portal-layout-cell_footer">
	<div class="portal-layout-cell_footer_l"></div>
	<div class="portal-layout-cell_footer_r"></div>
</div>