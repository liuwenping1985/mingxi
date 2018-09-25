  var dialogCalEventEntrust; //委托dialog
  var dialogCalEventDelete; //删除dialog

  /**
   * 加渲染
   * 页面列表生成列的时候，根据加载的属性，再加一些显示
   */
  function rend(txt, data, r, c, col) {
    var clm = col.name;
    if (clm == 'subject') { //标题
      return data.subject;
    } else { //其他属性直接返回即可，是VO对象的直接属性
      return txt;
    }
  }

  /**
   * 用户查看事件的时候，可能会点击修改，如果用户点击了修改，就会执行这个方法
   * 先将修改按钮隐藏、然后把确定按钮显示出来
   */
  function showBtn() {
    dialogCalEventUpdate.showBtn("sure");
    dialogCalEventUpdate.hideBtn("update");
    dialogCalEventUpdate.showBtn("cancel");
    dialogCalEventUpdate.hideBtn("btnClose");
    dialogCalEventUpdate.setTitle($.i18n('calendar.update.event'));
  }

  /**
   * 用户执行双击操作事件的方法
   */
  function dblclk(data, r, c) {
    var ajaxTestBean = new calEventManager();
    var res = ajaxTestBean.isHasDeleteByType(data.calEvent.id, "event");
    var isReceiveMember = ajaxTestBean.isReceiveMember($("#createUserId").val(),data.calEvent.id);
    if (res != null && res != "") {
      $.alert({
        'msg' : res,
        ok_fn : function() {
          if(res == $.i18n('calendar.event.create.had.delete')){
            window.location.reload(true);
          }
        }
      });
    } else {
      var height = 600;
      //如果当前事件并没有涉及到多人，则高度设置为480，如果涉及了多人，事件本身的窗口需要增加一个回复功能，所以这里有高度的设定
      if (data.calEvent.shareType == 1 && data.calEvent.receiveMemberId == null) {
        height = 500;
      }
      dialogCalEventUpdate = dynamicUpdateCalEventDailog(height, data);

      //刚开始将四个按钮全部影藏，然后根据情况才展示按钮
      dialogCalEventUpdate.hideBtn("sure");
      dialogCalEventUpdate.hideBtn("btnClose");
      dialogCalEventUpdate.hideBtn("update");
      dialogCalEventUpdate.hideBtn("cancel");
      //如果用户是创建事件的用户，则，刚用户拥有这个事件的全部属性
      if (data.calEvent.createUserId == $("#createUserId").val()||isReceiveMember) {
    	  dialogCalEventUpdate.showBtn("update");
    	  dialogCalEventUpdate.showBtn("btnClose");
      } else { //反之，则只有查看功能   	
        dialogCalEventUpdate.showBtn("btnClose");
      }
    }
  }

  /**
   * 生成事件修改窗口
   */
  function dynamicUpdateCalEventDailog(height, data) {
    var dialogCalEventUpdate = $.dialog({
      url : _ctxPath + '/calendar/calEvent.do?method=editCalEvent&id='
          + data.calEvent.id,
      width : 600,
      height : height,
      checkMax : true,
      targetWindow : getCtpTop(),
      title : $.i18n('calendar.event.search.title'),
      transParams : curTransParams,
      buttons : [ {
        id : "sure",isEmphasize:true,
        text : $.i18n('calendar.sure'),
        handler : function() {
        	var isFalse = dialogCalEventUpdate.getReturnValue();
        	if(isFalse){
        		dialogCalEventUpdate.disabledBtn("sure");
        	}   
        }
      }, {
        id : "update",
        text : $.i18n('calendar.update'),
        handler : function() {
          dialogCalEventUpdate.getReturnValue("update");
        }
      }, {
        id : "cancel",
        text : $.i18n('calendar.cancel'),
        handler : function() {
          dialogCalEventUpdate.close();
        }
      }, {
        id : "btnClose",
        text : $.i18n('calendar.close'),
        handler : function() {
          dialogCalEventUpdate.close();
        }
      } ]
    });
    return dialogCalEventUpdate;
  }

  /**
   * 委托事件事件之间会选择多个事件进行操作，将这些事件的ID组合起来
   * 
   */
  function entrust() {
    var vid = $("#myEvent").formobj({
      gridFilter : function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    return vid;
  }

  /**
   * 删除多个事件、委托多个事件，将事件的ID以逗号，即","分隔，组合后将这个字符串传给后台
   */
  function toAllIds(vid) {
    var ids = null;
    for ( var i = 0; i < vid.length; i++) {
      if (i == 0) {
        ids = vid[i].calEvent.id;
      } else {
        ids = ids + "," + vid[i].calEvent.id;
      }
    }
    return ids;
  }

  /**
   * 个人事件————委托事件
   */
  function addDialogCalEventEntrust(ids) {
    dialogCalEventEntrust = $
        .dialog({
          url : _ctxPath + "/calendar/calEvent.do?method=entrustCalEvent&id="
              + ids,
          width : 360,
          height : 320,
          targetWindow : getCtpTop(),
          transParams : {
            searchFunc : search,
            diaClose : viewDialogClose
          },
          title : $.i18n('calendar.event.list.cancel.event.client'),
          buttons : [ {
            id : "sure",
            text : $.i18n('calendar.sure'),
            handler : function() {
              dialogCalEventEntrust.getReturnValue();

            }
          }, {
            id : "cancel",
            text : $.i18n('calendar.cancel'),
            handler : function() {
              dialogCalEventEntrust.close();
            }
          } ]
        });
  }

  /**
   *个人事件列表—————— 删除事件
   */
  function addDialogCalEventDelete(curId) {
    dialogCalEventDelete = $.dialog({
      url : _ctxPath + "/calendar/calEvent.do?method=deleteCalEventTip&id="
          + curId,
      width : 300,
      height : 80,
      targetWindow : window.parent,
      transParams : {
        searchFunc : search,
        diaClose : viewDialogClose
      },
      title : $.i18n('calendar.tip'),
      buttons : [ {
        id : "sure",
        text : $.i18n('calendar.sure'),isEmphasize:true,
        handler : function() {
        dialogCalEventDelete.disabledBtn('sure');
          dialogCalEventDelete.getReturnValue();

        }
      }, {
        id : "cancel",
        text : $.i18n('calendar.cancel'),
        handler : function() {
          dialogCalEventDelete.close();
        }
      } ]
    });

  }

  /**
   * 导出excel方法
   */
  function exportToExcel() {
	var curPeople = $("#curPeople").val();
  	var EventListtype = $("#EventListtype").val();//事件列表类型
    var count = $("#myEvent")[0].rows.length;
    if (count < 1) {
      $.alert($.i18n('calendar.event.list.toexcel'));
      return false;
    }
    if(typeof(continueValue) == 'undefined'){
      var createUserId = $("#createUserId").val();
      if($("#createMemberId").val() != undefined) {
        if($("#createMemberId").val().length > 0){
          createUserId = $("#createMemberId").val();
        }
      }
      var beginDate = $("#beginDate").val();
      continueValue = "createUserIDF8:"+createUserId+"!beginDate:"+beginDate+","+beginDate;
    }
    if(EventListtype == "8") {
      $("#conditionText").val();
      $("#firstQueryValueText").val();
      $("#secondQueryValueText").val();
      if($("#conditionText").val().length > 0) {
        continueValue = $("#conditionText").val()+":";
        if($("#firstQueryValueText").val().length > 0) {
          continueValue += $("#firstQueryValueText").val();
        }
        if($("#secondQueryValueText").val().length > 0) {
          continueValue += "," + $("#secondQueryValueText").val();
        }
      }
    }
    if(typeof(curTab)=="undefined"){       
    	$("#deleteCalEvent").attr("action",
                "calEvent.do?method=exportToExcel&continueValue=" + continueValue+"&EventListtype="+EventListtype);
        $("#deleteCalEvent").jsonSubmit();
    }else{
    	if (curTab=="other") {
    		curTab = "all";
    	}
	    if(curTab=="all"){//共享事件导出    	
	            $("#ExportEventForm").attr("action",
	                    "calEvent.do?method=exportToExcel&continueValue=" + continueValue+"&curTab="+curTab+"&EventListtype="+EventListtype+"&curPeople="+curPeople);
	            $("#ExportEventForm").jsonSubmit();
	    }else if(curTab =="leaderSchedule"){
	    	$("#deleteCalEvent").attr("action",
	                "calEvent.do?method=exportToExcel&continueValue=" + continueValue+"&curTab="+curTab+"&EventListtype="+EventListtype+"&curPeople="+curPeople);
	        $("#deleteCalEvent").jsonSubmit();
	    }else{//个人事件导出
	        $("#deleteCalEvent").attr("action",
	                "calEvent.do?method=exportToExcel&continueValue=" + continueValue+"&curTab="+curTab+"&EventListtype="+EventListtype);
	        $("#deleteCalEvent").jsonSubmit();
	    }
    }
  }
  /**
   * 搜索方法
   */
  function search(curVal) {
    var o = new Object();
    if (curVal == "calEventStatis") { //统计页面的搜索条件
      o.statisticsType = $("#statisticsType").val();
      o.states = $("#states").val();
      o.endDate = $("#endDate").val();
      o.beginDate = $("#beginDate").val();
      o.testSearch = $("#testSearch").val();
    } else if (curVal == "calEventStatis4F8") { //f8那边有个穿透，会到列表中显示
      o.beginDate = $("#beginDate").val();
      o.createUserId = $("#createUserId").val();
    } else {
      o.createUserID = $("#createUserId").val();
      //这个是共享事件,全部共享/他人共享,哪个按钮被选中的标示
      if (typeof (curButtonClick) != 'undefined') {
        o.search = curButtonClick;
        if (curVal == null) {
        	o.newp = 1;
        }
      }
      if (curVal != null) {
        if (curVal.condition == 'subject') {
          o.subject = curVal.value;
        }
        if (curVal.condition == 'workType') {
          o.workType = curVal.value;
        }
        if (curVal.condition == 'signifyType') {
          o.signifyType = curVal.value;
        }
        if (curVal.condition == 'beginDate') {
          var dates = curVal.value;
          o.beginDate = dates[0];
          o.endDate = dates[1];
        }
        if (curVal.condition == 'states') {
          o.states = curVal.value;
        }
        if (curVal.condition == 'calEventType') {
          o.calEventType = curVal.value;
        }
        if (curVal.condition == 'createUsername') {
          o.createUsername = curVal.value;
        }
        continueValue = curVal.condition + ":" + curVal.value;
      }
    }
    $("#myEvent").ajaxgridLoad(o);
  }