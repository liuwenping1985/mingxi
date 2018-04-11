<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="headerbyopen.jsp"%>
<frameset rows="8%,*" frameborder="0" border="0" framespacing="0">
    <frame name="top" src="<c:url value='/workTimeSetController.do?method=toViewbycalendarTop'/>" noresize="noresize"> 
    <frame name="main" src="<c:url value='/workTimeSetController.do?method=viewByCalendar'/>">
 </frameset> 
</html>