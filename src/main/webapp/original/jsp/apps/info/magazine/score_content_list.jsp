<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>发布评分标准</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoScoreManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine/score_content_list.js${ctp:resSuffix()}"></script>
</head>
<body>
	<div id='layout'>
		<div class="layout_center over_hidden" id="center">
			<table class="flexme3" id="scoreTypeList"></table>
		</div>
	</div>
	<iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>