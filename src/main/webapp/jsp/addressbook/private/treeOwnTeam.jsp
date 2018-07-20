<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<script type="text/javascript" src="<c:url value='/apps_res/addressbook/js/private.js${v3x:resSuffix()}'/>"></script>
</head>
<body scroll="no">
<input type="hidden" name="tId" id="tId" value="-1">
<div class="scrollList border_r" style="width:99%"><script type="text/javascript">
	var root = new WebFXTree("-1","<fmt:message key='addressbook.zu.label'  bundle='${v3xAddressBookI18N}'/>" , "javascript:setTeamId(-1)");
	root.setBehavior('classic');
	root.icon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";
	root.openIcon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";	
		
	<c:forEach items="${teamlist }" var="t">
		var aa${fn:replace(t.id,'-','_')}= new WebFXTreeItem("${t.id}","${v3x:escapeJavascript(t.name)}","javascript:showOwnTeam('${t.id}')");
		root.add(aa${fn:replace(t.id,'-','_')});
	</c:forEach>
	
	document.write(root);
	document.close();
	root.select();
</script>
</div>
</body>
</html>
