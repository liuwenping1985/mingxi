<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" charset="UTF-8" src="/seeyon/common/js/V3X.js"></script>
	<link rel="stylesheet" type="text/css" href="/seeyon/common/css/default.css">
	<title>A8 Exception</title>
</head>
<body scroll="auto">
	<div style="text-align: center;margin-top: 30px;">
		<img src="${path }/skin/default/images/have_a_rest.png" align="absmiddle">
		<div style="font-size: 16px;margin-top: 10px;">
			${ctp:i18n('project.message.exception.projectNotExist')}<br/>
			<a href="${path }/projectandtask.do?method=projectAndTaskIndex&pageType=project">${ctp:i18n('project.label.backToIndex')}</a>
		</div>
	</div>
</body>
</html>