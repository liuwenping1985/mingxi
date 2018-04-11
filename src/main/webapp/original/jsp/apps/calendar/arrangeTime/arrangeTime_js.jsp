<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_js.jsp"%>
<c:if test="${ctp:hasPlugin('taskmanage')}">
	<%--
		//OA-85302:时间视图显示为NULL 
	--%>
	<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp" %>
</c:if>
<c:if test="${param.app =='6' }">
	<jsp:include page="/WEB-INF/jsp/meeting/view/arrangeTime_js.jsp"/>
</c:if>
<style type="text/css" media="screen">
  html,body {
    margin: 0px;
    padding: 0px;
    height: 100%;
    width: 100%;
  }
</style>
<script type="text/javascript" src="${path}/apps_res/calendar/js/arrangeTime_js.js${ctp:resSuffix()}"></script>
<input type="hidden" id="arrangePage" name="arrangePage" value="${arrangePage}"/>