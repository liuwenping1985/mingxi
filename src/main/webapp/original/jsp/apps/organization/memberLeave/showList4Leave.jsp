<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=memberLeaveManager' />"></script>
<script type="text/javascript">
<!--
$().ready(function() {
    var t = $("#mytable").ajaxgrid({
        colModel : [
            {
              display : "${ctp:i18n('common.subject.label')}",
              name : 'subject',
              width : '58%'
            }, 
            {
              display : "${ctp:i18n('common.sender.label')}",
              name : 'senderName',
              width : '20%'
            },
            {
              display : "${ctp:i18n('common.date.sendtime.label')}",
              name : 'sendDate',
              width : '20%'
            }
        ],
        managerName : "memberLeaveManager",
        managerMethod : "listPendingData",
        height: 362
    });

    var o = new Object();
    o.memberId = "${param.memberId}";
    o.key = "${param.key}";
    $("#mytable").ajaxgridLoad(o);

    //搜索框
  var searchobj = $.searchCondition({
    id:'table4Search',
    top:2,
    right:10,
    searchHandler: function() {
      var s = searchobj.g.getReturnValue();
      if(s==null) {
        return;
      } else {
        s.memberId = "${param.memberId}";
        s.key = "${param.key}";
        var choose = $('#'+searchobj.p.id).find("option:selected").val();
        s.condition = choose;
        if(choose === 'subject') {
          s.subject = s.value;
        } else if(choose === 'senderName'){
          s.senderName = s.value;
        } else if(choose === 'sendDate') {
          var fromDate = $.trim(s.value[0]);
          var toDate = $.trim(s.value[1]);
          if(fromDate != "" && toDate != "" && fromDate > toDate){
              $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能早于结束时间
              return;
          }
          s.sendDate = "sendDate";
          s.textfield = fromDate;
          s.textfield1 = toDate;
        }
        $("#mytable").ajaxgridLoad(s);
      }
    },
    conditions: [{
      id: 'search_title',
      name: 'search_title',
      type: 'input',
      text: '${ctp:i18n("cannel.display.column.subject.label")}',//标题
      value: 'subject'
    },
    {
      id: 'search_member',
      name: 'search_member',
      type: 'input',
      text: '${ctp:i18n("common.sender.label")}',//发起人
      value: 'senderName'
    },
    {
      id: 'search_startDate',
      name: 'search_startDate',
      type: 'datemulti',
	  ifFormat:'%Y-%m-%d',
      text: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
      value: 'sendDate'
    }]
  });
});
//-->
</script>
</head>
<body>
  <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div id="table4Search"></div>
        </div>
        <div class="layout_center over_hidden" layout="border:false" id="center">
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div id="grid_detail">
            </div>
        </div>
    </div>
</body>
</html>