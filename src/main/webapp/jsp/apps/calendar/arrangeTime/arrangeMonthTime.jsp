<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%-- <%@ include file="/WEB-INF/jsp/apps/calendar/arrangeTime/arrangeTime_js.jsp"%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b over_hidden" style="height:100%;overflow:hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<title>${ctp:i18n('calendar.event.calendar.view.title')}</title>
<style type="text/css">
  .dhx_cal_prev_button,.dhx_cal_next_button,.dhx_cal_date {
        margin-top: 0px;
  }
  html,body {
    margin: 0px;
    padding: 0px;
    height: 100%;
    width: 100%;
  }
</style>
</head>
<body onload="init();" style="height:100%;overflow:hidden;" class="bg_color_none">
  <div id="scheduler_here" class="dhx_cal_container" style='overflow:hidden; width: 100%; height: 100%;margin-top:-1px;'>
      <div class="dhx_cal_navline">
        <div style="position:absolute; top: 2px; left:50%; margin-left:-70px;">
          <div class="dhx_cal_prev_button" id="dhx_cal_prev_button">&nbsp;</div>
          <div class="dhx_cal_date" id="dhx_cal_date" style="right:273px;"></div>
          <div class="dhx_cal_next_button" id="dhx_cal_next_button">&nbsp;</div>
          <div class="dhx_cal_tab hidden" style="right: 76px;"></div>
        </div>
      </div>
      <div class="dhx_cal_header" id="dhx_cal_header"></div>
      <div class="dhx_cal_data" style="border-left: 1px solid #d2d2d2;"></div>
  </div>
  <div id="showEvent" class="hidden h100b padding_lr_5">
      <p class="hidden padding_l_5 padding_t_5" id="all_DayTitle">${ctp:i18n('calendar.portal.tip')}:</p>
      <ul id="allday_event" class="padding_l_5 padding_tb_5"></ul>
      <ul class="border_t_dashed padding_l_5 padding_t_5" id="oneday_event"></ul>
  </div>
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
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Create_addData_js.js"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/showTimeLineData.js"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Create_js.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/scheduler/dhtmlxscheduler-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/scheduler/<%=locale%>-debug.js"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/arrangeTime_js.js"></script>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp"%>
<script>
	var calevents = eval(<c:out value="${calevents}" default="null" escapeXml="false"/>);

    $(function () {
        //火狐浏览器，样式兼容js
        var ff_hasEvent_true = setInterval(function () {
            var _obj = $(".hasEvent_true");
            if (_obj.size() > 0) {
                _obj.css({ "position": "relative" });
                $(".dhx_cal_data td").css("line-height", $(".dhx_cal_data td").height() + "px");
                //处理ie8无边线
                $(".dhx_cal_data td").removeClass("relative");
                //清除计时器
                clearInterval(ff_hasEvent_true);
            }
        }, 200);
        //缺少左侧边线问题
        setTimeout(function(){
          $("#dhx_cal_header").css("left",0);
          $(".dhx_cal_data").css("height","auto");
        },100);
    })
</script>
</html>