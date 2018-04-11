<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
    $(document).ready(function(){
	　　function test(){
			document.forms[0].submit(); 
		} 
		//test();
		$("#abc")[0].click();
	}); 

</script>
</head>
<body>

<%if(request.getAttribute("dt")!=null){%>
<a id="abc" href="<%=request.getAttribute("ciURL")%>?siteId=1&dt=<%=request.getAttribute("dt")%>" target="_blank">
  <p></p>  
</a>
<%}else{ %>
<a id="abc" href="<%=request.getAttribute("ciURL")%>" target="_blank">
  <p></p>  
</a>
<%}%>


<%if(request.getAttribute("dt")!=null){%>
<form action="<%=request.getAttribute("ciURL")%>?siteId=1&dt=<%=request.getAttribute("dt")%>" method="post" target="_blank">
<%}else{ %>
<form action="<%=request.getAttribute("ciURL")%>" method="post" target="_blank">
<%}%>
<%if(request.getAttribute("token")!=null){%>
<input type="hidden" name="token" value="<%= request.getAttribute("token")%>" id="toks"/>
<%} %>
</form> 
</body>
</html>
