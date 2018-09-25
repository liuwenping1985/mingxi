// js开始处理
$(function() {
  pTemp.autoIllegalDiv = $("#autoSafetyEdit");
  var isDisable = true;
  if (window.parentDialogObj) {
	  isDisable = window.parentDialogObj['_office_Safety_edit'].getTransParams();
  }
  if (isDisable) {
	  pTemp.autoIllegalDiv.disable();
  } else {
	  pTemp.autoIllegalDiv.enable();
  }
  fnInitFrom();
});

/**
 * from 回填
 */
function fnInitFrom() {
	if (pTemp.jval != '') {
		var pData = $.parseJSON(pTemp.jval);
		if (pData) {
			$('#autoInfoNumber').disable();
			$('#memberName').disable();
			pTemp.autoIllegalDiv.fillform(pData);
		}
	}
	//转换回车字符 
	var regS = new RegExp("\\$n","g");
	$("#insureRemark").val($("#insureRemark").val().replace(regS,"\r\n"));
	changeTextarea();
	pTemp.ajaxM = new autoSafetyManager();
}


/**
 * 点击确定调用事件 
 */
function OK (){
	openProcePub();
//转换回车字符  OA-80062车辆维护，4个页面的数据，文本域内容，换行显示成代码了
	//$("#insureRemark").val($("#insureRemark").val().replace(/[\r\n]/g,"$n"));
	var isAgree = pTemp.autoIllegalDiv.validate();
	if (!isAgree) {// js校验
	    endProcePub();
	    return;
	}
	var safety = pTemp.autoIllegalDiv.formobj();
	if (!fnValidateByDate(safety)) {
	    endProcePub();
	    return;
	}
	if (fnCheckSafetyDate()) {
		$.alert($.i18n('office.auto.safety.timeError.js'));
		endProcePub();
	    return;
	}
	return safety;
}

function fnCheckSafetyDate() {
	var autoInfoId = $('#autoInfoId').val();
	var startDate = $('#insuredDate').val();
	var endDate = $('#expDate').val();
	var autoSafetyId = $("#id").val();
	return pTemp.ajaxM.findByAutoSafetyDate(autoSafetyId,autoInfoId,startDate,endDate);
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
	} else {
		ids = $('#memberId').val();
	}
	fnSelectPeoplePub({type:type,value:ids});
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
	}
	if (retval.dialog) {
		retval.dialog.close();
	}
}


function fnValidateByDate(safety) {
	var localDate = new Date();
	if (safety.insuredDate != '' && safety.expDate != '') {
		  if (fnDateParse(safety.insuredDate) > fnDateParse(safety.expDate)) {
			  $.alert($.i18n('office.auto.safety.datege.js'));
			  return false;
		  }
	}
	return true;
}

/**
 * 让textarea单击拥有滚动条,增加长字段的title
 */
function changeTextarea() {
  var policyNum = $("#policyNum").val();
  var insureCompany = $("#insureCompany").val();
   if($("#insureRemark").attr("disabled") == 'disabled'){
     $('#insureRemark').removeAttr("disabled");
     $("#insureRemark").attr("readonly","readonly");
     $("#insureRemark").css("background-color","#ecf1ef");
     $("#insureRemark").css("color","#AAA");
   if(policyNum.length > 25){
     $("#policyNum").attr("title",policyNum);
   }
   if(insureCompany.length > 12){
     $("#insureCompany").attr("title",insureCompany);
   }
   }
}

/**
 * 转换日期
 */
function fnDateParse(dateStr) {
	dateStr = dateStr.replace(/-/g,"/");
	return new Date(dateStr);
}
