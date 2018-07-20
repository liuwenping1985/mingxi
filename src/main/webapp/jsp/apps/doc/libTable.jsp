<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<c:set value="${v3x:currentUser().loginAccount}" var="loginAccountId" />
	<div class="center_div_row2" id="scrollListDiv" style="top:0px">
		<form name="top" id="top" method="post">
			<v3x:table data="${docTableVo}" var="vo" isChangeTRColor="true" showHeader="true" pageSize="20" className="sort ellipsis" >
			<c:choose>
				<c:when test="${(vo.doclib.type==0 || vo.doclib.type==2 || vo.doclib.type==3) && vo.doclib.domainId != loginAccountId }">  <!-- ${v3x:getOrgEntity('Account', vo.doclib.domainId)} -->  <%-- 前面的HTML注释代码是为了解决websphere下面兼容问题而特别加上，请勿删除! --%>
					<c:set value="(${v3x:getAccount(vo.doclib.domainId).shortName})" var="otherAccountShortName" />
				</c:when>
				<c:otherwise>
					<c:set value="" var="otherAccountShortName" />
				</c:otherwise>
			</c:choose>
				<c:set value="OnMouseUp('${vo.root.docResource.id}','${vo.doclib.createUserId}','${sessionScope['com.seeyon.current_user'].id}','${vo.doclib.id}','${vo.doclib.type}','${vo.doclib.columnEditable}','${vo.root.allAcl}','${vo.root.editAcl}','${vo.root.addAcl}','${vo.root.readOnlyAcl}','${vo.root.browseAcl}','${vo.root.listAcl}','${vo.isOwner}','${vo.root.docResource.frName}','${vo.noShare}','${vo.doclib.isDefault}', '${vo.doclib.searchConditionEditable}', '${vo.doclib.isSearchConditionDefault}','${vo.vForProperties}','${vo.vForShare}')" var="event" />
				<c:set value="editImg('${vo.doclib.id}')" var="mover" />
				<c:set value="removeEditImg('${vo.doclib.id}')" var="mout" />
				<v3x:column label="common.name.label" onmouseover="${mover}" onmouseout="${mout}"
					width="30%" alt="${v3x:_(pageContext, vo.doclib.name)}${otherAccountShortName}" type="String">
						<a class="font-12px defaulttitlecss" href="javascript:folderOpenFunHomepage('${vo.root.docResource.id}','${vo.root.docResource.frType}','${vo.root.allAcl}','${vo.root.editAcl}','${vo.root.addAcl}','${vo.root.readOnlyAcl}','${vo.root.browseAcl}','${vo.root.listAcl}','false','${vo.doclib.id}','${vo.doclib.type}','${vo.v}')">
							${v3x:getLimitLengthString(v3x:_(pageContext, vo.doclib.name), 32,'...')}${otherAccountShortName}
						</a>
					<c:if test="${vo.root.isPersonalLib == false}" >
						<span class="div-float-right editContent cursor-hand"
							title="<fmt:message key='doc.menu.caozuo.label'/>"
							onclick="${event}" id="_${vo.doclib.id}"></span>
					</c:if>
				</v3x:column>		
				<v3x:column label="common.type.label" width="15%" type="String">
					<fmt:message key="${vo.docLibType}"/></v3x:column>
				<v3x:column label="doc.jsp.properties.common.lib.admin" width="35%" alt="${vo.managerName}" type="String">${vo.managerName}</v3x:column>
				<v3x:column label="doc.metadata.def.lastupdate" width="20%" align="left" type="Date">
			 		<fmt:formatDate value="${vo.doclib.lastUpdate}"	pattern="${datetimePattern}"/></v3x:column>		
			</v3x:table>
		</form>
	</div>

<div id="deleteInfo"></div>