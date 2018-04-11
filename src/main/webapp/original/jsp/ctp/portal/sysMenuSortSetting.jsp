<%--
 $Author: leikj $
 $Rev: 33650 $
 $Date:: 2014-03-07 16:43:47#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title>系统预制菜单排序设置</title>
<style type="text/css">
#systemMenuTree {width:300px;overflow-y:auto;/*height:500px;overflow-x:auto;*/}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=portalSYSMenuManager"></script>
<script type="text/javascript">
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
  if(selectedNode.pIdKey == targetNode.pIdKey && moveType != "inner"){
    return true;
  }
  return  false;
}

function beforeExpand(treeId, treeNode) {
	return treeNode.expand;
}

//显示系统菜单
function showSystemMenuTree(enable){
  new portalSYSMenuManager().getPortalSYSMenus({
    success : function(portalSYSMenus){
      if(portalSYSMenus){
        $("#systemMenuTree").tree({
          idKey : "idKey",
          pIdKey : "pIdKey",
          nameKey : "nameKey",
          enableCheck : false,
          enableEdit : enable,
          enableRename : false,
          enableRemove : false,
          nodeHandler:function(n){
            if(!n.data.icon){
              n.isParent = true;
            }
            if(n.idKey=="menu_0"){
              n.open = true;
            }
            n.checked = n.data.checked;
            n.expand = n.data.expand;
            n.chkDisabled = !enable;
          }
        });
        var setting = $("#systemMenuTree").treeObj().setting;
        setting.callback = {
        	beforeDrag : beforeDrag,
        	beforeDrop : beforeDrop,
			beforeExpand: beforeExpand
		};
        setting.edit.drag.autoOpenTime = 99999999;
        setting.edit.drag.inner = false;
        var targetTree = $.fn.zTree.init($("#systemMenuTree"), setting, portalSYSMenus);
        $("#shortcut_set").height($("body").height()-80);
        $("#systemMenuTree").width($("#shortcut_set").width()).height($("#shortcut_set").height()-30);;
      }
    }
  });
}

$(document).ready(function() {
  showSystemMenuTree(true);
  
  $("#submitBtn").click(function(){
    $.confirm({
      'msg': "${ctp:i18n('portal.sysmenu.customprompt')}",
      ok_fn: function () {
        var treeObj = $("#systemMenuTree").treeObj();
        var nodesArray = treeObj.transformToArray(treeObj.getNodes());
        var menus = new Array();
        for(var i = 0 ; i < nodesArray.length; i++){
          var node = nodesArray[i];
          if(node.idKey == "menu_0"){
            continue;
          }else{
            var portalSYSMenuOrder = new Object();
            portalSYSMenuOrder.menuId = node.idKey.split("_")[1];
            portalSYSMenuOrder.orderId = i;
            menus.push(portalSYSMenuOrder);
          }
        }
        if(menus.length > 0){
          new portalSYSMenuManager().saveCustomSYSMenuOrders(menus, {
            success : function(){
              $.infor("${ctp:i18n('common.successfully.saved.label')}");
            }
          });
        }
      }
    });
  });
  
  $("#cancelBtn").click(function(){
    self.location.href = "${path}/portal/portalController.do?method=sysMenuSortSetting";
  });
});
</script>
</head>
<body class="h100b over_hidden page_color_write align_center">
    <div class="comp" comp="type:'breadcrumb',code:'T03_portalSYSMenuSort'"></div>
    <fieldset id="shortcut_set" class="shortcut_set" style="margin-bottom:5px;width:600px;overflow:hidden;">
    <legend>${ctp:i18n('portal.sysmenu.sortting')}</legend>
    <table border="0" align="left">
        <tr id="menuTR">
            <td><font color="red">*</font>${ctp:i18n('portal.sysmenu')}: <font color="gray">(${ctp:i18n('menuTree.sort.descoraption.label')})</font></td>
        </tr>
        <tr>
            <td valign="top" align="left">
                <div id="systemMenuTree" style="overflow:auto"></div>
            </td>
        </tr>
    </table>
    </fieldset>
    <div class="align_center" style="background-color: white;"><input id="submitBtn" type="button" class="common_button" style="margin-top:3px;line-height:22px" value="${ctp:i18n("common.button.ok.label")}" />&nbsp;&nbsp;<input id="cancelBtn" type="button" class="common_button" style="margin-top:3px;line-height:22px" value="${ctp:i18n("common.button.cancel.label")}" /></div>
</body>
</html>