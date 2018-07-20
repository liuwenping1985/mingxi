<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-16
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/seeyonreport/reporttemplatemanager_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/seeyonreport/reportShowIndex.js${ctp:resSuffix()}"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表数据综合分析</title>

<script type="text/javascript">
	var projectPath = '${path}';
	//搜索框对象
	var searchobj = "";
	//定义setTimeout执行方法,用来区分单击、双击事件
	var timeFn = null;
	//如果是搜索条件查询时，将查询条件返回
	var subject = "${subject}";
	var categoryName = "${categoryName}";
	var categoryId = "${categoryId}";
	var srcFrom = "${srcFrom}";
	$(function(){
		//初始化搜索条件
		init_serach();
		
		//模板分类树页面初始化
		init_tree();
		//将查询条件回填
		if(subject != ""){
			searchobj.g.setCondition('subject', subject);
		}else if(categoryName != ""){
			searchobj.g.setCondition('categoryName', categoryName);
		}
		
	});
	
</script>

</head>
<body class="">
    <div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T7_reportShowIndex'"></div>
        <div class="layout_north" layout="height:30,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="border:true">
            <table width="100%" style="height: 100%">
                <tr>
                    <td class="padding_10" valign="top">
                        <div id="templateTree" class="ztree"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="layout_center" id="center" layout="border:true">
            <iframe id="reportShowDes" width="100%" height="99%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
        </div>
     </div>
</body>
</html>