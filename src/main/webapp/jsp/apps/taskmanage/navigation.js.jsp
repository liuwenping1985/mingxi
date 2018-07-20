<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-27 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    var zTree = null;
    var projectId = '${projectId}';
    var userId = '${currentUserId}';
    /**
     * 初始化项目树
     */
    function initPorjectTree() {
        $("#tree_list").tree({
            onClick : clickEvent,
            idKey : "id",
            pIdKey : "parentId",
            nameKey : "name",
            nodeHandler : function(n) {
                if (n.data.parentId == -1) {
                    n.isParent = true;
                }
                if (n.data.isSelected == 1) {
                    n.open = true;
                }
            }
        });
        zTree = $.fn.zTree.getZTreeObj("tree_list");
    }

    /**
     * 初始化树形控件选中的选项
     */
    function initTreeSelected() {
      var listProUrl = _ctxPath +"/taskmanage/taskinfo.do?method=listManageTask&from=Manage&projectId=0&contextType=Project";
        var nodes = zTree.getNodes();
        if(nodes.length > 0) {
            nodes = nodes[0].children;
            for ( var i = 0; i < nodes.length; i++) {
                if (nodes.length > 0) {
                    var childrenNode = nodes[i].children;
                    if(childrenNode != undefined) {
                        for ( var j = 0; j < childrenNode.length; j++) {
                            if (childrenNode[j].data.isSelected == 1) {
                                zTree.selectNode(childrenNode[j]);
                                listProUrl = _ctxPath +"/taskmanage/taskinfo.do?method=listManageTask&from=Manage&projectId=" + childrenNode[j].data.id + "&contextType=Project";
                            }
                        }
                    }
                }
            }
        }
        $("#list_iframe",parent.document).attr("src",listProUrl);
    }
    
    function clickEvent(e, treeId, node) {
        if(!node.isParent && node.data.parentId != -1){
            zTree.expandNode(node);
            changeProjectListData(node.data.id);
        }
    }
    
    /**
     * 初始化页面UI
     */
    function initUI() {
        boolType();
    }
    
    /**
     * 判断页面数据显示的类型，并根据类型显示对应数据
     */
    function boolType() {
        var type = '${param.type}';
        if (type != null && type == "Project") {
            $("#member_table").addClass("hidden");
            $("#project_tree").removeClass("hidden");
            $("input:radio[name='navigation_type']").eq(1).attr("checked",
                    'checked');
        } else {
            $("#member_table").removeClass("hidden");
            $("#project_tree").addClass("hidden");
            $("input:radio[name='navigation_type']").eq(0).attr("checked",
                    'checked');
        }
    }
    
    function initBtnEvent(){
        $("#member_radio").bind("click", chooseNavigationType);
        $("#project_radio").bind("click", chooseNavigationType);
    }
    
    /**
     * 选择数据类型
     */
    function chooseNavigationType() {
        var radioVal = $('input:radio[name="navigation_type"]:checked').val();
        changeNavigationIframe(radioVal);
        changeListFrame(radioVal);
    }
    
    /**
     * 根据显示类型切换内容页面
     */
    function changeListFrame(type) {
        var listUrl = _ctxPath +"/taskmanage/taskinfo.do?method=listManageTask&from=Manage";
        if(type != null && type != "Project"){
            $("#list_iframe",parent.document).attr("src",listUrl);
        }
    }
    
    /**
     * 根据显示类型切换导航页面
     */
     function changeNavigationIframe(type) {
         var url = _ctxPath + "/taskmanage/taskinfo.do?method=navigation&type="+type;
         $("#navigation_iframe",parent.document).attr("src",url);                
     }
    
   /**
    * 改变人员任务列表信息
    */
    function changeMemberListData(uId) {
        var listUrl = _ctxPath +"/taskmanage/taskinfo.do?method=listManageTask&from=Manage&userId=" + uId + "&contextType=User";
        $("#list_iframe",parent.document).attr("src",listUrl);
    }
    
    /**
     * 改变项目任务列表信息
     */
    function changeProjectListData(pId) {
        var listUrl = _ctxPath +"/taskmanage/taskinfo.do?method=listManageTask&from=Manage&projectId=" + pId + "&contextType=Project";
        $("#list_iframe",parent.document).attr("src",listUrl);
    }
</script>