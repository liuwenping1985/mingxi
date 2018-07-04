<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_js.jsp"%>
<html class="h100b over_hidden">
<head>
	<title>${ctp:i18n('calendar.event.calendar.view.title')}</title>
    <script type="text/javascript">
         var relateMemberID = "${relateMemberID}";
    </script>
</head>
<body onload="init();" class="h100b over_hidden">
  <div class="stadic_layout bg_color_gray" style="height:100%;">
      <div class=common_crumbs>
          <span class=margin_r_10>${ctp:i18n('calendar.iframe.cur.place')}:</span>
          <a href="${path}/relateMember.do?method=relateMemberInfo&memberId=${relateMemberID}&relatedId=${curMemberID}">${relateMemberName }</a>
          <span class=margin_lr_5>-</span>
          <a href="${path}/calendar/calEvent.do?method=calEventView4RelateMember&curTab=relateMember&curDate=${curDate}&relateMemberID=${relateMemberID} ">${ctp:i18n('calendar.event.calendar.view.title')}</a>
      </div>
      <div id="scheduler_here" class="dhx_cal_container" style='width:100%;height:97%;*height:97%' >
          <div class="dhx_cal_navline" style="height:100%">
            <div class="dhx_cal_date hidden" id="dhx_cal_date"></div>
            <span id="top_right">
          <div id="dhx_cal_common_tabs" class="common_tabs clearfix" style="position: absolute; z-index:10;top: 0px; right: 0; width:100%;">
            <ul class="right" style="margin-right: 75px;">
                  <li class="left">
                      <a hidefocus="true" href="javascript:void(0)" class="border_b left" style="padding: 0;">
                          <div class="dhx_cal_tab" name="day_tab" id="day_tab" style="text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;"></div>
                      </a>
                  </li>
                  <li class="left">
                      <a hidefocus="true" href="javascript:void(0)" class="border_b" style="padding: 0;">
                           <div class="dhx_cal_tab" name="week_tab" id="week_tab" style="text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;"></div>
                      </a>
                  </li>
                  <li class="current">
                      <a hidefocus="true" href="javascript:void(0)" class="border_b last_tab" style="padding: 0;">
                         <div class="dhx_cal_tab" name="month_tab" id="month_tab" style="text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;"></div>
                      </a>
                  </li>
                </ul>
              </div>
            </span>
          </div>
          <div class="dhx_cal_header" style="margin-top: 2px;"></div>
          <div class="dhx_cal_data"></div>
      </div>
  </div>
</body>
</html>