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
<title>完成情況</title>
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEventStateForPortal.js"></script>
</head>
<body>
  <div class="form_area margin_10">
    <form id="stateInitDate" action="calEvent.do?method=saveCalEventState">
      <table width="100%">
        <tr>
          <TH nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.completeRate')}:</LABEL></TH>
          <td width="50%" class="padding_r_10"><label
            class="right valign_m margin_t_5 margin_l_5">%</label>
            <DIV class=common_txtbox_wrap>
              <input class="validate"
                validate='type:"number",name:"${ctp:i18n('calendar.event.create.completeRate')}",notNull:true,minValue:0,maxValue:100,isInteger:true'
                type="text" name="completeRate" id="completeRate" />
            </DIV> <input type="hidden" id="id" name="id" /></td>
          <th nowrap="nowrap"><label class=margin_r_5>${ctp:i18n('calendar.event.create.state.Actual.hour')}:</label>
          </th>
          <td class=margin_r_5 width="50%"><label
            class="right valign_m margin_t_5 margin_l_5">${ctp:i18n('calendar.event.create.state.hour')}</label>
            <DIV class="common_txtbox_wrap">
              <input id="realEstimateTime" name="realEstimateTime" value="0.0"
                class="validate"
                validate='type:"number",name:"${ctp:i18n('calendar.event.create.state.Actual.hour')}",notNull:true,minValue:0,maxValue:10000,integerDigits:4,dotNumber:2' />
            </DIV></td>
        </tr>
        <tr>
          <TH nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.states')}:</LABEL></TH>
          <td>
            <DIV class=common_selectbox_wrap>
              <select id="states" name="states" class="codecfg" style="font-size:12px;" 
                onchange="statesChoice(this);"
                codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum',defaultValue:0">
              </select>
            </DIV>
          </td>
          <TH nowrap="nowrap"></TH>
          <td>&nbsp;</td>
        </tr>
      </table>
    </form>
  </div>
</body>
</html>