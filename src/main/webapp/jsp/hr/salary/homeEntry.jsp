<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(null, getA8Top().findMenuName(12), getA8Top().findMenuItemName(1203));
</script>
</head>
<frameset rows="*" framespacing="3" frameborder="no" border="0" scrolling="no">
	<frameset rows="35%,*" id="sx" framespacing="3" frameborder="no" border="0" scrolling="no">
        <frame  frameborder="no" src="${urlHrSalary}?method=salaryInfo" name="listFrame" scrolling="no" id="listFrame" />
		<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</frameset>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>

</html>