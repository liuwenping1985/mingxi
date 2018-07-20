<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<script type="text/javascript" src="<c:url value='/apps_res/addressbook/js/public.js${v3x:resSuffix()}'/>"></script>
</head>
<body scroll="no">
<input type="hidden" name="tId" id="tId" value="-1">
<div class="scrollList border_r" style="width:99%">
<script type="text/javascript">
	var root = new WebFXTree("-1", "<fmt:message key='addressbook.team.personal.label'  bundle='${v3xAddressBookI18N}'/>", "");
	root.setBehavior('classic');
	root.icon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";
	root.openIcon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";	
		
	<c:forEach items="${teamlist }" var="t">
		var aa${fn:replace(t.v3xOrgTeam.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgTeam.id}","${v3x:escapeJavascript(t.v3xOrgTeam.name)}","javascript:showOwnTeam('${t.v3xOrgTeam.id}')");
		root.add(aa${fn:replace(t.v3xOrgTeam.id,'-','_')});
	</c:forEach>
	
	document.write(root);
	root.select();

function afterTeamModified(teamId, newTeamName) {
	try {
		var currentItem = eval('aa' + teamId.replace('-', '_'));
		currentItem.setText(newTeamName);
		showOwnTeam(teamId);
	} catch (e) {}
}
</script>
</div>
</body>
</html>