<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
 $(document).ready(function() {
	 $("#templateTree").tree({
		 idKey : "id",
	     pIdKey : "parentId",
	     nameKey : "name",
	     nodeHandler : function(n) {
	         n.isParent = true;
	     }
	  });
	 var treeObj = $.fn.zTree.getZTreeObj("templateTree");
      var nodes = treeObj.getNodes();
      if (nodes.length > 0) {
          treeObj.expandNode(nodes[0], true, false, true);
      }
      treeObj.selectNode(nodes[0]);
  });
  
  function OK(){
    var treeObj = $.fn.zTree.getZTreeObj("templateTree");
    var nodes = treeObj.getSelectedNodes();
    return nodes[0];
  }
</script>
</head>
<body>
    
    <div id="templateTree" class="ztree"></div>
</body>
</html>