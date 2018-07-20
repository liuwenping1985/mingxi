<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="edocHeader.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

</head>
<body scroll="no" >
this a test page
<c:forEach var="model" items="${list}"> 
${model.subject}----<a href="javascript:void(0)" onclick="openEdocByStatus('${model.affairId}','${model.state}')">${model.subject}</a>
&nbsp;&nbsp;截止日期：${model.deadLineDate } &nbsp;&nbsp; 显示时间 ${model.deadLineDisplayDate }
 &nbsp;&nbsp; ${model.edocUnit }
<br>
</c:forEach>

</body>
</html>