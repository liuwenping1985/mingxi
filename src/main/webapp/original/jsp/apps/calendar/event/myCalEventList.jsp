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
<html class="h100b">
<head>
<title>${ctp:i18n('calendar.event.list.title')}</title>
<style type="text/css">
.stadic_head_height {height: 40px;}
.stadic_body_top_bottom{ overflow:hidden; bottom: 0px; top: 40px;}
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/calendar/js/calEventUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var isList = {isList: "isList"};
var curTab = "${param.curTab}";
var searchobj;
var curTransParams = {
   searchFunc : search,
   diaClose : viewDialogClose,
   showButton : showBtn,
   isHasConVal : "Yes"
};
var continueValue = "";
  $(function() {
	//工具栏
	$("#toolbar").toolbar({
        toolbar : [{
        	searchHTML : 'curSearchVal',
            name : "${ctp:i18n('calendar.event.create.add')}",
            click : function() {
            	AddCalEvent(null,null,null,null,null,null,null,null,isList);
            },
            className : "ico16"
         },{
            name : "${ctp:i18n('calendar.event.create.Entrust')}",
            click : function() {
            	var vid = entrust();
                var ids = toAllIds(vid);
                if (ids == null) {
                  $.alert("${ctp:i18n('calendar.event.list.cancel.tip')}！");
                } else {
                  var calEventBean = new calEventManager();
                  var res = calEventBean.entrustMeg(ids);
                  if (res != null && res != "") {
                    $.alert(res);
                  }else{
                    addDialogCalEventEntrust(ids);
                  }
                }
              },
              className : "ico16 entrust_16"
        },{
          	name : "${ctp:i18n('calendar.event.create.delete')}",
              click : function() {
              	$("#deleteCalEvent").attr("action", "calEvent.do?method=deleteCalEvent");
                  var vid = entrust();
                  var ids = toAllIds(vid);
                  if (ids == null) {
                    $.alert("${ctp:i18n('calendar.event.list.delete.tip')}！");
                  } else {
                  	var curId = ids.split(",");
                   if (curId.length == 1 && vid[0].calEvent.periodicalStyle != 0) {
                   	if(vid.length > 0) {
                         var currentUserId = $.ctx.CurrentUser.id;
                         for(var k=0;k<vid.length;k++) {
                             var calEvt = vid[k].calEvent;
                             if(calEvt.createUserId.indexOf(currentUserId) < 0) {
                                 $.alert("${ctp:i18n('calendar.error.please.reselect.4')}！");
                                 return;
                             }
                         }
                   }     
                      addDialogCalEventDelete(curId);
                    } else {
                      // 只有创建人才可能删除事件 by xiangq
                      if(vid.length > 0) {
                          var currentUserId = $.ctx.CurrentUser.id;
                          for(var k=0;k<vid.length;k++) {
                              var calEvt = vid[k].calEvent;
                              if(calEvt.createUserId.indexOf(currentUserId) < 0) {
                                  $.alert("${ctp:i18n('calendar.error.please.reselect.4')}！");
                                  return;
                              }
                          }
                      }
                      var confirm = $.confirm({
                            'msg': "${ctp:i18n('calendar.event.create.deleteToSure')}",
                            ok_fn: function() {
                              $("#formId").val(ids);
                              $("#deleteCalEvent").jsonSubmit({
                              	callback : function(res) {
                              		if (res != null && res != "") {
                                            if (res.indexOf("${ctp:i18n('calendar.event.create.had.delete')}") > 0) {
                                              $.alert({
                                              	'msg' : "${ctp:i18n('calendar.event.create.had.delete')}",
                                                  ok_fn : function() {
                                                      search(searchobj.g.getReturnValue());
                                                    }
                                                  });
                                            } else {
                                              $.alert(res);
                                            }
                                          } else {
                                            search(searchobj.g.getReturnValue());
                                            confirm.close();
                                          }
                                        }
                                      });
                            },
                            cancel_fn : function() {
                              confirm.close();
                            }
                      });
                  }
                  }
                },
              className : "ico16 del_16"
          },{
         		name : "${ctp:i18n('calendar.event.create.out')}Excel",
         		click : exportToExcel,
         		className : "ico16 export_excel_16"
       	}
    ]});
	//搜索框
	searchobj = $.searchCondition({
		top : 7,
      	right : 5,           
      	searchHandler : function() {
      		search(searchobj.g.getReturnValue());
      	},
      	conditions : [{
            id : 'title',
            name : 'title',
            type : 'input',
            text : "${ctp:i18n('calendar.event.create.subject')}",
            value : 'subject'
        },{
            id : 'workType',
            name : 'workType',
            type : 'select',
            text : "${ctp:i18n('calendar.event.create.workType')}",
            value : 'workType',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.WorkTypeEnum'"
        },{
            id : 'signifyType',
            name : 'signifyType',
            type : 'select',
            text : "${ctp:i18n('calendar.event.create.signifyType')}",
            value : 'signifyType',
            codecfg : "codeId:'cal_event_signifyType'"
        },{
            id : 'beginDate',
            name : 'beginDate',
            type : 'datemulti',
            text : "${ctp:i18n('calendar.event.create.beginDate')}",
            value : 'beginDate',
            ifFormat : "%Y-%m-%d",
            dateTime : false
        },{
            id : 'states',
            name : 'states',
            type : 'select',
            text : "${ctp:i18n('calendar.state')}",
            value : 'states',
            items : [{
                  text : "${ctp:i18n('calendar.all')}",
                  value : '5'
                },{
                  text : "${ctp:i18n('calendar.event.states.not.end')}",
                  value : '0'
                } ],
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
        },{
            id : 'calEventType',
            name : 'calEventType',
            type : 'select',
            text : "${ctp:i18n('calendar.event.create.calEventType')}",
            value : 'calEventType',
            codecfg : "codeId:'cal_event_type'"
          }]
    });
	restrictionInputNumber("title", 160);
	//初始化表格
    $("#myEvent").ajaxgrid({
    	colModel : [{
           display : 'id',
           name : 'id',
           width : '5%',
           sortable : false,
           align : 'center',
           type : 'checkbox'
         },{//事件类型
           display : "${ctp:i18n('calendar.event.create.calEventType')}",
           name : 'calEventType',
           width : '10%',
           sortable : true
         },{//标题
           display : "${ctp:i18n('calendar.event.create.subject')}",
           name : 'subject',
           sortable : true,
           width : '23%'
         },{//重要程度
           display : "${ctp:i18n('calendar.event.create.signifyType')}",
           name : 'signifyType',
           width : '10%',
           sortable : true
         },{//开始时间
           display : "${ctp:i18n('calendar.event.create.beginDate')}",
           name : 'beginDate',
           sortable : true,
           width : '10%'
         },{//所属人
           display : "${ctp:i18n('calendar.event.create.createUserName')}",
           name : 'createUserName',
           sortable : true,
           width : '10%'
         },{//事件来源
           display : "${ctp:i18n('calendar.event.create.eventSource')}",
           name : 'eventSource',
           sortable : true,
           width : '10%'
         },{//事件状态
           display : "${ctp:i18n('calendar.event.create.states')}",
           name : 'states',
           width : '10%',
           sortable : true,
           codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
         },{//重复周期
           display : "${ctp:i18n('calendar.event.create.state.periodical')}",
           name : 'periodicalStyle',
           sortable : true,
           width : '10%',
           codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.PeriodicalEnum'"
         } ],
         render : rend,
         click : dblclk,
         resizable : false,
         parentId : "id",
         managerName : "calEventManager",
         managerMethod : "getMyOwnCalEventInfoBO"
       });
    search(null);
  });
</script>
</head>
<body class="h100b page_color">
  <div id='layout' class="comp stadic_layout" comp="type:'layout'">
    <div class="stadic_layout_head stadic_head_height" layout="border:false,height:40,maxHeight:100">
      <div class="common_search_box right clearfix" id="curSearchVal"></div>
      <div id="toolbar"></div>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom over_hidden" layout="border:false" id="id">
      <table id="myEvent" style="display: none"></table>
      <form id="deleteCalEvent" action="calEvent.do?method=deleteCalEvent" method="post">
        <input type="hidden" id="formId" name="formId" /> 
        <input type="hidden" id="checkVal" name="checkVal" value="1" />
      </form>
    </div>
  </div>
</body>
</html>