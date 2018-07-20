<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style type="text/css" media="screen">
  html,body {
    margin: 0px;
    padding: 0px;
    height: 100%;
    width: 100%;
  }
</style>
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Create_addData_js.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=calEventManager"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/showTimeLineData.js"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Create_js4Rkz.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/scheduler/dhtmlxscheduler-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/scheduler/<%=locale%>-debug.js"></script>


<input type="hidden" id="type" name="type" value="${type}">
<input type="hidden" id="currentUserId" name="currentUserId" value="${CurrentUser.id}">
<input type="hidden" id="year" name="year" value="${year}">
<input type="hidden" id="month" name="month" value="${month}">
<input type="hidden" id="day" name="day" value="${day}">
<input type="hidden" id="arrangePage" name="arrangePage" value="${arrangePage}">
<input type="hidden" id="iniHour" name="iniHour" value="${iniHour}">
<input type="hidden" id="source" name="source" value="${source}">
<input type="hidden" id="banben" name="banben" value="${banben}">
<input type="hidden" id="param_app" name="param_app" value="${param.app}">
<script type="text/javascript">
	var calevents = eval(<c:out value="${calevents}" default="null" escapeXml="false"/>);
</script>
