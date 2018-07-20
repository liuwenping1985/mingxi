<%--
 $Author: lilong $
 $Rev: 32885 $
 $Date:: 2014-01-23 14:07:25#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=menuManager"></script>
<script type="text/javascript">

$(function() {
  if ($._autofill) {
    var $af = $._autofill, $afg = $af.filllists;
  }
  // 列表
  $(".mytable").each(function() {
    $(this).ajaxgrid({
      click : clk,
      render : rend,
      dblclick : dblclk,
      colModel : [
        { display : 'id',
          name : 'id',
          width : '5%',
          sortable : false,
          align : 'center',
          type : 'checkbox'
        },
        { display : "${ctp:i18n('privilege.menu.name.label')}",
          name : 'name',
          width : '35%'
        },
        { display : "${ctp:i18n('privilege.menu.isVirtualNode.label')}",
          name : 'isVirtualNode',
          width : '10%',
          codecfg : "codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.BooleanEnums'"
        },
        { display : "${ctp:i18n('privilege.menu.menuLevel.label')}",
          name : 'menuLevel',
          width : '15%'
        },
        { display : "${ctp:i18n('privilege.menu.enterResourceName.label')}",
          name : 'enterResourceName',
          width : '30%'
        }
      ],
      width : "auto",
      parentId:'center',
      managerName : "menuManager",
      managerMethod : "findMenus"
    });
  });
  // 工具栏
  $("#toolbar").toolbar({
    toolbar : [ 
      { id : "create", 
        name : "${ctp:i18n('privilege.menu.new.label')}", 
        className : "ico16",
        click : function() { 
          newMenu(); 
        }
      },
      { id : "create", 
        name : "${ctp:i18n('privilege.menu.edit.label')}", 
        className : "ico16 editor_16",
        click : function() { 
          updateMenu(); 
        }
      },
      { id : "create", 
        name : "${ctp:i18n('privilege.menu.delete.label')}", 
        className : "ico16 del_16",
        click : function() { 
          deleteMenu(); 
        }
      }
      /*,
      { id : "create", 
        name : "${ctp:i18n('privilege.menu.copy.label')}", 
        className : "ico16 batch_16",
        click : function() {
          if($("#productVersion").val() === ""){
            $.infor("${ctp:i18n('privilege.menu.notSelectVersion.info')}");
            return;
          }
          copyResTree();
        }
      }*/
      ]
  });
  // 复制资源树
  var canonicalVersions = $afg.canonicalVersions;
  var productVersion = $("#productVersion");
  $(canonicalVersions).each(function(index, elem){
    productVersion.append("<option value=\""+elem+"\">"+elem+"</option>");
  });
  // 初始化树
  productVersionChange($("#productVersion").val());
  // 产品版本改变事件
  $("#productVersion").change(function(){
    productVersionChange($("#productVersion").val());
  });
  // 资源应用类型改变事件
  $("#appResCategory").change(function(){
    productVersionChange($("#productVersion").val());
  });
});

function loadTable(){
  // 手动加载表格数据
  var o1 = new Object();
  o1.id = $("#parnetMenuId").val();
  o1.ext3 = $("#productVersion").val();
  o1.ext4 = $("#appResCategory").val();
  $("#mytable1").ajaxgridLoad(o1);  
}

function rend(txt, data, r, c) {
    return txt;
}
  
function clk(data, r, c) {
}
  
function dblclk(data, r, c) {
  var dialog = $.dialog({
      url : _ctxPath+'/privilege/menu.do?method=edit&id='+data.id,
        width : 550,
        height : 400,
        targetWindow:top,
        title : "${ctp:i18n('privilege.resource.lookup.label')}",
        buttons : [ {
         text : "${ctp:i18n('privilege.resource.close.label')}",
            handler : function() {
              dialog.close();
            }
       }]
    });
}

function addNode(jsonObj){
  var pId = "menu_" + ($("#parnetMenuId").val() === "" ? "0" : $("#parnetMenuId").val());
  var newNode = new Object();
  newNode.idKey = "menu_" + jsonObj.id;
  newNode.nameKey = jsonObj.name;
  newNode.pidKey = pId;
  if(jsonObj.ext1 === 1){
    var treeback = window.frames["selectResouce"].$.fn.zTree.getZTreeObj("treeback");
    var pnode = treeback.getNodeByParam("idKey", pId, null);
    treeback.addNodes(pnode, newNode);
    var node = treeback.getNodeByParam("idKey", newNode.idKey, null);
    //if(jsonObj.enterResourceId){
    //  node.isParent = true;
    //}
    treeback.reAsyncChildNodes(node, "refresh");
  }else{
    var treefront = window.frames["selectResouce"].$.fn.zTree.getZTreeObj("treefront");
    var pnode = treefront.getNodeByParam("idKey", pId, null);
    treefront.addNodes(pnode, newNode);
    var node = treefront.getNodeByParam("idKey", newNode.idKey, null);
    //if(jsonObj.enterResourceId){
    //  node.isParent = true;
    //}
    treefront.reAsyncChildNodes(node, "refresh");
  }
}

function updateNode(menu){
  var treeback = window.frames["selectResouce"].$.fn.zTree.getZTreeObj("treeback");
  var treefront = window.frames["selectResouce"].$.fn.zTree.getZTreeObj("treefront");
  var node = treefront.getNodeByParam("idKey", "menu_" + menu.id, null);
  if(!node){
    node = treeback.getNodeByParam("idKey", "menu_" + menu.id, null);
  }
  node.nameKey = menu.name;
  treeback.updateNode(node);
  treefront.updateNode(node);
}

// 新建菜单
function newMenu(){
  if(typeof opendialog != "undefined" && opendialog){ 
    opendialog.getDialog(); 
    opendialog.autoMinfn(); 
    return; 
  }
  // 新建菜单的类型跟选择的应用资源类型相同
  var appResCategory = $("#appResCategory").val();
  var productVersion = $("#productVersion").val();
  var dialog = $.dialog({
    url : _ctxPath+'/privilege/menu.do?method=create&appResCategory='+appResCategory+'&productVersion='+productVersion,
    width : 550, 
    height : 400,
    targetWindow:top,
    title : "${ctp:i18n('privilege.menu.new.label')}",
    buttons : [ {
      text : "${ctp:i18n('privilege.resource.submit.label')}",
      handler : function() {
        var menuNew = new Object();
        var callerResponder = new CallerResponder();
        callerResponder.success = function(jsonObj) {
          dialog.close();
          // 手动加载表格数据
          loadTable();
          // 更新树
          addNode(jsonObj);
        };
        callerResponder.sendHandler = function(b, d, c) {
          if (confirm("${ctp:i18n('privilege.resource.confirmSubmit.info')}")) {
            b.send(d, c);
          }
        }
        var menu = dialog.getReturnValue();
        if(menu.valid){
          return;
        }
        menuNew.name = menu.name;
        menuNew.icon = menu.icon;
        var target = menu.target;
        if(target == 1){
        	menuNew.target = "";
        }else{
          	menuNew.target = menu.opentype;
        }
        menuNew.enterResourceId = menu.enterResourceId;
        // 菜单类型 0 前台 1 后台
        menuNew.ext1 = menu.ext1;
        menuNew.parentId = ($("#parnetMenuId").val() === "" ? "0" : $("#parnetMenuId").val());
        // 一级菜单需要设置图片
        /* if(menuNew.parentId === "0" && menuNew.icon === ""){
          $.alert("请设置菜单图片");
          return;
        } */
        menuNew.sortid = menu.sortid;
        // 菜单所属版本
        menuNew.ext3 = $("#productVersion").val();
        // 菜单的应用类型
        menuNew.ext4 = menu.ext4;
        // 导航菜单
        if(menu.naviResIds){
          menuNew.naviResourceIds = menu.naviResIds.split(",");
        }
        // 快捷菜单
        if(menu.shortCutResourceId){
          menuNew.shortcutResourceIds = menu.shortCutResourceId.split(",");
          menuNew.ext20 = menu.shortcutdefult;
        }
        var mm = new menuManager();
        mm.create(menuNew, callerResponder);
      }
    }, {
      text : "${ctp:i18n('privilege.resource.cancel.label')}",
      handler : function() {
        dialog.close();
      }
    }]
  });
  opendialog = dialog;
}

function updateMenu(){
  var boxs = $("#mytable1 input:checked:not(.togCol)");
    if(boxs.length === 0){
    	$.alert("${ctp:i18n('privilege.menu.notSelectEditMenu.info')}");
      
      return;
    }else if(boxs.length > 1){
    	$.alert("${ctp:i18n('privilege.menu.onlyOneSelect.info')}");	
     
      return;
    }
    var id = boxs[0].value;
    var dialog = $.dialog({
      url : _ctxPath+'/privilege/menu.do?method=edit&id='+id,
        width : 550,
        targetWindow:top,
        height : 400,
        title : "${ctp:i18n('privilege.menu.edit.label')}",
        buttons : [ {
          text : "${ctp:i18n('privilege.resource.submit.label')}",
          handler : function() {
            var callerResponder = new CallerResponder();
            callerResponder.success = function(jsonObj) {
              dialog.close();
              // 手动加载表格数据
              loadTable();
            };
            callerResponder.sendHandler = function(b, d, c) {
              if (confirm("${ctp:i18n('privilege.resource.confirmSubmit.info')}")) {
                b.send(d, c);
              }
            }
            var menu = dialog.getReturnValue();
            if(menu.valid){
              return;
            }
            var menuNew = new Object();
            menuNew.id = menu.id;
            menuNew.name = menu.name;
            menuNew.icon = menu.icon;
            menuNew.enterResourceId = menu.enterResourceId;
            // 一级菜单需要设置图片
            /* if(($("#parnetMenuId").val() === "0" || $("#parnetMenuId").val() === "") && menuNew.icon === ""){
              $.alert("请设置菜单图片");
              return;
            } */
            // 菜单类型 0 前台 1 后台
            menuNew.ext1 = menu.ext1;
            menuNew.sortid = menu.sortid;
            var target = menu.target;
            if(target == 1){
              menuNew.target = "";
            }else{
              menuNew.target = menu.opentype;
            }
            // 导航菜单
            if(menu.naviResIds){
              menuNew.naviResourceIds = menu.naviResIds.split(",");
            }
            // 快捷菜单
            if(menu.shortCutResourceId){
              menuNew.shortcutResourceIds = menu.shortCutResourceId.split(",");
              
              menuNew.ext20 = menu.shortcutdefult;
            }
            var mm = new menuManager();
            mm.updateMenu(menuNew, callerResponder);
            // 更新树
            updateNode(menu);
            //location.reload();//这里调整为直接页面刷新，否则会有更新tree节点的很多问题
         }
       }, {
         text : "${ctp:i18n('privilege.resource.cancel.label')}",
            handler : function() {
              dialog.close();
            }
       }]
    });
}

function deleteMenu(){
  var menues = new Array();
  var tesBS = new menuManager();
  var boxs = $("#mytable1 input:checked:not(.togCol)");
  if(boxs.length === 0){
	  $.alert("${ctp:i18n('privilege.menu.notSelectDelMenu.info')}");
   
    return;
  }else{
    // 更新树
    var nodes = new Array();
    var treeback = window.frames["selectResouce"].$.fn.zTree.getZTreeObj("treeback");
    var treefront = window.frames["selectResouce"].$.fn.zTree.getZTreeObj("treefront");
    boxs.each(function (index, domEle) {
      menues.push($(domEle).val());
      var node = treefront.getNodeByParam("idKey", "menu_" + $(domEle).val(), null);
      if(!node){
        node = treeback.getNodeByParam("idKey", "menu_" + $(domEle).val(), null);
      }
      nodes.push(node);
    });
    $.confirm({
     
      'msg' : "${ctp:i18n('privilege.menu.confirmDelete.info')}",
      ok_fn : function() {
        tesBS.deleteMenu(menues, {
          success : function(){
            // 手动加载表格数据
            loadTable();
            $(nodes).each(function (index, domEle) {
              treeback.removeNode(domEle);
              treefront.removeNode(domEle);
            });
        }
        });
      }
    });
  }
}

// 树节点单击事件
function nodeclk(event, treeId, treeNode) {
  if(treeNode.idKey.split("_")[0] === "res")return;
  // 手动加载表格数据
  var o1 = new Object();
  var menuId = treeNode.idKey.split("_")[1];
  o1.id = menuId;
  o1.ext3 = $("#productVersion").val();
  o1.ext4 = $("#appResCategory").val();
  if(menuId === "0"){
    delete o1.id;
  }
  o1.refreshCurPage = true;
  $("#parnetMenuId").val(menuId);
  $("#mytable1").ajaxgridLoad(o1);
  delete o1.refreshCurPage;
}

// 树节点删除事件
function removeMenu(data){
  var tesBS = new menuManager();
  var menues = new Array();
  var menuId = data.idKey.split("_")[1];
  menues.push(menuId);
  tesBS.deleteMenu(menues);
}

// 树节点拖拽事件
function dropMenu(targetNode, treeNodes){
  if(!targetNode)return;
  var tesBS = new menuManager();
  var parentId = targetNode.idKey.split("_")[1];
  var menues = new Array();
  $(treeNodes).each(function(index, elem){
    var menuId = elem.idKey.split("_")[1];
    menues.push(menuId);
  });
  tesBS.updateMenuPath(parentId, menues);
}

// 初始化树页面
function initTreePage(page){
  $("#backlable", page).hide();
  $("#frontlable", page).hide();
  $("#showAllBtu", page).hide();
  $("#showSelectBtu", page).hide();
}

//
function productVersionChange(version){
  // 切换版本后初始化已经打开过的dialog
  opendialog = null;
  var appRes = $("#appResCategory").val();
  $("#selectResouce").attr("src", 
      "../privilege/resource.do?method=getTree&cmd=menuList&drag=true&version="+version+"&appResCategory="+appRes);
  $("#parnetMenuId").val("");
  loadTable();
}

function copyResTree(){
  var dialog = $.dialog({
    url : _ctxPath+'/privilege/menu.do?method=showVersion&productVersion='+$("#productVersion").val(),
    width : 300,
    targetWindow:top,
    height : 200,
    title : "${ctp:i18n('privilege.menu.copy.label')}",
    buttons : [ {
      text : "${ctp:i18n('privilege.resource.submit.label')}",
      handler : function() {
      // $.messageBox({
      // 'title': '提示',
      // 'type' : 1,
      // 'msg' : '左侧资源树将被覆盖，确认继续?',
      // ok_fn : function() {
            var fromVersion = dialog.getReturnValue();
            var toVersion = $("#productVersion").val();
            var tesBS = new menuManager();
            tesBS.copyMenus(fromVersion, toVersion);
            dialog.close();
            productVersionChange(toVersion);
            $.infor("${ctp:i18n('privilege.menu.copySuccess.info')}");
      // }
      // });
      }
    }, {
      text : "${ctp:i18n('privilege.resource.cancel.label')}",
      handler : function() {
        dialog.close();
      }
    } ]
  });
}
</script>
