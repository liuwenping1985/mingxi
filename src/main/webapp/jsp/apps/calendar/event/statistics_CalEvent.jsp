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
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<html>
<head>
<title>${ctp:i18n('calendar.event.Statistics.title')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=calEventManager"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/statistics_CalEvent.js"></script>
</head>
<body class="page_color">
  <form id="statistics" action="" method="post" class="form_area" width="100%">
    <fieldset class="page_color">
      <legend class="font_bold padding_t_5">${ctp:i18n("calendar.event.show.statis.con")}</legend>
      <table align="center">
        <tr>
          <th nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n("calendar.event.show.statis.fanw")}:</LABEL>
          </th>
          <td style="width:160px;">
              <div class="common_txtbox_wrap"><input id="beginDate" readonly="readonly" type="text" class="comp validate"
                  validate='name:"${ctp:i18n('calendar.event.create.beginDate')}",notNull:true,type:5' comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" />
              </div>
          </td>
          <th nowrap="nowrap"><LABEL class="margin_r_5" for=text>&nbsp;&nbsp;${ctp:i18n("calendar.event.Statistics.toEnd")}&nbsp;</LABEL>
          </th>
          <td style="width:160px;">
            <div class="common_txtbox_wrap"><input id="endDate" readonly="readonly" type="text" class="comp validate" 
                validate='name:"${ctp:i18n('calendar.event.create.endDate')}",notNull:true,type:5' comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" />
            </div>
          </td>
        </tr>
        <tr>
          <th nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.state')}:</LABEL>
          </th>
          <td colspan="3"><DIV class=common_selectbox_wrap>
              <select id="states" name="states" class="codecfg"
                codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'">
                <option value="5">${ctp:i18n("calendar.all")}</option>
                <option value="0">${ctp:i18n("calendar.event.states.not.end")}</option>
              </select>
            </DIV></td>
        </tr>
        <tr>
          <th nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.show.statis.style')}:</LABEL>
          </th>
          <td colspan="3"><DIV class=common_selectbox_wrap>
              <select id="statisticsType">
                <option value="1">${ctp:i18n('calendar.event.create.signifyType')}</option>
                <option value="2">${ctp:i18n('calendar.event.create.calEventType')}</option>
              </select>
            </DIV></td>
        </tr>
        <tr>
          <th nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.show.statis.sumstyle')}:</LABEL>
          </th>
          <td colspan="3"><DIV class=common_selectbox_wrap>
              <select id="statisticsSumType">
                <option value="1">${ctp:i18n('calendar.event.show.statis.count')}</option>
                <option value="2">${ctp:i18n('calendar.event.show.statis.sumcount')}</option>
              </select>
            </DIV></td>
        </tr>
      </table>

    </fieldset>
    <div class="align_center margin_tb_5">
      <a onclick="toStatistics();" class="common_button common_button_gray"
        href="javascript:void(0)">${ctp:i18n('calendar.sure')}</a>
    </div>
  </form>
  <table border="0" class="font_size12 padding_t_10" align="center" width="800">
    <tr>
      <td valign="top" width="500">
        <div id="tttt" class="border_all h100b margin_5"
          style="width: 400px; height: 300px; margin: 0 auto; background: #fff;"></div>
      </td>

      <td valign="top" class="padding_l_10 align_left">
        <div id="statisticContent">
          <c:forEach items="${calEvents}" var="calEvent" varStatus="status">
            <a href="javascript:showDate(${calEvent.receiveMemberId });">
              ${calEvent.receiveMemberName } </a>
            <p style="height: 20px;" class="padding_l_10 padding_tb_10">${ctp:i18n("calendar.event.create.state.no")}</p>
          </c:forEach>
        </div>
      </td>
    </tr>
  </table>
</body>
</html>