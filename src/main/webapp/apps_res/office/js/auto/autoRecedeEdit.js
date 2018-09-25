// js开始处理
$(function() {
	pTemp.ajaxM = new autoUseManager();
	pTemp.autoUseTab = $("#autoUseTab");
	
	pTemp.outmileageInput = $("#outmileage");
	pTemp.backMileageInput = $("#backMileage");
	pTemp.travelMileageInput = $("#travelMileage");
	
	pTemp.realOuttimeInput = $("#realOuttime");
	pTemp.realBacktimeInput = $("#realBacktime");
	
	pTemp.fuelPriceInput = $("#fuelPrice");
	pTemp.applyOuttime = $("#applyOuttime");
	
	fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	if(pTemp.jval != '') {
		var pData = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pData.workFlow;
		pTemp.row = pData;
		// 加载打开页面数据
		fnPageReload(pData);
		if(pTemp.row.state == 15 && (pTemp.row.admin||pTemp.row.autoDriver) && getURLParamPub("isRecedeEdit") =='true'){//待还车
			pTemp.travelMileageInput.disable();
			pTemp.fuelPriceInput.disable();
			pTemp.outmileageInput.blur(fnValidateMileage);
			pTemp.backMileageInput.blur(fnValidateMileage);
		}else{
			pTemp.autoUseTab.disable();
		}
	}
	
	pTemp.realOuttimeInput.disable();
	pTemp.autoUseTab.find("tr[nodePostion=autoOut]").disable();
}

/**
 * 刷新页面
 * 
 * @param areaId，刷新野蛮部分的id
 */
function fnPageReload(p) {
	if(p.realBacktime==null){
		p.realBacktime = p.nowTime;
	}
	//如果没有派车意见隐藏
	pTemp.autoUseTab.fillform(p);
}

/**
 * 计算
 */
function fnValidateMileage(){
	//	OA-60985 废掉之前的校验组件方式，改用正则表达式test
	var reg1 = /^[0-9]{0,9}$/;
	var reg2 = /^[1-9][0-9]{0,8}$/;
	var outmileage = $("#outmileage").val();
	var backMileage = $("#backMileage").val();
	if((outmileage!=""&&(!reg1.test(outmileage))) || (backMileage!="" && (!reg2.test(backMileage)))){
		return;
	}
	if (pTemp.outmileageInput.val().trim() != "" && pTemp.backMileageInput.val().trim() != ""
			&& parseInt(pTemp.backMileageInput.val()) <= parseInt(pTemp.outmileageInput.val())) {
			$.alert($.i18n('office.auto.receded.klm.not.right.js'));
		return;
	}
	
	if(pTemp.outmileageInput.val().trim() != "" && pTemp.backMileageInput.val().trim() != ""){
		pTemp.travelMileageInput.val(pTemp.backMileageInput.val() - pTemp.outmileageInput.val());
		//计算油费
		if (parseFloat(pTemp.row.aveFuelCost) >= 0.001) {
			pTemp.fuelPriceInput.disable();
			pTemp.fuelPriceInput.val(parseFloat(pTemp.travelMileageInput.val())
					* parseFloat(pTemp.row.aveFuelCost)*0.01);
		}
	}else{
		pTemp.fuelPriceInput.enable();
	}
	
	return true;
}

/**
 * 还车
 */
function fnOK() {
	var isAgree = pTemp.autoUseTab.validate();
	
	if (!isAgree){
		return;
	}
	
	if (!fnValidateMileage()){
		return;
	}
	
	//校验时间
	var sDate = fnParseDatePub(pTemp.realOuttimeInput.val()),
	eDate = fnParseDatePub(pTemp.realBacktimeInput.val());
	
	if (eDate.getTime() - sDate.getTime() <= 0) {
		$.alert($.i18n('office.auto.receded.time.notRight.js'));
		return;
	}
	
	openProcePub();

	var autoUse = pTemp.autoUseTab.formobj();
	autoUse.type = "autoRecede";
	autoUse.applyId = pTemp.row.id;
	autoUse.realBacktime = pTemp.realBacktimeInput.val();
	
	pTemp.ajaxM.autoUseManage(autoUse, {
		success : function(rval) {
			var msg = $.i18n('office.handle.success.js'), type = 'ok';
			if(rval.state == "handled"){
				type = "error";
				msg = $.i18n('office.auto.receded.handle.js');
			}
			
			endProcePub();
			fnReloadPagePub({page : "autoRecedeOut"});
			if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
				alert(msg);
				fnAutoCloseWindow();
			}else{
				fnMsgBoxPub(msg, type,function(msbox){
					fnAutoCloseWindow();
				});
			}
			
		},
		error : function(rval) {
			var msg = $.i18n('office.auto.receded.fail.js'), type = 'error';
			
			endProcePub();
			fnMsgBoxPub(msg, type, function() {
				fnAutoCloseWindow();
			});
		}
	});
}

function fnCancel(){
	fnAutoCloseWindow();
}

/**
 * 打印
 */
function fnPrint(){
}