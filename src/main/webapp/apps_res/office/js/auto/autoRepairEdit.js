// js开始处理
$(function() {
  pTemp.autoIllegalDiv = $("#autoRepair");
  pTemp.ajaxM = new autoRepairManager();
  fnInitFrom();
  changeTextarea();
});

/**
 * from 回填
 */
function fnInitFrom() {
	var enableAutoNumberFlag = true;
	if (pTemp.jval != '') {
		var pData = $.parseJSON(pTemp.jval);
		if (pData) {
			$('#autoInfoNumber').disable();
			$('#memberName').disable();
			enableAutoNumberFlag = false;
			pTemp.autoIllegalDiv.fillform(pData);
			fnMaintenanceTabDisableOrEnable(pData.repairType);
		}
	} else {
		fnMaintenanceTabDisableOrEnable(0);
	}
	var isDisable = true;
	if (window.parentDialogObj) {
		isDisable = window.parentDialogObj['_office_Illegal_edit'].getTransParams();
	}
	if (isDisable) {
	  pTemp.autoIllegalDiv.disable();
    } else {
	  pTemp.autoIllegalDiv.enable();
    }
	if (!enableAutoNumberFlag) {
		$('#autoInfoNumber').disable();
		$('#memberName').disable();
	}
	 //转换回车字符
	var regS = new RegExp("\\$n","g");
  $("#repairRemarks").val($("#repairRemarks").val().replace(regS,"\r\n"));
  $("#repairProject").val($("#repairProject").val().replace(regS,"\r\n"));
}


/**
 * 点击确定调用事件 
 */
function OK (){
	openProcePub();
 //转换回车字符   OA-80062车辆维护，4个页面的数据，文本域内容，换行显示成代码了
//	$("#repairRemarks").val($("#repairRemarks").val().replace(/[\r\n]/g,"$n"));
//	$("#repairProject").val($("#repairProject").val().replace(/[\r\n]/g,"$n"));
	var repair = pTemp.autoIllegalDiv.formobj();
	var isAgree = pTemp.autoIllegalDiv.validate();
	if (!isAgree) {// js校验
		  endProcePub();
		  return null;
	}
	if(!fnValidateByDate(repair)){
		  endProcePub();
		  return null;
	}
	if (pTemp.isRemind && repair.repairType == '1') {
		if (repair.nextMaintenanceMileage == '') {
			$.alert($.i18n('office.auto.repair.fill.klm.right.js'));
			endProcePub();
			return null;
		}
		if (repair.nextMaintenanceDate == '') {
			$.alert($.i18n('office.auto.repair.fill.time.right.js'));
			endProcePub();
			return null;
		}
	}
	if (repair.repairType == '0') {
		$('#maintenanceMileage').val('');
		$('#nextMaintenanceMileage').val('');
		$('#nextMaintenanceDate').val('');
	}
	if (fnCheckRepairTime ()) {
		$.alert($.i18n('office.auto.repair.timeError.js'));
		endProcePub();
		return null;
	}
	return repair;
}

function fnCheckRepairTime () {
	var returnFlag = false;
	var autoInfoId = $('#autoInfoId').val();
	var repairTime = $('#repairTime').val();
	var retrievalTime = $('#retrievalTime').val();
	var enitid = $("#id").val();
	if (repairTime == '' || retrievalTime == '') {
		return returnFlag;
	}
	var returnFlag = pTemp.ajaxM.findByRepairTimes(enitid,autoInfoId,repairTime,retrievalTime);
	return returnFlag;
}

function fnDisableIncidentDesc (option) {
	if (option == 'disable') {
		$('#incidentDesc').disable();
	} else {
		$('#incidentDesc').enable();
	}
}

function fnSelectCarOrDriverMember(type) {
	var ids = '';
	if (type == 'auto') {
		ids = $('#autoInfoId').val();
		fnSelectPeoplePub({type:type,value:ids,width:400});
	} else {
		ids = $('#memberId').val();
		fnSelectPeoplePub({type:type,value:ids});
	}
	
}

function fnSelectPeople(retval){
	if (retval.okParam && retval.okParam.length > 0) {
		if (retval.type == 'auto') {
			$('#autoInfoId').val(retval.okParam[0].id);
			$('#autoInfoNumber').val(retval.okParam[0].autoNum);
		} else {
			$('#memberId').val(retval.okParam[0].id);
			$('#memberName').val(retval.okParam[0].name);
		}
		repairTimeVer();
	}
	if (retval.dialog) {
		retval.dialog.close();
	}
}

function fnMaintenanceTabDisableOrEnable (_type) {
	if (_type == '0') {
		$('#maintenanceMileageth').hide();
		$('#maintenanceMileageTd').hide();
		$('#maintenanceMileagetext').hide();
		$('#nextMaintenanceDatetr').hide();
		$('#nextMaintenanceMileagetr').hide();
	} else {
		$('#maintenanceMileageth').show();
		$('#maintenanceMileageTd').show();
		$('#maintenanceMileagetext').show();
		$('#nextMaintenanceDatetr').show();
		$('#nextMaintenanceMileagetr').show();
	}
}

/**
 * 验证提交的参数
 */
function fnValidateByDate(repair) {
  var localDate = new Date();
  if(repair.repairTime != '' && repair.retrievalTime != '') {
         if (fnDateParse(repair.repairTime) >= fnDateParse(repair.retrievalTime)) {
			  $.alert($.i18n('office.auto.repair.timege.js'));
			  return false;
		 }
  }
  if (repair.repairType == '1') {
	  if (repair.maintenanceMileage != '' && repair.nextMaintenanceMileagetr != '') {
		  if (parseInt(repair.maintenanceMileage) > parseInt(repair.nextMaintenanceMileagetr)) {
			  $.alert($.i18n('office.auto.repair.mileage.js'));
			  return false;
		  }
	  }
	  if (repair.nextMaintenanceDate != '') {
		  if (fnDateParse(repair.nextMaintenanceDate) <= localDate) {
			  $.alert($.i18n('office.auto.repair.matinDate.js'));
			  return false;
		  }
	  }
	  if(repair.maintenanceMileage !='' && repair.nextMaintenanceMileage !=''){
	    if(parseInt(repair.maintenanceMileage) > parseInt(repair.nextMaintenanceMileage)){
	      $.alert($.i18n('office.auto.repair.fill.klm.error.js'));
        return false;
	    }
	  }
  }
  return true;
}

/**
 * 转换日期
 */
function fnDateParse(dateStr) {
	dateStr = dateStr.replace(/-/g,"/");
	return new Date(dateStr);
}

/**
 * 让textarea单击拥有滚动条,增加长字段的title
 */
function changeTextarea() {
  var Plant = $("#repairPlant").val();
   if($("#repairRemarks").attr("disabled") == 'disabled'){
     $('textarea').removeAttr("disabled");
     $("textarea").attr("readonly","readonly");
     $("textarea").css("background-color","#ecf1ef");
     $("textarea").css("color","#AAA");
   if(Plant.length > 18){
     $("#repairPlant").attr("title",Plant);
   }
   }
}

/**
 * 送修时间校验
 */
function repairTimeVer() {
  var autoInfoId = $('#autoInfoId').val();
  var repairTime = $('#repairTime').val();
  var retrievalTime = $('#retrievalTime').val();
  if (repairTime != '' && retrievalTime != '') {
	  pTemp.ajaxM.verifyRepairTime(autoInfoId,repairTime,retrievalTime,{
		    success : function(returnVal) {
		      if(!returnVal){
		        $.alert($.i18n('office.auto.repair.time.error.js'));
		        $('#repairTime').val("");
		        $('#retrievalTime').val("");
		      }
		    }
	 });
	 retrievalTimeVer();
  }
}

/**
 * 取回时间校验
 */
function retrievalTimeVer() {
  var repairTime = fnDateParse($('#repairTime').val());
  var retrievalTime = fnDateParse($('#retrievalTime').val());
  if (repairTime > retrievalTime) {
    $.alert($.i18n('office.auto.get.car.time.error.js'));
    $('#retrievalTime').val("");
    return false;
  }
  return true;
}  
