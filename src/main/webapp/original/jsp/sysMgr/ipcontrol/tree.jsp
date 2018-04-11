<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<script type="text/javascript">
window.onload = function(){
	parent.menuFrame.document.getElementById('add').disabled = true;
	parent.menuFrame.document.getElementById('mod').disabled = true;
	parent.menuFrame.myBar.disabled('add');
	parent.menuFrame.myBar.disabled('mod');
	//parent.menuFrame.document.getElementById('del').disabled = true;
}
</script>
</head>
<body>
<fmt:message key="org.entity.disabled" var="orgDisabled"/>
<fmt:message key="org.entity.deleted" var="orgDeleted"/>
<div class="scrollList border-padding">
<script type="text/javascript">
	
function listIpcontrol(accountId){
	if(accountId != null){
		parent.menuFrame.document.getElementById('add').disabled = false;
		parent.menuFrame.document.getElementById('mod').disabled = false;
		parent.menuFrame.myBar.enabled('add');
		parent.menuFrame.myBar.enabled('mod');
		//parent.menuFrame.document.getElementById('del').disabled = false;
		parent.listFrame.location.href = "${ipcontrolURL}?method=listFrame&accountId="+accountId;
	}else{
		parent.menuFrame.document.getElementById('add').disabled = true;
		parent.menuFrame.document.getElementById('mod').disabled = true;
		parent.menuFrame.myBar.disabled('add');
		parent.menuFrame.myBar.disabled('mod');
		//parent.menuFrame.document.getElementById('del').disabled = true;
		parent.listFrame.location.href = "${ipcontrolURL}?method=listFrame&accountId=";
	}
}

var root = new WebFXTree("", "<fmt:message key='menu.organization.organ' bundle='${v3xMainI18N}'/>", "javascript:listIpcontrol();");
	root.setBehavior('classic');
	root.icon = "<c:url value='/common/images/left/icon/5101.gif'/>";
	root.openIcon = "<c:url value='/common/images/left/icon/5101.gif'/>";
	
	<c:forEach items="${accountlist}" var="account">
	<c:if test="${account.v3xOrgAccount.status == 2}"><c:set var="status" value="(${orgDisabled})"/></c:if>
    <c:if test="${account.v3xOrgAccount.status == 3}"><c:set var="status" value="(${orgDeleted})"/></c:if>
		<c:choose>
		<c:when test="${account.v3xOrgAccount.superior==null || account.v3xOrgAccount.superior==-1}">
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem("${account.v3xOrgAccount.id}","${v3x:escapeJavascript(account.v3xOrgAccount.name)}${v3x:escapeJavascript(status)}","javascript:listIpcontrol('${account.v3xOrgAccount.id}');", "");
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/1201.gif'/>";
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/1201.gif'/>";
		</c:when>
		<c:otherwise>
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem("${account.v3xOrgAccount.id}","${v3x:escapeJavascript(account.v3xOrgAccount.name)}","javascript:listIpcontrol('${account.v3xOrgAccount.id}');", "");
				account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/5104.gif'/>";
				account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/5104.gif'/>";
		</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:forEach items="${accountlist}" var="a">
	<c:choose>
		<c:when test="${a.v3xOrgAccount.superior==null || a.v3xOrgAccount.superior==-1}">
			root.add(account${fn:replace(a.v3xOrgAccount.id,'-','_')});
		</c:when>
		<c:otherwise>
			try{
				account${fn:replace(a.v3xOrgAccount.superior,'-','_')}.add(account${fn:replace(a.v3xOrgAccount.id,'-','_')});
			}
			catch(e){
				//alert(e.message);
			}
		</c:otherwise>
	</c:choose>
	</c:forEach>
	
	document.write(root);
	webFXTreeHandler.select(root);
	account${fn:replace(groupAccountId,'-','_')}.expand();
	
</script>
</div>
</body>
</html>