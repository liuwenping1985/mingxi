<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="/seeyon/common/js/v3x-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/main/common/js/skinChange.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/main/common/js/frame-min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/main/frames/cipPageLayout/frount_common.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/cloud/js/cloudmsg.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${pageRenderResult.customJS}${ctp:resSuffix()}"></script>
<html style="height: 100%">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>首页</title>
</head>
<body style="overflow: hidden;height: 100%">
<iframe marginheight="0" marginwidth="0" height="100%" style="height: 100%;" src="${url}" name="dataIFrame0" scroll="no" id="dataIFrame0" width="100%" frameborder="0"></iframe>
</body>
</html>