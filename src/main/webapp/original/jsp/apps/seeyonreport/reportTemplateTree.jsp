<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
var treeObj;
$(document).ready(function(){
	$("#templateTree").tree({
		idKey : "id",
		pIdKey : "parentId",
		nameKey : "name",
		nodeHandler : function(node) {
            node.isParent = true;
        }
	});
	treeObj = $.fn.zTree.getZTreeObj("templateTree");
	var node = treeObj.getNodeByParam("id", "0", null);
    treeObj.selectNode(node, false);
    treeObj.expandNode(node, true, false, true);
});
function OK() {
	var selected = treeObj.getSelectedNodes()[0].id;
	if (selected == "0") {
		$.alert($.i18n('seeyonreport.report.template.move.info'));
		return;
	}
	return selected;
}
</script>
</head>
<body>
    <div id="templateTree" class="ztree"></div>
</body>
</html>