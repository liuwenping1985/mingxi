<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	getA8Top().showLocation(null, getA8Top().findMenuName(7), getA8Top().findMenuItemName(803));
</script>
</head>
<frameset rows="35%,*" id="sx" framespacing="0" frameborder="no" border="0" scrolling="no">
    	<frame noresize="noresize" frameborder="no" src="${hrAppURL}?method=initRecordType&key=${recordType}" name="listFrame" id="listFrame" scrolling="no" />
        <frame src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>