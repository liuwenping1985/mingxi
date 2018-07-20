<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: 2014-01-20 16:45:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=roleManager,orgManager"></script>
<script type="text/javascript">

/**
 * cmd = "selectResource" 资源选择, cmd = "selectAll" 所有节点都可选择
 */
var canChangeCheck = true;
var oManager = new orgManager();
var roleman = new roleManager();
var isallowaccpriv = roleman.getGroupPrivType();
var isgroup=oManager.isGroup();
$().ready(function() {
  if ( $._autofill ) { var $af = $._autofill, $afg = $af.filllists; }
  var cmd = $afg.cmd;
  // 节点可拖拽
  var enableEdit = false;
  var enableRemove = false;
  var enableCheck = true;
  // 在查看选择资源时不显示checkbox，在选择和查看所有资源时显示
  if(cmd === "selectAll" || cmd === "selectResource" || $afg.treebackCheck){
    // enableCheck = true;
  }
  // 在查看选择资源时不能改变checkbox
  if(cmd != "selectAll" && cmd != "selectResource"){
    canChangeCheck = false;
  }
  //var drag = $afg.drag;
  var drag = false;
  if( drag ){ enableEdit = true; enableRemove = true; }
  // 系统管理资源树
  $("#treeback").tree({
    idKey : "idKey",
    pIdKey : "pIdKey",
    nameKey : "nameKey",
    enableCheck : enableCheck,
    enableEdit : enableEdit,
    enableRename : false,
    enableRemove : enableRemove,
    enableAsync : true,
    beforeDrag : beforeDrag,
    beforeDrop : beforeDrop,
    managerName : "resourceManager",
    managerMethod : "findTreeNodes"
  });
  // 前台应用资源树
  $("#treefront").tree({
    idKey : "idKey",
    pIdKey : "pIdKey",
    nameKey : "nameKey",
    enableCheck : enableCheck,
    enableEdit : enableEdit,
    enableRename : false,
    enableRemove : enableRemove,
    enableAsync : true,
    beforeDrag : beforeDrag,
    beforeDrop : beforeDrop,
    managerName : "resourceManager",
    managerMethod : "findTreeNodes"
  });
  
  // 设置树节点勾选状态
  checkNodes();
  // 设置树操作按钮显示
  if(cmd === "selectAll"){
    $("#showAllBtu").hide();
    $("#showSelectBtu").hide();
    $("#expandAllBtu").show();
    $("#foldAllBtu").show();
    $("#selectAllBtu").show();
    $("#selectNotBtu").show();
    //$("#confirmBtu").show();
  }
  // 初始化树页面
  if(typeof(parent.initTreePage) != "undefined"){
    parent.initTreePage(this);
  }
  //
  $("#selectNotBtu").click(function(){
    selectNotBtu();
  });
  
  // 提交
  $("#confirmBtu").click(function(){
    var nodesArray = new Array();
    var nodes = $("#treeback").treeObj().getCheckedNodes();
    $(nodes).each(function(index, elm){
      nodesArray.push(elm.data);
    });
    var nodes = $("#treefront").treeObj().getCheckedNodes();
    $(nodes).each(function(index, elm){
      nodesArray.push(elm.data);
    });
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
      var roleId = $afg.roleId;
    }
    var rm = new roleManager();
    var callerResponder = new CallerResponder();
    callerResponder.success = function() {
      try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
    	  parent.$.infor("${ctp:i18n('label.operation.success')}");
    	  window.parentDialogObj['treedialog'].close();
      /* parent.$.messageBox({'title': "${ctp:i18n('label.prompt')}",'type' : 0,'msg' : jsonObj[0]}); */
    };
    callerResponder.sendHandler = function(b, d, c) {
      try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
      if (confirm("${ctp:i18n('label.submit.or.not')}")) {
        b.send(d, c);
      }
    };
    //alert($afg.roleId);
    //alert(oManager.getRoleById($afg.roleId).bond);
    if(isgroup&&isallowaccpriv=="2"&&oManager.getRoleById($afg.roleId).bond!='0'){
      var confirm = $.confirm({
          'msg': "${ctp:i18n('role.groupsyc.confirm')}",
          ok_fn: function () {
            try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
            rm.updateRoleResource(nodesArray, roleId, callerResponder);
          },
          cancel_fn:function(){}
      });
    }else{
      try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
      rm.updateRoleResource(nodesArray, roleId, callerResponder);
    }
    
  });
  
  // 显示所有资源
  $("#showAllBtu").click(function(){
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
      window.location = "resource.do?method=getTree&showAll=1&appResCategory=1&isAllocated=true&roleId=" + $afg.roleId;
    }
  });

  // 显示选择资源
  $("#showSelectBtu").click(function(){
    if ($._autofill) {
      var $af = $._autofill, $afg = $af.filllists;
      window.location = "resource.do?method=getTree&roleId=" + $afg.roleId;
    }
  });

  // 展开所有节点
  $("#expandAllBtu").click(function(){
    var treeObj1 = $.fn.zTree.getZTreeObj("treeback");
    treeObj1.expandAll(true);
    var treeObj2 = $.fn.zTree.getZTreeObj("treefront");
    treeObj2.expandAll(true);
  });

  // 折叠所有节点
  $("#foldAllBtu").click(function(){
    var treeObj1 = $.fn.zTree.getZTreeObj("treeback");
    treeObj1.expandAll(false);
    var treeObj2 = $.fn.zTree.getZTreeObj("treefront");
    treeObj2.expandAll(false);
  });

  // 选择所有节点
  $("#selectAllBtu").click(function(){
    var treeObj1 = $.fn.zTree.getZTreeObj("treeback");
    treeObj1.checkAllNodes(true);
    var treeObj2 = $.fn.zTree.getZTreeObj("treefront");
    treeObj2.checkAllNodes(true);
  });
  // 默认将树展开
  var treeObj1 = $.fn.zTree.getZTreeObj("treeback");
  var nodes1 = treeObj1.getNodes();
  if (nodes1.length > 0) {
    treeObj1.expandNode(nodes1[0], true, false, true);
    treeObj1.selectNode(nodes1[0]);
  }
  var treeObj2 = $.fn.zTree.getZTreeObj("treefront");
  var nodes2 = treeObj2.getNodes();
  if (nodes2.length > 0) {
    treeObj2.expandNode(nodes2[0], true, false, true);
    treeObj2.selectNode(nodes2[0]);
  }
  
});

function beforeDrag(treeId, treeNodes) {
  if (treeNodes[0].idKey === "menu_0")return false;
  if (treeNodes[0].drag === false) {
  parent.$.messageBox({'title': "${ctp:i18n('label.prompt')}",'type' : 0,'msg' : "${ctp:i18n('resource.uder.menu.not.drag')}"});
    return false;
  }
  return true;
}

function beforeDrop(treeId, treeNodes, targetNode, moveType) {
  var result = targetNode ? targetNode.drop !== false : true;
  if(!result){
    parent.$.messageBox({'title': "${ctp:i18n('label.prompt')}",'type' : 0,'msg' : "${ctp:i18n('resource.menu.not.drag.under')}"});
  }
  return result;
}

function showRemoveBtn(treeId, treeNode) {
  if (treeNode.idKey === "menu_0")return false;
  if (treeNode.candelete === false) {
    return false;
  }
  return true;
}

function beforeRemove(treeId, treeNode) {
  return confirm("${ctp:i18n('resource.under.all.delete')}");
}

function onRemove(event, treeId, treeNode) {
  var result = true;
  if(typeof(parent.removeMenu) != "undefined"){
    parent.removeMenu(treeNode.data);
  }
}

function onDrop(event, treeId, treeNodes, targetNode, moveType) {
  if(typeof(parent.dropMenu) != "undefined"){
    parent.dropMenu(targetNode, treeNodes);
  }
}

function beforeCheck(treeId, treeNode){
  if(treeNode.data.editKey === "false" || !canChangeCheck){
    return false;
  }else{
    return true;
  }
}
    
// 设置树节点勾选状态
function checkNodes(){
  if ($._autofill) {
    // 获取后台request参数
    var $af = $._autofill, $afg = $af.filllists;
    // 后台管理资源树
    checkTreeNodes($afg, "treeback");
    // 前台应用资源树
    checkTreeNodes($afg, "treefront");
  }
}
function OK(){
	$("#confirmBtu").click();
}

function checkTreeNodes(afg, treeName){
	
  var cmd = afg.cmd;
  var treeObj = $.fn.zTree.getZTreeObj(treeName);
  
  // 设置节点的勾选子级取消勾选时不影响父级
  treeObj.setting.check.chkboxType.N = "s";
  treeObj.setting.check.chkboxType.Y = "ps";
  // 节点单击事件
  if(cmd != "selectResource"){
    treeObj.setting.callback.onClick = parent.nodeclk;
  }else{
    // 单选节点的实现
    checkOneNode();
  }
  //
  if(typeof(eval("afg."+treeName+"Check")) != "undefined"){
    // 显示全部资源的情况
    var treeNodes = eval("afg."+treeName+"Check");
  }else{
    // 显示选择资源的情况
    var treeNodes = eval("afg."+treeName);
  }
  var distreeNodes = eval("afg."+treeName);
  if(typeof(cmd) === "undefined"){
    var nodes = treeObj.getNodes();
    $(nodes).each(function (index, domEle) {
      treeObj.setChkDisabled(domEle, false);
    });
  }
  
  $(treeNodes).each(function (index, domEle) {
	 
    // 父节点
    var pnode = treeObj.getNodeByParam("idKey", domEle.pIdKey, null);
    var node = treeObj.getNodeByParam("idKey", domEle.idKey, pnode);
    if(cmd != "selectResource"){
      treeObj.checkNode(node, true, false);
      // 检查节点是否可编辑
      
      if(domEle.editKey === "false"){
        //node.data.editKey = "false";
        //treeObj.setChkDisabled(node, true);
      }
      // checkbox是否可编辑
      if(cmd != "selectAll"){
        // treeObj.setChkDisabled(node, true);
      }
    }
    if(domEle.idKey.indexOf("menu_") != -1){
      // treeObj.setChkDisabled(node, true);
    }else{
      // 菜单下的资源不能进行拖动,不能将菜单拖动到资源下
      node.drag = false;
      node.drop = false;
      node.candelete = false;
    }
  });
  $(distreeNodes).each(function (index, domEle) {
	  var pnode = treeObj.getNodeByParam("idKey", domEle.pIdKey, null);
	  var node = treeObj.getNodeByParam("idKey", domEle.idKey, pnode);
	  if(domEle.editKey === "false"){
		  //node.data.editKey = "false";
	  	  treeObj.setChkDisabled(node, true);
	  }
  });
  // 资源不能删除
  treeObj.setting.edit.showRemoveBtn = showRemoveBtn;
  treeObj.setting.callback.beforeRemove = beforeRemove;
  treeObj.setting.callback.onRemove = onRemove;
  treeObj.setting.callback.onDrop = onDrop;
  treeObj.setting.callback.beforeCheck = beforeCheck;
}

// 全不选节点
var selectNotBtu = function(){
  var treeObj1 = $.fn.zTree.getZTreeObj("treeback");
  treeObj1.checkAllNodes(false);
  var treeObj2 = $.fn.zTree.getZTreeObj("treefront");
  treeObj2.checkAllNodes(false);
};

// 单选节点的实现
function checkOneNode(){
  var treeObj1 = $.fn.zTree.getZTreeObj("treeback");
  treeObj1.setting.callback.beforeCheck = selectNotBtu;
  var treeObj2 = $.fn.zTree.getZTreeObj("treefront");
  treeObj2.setting.callback.beforeCheck = selectNotBtu;
}
</script>
