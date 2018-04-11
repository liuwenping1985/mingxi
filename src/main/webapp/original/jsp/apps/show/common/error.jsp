<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit">
	<title>${ctp:i18n('show.showIndex.title') }</title>
	<link rel="stylesheet" href="${path}/apps_res/show/css/base.css${ctp:resSuffix()}">
	<!-- 秀圈发布 -->
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/show/webuploader/uploader.css${ctp:resSuffix()}"/>
</head>
<body>
	<div class="error404">
	    <p><img src="${path}/apps_res/show/images/common/404.png" width="136" height="132" /></p>
	    <p>${ctp:i18n('show.common.error.tips')}：${msg}</p>
	</div>
</body>
</html>