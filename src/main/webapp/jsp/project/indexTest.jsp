<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<v3x:table
        data="${projectSummaryList}"  var="project" showPager="false">
        <c:set var="detail" value="getProject('${project.id}')"></c:set>
	         <v3x:column label="<fmt:message key='project_name'/>" value="${project.projectName}"  onClick="${detail}"
	              className="cursor-hand" maxLength="20" alt="${project.projectName}" symbol="...">
	         </v3x:column>
</v3x:table>
<p>
 <a href="${basicURL}?method=getAllProjectList"><fmt:message key='more_project'/></a>
 <a	href="${basicURL}?method=projectTransfer&transferId=1"><fmt:message key='config_project'/></a>
 </p>
</body>
</html>
