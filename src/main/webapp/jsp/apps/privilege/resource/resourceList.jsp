<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: 2014-01-20 16:45:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/apps/privilege/resource/resourceList_js.jsp"%>
<html>
<head>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'T02_resource'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">
      <div id="toolbar" class="border_b"></div>
    </div>
    <div id="layoutCenter" class="layout_center over_hidden" layout="border:false">
    <div class="common_tabs clearfix" id="tabs">
        <ul class="left">
            <li class="current"><a id="tab1" hidefocus="true" href="javascript:void(0)" class="no_b_border">系统资源</a></li>
            <li><a id="tab2" hidefocus="true" href="javascript:void(0)" class="last_tab no_b_border">自定义资源</a></li>
        </ul>
    </div>
     
            <table id="mytable" class="mytable" style="display: none"></table>
      </div>
    </div>
</body>
</html>
