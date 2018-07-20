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
							<fmt:message key="project.info.myProjectDoc" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder">
				<v3x:table htmlId="docs" leastSize="8" className="dotted"  dragable="false" data="docList" var="doc" pageSize="8" showHeader="false" showPager="false" size="1">
					<c:set value="${doc.docResource.hasAttachments}" var="attflag" />
					<v3x:column width="1%" align="right" className="sort height24">
					</v3x:column>
					<v3x:column width="48%" align="left" hasAttachments="${attflag}" className="sort height24">
						<img src="${pageContext.request.contextPath}${doc.icon}" style="display: block; float: left; margin-top: 2px;" />
						<a class="title-more margin_l_5" href="javascript:fnOpenKnowledge('${doc.docResource.id}')" style="display: block;float: left;" title="${v3x:toHTML(doc.name)}">${v3x:toHTML(v3x:getLimitLengthString(doc.name,28,"..."))}</a>
					</v3x:column>
					<v3x:column type="Date" width="20%" align="right" className="sort height24">
						<fmt:formatDate value='${doc.lastUpdate }' pattern='MM/dd HH:mm' />
					</v3x:column>
					<v3x:column width="15%" align="left" className="sort height24">
						<a title="${v3x:toHTML(doc.type)}"><font color="black">${v3x:getLimitLengthString(doc.type,8,"...")}</font></a>
		   			</v3x:column>	
				</v3x:table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="align_right">
					<c:if test="${relat!=true}">
						<c:if test="${projectState&&addAcl}">
							[<a onmouseout="autoReply_moveOut('divAutoReply')" onmouseover="javascript:autoReply_m(this,'divAutoReply',3)"><fmt:message key="project.lable.document" /></a>]
							[<a href="javascript:fileUpload();"><fmt:message key="project.upload.label" /></a>]
						</c:if>
						<c:if test="${!projectState}">
							[ <font color="gray"><fmt:message key="project.lable.document" /></font>]
						</c:if>
					</c:if>
					<c:if test = "${hasAcl==true}">
						[&nbsp;<a href="${docURL}?method=docHomepageIndex&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key="project.info.treeView" /></a>&nbsp;]
				    </c:if>
			   		[&nbsp;<a href="${basicURL}?method=moreProjectDoc&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="portal-layout-cell_footer">
	<div class="portal-layout-cell_footer_l"></div>
	<div class="portal-layout-cell_footer_r"></div>
</div>