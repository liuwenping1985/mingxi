// js开始处理
$(function() {
  pTemp.driverDiv = $("#driverDiv");
  pTemp.phoneNumber = $("#phoneNumber");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.isNew=true;
  pTemp.isModfiy = false;
  pTemp.phoneNote="";//记录自建人员的手机号
  pTemp.phoneSystemNote="";//记录系统人员的手机号
  pTemp.ajaxM = new autoDriverManager();
  fnPageInIt();
});

// 选人后，回填手机号
function systemMemberNameCallBack(rv) {
  var memberId = rv.obj[0].id;
  var accountId = $.ctx.CurrentUser.loginAccount;
  var member = getA8Top().getObject("Member", memberId, accountId);
  var mobile = member == undefined ? "" : member.mobile;
  pTemp.phoneNumber.val(mobile);
  pTemp.phoneNumber.attr("disabled", "disabled");
  $("#driverDiv").resetValidate();
}
function fnPageInIt() {
  fnSetCss();
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
  $("#driverDiv").resetValidate();
}

/**
 * 页面样式控制
 */
function fnSetCss() {
  if(pTemp.isFirst){
    pTemp.btnDiv.hide();
    pTemp.categoryDiv.disable();
  }
}

function fnOK() {
  $("#driverDiv").resetValidate();
  openProcePub();
  var isAgree = pTemp.driverDiv.validate();
  if (!isAgree) {// js校验
    endProcePub();
    return;
  }
  var driver = pTemp.driverDiv.formobj();
  var systemMemberName = "";
  if (driver.memberType == '1') {
    systemMemberName = driver.memberName;
  } else {
    systemMemberName = driver.systemMemberName_txt;
  }
  
  pTemp.ajaxM.isUniqDriver(driver, {
    success : function(returnVal) {
      if (returnVal ) {// 系统人员已经重复
        $.alert(systemMemberName + $.i18n('office.auto.alreadyexistschoose.js'));
        endProcePub();
        return;
      }
      if (verification(driver)) {
        endProcePub();
        return;
      }
      if (driver.id && typeof (driver.id) != 'undefined') {
        fnUpdate(driver);
      } else {
        fnNew(driver);
      }
    }
  });
 
}
/**
 * 修改
 */
function fnUpdate(driver) {
  $("#driverDiv").resetValidate();
  pTemp.ajaxM.update(driver, {
    success : function() {
      $.infor($.i18n('office.auto.savesuccess.js'));
      // 可以修改一下提交方式
      parent.pTemp.tab.load();
      parent.pTemp.tab.reSize('d');
      // 关闭遮罩
      endProcePub();
    },
    error : function() {
      $.infor($.i18n('office.auto.savefail.js'));
      endProcePub();
    }
  });
}

/**
 * 删除
 */
function fnDelete(warning, rowIds) {
  var rowidsNews = new Array();
  for ( var i = 0; i < rowIds.length; i++) {
    rowidsNews[i] = rowIds[i];
  }
  $.confirm({
    'msg' : warning,
    ok_fn : function() {
      pTemp.ajaxM.deleteByIds(rowidsNews, {
        success : function(returnVal) {
          if(returnVal=="0"){
          $.infor($.i18n('office.auto.delfail.js'));
          }else{
            $.infor($.i18n('office.auto.delsuccess.js'));
          }
          parent.pTemp.tab.load();
          parent.pTemp.tab.reSize('d');
        },
        error : function() {
          $.infor($.i18n('office.auto.delfail.js'));
          parent.pTemp.tab.load();
          parent.pTemp.tab.reSize('d');
        }
      });
    }
  });
}

/**
 * 新建
 */
function fnNew(driver) {
  pTemp.ajaxM.save(driver, {
    success : function() {
      $.infor($.i18n('office.auto.savesuccess.js'));
      // 可以修改一下提交方式
      parent.pTemp.tab.load();
      parent.pTemp.tab.reSize('d');
      // 关闭遮罩
      endProcePub();
    },
    error : function() {
      $.infor($.i18n('office.auto.savefail.js'));
      endProcePub();
    }
  });
}

// 取消按钮
function fnCancel() {
	if(pTemp.isModfiy){
		var confirm = $.confirm({
		    'msg': $.i18n('office.book.bookInfoEdit.qrfqdqcz.js'),
		    ok_fn: function () {
		    	  parent.pTemp.tab.reSize('d');
		    	},
			cancel_fn:function(){return;}
		});
	}else{
		  parent.pTemp.tab.reSize('d');
	}
}

/**
 * 显示或隐藏选人输入框
 */
function fnShowOrHideSelectPeople(type) {
  if (type == 'show') {
    $('#inputNameTr').hide();
    $('#selectPeopleTr').show();
    if(pTemp.isNew){
    $('#systemMemberName_txt').val("");
    $('#memberName').val("");
    pTemp.phoneNumber.val("");
    }else{
      pTemp.phoneNote=pTemp.phoneNumber.val();
      pTemp.phoneNumber.val(pTemp.phoneSystemNote);
    }
    $('#selectPeopleTr').removeAttr("disabled");
    pTemp.phoneNumber.attr("disabled", "disabled");
  } else {
    $('#selectPeopleTr').hide();
    $('#inputNameTr').show();
    if(pTemp.isNew){
      pTemp.phoneNumber.val("");
    }else{
      pTemp.phoneSystemNote=pTemp.phoneNumber.val();
      pTemp.phoneNumber.val(pTemp.phoneNote);
    }
    pTemp.phoneNumber.removeAttr("disabled");
  }
}

/**
 * 查看修改调用方法
 */
function fnShowDetail(type, row) {
  if (type == 'show' || type == 'update') {
    pTemp.driverDiv.clearform();
    pTemp.driverDiv.fillform(row);
    $("#driverDiv").resetValidate();
    pTemp.phoneNote="";//清空人员的手机号
    pTemp.phoneSystemNote=""
    if (type == 'show') {
      pTemp.btnDiv.hide();
      pTemp.driverDiv.disable();
    } else {
      pTemp.isNew=false;
      pTemp.btnDiv.show();
      pTemp.driverDiv.enable();
    }
    if (row.memberType == '0') {
      $('#inputNameTr').hide();
      $('#selectPeopleTr').show();
      var memberId = "Member|" + row.memberId;
      $("#systemMemberName").comp({
        value : memberId,
        text : row.systemMemberName
      });
    } else {
      $("#systemMemberName_txt").val("");
      $('#selectPeopleTr').hide();
      $('#inputNameTr').show();
    }
    if (type == 'update' && row.memberType == '1') {
      pTemp.phoneNumber.remove("disabled");
    } else {
      pTemp.phoneNumber.attr("disabled", "disabled");
    }
  } else if (type == 'add') {
	pTemp.isModfiy = false;
    pTemp.isNew=true;
    pTemp.btnDiv.show();
    pTemp.driverDiv.enable();
    fnShowOrHideSelectPeople('show');
    pTemp.driverDiv.clearform();
    $("input:hidden").each(function() {
      $(this).val("");
    });
    $('input[name=memberType]:eq(0)').attr('checked', 'checked');
    $("select[id=licenseType] option[value=0]").attr('selected','selected');
  }
  if(type == 'update'){
	  pTemp.isModfiy = true;
  }
}

/**
 * 验证提交的参数
 */
function verification(driver) {
  var LocaleDate = getLocaleDate();
  if (driver.receiveDate != "" && driver.validStartDate != "" && driver.receiveDate > driver.validStartDate) {
    $.alert($.i18n('office.auto.errorhelpone.js'));
    return true;
  }
  if (driver.validStartDate != "" && driver.validEndDate != "" && driver.validStartDate >= driver.validEndDate) {
    $.alert($.i18n('office.auto.errorhelptwo.js'));
    return true;
  }
  if (driver.receiveDate != "" && driver.receiveDate > LocaleDate + 1) {
    $.alert($.i18n('office.auto.errorhelpthree.js'));
    return true;
  }
  return false;
}

/**
 * 获得当前时间 XXXX-XX-XX
 */
function getLocaleDate() {
  var d = new Date();
  var year = d.getFullYear();
  var month = d.getMonth() + 1;
  month = month < 10 ? ("0" + month) : month;
  var dt = d.getDate();
  dt = dt < 10 ? ("0" + dt) : dt;
  var today = year + "-" + month + "-" + dt;
  return today;
}
