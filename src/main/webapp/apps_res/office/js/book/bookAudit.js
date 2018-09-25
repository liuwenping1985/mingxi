$(function() {
  // 初始化查询框
  pTemp.SBar = officeSBar("fnInitSearchBar").addAll(
      [ "applyUser", "applyDept", "applyDate" ]).init();
  // 初始化列表
  pTemp.tab = officeTab().addAll(
      [ "id", "applyUser", "applyDept", "bookName", "bookCategory",
          "bookHouseName", "applyDate", "applyCount", "applyState" ]).init(
      "bookApply", {
        argFunc : "fnBookApplyItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,
        resizable : false,
        "managerName" : "bookApplyManager",
        "managerMethod" : "find"
      });
  pTemp.TBar = officeTBar().addAll([ "batchApproval" ]).init("toolbar");
  pTemp.ajaxM = new bookApplyManager();
  pTemp.editIframe = $("#editIframe");
  pTemp.tab.load();
});
var treeTempValue = 0;

function fnPageInIt() {
}

function fnPageReload() {
  pTemp.tab.load();
}

function fnSetCss() {
}

/*******************************************************************************
 * 单击Tab查看
 */
function fnTabClk() {
  showAuditWindow();
}

function showAuditWindow() {
  var rows = pTemp.tab.selectRows();
  var url = "/office/bookUse.do?method=bookAuditDetail&bookApplyId="
      + rows[0].id + "&v=" + rows[0].v, title = $
      .i18n('office.book.bookAudit.tszlsp.js');
  fnAutoOpenWindow({
    "url" : url,
    "title" : title,
    hasBtn : false,
    width : 800,
    height : 600
  });
}

/*******************************************************************************
 * 双击Tab查看
 */
function fnTabDBClk() {

}

function fnBookApplyItems() {
  return {
    "id" : {
      display : 'id',
      name : 'id',
      width : '3%',
      sortable : false,
      align : 'center',
      type : 'checkbox',
      isToggleHideShow : true
    },
    "applyUser" : {
      display : $.i18n('office.stock.use.user.js'),
      name : 'applyUser',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false
    },
    "applyDept" : {
      display : $.i18n('office.stock.use.dep.js'),
      name : 'applyDept',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "bookName" : {
      display : $.i18n('office.asset.apply.assetName.js'),
      name : 'bookName',
      width : '17%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "bookCategory" : {
      display : $.i18n('office.bookinfo.category.js'),
      name : 'bookCategory',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "bookHouseName" : {
      display : $.i18n('office.bookhouse.js'),
      name : 'bookHouseName',
      width : '17%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "applyDate" : {
      display : $.i18n('office.bookapply.applydate.js'),
      name : 'applyDate',
      width : '15%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "applyCount" : {
      display : $.i18n('office.bookapply.applysum.js'),
      name : 'applyCount',
      width : '8%',
      sortable : true,
      align : 'right',
      isToggleHideShow : true
    },
    "applyState" : {
      display : $.i18n('office.asset.query.state.js'),
      name : 'applyState',
      width : '8%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true,
      codecfg : "codeType:'java',codeId:'com.seeyon.apps.office.constants.BookInfoApplyState'"
    }
  }
}

function fnShowDetail(mode) {
  var rows = pTemp.tab.selectRows();
  if (mode === 'modify') {
    if (rows.length == 0) {
      $.alert($.i18n('office.book.bookAudit.qxzybjdbgyp.js'));
      return;
    } else if (rows.length > 1) {
      $.alert($.i18n('office.book.myLend.znxzytjl.js'));
      return;
    }
  }
  pTemp.tab.reSize('m');
  if(!pTemp.cPage || !pTemp.cPage.fnPageReload){//快速点击报错问题
  	return;
  }
  pTemp.cPage.fnPageReload({
    "mode" : mode,
    "row" : rows[0],
    "treeTempValue" : treeTempValue
  });
}

function fnDel() {
  var rowIds = pTemp.tab.selectRowIds();

  if (rowIds.length == 0) {
    $.alert($.i18n('office.book.myLend.qxzyscdsqjl.js'));
    return;
  }
  fnRealDel(rowIds);
}

function fnRealDel(rowIds) {
  $.confirm({
    'msg' : $.i18n('office.book.bookAudit.qdyscyjxzdsqjl.js'),
    ok_fn : function() {
      pTemp.ajaxM.deleteApplyByIds(rowIds, {
        success : function() {
          $.infor($.i18n('office.book.myLend.sccg.js'));
          pTemp.tab.load();
        }
      });
    }
  });
}

/**
 * 查询
 */
function fnSBarQuery(obj) {
  // 查询的时候，记录下查询条件，供导出用
  pTemp.condition = obj.condition;
  pTemp.value = obj.value;
  pTemp.tab.load(obj);
}

function fnBookApplyStateItems() {
  var options = [];
  options[0] = {
    text : $.i18n('office.book.bookAudit.dsp.js'),
    value : "1"
  };
  options[1] = {
    text : $.i18n('office.book.bookAudit.djc.js'),
    value : "5"
  };
  options[2] = {
    text : $.i18n('office.book.bookAudit.qb.js'),
    value : "-1"
  };
  return options;
}

/**
 * 搜索框初始化
 * 
 * @returns
 */
function fnInitSearchBar() {
  return {
    "applyUser" : {
      id : 'applyUser',
      name : 'applyUser',
      type : 'input',
      text : $.i18n('office.stock.use.user.js'),
      value : 'applyUser'
    },
    "applyDept" : {
      id : 'applyDept',
      name : 'applyDept',
      type : 'selectPeople',
      text : $.i18n('office.stock.use.dep.js'),
      value : 'applyDept',
      comp : "type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',maxSize:'1'"
    },
    "applyDate" : {
      id : 'applyDate',
      name : 'applyDate',
      type : 'datemulti',
      text : $.i18n('office.stock.use.applydate.js'),
      value : 'applyDate',
      ifFormat : '%Y-%m-%d',
      dateTime : false
    }
  }
}
/**
 * 批量审批
 */
function fnBatchApproval() {
  var rowIds = pTemp.tab.selectRowIds();
  if (rowIds == null || rowIds == "") {
    $.alert($.i18n('office.book.bookRemand.qzsxzytjl.js'));
  } else {
    var baDialog = $.dialog({
      url : _ctxPath + '/office/bookUse.do?method=batchApproval',
      title : $.i18n('office.tbar.batchApproval.js'),
      width : 450,
      height : 200,
      buttons : [{
        text : $.i18n('office.book.bookInfoDetail4Audit.ptgbjc.js'),
        id : "passAndLend",
        isEmphasize : true,
        handler : function() {
          var re = baDialog.getReturnValue();
          var vali = re.vali;
          if(vali == "false"){
            return false;
          }else{
            var data = {
              auditFlag : "audit",
              ids : rowIds,
              flag : "passAndLend",
              auditOpinion : re.approvalText
            };
            fnAjaxBatchApproval(data);
            baDialog.close();
          }
        }
      }, {
        text : $.i18n('office.book.bookInfoDetail4Audit.ptg.js'),
        id : "pass",
        isEmphasize : true,
        handler : function() {
          var re = baDialog.getReturnValue();
          var vali = re.vali;
          if(vali == "false"){
            return false;
          }else{
            var data = {
                auditFlag : "audit",
                ids : rowIds,
                flag : "pass",
                auditOpinion : re.approvalText
            };
            fnAjaxBatchApproval(data);
            baDialog.close();
          }
        }
      }, {
        text : $.i18n('office.book.bookInfoDetail4Audit.pbtg.js'),
        id : "noPass",
        handler : function() {
          var re = baDialog.getReturnValue();
          var vali = re.vali;
          if(vali == "false"){
            return false;
          }else{
            var data = {
                auditFlag : "audit",
                ids : rowIds,
                flag : "noPass",
                auditOpinion : re.approvalText
            };
            fnAjaxBatchApproval(data);
            baDialog.close();
          }
        }
      }]
    });
  }

}
function fnAjaxBatchApproval(data) {
  pTemp.ajaxM.batchAuditBookApply(data, {
    success : function(rv) {
      if (rv.successNum == rv.totalNum) {
        $.infor($.i18n('office.handle.success.js'));
      } else {
        if (rv.numFailList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.numFailList.length; i++) {
            str = str + "《" + rv.numFailList[i] + "》";
          }
          $.alert($.i18n('office.book.bookBorrow.yxtskcbzbyxzjjc.js') + "<br>"
              + str);
        }else if (rv.dateFailList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.dateFailList.length; i++) {
            str = str + "《" + rv.numFailList[i] + "》";
          }
          $.alert($.i18n('office.book.bookBorrow.yxtszljcsjcgjyqx.js') + "<br>"
              + str);
        }else if (rv.failList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.failList.length; i++) {
            str = str + "《" + rv.failList[i] + "》";
          }
          $.alert($.i18n('office.manager.BookApplyManagerImpl.spsb1.js')
              + "<br>" + str);// 审批
        }
      }
      pTemp.tab.load();
    },
    error : function(rv) {
      $.error("error");
    }
  });

}
