<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE11"/>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<script type="text/javascript">
	var openFromUC = "${param.openFrom}";
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${meetingTitle }</title>
<style type="text/css">
   html,body{
       width: 100%;
       height: 100%;
       overflow: hidden;
   }
</style>
</head>
<body>
	<iframe src="meetingSummary.do?method=mydetail&recordId=${param.recordId}&mtId=${param.mtId}&openType=${param.openType }&hiddenAuditOpinion=${param.hiddenAuditOpinion }&listType=${param.listType }&proxy=${param.proxy}&proxyId=${param.proxyId}&affairId=${affairId}" name="mtFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
</body>
</html>