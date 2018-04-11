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
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Dialog_js.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n("calendar.event.show.statis.title")}</title>
<script type="text/javascript">
  var curTransParams = {
    searchFunc : search,
    diaClose : viewDialogClose,
    showButton : showBtn,
    curPageName : "calEventStatis"
  };

  $(function() {
    $("#myEvent")
        .ajaxgrid(
            {
              colModel : [
                  {
                    display : "${ctp:i18n('calendar.event.create.calEventType')}",
                    name : 'calEventType',
                    width : '10%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.subject')}",
                    name : 'subject',
                    sortable : true,
                    width : '25%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.signifyType')}",
                    name : 'signifyType',
                    width : '10%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.beginDate')}",
                    name : 'beginDate',
                    sortable : true,
                    width : '15%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.createUserName')}",
                    name : 'createUserName',
                    sortable : true,
                    width : '10%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.eventSource')}",
                    name : 'eventSource',
                    sortable : true,
                    width : '10%'
                  },
                  {
                    display : "${ctp:i18n('calendar.state')}",
                    name : 'states',
                    sortable : true,
                    width : '10%',
                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.state.periodical')}",
                    name : 'periodicalStyle',
                    sortable : true,
                    width : '10%',
                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.PeriodicalEnum'"
                  } ],
              render : rend,
              click : dblclk,
              parentId : $('.list').eq(0).attr('id'),
              managerName : "calEventManager",
              managerMethod : "getStatisticsCalEventInfoBO"
            });
    search("calEventStatis");
  });
</script>
</head>
<body class="page_color h100b over_hidden">
  <input type="hidden" name="testSearch" id="testSearch" value="${testSearch}" />
  <input type="hidden" name="statisticsType" id="statisticsType"
    value="${statisticsType}" />
  <input type="hidden" name="states" id="states" value="${states}" />
  <input type="hidden" name="beginDate" id="beginDate" value="${beginDate}" />
  <input type="hidden" name="endDate" id="endDate" value="${endDate}" />
  <div class=" list h100b" id="id">
    <table id="myEvent" style="display: none"></table>
  </div>
</body>
</html>