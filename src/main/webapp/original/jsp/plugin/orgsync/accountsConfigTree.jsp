<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="header.jsp"%>
<script>
 function showAccountInfo(accountId){
 	parent.listAndDetailFrame.listFrame.location.href = "${urlNCSynchron}?method=showAccountDeptsInfo&id="+accountId;
 	parent.listAndDetailFrame.detailFrame.location.href = "<c:url value="/common/detail.jsp" />";
 }
 function showAccountsInfo(){
  	parent.listAndDetailFrame.listFrame.location.href = "${urlNCSynchron}?method=listConfig";
 	parent.listAndDetailFrame.detailFrame.location.href = "<c:url value="/common/detail.jsp" />";
 }
</script>
</head>
<body class="border-left"style="padding:8px;overflow:auto;">
<script type="text/javascript">
var root = new WebFXTree("root", "<fmt:message key='menu.group.organ.setting.label' bundle='${v3xMainI18N}'/>","javascript:showAccountInfo('${account.v3xOrgAccount.id}');");
	root.setBehavior('classic');
	root.icon = "<c:url value='/common/images/left/icon/5101.gif'/>";
	root.openIcon = "<c:url value='/common/images/left/icon/5101.gif'/>";

	<c:forEach items="${accountlist}" var="account">
		<c:choose>
		<c:when test="${account.v3xOrgAccount.superior==null || account.v3xOrgAccount.superior==-1}">
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem('${account.v3xOrgAccount.id}','${v3x:escapeJavascript(account.v3xOrgAccount.name)}',"javascript:showAccountsInfo('${account.v3xOrgAccount.id}');", "return false");
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/1201.gif'/>";
			account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/1201.gif'/>";
		</c:when>
		<c:otherwise>
		    <c:choose>
		    <c:when test="${accoutMap[account.v3xOrgAccount.id].ORGNAME!=null&&accoutMap[account.v3xOrgAccount.id].ORGNAME!=''}">
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem('${account.v3xOrgAccount.id}','${v3x:escapeJavascript(account.v3xOrgAccount.name)}(${v3x:escapeJavascript(accoutMap[account.v3xOrgAccount.id].ORGNAME)})',"javascript:showAccountInfo('${account.v3xOrgAccount.id}');", "return false");
				account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/5104.gif'/>";
				account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/5104.gif'/>";
			</c:when>
			<c:otherwise>
			var account${fn:replace(account.v3xOrgAccount.id,'-','_')} = new WebFXTreeItem('${account.v3xOrgAccount.id}','${v3x:escapeJavascript(account.v3xOrgAccount.name)}',"javascript:showAccountInfo('${account.v3xOrgAccount.id}');", "return false");
				account${fn:replace(account.v3xOrgAccount.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/5104.gif'/>";
				account${fn:replace(account.v3xOrgAccount.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/5104.gif'/>";
			</c:otherwise>
			</c:choose>
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
	try{
		account${fn:replace(groupAccountId,'-','_')}.expand();
	}catch(e){
		//alert(e.message);
	}
</script>
</body>
</html>