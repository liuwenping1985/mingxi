<%-- 此页面废弃，留作纪念 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<table border=0 cellSpacing=0 cellPadding=0 width="100%">
	<tbody>
		<tr>
			<td class="sectionTitleLine sectionTitleLineBackground">
				<div class=sectionSingleTitleLine>
					<div class=sectionTitleLeft></div>
					<div class=sectionTitleMiddel>
					<div class=sectionTitlediv>
						<SPAN class=sectionTitle>
							<fmt:message key="project.body.templates.label" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder">
				<v3x:table htmlId="templeteList" data="templeteList" var="templete" className="dotted" dragable="false" leastSize="8" pageSize="8" showHeader="false" showPager="false" size="1">
					<v3x:column width="1%" align="right" className="sort height24">
						<img src="<c:url value="/common/images/icon.gif"/>" width="10" height="10" />
					</v3x:column>
					<v3x:column width="99%" align="left" type="String" maxLength="40" className="sort height24" bodyType="${templete.bodyType}">
						&nbsp;<a class="title-more" href="${colURL}?method=newColl&templeteId=${templete.id}&projectId=${projectCompose.projectSummary.id}&from=relateProject" title="${templete.subject}">${v3x:getLimitLengthString(templete.subject,30,"...")}</a>
					</v3x:column>
				</v3x:table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="more">
					<c:if test="${relat != true}">
						<c:if test="${fn:length(colTempleteList) > 0}">
							[&nbsp;<a onMouseOver="javascript:autoReply_m(this,'divAutoReply3',1)" ><fmt:message key='project.info.collTemp' /></a>&nbsp;]
						</c:if>
						<c:if test="${isManager}">
							<c:if test="${projectState == true}">
								[&nbsp;<a href="javascript:setProjectTemplete('true')"><fmt:message key="templete.button.config.label" bundle="${collI18N}" /></a>&nbsp;] 
							</c:if>
						</c:if>
					</c:if>
					[&nbsp;<a href="${basicURL}?method=moreProjectTemplete&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>