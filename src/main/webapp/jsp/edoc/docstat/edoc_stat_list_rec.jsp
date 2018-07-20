<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatNewManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat_list.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat_list_rec.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript">
	var _ctxPath = '${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
	var listType = "${v3x:escapeJavascript(param.listType)}";
	var listTitle = "${v3x:escapeJavascript(param.listTitle)}";
	var displayId = "${v3x:escapeJavascript(param.displayId)}";
	var displayType = "${v3x:escapeJavascript(param.displayType)}";
	var displayTimeType = "${v3x:escapeJavascript(param.displayTimeType)}";
	var edocType = "${param.edocType}";
	var isG6Version = "${isG6Version}"=="true";
	var nodeList = [];
	<c:forEach items="${nodeList}" var="node">	
		var nodeObj = new Object();
		nodeObj.text = "${node.label}";
		nodeObj.value = "${node.name}";
		nodeList.push(nodeObj);
	</c:forEach>
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