<%--
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=projectConfigManager,projectQueryManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectConfigList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectConfigListEvent.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
    	//showCtpLocation("F02_projectPersonPage");
        initToolBar();
        initSearchDiv();
        initData();
    }); 
</script>
</head>
<body>
	<input type="hidden" id="canAdd" value="${canAdd}"/>
	<div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_projecttask'"></div>
    </div>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north page_color" layout="height:40,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="projectConfigList" class="flexme3" style="display: none"></table>
        </div>
    </div>
    <iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>
