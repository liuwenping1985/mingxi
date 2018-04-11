<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(null, getA8Top().findMenuName(8), getA8Top().findMenuItemName(803));
	//getA8Top().showLocation(803);
</script>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	<frameset rows="35%,*" id='sx' name="sx" cols="*" framespacing="3" frameborder="no" border="0">
		<frameset rows="40,*" framespacing="0" frameborder="no" border="0">
			<frame src="${hrRecordURL}?method=initToolBar" name="toolbarFrame" id="toolbarFrame" scrolling="no" frameborder="no" noresize="noresize" />
		
			<frame src="${hrRecordURL}?method=ownRecordList" name="listFrame" id="listFrame" frameborder="no" scrolling="no"/>
		</frameset>
		<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</frameset>	
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>