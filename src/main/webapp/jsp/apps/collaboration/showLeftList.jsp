<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function checkAndOpen(affairId,link,title,openType) {
	parent.checkAndOpen(affairId,link,title,openType);
}
function openLink(link) {
	try{
		window.parent.parent.location.href("/seeyon"+link);
	}catch(e){//非IE跳转
		window.parent.parent.location.href="/seeyon"+link;
	}
}
$(function(){
	var templeteObj=window.parent.$("#leftList");//iframe对象
	var leftListDisplayDivObj=$("#leftListDisplayDiv");
	templeteObj.height(parent.iframe_h);
	templeteObj.width(parent.iframe_w);
	leftListDisplayDivObj.height(parent.iframe_h);
	leftListDisplayDivObj.width(parent.iframe_w);
	$.portalChannel(".channel_content",parent.iframe_w);
})
</script>
</head>
<body class="overflow_hidden">
<div id="leftListDisplayDiv" class="channel_content font_size12">
<%@ include file="/WEB-INF/jsp/apps/collaboration/displayPendingList.jsp" %>
</div>
</body>
</html>