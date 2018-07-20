<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/m1/js/lbsListMore.js${ctp:resSuffix()}"></script>
<script type="text/javascript"src="${path}/ajax.do?managerName=mLbsRecordManager"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
	<div id='layout' class="comp page_color" comp="type:'layout'">
            <div class="layout_north" layout="height:30,sprit:false,border:false">
                <div id="lbsToolBar">
				</div>
            </div>
            <div class="layout_center" id="center" layout="border:false" style="overflow-y:auto">
            	<table class="flexme3" style="display: none" id="listStatistic"></table>
            </div>
            <form id="execlToExport" action="${path}/m1/lbsRecordController.do?method=execlToExport">
            	<input id="searchCondition" name="searchCondition" type="hidden"/>
            </form>
   </div>
</body>
</html>