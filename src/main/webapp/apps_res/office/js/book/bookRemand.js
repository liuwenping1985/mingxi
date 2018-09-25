$(function() {
  // toolBar初始化
  pTemp.sTBar = officeTBar().addAll([ "recall", "bookBatchReturn" ]).init(
      "toolbar");
  // 初始化查询框
  pTemp.SBar = officeSBar("fnInitSearchBar").addAll(
      [ "applyUser", "applyDept", "applyBookHouse", "applyBookType" ]).init();
  // 初始化列表
  pTemp.tab = officeTab().addAll(
      [ "id", "applyUser", "applyDept", "bookName", "bookHouseName",
          "bookCategory", "applyDate", "stateStr" ]).init("bookRemand", {
    argFunc : "fnBookApplyItems",
    parentId : $('.layout_center').eq(0).attr('id'),
    slideToggleBtn : false,
    resizable : false,
    "managerName" : "bookApplyManager",
    "managerMethod" : "findRemandings"
  });

  pTemp.ajaxM = new bookApplyManager();
  pTemp.editIframe = $("#editIframe");
  pTemp.tab.load();
});
var treeTempValue = 0;

function fnReg() {
  fnShowDetail('add');
}

function fnRecall() {
  var rowIds = pTemp.tab.selectRowIds();
  if (rowIds.length == 0) {
    $.alert($.i18n('office.book.bookRemand.qxzychdsqjl.js'));
    return;
  }

  if (rowIds.length > 1) {
    $.alert($.i18n('office.book.bookRemand.znxzytychddjl.js'));
    return;
  }

  var bookParam = new Object();
  bookParam.applyId = rowIds;
  bookParam.auditFlag = "recall";
  pTemp.ajaxM.auditBookApply(bookParam, {
    success : function(returnMap) {
      if (returnMap.flag) {
        var msg = returnMap.result;
        $.infor({
          'type' : 0,
          'msg' : msg,
          'imgType' : 0,
          ok_fn : loadTab
        });
      } else {
        var msg = returnMap.result;
        $.infor({
          'type' : 0,
          'msg' : msg,
          'imgType' : 2,
          ok_fn : loadTab
        });
      }
    },
    error : function(rval) {
      endProcePub();
      var msg = $.i18n('office.book.bookRemand.dbqchsb.js'), type = 'error';
      fnMsgBoxPub(msg, type, function() {
        fnReloadPagePub({
          page : "bookRemand"
        });
        fnAutoCloseWindow();
      });
    }
  });
}

function loadTab() {
  pTemp.tab.load();
}

function fnPageInIt() {
}

function fnPageReload() {
  pTemp.tab.load();
}

function fnSetCss() {
}

function fnTabClk() {
  fnShowDetail();
}

function fnTabDBClk() {
  fnShowDetail();
}

function fnBookApplyItems() {
  return {
    "id" : {
      display : 'id',
      name : 'id',
      width : '5%',
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
      width : '18%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "bookHouseName" : {
      display : $.i18n('office.bookhouse.lib.js'),
      name : 'bookHouseName',
      width : '15%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "bookCategory" : {
      display : $.i18n('office.bookinfo.category.js'),
      name : 'bookCategory',
      width : '11%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "applyDate" : {
      display : $.i18n('office.bookapply.applydate.js'),
      name : 'applyDate',
      width : '20%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    },
    "stateStr" : {
      display : $.i18n('office.asset.query.state.js'),
      name : 'stateStr',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : true
    }
  }
}

function fnShowDetail(mode) {
  var rows = pTemp.tab.selectRows();
  var url = "/office/bookUse.do?method=bookRemandDetail&bookApplyId="
      + rows[0].id + "&v=" + rows[0].v, title = $
      .i18n('office.book.bookRemand.tszlgh.js');
  fnAutoOpenWindow({
    "url" : url,
    "title" : title,
    hasBtn : false,
    width : 800,
    height : 600
  });
}
/**
 * 批量归还
 */
function fnBookBatchReturn() {
  // rebackDate
  var rowIds = pTemp.tab.selectRowIds();
  if (rowIds == null || rowIds == "") {
    $.alert($.i18n('office.book.bookRemand.qzsxzytjl.js'));
  } else {
    var bookReturn = $.dialog({
      id : 'batchReturn',
      url : _path + '/office/bookUse.do?method=bookBatchReturn',
      title : $.i18n('office.tbar.remind.js'),
      width : 480,
      height : 230,
      buttons : [ {
        id : "remand",
        isEmphasize : true,
        text : $.i18n('office.asset.apply.remind.js'),
        handler : function() {
          var rv = bookReturn.getReturnValue();
          if (rv == false) {
            return false;
          } else {
//            var rebackDate = fnParseDatePub(rv.rebackDate);
//            var nowTime = new Date().getTime();
            var data = {
              rebackDate : rv.rebackDate,
              remandFlag : "remand",
              ids : rowIds,
            };
            fnQuickRemand(data);
            bookReturn.close();
          }

        }
      }, {
        id : "cancel",
        text : $.i18n('calendar.cancel'),
        handler : function() {
          bookReturn.close();
        }
      } ]
    });
  }
}

function fnQuickRemand(data) {
  pTemp.ajaxM.batchBookReturn(data, {
    success : function(rv) {
      if (rv.successNum == rv.totalNum) {
        $.infor($.i18n("office.manager.BookApplyManagerImpl.ghcg.js"))
      } else {
        if (rv.failList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.failList.length; i++) {
            str = str + "《" + rv.failList[i] + "》";
          }
          $.alert($.i18n('office.manager.BookApplyManagerImpl.ghsb.js')
              + "<br>" + str);// 借出
        }else if(rv.dateFailList.length>0){
          var str = "";
          for (var i = 0; i < rv.dateFailList.length; i++) {
            str = str + "《" + rv.dateFailList[i] + "》";
          }
          $.alert($.i18n('office.book.bookInfoDetail4Remand.ghrqbxdydyjcrq.js')
              + "<br>" + str);// 借出
        }
      }
      pTemp.tab.load();
    },
    error : function(rv) {
      $.error("error");
    }
  });

}

function fnDel() {
  var rowIds = pTemp.tab.selectRowIds();

  if (rowIds.length == 0) {
    $.alert($.i18n('office.book.bookRemand.qxzyscdbgyp.js'));
    return;
  }
  var canDel = pTemp.ajaxM.validateDelData(rowIds);
  if (canDel == false) {
    fnRealDel(rowIds);
  } else {
    $.infor({
      'type' : 2,
      'msg' : $.i18n('office.book.bookRemand.yphysqjlbnsc.js'),
      'imgType' : 2
    });
  }
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

function fnBookHouseItems() {
  var jval = $.parseJSON(pTemp.jval);
  var rows = jval.sb1;
  var options = [];
  if (rows.length > 0) {
    return rows;
  } else {
    options[0] = {
      text : "",
      value : ""
    };
    return options;
  }
}
function fnBookTypeItems() {
  var jval = $.parseJSON(pTemp.jval);
  var rows = jval.sb2;
  var options = [];
  if (rows.length > 0) {
    return rows;
  } else {
    options[0] = {
      text : "",
      value : ""
    };
    return options;
  }
}
function fnBookApplyStateItems() {
  var options = [];
  options[0] = {
    text : $.i18n('office.asset.query.state.lended.js'),
    value : "10"
  };
  options[1] = {
    text : $.i18n('office.bookapply.state.back.js'),
    value : "30"
  };
  options[2] = {
    text : $.i18n('office.asset.query.state.all.js'),
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
    "applyBookHouse" : {
      id : 'applyBookHouse',
      name : 'applyBookHouse',
      type : 'select',
      text : $.i18n('office.bookhouse.js'),
      value : 'applyBookHouse',
      items : fnBookHouseItems()
    },
    "applyBookType" : {
      id : 'applyBookType',
      name : 'applyBookType',
      type : 'select',
      text : $.i18n('office.bookapply.belong.type.js'),
      value : 'applyBookType',
      items : fnBookTypeItems()
    }
  }
}
