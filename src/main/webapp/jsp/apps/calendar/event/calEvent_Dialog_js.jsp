<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include
  file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_addData_js.jsp"%>
<style>
.stadic_head_height {
  height: 30px;
}

.stadic_body_top_bottom {
  bottom: 0px;
  top: 30px;
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=calEventManager"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Dialog_js.js"></script>
<input type="hidden" id="createUserId" name="createUserId" value="${CurrentUser.id}"/>
