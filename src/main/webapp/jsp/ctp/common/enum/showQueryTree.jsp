<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script type="text/javascript">
</script>
<body scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
<div class="scrollList">
 <script type="text/javascript">
  	var root = new WebFXTree('0', '<fmt:message key="metadata.query.lable"/>');
  	//root.target = "systemDataTree" ;
 	<c:forEach items="${metadataItem}" var="item">
 	 var metadataitem${fn:replace(item.id, '-', '_')} = new WebFXTreeItem('${item.id}','${item.label}') ;
 		//metadataitem${fn:replace(item.id, '-', '_')}.target = "systemDataTree" ;
    </c:forEach>
    
     <c:forEach items="${metadataItem}" var="item">
    	 root.add(metadataitem${fn:replace(item.id, '-', '_')}) ;   
    </c:forEach>
    
    
	document.write(root);
	document.close();
	webFXTreeHandler.select(root);       
 </script>
</div>
<iframe name="systemDataTree" width="100%" height="100%" id="systemDataTree" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>