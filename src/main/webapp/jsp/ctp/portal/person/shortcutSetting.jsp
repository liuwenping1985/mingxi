<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>菜单排序</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager"></script>
<script>
  $(document).ready(function() {
    $("#shortcutTree").height($(document).height()-45);
    $("#shortcutTree").tree({
      idKey : "idKey",
      pIdKey : "pIdKey",
      nameKey : "nameKey",
      urlKey : "urlKey",
      iconKey : "iconKey",
      beforeDrag : beforeDrag,
      beforeDrop : beforeDrop,
      enableCheck : true,
      enableEdit : true,
      enableRename : false,
      enableRemove : false,
      nodeHandler:function(n){
        if(n.pIdKey == null){
          n.open = true;
        }
        n.checked = n.data.checked;
      }
    });
    //增加节点校验，修正当前人员授权变更时，节点的check状态与现实的数据不符
    var nodes = $("#shortcutTree").treeObj().getNodes();
    if(nodes&&nodes.length>0){
      for(var i=0; i<nodes.length; i++){
        var node = nodes[i];
        checkNodeState(node);
      }
    }
    function checkNodeState(node){
        if(!node.data.urlKey){
          if(!node.children || node.children.length == 0){
            node.checked = false;
          }else{
            var items = node.children;
            var checked = false;
            for(var j=0; j<items.length; j++){
              if(checkNodeState(items[j]) == true){
                checked = true;
                continue;
              }
            }
            if(node.checked != checked){
              $("#shortcutTree").treeObj().checkNode(node,checked);
            }
            return checked;
          }
        }else{
          return node.checked;
        }
    }
    function beforeDrag(treeId, treeNodes) {
      if (treeNodes[0].drag === false) {
        return false;
      }
      return true;
    }
    function beforeDrop(treeId, treeNodes, targetNode, moveType) {
      //当前选中节点
      var selectedNode = treeNodes[0];
      if(selectedNode.pIdKey == targetNode.idKey && moveType == "inner"){
        return true;
      }
      if(selectedNode.pIdKey == targetNode.pIdKey && moveType != "inner" && targetNode.idKey != "0"){
        return true;
      }
      return  false;
    }
  });
  //前台提交用到的树对象
  function nodeObj(id,parentId,name,url,icon,checked,sort,target){
    this.id = id;
    this.parentId = parentId;
    this.name = name;
    this.url = url;
    this.icon = icon;
    this.checked = checked;
    this.sort = sort;
    this.target = target;
  }
  function save(){
    //增加提交遮蔽
    showMask();
    var treeObj = $("#shortcutTree").treeObj();
    var nodesArray = treeObj.transformToArray(treeObj.getNodes());
    var nodes = new Array();
    var checkedNodes = 0;
    for(var i=0 ; i<nodesArray.length; i++){
      var node = nodesArray[i];
      //提交数据屏蔽根节点
      if(node.idKey == "menu_0"){
        continue;
      }else{
        var n = new nodeObj(node.idKey,node.pIdKey,node.nameKey,node.data.urlKey,node.data.iconKey,node.checked,i,node.data.target);
        nodes.push(n);
      }
      if(node.idKey != "menu_0" && node.pIdKey == "menu_0" && node.checked){
        checkedNodes++;
      }
    }
    /*
    if(checkedNodes<=0){
      alert($.i18n("portal.shortcut.least",1));
      return;
    }
    if(checkedNodes>7){
      hideMask();
      $.alert($.i18n("portal.shortcut.most",7));
      return;
    }
    */
    new spaceManager().saveShortcutsSortOfMember($.toJSON(nodes),{
      success:function(){
        //撤销遮蔽
        hideMask();
        $.messageBox({
          'title': "${ctp:i18n('common.prompt')}",
          'type': 0,
          'msg': "<span class='msgbox_img_0 left'></span><span class='margin_l_5 padding_5'>${ctp:i18n('common.successfully.saved.label')}</span>",
           ok_fn: function() {
             getCtpTop().refreshShortcuts();
             location.reload();
          }
        });
    }});
  }
  
  function cancel(){
    window.location.reload();
  }
  
  parent.$("#content_div").removeClass("over_hidden");
  parent.$("#content_div").css("overflow-x", "hidden");
</script>
</head>
<body class="h100b over_auto page_color_write align_center">
    <fieldset class="shortcut_set">
        <legend>${ctp:i18n('personalSetting.shortcut.setting')}&nbsp;&nbsp;<span class="color_gray">(${ctp:i18n("short.jsp.sort.opera")})</span></legend>
        <table id="selectTable" width="60%" height="100%" align="left">
            <input type="hidden" id="treeObjInput" />
            <tr>
                <td width="100%" valign="top" height="100%" align="left">
                    <div id="shortcutTree" style="width:500px;overflow: auto;"></div>
                </td>
            </tr>
        </table>
    </fieldset>
</body>
</html>