$(function() {
    pTemp.TBar = officeTBar().addAll([ "new", "edit", "del" ]).init("toolbar");
    pTemp.SBar = officeSBar().init({
        argFunc : "fnStockHouseSBar",
        searchItem : [ "name" ]
    });
    pTemp.tab = officeTab().addAll([ "id", "name", "managertxt", "scopeName" ]).init("stockHouse", {
        argFunc : "fnStockHouseTab",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : true,
        resizable : true,
        "managerName" : "stockHouseManager",
        "managerMethod" : "findStockHouse"
    });

    pTemp.ajaxM = new stockHouseManager();
    pTemp.editIframe = $("#editIframe");
    pTemp.cPage = pTemp.editIframe[0].contentWindow;
    pTemp.tab.load();
});

function fnPageInIt() {
}

function fnPageReload(areaId) {
}

function fnSetCss() {
}

function fnTabClk() {
    fnShowDetail('view');
}

function fnTabDBClk() {
    fnShowDetail('modify');
}

function fnNew() {
    fnShowDetail('add');
}

function fnEdit() {
    fnShowDetail('modify');
}

function fnShowDetail(mode) {
    var rows = pTemp.tab.selectRows();
    if (mode === 'modify') {
        if (rows.length == 0) {
            $.alert($.i18n('office.stock.house.select.edit.js'));
            return;
        } else if (rows.length > 1) {
            $.alert($.i18n('office.auto.onlyone.edit.js'));
            return;
        }
    }
    pTemp.tab.reSize('m');
    if(!pTemp.cPage || !pTemp.cPage.fnPageReload){//快速点击报错问题
    	return;
    }
    pTemp.cPage.fnPageReload({
        "mode" : mode,
        "row" : rows[0]
    });
}

function fnDel() {
    var rowIds = pTemp.tab.selectRowIds();

    if (rowIds.length == 0) {
        $.alert($.i18n('office.stock.house.select.delete.js'));
        return;
    }
    
    var hasInfo = pTemp.ajaxM.hasInfoInHouse(rowIds);
	if(typeof(hasInfo.length)!='undefined' && hasInfo.length>0){
		$.alert($.i18n('office.stockhouse.delete.vali.js'));
		return;
	}
    
    $.confirm({
        'msg' : $.i18n('office.auto.really.delete.js'),
        ok_fn : function() {
            pTemp.ajaxM.deleteByIds(rowIds, {
                success : function() {
                    $.infor($.i18n('office.auto.delsuccess.js'));
                    pTemp.tab.load();
                    fnNew();
                    fnShowDetail('view');
                    pTemp.tab.reSize('d');
                }
            });
        }
    });
}

/**
 * 查询
 */
function fnSBarQuery(condition){
	$("#stockHouse").ajaxgridLoad(condition);
}

function fnStockHouseTab() {
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
        "name" : {
            display : $.i18n('office.stock.house.js'),
            name : 'name',
            width : '20%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "managertxt" : {
            display : $.i18n('office.stock.house.manager.js'),
            name : 'managertxt',
            width : '20%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "scopeName" : {
            display : $.i18n('office.stock.house.usescope.js'),
            name : 'scopeName',
            width : '55%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        }
    };
}

function fnStockHouseSBar() {
    return {
        "name" : {
            id : 'name',
            name : 'name',
            type : 'input',
            text : $.i18n('office.stock.house.js'),
            value : 'name'
        }
    };
}

