// js开始处理
$(function() {
  pTemp.autoIllegalDiv = $("#autoInspection");
  var isDisable = true;
  if (window.parentDialogObj) {
	  isDisable = window.parentDialogObj['_office_Safety_edit'].getTransParams();
  }
  if (isDisable) {
	  pTemp.autoIllegalDiv.disable();
  } else {
	  pTemp.autoIllegalDiv.enable();
  }
  pTemp.ajaxM = new autoInspectionManager();
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
  $("#remark").val($("#remark").val().replace(regS,"\r\n"));
	changeTextarea();
}


/**
 * 点击确定调用事件 
 */
function OK (){
	openProcePub();
	 //转换回车字符 OA-80062车辆维护，4个页面的数据，文本域内容，换行显示成代码了
  //$("#remark").val($("#remark").val().replace(/[\r\n]/g,"$n"));
	var inspection = pTemp.autoIllegalDiv.formobj();
	var isAgree = pTemp.autoIllegalDiv.validate();
	if (!isAgree) {// js校验
	    endProcePub();
	    return null;
	}
	if (!fnValidateByDate(inspection)) {
	    endProcePub();
	    return null;
	}
	if (fnCheckInspectionDate()) {
		$.alert($.i18n('office.auto.inspection.timeError.js'));
		endProcePub();
	    return null;
	}
	return inspection;
}

function fnCheckInspectionDate () {
	var autoInfoId = $('#autoInfoId').val();
	var startDate = $('#inspectionDate').val();
	var endDate = $('#expDate').val();
	var autoinspectionId = $("#id").val();
	return pTemp.ajaxM.findByInspectionDates(autoinspectionId,autoInfoId,startDate,endDate);
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

function fnValidateByDate(inspection) {
	var localDate = new Date();
	if (inspection.inspectionDate != '' && inspection.expDate != '') {
		  if (fnDateParse(inspection.inspectionDate) > fnDateParse(inspection.expDate)) {
			  $.alert($.i18n('office.auto.inspection.datele.js'));
			  return false;
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
  var addr = $("#inspectionAddr").val();
   if($("#remark").attr("disabled") == 'disabled'){
     $('#remark').removeAttr("disabled");
     $("#remark").attr("readonly","readonly");
     $("#remark").css("background-color","#ecf1ef");
     $("#remark").css("color","#AAA");
     if(addr.length > 16){
       $("#inspectionAddr").attr("title",addr);
     }
   }
}
