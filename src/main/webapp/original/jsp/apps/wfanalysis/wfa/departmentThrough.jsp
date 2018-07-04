<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path }/apps_res/wfanalysis/css/common.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path }/apps_res/wfanalysis/css/index.css${ctp:resSuffix()}"/>
	<style type="text/css">
	#crumb{border-bottom: solid #E0E0E0 1px; padding: 8px 0px 2px 0px;margin: 10px 0px 10px 25px;font-size: 14px;color:#666666;}
	#crumb .current{border-bottom: #3da9f7 solid 2px;padding:0px 20px 2px 20px;font-size: 14px;color:#3da9f7;}
	#crumb a{padding:0px 20px 2px 20px;font-size: 14px;color: #666666;}
	#crumb .current_posi{border-bottom: #FaFaFa solid 2px;padding:0px 0px 2px 0px;font-size: 14px;color:#666666;}
	#tableData{margin-bottom: 20px;}
	.span1{width:120px;}
	</style>
</head>
<body style="overflow-y:auto;background:#fafafa;">
	<div class="marLeftRight" id="crumb"></div>
	<%--内容部分 --%>
	<%@include file="/WEB-INF/jsp/apps/wfanalysis/wfa/departmentContent.jsp"%>
	<form id="throughFrom" action="#" method="post">
		<input id="crumbJson" name="crumbJson" value='${crumbJson}' type="hidden">
		<%--隐藏域属性：与非弹出窗口保持一致 --%>
		<input type="hidden" id="templateIds" name="templateIds" value="${templateIds }" >
		<input type="hidden" id="rptYear" name="rptYear" value="${rptYear }" >
		<input type="hidden" id="rptMonth" name="rptMonth" value="${rptMonth }" >
		<input type="hidden" id="crumbName" name="crumbName">
		<input type="hidden" id="searchRange" name="searchRange">
		<input type="hidden" id="activityIdOption" name="activityIdOption" value="${ctp:toHTMLWithoutSpaceEscapeQuote(activityIdOption) }"/>
		<input type="hidden" id="permissionOption" name="permissionOption" value="${ctp:toHTMLWithoutSpaceEscapeQuote(permissionOption)}"/>
		<input type="hidden" id="templateRange" name="templateRange" value="${searchRange}">
		<input type="hidden" id="accountId" name="accountId" value="${accountId}">
	</form>
	<script type="text/javascript" src="${path }/apps_res/wfanalysis/js/wfa-through-common-debug.js${ctp:resSuffix()}"></script>
</body>
</html>