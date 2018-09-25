// js开始处理
$(function() {
    //toolbar
		pTemp.TBar = officeTBar().addAll(["export","print"]).init("toolbar");
    //table
    pTemp.tab = officeTab().addAll(["applyUser","applyDept","applyDate","stockName","stockModel","applyAmount","grantAmount","total"]).init("stockGrantLogTab", {
        argFunc : "fnTabItem",
        parentId : $('.stadic_layout_body').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "stockUseManager",
        "managerMethod" : "findStockGrantLog"
    });
    $('#stockGrantLogTab').width("");
    pTemp.layout = $('#layout').layout();
    pTemp.useTab =  $("#stockUseTab");
    pTemp.stockType = $("#stockType");
    pTemp.ajaxM = new stockUseManager();
    fnPageReload();
});

/**
 * 根据当前选中的用品库，初始化用品库中有用品的分类
 */
function fnHouseChange(){
	var typeOfHouse = pTemp.ajaxM.findStockTypeEnum($("#stockHouseId").val());
	var stockTypeOptions = fnNewOptionPub(typeOfHouse);
	$("#stockType").html(stockTypeOptions);
}

/**
 * 刷新页面
 */
function fnPageReload() {
	pTemp.tab.load();
	var isAdmin = false;
	// 加载页面枚举
	if (pTemp.jval != '') {
		var enums = $.parseJSON(pTemp.jval);
		var uesedHouseOptions = fnNewOptionPub(enums.uesedHouseEnums,{},'fnOptionClk');
		$("#stockHouseId").html(uesedHouseOptions);
		pTemp.stockType.html(fnNewOptionPub([]));
		isAdmin = enums.isAdmin;
		pTemp.row = enums;
		pTemp.useTab.fillform(enums);
		var stockTypeOptions = fnNewOptionPub(enums.stockTypeEnums);
		$("#stockType").html(stockTypeOptions);
	}
	
	
	//如果不是管理员，申请人禁用
	if(!isAdmin){
		var obj ={applyUser: $.ctx.CurrentUser.name};
		$("#applyUserDiv").fillform(obj);
		$("#applyUserDiv").disable();
	}
}

function fnOptionClk(_this){
	pTemp.ajaxM.findStockTypeEnum(_this.value,{
		success:function(rval){
			pTemp.stockType.html(fnNewOptionPub(rval));
		}
	});
}

/**
 * 
 */
function fnExp(){
	var queryMap = fnParseQueryArg();
	$("#btnok").jsonSubmit({
		action : _path + "/office/stockUse.do?method=expStockGrantLog",
		paramObj:queryMap,
    callback: function() {
    }
  });
}

function fnPrint(){
	var printSubject = "";
	var colBody = fnStockLogGrant();
	var colBodyFrag = new PrintFragment(printSubject, colBody);
	var cssList = new ArrayList();
	var pl = new ArrayList();
	pl.add(colBodyFrag);
	printList(pl, cssList)
}


/**
* 获取打印数据
*/
function fnStockLogGrant(){
var mxtgrid = $("#stockGrantLogTab");
var str = "";
if(mxtgrid.length > 0 ){
    var tableHeader = jQuery(".hDivBox thead");               
    var tableBody = jQuery(".bDiv tbody");
    var headerHtml =tableHeader.html();
    var bodyHtml = tableBody.html();
    if(headerHtml == null || headerHtml == 'null'){
        headerHtml ="";
    }
    if(bodyHtml == null || bodyHtml=='null'){
        bodyHtml="";
    }
    bodyHtml = bodyHtml.replace(/text_overflow/g,'word_break_all');
    str+="<table class='only_table edit_table font_size12' border='0' cellspacing='0' cellpadding='0'>"
    str+="<thead>";
    str+=headerHtml;
    str+="</thead>";
    str+="<tbody>";
    str+=bodyHtml;
    str+="</tbody>";
    str+="</table>";
}
return str;
}

function fnParseQueryArg(){
	var applyDate = ['',''];
	var useMap = pTemp.useTab.formobj();
	var queryMap = {};
	for (var name in useMap) {
		if(name =="applyDate0"){
			if (useMap[name] != null && useMap[name] != '') {
				applyDate[0] = useMap[name];
				queryMap.applyDate = applyDate;
			}
		}else	if(name == "applyDate1"){
			if (useMap[name] != null && useMap[name] != '') {
				applyDate[1] = useMap[name];
				queryMap.applyDate = applyDate;
			}
		}else if(name == "applyDept" && useMap[name] != null && useMap[name] != ''){
				queryMap.applyDept = useMap[name].split("|")[1];
		}else if(useMap[name] != null && useMap[name] != '' && useMap[name] != '-1'&& useMap[name] != -1) {
			queryMap[name] = useMap[name];
		}
	}
	return queryMap;
}

/**
 * 查询
 */
function fnQuery(){
	var queryMap = fnParseQueryArg();
	if (queryMap.applyDate && queryMap.applyDate[0] != '' && queryMap.applyDate[1] != '') {
		if (fnParseDatePub(queryMap.applyDate[0]).getTime() > fnParseDatePub(queryMap.applyDate[1]).getTime()) {
	    $.alert($.i18n('office.stock.date.error.js'));
	    return;
	  }
	}
	pTemp.tab.load(queryMap);
}

/**
 * 重置
 */
function fnCancel(){
	pTemp.useTab.clearform();
	$("input:hidden").val("");
	var enums = $.parseJSON(pTemp.jval);
	var stockTypeOptions = fnNewOptionPub(enums.stockTypeEnums);
	$("#stockType").html(stockTypeOptions);
	pTemp.row.stockHouseId = '-1';
	pTemp.row.stockType = '-1';
	if(!pTemp.row.isAdmin){
		var obj ={applyUser: $.ctx.CurrentUser.name};
		$("#applyUserDiv").fillform(obj);
		$("#applyUserDiv").disable();
	}
	pTemp.useTab.fillform(pTemp.row);
}

function fnTabItem(){
 var tabItem = {
   "stockName" : {
       display : $.i18n('office.stock.name.js'),
       name : 'stockName',
       width : '15%',
       sortable : true,
       align : 'left'
   },
   "stockModel" : {
     display : $.i18n('office.manager.StockInfoManagerImpl.ypgg.js'),
     name : 'stockModel',
     width : '15%',
     sortable : true,
     align : 'left'
   },
   "applyAmount" : {
     display : $.i18n('office.stock.applynum.js'),
     name : 'applyAmount',
     width : 90,
     sortType :'number',
     sortorder:'desc',
     sortable : true,
     align : 'right'
   },
   "grantAmount" : {
     display : $.i18n('office.stock.grantnum.js'),
     name : 'grantAmount',
     width : 90,
     sortType :'number',
     sortorder:'desc',
     sortable : true,
     align : 'right'
   },
   "total" : {
     display : $.i18n('office.stock.totalprice.js'),
     name : 'total',
     sortType :'number',
     sortorder:'desc',
     width : 120,
     sortable : true,
     align : 'right'
   }
 }
 
 var items = fnTabItem4UsePub();
 $.extend(tabItem,items);
 return tabItem;
}
