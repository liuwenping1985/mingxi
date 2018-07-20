<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2013-01-11 18:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n("taskmanage.parentTask.select")}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/listTasks.js${ctp:resSuffix()}"></script>
<%@ include file="commonTaskEvent.js.jsp" %>
<script type="text/javascript">   
    $(document).ready(function() {
        initListData();
        initToolBar();
    }); 
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="taskInfoList" class="flexme3" style="display: none"></table>
        </div>
        <form action="#" id="queryConditionForm" name="queryConditionForm" style="margin:0;padding:0; height:0px" method="post" target="main">  
            <input type="hidden" id="task_list_content" name="task_list_content" value="1111111"/>  
         </form>
        <input type="hidden" id="isReport" name="isReport" value="${isReport}"/>
    </div>
</body>
</html>
