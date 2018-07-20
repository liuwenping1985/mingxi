<%--
 $Author: wuym $
 $Rev: 368 $
 $Date:: 2012-08-09 13:46:49#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>Tree测试</title>
<script type="text/javascript" language="javascript">
  $().ready(function() {
    $("#simpleTree").tree({
      idKey : "orgid",
      pIdKey : "parentid",
      nameKey : "orgname"
    });

    $("#addBtn").click(function() {
      var nodes = $("#simpleTree").treeObj().getSelectedNodes();
      var data = $("#addNode").formobj();
      if (nodes.length > 0) {
        $("#simpleTree").treeObj().addNodes(nodes[0], data);
      } else {
        $("#simpleTree").treeObj().addNodes(null, data);
      }
    });

    $("#selectAddBtn").click(function() {
      var nodes = $("#simpleTree").treeObj().getSelectedNodes();
      alert($.toJSON(nodes));
    });

    $("#tree").tree({
      onClick : clk,
      beforeDrag : beforeDrag,
      beforeDrop : beforeDrop,
      managerName : "testCRUDManager",
      managerMethod : "testLoadAll",
      idKey : "orgid",
      pIdKey : "parentid",
      nameKey : "orgname",
      enableCheck : true,
      enableEdit : true,
      enableRename : true,
      enableRemove : true,
      asyncParam : {
        orgname : '致远'
      },
      nodeHandler : function(n) {
        n.open = true;
        if (n.data.orgid == '1') {
          n.isParent = true;
          n.drag = false;
          n.drop = false;
        }
        n.isParent = true;
      },
      render : function(name, data) {
        return data.orgid + " - " + name;
      }
    });

    function clk(e, treeId, node) {
      alert($.toJSON(node.data) + node.parentid);
      //node.children[0].data 取第0个子节点的数据对象
    }

    function beforeDrag(treeId, treeNodes) {
      if (treeNodes[0].drag === false) {
        return false;
      }
      return true;
    }
    function beforeDrop(treeId, treeNodes, targetNode, moveType) {
      return targetNode ? targetNode.drop !== false : true;
    }

    $("#selectedBtn").click(function() {
      var nodes = $("#tree").treeObj().getSelectedNodes();
      alert($.toJSON(nodes));
    });
    $("#checkedBtn").click(function() {
      var nodes = $("#tree").treeObj().getCheckedNodes();
      alert($.toJSON(nodes));
    });

    $("#asyncBtn").click(function() {
      $("#tree").treeObj().reAsyncChildNodes(null, "refresh");
    });
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <table>
        <tr>
            <td valign="top" width="400">复杂树功能：<br> <input type="button" id="selectedBtn" value="已选择节点">
                <input type="button" id="checkedBtn" value="已勾选节点"> <input type="button" id="asyncBtn"
                value="异步加载当前节点">
                <div id="tree"></div></td>
            <td valign="top">简单树实现：<br> <input type="button" id="selectAddBtn" value="已选择节点">
                <div id="addNode">
                    <input type="button" id="addBtn" value="添加节点"> <input type="text" id="orgid"><input
                        type="text" id="orgname">
                </div>
                <div id="simpleTree"></div>
            </td>
        </tr>
    </table>
</body>
</html>
