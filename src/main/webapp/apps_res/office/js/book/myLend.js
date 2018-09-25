$(function() {
	// toolBar初始化
	pTemp.sTBar = officeTBar().addAll(["renew","revoke","del"]).init("toolbar");
	// 初始化查询框
	pTemp.SBar = officeSBar("fnInitSearchBar").addAll(
			[ "applyBookHouse", "applyBookType", "applyState", "applyDate" ]).init();
	//  初始化列表
	pTemp.tab = officeTab().addAll(
			[ "id", "bookNum", "bookName", "bookType","bookCategory", "bookHouseName",
					"applyDate", "applyCount","reNewTime","stateStr" ]).init(
			"myLend", {
				argFunc : "fnBookApplyItems",
				parentId : $('.layout_center').eq(0).attr('id'),
				slideToggleBtn : false,
				resizable : false,
				"managerName" : "bookApplyManager",
				"managerMethod" : "findMyLend"
			});

	pTemp.ajaxM = new bookApplyManager();
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

/**
 * 单击Tab查看
 */
function fnTabClk() {
	fnShowDetail();
}
/***
 * 双击
 */
function fnTabDBClk() {
	fnShowDetail();
}

function fnNew() {
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
		"bookNum" : {
			display : $.i18n('office.bookinfo.num.js'),
			name : 'bookNum',
			width : '12%',
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
			isToggleHideShow : true
		},
		"bookType" : {
            display : $.i18n('office.bookinfo.type.js'),
            name : 'bookType',
            width : '5%',
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
			width : '15%',
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
		"reNewTime" : {
			display : $.i18n('office.bookhouse.renewtimes.js'),
			name : 'reNewTime',
			width : '8%',
			sortable : true,
			align : 'right',
			isToggleHideShow : true
		},
		"stateStr" : {
			display : $.i18n('office.asset.query.state.js'),
			name : 'stateStr',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		}
	}
}

function fnShowDetail() {
    var rows = pTemp.tab.selectRows();
    var url = "/office/bookUse.do?method=myBookLendDetail&bookApplyId="+rows[0].id+"&v="+rows[0].v,title = $.i18n('office.book.myLend.wdjy.js');
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:800,height:600});
}

function fnRenew(){
	var rowIds = pTemp.tab.selectRowIds();

	if (rowIds.length == 0) {
		$.alert($.i18n('office.book.myLend.qxzyxjddsqjl.js'));
		return;
	}
	if (rowIds.length > 1) {
		$.alert($.i18n('office.book.myLend.znxzytyxjddjl.js'));
		return;
	}
	
	var rows =pTemp.tab.selectRows();
	var state = "";
	for(var i=0;i<rows.length;i++){
		var row = rows[i];
		state = row.stateStr;
	}
//	if(state!="待归还"){
//		$.infor({
//    		'type': 0,
//    	    'msg': $.i18n('office.book.myLend.znxjyjcdsq.js'),
//    	    'imgType':2,
//    	    ok_fn: loadTab
//		});
//		return;
//	}
	
	$.confirm({
        'msg' : $.i18n('office.book.myLend.qdyxjm.js'),
        ok_fn : function() {
			var bookParam = new Object();
			bookParam.applyId = rowIds;
			bookParam.auditFlag = "renew";
			pTemp.ajaxM.auditBookApply(bookParam,{
				success : function(returnMap) {
					if (returnMap.flag) {
						var msg = returnMap.result;
						$.infor({
			        		'type': 0,
			        	    'msg': msg,
			        	    'imgType':0,
			        	    ok_fn: loadTab
						});
					} else {
						var msg = returnMap.result;
						$.infor({
			        		'type': 0,
			        	    'msg': msg,
			        	    'imgType':2,
			        	    ok_fn: loadTab
						});
					}
				},
				error : function(rval) {
					endProcePub();
					var msg = $.i18n('office.book.myLend.dbqxjsb.js'),type = 'error';
					fnMsgBoxPub(msg,type,function(){
						fnReloadPagePub({page:"bookLend"});
							fnAutoCloseWindow();
						});
				}
			});
        }
	});

	
}

function fnDel() {
	var rowIds = pTemp.tab.selectRowIds();

	if (rowIds.length == 0) {
		$.alert($.i18n('office.book.myLend.qxzyscdsqjl.js'));
		return;
	}
	var canDel = pTemp.ajaxM.validateDelData(rowIds);
    if(canDel  == false){
    	fnRealDel(rowIds);
    }else{
        $.infor({
        		'type': 2,
        	    'msg': $.i18n('office.book.myLend.zkscyghspbtgjcbtgcxjl.js'),
        	    'imgType':2
        });
    }
}

function fnRealDel(rowIds) {
	$.confirm({
		'msg' : $.i18n('office.book.myLend.qdyscyjxzdjl.js'),
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

function fnRevoke(){
	var rowIds = pTemp.tab.selectRowIds();
	
	if (rowIds.length == 0) {
		$.alert($.i18n('office.book.myLend.qxzycxdsqjl.js'));
		return;
	}
	var canDel = pTemp.ajaxM.validateRevokeData(rowIds);
    if(canDel  == false){
    	fnRealRevoke(rowIds);
    }else{
        $.infor({
        		'type': 2,
        	    'msg': $.i18n('office.book.myLend.zkcxdspdjcdjl.js'),
        	    'imgType':2
        });
    }

}

function fnRealRevoke(rowIds){
	var bookParam = new Object();
	bookParam.applyId = rowIds;
	bookParam.auditFlag = "revoke";
	pTemp.ajaxM.auditBookApply(bookParam,{
		success : function(returnMap) {
			if (returnMap.flag) {
				var msg = returnMap.result;
				$.infor({
	        		'type': 0,
	        	    'msg': msg,
	        	    'imgType':0,
	        	    ok_fn: loadTab
				});
			} else {
				var msg = returnMap.result;
				$.infor({
	        		'type': 0,
	        	    'msg': msg,
	        	    'imgType':2,
	        	    ok_fn: loadTab
				});
			}
		},
		error : function(rval) {
			endProcePub();
			var msg = $.i18n('office.book.myLend.dbqcxsb.js'),type = 'error';
			fnMsgBoxPub(msg,type,function(){
				fnReloadPagePub({page:"bookLend"});
					fnAutoCloseWindow();
				});
		}
	});

}

function loadTab(){
	pTemp.tab.load();
}

function fnTreeClk(e, treeId, node) {
	treeTempValue = node.data.id;
	var nodeData = node.data;
	pTemp.tab.load(nodeData);
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

/**
 * 申请
 */
function fnStorage() {
	var rows = pTemp.tab.selectRows();
	if (rows.length == 0) {
		$.alert($.i18n('office.book.myLend.qxzyrkdbgyp.js'));
		return;
	} else if (rows.length > 1) {
		$.alert($.i18n('office.book.myLend.znxzytjl.js'));
		return;
	}
	var url = "/office/stockSet.do?method=stockStorageIframe&isNew=true&rows="
			+ rows[0].id, title = $.i18n('office.book.myLend.rk.js');
	fnAutoOpenWindow({
		"url" : url,
		"title" : title,
		hasBtn : false,
		width : 400,
		height : 250
	});
}
function fnStockHouseItems() {
	var rows = $.parseJSON(pTemp.jval);
	var options = [];
	if (rows.uesedHouseEnums.length > 0) {
		for ( var i = 0; i < rows.uesedHouseEnums.length; i++) {
			options[i] = {
				text : rows.uesedHouseEnums[i].text,
				value : rows.uesedHouseEnums[i].value
			};
		}
		return options;
	} else {
		options[0] = {
			text : "",
			value : ""
		};
		return options;
	}
}

function fnBookHouseItems(){
	var jval =$.parseJSON(pTemp.jval);
	var rows =  jval.sb1;
	var options =[];
	if(rows.length>0){
		return rows;
	}else{
		options[0] = {text:"",value:""};
		return options;
	}
}
function fnBookTypeItems(){
	var jval =$.parseJSON(pTemp.jval);
	var rows =  jval.sb2;
	var options =[];
	if(rows.length>0){
		return rows;
	}else{
		options[0] = {text:"",value:""};
		return options;
	}
}
function fnBookApplyStateItems() {
	var options = [];
	options[0] = {
		text : $.i18n('office.workflow.state.unaduit.js'),
		value : "1"
	};
	options[1] = {
		text : $.i18n('office.bookapply.state.unlended.js'),
		value : "5"
	};
	options[2] = {
		text : $.i18n('office.asset.query.state.lended.js'),
		value : "10"
	};
	options[3] = {
		text : $.i18n('office.bookapply.state.back.js'),
		value : "30"
	};
	options[4] = {
		text : $.i18n('office.workflow.state.aduit.not.js'),
		value : "15"
	};
	options[5] = {
		text : $.i18n('office.bookapply.state.lend.not.js'),
		value : "20"
	};
	options[6] = {
		text : $.i18n('office.tbar.revoke.js'),
		value : "25"
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
		"applyBookHouse" : {
			id : 'applyBookHouse',
			name : 'applyBookHouse',
			type : 'select',
			text : $.i18n('office.bookhouse.js'),
			value : 'applyBookHouse',
			items:fnBookHouseItems()
		},
		"applyBookType" : {
			id : 'applyBookType',
			name : 'applyBookType',
			type : 'select',
			text : $.i18n('office.bookapply.belong.type.js'),
			value : 'applyBookType',
			items:fnBookTypeItems()
		},
		"applyState" : {
			id : 'applyState',
			name : 'applyState',
			type : 'select',
			text : $.i18n('office.asset.query.state.js'),
			width : '10%',
			value : "applyState",
	        items:fnBookApplyStateItems()
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
