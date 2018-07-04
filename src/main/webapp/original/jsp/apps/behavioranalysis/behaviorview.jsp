<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>${wfParam.dptType == 3 ? '个人行为绩效' : '组织行为绩效'}</title>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/behavioranalysis/css/bha-index.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/behavioranalysis/css/common.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/behavioranalysis/css/index.css${ctp:resSuffix()}"/>
	<script type="text/javascript">
		var orgType = "${wfParam.orgType}";
		var _currentUserId = "${CurrentUser.id}";
	</script>
</head>
<body style="overflow-y:hidden;background: #f9f9f9;">
<div class="showMask"></div>
<div class="header ">
	<!-- 条件区 -->
	<%@include file="/WEB-INF/jsp/apps/behavioranalysis/bha/condition.jsp"%>
</div>
<div class="nodata hidden">
	<div class="have_a_rest_area"><span class="msg" style="color: #999999"></span></div>
</div>
<div class="behavior_middle">
	<div class="contain hidden">
		<!-- 积分排行 -->
		<%@include file="/WEB-INF/jsp/apps/behavioranalysis/bha/scoreRank.jsp"%>
		<!-- 指标显示-->
		<div class="behavior_Date" id="behavior_Date"></div>
	</div>
</div>
<%@include file="/WEB-INF/jsp/apps/behavioranalysis/IndexTable.jsp" %>
<script type="text/javascript" src="${path}/apps_res/behavioranalysis/js/seeyon.ui.table-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/behavioranalysis/js/bha-common.js${ctp:resSuffix()}"></script>
<!--[if lt IE 9]>
	<script type="text/javascript" src="${path}/common/respond/respond.min.js${ctp:resSuffix()}"></script>
<![endif]-->
</body>
</html>