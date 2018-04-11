<%--
 $Author:  翟锋$
 $Rev:  $
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
<title>首页设计</title>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/spaceDesignIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=pageLayoutManager"></script>
<script type="text/javascript">
	$(function(){
		//初始化toolbar
		initToolbar();
		//初始化查询
		initSearch();
		//初始化列表
		initGridTable();
	}) 
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'T3_spaceDesignIndex'"></div>
    	<div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
      		<div id="toolbar"></div>
    	</div>
    	<div class="layout_center" id="center">
      		<table class="flexme3"id="mytable"></table>
      		<div id="grid_detail">
        		<iframe id="viewFrame" class="calendar_show_iframe" src="" frameborder="0" style="width: 100%; height: 100%"></iframe>
      		</div>
    	</div>
  	</div>
</body>
</html>
