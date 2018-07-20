<%--
 $Author:  翟锋$
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>F1-节点权限布局</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=permissionManager"></script>
    <c:if test="${category=='info'}">
    <script type="text/javascript" src="${path}/ajax.do?managerName=elementManager"></script>
    </c:if>
    <script type="text/javascript">
        var grid;
        var edocDialog;
        var infoDialog;
        var newEdoc = "${newEdoc}";
        $(function () {
            //初始化布局
            new MxtLayout({
                'id': 'layout',
                'northArea': {
                    'id': 'north',
                    'height': 30,
                    'sprit': false,
                    'border': false
                },
                'centerArea': {
                    'id': 'center',
                    'border': false,
                    'minHeight': 20
                }
            });
            //获取类型 (协同 或者公文)
            var category = $('#category').val();
            //工具栏
            var toolbar = new Array();
            //新建
            toolbar.push({id: "newCreate",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16",click:addRow });
            //修改
            toolbar.push({id: "update",name: "${ctp:i18n('common.toolbar.update.label')}",className: "ico16 editor_16",click:updateRow });
            //如果是公文时，要添加'公文元素配置' 按
            if('col_flow_perm_policy'!==category && newEdoc != 'true'){
            	//V51 F18 信息报送  start
            	if('info'===category) {
            		toolbar.push({id:"setPolicy", name:"${ctp:i18n('collaboration.info.element')}", className:"ico16 edoceleset_16", click:setInfoPolicyRow });
            	} 
            	//V51 F18 信息报送  end
            	else {
            		//公文元素设置
                    toolbar.push({id:"setPolicy",name: "${ctp:i18n('collaboration.edoc.element')}",className: "ico16 edoceleset_16",click:setPolicyRow });
            	}
            }
            //删除
            toolbar.push({ id: "delete",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16",click:deleteRow });
            
            $("#toolbars").toolbar({
                borderLeft:false,
                borderTop:false,
                borderRight:false,
                toolbar: toolbar
            });
            //定义搜索条件选项
            var condition = new Array();
            //名称
            condition.push({id: 'name',name: 'name',type: 'input',text: "${ctp:i18n('permission.name')}",value: 'name',maxLength:20,validate:false});
            //引用状态
            condition.push({id: 'isRef',name: 'isRef',type: 'select',text: "${ctp:i18n('permission.auth.isref')}",value: 'isRef',
                items: [{
                    text: "${ctp:i18n('systemswitch.yes.lable')}",//是
                    value: '1'
                }, {
                    text: "${ctp:i18n('systemswitch.no.lable')}",//否
                    value: '0'
                }]
            });
            //启用状态
            condition.push({id: 'isEnabled',name: 'isEnabled',type: 'select',text: "${ctp:i18n('permission.auth.isenabled')}",value: 'isEnabled',
                items: [{
                    text: "${ctp:i18n('common.state.normal.label')}",//启用
                    value: '1'
                }, {
                    text: "${ctp:i18n('common.state.invalidation.label')}",//停用
                    value: '0'
                }]
            });
            
            //定义列表框的宽度
            var width = '15%';
            var nameWidth = '20%';
            if('col_flow_perm_policy' !== category && 'info'!=category){
              width = '12%';
              nameWidth = '22%';
	              if(newEdoc){
	              		//权限类别
		              condition.push({id: 'expressionType',name: 'expressionType',type: 'select',text: "${ctp:i18n('flowperm.edoc.type')}",value: 'expressionType',
		                  items: [{
		                    text: "${ctp:i18n('permission.edoc_new_send_permission_policy')}",//发文
		                    value: 'edoc_new_send_permission_policy'
		                  }, {
		                    text: "${ctp:i18n('permission.edoc_new_rec_permission_policy')}",//收文
		                    value: 'edoc_new_rec_permission_policy'
		                  }, {
		                    text: "${ctp:i18n('permission.edoc_new_change_permission_policy')}",//公文交换
		                    value: 'edoc_new_change_permission_policy'
		                  },{
		                	  text:"${ctp:i18n('permission.edoc_qianbao_permission_policy')}",//签报
		                	  value: 'edoc_new_qianbao_permission_policy'
		                  }]
		                });
	              }else{
	              	//权限类别
		              condition.push({id: 'expressionType',name: 'expressionType',type: 'select',text: "${ctp:i18n('flowperm.edoc.type')}",value: 'expressionType',
		                  items: [{
		                    text: "${ctp:i18n('permission.edoc_send_permission_policy')}",//发文
		                    value: 'edoc_send_permission_policy'
		                  }, {
		                    text: "${ctp:i18n('permission.edoc_rec_permission_policy')}",//收文
		                    value: 'edoc_rec_permission_policy'
		                  }, {
		                    text: "${ctp:i18n('permission.edoc_qianbao_permission_policy')}",//签报
		                    value: 'edoc_qianbao_permission_policy'
		                  }]
		                });
	              }
             }
            //搜索框
            var searchobj = $.searchCondition({
                top:2,
                right:10,
                searchHandler: function(){
                    searchFunc();
                },
                conditions:condition
            });
            //搜索框执行的动作
            function searchFunc(){
                var o = new Object();
                o.configCategory = $('#category').val();
                var choose = $('#'+searchobj.p.id).find("option:selected").val();
                if(choose === 'name'){
                    o.name = $('#name').val();
                }else if(choose === 'isRef'){
                    o.isRef = $('#isRef').val();
                }else if(choose === 'isEnabled'){
                    o.isEnabled = $('#isEnabled').val();
                }else if(choose === 'expressionType'){
                    o.configCategory = $('#expressionType').val();
                }
                o.newEdoc = newEdoc;
                var val = searchobj.g.getReturnValue();
                if(val !== null){
                    $("#permissionList").ajaxgridLoad(o);
                }
            }
          	//定义列表框选项栏目名称
            var colModel = new Array();
            colModel.push({display: 'id',name: 'flowPermId',width: '4%',type: 'checkbox'});
            //节点权限名称
            colModel.push({display: "${ctp:i18n('permission.name.label')}",name: 'label',width: nameWidth});
            //权限类别
            if('col_flow_perm_policy'!==category && 'info'!==category){
                colModel.push({display: "${ctp:i18n('flowperm.edoc.type')}",name: 'categoryName',width: width});
            }
            //权限类型
            colModel.push({display: "${ctp:i18n('permission.type')}",name: 'typeName',width: width});
            //位置
            colModel.push({display: "${ctp:i18n('permission.location.label')}",name: 'locationName',width: width});
            //是否引用
            colModel.push({display: "${ctp:i18n('permission.isref')}",name: 'isRefName',width: width});
            //是否启用
            colModel.push({display: "${ctp:i18n('permission.isenabled')}",name: 'isEnabledName',width: width});
            //意见必填
            colModel.push({display: "${ctp:i18n('permission.opinion')}",name: 'opinionPolicyName',width: width});
            //构造列表
             grid = $('#permissionList').ajaxgrid({
                click: showInfo,
                dblclick: dbclickRow,
                colModel: colModel,
                height: 200,
                render : rend,
                showTableToggleBtn: true,
                parentId: $('.layout_center').eq(0).attr('id'),
                vChange: true,
                isHaveIframe:true,
                slideToggleBtn:true,
                onSuccess:function(){
                	if($.trim(grid) != "" && $.trim(grid.p) != ""){
                		$('#summary').attr("src",_ctxPath + "/permission/permission.do?method=settingDesc&size="+grid.p.total);
                		grid.grid.resizeGridUpDown("down");
                	}
                },
                managerName : "permissionManager",
                managerMethod : "select"
            });
             function rend(txt, data, r, c) {
            		if(c===1){
            			txt = "<span class='grid_black'>"+txt+"</span>";
            		}
            		return txt;
            }
            function showInfo(row, rowIndex, colIndex) {
                $('#summary').attr("src",_ctxPath + "/permission/permission.do?method=edit&newEdoc=${newEdoc}&operType=change&id="+row.flowPermId);
            }
            //双击事件
            function dbclickRow(){
                updateRow();
            }
            //页面底部说明加载
            $('#summary').attr("src",_ctxPath + "/permission/permission.do?method=settingDesc&size="+grid.p.total);
            //新建节点权限
            function addRow(){
                //将新建页面显示
                $('#summary').attr("src",_ctxPath + "/permission/permission.do?method=newPermission&newEdoc=${newEdoc}&operType=add&category="+$('#category').val());
                grid.grid.resizeGridUpDown('middle');
            }
            //设置公文元素
            function setPolicyRow(){
            	var rows = grid.grid.getSelectRows();
                if(rows.length === 0){
                    $.alert("${ctp:i18n('permission.operation.choose.one')}!");//请选择一条记录
                    return;
                }
                if(rows.length>1){
                    $.alert("${ctp:i18n('permission.operation.choose.onlyone')}!");//只能选择一条记录进行修改
                    return;
                }
                var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "edocElementsCount", false);
                var rs = requestCaller.serviceRequest();
                if(rs=="have"){
                  edocDialog = $.dialog({
                    url:"${path}/edocController.do?method=setPolicy&id="+rows[0].flowPermId,
                    width: 380,
                    height: 480,
                    title: "${ctp:i18n('collaboration.edoc.element')}",
                    targetWindow:getCtpTop()
                  });
                }else{
                  $.alert(rs);
                }
          }
            
          	//V51 F18 信息报送  start
          	//设置信息元素
           	function setInfoPolicyRow() {
				var rows = grid.grid.getSelectRows();
                if(rows.length === 0) {
                    $.alert("${ctp:i18n('permission.operation.choose.one')}!");//请选择一条记录
                    return;
                }
                if(rows.length>1) {
                    $.alert("${ctp:i18n('permission.operation.choose.onlyone')}!");//只能选择一条记录进行修改
                    return;
                }
                var appType = category==='info' ? 32 : (category==='edoc' ? 4 : 1);
                var em = new elementManager();
                var msg = em.checkElementCount(appType);
                if(msg=="have"){
                    infoDialog = $.dialog({
                        url:"${path}/element/element.do?method=setPermissionPolicy&appType="+appType+"&id="+rows[0].flowPermId,
                        width: 380,
                        height: 480,
                        title: "${ctp:i18n('collaboration.info.element')}",
                        transParams: {pwindow:window},
                        targetWindow:getCtpTop()
                    });
                }else {
                    $.alert(msg);
                }
                
          	}
            //V51 F18 信息报送  end
            
            //修改节点权限
            function updateRow(){
                var rows = grid.grid.getSelectRows();
                if(rows.length === 0){
                    $.alert("${ctp:i18n('permission.operation.choose.one')}!");//请选择一条记录
                    return;
                }
                if(rows.length>1){
                    $.alert("${ctp:i18n('permission.operation.choose.onlyone')}!");//只能选择一条记录进行修改
                    return;
                }
                if(rows[0].name =="niwen"){
                	$.alert("拟文权限不允许编辑!");//只能选择一条记录进行修改
                    return;
                }
                grid.grid.resizeGridUpDown('middle');
                $('#summary').attr("src",_ctxPath + "/permission/permission.do?method=edit&newEdoc=${newEdoc}&operType=change&flag=edit&id="+rows[0].flowPermId);
            }
            //删除节点权限
            function deleteRow(){
                var rows = grid.grid.getSelectRows();
                if(rows.length === 0){
                    $.alert("${ctp:i18n('permission.operation.choose.delete.records')}"); //请选择要删除的记录
                    return;
                }
                var pm = new permissionManager();
                var tranObj = new Array();
                for(i=0;i<rows.length;i++){
                    if(rows[i].type == '0'){
                        $.alert("${ctp:i18n('permission.right.not.delete')}");//系统权限无法被删除
                        return;
                    }
                    //判断是否被引用
                    if(rows[i].isRef == '1'){
                        $.alert("${ctp:i18n('permission.operation.isRef')}");//权限已被引用，无法被删除
                        return;
                    }
                    tranObj[i] = rows[i].flowPermId;
                }
                var confirm = $.confirm({
                    'msg': "${ctp:i18n('permission.operation.confirm.delete')}",//确定删除该权限，该操作无法恢复
                    ok_fn: function () { 
                        pm.deletes(tranObj,{
                            success : function(msg){
                                if(msg === ""){
                                    searchFunc();
                                }else{
                                    $.alert(msg);
                                }
                            }, 
                            error : function(request, settings, e){
                                    $.alert(e);
                            }
                         });
                    },
                    cancel_fn:function(){
                        confirm.close();
                    }
                });
            };
        });
    </script>
</head>
<body>
    <div id='layout'>
        <!-- 公文节点权限当前位置，在外部控制，请慎动!!  为什么呢? 谭敏锋加了公文的 -->
        <c:if test="${category=='edoc' }">
            <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F07_edocSystem1',border:false"></div>
        </c:if>
        <c:if test="${category!='edoc' }">
            <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_permission',border:false"></div>
        </c:if>
        <div class="layout_north bg_color f0f0f0" id="north">
            <div id="toolbars"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="permissionList"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" width="100%" height="100%" frameborder="0"  style="overflow-y:hidden"></iframe>
            </div>
        </div>
        <input type="hidden" name="category" id="category" value="${category}">
    </div>
</body>
</html>
