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
<title>${ctp:i18n("calendar.event.list.title")}</title>
<script type="text/javascript">
  var curTransParams = {
    searchFunc : search,
    diaClose : viewDialogClose,
    showButton : showBtn,
    curPageName : "calEventStatis4F8"
  };
  $(function() {
    $("#myEvent")
        .ajaxgrid(
            {
              colModel : [                  
                  {
                    display : "${ctp:i18n('calendar.event.create.calEventType')}",
                    name : 'calEventType',
                    align : 'center',
                    width : '10%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.subject')}",
                    name : 'subject',
                    sortable : true,
                    width : '15%'
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
                    width : '16%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.createUserName')}",
                    name : 'createUserName',
                    sortable : true,
                    width : '15%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.eventSource')}",
                    name : 'eventSource',
                    sortable : true,
                    width : '10%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.states')}",
                    name : 'states',
                    width : '10%',
                    sortable : true,
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
              managerMethod : "getStatisticCalEventInfoBOF8"
            });
    //search("calEventStatis4F8");
  });
  function printCalEvent(){
      var printSubject ="";
        var printsub = "${ctp:i18n('calendar.event.list.toexcel.title')}";
        printsub = "<center><span style='font-size:24px;line-height:24px;'>"+printsub.escapeHTML()+"</span><hr style='height:1px' class='Noprint'&lgt;</hr></center>";
        
        var printColBody= "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
        var colBody= convertTable();
        // var printSubFrag = new PrintFragment(printColBody,printsub );   
        var  colBodyFrag= new PrintFragment(printSubject, colBody); 
        
        var cssList = new ArrayList();
        cssList.add("/apps_res/collaboration/css/collaboration.css")
        
        var pl = new ArrayList();
        // pl.add(printSubFrag);
        pl.add(colBodyFrag);
        printList(pl,cssList)
  }
  
  function convertTable(){  
      var mxtgrid = $("#id");
      var str = "";
      if(mxtgrid.length > 0 ){
          var tableHeader = jQuery(".hDivBox thead");               
          var tableBody = jQuery(".bDiv tbody");
          var headerHtml =tableHeader.html();
          var bodyHtml = tableBody.html();
          if(headerHtml == null || headerHtml == 'null'){
              headerHtml ="";
          }
          if(bodyHtml == null || bodyHtml=='null'){
              bodyHtml="";
          }
          bodyHtml = bodyHtml.replace(/text_overflow/g,'word_break_all');
          str+="<table class='only_table edit_table font_size12' border='0' cellspacing='0' cellpadding='0'>"
          str+="<thead>";
          str+=headerHtml;
          str+="</thead>";
          str+="<tbody>";
          str+=bodyHtml;
          str+="</tbody>";
          str+="</table>";
      }
      return str;
  } 
  
  function toBeanCollection(){
      $("#title").val("");
      var curHtml = convertTable();
      $("#contentHtml").val(curHtml);
      $("#deleteCalEvent").attr("action","calEvent.do?method=reportForwardCol");
      $("#deleteCalEvent").submit();
  }
  $().ready(
      function() {
        $("#toolbar")
            .toolbar(
                {
                  toolbar : [
                      {
                        name : "${ctp:i18n('report.queryReport.index_right.toolbar.synergy')}",
                        click : toBeanCollection,
                        className : "ico16 forwarding_16"
                      },
                      {
                        name : "${ctp:i18n('calendar.event.create.out')}Excel",
                        click : exportToExcel,
                        className : "ico16 export_excel_16"
                      },
                      {
                        name : "${ctp:i18n('report.queryReport.index_right.toolbar.print')}",
                        click : printCalEvent,
                        className : "ico16 print_16"
                      } ]

                });
      });
</script>
</head>
<body class="page_color h100b over_hidden">
 <div id='layout' class="comp" comp="type:'layout'">
      <input type="hidden" name="createMemberId" id="createMemberId" value="${createUserId}" />
      <input type="hidden" name="beginDate" id="beginDate" value="${beginDate}" />
       <form id="deleteCalEvent" action="" method="post" target="main">
            <input type="hidden" name="title" id="title"  />
            <input type="hidden" name="contentHtml" id="contentHtml"  />
       </form>
      <div class="layout_north" layout="border:false,height:30,maxHeight:100,minHeight:30">
          <div id="toolbar"></div>
      </div>
      <div class="layout_center stadic_layout_body stadic_body_top_bottom list" id="id" layout="border:false">
            <table id="myEvent" style="display: none"></table>
      </div>      
  </div>
</body>
</html>