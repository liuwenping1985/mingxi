<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.learn.history.title'/></title>

</head>

<body scroll="no">
<form action="" name="mainForm" id="mainForm" method="post">

		<iframe src="${detailURL}?method=docLearningHistory&docId=${param.docId}&isGroupLib=${param.isGroupLib}" name="docIframe" id="docIframe" frameborder="0"
			height="100%" width="100%" scrolling="yes"></iframe>


</form>
</body>
</html>