<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<html class="h100b over_hidden">
<head>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_js.jsp"%>
<title>${ctp:i18n('calendar.event.calendar.view.title')}</title>
</head>
<body onload="init();">
<input type="hidden" id="tagetid" name="tagetid" value="${tagetid}">
  <div id="scheduler_here" class="dhx_cal_container"
    style='width: 100%; height: 100%;'>
    <div class="dhx_cal_navline">
    
        <span style="margin-left:50px;margin-top:15px;margin-bottom:15px;position: absolute;font-weight:bold;" >${userName}公开给我的领导日程</span>
        <div style="position:absolute; top: 2px; right:255px; margin-top:15px;">
          <div class="dhx_cal_prev_button" id="dhx_cal_prev_button">&nbsp;</div>
          <div class="dhx_cal_date" id="dhx_cal_date"></div>
          <div class="dhx_cal_next_button" id="dhx_cal_next_button">&nbsp;</div>
        </div>
      <span id="top_right">
        <div id="dhx_cal_common_tabs" class="common_tabs clearfix"
          style="position: absolute; top: 12px; right: 75px;">
          <ul class="left">
            <li class="left"><a hidefocus="true" href="javascript:void(0)"
              class="border_b left" style="padding: 0;">
                <div class="dhx_cal_tab" name="day_tab" id="day_tab"
                  style="text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;"></div>
            </a></li>
            <li class="left"><a hidefocus="true" href="javascript:void(0)"
              class="border_b" style="padding: 0;">
                <div class="dhx_cal_tab" name="week_tab" id="week_tab"
                  style="text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;"></div>
            </a></li>
            <li class="current"><a hidefocus="true"
              href="javascript:void(0)" class="border_b last_tab"
              style="padding: 0;">
                <div class="dhx_cal_tab" name="month_tab" id="month_tab"
                  style="text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;"></div>
            </a></li>
          </ul>
        </div>
      </span>
    </div>
    <div class="dhx_cal_header"></div>
    <div class="dhx_cal_data"></div>
  </div>
</body>
</html>