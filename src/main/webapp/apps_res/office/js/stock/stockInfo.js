$(function() {
    pTemp.TBar = officeTBar().addAll([ "reg", "edit", "storage", "imp2exp","del" ]).init("toolbar");
    
    pTemp.SBar = officeSBar("fnInitSearchBar").addAll(["stockNum","stockName","stockHouse","stockState"]).init();
   
    pTemp.tab = officeTab().addAll([ "id", "stockNum", "stockName", "stockModel", "stockPrice", "stockHouseName", "stockCount" ,"state"]).init("stockInfo", {
        	argFunc : "fnStockInfoItems",
	        parentId : $('.layout_center').eq(0).attr('id'),
	        slideToggleBtn : true,
	        resizable : true,
	        "managerName" : "stockInfoManager",
	        "managerMethod" : "find"
    });
    $('#stockInfo').width("");
    pTemp.ajaxM = new stockInfoManager();
    pTemp.editIframe = $("#editIframe");
    pTemp.cPage = pTemp.editIframe[0].contentWindow;
    pTemp.tab.load();
    initStockTree();
});

var treeTempValue = "";

function fnReg(){
    fnShowDetail('add');
}


function fnPageInIt() {
}

function fnPageReload() {
	pTemp.tab.load();
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

/**
 * 【导入】
 */
function fnImp(){
//	 dymcCreateFileUpload("dyncid", "13", "xls,xlsx", "1", false, 'fnImpCall', null, true, true, null, true,false,'5120000');
//	 insertAttachment();
	var importDialog = $.dialog({
		id: 'imp',
	    url: _path+"/office/stockSet.do?method=importStockInfo",
	    width: 400,
	    height: 125,
	    title: $.i18n('office.assetinfo.fileupload.js'),
	    targetWindow : getCtpTop(),
	    closeParam:{'show':true,handler:function(){
	    	pTemp.tab.load();
	    }} 
	}); 
	
} 

function fnImpCall(file){
	var fileUrl = file.get(0).fileUrl;
	$("#expOrImp").jsonSubmit({
		action:_path+"/office/stockSet.do?method=importAutoInfo&fileUrl="+fileUrl,
		callback:function(rval){
			
		}
	});
	
}
/**
 * 【导出】
 */
function fnExp(){
	var condition = pTemp.condition ;
	var value = pTemp.value ;
	var selectIds = pTemp.tab.selectRowIds(); //导出时、选择的数据
	//var selectType = treeTempValue;
	$("#expOrImp").jsonSubmit({
		action:_path+"/office/stockSet.do?method=exportStockInfo&con="+condition+"&val="+value+"&ids="+selectIds+"&type="+treeTempValue,
		callback:function(rval){}
	});
}

/**
 * 【下载模板】
 */
function fnDow(){
	$("#expOrImp").jsonSubmit({
		action:_path+"/office/stockSet.do?method=exportStockInfo&dow=dowloadTemplete",
		callback:function(rval){}
	});
}

function fnStockInfoItems(){
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
        "stockNum" : {
            display : $.i18n('office.stock.num.js'),
            name : 'stockNum',
            width : '15%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "stockName" : {
            display : $.i18n('office.stock.name.js'),
            name : 'stockName',
            width : '20%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "stockModel" : {
            display : $.i18n('office.manager.StockInfoManagerImpl.ypgg.js'),
            name : 'stockModel',
            width : '12%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "stockPrice" : {
            display : $.i18n('office.manager.StockStcManagerImpl.pjdj.js'),
            name : 'stockPrice',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "stockHouseName" : {
            display : $.i18n('office.stock.house.js'),
            name : 'stockHouseName',
            width : '15%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "stockCount" : {
            display : $.i18n('office.stock.countsum.js'),
            name : 'stockCount',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "state" : {
            display : $.i18n('office.assetinfo.state.js'),
            name : 'state',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true,
			codecfg:"codeType:'java',codeId:'com.seeyon.apps.office.constants.StockInfoStateEnum'"
        }
    }
}

function fnShowDetail(mode) {
    var rows = pTemp.tab.selectRows();
    if (mode === 'modify') {
        if (rows.length == 0) {
            $.alert($.i18n('office.stock.info.edit.js'));
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
        "row" : rows[0],
        "treeTempValue":treeTempValue
    });
}

function fnDel() {
    var rowIds = pTemp.tab.selectRowIds();

    if (rowIds.length == 0) {
        $.alert($.i18n('office.stock.info.delete.js'));
        return;
    }
    var canDel = pTemp.ajaxM.validateDelData(rowIds);
    if(canDel  == false){
    	fnRealDel(rowIds);
    }else{
        $.infor({
        		'type': 2,
        	    'msg': $.i18n('office.stock.info.cannotdelete.js'),
        	    'imgType':2
        });
    }
}

function fnRealDel(rowIds){
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


function initStockTree(){
	$("#stockTree").tree({
		idKey: "id",
		pIdKey: "pid",
		nameKey: "name",
		managerName : "stockInfoManager",
	    managerMethod : "getStockTreeNodes",
	    onClick: fnTreeClk,
	    nodeHandler: function(n) {
	    	n.open = true;
	    }
	});
	$("#stockTree").treeObj().reAsyncChildNodes(null, "refresh");
}

function fnTreeClk(e, treeId, node) {
	treeTempValue = node.data.id;
	var nodeData = node.data;
	pTemp.tab.load(nodeData);
}

/**
 * 查询
 */
function fnSBarQuery(obj){
	//查询的时候，记录下查询条件，供导出用
	pTemp.condition = obj.condition;
	pTemp.value = obj.value;
	pTemp.tab.load(obj);
}

/**
 *申请 
 */
function fnStorage(){
	var rows = pTemp.tab.selectRows();
    if (rows.length == 0) {
        $.alert($.i18n('office.stock.info.storage.js'));
        return;
    } else if (rows.length > 1) {
        $.alert($.i18n('office.stock.house.edit.only.js'));
        return;
    }
	var url = "/office/stockSet.do?method=stockStorageIframe&isNew=true&rows="+rows[0].id,title = $.i18n('office.tbar.storage.js');
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:400,height:250});
}

function fnStockHouseItems(){
	var rows =  $.parseJSON(pTemp.jval);
	var options =[];
	if(rows.uesedHouseEnums.length>0){
		for ( var i = 0; i < rows.uesedHouseEnums.length; i++) {
			options[i]= {text:rows.uesedHouseEnums[i].text,value:rows.uesedHouseEnums[i].value};
		}
		return options;
	}else{
		options[0] = {text:"",value:""};
		return options;
	}
}


/**
 * 搜索框初始化
 * @returns
 */
function fnInitSearchBar(){
    return {"stockState" : {
		        id : 'stockState',
		        name : 'stockState',
		        type : 'select',
		        text : $.i18n('office.assetinfo.state.js'),
		        value : 'stockState',
		        items : [ {
		            text : $.i18n('office.stock.state0.js'),
		            value : '0'
		        }, {
		            text :$.i18n('office.stock.state1.js'),
		            value : '1'
		        }]
		   },
		   "stockNum" : {
		       id : 'stockNum',
		       name : 'stockNum',
		       type : 'input',
		       text : $.i18n('office.stock.num.js'),
		       value : 'stockNum'
		  },
		  "stockName" : {
		      id : 'stockName',
		      name : 'stockName',
		      type : 'input',
		      text : $.i18n('office.stock.name.js'),
		      value : 'stockName'
		 },
		 "stockHouse" : {
		     id : 'stockHouse',
		     name : 'stockHouse',
		     type : 'select',
		     text : $.i18n('office.stock.house.js'),
		     value : 'stockHouse',
	         items:fnStockHouseItems()
		 }
    }
}
