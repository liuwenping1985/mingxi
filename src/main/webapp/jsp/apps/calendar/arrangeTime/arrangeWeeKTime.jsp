<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/calendar/arrangeTime/arrangeTime_js.jsp"%>
<html>
<title>${ctp:i18n('calendar.event.calendar.view.title')}</title>
<head>
<style>
  .dhx_cal_prev_button,.dhx_cal_next_button,.dhx_cal_date {
    margin-top: 0px;
  }
</style>
</head>
<body onload="init();">
  <div id="scheduler_here" class="dhx_cal_container" style='width: 100%; height: 100%;'>
    <div class="dhx_cal_navline" style="padding-left: 210px;">
      <div id="cal_date_week_area" style="position:absolute; top: 2px; right:255px;">
        <div class="dhx_cal_prev_button" id="dhx_cal_prev_button">&nbsp;</div>
        <div class="dhx_cal_date" id="dhx_cal_date"></div>
        <div class="dhx_cal_next_button" id="dhx_cal_next_button">&nbsp;</div>
        <div class="dhx_cal_tab hidden"></div>
      </div>
    </div>
    <div class="dhx_cal_header"></div>
    <div class="dhx_cal_data"></div>
  </div>
</body>
</html>