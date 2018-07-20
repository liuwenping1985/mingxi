<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>任务信息</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<%@ include file="listTaskInfoEvent.js.jsp" %>
<%@ include file="listTaskInfo.js.jsp" %>
<script type="text/javascript">
	var formType="${param.from}";
    $(document).ready(function() {
        initToolBar();
        initSearchDiv();
        initData();
        initUI();
    }); 
</script>
</head>
<body onkeydown="listenerKeyESC()">
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north page_color" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
            <input type="hidden" id="createUserValueText" name="createUserValueText" />
            <input type="hidden" id="managersValueText" name="managersValueText" />
            <input type="hidden" id="participatorsValueText" name="participatorsValueText" />
            <input type="hidden" id="inspectorsValueText" name="inspectorsValueText" />
            <input type="hidden" id="conditionText" name="conditionText" />
            <input type="hidden" id="firstQueryValueText" name="firstQueryValueText" />
            <input type="hidden" id="secondQueryValueText" name="secondQueryValueText" />
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="taskInfoList" class="flexme3" style="display: none"></table>
            <div id="grid_detail">
                <iframe src="" id="taskinfo_iframe" width="100%" height="100%" frameborder="0"></iframe>
            </div>
        </div>
        <iframe id="exportExcelIframe" name="exportExcelIframe" frameborder="0" marginheight="0" marginwidth="0" style="visibility: visible;"></iframe>
    </div>
</body>
</html>
