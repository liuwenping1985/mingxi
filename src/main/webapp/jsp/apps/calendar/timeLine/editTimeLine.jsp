<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('calendar.editTimeLine.title')}</title>
<script type="text/javascript" src="${path}/apps_res/calendar/js/editTimeLine.js"></script>
</head>
<body onload="loadData()" class="over_hidden">
  <form id="calEventPeriodicalRelation" method="post">
    <table align="left" class="font_size12 margin_l_5 margin_t_5" width="100%">
      <tr>
        <td nowrap="nowrap" class="padding_r_5" align="right">${ctp:i18n('calendar.editTimeLine.time.show')}:</td>
        <td width="100%">
            <select id="beginTime" name="beginTime" class="codecfg valign_m" codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.DayTimeShowEnum',defaultValue:${beginTime }"></select> -- 
            <select id="endTime" name="endTime" class="codecfg valign_m" codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.DayTimeShowEnum',defaultValue:${endTime }"></select>
            &nbsp;(${ctp:i18n('calendar.editTimeLine.time.arrange')})
        </td>
      </tr>
      <tr>
        <td nowrap="nowrap" rowspan="6" valign="top" align="right" class="padding_r_5 padding_t_5">${ctp:i18n('calendar.editTimeLine.source')}:</td>
        <c:if test="${plan=='yes' }">
          <td class="padding_t_5">
               <label class="margin_r_10 hand" for="Checkbox1"> 
                    <input id="Checkbox1" class="radio_com" name="timeLineType" value="1" type="checkbox">
                    <a title="" href="javascript:selectCheckBox('Checkbox1')" style="color:black" value="1">${ctp:i18n('calendar.editTimeLine.nomy.plan')}</a>
               </label>
          </td>
        </c:if>
      </tr>
<%--       <c:if test="${meeting=='yes' }"> --%>
        <tr>
          <td class="padding_t_5">
              <label class="margin_r_10 hand" for="Checkbox2">
                    <input id="Checkbox2" class="radio_com" name="timeLineType" value="2" type="checkbox">
                    <a title="" href="javascript:selectCheckBox('Checkbox2')" style="color:black" value="2">${ctp:i18n('calendar.editTimeLine.nomy.meeting')}</a>
              </label>
          </td>
        </tr>
<%--       </c:if> --%>
      <c:if test="${task=='yes' }">
          <tr>
            <td class="padding_t_5">
                <label class="margin_r_10 hand" for="Checkbox3">
                    <input id="Checkbox3" class="radio_com" name="timeLineType" value="3" type="checkbox">
                    <a title="" href="javascript:selectCheckBox('Checkbox3')"  style="color:black" value="3">${ctp:i18n('calendar.editTimeLine.nomy.task')}</a>
                </label>
            </td>
          </tr>
      </c:if>
      <c:if test="${event=='yes' }">
        <tr>
          <td class="padding_t_5">
              <label class="margin_r_10 hand" for="Checkbox4">
                  <input id="Checkbox4" class="radio_com" name="timeLineType" value="4" type="checkbox">
                  <a title="" href="javascript:selectCheckBox('Checkbox4')" style="color:black" value="4">${ctp:i18n('calendar.editTimeLine.nomy.event')}</a>
              </label>
          </td>
        </tr>
      </c:if>
      <tr>
        <td class="padding_t_5">
            <label class="margin_r_10 hand" for="Checkbox5"> 
                <input id="Checkbox5" class="radio_com" name="timeLineType" value="5" type="checkbox">
                <a title="" href="javascript:selectCheckBox('Checkbox5')" style="color:black" value="5">${ctp:i18n("calendar.arrangeTime.collaboration.timed")}</a>
            </label>
        </td>
      </tr>
      <c:if test ="${(v3x:getSysFlagByName('edoc_notShow') != 'true')}">
      <tr>
        <td class="padding_t_5">
            <label class="margin_r_10 hand" for="Checkbox6"> 
                <input id="Checkbox6" class="radio_com" name="timeLineType" value="6" type="checkbox">
                <a title="" href="javascript:selectCheckBox('Checkbox6')" style="color:black" value="6">${ctp:i18n("calendar.arrangeTime.doc.timed")}</a>
            </label>
        </td>
      </tr>
      </c:if>
    </table>
  </form>
  <input type="hidden" id="eventType" name="eventType" value="${eventType}"/>
</body>
<script type="text/javascript">
 var parentWindowData = window.dialogArguments;
 var eventType = eval($("#eventType").val());
</script>
</html>
