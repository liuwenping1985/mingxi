<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	function test(){
		<c:choose>
			<c:when test="${success}">
			  document.forms[0].submit();
			</c:when>
			<c:otherwise>
				alert("<fmt:message key='message.meeting.joinerror' bundle='${wim}'/>");
				window.close();
			</c:otherwise>
		</c:choose>
	}
</script>
</head>
<body onload=test()>
<form action="<%=request.getAttribute("ciURL")%>?siteId=1&dt=GMT" method="post">
<input type="hidden" name="token" value="<%= request.getAttribute("token")%>" id="toks"/>
<input type="hidden" name="backUrl" value="http://<%=request.getLocalAddr()%>/seeyon/closeIE7.htm"/>
</form> 
</body>
</html>
