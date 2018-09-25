// js开始处理
$(function() {
  pTemp.sTBar = officeTBar().addAll([ "new", "edit", "del" ]).init("toolbar");
  
  // searchBar
  pTemp.SBar = officeSBar("InitDriverSearchBar").addAll([ "driverName", "memberType" ]).init();
    
  pTemp.tab = officeTab().addAll( 
     [ "id", "memberNameShow", "phoneNumber", "receiveDate", "validEndDate","memberTypeName" ]).init("autoDriver", {
    argFunc : "fnAutoDriverTabItems",
    parentId : $('.layout_center').eq(0).attr('id'),
    slideToggleBtn : true,// 上下伸缩按钮是否显示
    resizable : true,// 明细页面的分隔条
    managerName : "autoDriverManager",
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
	if(!pTemp.chPage){//快速点击报错
		return;
	}
  pTemp.chPage.fnShowDetail('add', null);
  pTemp.tab.reSize('m');
}
/**
 * tBar编辑
 */
function fnEdit() {
  var rows = pTemp.tab.selectRows();
  if (rows.length == 0) {
    $.alert($.i18n('office.auto.driverwarnone.js'));
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
    $.alert($.i18n('office.auto.driverwarntwo.js'));
    return;
  }
  var j = 0;
  var ids = new Array();// 可以删除的ID
  var warning = $.i18n('office.auto.isdel.js');// 提示语句
  for ( var i = 0; i < rows.length; i++) {
    ids[j++] = rows[i].id;
    if (rows[i].memberType != 1) {
      warning = warning + rows[i].systemMemberName + "、";
    } else {
      warning = warning + rows[i].memberName + "、";
    }
  }
  pTemp.chPage.fnDelete(warning.substr(0, warning.length - 1) + "?", ids);
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
      isToggleHideShow : true
    },
    "memberNameShow" : {
      display : $.i18n('office.auto.drivername.js'),
      name : 'memberNameShow',
      width : '10%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false
    },
    "phoneNumber" : {
      display : $.i18n('office.auto.phone.js'),
      name : 'phoneNumber',
      width : '15%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false
    },
    "receiveDate" : {
      display : $.i18n('office.auto.receiveDate.js'),
      name : 'receiveDate',
      width : '20%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false,
      sortorder:'desc'
    },
    "validEndDate" : {
      display : $.i18n('office.auto.validDateto.js'),
      name : 'validEndDate',
      width : '20%',
      sortable : true,
      align : 'left',
      isToggleHideShow : false,
      sortorder:'desc'
    },
    "memberTypeName" : {
      display : $.i18n('office.auto.peopletype.js'),
      name : 'memberTypeName',
      width : '30%',
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
    "driverName" : {
      id : 'driverName',
      name : 'driverName',
      type : 'input',
      text : $.i18n('office.auto.drivername.js'),
      value : 'memberName'
    },
        "memberType" : {
          id : 'memberType',
          name : 'memberType',
          type : 'select',
          text : $.i18n('office.auto.peopletype.js'),
          value : 'memberType',
          items : [ {
              text : $.i18n('office.auto.peoplesystem.js'),
              value : '0'
          }, {
              text : $.i18n('office.auto.peopleselfhelp.js'),
              value : '1'
          }]
    }
      };
}
