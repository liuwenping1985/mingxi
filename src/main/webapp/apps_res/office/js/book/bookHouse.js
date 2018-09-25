// js开始处理
$(function() {
  pTemp.sTBar = officeTBar().addAll([ "new", "edit", "del" ]).init("toolbar");
  
  // searchBar
  pTemp.SBar = officeSBar("InitDriverSearchBar").addAll([ "houseName"]).init();
    
  pTemp.tab = officeTab().addAll( 
     [ "id", "houseName", "houseManager_txt", "range", "borrowDays", "alertDays","renewTimes" ]).init("bookHouse", {
    argFunc : "fnAutoDriverTabItems",
    parentId : $('.layout_center').eq(0).attr('id'),
    slideToggleBtn : true,// 上下伸缩按钮是否显示
    resizable : true,// 明细页面的分隔条
    managerName : "bookHouseManager",
    managerMethod : "find"
  });
  pTemp.editIframe = $("#editIframe");// 子页面的iframe对象
  pTemp.chPage = pTemp.editIframe[0].contentWindow;// 子页面对象
  pTemp.tab.load();
});

/**
 * 单击Tab查看
 */
function fnTabClk() {
  var rows = pTemp.tab.selectRows();
	if (!pTemp.chPage || rows == null || rows.length == 0) {//快速点击报错
  	return ;
  }
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
 * tBar新增
 */
function fnNew() {
  pTemp.chPage.fnShowDetail('add', null);
  pTemp.tab.reSize('m');
}
/**
 * tBar编辑
 */
function fnEdit() {
  var rows = pTemp.tab.selectRows();
  if (rows.length == 0) {
    $.alert($.i18n('office.bookhouse.edit.js'));
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
    $.alert($.i18n('office.bookhouse.delete.js'));
    return;
  }
  if (rows.length > 1) {
    $.alert($.i18n('office.assethouse.delete.onlyone.js'));
    return;
  }
  pTemp.chPage.fnDelete(rows[0].id);
}

/**
 * Tab标题头
 */
function fnAutoDriverTabItems() {
  return {
    "id" : {
      display : 'id',
      name : 'id',
      width : '5%',
      sortable : false,
      align : 'center',
      type : 'checkbox',
      isToggleHideShow : false
    },
    "houseName" : {
      display : $.i18n('office.bookhouse.js'),
      name : 'houseName',
      width : '18%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false
    },
    "houseManager_txt" : {
      display : $.i18n('office.auto.admin.js'),
      name : 'houseManager_txt',
      width : '15%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false
    },
    "range" : {
      display : $.i18n('office.auto.category.usescope.js'),
      name : 'range',
      width : '30%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false,
      onCurrentPageSort:false,
      sortorder:'desc'
    },
    "borrowDays" : {
      display : $.i18n('office.bookhouse.borrowdays.js'),
      name : 'borrowDays',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false,
      onCurrentPageSort:false,
      sortorder:'desc'
    },
    "alertDays" : {
      display : $.i18n('office.bookhouse.alertdays.js'),
      name : 'alertDays',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false
    },
    "renewTimes" : {
        display : $.i18n('office.bookhouse.renewtimes.js'),
        name : 'renewTimes',
        width : '10%',
        sortable : true,
        align : 'left',
        isToggleHideShow : false
      }
  }
}

/**
 * 查询
 */
function fnSBarQuery(obj){
  pTemp.tab.load(obj);
}
/**
 * 搜索框初始化
 * @returns
 */
function InitDriverSearchBar(){
  return{
    "houseName" : {
      id : 'houseName',
      name : 'houseName',
      type : 'input',
      text : $.i18n('office.bookhouse.js'),
      value : 'houseName'
    } 
      };
}
