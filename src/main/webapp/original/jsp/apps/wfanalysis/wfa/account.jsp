<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="renderer" content="webkit">
        <%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
		<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
        <title>${ctp:i18n("wfanalysis.unit.title") }</title>
        <%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
        <link rel="stylesheet" type="text/css" href="${path }/apps_res/wfanalysis/css/common.css${ctp:resSuffix()}"/>
        <link rel="stylesheet" type="text/css" href="${path }/apps_res/wfanalysis/css/index.css${ctp:resSuffix()}"/>
     	<style type="text/css">
     		.span0{width: 150px;}
     	</style>
    </head>
<body style="background:#e9eaec;" >
<div class="containe overflow">
	<div class="leftBar left">
		<%-- 左侧绩效菜单栏 --%>
		<%@include file="/WEB-INF/jsp/apps/wfanalysis/common/menu.jsp" %>
	</div>
	<div class="rightBar left" >
		<%-- 顶部条件区 --%>
		<%@include file="/WEB-INF/jsp/apps/wfanalysis/common/condition.jsp" %>
		<%-- 流程效率数据展示区 --%>
		<%@include file="/WEB-INF/jsp/apps/wfanalysis/wfa/accountContent.jsp" %>
	</div>
</div>
<script type="text/javascript" src="${path}/apps_res/wfanalysis/js/jquery.htdate-debug.js${ctp:resSuffix()}"></script>
</body>
</html>