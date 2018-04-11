<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${url_ajax_reportingManager}"></script>
<title><fmt:message key="meeting.title.performance" bundle="${v3xCommonI18N}" /></title>
</head>
<body class="h100b over_hidden page_color">
	<div id='layout' class="comp page_color" comp="type:'layout'">
        <%-- <div class="layout_west line_col over_hidden">
        	<iframe src="${path}/performanceReport/performanceReport.do?method=performanceTree&source=2" width="100%" height="100%" frameborder="0"></iframe>
        </div> --%>
        <div class="layout_center page_color over_hidden" layout="border:false">
	       <iframe src="${path}/performanceReport/performanceQuery.do?method=queryMain&from=meeting&reportId=${reportId}" width="100%" id="rightFrame" height="100%" frameborder="0"></iframe>
        </div> 
    </div> 
</body>
</html>

