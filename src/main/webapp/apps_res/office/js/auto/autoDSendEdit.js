// js开始处理
$(function() {
	pTemp.ajaxM = new autoUseManager();
	pTemp.useTab =  $("#autoUseTab");
	pTemp.editDiv = pTemp.useTab.find("tr[nodePostion=autoOut]");
	//自驾
	pTemp.selfDrivingInput = $("#selfDriving");
	fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	var bDate = new Date();
	var fromDate = bDate.print("%Y-%m-%d %H:%M");
	$("#applyOuttime").val(fromDate);
	pTemp.row = {};
	// 不显示审核
	pTemp.useTab.find("tr[nodePostion=audit]").hide();
	if (pTemp.jval != '') {
		pTemp.row = $.parseJSON(pTemp.jval);
		// 加载打开页面数据
		fnPageReload(pTemp.row);
	}
	pTemp.useTab.disable();
	if(getURLParamPub("isDEdit")=="true"){// 直接派车
		pTemp.useTab.find("tr[nodePostion=autoOut]").hide();// 不显示出车
		pTemp.editDiv = pTemp.useTab;
		pTemp.editDiv.enable();
	}else{
		if (!pTemp.row.admin && pTemp.row.state == 10 && getURLParamPub("isEdit")=="true") {// 驾驶员
			pTemp.editDiv = pTemp.useTab.find("tr[nodePostion=autoOut]");
			pTemp.editDiv.enable();
		}else if (pTemp.row.admin && pTemp.row.state == 10 && getURLParamPub("isEdit")=="true") {// 管理员
			// 编辑区域
			pTemp.editDiv = pTemp.useTab.find("tr[nodeAcl=sendOut]");
			pTemp.editDiv.enable();
			//处理自驾
			fnSelfDriving();
		}else{
			pTemp.editDiv.disable();
		}
		// 自驾置灰
		$("#applySelf2Msg").disable();
		$("#applyDriverPhoneDiv").disable();
		//置灰派车意见
		pTemp.useTab.find("#dispatchOpinionTR").disable();
	}
	pTemp.useTab.resetValidate();
}

/**
 * 刷新页面
 */
function fnPageReload(p) {
	// 出车时间，等于现在时间
	if (p.realOuttime == null || p.realOuttime == '') {
		p.realOuttime = p.nowTime;
	}
	if (p.outmileage == 0) {
		p.outmileage = '';
	}
	pTemp.useTab.fillform(p);
	// 选人组件回填
  $("#userDiv").comp({value : p.applyUser,text : p.applyUserName});
  $("#depDiv").comp({value : p.applyDept,text : p.applyDeptName});
  $("#passengerDiv").comp({value : p.passenger,text : p.passengerName});
}

/**
 * 派车确定调用
 */
function fnOK(operate) {
	pTemp.editDiv.resetValidate();
	var isAgree = pTemp.editDiv.validate();
	if (!isAgree){
		return;
	}
	
	var startTime = fnParseDatePub($("#applyOuttime").val());
	var endTime = fnParseDatePub($("#applyBacktime").val());
	if (startTime.getTime() >= endTime.getTime()) {
	  $.alert($.i18n('office.auto.sdate.compare.edate.js'));
	  return;
	}
	
	if(operate=='sendOut'){
		var nowDate = fnParseDatePub(new Date());	
		if (nowDate.getTime() >= endTime.getTime()) {
			$.alert($.i18n('office.auto.useTime.error.js'));
			return;
		}
	}
	
	openProcePub();
	var autoUse = pTemp.editDiv.formobj();
	autoUse.type = "autoDSend";
	autoUse.applyUser = autoUse.applyUser.split("|")[1];
	autoUse.applyDept = autoUse.applyDept.split("|")[1];
	pTemp.ajaxM.autoUseManage(autoUse,{
		success : function(rval) {
			endProcePub();			
			var msgType = fnSendOutCarMsgPub(rval,pTemp.useTab.formobj());
			var type = msgType.type , msg = msgType.msg;
			
			if (type == 'ok') {
				pTemp.applyId = rval.applyId;				
				if(operate=='sendOut'){
					fnAutoDOut();
				}else{
					if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
						alert(msg);
						fnAutoCloseWindow();
					}else{
						fnMsgBoxPub(msg, type,function(msbox){						
							fnAutoCloseWindow();						
						});
					}
				}				
			} else {
				if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
					alert(msg);
				}else{
					fnMsgBoxPub(msg, type);
				}
			}
			
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.auto.apply.send.fail.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
				fnAutoCloseWindow();
			});
    }
	});
}

/**
 * 直接出车
 */
function fnAutoDOut() {
	var autoUse = {type:"autoDOut",applyId:pTemp.applyId};
	pTemp.ajaxM.autoUseManage(autoUse, {
		success : function(rval) {
			var msg = $.i18n('office.handle.success.js'), type = 'ok';
			if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
				alert(msg);
				endProcePub();
				fnAutoCloseWindow();
			}else{
				fnMsgBoxPub(msg, type, function() {
					endProcePub();
					fnAutoCloseWindow();
				});
			}
		}
	});
}

/**
 * 自驾
 */
function fnSelfDriving(){
	var phone = $("#applyDriverPhone");
	var driverDiv = $("#applyDriverDiv");
	var applyDriverSpan = $("#applyDriverSpan");
	
	if(pTemp.selfDrivingInput.is(':checked')){
		pTemp.driverDivObj = driverDiv.formobj();
		driverDiv.clearform();
		driverDiv.disable();
		applyDriverSpan.hide();
	}else{
		driverDiv.fillform(pTemp.driverDivObj);
		driverDiv.enable();
		applyDriverSpan.show();
	}
	
	phone.disable();
}

/**
 * 取消
 */
function fnCancel() {
	fnAutoCloseWindow();
}

/**
 * 选择驾驶员
 */
function fnSelectPeople(opt){
	fnSelectPeople4Send2OutPub(opt);
}

/**
 * 直接派车后的出车
 */
function fnOutOK(saveOrOut){
	var isAgree = pTemp.editDiv.validate();
	if (!isAgree){
		return;
	}
	
	// 校验实际出车时间大于还车时间
	var realOuttime = fnParseDatePub($("#realOuttime").val());
	var applyBacktime = fnParseDatePub($("#applyBacktime").val());
	
	if (realOuttime.getTime() >= applyBacktime.getTime() && saveOrOut!='save') {
		if(pTemp.row.admin){// 是管理员
			$.alert($.i18n('office.auto.useTime.error.js'));
		}else{// 驾驶员
			$.alert($.i18n('office.auto.useTime.error2.js'));
		}
		return;
	}
	
	// 车辆出车时间晚于
	openProcePub();
	var autoUse = pTemp.useTab.formobj();
	autoUse.clkBtn = saveOrOut;
	autoUse.type = "autoOut";
	autoUse.applyId = pTemp.row.id;
	// 出车时间，还车时间可以修改
	
	pTemp.ajaxM.autoUseManage(autoUse,{
		success : function(rval) {
			endProcePub();
			var msgType = fnSendOutCarMsgPub(rval,pTemp.useTab.formobj());
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

/**
 * 回填部门信息
 */
function fnFillDept(member){
	if(member){
		var dept = getCtpTop().getObject("Department",member.departmentId);
		if (dept) {
			var deptName = dept.name;
			//显示外单位
			if(dept.accountId != $.ctx.CurrentUser.loginAccount){
				var account = getCtpTop().getObject("Account",member.accountId);
				deptName += "("+account.shortname+")";
			}
			$("#depDiv").comp({value : "Department|"+dept.id,text : deptName});
		}
	}
}