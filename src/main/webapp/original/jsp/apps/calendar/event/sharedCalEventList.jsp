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
<title>${ctp:i18n('calendar.event.share.title')}</title>
<style type="text/css">
	a {outline: none; blr: expression(this.onFocus =   this.blur () ); }
	.stadic_head_height {height: 40px;}
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/calendar/js/calEventUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var curTab = "${ctp:toHTML(param.curTab)}";
  var curButtonClick = "all";
  var searchobj;
  var toobar;
  try {
    curButtonClick = window.location.href.split("&")[1].split("=")[1];
    if (curButtonClick == "calEventView") {
      curButtonClick = "all";
    }
  } catch (e) {
    curButtonClick = "all";
  }
  var curTransParams = {
    searchFunc : searchTarget,
    diaClose : viewDialogClose,
    showButton : showBtn,
    curClick : curButtonClick
  };

  var curVal = "";

  $(function() {
    $("#myEvent")
        .ajaxgrid(
            {
              colModel : [
                  {
                    display : 'id',
                    name : 'id',
                    width : '5%',
                    sortable : false,
                    align : 'center',
                    type : 'checkbox'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.calEventType')}",
                    name : 'calEventType',
                    width : '10%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.subject')}",
                    name : 'subject',
                    width : '18%',
                    sortable : true
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
                    width : '10%'
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.shareType')}",
                    name : 'shareType',
                    width : '15%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.createUserName')}",
                    name : 'createUserName',
                    width : '10%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.eventSource')}",
                    name : 'eventSource',
                    width : '10%',
                    sortable : true
                  },
                  {
                    display : "${ctp:i18n('calendar.event.create.states')}",
                    name : 'states',
                    sortable : true,
                    width : '10%',
                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
                  } ],
              render : rend,
              click : dblclk,
              resizable : false,
              parentId : "id",
              managerName : "calEventManager",
              managerMethod : "getMyOwnCalEventInfoBO"
            });
    searchTarget(curButtonClick);
  });

  $().ready(function() {
    toobar = $("#toolbar").toolbar({
      toolbar : [ {
        id : 'all',
        searchHTML : 'curSearchVal',
        name : "${ctp:i18n('calendar.share.event.all')}",
        click : function() {
          buttonSelect("all");
        },
        className : "ico16 allshare_16"
      }, {
        name : "${ctp:i18n('calendar.share.event.department')}",
        id : 'department',
        click : function() {
          buttonSelect("department");
        },
        className : "ico16 deptevent_16"
      }, {
        name : "${ctp:i18n('calendar.share.event.project')}",
        id : 'project',
        click : function() {
          buttonSelect("project");
        },
        className : "ico16 projevent_16"
      }, {
        name : "${ctp:i18n('calendar.share.event.other')}",
        id : 'other',
        click : function() {
          buttonSelect("other");
        },
        className : "ico16 otherevent_16"
      } , {
          name : "${ctp:i18n('calendar.event.create.out')}Excel",
          click : exportToExcel,
          className : "ico16 export_excel_16"
        }
      ]
    });
    toobar.selected(curButtonClick);
  });

  function buttonSelect(curSelected) {
    //if (curButtonClick != curSelected) {
      curVal = "";
      searchobj.g.clearCondition();
   // }
    curButtonClick = curSelected;
    $("#EventListtype").val(curSelected);
    if(typeof(curSelected) != 'undefined' && curSelected == "other"){
      $("#curPeople").val(curSelected);
    }
    searchTarget();
    toobar.unselected();
    toobar.selected(curSelected);
  }

  function searchTarget() {
   var obj = curButtonClick;
    var layout = $("#layout").layout();
    if (obj == 'other') {
      layout.setWest(172);//先设置布局，再设置内容，防止布局计算的问题
      var peopleRelateHtml = "<li class='margin_t_20'><span class=\"ico16 staff_16\"></span> <a id='other' class='display_block margin_t_5' href='javascript:detailPer(\"other\")'><span class='font_bold'>${ctp:i18n('calendar.all')}</span></a></li>";
      var ajaxTestBean = new calEventManager();
      var peopleRelates = ajaxTestBean.getPeopleRelateList();
      if (peopleRelates != null) {
        for ( var i = 0; i < peopleRelates.length; i++) {
          peopleRelateHtml = peopleRelateHtml
              + "<li class='margin_t_20'><span class=\"ico16 staff_16\"></span><a id='"
              + peopleRelates[i].id
              + "' class='display_block margin_t_5' href='javascript:detailPer(\""
              + peopleRelates[i].id + "\")'>" + peopleRelates[i].name
              + "</a></li>";
        }
      }
      $("#peopleRelate").html(peopleRelateHtml);
      $("#peopeleList").removeClass("hidden");
      
    } else {
      $("#peopeleList").addClass("hidden");
      layout.setWest(0);
      $("#peopleRelate").html("");
    }
    search(curVal);
  }

  function detailPer(obj) {
  $("#curPeople").val(obj);
    var curHtml = $("#peopleRelate").html();
    curHtml = curHtml.replace("font_bold", "");
    $("#peopleRelate").html(curHtml);
    document.getElementById(obj).innerHTML = "<span class='font_bold'>"
        + document.getElementById(obj).innerHTML + "</span>";
    curButtonClick = obj;
    search(null);
  }

  function selectPerson() {
    $.selectPeople({
      minSize : 0,
      maxSize : 1,
      showMe : false,
      type : 'selectPeople',
      panels : 'Department,Team,Post,Outworker,RelatePeople',
      selectType : 'Member',
      isNeedCheckLevelScope : false,
      text : "${ctp:i18n('common.default.selectPeople.value')}",
      params : {
        text : $("#createUsername").val(),
        value : $("#createUserID").val()
      },
      targetWindow : getCtpTop(),
      callback : function(res) {
        $("#createUsername").val(res.text);
        $("#createUserID").val(res.value);
      }
    });
  }

  $(document)
      .ready(
          function() {
            searchobj = $
                .searchCondition({
                  top : 7,
                  right : 5,
                  searchHandler : function() {
                    curVal = searchobj.g.getReturnValue();
                    search(curVal);
                  },
                  conditions : [
                      {
                        id : 'title',
                        name : 'title',
                        type : 'input',
                        text : "${ctp:i18n('calendar.event.create.subject')}",
                        value : 'subject'
                      },
                      {
                        id : 'signifyType',
                        name : 'signifyType',
                        type : 'select',
                        text : "${ctp:i18n('calendar.event.create.signifyType')}",
                        value : 'signifyType',
                        codecfg : "codeId:'cal_event_signifyType'"
                      },
                      {
                        id : 'beginDate',
                        name : 'beginDate',
                        type : 'datemulti',
                        text : "${ctp:i18n('calendar.event.create.beginDate')}",
                        value : 'beginDate',
                        ifFormat : "%Y-%m-%d",
                        dateTime : false
                      },
                      {
                        id : 'createUsername',
                        name : 'createUsername',
                        type : 'input',
                        text : "${ctp:i18n('calendar.event.share.iframe.createusername')}",
                        value : 'createUsername'
                      },
                      {
                        id : 'states',
                        name : 'states',
                        type : 'select',
                        text : "${ctp:i18n('calendar.state')}",
                        value : 'states',
                        items : [
                            {
                              text : "${ctp:i18n('calendar.all')}",
                              value : '5'
                            },
                            {
                              text : "${ctp:i18n('calendar.event.states.not.end')}",
                              value : '0'
                            } ],
                        codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
                      } ]
                });
            restrictionInputNumber("title", 160);
            restrictionInputNumber("createUsername", 200);
            if (curTab=="other") {
              $("#EventListtype").val("other");
            }
          });
</script>
</head>
<body class="h100b over_hidden page_color">
  <input type="hidden" name="createUserID" id="createUserID" />
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north"
      layout="height:40,maxHeight:100,sprit:false,border:false">
      <div class="stadic_layout_head stadic_head_height">
        <div class="common_search_box right clearfix" id="curSearchVal"></div>
        <div id="toolbar"></div>
      </div>
    </div>
    <div class="layout_center over_hidden list" id="id" layout="border:false">
      <table id="myEvent" style="display: none"></table>
      <form id="ExportEventForm" action=""
        method="post">
        <input type="hidden" id="EventListtype" name="EventListtype" />
        <input type="hidden" id="curPeople" name="curPeople" value="other"/>
      </form>
    </div>
    <div class="layout_west"
      layout="width:0,minWidth:50,maxWidth:300,sprit:false">
      <div id="peopeleList">
        <p class="font_bold font_size12 align_center margin_t_5">${ctp:i18n("calendar.event.share.iframe.other")}</p>
        <ul id="peopleRelate" class="font_size12 align_center">
        </ul>
      </div>
    </div>
  </div>
</body>
</html>