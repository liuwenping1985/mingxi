// js开始处理
$(function() {
	pTemp.ajaxM = new autoUseManager();
	pTemp.useTab =  $("#autoUseTab");
	
	pTemp.applyDriverNameInput = $("#applyDriverName");
	pTemp.applyDriverSpan = $("#applyDriverSpan");
	pTemp.applyDriverDiv = $("#applyDriverDiv");
	fnPageInIt();
	$(".stadic_layout_body").scrollTop(0);
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	var isSelfDriving = false;
	pTemp.row = {};
	if (pTemp.jval != '') {
		pTemp.row  = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pTemp.row.workFlow;
		// 加载打开页面数据
		fnPageReload(pTemp.row);
		//没有勾选自驾
		if (pTemp.row.selfDriving == null || !pTemp.row.selfDriving) {
			pTemp.applyDriverSpan.show();
		} else {
			pTemp.applyDriverSpan.hide();
			isSelfDriving = true;
		}
		fnSelfDrivingPub();
	}
	
	pTemp.useTab.resetValidate();
	pTemp.useTab.disable();
	
	//如果是管理员，开启派车界面元素
	if(pTemp.row.state == 10 && pTemp.row.admin && getURLParamPub("isEdit") == 'true'){
		pTemp.editDiv = pTemp.useTab.find("tr[nodeAcl=sendOut]");
		pTemp.editDiv.enable();
	}else if(pTemp.row.state == 10 && pTemp.row.autoDriver && getURLParamPub("isEdit") == 'true'){//驾驶员
		pTemp.editDiv = pTemp.useTab.find("tr[nodePostion=autoOut]");
		pTemp.editDiv.enable();
	}
	
	if(isSelfDriving){
		//勾选自驾，驾驶员置灰色
		pTemp.applyDriverDiv.disable();
		pTemp.applyDriverNameInput.val("");
	}
	//置灰派车意见
	pTemp.useTab.find("#dispatchOpinionTR").disable();
	//自驾置灰
	$("#applySelf2Msg").disable();
	$("#applyDriverPhoneDiv").disable();
}

/**
 * 刷新页面
 */
function fnPageReload(p) {
	// 出车时间，等于现在时间
	if (p.realOuttime == null) {
		p.realOuttime = p.nowTime;
	}
	if (p.outmileage == 0) {
		p.outmileage = '';
	}
	pTemp.useTab.fillform(p);
	//选人组件回填
  $("#userDiv").comp({value : p.applyUser,text : p.applyUserName});
  $("#depDiv").comp({value : p.applyDept,text : p.applyDeptName});
  $("#passengerDiv").comp({value : p.passenger,text : p.passengerName});
}

/**
 * 出车
 */
function fnOK(saveOrOut) {
	if(pTemp.editDiv==null || pTemp.editDiv==undefined || pTemp.editDiv=='undefined'){
		$.alert($.i18n('office.auto.apply.handled.js'));
		return;
	}
	pTemp.editDiv.resetValidate();
	var isAgree = pTemp.editDiv.validate();
	if (!isAgree){
		return;
	}
	
	//校验实际出车时间大于还车时间
	var realOuttime = fnParseDatePub($("#realOuttime").val());
	var applyBacktime = fnParseDatePub($("#applyBacktime").val());
	var applyOuttime = fnParseDatePub($("#applyOuttime").val());
	if (applyOuttime.getTime() >= applyBacktime.getTime()) {
		$.alert($.i18n('office.auto.sdate.compare.edate.js'));
		return ;
	}
	
	if (realOuttime.getTime() >= applyBacktime.getTime()) {
		if(pTemp.row.admin){//是管理员
			$.alert($.i18n('office.auto.useTime.error.js'));
		}else{//驾驶员
			$.alert($.i18n('office.auto.useTime.error2.js'));
		}
		return;
	}
	openProcePub();
	var autoUse = pTemp.useTab.formobj();
	autoUse.clkBtn = saveOrOut;
	autoUse.type = "autoOut";
	autoUse.applyUser ="";
	autoUse.applyId = pTemp.row.id;
	//出车时间，还车时间可以修改
	
	pTemp.ajaxM.autoUseManage(autoUse,{
		success : function(rval) {
			endProcePub();
			var msgType = fnSendOutCarMsgPub(rval,pTemp.useTab.formobj(),'out');
			var type = msgType.type,msg = msgType.msg;
			
		  if(type == 'error'||type == 'ok'){
				fnMsgBoxPub(msg, type,function(msbox){
					fnReloadPagePub({page:"autoRecedeOut"});
					fnAutoCloseWindow();
				});
			}else{
				fnMsgBoxPub(msg, type);
			}
		},
    error : function(rval) {
    		endProcePub();
    		fnReloadPagePub({page:"autoRecedeOut"});
    		var msg = $.i18n('office.auto.outCar.error.js'),type = 'error';
    		fnMsgBoxPub(msg, type,function(msbox){
  				fnAutoCloseWindow();
  			});
    }
	});
}

function fnCancel(){
	fnAutoCloseWindow();
}

/**
 * 选择驾驶员
 */
function fnSelectPeople(opt){
	fnSelectPeople4Send2OutPub(opt);
}
