<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-11
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/seeyonreport/reporttemplatemanager_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/seeyonreport/reportTemplateIndex.js${ctp:resSuffix()}"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
	var projectPath = '${path}';
	var isAdmin = '${isAdmin}';
	var curUserId = "${CurrentUser.id}";
	//获得需要展开的节点
	var expandNodeId = "${expandNodeId}";
	//能否修改、删除操作
	var canEdit = true;
	//定义setTimeout执行方法,用来区分单击、双击事件
	var timeFn = null;
	//选中的模板分类及其子节点的模板分类ID
	var categoryIds = "";
	//工具栏对象
	var toolbar = "";
	//模板列表对象
	var reportGrid = "";
	//搜索框对象
	var searchobj = "";
	$(function(){
		//面包屑
		init_location();
		
		//初始化toolbar
		init_toolbar();
		
		//初始化搜索条件
		init_serach();
		
		//初始化绑定报表模板列表,
		init_reportTemplateList();
		
		//模板分类树页面初始化
		init_tree();
		
	});
	
</script>

</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="border:true">
            <table width="100%" style="height: 100%">
                <tr>
                    <td class="  padding_10" valign="top">
                        <div id="templateTree" class="ztree"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="layout_center" id="center" style="overflow:hidden;" layout="border:false">
            <table id="reportTemplateTable" style="display: none;"></table>
            <div id="grid_detail">
                <iframe id="templateOperDes" width="100%" height="100%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
            </div>
        </div>
     </div>
</body>
</html>