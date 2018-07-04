<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp"%>
</head>
<body>
    <fmt:message key="org.entity.disabled" var="orgDisabled" />
    <fmt:message key="org.entity.deleted" var="orgDeleted" />
    <div class="scrollList border-padding">
    <script type="text/javascript">
        function listIpcontrol(accountId){
        	if(typeof(accountId) == "undefined"){
        		accountId = "";
        	}
        	if(accountId != null){
        		parent.listFrame.location.href = "${detailURL}?method=agentFrame&accountId="+accountId;
        	}else{
        		parent.listFrame.location.href = "${detailURL}?method=agentFrame&accountId="+accountId;
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