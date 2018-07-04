<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('performanceReport.authorize.index.title')}</title>
</head>
<body class="h100b over_hidden page_color">
	<div id="index_layout" class="comp page_color" comp="type:'layout'">
		<div class="comp"
			comp="type:'breadcrumb',comptype:'location',code:'F08_dashboardset'"></div>
		<div class="layout_west line_col over_hidden" layout="border:false" style="margin-top:10px;">
			<ul id="leftTree" class="treeDemo_0 ztree"></ul>
		</div>
		<div class="layout_center page_color over_hidden" layout="border:false">
			<iframe id="rightFrame" width="100%" height="100%" frameborder="0"></iframe>
		</div>
	</div>
	<script>
		$(function() {
			$("#leftTree").tree({
				idKey : "id",
				pIdKey : "parentId",
				nameKey : "name",
				isParent : "isParent",
				onClick : function(e,treeId,node){
					if(!node.isParent){
						if(node.data.target){
							window.open(_ctxPath+node.data.url, node.data.target);
						}else{
							$("#rightFrame").attr("src",_ctxPath+node.data.url);
						}
					}
				},
				nodeHandler : function(n) {
					n.open = true;
				}
			});
			
			var treeObj = $.fn.zTree.getZTreeObj("leftTree");
			treeObj.selectNode(treeObj.getNodeByParam('id',"100100"));
			$("#rightFrame").attr("src",_ctxPath + "/wfanalysisAuth.do?method=index");
		});
	</script>
</body>
</html>

