<%--
 $Author:wanguangdong$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title>项目任务更多页面</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<style>
.stadic_head_height {
    height: 0px;
}

.stadic_body_top_bottom {
    bottom: 0px;
    top: 30px;
}
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/TaskUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/listTaskInfo_index.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
        initSearch();
        initDataList();
        initToolBar();
    });
</script>
</head>
<body class="h100b page_color" >
<input type="hidden" name="projectId" id="projectId" value="${param.projectId}">
<input type="hidden" name="projectPhaseId" id="projectPhaseId" value="${param.projectPhaseId}">
<input type="hidden" name="beginDate" id="beginDate" value="${beginDate}">
<input type="hidden" name="endDate" id="endDate" value="${endDate}">
<input type="hidden" id="managersValueText" name="managersValueText" />
<input type="hidden" id="createUserValueText" name="createUserValueText" />
<input type="hidden" id="participatorsValueText" name="participatorsValueText" />
<input type="hidden" id="inspectorsValueText" name="inspectorsValueText" />
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
           <div class="common_search_box right clearfix" id="curSearchVal"></div>
        </div>
        <div id="toolbar"></div>
            <input type="hidden" id="conditionText" name="conditionText" />
            <input type="hidden" id="firstQueryValueText" name="firstQueryValueText" />
            <input type="hidden" id="secondQueryValueText" name="secondQueryValueText" />
    </div>
    
    <div class="stadic_layout_body stadic_body_top_bottom list" id="id" style="overflow: hidden;">
        <table id="departmentTask" class="flexme3" style="display: none"></table>
        <div id="grid_detail">
            <iframe src="" id="moreListTaskInfo_iframe" width="100%" height="100%" frameborder="0"></iframe>
        </div>
        <iframe id="exportExcelIframe" name="exportExcelIframe" frameborder="0" marginheight="0" marginwidth="0" style="visibility: visible;"></iframe>
    </div>
</body>
</html>