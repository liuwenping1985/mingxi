function initTimeLineDate() {
  return new MxtTimeLine({
    id : 'timeLine',
    height : $('#content_layout_body_right').height(),
    render : 'content_layout_body_right',
    date : timeLineDate[2],
    timeStep : timeLineDate[0],
    searchClick : function() {
      timeLineObjReset(timeLineObj);
    },
    editClick : function() {
      timeLineDialog = $.dialog({
        url : _ctxPath + '/calendar/calEvent.do?method=editTimeLine',
        width : 425,
        height : 180,
        targetWindow : getCtpTop(),
        transParams : {
          searchFunc : timeLineObjReset,
          diaClose : timeLineObjDialogClose,
          timeLineObjResetParam : timeLineObj
        },
        title : $.i18n('calendar.editTimeLine.title'),
        buttons : [ {
          id : "sure",isEmphasize:true,
          text : $.i18n('calendar.sure'),
          handler : function() {
            timeLineDialog.getReturnValue();      
          }
        }, {
          id : "cancel",
          text : $.i18n('calendar.cancel'),
          handler : function() {
            timeLineDialog.close();
          }
        } ]
      });
    },
    maxClick : function() {
      var url = _ctxPath + "/calendar/calEvent.do?method=arrangeTime&type=day";
      var curDayArr = getCurDayStr();
      var curDayStr = curDayArr[0] + "-" + curDayArr[1] + "-" + curDayArr[2];
      url = url + "&selectedDate=" + curDayStr;
      url = url + "&curDay=" + curDayStr;
      $("#main").attr("src",url); 
    },
    action : 'timeLineAction',
    items : timeLineDate[1]
  });
}

function getCurDayStr(){
  var timeSure = timeLineObj.getDate();
  var curDayArr = new Array();
  if(timeSure.year == "" || timeSure.mounth == "" || timeSure.day == ""){
    var _ymd = new Date();
    timeSure.year = _ymd.getFullYear();
    timeSure.mounth = _ymd.getMonth()+1;
    timeSure.day = _ymd.getDate();
  }
  curDayArr[0] = timeSure.year;
  curDayArr[1] = timeSure.mounth;
  curDayArr[2] = timeSure.day;
  return curDayArr;
}

/**
 * 打开计划
 * 
 * @param planId 计划ID
 * @param actionAfterClose 刷新方法名
 * @return
 */
function openPlan(planId, actionAfterClose) {
  var toSrc = _ctxPath + "/plan/plan.do?method=initPlanDetailFrame&planId="
      + planId;
  var ajaxCalEventBean = new calEventManager();
  var res = ajaxCalEventBean.isHasDeleteByType(planId, "plan");
  res = res.toString();
  if (res == "true") {
    var planViewdialog = $.dialog({
      id : 'showPlan',
      url : toSrc,
      width : $(getCtpTop().document).width() - 100,
      height : $(getCtpTop().document).height() - 100,
      title : $.i18n('plan.dialog.showPlanTitle'),
      targetWindow : getCtpTop(),
      buttons : [ {
        text : $.i18n('plan.dialog.close'),
        handler : function() {
          planViewdialog.close();
          if (actionAfterClose instanceof Function) {
            actionAfterClose();
          }
        }
      } ]
    });
  } else {
    var msg;
    if (res == "false") {
      msg = $.i18n('plan.alert.nopotent');
    } else if (res == "absence") {
      msg = $.i18n('plan.alert.deleted');
    }
    $.error({
      'msg' : msg,
      ok_fn : function() {
        if (actionAfterClose instanceof Function) {
          actionAfterClose();
        }
      }
    });
  }

}

/**
 * 时间线执行查看数据的时候调用
 * 
 * @param id 当前数据的ID
 * @param type 六个模块的类型
 */
function timeLineAction(id, type) {
	var calEvent = timeLineObj.getDateObj(id);
    showDate(calEvent,refleshTimeLinePage);
}

/**
 * 六个模块点击查看详细信息
 */
function showDate(calEvent,refleshPage){
  var type = calEvent.type;
  if (type == "event") {
	  if(curUserID!=undefined){
    calEvent.curUserID = curUserID;
    }else{
    	calEvent.curUserID = parent.curUserID;	
    }
    dynamicUpdateCalEventDailog(calEvent,refleshPage);
  } else if (type == "task") {
      viewTaskInfo4Event(calEvent.id,refleshPage);
  } else if (type == "plan") {
    openPlan(calEvent.id,refleshPage);
  } else if (type == "meeting") {
    if(calEvent.canView) {
      if(typeof(curNextDate)=="object") {
        curNextDate = curNextDate.format("yyyy-MM-dd");
      }
      openMeeting(calEvent.id, refleshPage);  
    }
  } else if (type == "collaboration") {
  	//OA-76862
    showSummayDialog(calEvent.id,calEvent.subject,refleshPage);
  } else if (type == "edoc") {
    openEdocByStatus(calEvent.id, calEvent.states,_ctxPath,refleshPage);
  }
}


/**
 * 时间线局部刷新的方法
 * 
 * @param timeLineObj
 */
function timeLineObjReset(timeLineObj) {
  if(timeLineObj != null && typeof(timeLineObj) != "undefined"){
    var curDayArr = getCurDayStr();
    var curDayStr = curDayArr[0] + "-" + curDayArr[1] + "-" + curDayArr[2];
    var timeLineMag = new timeLineManager();
    timeLineMag.getTimeLineResetDate(curDayStr,{
      success : function(listDate){
        timeLineObj.reset({
          date : curDayArr,
          timeStep : listDate[0],
          action : 'timeLineAction',
          items : listDate[1]
        });
      }
    });
    
  }
}

/**
 * 时间线编辑的时候关闭的方法
 */
function timeLineObjDialogClose() {
  timeLineDialog.close();
}

/**
 * 由于时间线的局部刷新方法timeLineObjReset有参数timeLineObj，而每个模块
 * 调用回来执行这个刷新的时候都报timeLineObj这个参数不存在，所以，另外封装了一 层一个不带任何参数的方法代替执行的刷新方法
 */
function refleshTimeLinePage() {
  timeLineObjReset(timeLineObj);
}

/**
 * 查看任务详细信息页面
 * 
 * @param id 任务编号
 */
function viewTaskInfo4Event(id, actionAfterClose) {
  var ajaxCalEventBean = new calEventManager();
  var res = ajaxCalEventBean.isHasDeleteByType(id, "task");
  if (res != null && res != "") {
    $.error({
      'msg' : res,
      ok_fn : function() {
        if (actionAfterClose instanceof Function) {
          actionAfterClose();
        }
      }
    });
  } else {
        var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&isTimeLine=2&from=timeLineDate&taskId="+id;
        var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+id;
		var taskDetailTreeManager_=new taskDetailTreeManager();
		var exitTree=taskDetailTreeManager_.checkTaskTree(id);
		var treeUrl="";
		var hideBtnC = true;
		treeUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+id;
		if(exitTree){
			hideBtnC = false;
		}
		removeAllDialog();
		new projectTaskDetailDialog({"url1":detailUrl,"url2":contentUrl,"url3":treeUrl,"openB":true,"hideBtnC":hideBtnC,"animate":false});
  }
}

/**
 * 打开正文内容
 * 
 * affairId 待办事项的id title dialog的标题，用affair的subject值 actionAfterClose
 * 协同处理完成后需要执行的方法，比如刷新
 */
function showSummayDialog(affairId, title, actionAfterClose) {
  var url = _ctxPath
      + "/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="
      + affairId;
  var width = $(getCtpTop().document).width() - 100;
  var height = $(getCtpTop().document).height() - 50;
  $.dialog({
    url : url,
    width : width,
    height : height,
    title : title,
    id : 'dialogDealColl',
    transParams : {
    	callbackOfEvent : actionAfterClose,
    	window : window
    },
    targetWindow : getCtpTop()
  });
}

/**
 * 查看会议接口
 * 
 * @param id 会议id
 */
var dialogDealColl;
function openMeeting(meetingId, actionAfterClose) {
  var url = _ctxPath + "/mtMeeting.do?method=myDetailFrame&id=" + meetingId;
  /*
  var width = $(getCtpTop().document).width() - 100;
  var height = $(getCtpTop().document).height() - 50;
  dialogDealColl = $.dialog({
    url : url,
    width : width,
    height : height,
    title : '会议',
    targetWindow : getCtpTop(),
    transParams : {
      diaClose : actionAfterClose,
      window : window
    }
  });*/
	//改为多任务窗口形式
	openCtpWindow({'url':url,'id':meetingId});

}

// 5.0对外接口--时间安排，查询某个公文的详细，根据状态判断显示待办还是已办
// 新增参数 actionAfterClose 又外面传的 刷新方法名
function openEdocByStatus(affairId, state, contextPath, actionAfterClose) {
  if (state == '3') { // 待办
    openDetail_edoc('listPending', 'from=Pending&affairId=' + affairId
        + '&from=Pending', contextPath, actionAfterClose);
  } else if ((state == '4')) { // 已办
    openDetail_edoc('', 'from=Done&affairId=' + affairId, contextPath,
        actionAfterClose);
  } else {

  }

}

function openDetail_edoc(subject, _url, contextPath, actionAfterClose) {
  // 'subject'判断是否是交换公文
  if (subject == 'exchange') {
    _url = _url;
  } else {
    _url = contextPath + "/edocController.do" + "?method=detailIFrame&" + _url;

    if ("listPending" == subject || "listReading" == subject || "" == subject) {
      var rv = v3x.openWindow({
        url : _url,
        FullScrean : 'yes',
        //dialogType : 'open'
        dialogType: v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
      });
    } else {
      var rv = v3x.openWindow({
        url : _url,
        FullScrean : 'yes',
        dialogType : v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
      });
    }
  }

  if (rv == "true") {
    if (actionAfterClose instanceof Function) {
      actionAfterClose();
    }
  }

}

/**
 * 访问后台看看数据被删掉了没有
 * 
 * @param id 数据IE
 */
function accessManagerData(id ,eventObj) {
  var ajaxCalEventBean = new calEventManager();
  return ajaxCalEventBean.isHasDeleteByType(id, eventObj);
}

/**
 * 查看事件
 * 
 * @param data 事件对象
 */
var calEventDialogUpdate;
function dynamicUpdateCalEventDailog(data, timeLineObjReset) {
  var res = accessManagerData(data.id ,"event");
  var ajaxTestBean = new calEventManager();
  var isReceiveMember = false;
  var currentUserId = $.ctx.CurrentUser.id;
  isReceiveMember = ajaxTestBean.isReceiveMember(currentUserId, data.id);
  if (res != null && res != "") {
    $.alert({
      'msg' : res,
      ok_fn : function() {
        if(res == "${ctp:i18n('calendar.event.create.had.delete')}"){
          if (timeLineObjReset instanceof Function) {
            timeLineObjReset();
          }
        }
      }
    });
  } else {
    var height = 600;
    if (data.shareType == 1 && data.receiveMemberId == null) {
      height = 500;
    }
    calEventDialogUpdate = $.dialog({
      id : "calEventUpdate",
      url : _ctxPath + '/calendar/calEvent.do?method=editCalEvent&id='
          + data.id,
      width : 600,
      height : height,
      targetWindow : getCtpTop(),
      checkMax : true,
      transParams : {
        diaClose : dialogClose,
        showButton : showBtn,
        isview : "true",
        refleshMethod : timeLineObjReset
      },
      title : $.i18n('calendar.event.search.title'),
      buttons : [ {
        id : "sure",isEmphasize:true,
        text : $.i18n('calendar.sure'),
        handler : function() {
          calEventDialogUpdate.getReturnValue();
        }
      }, {
        id : "update",
        text : $.i18n('calendar.update'),
        handler : function() {
          calEventDialogUpdate.getReturnValue("update");
        }
      }, {
        id : "cancel",
        text : $.i18n('calendar.cancel'),
        handler : function() {
          calEventDialogUpdate.close();
        }
      }, {
        id : "btnClose",
        text : $.i18n('calendar.close'),
        handler : function() {
          calEventDialogUpdate.close();
        }
      } ]
    });
    calEventDialogUpdate.hideBtn("sure");
    calEventDialogUpdate.hideBtn("btnClose");
    calEventDialogUpdate.hideBtn("update");
    calEventDialogUpdate.hideBtn("cancel");
    if(typeof(data.curUserID) == "undefined") {
      data.curUserID = $.ctx.CurrentUser.id;
    }
	  if (data.createUserId != data.curUserID && (isReceiveMember==false || isReceiveMember=="false")) {
	      calEventDialogUpdate.showBtn("btnClose");
	  } else {
	      calEventDialogUpdate.showBtn("update");
	      calEventDialogUpdate.showBtn("cancel");
	  }   
  }
}

function dialogClose(id, reloadDate, timeLineObjReset) {
  calEventDialogUpdate.close();
  if (reloadDate == 'true') {
    if (timeLineObjReset instanceof Function) {
      timeLineObjReset();
    }
  }
}

function showBtn() {
  calEventDialogUpdate.showBtn("sure");
  calEventDialogUpdate.hideBtn("update");
}