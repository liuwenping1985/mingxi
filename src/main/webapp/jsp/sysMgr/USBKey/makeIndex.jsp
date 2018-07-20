<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp"%>
<script type="text/javascript">
	<%--是否显示detailInfo标记，用于连续制作--%>
	var showDetailInfo = true;
</script>
</head>
<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
  <frame frameborder="no" src="${identificationURL}?method=showUSBKeyList" name="listFrame" scrolling="no" id="listFrame" />
  <frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>