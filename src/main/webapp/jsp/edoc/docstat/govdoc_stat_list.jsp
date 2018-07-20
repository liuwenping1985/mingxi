<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatNewManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/govdoc_stat_list.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript">
	var _ctxPath = '${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
	
	var statId = "${v3x:escapeJavascript(param.statId)}";
	var statType = "${v3x:escapeJavascript(param.statType)}";
	var listType = "${v3x:escapeJavascript(param.listType)}";
	var displayType = "${v3x:escapeJavascript(param.displayType)}";
	var displayId = "${v3x:escapeJavascript(param.displayId)}";
	var displayName = "${v3x:escapeJavascript(param.displayName)}";
	var docMark = "${v3x:escapeJavascript(param.docMark)}";	
	var docMark_txt = "${v3x:escapeJavascript(param.docMark_txt)}";	
	var serialNo = "${v3x:escapeJavascript(param.serialNo)}";	
	var serialNo_txt = "${v3x:escapeJavascript(param.serialNo_txt)}";	
	var startTime = "${v3x:escapeJavascript(param.startTime)}";
	var endTime = "${v3x:escapeJavascript(param.endTime)}";
	
</script>
</head>
<body scroll="">
<div id='layout'>

<form id="statConditionForm" name="statConditionForm" method="post">
<input type="hidden" id="statId" name="statId" value="${param.statId }" />
<input type="hidden" id="statType" name="statType" value="${param.statType }" />
<input type="hidden" id="listType" name="listType" value="${param.listType }" />
<input type="hidden" id="listTitle" name="listTitle" value="${param.listTitle }" />
<input type="hidden" id="displayType" name="displayType" value="${param.displayType }" />
<input type="hidden" id="displayId" name="displayId" value="${param.displayId }" />
<input type="hidden" id="displayName" name="displayName" value="${param.displayName }" />
<input type="hidden" id="startTime" name="startTime" value="${param.startTime }" />
<input type="hidden" id="endTime" name="endTime" value="${param.endTime }" />
<input type="hidden" id="docMark" name="docMark" value="${param.docMark }" />
<input type="hidden" id="docMark_txt" name="docMark_txt" value="${param.docMark_txt }" />
<input type="hidden" id="serialNo" name="serialNo" value="${param.serialNo }" />
<input type="hidden" id="serialNo_txt" name="serialNo_txt" value="${param.serialNo_txt }" />

<div class="layout_north bg_color" id="north">
	<div style="float: left" id="toolbars"></div>
</div>
   <div class="layout_center page_color over_hidden " id="center" width="100%" height="100%" >
   	<table  class="flexme3" id="edocStatListRec"></table>
</div>
	
</form>

</div>

<div class="hidden">
	<iframe name="export_iframe" id="export_iframe">&nbsp;</iframe>
</div>

</body>
</body>
</html>