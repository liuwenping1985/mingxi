<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<script type="text/javascript">
  $().ready(function() {
    $("#linkTree").tree({
      idKey : "id",
      pIdKey : "categoryId",
      nameKey : "name",
      title : "title",
      onClick : clk,
      onDblClick : function() {
        parent.selectToRight();
      },
      nodeHandler : function(n) {
        if(typeof n.title == "undefined"){
          n.title = n.name;
          n.data.formCreator = "";
        }
        if (n.data.sourceType == -1) {
          n.open = true;
        }
        if (n.data.sourceType == 0) {
          n.isParent = true;
        }
        if ("${needExpan}" == "true") {
          n.open = true;
        }
      }
    });
  });
  
  function clk(e, treeId, node) {
    //基础数据、信息管理中根和分类只支持列表
    if ("${param.linkType}" == "formBaseInfo" || "${param.linkType}" == "formManageInfo") {
      if (node.data.sourceType == "-1" || node.data.sourceType == "0") {
        parent.$("#list").click();
      } else {
        parent.$("#view").click();
      }
    }
  }

  function getSelectedNode() {
    return $("#linkTree").treeObj().getSelectedNodes()[0];
  }
</script>
</head>
<body class="h100b">
    <div id="linkTree"></div>
</body>
</html>