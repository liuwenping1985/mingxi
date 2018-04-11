<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.apps.show.ShowConstants.ShowbarListEnum" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title>${ctp:i18n('show.showbarSearchIndex.title') }</title>
	<link rel="stylesheet" href="${path}/apps_res/show/css/base.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/show.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/auto-fix.css${ctp:resSuffix()}">
</head>
<body>
	<!-- 首页header -->
	<%@include file="/WEB-INF/jsp/apps/show/common/showHeader.jsp" %>
	
	<div class="warp">
		<!-- 首页秀吧查询列表 -->
		<div style="text-align: center; clear: both"></div>
		<div id="container" class="searchContainer">
			<!-- 最新 -->
			<div class="Tabcontent w1208" style="display: block;" data-option="type:'<%=ShowbarListEnum.Newest.ordinal()%>'">
				<div class="doublePartOut clearfix"></div>
			</div>
		</div>
		<!-- 秀吧搜索列表[End] -->
	</div>
	
	<%-- 没有搜到的情况显示 --%>
	<div class="error404" style="display: none;">
	   <p><img width="136" height="132" /></p>
	   <p>${ctp:i18n("show.common.search.notfind") }</p>
	</div>
	
	<%--  首页主题/我参与/我创建的/搜索结果 模板 --%>
	<%@include file="/WEB-INF/jsp/apps/show/common/showTpl.jsp" %>
	<%-- 平台的js --%>
	<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%-- 秀公用的js --%>
	<%@include file="/WEB-INF/jsp/apps/show/common/showFooter.jsp" %>
	<!-- 搜索秀吧 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/showsearch/jquery.textsearch-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showsearch/showbar-search-debug.js${ctp:resSuffix()}"></script>
</body>
</html>