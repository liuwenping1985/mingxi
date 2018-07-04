<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="spaceHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<title></title>
</head>
<script type="text/javascript">
<!-- 	
	
	function doOneClick(theId){
		parent.bottom.location.href="${spaceURL}?method=getSpaceModify&spaceId="+theId+"&dbClick=false";
	}

	function doTwoClick(theId){
		parent.bottom.location.href="${spaceURL}?method=getSpaceModify&spaceId="+theId+"&dbClick=true";
	}
//-->	
</script>
<body scroll="no">
<form id="theForm" name="theForm" >
	<v3x:table data="${docSpace}" var="vo" isChangeTRColor="true" showHeader="true" showPager="true" className="sort ellipsis" htmlId="sss" width="100%">
		<v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id="id" value="${vo.docStorageSpace.id}" />
		</v3x:column>
		<v3x:column width="30%" label="doc.space.username"  value="${vo.userName}" onClick="doOneClick('${vo.docStorageSpace.id}')" onDblClick="doTwoClick('${vo.docStorageSpace.id}')" type="string" className="cursor-hand sort"></v3x:column>
		
        <c:if test="${v3x:hasPlugin('doc')}">
        <v3x:column width="20%" label="doc.space.doc.space"  value="${vo.docdesc}" onClick="doOneClick('${vo.docStorageSpace.id}')" onDblClick="doTwoClick('${vo.docStorageSpace.id}')" type="string" className="cursor-hand sort"></v3x:column>
        </c:if>
        
        <c:if test="${v3x:hasPlugin('blog') && v3x:isEnableSwitch('blog_enable')}">
        <v3x:column width="20%" label="doc.space.blog.space" alt="${vo.blogdesc}" value="${vo.blogdesc}" onClick="doOneClick('${vo.docStorageSpace.id}')" onDblClick="doTwoClick('${vo.docStorageSpace.id}')" type="string" className="cursor-hand sort"></v3x:column>
        </c:if>
        
        <c:if test="${v3x:hasPlugin('webmail')}">
		<v3x:column width="20%" label="doc.space.mail.space"  value="${vo.maildesc}" onClick="doOneClick('${vo.docStorageSpace.id}')" onDblClick="doTwoClick('${vo.docStorageSpace.id}')" type="string" className="cursor-hand sort"></v3x:column>	
        </c:if>
	</v3x:table>
	</form>
<script type="text/javascript">
showDetailPageBaseInfo("bottom", "<fmt:message key='menu.run.base.setup.personspace' bundle="${v3xMainI18N}"/>", [3,1], pageQueryMap.get('count'), _("DocLang.detail_info_7004"));	
</script>
</body>
</html>