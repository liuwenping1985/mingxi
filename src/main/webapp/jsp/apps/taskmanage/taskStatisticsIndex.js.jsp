<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-01-15 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    var zTree = null;
    var IDMark_A = "_a";
    
    function addHoverDom(treeId, treeNode) {
        if (treeNode.isParent) return;
        var aObj = $("#" + treeNode.tId + IDMark_A);
        if ($("#diyBtn1_"+treeNode.id).length>0) return;
        var editStr = "<a id='diyBtn1_" +treeNode.id+ "' onclick='setDefaultTaskStatistics(\"" + treeNode.id + "\");return;' style='margin:0 0 0 20px;'>设置默认</a>";
        aObj.append(editStr);
    }

    function removeHoverDom(treeId, treeNode) {
        if (treeNode.isParent) return;
        $("#diyBtn1_"+treeNode.id).unbind().remove();
    }
    
    /**
     * 初始化项目树
     */
    function initStatisticsTree() {
        $("#statistics_tree").tree({
            onClick : clickEvent,
            idKey : "id",
            pIdKey : "parent",
            nameKey : "name",
            asyncParam : {

            },
            nodeHandler : function(n) {
                if (n.data.parent == -1) {
                    n.isParent = true;
                    n.open = true;
                }
            },
            addHoverDom: addHoverDom,
            removeHoverDom: removeHoverDom
        });
        zTree = $.fn.zTree.getZTreeObj("statistics_tree");
    }

    /**
     * 初始化树形控件选中的选项
     */
    function initTreeSelected() {
        var nodes = zTree.getNodes();
        for ( var i = 0; i < nodes.length; i++) {
            if (nodes.length > 0) {
                var childrenNode = nodes[i].children;
                if(childrenNode){
                    for ( var j = 0; j < childrenNode.length; j++) {
                        if (childrenNode[j].data.isSelected == 1) {
                            zTree.selectNode(childrenNode[j]);
                            changeIframeSrc(childrenNode[j].data.id);
                        }
                    }
                }
            }
        }
    }
    
    /**
     * 树形控件的单击事件
     */
    function clickEvent(e, treeId, node) {
        zTree.expandNode(node);
        if(!node.isParent && node.data.id != 1){
            changeIframeSrc(node.data.id);
        }
    } 
    
    /**
     * 切换iframe路径
     */
     function changeIframeSrc(id) {
         var url = _ctxPath + "/taskmanage/taskstatistics.do?method=taskStatisticsView&sid="+id;
         $("#statistics_view_iframe").attr("src",url);                
     }
    
    function setDefaultTaskStatistics(sId){
        var callerResponder = new CallerResponder();
        var taskAjax = new taskAjaxManager();
        var formObj = new Object();
        formObj.userId = $.ctx.CurrentUser.id;
        formObj.statisticsId = sId;
        callerResponder.success = function(retObj) {
            if (retObj == true || retObj == "true") {
                new MxtMsgBox({
                    'msg': "设置成功！",
                    'type': 0,
                    imgType:0,
                    title:"系统提示"
                });
            }
        };
        callerResponder.sendHandler = function(b, d, c) {
        }
        //表单局部提交
        taskAjax.saveTaskStatisticsView(formObj, callerResponder);
    }
</script>