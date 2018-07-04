<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/doc/docHeaderOnPigeonhole.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="doc.menu.history.label"/>:${param.docResName}</title>
</head>
<body  scroll='no' onkeydown="listenerKeyESC()" >
<IFRAME name="versionsFrame" id="versionsFrame" frameborder="0" width="100%" height="100%" 
	src="${detailURL}?method=listAllDocVersions&docResId=${param.docResId}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&isBorrowOrShare=${param.isBorrowOrShare}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&entranceType=${param.entranceType}"></IFRAME>
</body>
<script>
	if(v3x.isMSIE9 || v3x.isMSIE8){
		var html_h = parseInt($('html').css('height'));
		var iframe = $('#versionsFrame');
		var iframe_h = parseInt(iframe.css('height',html_h+'px'));
		setTimeout(function(){
			var bDiv = $(document.getElementById('versionsFrame').contentWindow.document).find('#bDivlistTable');
			var hDiv_h = parseInt($(document.getElementById('versionsFrame').contentWindow.document).find('#hDivlistTable').css('height'));
			var topDiv_h = parseInt($(document.getElementById('versionsFrame')).find('.top_div_row2').css('height'));
			$(bDiv).css('height',iframe_h-hDiv_h-topDiv_h+'px');
		},300);
	}
</script>
</html>