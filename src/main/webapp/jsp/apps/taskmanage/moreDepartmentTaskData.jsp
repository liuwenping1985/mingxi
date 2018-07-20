<%--
 $Author: wanguangdong $
 $Rev: 1783 $
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title>部门任务更多页面</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/moreDepartmentTaskData.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
//搜索框
$(document).ready(function() {
    initLayout();
    initSearch();
    initDataList();
    getCtpTop().showMoreSectionLocation("${ctp:i18n("taskmanage.departmentTask")}");
});
</script>
</head>
<body class="h100b page_color">
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div class="border_lr border_t padding_b_5">
                <div class="clearfix">
<%--                     <span id="backLink" class="right ico16 home_16 margin_r_10 margin_t_5" onclick="javascript:getA8Top().main.history.back()" title='${ctp:i18n("common.toolbar.back.label")}'></span> --%>
                    <!-- 返回 -->
                </div>
                <div id="content_text" class="margin_t_10 margin_l_10 font_size14" >&nbsp;</div>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="departmentTask"></table>
        </div>
        <input type="hidden" id="dep_member_id" name="dep_member_id" value="${depMemberIdStr}"/> 
    </div>
</body>
</html>