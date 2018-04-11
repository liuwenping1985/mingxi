<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp" %>
<script>
 <c:choose>
	   <c:when test="${userType =='accountAdmin'}">
		    //var menuKey="1606";
		     getA8Top().showLocation(1606);
	   </c:when>
	   <c:otherwise>
			var menuKey="2401";
			getA8Top().showLocation(menuKey);
	  </c:otherwise>
  </c:choose>
</script>
</head>
<frameset rows="100%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	 <c:choose>
	   <c:when test="${userType =='accountAdmin'}">
		   <frame frameborder="no" src="${log}?method=accountLogView&category=${param['category']}" name="listFrame" id="listFrame" scrolling="no"/>
	   </c:when>
	   <c:otherwise>
         <frame frameborder="no" src="${log}?method=list&category=${param['category']}" name="listFrame" id="listFrame" scrolling="no"/>
	  </c:otherwise>
  </c:choose>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>