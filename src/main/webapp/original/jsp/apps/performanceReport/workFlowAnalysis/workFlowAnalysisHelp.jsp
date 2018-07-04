<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%-- <%@ include file="../../common/INC/noCache.jsp"%> --%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='common.wfanalysis.help.label'/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<c:choose> 
       <c:when test="${performanceQuery == 1}"> 
			<td height="16" id="policyName" class="PopupTitle">${from}</td>
       </c:when> 
       <c:otherwise> 
			<td height="16" id="policyName" class="PopupTitle"><fmt:message key='${from}' bundle="${v3xMainI18N}"/></td>
       </c:otherwise> 
	</c:choose>
	</tr>
	<tr>
		<td id="div1" align="center" >
			<textarea  style="overflow: auto; height:210px; width:300px" id="content" name="content" rows="11" cols="50" validate="maxLength" inputName="<fmt:message key="common.opinion.label" bundle="${v3xCommonI18N}" />" readonly></textarea>
		</td>
	</tr>
</table>
</body>
<script type="text/javascript">
document.getElementById("content").value = "${description}";
</script>
</html>