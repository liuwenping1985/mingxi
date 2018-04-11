<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	showCtpLocation("F12_perTemplate");
</script>
<title>Insert title here</title>
</head>
<frameset rows="100%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
  <frame frameborder="no" src="${urlMyTemplate}?method=initListTemplate&type=${v3x:toHTML(param.type)}" name="listFrame" id="listFrame" scrolling="no"/>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>