<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="ldap.ou.click" bundle="${ldaplocale}"/></title>
<base  target=_self>
</head>
<script type="text/javascript">
	var rValue=null;
function showRdn(element) {
rValue=element;
}

function OK() {
		return rValue;
}

</script>
<body style="overflow-x:hidden;overflow-y:auto">
<table class="popupTitleRight" style="position:absolute;left:0;top:0;z-index:1" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr height="20">
		<td height="20" class="PopupTitle"><fmt:message key="ldap.ou.click" bundle="${ldaplocale}"/></td>
	</tr>
	<tr>
	<td  style="padding:3px" height="250">
	<div class="scrollList">
	<script type="text/javascript">

try{
	var root = new WebFXTree("root", "${rootDN}", "javascript:showRdn('${rootDN}')");
	root.setBehavior('classic');
	root.icon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";
	root.openIcon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";	
	<c:forEach items="${userList}" var="userList">
	    var ldap${fn:replace(userList.id, " ", "_")}=new WebFXTreeItem('${userList.id}','${v3x:toHTML(userList.name)}',"javascript:showRdn('${v3x:toHTML(userList.dnName)}')","","","","","${v3x:toHTML(userList.name)}");
	</c:forEach>
	<c:forEach items="${userList}" var="userList">
	<c:choose>
		<c:when test="${userList.parentId==null}">
			root.add(ldap${fn:replace(userList.id, " ", "_")});
		</c:when>
		<c:otherwise>
				ldap${fn:replace(userList.parentId, " ","_")}.add(ldap${fn:replace(userList.id," ", "_")});
		</c:otherwise>
	</c:choose>
	</c:forEach>
	document.write(root);
}
catch(e){
	alert(e.message);
}
</script>
	</div>
	</td>
	</tr>
	<tr>
<td style="padding: 0px;" >
</td>
</tr>
	</table>

</body>
</html>
