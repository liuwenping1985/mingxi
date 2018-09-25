// js开始处理
$(function() {
  pTemp.bookHouseDiv = $("#bookHouseDiv");
  pTemp.btnDiv = $("#btnDiv");
  pTemp.ok = $("#btnok");
  pTemp.cancel = $("#btncancel");
  pTemp.ajaxM = new bookHouseManager();
  pTemp.isModfiy = false;
  fnPageInIt();
});

function fnPageInIt() {
  pTemp.ok.click(fnOK);
  pTemp.cancel.click(fnCancel);
  if(pTemp.isFirst){
    pTemp.btnDiv.hide();
    pTemp.categoryDiv.disable();
  }
  $("#bookHouseDiv").resetValidate();
}

function fnOK() {
  openProcePub();
  $("#bookHouseDiv").resetValidate();
   var isAgree = pTemp.bookHouseDiv.validate();
   if (!isAgree) {// js校验
   endProcePub();
   return;
   }
   if(verifyDate()){
     $.alert($.i18n('office.book.bookHouseEdit.yjtsbndyjyts.js'));
     endProcePub();
     return;
   }
  var bookHouse = pTemp.bookHouseDiv.formobj();
  pTemp.ajaxM.isUniqBookHouse(bookHouse, {
    success : function(returnVal) {
      if (returnVal) {// 系统人员已经重复
        $.alert($.i18n('office.book.bookHouseEdit.tszlkycz.js'));
        endProcePub();
        return;
      }
      if (bookHouse.id && typeof (bookHouse.id) != 'undefined') {
        fnUpdate(bookHouse);
      } else {
        fnNew(bookHouse);
      }
      pTemp.bookHouseDiv.clearform(); // 清空数据
      $("#bookHouseDiv").resetValidate();
    }
  });
}

function fnCancel() {
	if(pTemp.isModfiy){
		var confirm = $.confirm({
		    'msg': $.i18n('office.book.bookInfoEdit.qrfqdqcz.js'),
		    ok_fn: function () {
		    	parent.pTemp.tab.reSize("d");
		    	},
			cancel_fn:function(){return;}
		});
	}else{
		parent.pTemp.tab.reSize("d");
	}
}
/**
 * 新建
 */
function fnNew(bookHouse) {
  if(pTemp.protectDbClk=="allow"){
    pTemp.protectDbClk = "negative";
    pTemp.ajaxM.save(bookHouse, {
      success : function() {
        $.infor($.i18n('office.auto.savesuccess.js'));
        // 可以修改一下提交方式
        parent.pTemp.tab.load();
        parent.pTemp.tab.reSize('d');
        // 关闭遮罩
        endProcePub();
        pTemp.protectDbClk=="allow";
      },
      error : function() {
        $.alert($.i18n('office.auto.savefail.js'));
        endProcePub();
        pTemp.protectDbClk=="allow";
      }
    });
  }
}

/**
 * 修改
 */
function fnUpdate(bookHouse) {
  pTemp.ajaxM.update(bookHouse, {
    success : function() {
      $.infor($.i18n('office.auto.savesuccess.js'));
      // 可以修改一下提交方式
      parent.pTemp.tab.load();
      parent.pTemp.tab.reSize('d');
      // 关闭遮罩
      endProcePub();
    },
    error : function() {
      $.alert($.i18n('office.auto.savefail.js'));
      endProcePub();
    }
  });
}

/**
 * 删除
 */
function fnDelete(rowId) {
  var canDel = pTemp.ajaxM.deleteByIds(rowId);
  if(!canDel){
	  $.alert($.i18n('office.book.bookHouseEdit.gtskxcztsbnsc.js'));
	  return;
  }
  
  $.confirm({
    'msg' : $.i18n('office.auto.really.delete.js'),
    ok_fn : function() {
      pTemp.ajaxM.deleteByIds(rowId, {
        success : function(returnVal) {
          if (returnVal == true) {
            $.infor($.i18n('office.auto.delsuccess.js'));
          } else {
            $.alert($.i18n('office.book.bookHouseEdit.gtskxcztsbnsc.js'));
          }
          parent.pTemp.tab.load();
          parent.pTemp.tab.reSize('d');
        },
        error : function() {
          $.alert($.i18n('office.auto.delfail.js'));
          parent.pTemp.tab.load();
          parent.pTemp.tab.reSize('d');
        }
      });
    }
  });
}

function fnShowDetail(type, row) {
  if (type == 'show') {
    bookfillform(row);
    pTemp.protectDbClk = "allow";
    pTemp.bookHouseDiv.disable();
    pTemp.btnDiv.hide();
  }
  if (type == 'update') {
	pTemp.isModfiy = true;
    bookfillform(row);
    pTemp.bookHouseDiv.enable();
    pTemp.btnDiv.show();
  }
  if (type == 'add') {
  	pTemp.isModfiy = false;
  	pTemp.protectDbClk = "allow";
    initData();
    pTemp.btnDiv.show();
    pTemp.bookHouseDiv.enable();
    $('#rangeScope').val("");
  }
}

function fnSelectBookMember(type) {
  var houseManagerId = $('#houseManager').val();
  if (type == 'BookMember') {
    fnSelectPeoplePub({
      type : type,
      value : houseManagerId
    });
  }
}

function fnSelectPeople(retval) {
  var BookMember = retval.okParam;
  if(BookMember.length == 0 ){
    $.alert($.i18n('office.book.bookHouseEdit.tszsxzxsjdqyxzx.js'));
    return ;
  }
  var houseManager_text = BookMember[0].name;
  var houseManager = BookMember[0].id;
  for ( var i = 1; i < BookMember.length; i++) {
    houseManager_text = houseManager_text + '、' + BookMember[i].name;
    houseManager = houseManager + ',' + BookMember[i].id;
  }
  if (retval.okParam) {
    $('#houseManager_txt').val(houseManager_text);
    $('#houseManager').val(houseManager);
  }
  if (retval.dialog) {
    retval.dialog.close();
  }
}

function bookfillform(row) {
  pTemp.bookHouseDiv.fillform(row);
  $("#rangeScope").val(row.rangeScope);
  $("#rangeScope_txt").attr("value", row.range);
  $("#rangeScope_txt").attr("title", row.range);
}

// 初始化数据
function initData(){
  pTemp.bookHouseDiv.clearform();
  $("#id").val('');
  $("#houseManager").val($.ctx.CurrentUser.id);
  $("#houseManager_txt").val($.ctx.CurrentUser.name);
  $("#borrowDays").val('14');
  $("#alertDays").val('2');
  $("#bookHouseDiv").resetValidate();
}

// 校验数据
function verifyDate(){
  var borrowDays = $("#borrowDays").val();
  var alertDays = $("#alertDays").val();
  if(parseInt(borrowDays) < parseInt(alertDays)){
    return true;
  }else{
    return false;
  }
}