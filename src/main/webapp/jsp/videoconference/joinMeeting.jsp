<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="head.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	function test(){
		  document.forms[0].submit();
	}
</script>
</head>
<body onload="test()">
<%if(request.getAttribute("dt")!=null){%>
<form action="<%=request.getAttribute("ciURL")%>?siteId=1&dt=<%=request.getAttribute("dt")%>" method="post" target="_blank">
<%}else{ %>
<form action="<%=request.getAttribute("ciURL")%>?siteId=1" method="post" target="_blank">
<%}%>
<input type="hidden" name="token" value="<%= request.getAttribute("token")%>" id="toks"/>
</form> 
</body>
</html>
