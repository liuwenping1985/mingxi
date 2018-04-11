<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=categoryManager"></script>
<!DOCTYPE html>
<html>
<head>
<title>信息类型左导航</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" language="javascript">
$().ready(function() {
	$("#categoryTree").tree({
		onClick : showCategory,
		idKey : "id",
		pIdKey : "parentId",
		nameKey : "name",
		managerName : "categoryManager",
		managerMethod : "showCategoryTree",
		enableAsync : true,
		nodeHandler : function(n) {
			n.isParent = true;
		}
	});
});

function asyncLoad(){ 
	$("#categoryTree").treeObj().reAsyncChildNodes(null, "refresh");
}

function showCategory(e, treeId, node) {
	//alert("showCategory");
	//alert($.toJSON(node.data));
	//var o = new Object();
	//o.parentId = 1;
	//window.frames[0].$('#listCategory').ajaxgridLoad(o);
}

</script>
</head>
<body>
<div class="padding_10">
	<div id="categoryTree" class="ztree "></div>
</div>
</body>
</html>
