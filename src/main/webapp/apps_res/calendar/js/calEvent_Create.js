  var curCount;
  var parentWindowData ;
  var flagV3x ; //关联项目标记
  var transParams;
  var dialogReply;
  var isOa;
  $(function(){
	  curCount = 1; //点击高级设置的次数.默认为1
	  parentWindowData = window.dialogArguments;
	  flagV3x = $("#objectFlag").val(); //关联项目标记
	  transParams = null;
	  G6Opeartion();
  });
  try {
    transParams = {
      searchFunc : window.dialogArguments.searchFunc,
      diaClose : window.dialogArguments.dialogClose,
      showButton : window.dialogArguments.showBtn,
      curClick : window.dialogArguments.curClick,
      curPageName : window.dialogArguments.curPageName,
      isHasConVal : window.dialogArguments.isHasConVal,
      sectionID : window.dialogArguments.sectionID,
      isList : window.dialogArguments.isList
    };
  } catch (e) {
    transParams = null;
  }
  function choice(conditionObject) {
    var options = conditionObject.options;
    for ( var i = 0; i < options.length; i++) {
      var d = document.getElementById("shareType" + options[i].value);
      if (d) {
        d.style.display = "none";
      }
    }
    if($("#shareType").val()==="3"){
    	//表示选择了项目事件,显示该元素
    	$("#projectID").show();
    }else{
    	//表示未选择项目事件,隐藏该元素
    	$("#projectID").hide();
    }
    var optionVal = conditionObject.value;
    if(optionVal == 8) {
      optionVal = 4;
    }
    if (!document.getElementById("shareType" + optionVal)){
      return;
    }
    document.getElementById("shareType" + optionVal).style.display = "block";
    if (conditionObject.value == 2 && $("#cInfoShareType").val() != 2) {
      $("#shareTargetDep").val($.i18n('calendar.event.create.department'));
    } else if (conditionObject.value == 4 && $("#cInfoShareType").val() != 4) {
      $("#shareTargetOther").val($.i18n('calendar.event.create.publicToOther'));
    } else if (conditionObject.value == 8 && $("#cInfoShareType").val() != 8) {
      $("#shareTargetOther").val($.i18n('calendar.event.create.publicToOther'));
    }
  }

  function statesChoice(conditionObject) {
    if (conditionObject.value == 4) {
      $("#completeRate").val(100);
      $("#completeRate").attr("disabled", "true");
    } else {
      $("#completeRate").removeAttr("disabled");
    }
  }

  function otherIDFunc(res) {
    $("#other").val(res.text);
    if ($("#other").val() == "" && $("#isEntrust").val() == 1) {
      $("#isEntrust").val(0);
    }
    $("#otherID").val(res.value);
  }

  function shareTargetDepFunc(res) {
    $("#shareTargetDep").val(res.text);
    $("#tranMemberIdsDep").val(res.value);
  }

  function tranMemberIdsOtherFunc(res) {
    $("#shareTargetOther").val(res.text);
    $("#tranMemberIdsOther").val(res.value);
  }

  function selectPerson(curText) {

    var text = "";
    var value = "";
    var panelType = "Department,Team,Post,Outworker,RelatePeople";
    if (curText == 'otherID') {
      test = "Member";
      panelType = "Department,Team,Post,Outworker,RelatePeople";
      func = otherIDFunc;
      text = $("#ctpShowReceiveMemberId").val();
      value = $("#ctpParseReceiveMemberId").val();
      if (value == "") {
        value = $("#otherID").val();
        text = $("#other").val();
      }
    } else if (curText == 'shareTargetDep') {
      test = "Department";
      func = shareTargetDepFunc;
      text = $("#ctpShowTranMemberIds").val();
      value = $("#ctpParseTranMemberIds").val();
      if (value == "") {
        text = $("#shareTargetDep").val();
        value = $("#tranMemberIdsDep").val();
      }
    } else if (curText == 'tranMemberIdsOther') {
      test = "Account,Member,Department";
      panelType = "Department,Team,Post,Outworker,RelatePeople";
      func = tranMemberIdsOtherFunc;
      text = $("#ctpShowTranMemberIds").val();
      value = $("#ctpParseTranMemberIds").val();
      if (value == "") {
        text = $("#shareTargetOther").val();
        value = $("#tranMemberIdsOther").val();
      }
    }
    var openMod = "open";
    if(isOa.indexOf("a8genius.do")>-1){
      openMod = "modal";
    }
    $.selectPeople({
      minSize : 0,
      type : 'selectPeople',
      mode : openMod,
      panels : panelType,
      selectType : test,
      showMe : false,
      isNeedCheckLevelScope : false,
      text : $.i18n('common.default.selectPeople.value'),
      params : {
        text : text,
        value : value
      },
      targetWindow : getCtpTop(),
      callback : function(res) {
        func(res);
      }
    });
  }

  function OK(isupdate) {
    if (isupdate == 'update') {
      toUpdate();
    } else if (flagV3x == "objectFlag") {
      toUpdate();
      parent.document.getElementById("sure").style.display = "";
      parent.document.getElementById("update").style.display = "none";
      flagV3x = "null";//重新赋值下次点页面上确定则执行else里面的代码
    } else {  
      var shareTargetOther = "";
      //shareTargetOther = $("#projectText").val();
      shareTargetOther = $("#projectID").val();
      if ($("#shareType").val() == 3 && shareTargetOther == -1) {
        $.alert($.i18n('calendar.event.create.tip7'));
        return false;
      }
      shareTargetOther = $("#tranMemberIdsOther").val();
      ///
      if($.trim(shareTargetOther)!= ""){
    	  if($("#shareType").val() != 2 && shareTargetOther.indexOf("Department") != -1){
    		  $.alert($.i18n('calendar.share.people.info'));
    		  return false;
    	  }
      }
      ///
      if (($("#shareType").val() == 4 || $("#shareType").val() == 8)&& $.trim(shareTargetOther)== "") {
        $.alert($.i18n('calendar.event.shareType.share.object'));
        return false;
      }
      shareTargetOther = $("#tranMemberIdsDep").val();
      ///
      if($.trim(shareTargetOther)!= ""){
    	  if($("#shareType").val() == 2 && shareTargetOther.indexOf("Member") != -1){
    		  $.alert($.i18n('calendar.share.department.info')); 
    		  return false;
    	  }
      }
      ///
      if ($("#shareType").val() == 2 && $.trim(shareTargetOther)== "") {
        $.alert($.i18n('calendar.event.shareType.department.isNull'));
        return false;
      }

    var fValidate = $("#createCalEvent").validate();
    try{
	  var divid = parent.document.getElementsByTagName('DIV')[0].id+"";
	  var buttonobj = eval("parent.document.getElementById("+divid+")");
	  if($(buttonobj).attr("class").indexOf("dialog_box") < 0) {
      buttonobj.style.display = "none";
	  }
	  }catch(e){
	  
	  }
      if (fValidate) {
        var beginTime = $("#beginTime").val();
        beginTime = beginTime.substring(0,10);
        var endTime = $("#endTime").val();
        endTime = endTime.substring(0,10);
        var beginDate = $("#beginDate").val();
        beginDate = beginDate.substring(0,10);
        var periodicalType = $("#periodicalType").val();
        if ($("#updateTip").val() != 1&&(beginTime > endTime ||(beginTime<beginDate && periodicalType != "0"))) {
          $.alert($.i18n('calendar.event.state.beginDate.compare'));
          return false;
        }
        var endDate = $("#endDate").val();
        endDate = endDate.substring(0,10);
        if(periodicalType!=0 && beginDate != endDate && periodicalType!=3 && periodicalType!=4 && $("#updateTip").val() != 1){
             $.alert($.i18n('calendar.event.priorityType.kuaRi'));
             return false;
        }
        var currentDate = new Date();
        var nowDate = currentDate.print("%Y-%m-%d");
        if ($("#updateTip").val() != 1 && nowDate > endTime && periodicalType != "0") {
            $.alert($.i18n('calendar.event.state.endTime.compare'));
            return false;
        }
        if ($("#shareType").val() == 2) {
          $("#projectID").val("");
          $("#shareTargetOther").val("");
          $("#tranMemberIdsOther").val("");
        } else if ($("#shareType").val() == 3) {
          $("#shareTargetOther").val("");
          $("#tranMemberIdsOther").val("");
          $("#shareTargetDep").val("");
          $("#tranMemberIdsDep").val("");
        } else if ($("#shareType").val() == 4) {
          $("#projectID").val("");
          $("#shareTargetDep").val("");
          $("#tranMemberIdsDep").val("");
        } else if ($("#shareType").val() == 8) {
          $("#projectID").val("");
          $("#shareTargetDep").val("");
          $("#tranMemberIdsDep").val("");
        }
        $("#createCalEvent").jsonSubmit({
          domains : [ "domaincalEvent" ],
          debug : false,
          callback : function(res) {
            if(isOa.indexOf("a8genius.do")>-1){   //是精灵
            	getA8Top().close();
            }else{
                if (res != null && res != "") {
                    $.alert(res);
                    parentWindowData.diaClose("hasError");
                  } else {
                    var formType = $("#cInfoFromType").val();
                    var id = $("#cInfoId").val();
                    var resultTip = "";
                    if (id == -1) {
                      if (formType == 1) { // 协同
                        resultTip = $.i18n('calendar.swith.to.event.by.affaire');
                      } else if (formType == 5) { //计划
                        resultTip = $.i18n('calendar.swith.to.event.by.plan');
                      }
                    }
                    if (resultTip != "") {
                      new MxtMsgBox({
                        'msg' : resultTip,
                        'type' : 0,
                        imgType : 0,
                        title : $.i18n('system.prompt.js'),
                        ok_fn : function() {
                          resultOK(formType);
                        }
                      });
                    } else {
                      try{
                    	  if (formType == 19) {
                    		  resultOK(formType);
                    	  }else {
	                          if (formType != 14 ||formType != 15) { //14关联项目 15 关联人员
	                            resultOK();
	                          }
                    	  }
                          if(formType == 15){
                            parent.reloadPage();
                          }
                      }catch(e){}
                    }

                  }	
            }
          }
        });
      }
      return fValidate;
    }
  }

  function resultOK(formType) {
    if (typeof (parentWindowData) != 'undefined') {
      var id = $("#cInfoId").val();
      if (typeof (parentWindowData.curClick) == 'undefined') {
        var isview = false;
        try{
            isview = (parentWindowData.isview != 'true' && window.parentDialogObj["dialogCalEventAdd"].getTransParams().isview != 'true');

        }catch(e){
            isview = (parentWindowData.isview != 'true');
        }

        if (isview) {
          if (typeof (parentWindowData.curPageName) != 'undefined') {
            parentWindowData.searchFunc(parentWindowData.curPageName);
          } else {
            if (typeof (parentWindowData.isHasConVal) == 'undefined') {
              parentWindowData.searchFunc(null);
            }
          }
        }
      } else {
        parentWindowData.searchFunc(parentWindowData.curClick);
      }
      if (typeof (parentWindowData.sectionID) == 'undefined') {
        var curisView = parentWindowData.isview;
        if(typeof (curisView) == 'undefined'){
          try{
              curisView = window.parentDialogObj["dialogCalEventAdd"].getTransParams().isview;
          }catch(e){}
        }
        if (formType == 1 || formType == 5 || formType == 19) {
          curisView = false;
        }
        try{
        	if(typeof (window.dialogArguments.isList) != 'undefined'&&window.dialogArguments.isList!=null&&window.dialogArguments.isList=="isList"){//这里把两个刷新方法分成两种，是为了解决IE11在刷新事件列表时卡死的问题
        		parentWindowData.diaClose(id, curisView, window.dialogArguments.isList,parentWindowData.refleshMethod);//事件列表的刷新方法
        	}else{
        		parentWindowData.diaClose(id, curisView,parentWindowData.refleshMethod);//事件视图的刷新方法
        	}
             
        }catch(e){
             window.parentDialogObj["dialogCalEventAdd"].getTransParams().diaClose(id, curisView, parentWindowData.refleshMethod);
        }
      } else { // portal刷新关闭方法
        parentWindowData.diaClose(id, parentWindowData.isview,parentWindowData.sectionID);
      }
    }
  }

  function toUpdate() {
    if ($("#periodicalType").val() != 0 || $("#cInfoPeriodicalStyle").val() != 0) {
      var dialog = $.dialog({
        url : _ctxPath + '/calendar/calEvent.do?method=updateTip&id='
            + $("#calEventID").val(),
        width : 300,
        height : 80,
        targetWindow : window.parent,
        transParams : transParams,
        title : $.i18n('calendar.tip'),
        buttons : [ {
          id : "sure",isEmphasize:true,
          text : $.i18n('calendar.sure'),
          handler : function() {
            var o = dialog.getReturnValue();
            $("#updateTip").val(o);
            toSureUpdate();
            dialog.close();
          }
        }, {
          id : "cancel",
          text : $.i18n('calendar.cancel'),
          handler : function() {
            dialog.close();
          }
        } ]
      });
    } else {
      toSureUpdate();
    }
  }

  function toSureUpdate() {
    if ($("#updateTip").val() == 2) { //周期性事件。如果用户选择的修改所选事件及其之后的事件，重新初始化重复的时间
      var beginDate = $("#beginDate").val();
      var temp = beginDate.split(' ');
      temp = temp[0].split('-');
      var curBeginDate = new Date(temp[0], (temp[1] - 1), temp[2]);
      var selectedDate = curBeginDate.format("yyyy-MM-dd");
      $("#beginTime").val(selectedDate);
    }
    var ajaxTestBean = new calEventManager();
    var isReceiveMember = ajaxTestBean.isReceiveMember($("#currentUserId").val(),$("#calEventID").val());
    var calevent = ajaxTestBean.getCalEventById($("#calEventID").val(),false);
    if(isReceiveMember&&calevent.createUserId!=$("#currentUserId").val()){//是受委托人，但是不是创建者
        $("#completeRateDIV").removeClass("common_txtbox_wrap_dis");
        $("#states").removeAttr("disabled");
        $("#alarmDate").removeAttr("disabled");
        if ($("#states").val() != 4) {
          $("#completeRate").removeAttr("disabled");
        }
        $("#beforendAlarm").removeAttr("disabled");
        $("#advancedSettings").removeClass("common_button common_button_disable");
        $("#advancedSettings").addClass("common_button common_button_gray");
        $("#advancedSettings").attr("href", "javascript:toEventState()");
        var projectSelect  = $("#projectID")[0];//如果当前人员不在项目中，修改的时候，这里的初始值没有赋上，而且修改的时候没法改项目名，这里给个初始值
        projectSelect.options[0].value=$("#projectText").val();
        if(isOa.indexOf("a8genius.do")>-1){   //是精灵
        	$("#spanModify").addClass("display_none");
          	$("#spanOk").removeClass("display_none");
        }
    }else{
        $(".calendar_icon").css("display", "inline-block"); //修改：默认隐藏日期按钮
        $("#subject").removeAttr("disabled");
        $("#subjectDIV").removeClass("common_txtbox_wrap_dis");
        $("#beginDateDIV").removeClass("common_txtbox_wrap_dis");
        $("#endDateDIV").removeClass("common_txtbox_wrap_dis");
        $("#completeRateDIV").removeClass("common_txtbox_wrap_dis");
        $("#shareType2").removeClass("common_txtbox_wrap_dis");
        $("#shareType4").removeClass("common_txtbox_wrap_dis");
        $("#otherDIV").removeClass("common_txtbox_wrap_dis");
        $("#shareTargetDep").removeAttr("disabled");
        $("#projectID").show();
        $("#projectModify").remove();
        $("#projectID").removeAttr("disabled");
        $("#shareTargetOther").removeAttr("disabled");
        $("#calEventType").removeAttr("disabled");
        $("#beginDate").removeClass("color_gray2");
        $("#endDate").removeClass("color_gray2");
        $("#signifyType").removeAttr("disabled");
        $("#states").removeAttr("disabled");
        $("#alarmDate").removeAttr("disabled");
        if ($("#states").val() != 4) {
          $("#completeRate").removeAttr("disabled");
          $("#other").removeAttr("disabled");
        }
        $("#attaDiv2_noEdit").addClass("display_none");
        $("#attaDiv2").removeClass("display_none");
        $("#docDiv2_noEdit").addClass("display_none");
        $("#docDiv2").removeClass("display_none");
        bindClick(); //修改的时候需要给附件和关联文档绑定事件
        if(isOa.indexOf("a8genius.do")>-1){   //是精灵
        	$("#spanModify").addClass("display_none");
          	$("#spanOk").removeClass("display_none");
        }
        $("#beforendAlarm").removeAttr("disabled");
        $("#advancedSettings").removeClass("common_button common_button_disable");
        $("#advancedSettings").addClass("common_button common_button_gray");
        $("#advancedSettings").attr("href", "javascript:toEventState()");
        $("#projectID option[id='2']").remove();
        $("#shareType").removeAttr("disabled");
        $("#eventType").removeAttr("disabled");
        $("#content").removeAttr("readonly");
        
        $(".attachment_operate_btn").addClass("display_none");
        $(".attachment_operate_btn_bg").addClass("display_none");
        $(".attachment_operate_bg").addClass("display_none");
        $(".attachment_operate").addClass("display_none");
        $(".attachment_block").find("span:last").show();
        $("#content").unbind("focus");//编辑的时候，可以定位content
        showPrjSelect(true);//显示项目的select列表
    }
    
    if (flagV3x != "objectFlag") {
      try{parentWindowData.showButton();}catch(e){}
    }
  }

  // 点击高级设置
  function toEventState() {
    var beginDateStr = $("#beginDate").val().toString();
    beginDateStr = beginDateStr.replace(/-/g, "/");
    beginDateStr = new Date(beginDateStr);
    beginDateStr = beginDateStr.format("yyyy-MM-dd");
    var endDateStr = $("#endDate").val().toString();
    endDateStr = endDateStr.replace(/-/g, "/");
    endDateStr = new Date(endDateStr);
    endDateStr = endDateStr.format("yyyy-MM-dd");

    var fValidateEnd = $("#endDate").validate();
    var fValidateBegin = $("#beginDate").validate();
    if (fValidateEnd && fValidateBegin) {
      if ($("#updateTip").val() == 0 && curCount == 1) {
        var beginDate = $("#beginDate").val();
        var temp = beginDate.split(' ');
        temp = temp[0].split('-');
        var curBeginDate = new Date(temp[0], (temp[1] - 1), temp[2]);
        var selectedDate = curBeginDate.format("yyyy-MM-dd");
        $("#beginTime").val(selectedDate);

        var endDate = $("#endDate").val();
        temp = endDate.split(' ');
        temp = temp[0].split('-');
        curBeginDate = new Date(temp[0], (temp[1] - 1), temp[2]);
        selectedDate = curBeginDate.format("yyyy-MM-dd");
        $("#endTime").val(selectedDate);
      }

      var calEveteState = $("#beginTime").val() + "/";
      calEveteState = calEveteState + $("#endTime").val() + "/";
      calEveteState = calEveteState + $("#periodicalType").val() + "/";
      calEveteState = calEveteState + $("#realEstimateTime").val() + "/";
      calEveteState = calEveteState + $("#workType").val() + "/";
      calEveteState = calEveteState + $("#dayDate").val() + "/";
      calEveteState = calEveteState + $("#swithMonth").val() + "/";
      calEveteState = calEveteState + $("#swithYear").val() + "/";
      calEveteState = calEveteState + $("#dayWeek").val() + "/";
      calEveteState = calEveteState + $("#week").val() + "/";
      calEveteState = calEveteState + $("#month").val() + "/";
      calEveteState = calEveteState + $("#weeks").val() + "/";
      calEveteState = calEveteState + $("#updateTip").val() + "/";
      calEveteState = calEveteState + $("#calEventID").val() + "/";
      calEveteState = calEveteState + $("#isSearch").val() + "/";
      calEveteState = calEveteState + beginDateStr + "/";
      calEveteState = calEveteState + endDateStr;    
      var isNew;
      if($("#updateTip").val()!=0 && $("#calEventID").val() != -1){ //打开事件是修改模式
    	  isNew = $("#calEventCreateUserId").val();
      }else{
    	  isNew = "0";
      }
      var dialog = $
          .dialog({
            url : _ctxPath
                + '/calendar/calEvent.do?method=createCalEventState&id='
                + calEveteState+"&isNew="+isNew,
            width : 450,
            height : 250,
           // targetWindow : getCtpTop(),
            transParams : transParams,
            title : $.i18n('calendar.event.create.state.title'),

            buttons : [
                {
                  id : "sure",
                  text : $.i18n('calendar.sure'),
                  handler : function() {
                    var o = dialog.getReturnValue();
                    if (o) {
                      curCount = 2;
                      $("#periodicalType").val(o.periodicalType);
                      $("#dayDate").val(o.dayDate);
                      $("#dayWeek").val(o.dayWeek);
                      $("#week").val(o.week);
                      $("#month").val(o.month);
                      $("#weeks").val(o.weeks);
                      $("#beginTime").val(o.beginTime);
                      $("#endTime").val(o.endTime);
                      $("#realEstimateTime").val(o.realEstimateTime);
                      $("#workType").val(o.workType);
                      $("#swithMonth").val(o.swithMonth);
                      $("#swithYear").val(o.swithYear);
                      $("#isSearch").val(1);
                      dialog.close();
                    }
                  }
                },
                {
                  id : "cancel",
                  text : $.i18n('calendar.cancel'),
                  handler : function() {
                    if ($("#updateTip").val() == 2) {
                      $("#beginTime").val(beginDateStr);
                      $("#endTime")
                          .val($("#cInfoEndtime").val());
                    }
                    dialog.close();
                  }
                } ]
          });
    }
  }
  function doDate(curDate) {
    var ajaxTestBean = new calEventManager();
    var calEvent = new Object();
    if (curDate == 'endDate') {
      calEvent.receiveMemberName = 'endDate';
    }
    var fValidateEnd = $("#endDate").validate();
    var fValidateBegin = $("#beginDate").validate();
    if (fValidateEnd && fValidateBegin) {
      calEvent.endDate = $("#endDate").val();
      calEvent.beginDate = $("#beginDate").val();
      calEvent = ajaxTestBean.compareDate(calEvent);
      $("#endDate").val(calEvent.endDate);
      $("#beginDate").val(calEvent.beginDate);
    }
    
    if ($("#updateTip").val() == 2) {
      var beginDateStr = $("#beginDate").val().toString();
      beginDateStr = beginDateStr.replace(/-/g, "/");
      beginDateStr = new Date(beginDateStr);
      beginDateStr = beginDateStr.format("yyyy-MM-dd");
      $("#beginTime").val(beginDateStr);
    }    
  }
  function loadData(shareType, id) {
	isOa = getA8Top().location.href;
    if (shareType == 4 || shareType == 2 || shareType == 3) {
      document.getElementById("shareType" + shareType).style.display = "block";
    }
    if(shareType == 8) {
      document.getElementById("shareType4").style.display = "block";
    }
    if (id == -1) {  
      bindClick();
      showPrjSelect(true);
      $("#projectID option[id='2']").remove();
    } else {
      $(".attachment_block").find("span:last").hide();	
      $(".calendar_icon").css("display", "none"); //修改：默认隐藏日期按钮
      
      $("#attachmentNumberDiv_text").text($("#attachmentNumberDiv").text());
      $("#attachment2NumberDivposition1_text").text($("#attachment2NumberDivposition1").text());
      $("#attaDiv2").addClass("display_none");
      $("#attaDiv2_noEdit").removeClass("display_none");
      $("#docDiv2").addClass("display_none");
      $("#docDiv2_noEdit").removeClass("display_none");
      
      if(isOa.indexOf("a8genius.do")>-1){   //是精灵
        var ajaxCalEvent = new calEventManager();
      	var isReceiveMember = ajaxCalEvent.isReceiveMember($.ctx.CurrentUser.id,$("#calEventID").val());
      	if(isReceiveMember||($("#calEventCreateUserId").val()==$.ctx.CurrentUser.id)){
      		$("#spanModify").removeClass("display_none");	
      	}
      	$("#spanCancel").removeClass("display_none");
      	$("#btncancel").click(function(){
            	getA8Top().close();
            	return false;
        });
      }
    }
  }
  function showAllReply(id) {
    $.dialog({
      url : _ctxPath + '/calendar/calReply.do?method=showAllReply&id=' + id,
      width : 400,
      height : 320,
      minParam : {
        'show' : false
      },
      maxParam : {
        'show' : false
      },
      targetWindow : window.parent,
      title : $.i18n('calendar.event.create.reply.search.all')
    });
  }

  function initReplyContent(curReply){
      if ($("#replyInfo").html() != null && $("#replyInfo").html() != "") {
        $("#replyInfo").html(curReply + $("#replyInfo").html());
      } else {
        $("#replyInfo").html(curReply);
      }
      dialogReply.close();
  }
  
  function toReply(id) {
    dialogReply = $
        .dialog({
          url : _ctxPath + '/calendar/calReply.do?method=toReply&id=' + id,
          width : 400,
          height : 300,
          minParam : {
            'show' : false
          },
          maxParam : {
            'show' : false
          },
          targetWindow : window.parent,
          transParams : {initReplyFunc:initReplyContent},
          title : $.i18n('calendar.event.create.reply')+$.i18n('calendar.event.create.reply.event'),

          buttons : [
              {
                id : "sure",
                text : $.i18n('calendar.sure'),
                handler : function() {
                  dialogReply.getReturnValue({'dialogObj' : dialogReply});
                }
              }, {
                id : "cancel",
                text : $.i18n('calendar.cancel'),
                handler : function() {
                  dialogReply.close();
                }
              } ]
        });
  }

  function showCollation() {
    var fromId = $("#cInfoFromId").val();
    var eventId = $("#cInfoId").val();
    var url = _ctxPath
        + "/collaboration/collaboration.do?method=summary&openFrom=glwd&type=&affairId="
        + fromId+"&eventId="+eventId;
    showSummayToEventDialog(url, $("#cInfoAffSubject").val());
  }

  function showEdoc() {
    var fromId = $("#cInfoFromId").val();
    var eventId = $("#cInfoId").val();
    var url = _ctxPath + "/edocController.do?method=detailIFrame&from=Done&affairId=" + fromId+"&isTransFrom=transEvent";
    var width = $(getA8Top().document).width() - 60;
    var height = $(getA8Top().document).height() - 50;
    dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: $("#cInfoAffSubject").val(),
        targetWindow:getCtpTop()
    });
  }
  
  function showPlan() {
    var fromId = $("#cInfoFromId").val();
    openPlan(fromId, null, true,null,null,true);
  }
  function showPrjSelect(flag){
      if(flag==true){
          $("#projectID").removeClass("hidden").addClass("w100b");
          $("#projectText").addClass("hidden");
      }else{
          $("#projectID").addClass("hidden");
          $("#projectText").removeClass("hidden");
      }
      
  }
  //插入附件和关联文档组件，没有直接声明onClick事件，这里需要动态绑定：-新建，-修改
  function bindClick(){
	  $("#attaDiv2").click(function(){
    	  insertAttachment(); //动态绑定插入附件方法
    	  return;
      });
      $("#docDiv2").click(function(){
    	  quoteDocument('position1');  //动态绑定插入关联文档方法
    	  return;
      });
  }

  function G6Opeartion() {
    if($("#isG6Version").val() != 1){
      removeLeaderOption();
    }
  }
  
  function removeLeaderOption() {
      $("#shareType option[value='8']").remove();
      /*$("#shareType").append("<option value='1'>私人事件</option>");
      $("#shareType").append("<option value='2'>部门事件</option>");
      $("#shareType").append("<option value='3'>项目事件</option>");
      $("#shareType").append("<option value='8'>公开至领导日程</option>");
      $("#shareType").append("<option value='4'>公开给他人</option>");
      $("#shareType").append("<option value='5'>公开给上级</option>");
      $("#shareType").append("<option value='6'>公开给下级</option>");
      $("#shareType").append("<option value='7'>公开给秘书/助手</option>");*/
  }