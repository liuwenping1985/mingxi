// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll([ "new","edit", "del" ]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar().addAll(["categoryName"]).init();
    //table
    pTemp.tab = officeTab().addAll([ "id", "subject", "range" ]).init("autoCategory", {
        argFunc : "fnCategoryItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : true,// 上下伸缩按钮是否显示
        resizable : true,// 明细页面的分隔条
        "managerName" : "autoCategoryManager",
        "managerMethod" : "find"
    });
    //manager
    pTemp.ajaxM = new autoCategoryManager();
    pTemp.editIframe = $("#editIframe");//子页面的iframe对象
    pTemp.cPage = pTemp.editIframe[0].contentWindow;//子页面对象
    pTemp.tab.load();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
}

/**
 * 刷新页面
 * 
 * @param areaId，刷新野蛮部分的id
 */
function fnPageReload(areaId) {
}

/**
 * 页面样式控制
 */
function fnSetCss() {
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
    fnShowDetail('view');
}

/**
 * 双击Tab
 */
function fnTabDBClk() {
    fnEdit();
}

/**
 * tBar新增
 */
function fnNew() {
    fnShowDetail('add');
}

/**
 * tBar编辑
 */
function fnEdit() {
    fnShowDetail('modify');
}

/**
 * 刷新新增，修改页面的数据
 * @param mode
 */
function fnShowDetail(mode) {
    var rows = pTemp.tab.selectRows();
    if (mode === 'modify') {
        if(rows.length == 0){
            $.alert($.i18n('office.auto.select.modify.category.js'));
            return;
        }else if(rows.length > 1){
            $.alert($.i18n('office.auto.onlyone.edit.js'));
            return;
        }
    }
    pTemp.tab.reSize('m');
    if(!pTemp.cPage || !pTemp.cPage.fnPageReload){
    	return;
    }
    // 子页面载入
    pTemp.cPage.fnPageReload({
        "mode" : mode,
        "row" : rows[0]
    });
}

/**
 * tBar删除
 */
function fnDel() {
    var rowIds = pTemp.tab.selectRowIds();
    
    if(rowIds.length == 0){
        $.alert($.i18n('office.auto.select.del.category.js'));
        return;
    }else if(rowIds.length > 1){
        $.alert($.i18n('office.assethouse.delete.onlyone.js'));
        return;
    }
    //ajax调用后台
    //需要增加校验是否该分类已经被引用(仅一条)
    pTemp.ajaxM.canDelete(rowIds[0], {
      success : function(returnVal) {
          if (returnVal == false) {
              $.alert($.i18n('office.auto.category.used.notDel.js'));
              endProcePub();
              return;
          }
          $.confirm({
            'msg' : $.i18n('office.auto.really.delete.js'),
            ok_fn : function() {
                pTemp.ajaxM.deleteByIds(rowIds, {
                    success : function() {
                        //${ctp:i18n('system.phrase.delete')}
                        $.infor($.i18n('office.auto.delsuccess.js'));
                        pTemp.tab.load();
                        //清空编辑界面的值为空
                        fnNew();
                        fnShowDetail('view');
                        pTemp.tab.reSize('d');
                    }
                });
            }
        });
      }
  });
}

function fnCategoryItems(){
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
        "subject" : {
            display : $.i18n('office.auto.category.name.js'),
            name : 'subject',
            width : '20%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "range" : {
            display : $.i18n('office.auto.category.usescope.js'),
            name : 'range',
            width : '73%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        }
    }
}
/**
 * 查询
 */
function fnSBarQuery(obj){
  pTemp.tab.load(obj);
}

//IE 6第一次需要刷新Iframe
function ferForIE6(){
  if(pTemp.isFirst){
    pTemp.isFirst = false; 
    ferIframe('editIframe');
  }
}