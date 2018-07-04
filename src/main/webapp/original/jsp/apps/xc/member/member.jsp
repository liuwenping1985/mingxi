<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>MemberManagerment</title> 
<%@ include file="/WEB-INF/jsp/apps/xc/member/member_js.jsp"%>
</head>
<body>
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'xc004'"></div>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
            <div id="toolbar"><input type="hidden" id="apiKey" value='${apiKey}'></div>
            <div id="searchDiv"></div>
        </div>
        <div class="layout_west" id="west" layout="width:200">
            <div id="deptTree"></div>
        </div>
        <div class="layout_center over_hidden" layout="border:false" id="center">
            <table id="memberTable" class="flexme3" style="display: none"></table>
           
        </div>
    </div>
    <iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>