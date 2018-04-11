<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(1006);
</script>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
    <frame noresize="noresize" frameborder="0" src="${urlAddressBook}?method=initSpace&addressbookType=${addressbookType}&accountId=${param.accountId}" name="spaceFrame" scrolling="no" id="spaceFrame" />
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>