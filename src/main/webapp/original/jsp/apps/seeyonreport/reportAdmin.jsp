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
<title>报表管理员设置</title>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="comp" comp="type: 'breadcrumb', code: 'T7_reportAdminManager', comptype: 'location'"></div>
        <div class="layout_north" layout="height:40,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_center" id="center" layout="border:true">
            <table id="reportAdminTable" style="display: none;"></table>
        </div>
     </div>
</body>
<script type="text/javascript" src="${path}/common/seeyonreport/reportAdmin.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(document).ready(function(){
    initToolbox();
	initSearchBox();
    initTable();
});
</script>
</html>