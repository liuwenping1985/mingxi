<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="header.jsp" %>
</head>
<%-- xiangfan 修改 2012-04-14 会议室登记 不需要左侧导航 start --%>
<frameset cols="0%,*" framespacing="0" frameborder="no" border="0" scrolling="no">
<frame  frameborder="no" src="" name="treeFrame" scrolling="yes" id="treeFrame"/>
<%-- xiangfan 修改 2012-04-14 会议室登记 不需要左侧导航 end --%>
	<frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  <frame frameborder="no" src="${mrUrl }?method=listAdd" name="listFrame" scrolling="auto" id="listFrame" />
	  <frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>

 