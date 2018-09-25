/**
 * @param opt{type:[manager,driver],value:}
 * @returns {text:,id:}
 */
function fnSelectPeoplePub(opt){
	var width = 300;
	var _title = $.i18n('office.auto.select.manager.js');
	if(opt.type==="driver" || opt.type==="driverChecked"){
		_title = $.i18n('office.auto.select.driver.js');
	} 
	if (opt.type==="auto" || opt.type==="autoChecked") {
		_title = $.i18n('office.auto.autoStcInfo.xzcl.js');
	} 
	if (opt.type==="managerOrDriver") {
		_title = $.i18n('office.auto.select.use.people.js');
	}
	if (opt.width) {
		width = opt.width;
	}
  var dialog = $.dialog({
	  id : "manOrdriver",
	  url :_path+"/office/autoUse.do?method=autoSelectPeople",
	  width : width,
	  height : 300,
	  targetWindow : getCtpTop(),
	  transParams : {type:opt.type,value:opt.value},  //传给子页面
	  title : _title,
	  buttons : [
	      {id : "sure",text : $.i18n('calendar.sure'),
	      	isEmphasize:true,
	        handler : function() {
	        	if (typeof (fnSelectPeople) !== 'undefined') {
	        		if (dialog.getReturnValue() != null) {
	        			fnSelectPeople({dialog : dialog,okParam : dialog.getReturnValue(),type:opt.type});//dialog对象、弹出框页面返回值、操作类型：manager、driver
	        		}
	          }
	        }
	      },
	      {id : "cancel",text : $.i18n('calendar.cancel'),
	        handler : function() {dialog.close();}
	      }]
	});
}

function fnToggleTabs(p){
	if(p==='apply'){
		$("#autoApplyDiv").show();
		$("#autoWorkFlowDiv").hide();
		$("#applyLi").addClass("current");
		$("#workFlowLi").removeClass("current");
	}else{
		$("#autoWorkFlowIframe").attr("src",_path+"/workflow/designer.do?method=showDiagram&isModalDialog=false&isDebugger=false&isTemplate=true&scene=3&processId="
				+pTemp.workFlow.processId+"&caseId="+pTemp.workFlow.caseId
				+"&currentNodeId="+pTemp.workFlow.workItemId+"&appName=office&san=auto");
		$("#autoWorkFlowIframe").height($("#autoWorkFlowDiv").height());
		$("#autoApplyDiv").hide();
		$("#autoWorkFlowDiv").show();
		$("#applyLi").removeClass("current");
		$("#workFlowLi").addClass("current");
	}
}

/**
 * 1.解决ie11下不刷新的问题
 * 2.选中制定的clkTabId的tab页签
 */
function fnTabsClk2ReLoadFirst(clkTabId,firstTabId){
	$(window).load(function() {
		$(".common_tabs").find("a[tgt="+clkTabId+"]").click();
		//解决ie11下不刷新的问题
		var targetWin = $("#"+firstTabId);
		if(targetWin[0]){
			var url = targetWin.attr("src") + "&timestamp=" + new Date();
		  targetWin[0].src = url;
		}
	});
}

/**
 * 自驾checkBox样式设置
 */
function fnSelfDrivingPub(){
	var selfDriving = $("#selfDriving");
	var phone = $("#applyDriverPhone");
	var driverDiv = $("#applyDriverDiv");
	if(selfDriving.is(':checked')){
		pTemp.driverDivObj = driverDiv.formobj();
		driverDiv.clearform();
		driverDiv.disable();
	}else{
		driverDiv.fillform(pTemp.driverDivObj);
		driverDiv.enable();
	}
	
	selfDriving.disable();
	phone.disable();
}
/**
 * 申请人选人界面回调
 */
function applyUserCallBackPub(rv) {
  var memberId = rv.obj[0].id;
  if(memberId != $("#applyUser").val().split("|")[1]){
    $("#applyAutoIdName").val("");
    $("#applyAutoId").val("");
  }
  
  //处理工作流
  if(typeof (fnPaseWorkFlow) !== 'undefined'){
	  fnPaseWorkFlow('selectMember',memberId);
  }
  var member = getCtpTop().getObject("Member", memberId);
  var mobile = member.mobile == undefined ? "" : member.mobile;
  $("#applyUserPhone").val(mobile);
  if(typeof (fnFillDept) !== 'undefined'){
  	fnFillDept(member);
  }
  //清空其它无用信息
  $("#applyOuttime").val(new Date().format("yyyy-MM-dd HH:mm"));
  $("#applyBacktime").val("");
  $("#shadowapplyDriver").val("");
  $("#shadowapplyDriverName").val("");
  $("#shadowapplyDriverPhone").val("");
  $("#applyDriver").val("");
  $("#applyDriverName").val("");
  $("#applyDriverPhone").val("");
  $("#applyAutoPassengerNum").val("");
  $("#applyAutoId").val("");
  $("#applyAutoIdName").val("");
  $("#applyOrigin").val("");
  $("#applyMemo").val("");
}

/**
 * 车辆选择界面
 */
function fnOpenAutoPub(isAdmin){
  var _title = $.i18n('office.auto.car.select.page.js');
  var applyUserId = $("#applyUser").val();
  var applyOuttime = $("#applyOuttime").val();
  var applyBacktime = $("#applyBacktime").val();
  var passengerNum = $("#passengerNum").val();
  
  if(applyBacktime != ""){
 		if (applyOuttime >= applyBacktime) {
  		$.alert($.i18n('office.auto.use.end.time.error.js'));
  		return;
  	}
  }

  if(applyUserId == ""){
    $.alert($.i18n('office.auto.first.select.person.page.js'));
    return;
  }
  
  if(applyOuttime == ""){
    $.alert($.i18n('office.auto.set.usetime.page.js'));
    return;
  }
  
  var url = "/office/autoUse.do?method=autoOrderIframe&applyUserId="+applyUserId
  +"&applyOuttime="+applyOuttime+"&applyBacktime="+applyBacktime,title = $.i18n('office.auto.autoStcInfo.xzcl.js');
  
	if (isAdmin) {
		url += "&isAdmin=" + isAdmin;
	}
  var dialog = $.dialog({
    id : "orderList",
    url :_path+ url,
    width : $(getCtpTop()).width()*0.75 ,height : $(getCtpTop()).height()*0.8,
    targetWindow : getCtpTop(),
    title : _title,
    buttons : [
        {  id: 'ok',
          text : $.i18n('calendar.sure'),
          isEmphasize:true,
          handler : function() {
        	var rval = dialog.getReturnValue();
        	if(rval == "nullEndDate"){
        		$.alert($.i18n('office.auto.usetime.is.big.js'));
        		return;
        	}
            if (typeof (fnSelectAutoPub) !== 'undefined') {
            	fnSelectAutoPub({dialog : dialog, okParam : rval});
            }
          }
        },
        { id: 'cancel',
          text : $.i18n('calendar.cancel'),
          handler : function() {dialog.close();}
        }]
  });
}

/**
 * 设置车辆信息
 */
function fnSelectAutoPub(p) {
  var rval = p.okParam;
  if(!rval){
    return;
  }
  var row = rval.row;
  //处理工作流
  if(typeof (fnPaseWorkFlow) !== 'undefined'){
	  fnPaseWorkFlow('selectCar',row);
  }
  
  if(rval.oldApplyOuttime!=rval.applyOuttime||rval.oldApplyBacktime!=rval.applyBacktime){
    var confirm = $.confirm({
      'msg' : $.i18n('office.auto.modify.useTime.js'),
      ok_fn : function() {
        $("#applyOuttime").val(rval.applyOuttime);
        $("#applyBacktime").val(rval.applyBacktime);
        checkpassengerAndState(rval,row,p);
      }
    });
  }else{
    checkpassengerAndState(rval,row,p);
  }
}

/**
 * 校验座位数和状态
 */
function checkpassengerAndState(rval,row,p){
  var passengerNum = $("#passengerNum").val();
  if (passengerNum != '' && row.autoPernum != '') {
    if (parseInt(passengerNum) > parseInt(row.autoPernum)) {
      var confirm = $.confirm({
        'msg' : row.autoNum + $.i18n('office.auto.siet.notenght.js'),
        ok_fn : function() {
          fnFillBack(rval,row,p);
        }
      });
    }else{
      fnFillBack(rval,row,p);
    }
  }else{
    fnFillBack(rval,row,p);
  }
}
/**
 * 驾驶员信息回填函数
 */
function fnFillBack(rval,row,p){
  if (rval) {
    $("#applyAutoId").val(rval.id);
    $("#applyAutoIdName").val(rval.autoNum);
    //回填驾驶员信息，驾驶员电话，自驾的不回填
    if (!$("#selfDriving").is(":checked")) {
      $("#applyDriver").val(row.memberId=="null"?"":row.memberId);
      $("#applyDriverName").val(row.memberName);
      $("#applyDriverPhone").val(row.phoneNumber);
    }
      $("#shadowapplyDriver").val(row.memberId=="null"?"":row.memberId);
      $("#shadowapplyDriverName").val(row.memberName);
      $("#shadowapplyDriverPhone").val(row.phoneNumber);
      $("#applyAutoPassengerNum").val(row.autoPernum);
  }
  p.dialog.close();
}

/**
 * 用车时间列Render
 */
function fnUseTimeRenderPub(text, row, rowIndex, colIndex, col){
	var _text = (text === null) ? "" : text;
  if (col.name === 'useTime') {
		if (row.applyOuttime != null && row.applyBacktime != null) {
			_text = row.applyOuttime + " 至 " + row.applyBacktime;
  	}
  }
  return "<span class='grid_black'>"+_text+"</span>";
}

/**
 * 出车还车的选人界面的回填函数
 */
function fnSelectPeople4Send2OutPub(opt){
	var value = opt.okParam;
	if(value.length>0){
		$("#applyDriver").val(value[0].id);
		$("#applyDriverName").val(value[0].memberName);
		$("#applyDriverPhone").val(value[0].phoneNumber);
	}else{//没选，清空
		$("#applyDriver").val("");
		$("#applyDriverName").val("");
		$("#applyDriverPhone").val("");
	}
	opt.dialog.close();
}

/**
 * 出车还车的消息处理
 */
function fnSendOutCarMsgPub(rval,autoUse){
	var reload = false;
	var msg = $.i18n('office.handle.success.js'),type = 'ok';
	if (rval.state == "adminNoneAcl") {// 对该车辆无管理权限
		type = "alert";
		msg = $.i18n('office.auto.noUse.car.acl.js',$("#applyAutoIdName").val());
	} else if (rval.state == "userNoneAcl") {
		type = "alert";
		msg = $.i18n('office.auto.noUse.car.acl.4.apply4User.js',$("#applyAutoIdName").val());
	} else if (rval.state == "carBusy" || rval.state == "carNotState") {
		type = "alert";
		msg = $.i18n('office.auto.car.useing.js',$("#applyAutoIdName").val());
	}else if(rval.state == "carStateNotNormal"){
		type = "alert";
		msg = $.i18n('office.auto.car.no.state.js',$("#applyAutoIdName").val(),rval.msg);
	} else if (rval.state == "driverBusy") {
		type = "alert";
		msg = $.i18n('office.auto.driver.busy.js',autoUse.applyOuttime,autoUse.applyBacktime);
	}else if(rval.state == "driverDelete"){
		type = "alert";
		msg = $.i18n('office.auto.driver.game.over.js');
	}else if(rval.state == "duplicateApply"){
		type = "alert";
		msg = $.i18n('office.auto.apply.user.applyed.js');
	} else if (rval.state == "handled") {
		type = "alert";
		msg = $.i18n('office.auto.apply.handled.js');
		reload = true;
	} else if (rval.state == "fail") {
		type = "error";
		msg = $.i18n('office.handle.fail.js');
	} else if (rval.state == "saveSucess") {
		type = "ok";
		msg = $.i18n('office.auto.savesuccess.js');
	}
	return {msg:msg,type:type,isReload:reload};
}

/**
 * 申请，审核，派车，出车，还车，共用的标题列 tab数据
 */
function fnTabItems(){
  return {
      "id" : {
          display : 'id',
          name : 'id',
          width : 40,
          sortable : false,
          align : 'center',
          type : 'checkbox'
      },
      "applyUser" : {
          display : $.i18n('office.autoapply.user.js'),
          name : 'applyUserName',
          width : '7%',
          sortable : true,
          align : 'left'
      },
      "applyDept" : {
          display : $.i18n('office.autoapply.dep.js'),
          name : 'applyDeptName',
          width : '10%',
          sortable : true,
          align : 'left'
      },
      "passengerNum" : {
          display : $.i18n('office.autoapply.num.js'),
          name : 'passengerNum',
          width : 45,
          sortable : true,
          align : 'left'
      },
      "applyOrigin" : {
          display : $.i18n('office.autoapply.origin.js'),
          name : 'applyOrigin',
          width : '15%',
          sortable : true,
          align : 'left'
      },
      "realOuttime" : {
          display : $.i18n('office.autoapply.senddate.js'),
          name : 'realOuttime',
          width : 110,
          cutsize :21,
          sortable : true,
          type : 'date',
          align : 'left'
      },
      "realBacktime" : {
        display : $.i18n('office.autoapply.recededate.js'),
        name : 'realBacktime',
        width : 110,
        cutsize :21,
        sortable : true,
        type : 'date',
        align : 'left'
      },
      "applyDes" : {
          display : $.i18n('office.autoapply.endplace.js'),
          name : 'applyDes',
          width : '8%',
          sortable : true,
          align : 'left'
      },
      "applyAutoId" : {
          display : $.i18n('office.autoapply.auto.js'),
          name : 'applyAutoIdName',
          width : 80,
          sortable : true,
          align : 'left'
      },
      "state" : {
          display : $.i18n('office.asset.query.state.js'),
          name : 'stateName',
          width : 65,
          sortable : true,
          align : 'left'
      },
      "useTime" : {
        display : $.i18n('office.autoapply.udate.js'),
        name : 'useTime',
        width : 230,
        sortable : true,
        align : 'left'
      },
      "workFlowState" : {
        display : $.i18n('office.workflow.state.js'),
        name : 'workFlowState',
        width : 90,
        sortable : true,
        align : 'left'
      },
      "createDate" : {
        display : $.i18n('office.autoapply.start.date.js'),
        name : 'createDate',
        width : 110,
        sortable : true,
        cutsize :21,
        align : 'left'
      },
      "applyDriver" : {
        display : $.i18n('office.auto.driver.js'),
        name : 'applyDriverName',
        width : 100,
        sortable : true,
        align : 'left'
      }
  }
}

function fnSBArgFuncPub(){
	return {
    "applyUser":{
      id : 'applyUser',
      name : 'applyUser',
      type : 'input',
      text : $.i18n('office.autoapply.user.js'),
      value : 'applyUser'
    },
    "applyDept":{
      id : 'applyDept',
      name : 'applyDept',
      type : 'selectPeople',
      text : $.i18n('office.autoapply.dep.js'),
      value : 'applyDept',
      comp : "type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',maxSize:'1'"
    },
    "createDate" : {
      id : 'createDate',
      name : 'createDate',
      type : 'datemulti',
      text : $.i18n('office.autoapply.start.date.js'),
      value : 'createDate',
      ifFormat:'%Y-%m-%d',
      dateTime : false
    },
    "realOuttime" : {
      id : 'realOuttime',
      name : 'realOuttime',
      type : 'datemulti',
      text : $.i18n('office.autoapply.senddate.js'),
      value : 'realOuttime',
      ifFormat:'%Y-%m-%d',
      dateTime : false
    },
    "realBacktime" : {
      id : 'realBacktime',
      name : 'realBacktime',
      type : 'datemulti',
      text : $.i18n('office.autoapply.recededate.js'),
      value : 'realBacktime',
      ifFormat:'%Y-%m-%d',
      dateTime : false
    },
    "applyAutoIdName" : {
      id : 'applyAutoIdName',
      name : 'applyAutoIdName',
      type : 'input',
      text : $.i18n('office.autoapply.auto.js'),
      value : 'applyAutoIdName',
      dateTime : false
    },
    "workFlowState":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.workflow.state.js'),
      value : 'state_int',
      items : [ {
          text : $.i18n('office.workflow.state.unaduit.js'),
          value : 0
      }, {
          text : $.i18n('office.workflow.state.aduited.js'),
          value : 1
      }, {
          text : $.i18n('office.asset.query.state.all.js'),
          value : 2
      } ]
    },
    "outRedeceState":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.query.state.js'),
      value : 'state_int',
      items : [ {
          text : $.i18n('office.workflow.state.unout.js'),
          value : 10
      }, {
          text : $.i18n('office.workflow.state.unback.js'),
          value : 15
      }, {
          text : $.i18n('office.workflow.state.backed.js'),
          value : 20
      } ]
    },
    "state" : {
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.query.state.js'),
      value : 'state_int',
      items : [ {
        text : $.i18n('office.workflow.state.unaduit.js'),
        value : 1
      }, {
        text : $.i18n('office.workflow.state.unsend.js'),
        value : 5
      }, {
        text : $.i18n('office.workflow.state.unout.js'),
        value : 10
      }, {
        text : $.i18n('office.workflow.state.unback.js'),
        value : 15
      }, {
        text : $.i18n('office.workflow.state.backed.js'),
        value : 20
      }, {
        text : $.i18n('office.workflow.state.aduit.not.js'),
        value : 25
      }, {
        text : $.i18n('office.workflow.state.send.not.js'),
        value : 30
      }, {
        text : $.i18n('office.workflow.state.revoked.js'),
        value : 35
      }, {
        text : $.i18n('office.asset.query.state.all.js'),
        value : 999
      } ]
    }
	}
}
 
