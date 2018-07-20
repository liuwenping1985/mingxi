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
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_js4Rkz.jsp"%>
<title>考勤表</title>
</head>
<body onload="init();">
  <div id="scheduler_here" class="dhx_cal_container"
    style='width: 100%; height: 100%;'>
    <div class="dhx_cal_navline">
   
        <div style="position:absolute; top: 2px; right:255px; margin-top:15px;">
          <div class="dhx_cal_prev_button" id="dhx_cal_prev_button">&nbsp;</div>
          <div class="dhx_cal_date" id="dhx_cal_date"></div>
          <div class="dhx_cal_next_button" id="dhx_cal_next_button">&nbsp;</div>
        </div>
      <span id="top_right">
        <div id="dhx_cal_common_tabs" class="common_tabs clearfix"
          style="position: absolute; top: 12px; right: 75px;">
        
        </div>
      </span>
    </div>
    <div class="dhx_cal_header"></div>
    <div class="dhx_cal_data"></div>
  </div>
</body>
</html>