<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2012-12-11 18:17:19#$:
  
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
<%@ include file="parentTasksEvent.js.jsp" %>
<%@ include file="commonTaskEvent.js.jsp" %>
<%@ include file="parentTasks.js.jsp" %>
<script type="text/javascript">
	var isReport="${isReport}";
    $(document).ready(function() {
        initUI();
        initSearchDiv();
        initData();
        initCheckedTask();
    }); 
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
            <div class="common_tabs clearfix margin_t_5 margin_l_5" id="tab_area">
                    <ul class="left" id="tab_list">
                      <c:if test="${param.from ne 'newTask' }">
                          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="changeTab(this)" value="Parent">${ctp:i18n("taskmanage.my")}</a></li>
                          <li><a hideFocus="true" class="last_tab no_b_border" href="javascript:void(0)" onclick="changeTab(this)" value="ParentTellMe">${ctp:i18n("taskmanage.informMe.label")}</a></li>
                          <li><a hideFocus="true" class="last_tab no_b_border" href="javascript:void(0)" onclick="changeTab(this)" value="Sent">${ctp:i18n("taskmanage.assignment")}</a></li>
                       </c:if>
                       <c:if test="${param.from eq 'newTask' }">
                          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0);" value="Parent">${ctp:i18n("taskmanage.task.name.js")}</a></li>
                       </c:if>
                    </ul>
            </div>
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
            <input type="hidden" id="checked_id" name="checked_id" />
        </div>
    </div>
</body>
</html>
