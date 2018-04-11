<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>会议参照</title>
</head>
<script type="text/javascript">
  var toolbar = null;
  var listDataObj = null;

  /**
   * 初始化列表数据
   */
  function initMeetingTable() {
    listDataObj = $("#meetingList").ajaxgrid({
      render : render,
      resizable : false,
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '5%',
        align : 'center',
        type : 'checkbox'
      }, {
        display : "${ctp:i18n('plan.column.mt_name')}",
        name : 'title',
        sortable : true,
        width : '33%'
      }, {
        display : "${ctp:i18n('plan.grid.label.creator')}",
        name : 'createUserName',
        sortable : true,
        width : '10%'
      }, {
        display : "${ctp:i18n('plan.send.dept')}",
        name : 'sendDepartment',
        width : '10%',
        sortable : true
      }, {
        display : "${ctp:i18n('plan.grid.label.begintime')}",
        name : 'beginDateStr',
        sortable : true,
        width : '12%'
      }, {
        display : "${ctp:i18n('plan.grid.label.endtime')}",
        name : 'endDateStr',
        sortable : true,
        width : '12%'
      }, {
        display : "${ctp:i18n('plan.meeting.place')}",
        name : 'meetingPlace',
        sortable : true,
        width : '10%'
      }, {
        display : "${ctp:i18n('plan.label.reply_state')}",
        name : 'replyStateStr',
        sortable : true,
        width : '7%'
      } ],
      dblclick : doubleClickEvent,
      onSuccess : bindCheckBoxEvent,
      parentId : $('.layout_center').eq(0).attr('id'),
      managerName : "refMeetingManager",
      managerMethod : "selectMeetingList"
    });
  }
  function doubleClickEvent(data, r, c) {
    if(data) {
      openMeeting(data.id);
    }
  }
  function openMeeting(meetingId) {
    var dialog = $.dialog({
      url : _ctxPath + "/mtMeeting.do?method=myDetailFrame&id=" + meetingId +"&isQuote=true&proxy=0&proxyId=-1",
      width : $(getCtpTop()).width() - 100,
      height : $(getCtpTop()).height() - 100,
      title : "${ctp:i18n('plan.desc.viewreferinfo.meeting')}",
      targetWindow : getCtpTop(),
      buttons : [ {
        text : "${ctp:i18n('common.button.close.label')}",
        handler : function() {
          dialog.close();
        }
      } ]
    });
  }
  function render(text, row, rowIndex, colIndex, col) {
    var titleIcon = "";
    if (col.name == "title") {
      titleIcon += text;
      //视频会议图标
      if(row.video == true || row.video == "true") {
        titleIcon += "<span class='ico16 bodyType_videoConf_16'></span>";
      }
      //附件图标
      if(row.hasAttachments == true || row.hasAttachments == "true") {    
          titleIcon += "<span class='ico16 affix_16'></span>";
      }
      //正文内容图片
      if(row.contentType == "OfficeWord") {    
          titleIcon += "<span class='ico16 doc_16'></span>";
      } else if(row.contentType == "OfficeExcel") {    
          titleIcon += "<span class='ico16 xls_16'></span>";
      } else if(row.contentType == "WpsWord") {    
          titleIcon += "<span class='ico16 wps_16'></span>";
      } else if(row.contentType == "WpsExcel") {    
          titleIcon += "<span class='ico16 xls2_16'></span>";
      }
      return titleIcon;
    }
    return text;
  }
</script>

<script type="text/javascript">
  $(document).ready(function() {
    initMeetingTable();
  });
</script>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:0,sprit:false,border:false">
            <input type="hidden" id="list_type" name="list_type" />
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="meetingList" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>