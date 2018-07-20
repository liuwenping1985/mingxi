<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatNewManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat_workcount_list.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript">
	var _ctxPath = '${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
	var listType = "${v3x:escapeJavascript(param.listType)}";
	var deptOrMemberId = "${v3x:escapeJavascript(param.deptOrMemberId)}";
	var statRangeType = "${v3x:escapeJavascript(param.statRangeType)}";
	var statRangeId = "${v3x:escapeJavascript(param.statRangeId)}";
	var type = "${v3x:escapeJavascript(param.type)}";
	var startTime = "${v3x:escapeJavascript(param.startTime)}";
	var endTime = "${v3x:escapeJavascript(param.endTime)}";
	var checkDeptId = "${v3x:escapeJavascript(param.checkDeptId)}";
	var statId = "${v3x:escapeJavascript(param.statId)}";
	var ids = "${v3x:escapeJavascript(param.ids)}";
	var listTitle = "${v3x:escapeJavascript(param.listTitle)}";
</script>
</head>
<body scroll="">
<div id='layout'>
	<div class="layout_north bg_color" id="north">
		<div style="float: left" id="toolbars"></div>
	</div>
    <div class="layout_center over_hidden" id="center">
    	<table  class="flexme3" id="edocStatListRec"></table>
	</div>
</div>

<iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>

</body>
</body>
</html>