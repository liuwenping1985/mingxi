<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
</head>
<script type="text/javascript">
	//点击部门树的单位节点,显示单位信息页面
	function showAccount(accountid){
		//TODO 
		//parent.detailFrame.location.href = addressbookURL+"?method=viewAccount&id="+accountid+"&from=dept";
	    parent.detailFrame.location.href = "${detailURL}?method=listAccountMembersAdmin";
	}
	
	//点击部门树的部门节点,显示部门信息页面
		function showDepartment(deptid){
		//TODO
		//parent.detailFrame.location.href = addressbookURL+"?method=viewDept&id="+deptid+"&from=dept";
		parent.detailFrame.location.href = "${detailURL}?method=listDeptMembersAdmin&pId="+deptid;
	}	
</script>
<body onresize="resizeBody(100,'sx2','min','left')" class="border_all padding_l_5">

<div class="scrollList"><script type="text/javascript">

	var root = new WebFXTree("${account.id}", "${account.name}", "javascript:showAccount('${account.id}')");
	root.setBehavior('classic');
	root.icon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";
	root.openIcon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";	
		
	<c:forEach items="${deptlist }" var="t">
		<%-- nitrox:varType="com.seeyon.v3x.organization.webmodel.WebV3xOrgDepartment" --%>
		var aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgDepartment.id}","${v3x:escapeJavascript(t.v3xOrgDepartment.name)}","javascript:showDepartment('${t.v3xOrgDepartment.id}')");
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
	
		<%-- nitrox:varType="com.seeyon.v3x.organization.webmodel.WebV3xOrgDepartment" --%>
	</c:forEach>
	document.write(root);


</script></div>


</body>
</html>