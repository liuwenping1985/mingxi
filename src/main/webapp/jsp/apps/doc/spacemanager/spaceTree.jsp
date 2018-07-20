<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../docHeader.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
</head>
<script type="text/javascript">	
<!--	
	//点击部门树的部门节点,显示部门信息页面
	function listSpaces(id){
		parent.main.location.href = "${spaceURL}?method=spaceList&deptId="+id;
	}	
//-->
</script>
<body onresize="resizeBody(100,'treeFrameset','min','left')">
<div class="scrollList border_all">
<script type="text/javascript">
<!--
	var root = new WebFXTree("0", "${account.name}", "javascript:listSpaces('0')");
	root.setBehavior('classic');
	root.icon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";
	root.openIcon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";	
		
	<c:forEach items="${deptlist}" var="t">
		<%-- nitrox:varType="com.seeyon.v3x.organization.webmodel.WebV3xOrgDepartment" --%>
		var aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgDepartment.id}","${v3x:escapeJavascript(t.v3xOrgDepartment.name)}","javascript:listSpaces('${t.v3xOrgDepartment.id}')");
	</c:forEach>
	
		<c:forEach items="${deptlist}" var="t">
		<c:choose>
			<c:when test="${t.parentId==null}">
				root.add(aa${fn:replace(t.v3xOrgDepartment.id,'-','_')});
			</c:when>
			<c:otherwise>
				aa${fn:replace(t.parentId,'-','_')}.add(aa${fn:replace(t.v3xOrgDepartment.id,'-','_')});
			</c:otherwise>
		</c:choose>
	
	</c:forEach>
	document.write(root);
//-->
</script>
</div>


</body>
</html>
