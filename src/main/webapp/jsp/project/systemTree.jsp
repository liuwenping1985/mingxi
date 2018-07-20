<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>mainframe</title>
<%@include file="projectHeader.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript">
<!--
function showProjectList(projectTypeId){
	parent.detaliFrame.location.href ="${basicURL}?method=showListFrame&projectTypeId="+projectTypeId;	
	parent.disabledMyBar("new",true); 
	parent.disabledMyBar("modify",true); 
	parent.disabledMyBar("delete",true); 
	parent.disabledMyBar("modifyLeader",false); 
	
// 	var newbutton = parent.toolBarFrame.document.all("new");
// 	 var updatebutton = parent.toolBarFrame.document.all("modify");
// 	 var deletebutton = parent.toolBarFrame.document.all("delete");
// 	 var modifyLeader = parent.toolBarFrame.document.all("modifyLeader");
// 	 newbutton.disabled = false;
// 	 updatebutton.disabled = false;
// 	 deletebutton.disabled = false; 
// 	 modifyLeader.disabled = false;
}

function showDetailFrame(){
	parent.detaliFrame.location.href ="${basicURL}?method=showDetali";
	disableButtonsWhenRootNodeSelected();
}
<%-- 刷新或第一次显示页面时，根节点处于选中状态，对根节点不能进行修改和删除操作，将对应的工具栏菜单按钮置灰，当选中其他子节点时，修改和删除对应菜单按钮才生效 --%>
function disableButtonsWhenRootNodeSelected() {
  parent.disabledMyBar("new",true); 
  parent.disabledMyBar("modify"); 
  parent.disabledMyBar("delete"); 
  parent.disabledMyBar("modifyLeader");
}
//-->
</script>
</head>
<body onkeydown="${v3x:outConditionExpression(noClick, 'listenerKeyESC()', '')}">
<div class="scrollList">
<script type="text/javascript">
<!--
webFXTreeConfig.fileIcon = webFXTreeConfig.folderIcon;
var treeData = new ArrayList();

<c:forEach items="${ptList}" var="pt">
treeData.add("${v3x:toHTML(pt)}");
</c:forEach>
{
	var tree = new WebFXTree('0', "<fmt:message key='project.type.label' />", "javascript:showDetailFrame();");
	tree.setBehavior('classic');
	tree.icon = "<c:url value='/apps_res/project/images/templete.gif'/>";
	tree.openIcon = "<c:url value='/apps_res/project/images/templete.gif'/>";
	
	<c:forEach items="${ptList}" var="c">
		<%--  WebFXTreeItem(sBusinessId, sText, sAction, sDBlClick, eParent, sIcon, sOpenIcon)  --%>
		var tree${fn:replace(c.id, '-', '_')} = new WebFXTreeItem('${c.id}', "${v3x:escapeJavascript(c.name)}","javascript:showProjectList('${c.id}')");
		tree.add(tree${fn:replace(c.id, '-', '_')});
	</c:forEach>
	
	document.write(tree);
	document.close();
	
	try{
		webFXTreeHandler.select(tree);
	}catch(e){}
}
//-->

</script>
</div>
<iframe src="javascript:void(0)" name="hiddenIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>