<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-11
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/seeyonreport/reportConfig.js${ctp:resSuffix()}"></script>
<title>报表数据集</title>
<script type="text/javascript">
	$(document).ready(function(){
		//面包屑
		init_location();
		//初始化搜索
		init_serach();
		//初始化列表
		init_dataSetTable();
	});
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="border:true">
            <table id="reportDataSetTable" style="display: none;"></table>
        </div>
     </div>
</body>
</html>