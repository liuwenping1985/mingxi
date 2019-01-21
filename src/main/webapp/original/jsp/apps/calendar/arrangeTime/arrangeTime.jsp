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

<html class="h100b">
<title>${ctp:i18n('calendar.arrangeTime.title')}</title>
<head>
  <style type="text/css" media="screen">
      .stadic_head_height {
        height: 30px;
      }
      
      .stadic_body_top_bottom {
        bottom: 0px;
        top: 30px;
      }
  </style>
</head>
<body onLoad="init();" class="bg_color_gray">
  <div class="stadic_layout bg_color_gray" style="font-size: 0;">
    <c:if test="${param.app!='6' }">
      <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_timeArrangelist'"></div>
      <div class="hr_heng"></div>
    </c:if>

    <div id="scheduler_here" class="dhx_cal_container" style="width: 100%; height: ${param.app=='6'?86:100 }%;">
      <div class="dhx_cal_navline">
        <c:if test="${param.app!='6' }">
        	<c:if test="${ctp:hasResourceCode('F09_meetingArrange') == true}">
	          <a id="newMeeting" style="position: relative; z-index: 22;" class="common_button" href="javascript:newMeeting();"><span>${ctp:i18n("calendar.arrangeTime.newmeeting")}</span></a>
        	</c:if>
        	<c:if test="${ctp:hasResourceCode('F02_planListHome') == true}">
        	  <a id="newPlan" class="common_button  resCode" style=" position: relative; z-index: 22;" href="javascript:newPlan();"><span>${ctp:i18n("calendar.arrangeTime.newplan")}</span></a>
        	</c:if>
	        <c:if test="${hasNewTaskPurview == true}">
	          <a id="newTask" class="common_button  resCode" style=" position: relative; z-index: 22;" href="javascript:newTask();"><span>${ctp:i18n("calendar.arrangeTime.newtask")}</span></a>
	        </c:if>
	        <c:if test="${ctp:hasResourceCode('F02_eventlist') == true}">
	          <a id="newEvent" class="common_button  resCode" style=" position: relative; z-index: 22;" href="javascript:AddCalEvent();"><span>${ctp:i18n("calendar.event.view.add")}</span></a>
	        </c:if>
        </c:if>

        <c:if test="${param.app=='6' }">
          <div id="personTab" class="common_tabs clearfix border_r" style="padding-left: 50px; padding-top: 5px;">
            <ul></ul>
          </div>
        </c:if>

        <div id="cal_date_area" style="${param.app!='6'?'position:absolute; z-index:2; top: 2px; right:554px; margin-top:15px;':'position:absolute; right:15px;'}">
          <div class="dhx_cal_prev_button" id="dhx_cal_prev_button${ctp:toHTML(param.app) }" style="">&nbsp;</div>
          <div class="dhx_cal_date" id="dhx_cal_date" style="${param.app!='6'?'':'right:51px;'}"></div>
          <div class="dhx_cal_next_button" id="dhx_cal_next_button" style="">&nbsp;</div>
        </div>

        <span id="top_right" style="${param.app!='6'?'':'display:none'}">
          <div id="dhx_cal_common_tabs" class="common_tabs clearfix" style="position: absolute; z-index:0;top: 12px; right: 0; width:100%;">
            <ul class="right" style="margin-right: 75px;">
              <li class="left">
                <a hidefocus="true" href="javascript:void(0)" class="border_b left" style="padding: 0;">
                    <div class="dhx_cal_tab" name="day_tab" id="day_tab" style="color:#414141;text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;${param.app!='6'?'right: 204px;':'display:none'}"></div>
                </a>
              </li>
              <li class="left">
                <a hidefocus="true" href="javascript:void(0)" class="border_b" style="padding: 0;">
                    <div class="dhx_cal_tab" name="week_tab" id="week_tab" style="color:#414141;text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;${param.app!='6'?'right: 140px;':'display:none'}"></div>
                </a>
              </li>
              <li class="current">
                <a hidefocus="true" href="javascript:void(0)" class="border_b last_tab" style="padding: 0;">
                    <div class="dhx_cal_tab" name="month_tab" id="month_tab" style="color:#414141;text-align: center; position: initial; top: initial; white-space: initial; padding: 0 10px; position: static;${param.app!='6'?'right: 76px;':'display:none'}"></div>
                </a>
              </li>
            </ul>
          </div>
          <div href="#" class="common_drop_list dhx_cal_type right" name="more_tab" id="more_tab" style="${param.app!='6'?'':'display:none;'} width:16px;z-index:10;" >
              <span class="ico16 time_management_example_16 right" id="itemize"></span>
          </div>
          <div class="common_drop_list dhx_cal_type right" style="top:34px;">
              <div class="common_drop_list_content common_drop_list_content_action hidden dhx_cal_content right" id="itemize_content">
                <c:if test="${ctp:hasResourceCode('F02_planListHome') == true}">
	                <a title="" href="javascript:void(0)" class="resCode" value="1" style="text-indent: 0">
	                      <span class="dhx_cal_type_color cal_plan">■</span>${ctp:i18n("calendar.arrangeTime.plan")}
	                </a>
                </c:if>
                
                <c:if test="${hasViewTaskPurview == true and ctp:hasResourceCode('F02_projecttask') == true}">
                  <a title="" href="javascript:void(0)" class="resCode" value="2" style="text-indent: 0">
                      <span class="dhx_cal_type_color cal_task">■</span>${ctp:i18n("calendar.arrangeTime.ztask")}
                  </a>
                </c:if>
                <c:if test="${ctp:hasResourceCode('F09_meetingArrange') == true}">
	                <a title="" href="javascript:void(0)" class="resCode" value="0" style="text-indent: 0">
	                      <span class="dhx_cal_type_color cal_meeting">■</span>${ctp:i18n("calendar.arrangeTime.meeting")}
	                 </a>
                 </c:if>
                 <c:if test="${ctp:hasResourceCode('F02_eventlist') == true}">
	                <a title="" href="javascript:void(0)" value="3" class="resCode" style="text-indent: 0">
	                      <span class="dhx_cal_type_color cal_event">■</span>${ctp:i18n("calendar.arrangeTime.event")}
	                 </a>
                 </c:if>
            </div>
            </div>
        </span>
      </div>
      <div class="dhx_cal_header"></div>
      <div class="dhx_cal_data"></div>
    </div>
    <!-- scheduler_here -->
    <!-- 我的会议日程视图(请不要动我的代码) -->
    <c:if test="${param.app=='6' }">
      <div align='left' class="bg-advance-bottom bg_color_gray padding_t_5" style="height: 30px;">
          <font class="margin_lr_5 left" style="display: block; margin-top: 3px; font-size: 12px;">${ctp:i18n("meeting.view.others.label")}:</font>
          <input type="hidden" id="othersId" value="${ctp:toHTML(param.perIds) }" /> 
          <c:set var="selectLabel" value="<${ctp:i18n('meeting.view.others.select')}>" />
          <input type="text" id="othersName" class="input-100per hand" width="100" value="${empty param.perNames || param.perNames == ''? selectLabel : param.perNames}" onClick="selectOtherPeople('others', 'othersId');" />
      </div>
      <!-- bg-advance-bottom -->
    </c:if>
  </div>
  <!-- stadic_layout -->
</body>
</html>