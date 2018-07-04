<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('calendar.event.create.state.title')}</title>
<script type="text/javascript" src="${path }/apps_res/calendar/js/calEvent_CreateCalEventState.js${ctp:resSuffix()}"></script>
</head>
<body
  onload="loadData(${calEventInfoBO.weeks},${calEventInfoBO.calEventPeriodicalInfo.periodicalType});" style="background:#fafafa;">
  <form id="createCalEventState" action="#">
    <div class="form_area margin_10">
      <table width="100%">
        <tr>
          <th nowrap="nowrap"><label class=margin_r_5>${ctp:i18n('calendar.event.create.state.worktype')}:</label>
          </th>
          <td colspan="3">
            <div class="code_list">
              <div class="common_radio_box clearfix">
                <LABEL class="margin_r_10 hand" for=radio1> <INPUT
                  <c:if test='${calEventInfoBO.calEvent.workType==1}'> 
                    checked </c:if>
                    <c:if test='${canUpdateWorkType==false}'> 
                    disabled</c:if>
                  name="workType" class="workType" value="1" type=radio>&nbsp;${ctp:i18n('calendar.event.create.state.worktype1')}
                </LABEL> <LABEL class="margin_r_10 hand" for=radio2> <INPUT
                  <c:if test='${calEventInfoBO.calEvent.workType==2}'> 
                    checked </c:if>
                    <c:if test='${canUpdateWorkType==false}'> 
                    disabled</c:if>
                  name="workType" class="workType" value="2" type=radio>&nbsp;${ctp:i18n('calendar.event.create.state.worktype2')}
                </LABEL> <LABEL class="margin_r_10 hand" for=radio3> <INPUT
                  <c:if test='${calEventInfoBO.calEvent.workType==3}'> 
                    checked </c:if>
                    <c:if test='${canUpdateWorkType==false}'> 
                    disabled</c:if>
                  name="workType" class="workType" value="3" type=radio>&nbsp;${ctp:i18n('calendar.event.create.state.worktype3')}
                </LABEL>
              </div>
            </div>
          </td>
        </tr>
        <tr>
          <th nowrap="nowrap"><label class=margin_r_5>${ctp:i18n('calendar.event.create.state.Actual.hour')}:</label>
          </th>
          <td colspan="3" width="100%" class=margin_r_5>
            <DIV class="common_txtbox_wrap left" style="width: 80px;">
              <input value="${calEventInfoBO.calEvent.realEstimateTime }"
                type="text" id="realEstimateTime" name="realEstimateTime"
                value="0.0" class="validate"
                validate='type:"number",name:"${ctp:i18n('calendar.event.create.state.Actual.hour')}",notNull:true,minValue:0,maxValue:10000,integerDigits:4,dotNumber:2' />
            </DIV> <span class="margin_5 display_inline-block">${ctp:i18n('calendar.event.create.state.hour')}</span>
          </td>
        </tr>
        <tr>
          <td colspan="4">
            <hr />
          </td>
        </tr>
        <tr>
          <th nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.state.periodical')}:</LABEL>
          </th>
          <td>
            <DIV class=common_selectbox_wrap>
              <select style="width: 90%;font-size:12px;" id="periodical" name="periodical" 
                class="codecfg"
                <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                onchange="choice(this);"
                codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.PeriodicalEnum',defaultValue:${calEventInfoBO.calEventPeriodicalInfo.periodicalType}">
              </select>
            </DIV>
          </td>
          <td colspan="2"></td>
        </tr>
        <tr>
          <th class="margin_r_5" nowrap="nowrap"></th>
          <td colspan="3">
            <div id="periodical1"
              class="<c:if test='${calEventInfoBO.calEventPeriodicalInfo.periodicalType!=1}'> div-float hidden </c:if>">
              ${ctp:i18n('calendar.event.create.state.evenry')}<select id="day"
                name="day" class="codecfg"
                <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.DayEnum',defaultValue:${calEventInfoBO.calEventPeriodicalInfo.dayDate}">
              </select>${ctp:i18n('calendar.event.create.state.day.alarm')}
            </div>
            <div id="periodical2"
              class="<c:if test='${calEventInfoBO.calEventPeriodicalInfo.periodicalType!=2}'> div-float hidden </c:if>">
              <DIV class="common_checkbox_box clearfix ">
                <LABEL class="margin_r_10 hand" for=radio1><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox1 class="dayWeek" name=option value="1"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.seven')}</LABEL>
                <LABEL class="margin_r_10 hand" for=radio2><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox2 class="dayWeek" name=option value="2"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.one')}</LABEL>
                <LABEL class="margin_r_10 hand" for=radio3><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox3 class="dayWeek" name=option value="3"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.two')}</LABEL>
                <LABEL class="margin_r_10 hand" for=radio4><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox4 class="dayWeek" name=option value="4"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.there')}</LABEL>
                <br />
                <br /> <LABEL class="margin_r_10 hand" for=radio4><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox5 class="dayWeek" name=option value="5"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.four')}</LABEL>
                <LABEL class="margin_r_10 hand" for=radio4><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox6 class="dayWeek" name=option value="6"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.five')}</LABEL>
                <LABEL class="margin_r_10 hand" for=radio4><INPUT
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=Checkbox7 class="dayWeek" name=option value="7"
                  type=checkbox>${ctp:i18n('calendar.event.create.state.six')}</LABEL>

              </DIV>
            </div>
            <div id="periodical3"
              class="<c:if test='${calEventInfoBO.calEventPeriodicalInfo.periodicalType!=3}'> div-float hidden </c:if>">
              <div class="common_radio_box clearfix">
                <LABEL class="margin_t_5 hand display_block" for=radio2><INPUT
                  id=workType class="month" name="month"
                  <c:if test='${calEventInfoBO.calEventPeriodicalInfo.swithMonth==1}'> 
                    checked </c:if>
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  value="1" type=radio>${ctp:i18n('calendar.event.create.state.month.alarm')}${curDayDate}${ctp:i18n('calendar.event.create.state.day.alarm')}</LABEL><LABEL
                  class="margin_t_5 hand display_block" for=radio2><INPUT
                  <c:if test='${calEventInfoBO.calEventPeriodicalInfo.swithMonth==2}'> 
                    checked </c:if>
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=workType class="month" name="month" value="2" type=radio><c:if test="${calEventInfoBO.calEventPeriodicalInfo.week!=5}">${ctp:i18n('calendar.event.create.state.month.alarm')}</c:if><c:if test="${calEventInfoBO.calEventPeriodicalInfo.week==5}">${ctp:i18n('calendar.event.create.state.number')}${ctp:i18n('calendar.event.create.month')}</c:if>${numberWeek}${dayWeek}${ctp:i18n('calendar.event.create.state.message')}</LABEL>
              </div>
            </div>
            <div id="periodical4"
              class="<c:if test='${calEventInfoBO.calEventPeriodicalInfo.periodicalType!=4}'> div-float hidden </c:if>">
              <div class="common_radio_box clearfix">
                <LABEL class="margin_t_5 hand display_block" for=radio2><INPUT
                  id=workType class="year" name="year" value="1"
                  <c:if test='${calEventInfoBO.calEventPeriodicalInfo.swithYear==1}'> 
                    checked </c:if>
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  type=radio>${ctp:i18n('calendar.event.create.state.year.alarm')}${calEventInfoBO.calEventPeriodicalInfo.month}${ctp:i18n('calendar.event.create.month')}${curDayDate}${ctp:i18n('calendar.event.create.state.day.alarm')}</LABEL><LABEL
                  class="margin_t_5 hand display_block" for=radio2><INPUT
                  <c:if test='${calEventInfoBO.calEventPeriodicalInfo.swithYear==2}'> 
                    checked </c:if>
                  <c:if test='${calEventInfoBO.isNew==1}'>
                    disabled </c:if>
                  id=workType class="year" name="year" value="2" type=radio>${ctp:i18n('calendar.event.create.state.year.alarm')}${calEventInfoBO.calEventPeriodicalInfo.month}<c:if test="${calEventInfoBO.calEventPeriodicalInfo.week!=5}">${ctp:i18n('calendar.event.create.month.one')}</c:if><c:if test="${calEventInfoBO.calEventPeriodicalInfo.week==5}">${ctp:i18n('calendar.event.create.month')}</c:if>${numberWeek}${dayWeek}${ctp:i18n('calendar.event.create.state.message')}
                </LABEL>
              </div>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4" class="margin_r_5">${ctp:i18n("calendar.event.create.periodicalStyle.label")}:</td>
        </tr>
        <tr>
          <th nowrap="nowrap"><label class=margin_r_5>${ctp:i18n('calendar.event.create.state.beginDate')}:</label>
          </th>
          <TD>
            <div class="common_txtbox_wrap left" style="width: 100px;">
              <input id="beginTime" readonly
                validate='name:"${ctp:i18n('calendar.event.create.state.beginDate')}",notNull:true,type:3'
                name="beginTime" type="text" class="comp validate <c:if test='${calEventInfoBO.isNew==1}'>color_gray2 </c:if>"
                comp="type:'calendar',ifFormat:'%Y-%m-%d'" 
                value="${ctp:formatDate(calEventInfoBO.calEventPeriodicalInfo.beginTime)}" />
            </div>
          </TD>
          <th nowrap="nowrap"><label class=margin_r_5>${ctp:i18n('calendar.event.create.state.endDate')}:</label>
          </th>
          <TD>
            <div class="common_txtbox_wrap left" style="width: 100px;">
              <input id="endTime" name="endTime" readonly
                validate='name:"${ctp:i18n('calendar.event.create.state.endDate')}",notNull:true,type:3'
                type="text" class="comp validate <c:if test='${calEventInfoBO.isNew==1}'>color_gray2 </c:if>"
                comp="type:'calendar',ifFormat:'%Y-%m-%d'" 
                value="${ctp:formatDate(calEventInfoBO.calEventPeriodicalInfo.endTime)}" /><input
                type="hidden" id="curDate"
                value="${ctp:formatDate(calEventInfoBO.curDate)}" /> <input
                type="hidden" id="beginDate"
                value="${ctp:formatDate(beginDate)}" /> <input type="hidden"
                id="beginDateFirst" value="${ctp:formatDate(beginDateFirst)}" />
              <input type="hidden" id="endDate"
                value="${ctp:formatDate(endDate)}" />
            </div>
          </TD>
        </tr>
      </table>
    </div>
  </form>
  <input type="hidden" id="curDayDate" name="curDayDate" value="${curDayDate}"/>
  <input type="hidden" id="cInfoPerInfoWeek" name="cInfoPerInfoWeek" value="${calEventInfoBO.calEventPeriodicalInfo.week}"/>
  <input type="hidden" id="cInfoPerInfoDayWeek" name="cInfoPerInfoDayWeek" value="${calEventInfoBO.calEventPeriodicalInfo.dayWeek}"/>
  <input type="hidden" id="cInfoPerInfoMonth" name="cInfoPerInfoMonth" value="${calEventInfoBO.calEventPeriodicalInfo.month}"/>
  <input type="hidden" id="isNew" name="isNew" value="${calEventInfoBO.isNew}"/>
  <input type="hidden" id="cInfoPerInfoType" name="cInfoPerInfoType" value="${calEventInfoBO.calEventPeriodicalInfo.periodicalType}"/>
</body>
</html>