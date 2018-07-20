<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../include/taglib.jsp"%>

<html>
<head>
<title>
	<fmt:message key="oper.view" /><fmt:message key="bul.log" />
</title>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
	
<script type="text/javascript">
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
		
	myBar.add(
		new WebFXMenuButton(
			"refBtn", 
			"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
			"window.location.reload();", 
			"<c:url value='/common/images/toolbar/refresh.gif'/>", 
			"", 
			null
			)
	);
	
	detailBaseUrl='${bulDataURL}?method=detail';
	
</script>
</head>
<body>

<form>
<v3x:table htmlId="listTable" data="list" var="bean">
	<v3x:column width="20%" type="String"
		label="bul.log.recordDate" className="cursor-hand sort">
		<fmt:formatDate value="${bean.recordDate}" pattern="${datePattern}"/>
	</v3x:column>
	<v3x:column width="12%" type="String"
		label="bul.log.userId" className="cursor-hand sort">
		${bean.userName}
	</v3x:column>
	<v3x:column width="12%" type="String"
		label="bul.log.operType" className="cursor-hand sort">
		<fmt:message key="oper.${bean.operType}" /> 
	</v3x:column>
	<v3x:column width="30%" type="String"
		label="bul.log.recordId" className="cursor-hand sort">
		${bean.recordTitle}
	</v3x:column>
	<v3x:column width="14%" type="String"
		label="bul.data.type" className="cursor-hand sort">
		${bean.ext1}
	</v3x:column>
	<v3x:column width="12%" type="String"
		label="bul.log.result" className="cursor-hand sort">
		<fmt:message key="label.${bean.result}" /> 
	</v3x:column>

</v3x:table>
</form>
</body>
</html>
