<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="webmailheader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${title }</title>
</head>
<script>
</script>
<body scroll="no" style="overflow: hidden;">
<div class="page-list-border">
<iframe src="${webmailURL}?method=list&entry=indexEntry&jsp=${jsp}" id="detailIframe" name="detailIframe" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</div>
</body>
</html>