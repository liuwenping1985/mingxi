<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('performanceReport.authorize.index.title')}</title>
<script type="text/javascript">
$(document).ready(function() { 
	$("#authFrame").attr("src",url_performanceReport_performanceTree+"&source=1");
	$("#rightFrame").attr("src",url_performanceReport_centerGrid+"&reportId=${defualtReportId}&parentId=${defualtParentId}");
});
</script>
</head>
<body class="h100b over_hidden page_color">
	<div id="index_layout" class="comp page_color" comp="type:'layout'">
    	<div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_performanceReport'"></div>
        <div class="layout_west line_col over_hidden" layout="border:false">
        	<iframe id="authFrame" src="" width="100%" height="100%" frameborder="0"></iframe>
        </div>
        <div class="layout_center page_color over_hidden" layout="border:false">
	       <iframe id="rightFrame" src="" width="100%" height="100%" frameborder="0"></iframe>
        </div> 
    </div> 
</body>
</html>

