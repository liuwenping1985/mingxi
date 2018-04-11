<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoListManager"></script>
<!DOCTYPE html>
<html>
<head>
<title>分类</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" language="javascript">
var iManager = new infoListManager();
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
	
	var treeObj = $.fn.zTree.getZTreeObj("categoryTree"); 
	treeObj.expandAll(true);
});

$("#selectedBtn").click(function() {
    var nodes = $("#categoryTree").treeObj().getSelectedNodes();
    alert($.toJSON(nodes));
});

function asyncLoad(){ 
	$("#categoryTree").treeObj().reAsyncChildNodes(null, "refresh");
}

var _idstr = "${idStr}";
function OK(){
	var nodes = $("#categoryTree").treeObj().getSelectedNodes();
	if(nodes.length>0 && nodes[0].data.id !== "0"){
    	iManager.updateInfoCategory(_idstr, nodes[0].data.id);
    	return "success";
	}else {
		return "error";
	}
}

function showCategory() {
	//alert("showCategory");
	//alert($.toJSON(node.data));
	//var nodes = $("#categoryTree").treeObj().getSelectedNodes();
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
