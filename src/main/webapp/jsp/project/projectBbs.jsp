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
							<fmt:message key="project.info.myProjectBbs" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder">
				<v3x:table htmlId="bbsList" className="dotted" dragable="false" leastSize="8" data="bbsList" var="bbs" pageSize="8" showHeader="false" showPager="false" size="1">
					<v3x:column width="2%" align="right">
					</v3x:column>
					<v3x:column align="left" width="58%" alt="${bbs.articleName}" hasAttachments="${bbs.attachmentFlag}">
						<a class="title-more" href="javascript:openWin('${bbsURL}?method=showPost&resourceMethod=listLatestFiveArticleAndAllBoard&articleId=${bbs.id}')">${v3x:toHTML(v3x:getLimitLengthString(bbs.articleName,33,"..."))}</a>
					</v3x:column>
					<v3x:column width="15%" type="String" label="common.issuer.label" alt="${v3x:showMemberName(bbs.issueUser)}">
						<nobr>${v3x:showMemberName(bbs.issueUser)}</nobr>
					</v3x:column>
					<v3x:column align="left" width="25%">
						<fmt:formatDate value='${bbs.issueTime}' pattern='MM/dd HH:mm' />
					</v3x:column>
				</v3x:table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="align_right">
					<c:if test="${relat != true and hasAuthForNew == true}">
						<c:if test="${projectState == true}">
							[&nbsp;<a href="${bbsURL}?method=issuePost&projectState=${projectState}&showSpaceLacation=true&boardId=${projectCompose.projectSummary.id}&managerFlag=${managerFlag}&phaseId=${phaseId}"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /><fmt:message key="application.9.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
						</c:if>
						<c:if test="${projectState != true}">
							[&nbsp;<font color="gray"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /><fmt:message key="application.9.label" bundle="${v3xCommonI18N}" /></font>&nbsp;]
						</c:if>
					</c:if>
					[&nbsp;<a href="${bbsURL}?method=moreProjectBbs&projectState=${projectState}&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}&relat=${relat }"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="portal-layout-cell_footer">
	<div class="portal-layout-cell_footer_l"></div>
	<div class="portal-layout-cell_footer_r"></div>
</div>