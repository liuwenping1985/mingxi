<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>

<div class="portal-layout-cell_head">
<div class="portal-layout-cell_head_l"></div>
<div class="portal-layout-cell_head_r"></div>
</div>
<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
	<tbody>
		<tr>
			<td class="sectionTitleLine sectionTitleLineBackground">
				<div class=sectionSingleTitleLine>
					<div class=sectionTitleLeft></div>
					<div class=sectionTitleMiddel>
					<div class=sectionTitlediv>
						<SPAN class=sectionTitle>
							<fmt:message key="project.info.myProjectColl" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder">
				<v3x:table htmlId="pending1" className="dotted" dragable="false" leastSize="8" data="colList" var="col" pageSize="8" showHeader="false" showPager="false" size="1">
					<c:choose>
						<c:when test="${col.state==2}">
							<c:set var="from" value="listSent" />
						</c:when>
						<c:when test="${col.state==3}">
							<c:set var="from" value="listPending" />
						</c:when>
						<c:otherwise>
							<c:set var="from" value="listDone" />
						</c:otherwise>
					</c:choose>
					
					<v3x:column width="1%" align="right" className="sort height24">
					</v3x:column>
					<v3x:column width="55%" align="left" type="String" maxLength="20" className="sort height24" hasAttachments="${col.attsFlag}" importantLevel="${col.importantLevel}" bodyType="${col.bodyTypeStr}">
						&nbsp;<span class="inline-block flowState_${col.colSummaryState}"></span><a class="title-more" href="javascript:dealCol('${colURL}?method=summary&openFrom=${from}&summaryId=${col.objectId }&affairId=${col.id }')" title="${v3x:toHTML(col.addition)}">${v3x:getLimitLengthString(col.addition,30,"...")}</a>
					</v3x:column>
					<v3x:column width="34%" type="Date" align="right" nowarp="true" className="sort height24">
						<c:if test="${hasNewColl}">
							<a href="javascript:forwardCol('${col.objectId}', '${col.id}', 'self', '${col.canForward}')">[<fmt:message key="project.collaboration.show.forward" bundle="${v3xCommonI18N}" />]</a>
						</c:if>
						<fmt:formatDate value='${col.createDate}' pattern='MM/dd HH:mm' />
					</v3x:column>
					<v3x:column width="10%" align="left" type="String" maxLength="20" className="sort height24" nowarp="true">

						<c:choose>
							<c:when test="${col.state==2}">
                                <c:choose>
                                  <c:when test="${listSent=='yes' }">
                                      <a href="${colURL}?method=listSent">
                                          <fmt:message key="col.coltype.Sent.label" bundle="${collI18N}" />
                                      </a>
                                  </c:when>
                                  <c:otherwise>
                                      <fmt:message key="col.coltype.Sent.label" bundle="${collI18N}" />
                                  </c:otherwise>
                                </c:choose>
							</c:when>
							<c:when test="${col.state==3}">
                                <c:choose>
                                  <c:when test="${listPending=='yes' }">
                                        <a href="${colURL}?method=listPending&from=listPending">
                                          <fmt:message key="col.coltype.Pending.label" bundle="${collI18N}" />
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                       <fmt:message key="col.coltype.Pending.label" bundle="${collI18N}" />
                                    </c:otherwise>
                                  </c:choose>
							</c:when>
							<c:otherwise>
                                    <c:choose>
                                      <c:when test="${listDone=='yes' }">
                                            <a href="${colURL}?method=listDone"><fmt:message
                                            key="col.coltype.Done.label" bundle="${collI18N}" /></a>
                                        </c:when>
                                        <c:otherwise>
                                           <fmt:message key="col.coltype.Done.label" bundle="${collI18N}" />
                                        </c:otherwise>
                                    </c:choose>
							</c:otherwise>
						</c:choose>
<%-- 						<a href="${colURL}?method=listSent&from=${from}"><fmt:message key="col.coltype.${from}.label" bundle="${collI18N}" /></a> --%>
					</v3x:column>
				</v3x:table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="align_right">
					<c:if test="${relat!=true}">
						<c:if test="${hasNewColl == true and hasAuthForNew == true }">
							<c:if test="${projectState == true }">
								[&nbsp;<a href="${basicURL}?method=moreProjectTemplete&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}"><fmt:message key='project.body.templates.label' /></a>&nbsp;]
								[&nbsp;<a href="${colURL}?method=newColl&projectId=${projectCompose.projectSummary.id}&from=relateProject"><fmt:message key="project.info.newColl" /></a>&nbsp;] 
							</c:if>
							<c:if test="${projectState == false }">
								[&nbsp;<font color="gray"><fmt:message key='project.body.templates.label' /></font>&nbsp;]
								[&nbsp;<font color="gray"><fmt:message key="project.info.newColl" /></font>&nbsp;] 							
							</c:if>
						</c:if>
					</c:if>
					[&nbsp;<a href="${basicURL}?method=moreProjectCol&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="portal-layout-cell_footer">
	<div class="portal-layout-cell_footer_l"></div>
	<div class="portal-layout-cell_footer_r"></div>
</div>