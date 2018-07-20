<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>Insert title here</title>
<script type="text/javascript">
if('1'=='${param.spaceType}'){
  var theHtml=toHtml('<fmt:message key="seeyon.top.department.space.label" bundle="${v3xMainI18N}"/>','<fmt:message key="bul.more"/>');
  showCtpLocation("",{html:theHtml});
}
</script>
</head>
<body scroll='no' class="padding5">
<c:choose>
	<c:when test="${isSpaceManager !=false }">
		<iframe src="${bulDataURL}?method=publishListMain&spaceType=${param.spaceType}&bulTypeId=${param.bulTypeId}&spaceId=${param.spaceId}" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	</c:when>
	<c:otherwise>
		<script type="text/javascript">
			alert(v3x.getMessage("bulletin.bulletin_no_pers"));
			//TODO yangwulin 2012-11-28 getA8Top().contentFrame.topFrame.back();
			getA8Top().back();
		</script>
	</c:otherwise>
</c:choose>
</body>
</html>