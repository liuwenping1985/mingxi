// js开始处理
$(function() {
  pTemp.autoIllegalDiv = $("#autoIllegal");
  var isDisable = true;
  if (window.parentDialogObj) {
	  isDisable = window.parentDialogObj['_office_Illegal_edit'].getTransParams();
  }
  if (isDisable) {
	  pTemp.autoIllegalDiv.disable();
  } else {
	  pTemp.autoIllegalDiv.enable();
  }
  pTemp.ajaxM = new autoIllegalManager();
  fnInitFrom();
});

/**
 * from 回填
 */
function fnInitFrom() {
	if (pTemp.jval != '') {
		var pData = $.parseJSON(pTemp.jval);
		if (pData) {
			pTemp.autoIllegalDiv.fillform(pData);
			$("#autoInfoNumber").disable();
			$("#driverMemberName").disable();
			if (pData.illegalFlag == '0' && $('#illegalFlag').attr('disabled') != 'disabled') {
				$('#illegalContent').removeAttr("disabled");
				changeTextarea('0');
			}else{
			  changeTextarea('1');
			}
		}
	  //转换回车字符
		var regS = new RegExp("\\$n","g");
	  $("#illegalContent").val($("#illegalContent").val().replace(regS,"\r\n"));
	}
}


/**
 * 点击确定调用事件 
 */
function OK (){
	openProcePub();
	//OA-80062车辆维护，4个页面的数据，文本域内容，换行显示成代码了
  //$("#illegalContent").val($("#illegalContent").val().replace(/[\r\n]/g,"$n"));
	var illegal = pTemp.autoIllegalDiv.formobj();
	var isAgree = pTemp.autoIllegalDiv.validate();
	if (!isAgree) {// js校验
	    endProcePub();
	    return null;
	}
	if(!fnValidateByDate(illegal)){
		  endProcePub();
		  return null;
	}
	
	if (fnCheckIllegalDate()) {
		 $.alert($.i18n('office.auto.illegal.timeError.js'));
		 endProcePub();
		 return null;
	}
	
	return illegal;
}

function fnCheckIllegalDate() {
	var autoInfoId = $('#autoInfoId').val();
	var illegalDate = $('#illegalDate').val();
	var illegalId = $("#id").val();
	return pTemp.ajaxM.findByAutoIllegalDate(illegalId,autoInfoId,illegalDate);
}

function fnDisableIncidentDesc (option) {
	if (option == 'disable') {
		$('#illegalContent').val('');
		changeTextarea('1');
	} else {
	  $('#illegalContent').removeAttr("disabled");
		changeTextarea('0');
	}
}

function fnSelectCarOrDriverMember(type) {
	var ids = '';
	if (type == 'auto') {
		ids = $('#autoInfoId').val();
	} else {
		ids = $('#autoDriverId').val();
	}
	fnSelectPeoplePub({type:type,value:ids});
}

function fnSelectPeople(retval){
	if (retval.okParam && retval.okParam.length > 0) {
		if (retval.type == 'auto') {
			var illegalDate = $('#illegalDate').val();
			if (illegalDate != '') {
				showDriverByAutoApp(retval.okParam[0].id,illegalDate);
			}
			$('#autoInfoId').val(retval.okParam[0].id);
			$('#autoInfoNumber').val(retval.okParam[0].autoNum);
		} else {
			$('#autoDriverId').val(retval.okParam[0].id);
			$('#driverMemberName').val(retval.okParam[0].memberName);
		}
	}
	if (retval.dialog) {
		retval.dialog.close();
	}
}


function fnShowDriver (){
	var autoInfoId = $('#autoInfoId').val();
	var illegalDate = $('#illegalDate').val();
	if (autoInfoId != '' && illegalDate != '') {
		showDriverByAutoApp(autoInfoId,illegalDate);
	}
}
var isFillDriverFlag = false;
function showDriverByAutoApp(autoinfoId , illegalDate) {
	var item = {
			"autoInfoId":autoinfoId,
			"illegalDate":illegalDate
	}
	pTemp.ajaxM.fingDriverByIllegal(item, {
	    success : function(returnVal) {
	    	if (returnVal != '') {
	    		var jsonValue = eval(returnVal);
	    		if (jsonValue && jsonValue != null) {
	    			isFillDriverFlag = true;
					$('#autoDriverId').val(jsonValue[0].id);
					$('#driverMemberName').val(jsonValue[0].memberName);
	    		}
	    	} else {
	    		if (isFillDriverFlag) {
	    			$('#autoDriverId').val("");
					$('#driverMemberName').val("");
	    		}
	    	}
	    }
	});
}

/**
 * 让textarea单击拥有滚动条,增加长字段的title
 */
function changeTextarea(illegalFlag) {
  var addr = $('#illegalAddr').val();
  var action = $('#illegalAction').val();
   if(illegalFlag == '1'){
     $('#illegalContent').attr("disabled","disabled");
     $('#illegalContent').attr("readonly","readonly");
     $('#illegalContent').css("background-color","#ecf1ef");
     $('#illegalContent').css("color","#AAA");
   }else{
	   $('#illegalContent').removeAttr("disabled");
       $('#illegalContent').removeAttr("readonly");
       $('#illegalContent').css("background-color","#fff");
       $('#illegalContent').css("color","#000");
   }
   if(action.length > 15 && $('#illegalAction').attr("disabled") == 'disabled'){
     $('#illegalAction').attr("title",action);
   }
   if(addr.length > 15 && $('#illegalAddr').attr("disabled") == 'disabled'){
     $('#illegalAddr').attr("title",addr);
   }
}

function fnValidateByDate(illegal) {
	var localDate = new Date();
	if (illegal.illegalDate != '') {
		if (fnDateParse(illegal.illegalDate) > localDate) {
			$.alert($.i18n('office.auto.illegal.illegaldate.js'));
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

