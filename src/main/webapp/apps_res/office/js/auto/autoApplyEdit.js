// js开始处理
$(function() {
  pTemp.autoApplyDiv = $("#autoApplyDiv");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#applyOk");
  pTemp.cancel = $("#btncancel");
  pTemp.autoId = $("#applyAutoIdName");
  pTemp.ajaxM = new autoApplyManager();
  pTemp.ajaxUseM = new autoUseManager();
  fnSetCss();
  fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	pTemp.ok.click(fnOK);
	pTemp.cancel.click(fnCancel);
	if (pTemp.jval != '') {
		var row = $.parseJSON(pTemp.jval);
		// 加载打开页面数据
		fnPageReload(row);
		pTemp.autoApplyDiv.disable();
		pTemp.row = row;
	}
	
	//新增，修改，不显示审批意见
	if(getURLParamPub("operate")=="new"||getURLParamPub("operate")=="modfiy"){
		 $("#auditContentTR").hide();
		 pTemp.autoApplyDiv.enable();
	}
	//新增，修改，带审批，不显示派车意见
	if(getURLParamPub("operate")=="new"||getURLParamPub("operate")=="modfiy"||
			(pTemp.row && (parseInt(pTemp.row.state)==1||parseInt(pTemp.row.state)==25||parseInt(pTemp.row.state)==35))){
		 $("#dispatchOpinionTR").hide();
	}
	pTemp.autoApplyDiv.resetValidate();
}

/**
 * 取消
 */
function fnCancel() {
	if(getURLParamPub("operate")=="new"){
		var confirm = $.confirm({
            'msg' : $.i18n('office.sure.giveup.operate.js'),
            ok_fn : function() {
            	fnAutoCloseWindow();
            }
          });
	}else{
		fnAutoCloseWindow();
	}
}

/**
 * 处理工作流的问题
 * @param selectAutorow
 */
function  fnPaseWorkFlow(selectOperate,selectData){
	var params = {operate:selectOperate,accountId:selectData.accountId};
	if(selectOperate=='selectMember'){
		params.memberId = selectData;
	}
	
	pTemp.ajaxUseM.findAutoWorkFlowArgs(params, {
      success : function(rVal) {
    	  officeWorkFlowTemp.processId = rVal.processId;
    	   officeWorkFlowTemp.workflowId = rVal.workflowId;
    	   var officeTemplateIframe = $(parent.document).find("#officeTemplate");
    	   var workFlowSrc = officeTemplateIframe.attr("src");
    	   workFlowSrc = setURLParamPub("processId",rVal.processId,workFlowSrc);
		   workFlowSrc = setURLParamPub("scene",'2',workFlowSrc);
		   workFlowSrc = setURLParamPub("currentUserName",encodeURIComponent(rVal.currentUserName),workFlowSrc);
		   workFlowSrc = setURLParamPub("currentUserAccountName",encodeURIComponent(rVal.currentUserAccountName),workFlowSrc);
    	   officeTemplateIframe.attr("src",workFlowSrc);
      },
      error : function() {
      }
	});
}

function fnOK(){
  var applyDepartType = $("#applyDepartType").val();
  if(applyDepartType==null){
	  $.alert($.i18n('office.autoapply.autoUseType.none.js'));
	  return;
  }
  $("#autoApplyDiv").resetValidate();
  openProcePub();
  var isAgree = $("#autoApplyDiv").validate();
  if (!isAgree) {// js校验
      endProcePub();
      return;
  }

  var passengerNum = $("#passengerNum").val();
  var autoPernum = $("#applyAutoPassengerNum").val();
  var applyUserId = $("#applyUser").val();
  var applyAutoId = $("#applyAutoId").val();
  var startTime = $("#applyOuttime").val();
  var endTime = $("#applyBacktime").val();
  var o = new Object();
  o.applyUserId = applyUserId;
  o.applyAutoId = applyAutoId;
  o.applyOuttime = startTime;
  o.applyBacktime = endTime;
  
  if (fnParseDatePub(startTime) >= fnParseDatePub(endTime)) {
	$.alert($.i18n('office.auto.sdate.compare.edate.js'));
	endProcePub();
	return;
  }
  
  pTemp.ajaxM.canApply(o, {
    success : function(returnVal) {
      if (returnVal.state == false) {
        $.alert($.i18n('office.auto.not.acl.js'));
        endProcePub();
        return;
      }
      
      if (returnVal.autoInfoDel) {
        $.alert($.i18n('office.auto.apply.car.del.js'));
        endProcePub();
        return;
      }
      
      if (returnVal.applyState == false) {
        $.alert($.i18n('office.auto.apply.car.busy.js'));
        endProcePub();
        return;
      }
      
      if(returnVal.moreAcc2noneSelfAccCar && (applyAutoId == null || applyAutoId=='')){//仅仅有多个外单位的车,并且没选车
      	 $.alert($.i18n('office.auto.user.only.other.accCar.js'));
         endProcePub();
         return;
      }
      //流程预提交
      if (passengerNum != '' && autoPernum !='') {
        if (parseInt(passengerNum) > parseInt(autoPernum)) {
          var confirm = $.confirm({
            'msg' : $("#applyAutoIdName").val() + $.i18n('office.auto.siet.notenght.js'),
            ok_fn : function() {
              preSubmit();
            }
          });
        }else{
          preSubmit();
        }
      }else{
        preSubmit();
      }
    }
  });
}

function officeSubmitForm() {
  //提交
  openProcePub();
  var apply = pTemp.autoApplyDiv.formobj();
  apply.workFlow = $("#workFlowDiv").formobj();
  apply.workFlow.officeData = officeData;
  apply.applyUser = apply.applyUser.split("|")[1];
  apply.applyDept = apply.applyDept.split("|")[1];
  pTemp.ajaxM.save(apply, {
      success : function(returnVal) {
        if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
          alert($.i18n('office.auto.savesuccess.js'));
          endProcePub();
          fnReloadPagePub({page : "autoApply"});
          fnAutoCloseWindow();
        }else{
            fnMsgBoxPub($.i18n('office.auto.savesuccess.js'),"ok",function(){
            endProcePub();
            fnReloadPagePub({page : "autoApply"});
            fnAutoCloseWindow();
          });
        }
      },
      error : function() {
          endProcePub();
      }
  });
}

/**
 * 刷新页面
 * @param areaId，刷新
 */
function fnPageReload(p) {
  $("#autoApplyDiv").fillform(p);
//选人组件回填
  $("#userDiv").comp({value : "Member|"+p.applyUser,text : p.applyUserName});
  $("#depDiv").comp({value : "Department|"+p.applyDept,text : p.applyDeptName});
  $("#passengerDiv").comp({value : p.passenger,text : p.passengerName});
}

/**
 * 选择驾驶员
 */
function fnSelectPeople(opt){
  var value = opt.okParam;
  if(value.length>0){
    $("#applyDriver").val(value[0].id);
    $("#applyDriverName").val(value[0].memberName);
    $("#applyDriverPhone").val(value[0].phoneNumber);
  }
  opt.dialog.close();
}

/**
 * 自驾checkBox事件
 */
function fnSelfDrivingPub(){
  if($("#selfDriving").is(':checked')){
    $("#applyDriverDiv").clearform();
    $("#applyDriverDiv").disable();
    $("#applyDriverPhone").disable();
  }else{
    $("#applyDriver").val($("#shadowapplyDriver").val());
    $("#applyDriverName").val($("#shadowapplyDriverName").val());
    $("#applyDriverPhone").val($("#shadowapplyDriverPhone").val());
    $("#applyDriverDiv").enable();
    $("#applyDriverPhone").enable();
  }
}

/**
 * 页面样式控制
 */
function fnSetCss() {
	$("#autoUseTab tr[nodePostion=audit]").show();
	$("#autoUseTab tr[nodePostion*=send]").show();
	$("#applyDriverSpan").remove();
	$("#applyAutoSpan").remove();
	$("#auditContent").disable();
	$("#dispatchOpinion").disable();
	$("#applyDriverDiv").disable();
	$("#applyDriverName").attr({"validate":"type:'string',name:'"+$.i18n('office.auto.autoStcInfo.jsy.js')+"'"});
}