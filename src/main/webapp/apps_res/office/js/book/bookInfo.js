$(function() {
    pTemp.TBar = officeTBar().addAll([ "reg", "edit", "imp2exp","del" ]).init("toolbar");

    pTemp.SBar = officeSBar("fnInitSearchBar").addAll(["bookNum","bookName","houseName","bookState"]).init();

    pTemp.tab = officeTab().addAll([ "id", "bookNum", "bookName", "bookType_txt", "houseName", "bookCategoryStr", "bookUnit" , "bookCount", "bookState_txt"]).init("bookInfo", {
          argFunc : "fnBookInfoItems",
          parentId : $('.layout_center').eq(0).attr('id'),
          slideToggleBtn : true,
          resizable : true,
          "managerName" : "bookInfoManager",
          "managerMethod" : "find"
    });
    initStockTree();
    pTemp.ajaxM = new bookInfoManager();
    pTemp.editIframe = $("#editIframe");
    pTemp.chPage = pTemp.editIframe[0].contentWindow;
    pTemp.tab.load();
});
var treeTempValue = 0;
function fnBookInfoItems(){
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
        "bookNum" : {
            display : $.i18n('office.bookinfo.num.js'),
            name : 'bookNum',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "bookName" : {
            display : $.i18n('office.asset.apply.assetName.js'),
            name : 'bookName',
            width : '12%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "bookType_txt" : {
            display : $.i18n('office.bookinfo.type.js'),
            name : 'bookType_txt',
            width : '8%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "houseName" : {
            display : $.i18n('office.bookhouse.js'),
            name : 'houseName',
            width : '15%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "bookCategoryStr" : {
            display : $.i18n('office.bookinfo.category.js'),
            name : 'bookCategoryStr',
            width : '13%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "bookUnit" : {
            display : $.i18n('office.stock.unit.js'),
            name : 'bookUnit',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "bookCount" : {
            display : $.i18n('office.stock.countsum.js'),
            name : 'bookCount',
            width : '15%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
      "bookState_txt" : {
        display : $.i18n('office.assetinfo.state.js'),
        name : 'bookState_txt',
        width : '10%',
        sortable : true,
        align : 'left',
        isToggleHideShow : false
    }
    }
}
/**
 * tBar登记
 */
function fnReg() {
  pTemp.tab.reSize('m');
  if(!pTemp.editIframe){
  	return;
  }
  pTemp.editIframe[0].src = _ctxPath + "/office/bookSet.do?method=bookInfoEdit";
}


/**
 * 单击Tab查看
 */
function fnTabClk() {
  var rows = pTemp.tab.selectRows();
  pTemp.chPage.fnShowDetail('show', rows[0]);
  pTemp.tab.reSize('m');
}

/**
 * 双击Tab
 */
function fnTabDBClk() {
  var rows = pTemp.tab.selectRows();
  pTemp.chPage.fnShowDetail('update', rows[0]);
  pTemp.tab.reSize('m');
}

/**
 * tBar修改
 */
function fnEdit() {
  var rows = pTemp.tab.selectRows();
  if (rows.length == 0) {
    $.alert($.i18n('office.bookinfo.edit.js'));
    return;
  } else if (rows.length > 1) {
    $.alert($.i18n('office.auto.onlyone.edit.js'));
    return;
  }
  pTemp.chPage.fnShowDetail('update', rows[0]);
  pTemp.tab.reSize('m');
}

/**
 * tBar删除
 */
function fnDel() {
  var rows = pTemp.tab.selectRows();
  if (rows.length == 0) {
    $.alert($.i18n('office.bookinfo.delete.js'));
    return;
  }
  pTemp.chPage.fnDelete(rows);
}
/**
 * 【导出】
 */
function fnExp(){
  var condition = pTemp.condition ;
  var value = pTemp.value ;
  var selectIds = pTemp.tab.selectRowIds(); //导出时、选择的数据
  $("#expOrImp").jsonSubmit({
    action:_path+"/office/bookSet.do?method=exportBookInfo&condition="+condition+"&value="+value+"&ids="+selectIds+"&bookCategory="+pTemp.treeTempValue,
    callback:function(rval){}
  });
}
/**
 * 【模板下载】
 */
function fnDow(){
  $("#expOrImp").jsonSubmit({
    action:_path+"/office/bookSet.do?method=exportBookInfo&dow=dowloadTemplete",
    callback:function(rval){}
  });
}
/**
 * 【导入】
 */
function fnImp(){
//   dymcCreateFileUpload("dyncid", "13", "xls,xlsx", "1", false, 'fnImpCall', null, true, true, null, true,false,'5120000');
//   insertAttachment();
  var importDialog = $.dialog({
      id: 'imp',
      url: _path+"/office/bookSet.do?method=importBookInfo",
      width: 400,
      height: 180,
      title: $.i18n('office.book.bookInfo.scwj.js'),
      targetWindow : getCtpTop(),
      closeParam:{'show':true,handler:function(){
        pTemp.tab.load();
      }} 
  }); 
  
} 
function initStockTree(){
  $("#bookTree").tree({
    idKey: "id",
    pIdKey: "pid",
    nameKey: "name",
    managerName : "bookInfoManager",
      managerMethod : "getBookTreeNodes",
      onClick: fnTreeClk,
      nodeHandler: function(n) {
    	  n.open = true;
      }
  });
  $("#bookTree").treeObj().reAsyncChildNodes(null, "refresh");
}

function fnTreeClk(e, treeId, node) {
  if (node.isParent) {
	  var object = new Object();
	  pTemp.treeTempValue = "";
	  object.condition = pTemp.condition;
	  object.value = pTemp.value;
	  pTemp.tab.load(object);
  } else {
	  pTemp.treeTempValue = node.data.id;
	  pTemp.chPage.$("#bookCategory").val(treeTempValue);
	  var object = new Object();
	  object.bookCategory = pTemp.treeTempValue;
	  if (pTemp.condition && pTemp.condition != '') {
	    object.condition = pTemp.condition;
	    object.value = pTemp.value;
	  }
	  pTemp.tab.load(object);
  }
  pTemp.tab.reSize();
}

/**
 * 搜索框初始化
 * @returns
 */
function fnInitSearchBar(){
    return {
       "bookNum" : {
           id : 'bookNum',
           name : 'bookNum',
           type : 'input',
           text : $.i18n('office.bookinfo.num.js'),
           value : 'bookNum'
      },
      "bookName" : {
          id : 'bookName',
          name : 'bookName',
          type : 'input',
          text : $.i18n('office.asset.apply.assetName.js'),
          value : 'bookName'
     },
     "houseName" : {
         id : 'houseName',
         name : 'houseName',
         type : 'select',
         text : $.i18n('office.bookhouse.js'),
         value : 'houseName',
         codecfg : "codeType:'java',codeId:'com.seeyon.apps.office.constants.BookHouseEnum'"
     },
     "bookState" : {
       id : 'bookState',
       name : 'bookState',
       type : 'select',
       text : $.i18n('office.assetinfo.state.js'),
       value : 'bookState',
       items : [ {
           text : $.i18n('office.bookinfo.state.use.js'),
           value : '0'
       }, {
           text :$.i18n('office.bookinfo.state.unuse.js'),
           value : '1'
       }]
  }
    };
}
/**
 * 查询
 */
function fnSBarQuery(obj){
  //查询的时候，记录下查询条件，供导出用
  pTemp.condition = obj.condition;
  pTemp.value = obj.value;
  if (pTemp.treeTempValue && pTemp.treeTempValue != '') {
    obj.bookCategory = pTemp.treeTempValue;
  }
  pTemp.tab.load(obj);
}
