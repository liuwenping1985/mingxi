<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>                                  
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/attendance/js/lbsListMore.js${ctp:resSuffix()}"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Insert title here</title>
</head>
<body>
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<div class="layout_north" layout="height:30,sprit:false,border:false">
			<div id="lbsToolBar"></div>
		</div>
		<div class="layout_center" id="center" layout="border:false" style="overflow-y: auto">
			<table class="flexme3" style="display: none" id="listStatistic"></table>
		</div>
		<form id="execlToExport" action="${path}/attendanceLbsController.do?method=execlToExport">
			<input id="searchCondition" name="searchCondition" type="hidden" />
		</form>
	</div>
</body>
</html>