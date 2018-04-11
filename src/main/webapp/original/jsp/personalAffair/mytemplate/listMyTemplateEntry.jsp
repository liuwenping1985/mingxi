<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(806);
</script>
<title>Insert title here</title>
</head>
<body style="overflow: hidden" scroll="no" class="padding5">
<div class="page-list-border">
<iframe width="100%" height="100%" frameborder="no" src="${urlMyTemplate}?method=myTemplate&type=${param.type}" id="entryFrame" name="entryFrame" scrolling="no"></iframe>
</div>
</body>
</html>