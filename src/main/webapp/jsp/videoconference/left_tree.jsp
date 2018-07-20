<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="head.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body style="padding:8px;">
<fmt:message key="org.entity.disabled" var="orgDisabled"/>
<fmt:message key="org.entity.deleted" var="orgDeleted"/>
<script type="text/javascript">
 //点击树节点编辑单位信息
 function showChildDeptInfo(accountId){
 	parent.detailFrame.location.href = videoconfURL + "?method=showChildDeptInfo&id="+accountId;
 }
  function showAccountInfo(){
 	parent.detailFrame.location.href = videoconfURL + "?method=showAccountState";
 }
	<%--改变显示模式--%>
	function change(){
	}


var root = new WebFXTree("root", "<fmt:message key='menu.group.organ.setting.label' bundle='${v3xMainI18N}'/>", "javascript:change();");
	root.setBehavior('classic');
	root.icon = "<c:url value='/common/images/left/icon/5101.gif'/>";
	root.openIcon = "<c:url value='/common/images/left/icon/5101.gif'/>";
	
	<c:forEach items="${accountlist}" var="account">
	<c:if test="${account.v3xOrgAccount.status == 2}"><c:set var="status" value="(${orgDisabled})"/></c:if>
    <c:if test="${account.v3xOrgAccount.status == 3}"><c:set var="status" value="(${orgDeleted})"/></c:if>
		<c:choose>
		<c:when test="${account.v3xOrgAccount.isRoot==true}">
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem('${account.v3xOrgAccount.id}','${v3x:escapeJavascript(account.v3xOrgAccount.name)}${v3x:escapeJavascript(status)}',"javascript:showAccountInfo();", "javascript:showAccountInfo()");
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/1201.gif'/>";
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/1201.gif'/>";
		</c:when>
		<c:when test="${account.v3xOrgAccount.superior==null || account.v3xOrgAccount.superior==-1}">
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem('${account.v3xOrgAccount.id}','${v3x:escapeJavascript(account.v3xOrgAccount.name)}${v3x:escapeJavascript(status)}',"javascript:showChildDeptInfo('${account.v3xOrgAccount.id}');", "javascript:showChildDeptInfo('${account.v3xOrgAccount.id}')");
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/1201.gif'/>";
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/1201.gif'/>";
		</c:when>
		<c:otherwise>
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem('${account.v3xOrgAccount.id}','${v3x:escapeJavascript(account.v3xOrgAccount.name)}',"javascript:showChildDeptInfo('${account.v3xOrgAccount.id}');", "javascript:showChildDeptInfo('${account.v3xOrgAccount.id}')");
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
	//展开集团树下的单位
	<c:if test="${groupAccountId != null}">
	try{
		account${fn:replace(groupAccountId,'-','_')}.expand();
	}catch(e){
		//alert(e.message);
	}
	</c:if>
	root.select();
</script>
</body>
</html>