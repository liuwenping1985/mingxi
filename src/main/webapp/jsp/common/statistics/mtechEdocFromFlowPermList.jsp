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
    <script type="text/javascript">
        var grid;
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
        
            //定义列表框的宽度
            var width = '23%';
            var nameWidth = '20%';
          	//定义列表框选项栏目名称
            var colModel = new Array();
            colModel.push({display: 'id',name: 'name',width: '8%',type: 'checkbox'});
            //节点权限名称
            colModel.push({display: "${ctp:i18n('permission.name.label')}",name: 'label',width: nameWidth});
          
            //权限类型
            colModel.push({display: "${ctp:i18n('permission.type')}",name: 'typeName',width: width});
            //位置
            colModel.push({display: "${ctp:i18n('permission.location.label')}",name: 'locationName',width: width});
            //是否启用
            colModel.push({display: "${ctp:i18n('permission.isenabled')}",name: 'isEnabledName',width: width});
 			var selectRow = -1;
            //构造列表
             grid = $('#permissionList').ajaxgrid({
                click: null,
                dblclick: null,
                colModel: colModel,
                height: 200,
                render : rend,
                showTableToggleBtn: true,
                parentId: $('.layout_center').eq(0).attr('id'),
                vChange: true,
                isHaveIframe:true,
                slideToggleBtn:false,
                resizable:false,
                usepager:false,
                onSuccess:function(){
                	if($.trim(grid) != "" && $.trim(grid.p) != ""){
                		$('#summary').attr("src",_ctxPath + "/permission/permission.do?method=settingDesc&size="+grid.p.total);
                		grid.grid.resizeGridUpDown("down");
                		if(selectRow >= 0){
                			$("#permissionList tr").eq(selectRow).find('input:checkbox').attr('checked','checked');
                		}
                	}
                },
                managerName : "permissionManager",
                managerMethod : "select"
            });
            var filter = new Object();
            filter.newEdoc = true;
            filter.configCategory='${type}';
             $("#permissionList").ajaxgridLoad(filter);
            function rend(txt, data, r, c) {
            	if(data.name=='${node}' && data.name !=''){
            		selectRow = r;
            	}
            		if(c===1){
            			txt = "<span class='grid_black'>"+txt+"</span>";
            		}
            		return txt;
            }
         
   
        });
    </script>
</head>
<body>
    <div id='layout'>
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="permissionList"></table>           
        </div>
    </div>
</body>
</html>
