<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(1204);
</script>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	<frameset rows="35%,*" id='sx' name="sx" cols="*" framespacing="3" frameborder="no" border="0">
		<frameset rows="30,*" framespacing="0" frameborder="no" border="0">
	    	<frame frameborder="no" src="${hrRecordURL}?method=initRecordManagerToolBar&type=${recordType}&recordDept=${recordDept}" noresize="noresize" name="toolbarFrame" id="toolbarFrame" scrolling="no" />
	    	<frame frameborder="no" src="${hrAppURL}?method=initRecordType&key=${recordType}&recordDept=${recordDept}" name="listFrame" scrolling="no" id="listFrame" />
	    </frameset>
	    <frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</frameset>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>