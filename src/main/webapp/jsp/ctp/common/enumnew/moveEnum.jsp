<%--
 $Author: dengxj $
 $Rev: 32026 $
 $Date:: 2013-12-04 10:40:52#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>枚举页面</title>
</head>
<body style="height:480px;width:480px; overflow:auto">
	<div>
		<!--  <b>${ctp:i18n('common.toolbar.move.label')}</b>-->
		<div id="tree"></div>
	</div>
	<!-- <iframe src="" class="hidden" id="moveIframe"></iframe> -->
    <script type="text/javascript">
		  //树结构参数
			var treeParams = {
			        idKey : "id",
			        pIdKey : "pId",
			        nameKey : "name",
			        managerName : "enumManagerNew",
			        managerMethod : "getEnumCategoryTree",
			        enableCheck : false,
			        enableEdit : false,
			        enableRename : false,
			        enableRemove : false,
					nodeHandler : function(n) {
						if(n.data.id == -1){
				        	n.open = true;
			        	}
					}
					};
					$().ready(function() {
						initTree();
					});
					//树刷新方法
					function refleshTree(o) {
						$("#" + o).treeObj().reAsyncChildNodes(null, "refresh");
					}
					//初始化树方法
					function initTree() {
						var params = {
							tabType : "${tabType}"
						};
						treeParams.asyncParam = params;
						$("#tree").empty();
						$("#tree").tree(treeParams);
						refleshTree("tree");
					}
					//取得当前选中的树的节点id
					function getSelectTreeNode() {
						var treeObj = $.fn.zTree.getZTreeObj("tree");
						var selected = treeObj.getSelectedNodes();
						return selected[0] == undefined ? undefined
								: selected[0].data;
					}
					//点击确定方法
					function OK() {
						//需要移动的所有枚举id
						var ids = window.dialogArguments[1];
						var currentNode = getSelectTreeNode();
						var parentId = currentNode == undefined ? 0
								: currentNode.id;
						//如果枚举id为-1那么传进去的parentId = 0
						if(parentId == -1) parentId = 0;
						//$("#moveIframe").attr("src",
						//		"${path }/enum.do?method=moveEnum&ids=" + ids
						//				+ "&parentId=" + parentId);
						//return true;
						var moveFlag=false;
						var url="${path}/enum.do?method=moveEnum";
						$.ajax({
							url:url,
							type:"POST",
							data:{
								ids:ids,
								parentId:parentId
							},
							async:false,
							dataType:"text",
							success:function(data)
							{
								if(data=="")
									{
									   moveFlag=true;
									}
								
							},
							error:function()
							{
								alert("Error!");
							}
						});
						return moveFlag;
					}
				</script>
</body>
</html>