<%--
 $Author:  $
 $Rev:  $
 $Date:: 2012-08-07 15:52:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" href="${path}/decorations/css/skin.css">
<script type="text/javascript" src="${path}/ajax.do?managerName=sectionManager"></script>
<script type="text/javascript" src="${path}/decorations/js/space.js"></script>
<html>
<head>
<title>${ctp:i18n('menu.space.personalConfig')}</title>
<script type="text/javascript">
var selectedPanel = "common";//记录选中的页签
$(document).ready(function(){
    var allPanels = new ArrayList();
    <c:forEach items="${allSpaceSectionTypes}" var="as">
      allPanels.add("${as}");
    </c:forEach>
    
    var panels = new ArrayList();
    <c:forEach items="${spaceSectionTypes}" var="sectionType">
     <c:set var="sectionTypeLabel" value="channel.${sectionType}.label.${ctp:getSystemProperty('portal.porletSelectorFlag')}" />
              panels.add(["${sectionType}", "${ctp:i18n(sectionTypeLabel)}"]);
    </c:forEach>

    var ulObj = $("#selectorUl");
    for(var i=0 ; i<panels.size(); i++){
      var panel = panels.get(i);
      var panelId = panel[0];
      var panelTxt = panel[1];
      var currentClass = "";
      if(panelId==selectedPanel){
        currentClass = "current";
      }
      ulObj.append("<li id=\""+panelId+"\" class=\""+currentClass+" display_block left\" title=\""+panelTxt+"\"><a href=\"javascript:changePanel('"+panelId+"')\" tgt=\""+panelId+"_div\"><span>"+panelTxt+"</span></a></li>");
    }
    if(${'related_project_space' == spaceType }){
    	$("#selectorTab").hide();
    }
    //$("#selectorUl li :last").addClass("border_r");
    $("#sectionTree").tree({
      idKey : "id",
      pIdKey : "parentId",
      nameKey : "sectionName",
      onDblClick : _selectNode,
      onClick : _clkNode,
      nodeHandler: function(n) {
        if(n.data.icon || n.data.sectionBeanId == null || n.data.sectionBeanId == ""){
          n.isParent = true;
        }
        if(n.data.parentId){
          n.open = false;
        }else{
          n.open = true;
        }
      }
    });
    $("#selectedTree").tree({
      idKey : "id",
      pIdKey : "parentId",
      nameKey : "sectionName",
      title : "title",
      onDblClick : _removeNode,
      showTitle : true,
      nodeHandler: function(n) {
        n.open = false;
      }
    });
    //栏目初始化
    showTreeData(selectedPanel);
    
    //已选栏目回显
    var pagePath = "${ctp:escapeJavascript(pagePath)}";
    var entityId = "${ctp:escapeJavascript(entityId)}";
    var editKeyId = "${ctp:escapeJavascript(editKeyId)}";
    var ownerId = "${ctp:escapeJavascript(ownerId)}";
    var spaceId = "${ctp:escapeJavascript(spaceId)}";
    var params = new Object();
    if(entityId){
      params['entityId']=entityId;
    }else{
      params['pagePath']=pagePath;
      params['editKeyId'] = editKeyId;
    }
    params['ownerId']=ownerId;
    params['spaceId']=spaceId;
    new sectionManager().selectedSectionTreeNode(params,{
      success : function(data){
          var setting = $("#selectedTree").treeObj().setting;
          setting.view.selectedMulti = true;
          $.fn.zTree.init($("#selectedTree"), setting, data);
      }
    });
});
var spaceType = "${ctp:escapeJavascript(spaceType)}";
var spaceId = "${ctp:escapeJavascript(spaceId)}";
var isMulti = "${ctp:escapeJavascript(isMulti)}";
function showTreeData(selectedPanel){
  var params = new Object();
  params['sectionType']=selectedPanel;
  params['spaceType']=spaceType;
  params['spaceId']=spaceId;
  params['isMulti']=isMulti;
  
  new sectionManager().selectSectionTreeNode(params,{
    success : function(data){
        var setting = $("#sectionTree").treeObj().setting;
        //查询数据展现完成后，设置节点不默认展开
        setting.nodeHandler = function(n){
          if(n.data.icon || n.data.sectionBeanId == null || n.data.sectionBeanId == ""){
            n.isParent = true;
          }
          if(n.data.parentId){
            n.open = false;
          }else{
            n.open = true;
          }
        }
        //允许多选
        setting.view.selectedMulti = true;
        setting.callback.beforeExpand = _beforeExpand;
        $.fn.zTree.init($("#sectionTree"), setting, data);
    }
  });
}

function changePanel(panel){
  $("#selectorUl li").each(function(i,obj){
    if($(obj).attr("id")==panel){
      $(obj).addClass("current");
    }else{
      $(obj).removeClass("current");
    }
  });
  selectedPanel = panel;
  /* 表单栏目增加查询 */
  if(panel == "formbizconfigs"){
    $("#searchBtn").show().bind("click",function(){
       _sectionSearch($("#searchTxt").val());
    });
      $("#searchTxt").show().val("").bind("keydown",function(event){
        switch(event.keyCode){
          //回车触发查询
          case 13:
            _sectionSearch(this.value);
            break;
        }
      });
  }else{
    $("#searchBtn").unbind("click").hide();
    $("#searchTxt").unbind("keydown").hide();
  }
  showTreeData(panel);
}
function _sectionSearch(searchWord){
  var params = new Object();
  params['sectionType']=selectedPanel;
  params['spaceType']=spaceType;
  params['spaceId']=spaceId;
  params['isMulti']=isMulti;
  params['searchWord'] = searchWord;
  new sectionManager().selectSectionTreeNode(params,{
    success : function(data){
     /*  var _data = [];
        //空查询直接返回
        if(searchWord == ""){
          _data = data;
        }else if(data && data.length > 0){
          for(var i=0 ; i < data.length; i++){
            var _d = data[i];
            if(_d.sectionBeanId == null || _d.sectionBeanId == ""){
               _data[_data.length] = _d;
            }else if(_d.sectionName.indexOf(searchWord) >= 0){
              _data[_data.length] = _d;
            }
          }
        } */
        var setting = $("#sectionTree").treeObj().setting;
        //查询后设置节点全部展开
        setting.nodeHandler = function(n){
          if(n.data.icon || n.data.sectionBeanId == null || n.data.sectionBeanId == ""){
            n.isParent = true;
          }
            n.open = true;
        }

        //允许多选
        setting.view.selectedMulti = true;
        setting.callback.beforeExpand = _beforeExpand;
        $.fn.zTree.init($("#sectionTree"), setting, data);
    }
  });
}
function _beforeExpand(treeId,treeNode){
	if(treeNode.data.async == false){
		var params = new Object();
		  params['sectionType']=selectedPanel;
		  params['spaceType']=spaceType;
		  params['spaceId']=spaceId;
		  params['isMulti']=isMulti;
		  params['nodeId'] = treeNode.id;
	  new sectionManager().selectAsyncSectionTreeNode(params,{
		    success : function(data){
		        $("#sectionTree").treeObj().removeChildNodes(treeNode);
		        $("#sectionTree").treeObj().addNodes(treeNode, data);
		    }
		  });
	}
}
function _clkNode(event, treeId, treeNode){
	if(treeNode.data.async == false){
		var params = new Object();
		  params['sectionType']=selectedPanel;
		  params['spaceType']=spaceType;
		  params['spaceId']=spaceId;
		  params['isMulti']=isMulti;
		  params['nodeId'] = treeNode.id;
	  new sectionManager().selectAsyncSectionTreeNode(params,{
		    success : function(data){
		        $("#sectionTree").treeObj().removeChildNodes(treeNode);
		        $("#sectionTree").treeObj().addNodes(treeNode, data);
		    }
		  });
	}
}
function _selectNode(){
  var nodes = $("#sectionTree").treeObj().getSelectedNodes();
  if(nodes){
    for (var i=0, l=nodes.length; i < l; i++) {
      //多频道，只能选3个
      var selectedNodes = $("#selectedTree").treeObj().getNodes();
      if("true" == isMulti){
        if(selectedNodes.length>=3){
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'msg': "<span class='msgbox_img_2 left'></span><span class='margin_l_5'>${ctp:i18n_2('space.alertSection1_3',3,3)}</span>",
             ok_fn: function() {
              
            }
          });
          return;
        }
      }
      //一个空间只能选一个的栏目
   	  var nodeData = null;
   	  if(nodes[i].data.data){
        nodeData = nodes[i].data.data;
      }else{
        nodeData = nodes[i].data;
      }
      if(nodeData.unique){
    	  if(selectedNodes&&selectedNodes.length>0){
    		  for(var j=0; j<selectedNodes.length; j++){
    			  var selectedNodeData = null;
    		      if(selectedNodes[j].data.data){
    		    	  selectedNodeData = selectedNodes[j].data.data;
    		      }else{
    		    	  selectedNodeData = selectedNodes[j].data;
    		      }
    		      var id = nodeData.sectionBeanId;
    		      if(selectedNodeData.sectionBeanId.indexOf(nodeData.sectionBeanId)>=0){
    		    	  $.messageBox({
    		              'title': "${ctp:i18n('common.prompt')}",
    		              'type': 0,
    		              'msg': "<span class='msgbox_img_2 left'></span><span class='margin_l_10'>${ctp:i18n_1('space.section.isUnique','"+nodes[i].data.sectionName+"')}</span>",
    		               ok_fn: function() {
    		                
    		              }
    		            });
    		            return;
    		      }
    		  }
    	  }
      }
      var sectionBeanId = nodes[i].data.sectionBeanId;
      if(sectionBeanId == null){
        continue;
      }
      $("#selectedTree").treeObj().addNodes(null,nodes[i]);
    }
  }
}
function _removeNode(){
  var treeObj = $("#selectedTree").treeObj();
  var nodes = treeObj.getSelectedNodes();
  if(nodes){
    for (var i=0, l=nodes.length; i < l; i++) {
      treeObj.removeNode(nodes[i]);
    }
  }
}
function _upNode(){
  var treeObj = $("#selectedTree").treeObj();
  var nodes = treeObj.getSelectedNodes();
  if(nodes&&nodes.length>0){
    var preNode = nodes[0].getPreNode();
    if(preNode){
      treeObj.moveNode(preNode,nodes[0],"prev");
    }
  }
}
function _downNode(){
  var treeObj = $("#selectedTree").treeObj();
  var nodes = treeObj.getSelectedNodes();
  if(nodes&&nodes.length>0){
    var nextNode = nodes[0].getNextNode();
    if(nextNode){
      treeObj.moveNode(nextNode, nodes[0], "next");
    }
  }
}
function OK(){
  var nodes = $("#selectedTree").treeObj().getNodes();
  var names = [];
  var ids = [];
  var singleBoards = [];
  var entityIds = [];
  var ordinals = [];
  var properties = [];
  if(nodes){
    for(var i=0, l=nodes.length; i<l; i++){
      var node = nodes[i];
      var nodeData = null;
      if(node.data.data){
        nodeData = node.data.data;
      }else{
        nodeData = node.data;
      }
      var id = nodeData.sectionBeanId;
      var name = node.data.sectionName;
      var singleBoardId = nodeData.singleBoardId;
      var entityId = nodeData.entityId;
      var ordinal = nodeData.ordinal;
      var property = nodeData.properties;
      ids[ids.length] = id;
      names[names.length]=name;
      if(singleBoardId){
          singleBoards[singleBoards.length] = singleBoardId;
      }
      else{
          singleBoards[singleBoards.length] = "";
      }
      if(entityId){
          entityIds[entityIds.length] = entityId;
      }else{
          entityIds[entityIds.length] = "";
      }
      if(ordinal){
          ordinals[ordinals.length] = ordinal;
      }else{
          ordinals[ordinals.length] = "";
      }
      if(property){
        properties[properties.length] = property;
      }else{
        properties[properties.length] = "";
      }
    }
  }
  return [ids, names, singleBoards,entityIds,ordinals,properties];
}
</script>
</head>
<body>
    <div id="selector" class="comp" comp="type:'tab',width:'100%',height:'100%'">
        <div id="selectorTab" class="common_tabs clearfix" style="padding: 5px 5px 0 5px; width: 680px">
            <ul class="left" id="selectorUl">
            </ul>
        </div>
        <div class="left">
            <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="40%" class="padding-T padding-L">
                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="20" class="padding_b_5">${ctp:i18n('channel.optional.label')}</td>
                                <td height="20" align="right" class="padding_b_5"><input type="text" id="searchTxt" value="" class="hidden"/></td>
                            	  <td height="20" align="right" valign="middle" class="padding_b_5"><div id="searchBtn" class="hidden"><em class="ico16 search_16"></em></div></td>
                            </tr>
                            <tr id="commonTR">
                                <td height="100%" valign="top" colspan="3">
                                    <div style="width:300px; height:375px; background:#FFF; border:solid 1px #555;overflow:auto;">
                                        <ul id="sectionTree"></ul>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="10%" align="center" valign="middle">
                        <span class="ico16 select_selected margin_b_10 margin_l_10" onclick="_selectNode()"></span>
                        <span class="ico16 select_unselect margin_t_10 margin_l_10" onclick="_removeNode()"></span>
                    </td>
                    <td width="40%" class="padding-T padding-L">
                        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="20" class="padding_b_5">${ctp:i18n('channel.selected.label')}</td>
                            </tr>
                            <tr>
                                <td height="100%" valign="top">
                                    <div  style="width:300px; height:375px; background:#FFF; border:solid 1px #555;overflow:auto;">
                                        <ul id="selectedTree"></ul>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="10%" align="center" valign="middle">
                        <c:if test="${param.count != null && param.count <= 3 }">
                            <span class="ico16 sort_up margin_b_10 margin_l_5" onclick="_upNode()"></span>
                            <span class="ico16 sort_down margin_t_10 margin_l_5" onclick="_downNode()"></span>
                        </c:if>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>