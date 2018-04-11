<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<fmt:message key="common.dateselected.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<form action="" name="mainForm" id="mainForm"  method="post" >
  <div>
	<input type="hidden" name="isNewView" value="false">
	<input type="hidden" id="isalert" value="true">
  	<v3x:table data="${myFav}" var="myFavList" htmlId="docgrid" className="sort ellipsis" isChangeTRColor="false" showHeader="true" showPager="true" pageSize="0" dragable="true">
			<v3x:column width="3%" align="center" label="<input type='checkbox' onclick='docSelectAll(this, \"id\")'/>">
			<input type="hidden" id="isFolder${myFavList.id}" value="false">
					<input type="hidden" id="appEnumKey_${myFavList.id}"
					value="${myFavList.appEnumKey}">
					<input type="hidden" id="sourceId_${myFavList.id}"
					value="${myFavList.sourceId}">
					<input type='checkbox' name='id' value="${myFavList.id}" isCollect="true" onClick="chkMenuGrantControl('true','true','true','true','true','true',this,'false','false','${myFavList.isLink}','${myFavList.appEnumKey}','false','${myFavList.createUserId == v3x:currentUser().id}','true','${onlyA6}','${onlyA6s}');" />
					<script type="text/javascript">
						parentAclAll = 'true';
						parentAclEdit = 'true';
						parentAclAdd = 'true';
						parentAclReadonly = 'true';
						parentAclBrowse = 'true';
						parentAclList = 'true';
						pagedAclMap.put('${myFavList.id}', 
							new docListAcl('true','true','true',
										'true','true','true',
										'false','false','${myFavList.isLink}','${myFavList.appEnumKey}','false','${myFavList.createUserId == v3x:currentUser().id}','true','${onlyA6}','${onlyA6s}'));
						
					</script>
			</v3x:column>
		<c:choose>
			<c:when test="${CurrentUser.externalType == 0 }">
				<v3x:column label="doc.search.title.label" width="20%" type="String" >
					<a class="font-12px defaulttitlecss" href="javascript:fnOpenKnowledge('${myFavList.id}','1',null,false,true)">${v3x:toHTML(myFavList.frName)}</a>
				</v3x:column>
				<v3x:column label="doc.search.category.label" width="5%" value="${v3x:toHTML(v3x:_(pageContext, myFavList.typeName))}"  type="String"></v3x:column>
				<v3x:column label="doc.search.creator.label" width="10%" value="${myFavList.name}"  type="String" ></v3x:column>
			 	<v3x:column label="doc.search.createtime.label" width="20%" align="left" type="Date"><fmt:formatDate value="${myFavList.createTime}" pattern="${datetimePattern}"/></v3x:column>
				<v3x:column label="doc.file.path" alt="${myFavList.fullPath}" width="42%" type="String" >
					<a class="font-12px defaulttitlecss" href="javascript:docOpenFun('${myFavList.parentId}')">${myFavList.halfPath}</a>
				</v3x:column>
			</c:when>
			<c:otherwise>
				<v3x:column label="doc.search.title.label" width="30%" type="String" >
					<a class="font-12px defaulttitlecss" href="javascript:fnOpenKnowledge('${myFavList.id}','1',null,false,true)">${v3x:toHTML(myFavList.frName)}</a>
				</v3x:column>
				<v3x:column label="doc.search.category.label" width="10%" value="${v3x:toHTML(v3x:_(pageContext, myFavList.typeName))}"  type="String"></v3x:column>
				<v3x:column label="doc.search.creator.label" width="30%" value="${myFavList.name}"  type="String" ></v3x:column>
			 	<v3x:column label="doc.search.createtime.label" width="27%" align="left" type="Date"><fmt:formatDate value="${myFavList.createTime}" pattern="${datetimePattern}"/></v3x:column>
			</c:otherwise>
		</c:choose>
 	</v3x:table>
  </div>
</form>