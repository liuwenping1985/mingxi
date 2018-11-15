<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp"%>
<script>
function setSelApp()
{
try{
  parent.listFrame.myBar.disabled("newdata");
  parent.listFrame.myBar.disabled("editdata");
  parent.listFrame.myBar.disabled("deldata");
  }catch(e){}
}
</script>
</head>
<script type="text/javascript">
<%--选中树节点显示数据项列表--%>	
function showList(metadataId){
	parent.listFrame.location.href = metadataURL+"?method=systemMetadataListItemList&id="+metadataId;
}

function showTypeList(){
	parent.listFrame.location.href = metadataURL+"?method=systemMetadataList";
}

</script>
<body scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
<div class="scrollList  border-padding">
<script type="text/javascript">
	var root = new WebFXTree("treeRoot", "<fmt:message key='metadata.label.tree'/>", "javascript:setSelApp();showTypeList();");
	<c:forEach items="${metadatasList}" var="meta">
	<c:if test="${meta.canEdit == 'true'}">
		var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('meta_${meta.id}',"${v3x:messageFromResource(EnumI18N, meta.label)}","javascript:showList('${meta.id}')");
		root.add(metadata${fn:replace(meta.id, '-', '_')});
	</c:if>	
	</c:forEach>
	document.write(root);
	document.close();
	root.select();
</script></div>
</body>
</html>
