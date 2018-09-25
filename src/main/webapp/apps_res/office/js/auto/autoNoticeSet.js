// js开始处理
$(function() {
  pTemp.reminDiv = $("#reminDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.ajaxM = new autoRemindManager();
  
  fnPageInIt();
  fnSetCss();
});

$(document).ready(function() {
  $(window).load(function() {
    fnCancel();
  });
});

/**
 * 页面样式控制
 */
function fnSetCss() {
}
/**
 * 页面初始化
 */
function fnPageInIt() {
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
}

/**
 * 确定
 */
function fnOK() {
  $("#reminDiv").resetValidate();
  var checkRepair = $("#checkRepair");
  var checkInspection = $("#checkInspection");
  var checkSafety = $("#checkSafety");
  var checkLicense = $("#checkLicense");
  
  if(!checkRepair.is(':checked')){
    $("#remindMilRepair").val("");
    $("#remindDateRepair").val("");
  }
  if(!checkInspection.is(':checked')){
    $("#remindDateInspection").val("");
  }
  if(!checkSafety.is(':checked')){
    $("#remindDateSafety").val("");
  }
  if(!checkLicense.is(':checked')){
    $("#remindDateLicense").val("");
  }
  if(checkRepair.is(':checked')){
    if(reminfunc()){
      endProcePub();
      return ;
    }
  }
    var isAgree = $("#reminDiv").validate();
    if (isAgree) {
    	var remianInfo = pTemp.reminDiv.formobj();
        pTemp.ajaxM.saveRemin(remianInfo, {
            success : function(returnVal) {
              $("#reminDiv").fillform(returnVal);
              $.infor($.i18n('office.auto.savesuccess.js'));
            }
        });
    }
}

/**
 * 
 * 根据是否选择加载样式
 */
function reminClick(){
  var checkRepair = $("#checkRepair");
  var checkInspection = $("#checkInspection");
  var checkSafety = $("#checkSafety");
  var checkLicense = $("#checkLicense");
  
  if(!checkRepair.is(':checked')){
    $("#remindMilRepair").disable();
    $("#remindDateRepair").disable();
  }else{
    $("#remindMilRepair").enable();
    $("#remindDateRepair").enable();
  }
  if(!checkInspection.is(':checked')){
    $("#remindDateInspection").disable();
  }else{
    $("#remindDateInspection").enable();
  }
  if(!checkSafety.is(':checked')){
    $("#remindDateSafety").disable();
  }else{
    $("#remindDateSafety").enable();
  }
  if(!checkLicense.is(':checked')){
    $("#remindDateLicense").disable();
  }else{
    $("#remindDateLicense").enable();
  }
}

function reminfunc(){
  if($("#remindMilRepair").val()=="" && $("#remindDateRepair").val()==""){
    $.alert($.i18n('office.auto.notice.alert.js'));
    return true;
  }
  return false;
}

/**
 * 取消
 */
function fnCancel() {
  pTemp.ajaxM.findRemin({
    success : function(returnVal) {
      var checkRepair = $("#checkRepair");
      var checkInspection = $("#checkInspection");
      var checkSafety = $("#checkSafety");
      var checkLicense = $("#checkLicense");
      if((returnVal.remindMilRepair!="" && returnVal.remindMilRepair!=null)
    		  || (returnVal.remindDateRepair!="" && returnVal.remindDateRepair!=null)){
        checkRepair.attr("checked", true);
      } else {
    	  checkRepair.removeAttr("checked");
      }
      if(returnVal.remindDateInspection!="" && returnVal.remindDateInspection!=null){
        checkInspection.attr("checked", true);
      } else {
    	  checkInspection.removeAttr("checked");
      }
      if(returnVal.remindDateSafety!="" && returnVal.remindDateSafety!=null){
        checkSafety.attr("checked", true);
      } else {
    	  checkSafety.removeAttr("checked");
      }
      if(returnVal.remindDateLicense!="" && returnVal.remindDateLicense!=null){
        checkLicense.attr("checked", true);
      } else {
    	  checkLicense.removeAttr("checked");
      }
      reminClick();
      $("#reminDiv").fillform(returnVal);
      endProcePub();
    }
});
}
