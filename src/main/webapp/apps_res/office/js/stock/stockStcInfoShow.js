//查询的所有参数
var queryParams = new Object();
$(function() {
	//获取父级窗口参数
	var windowParam = window.parentDialogObj['showData'].getTransParams();
	//获取查询模块
	var queryOption = windowParam.option;
	//查询数据
	var queryData = windowParam.params.data;
	//获取查询类型
	var queryType = windowParam.params.type;
	var startTime = windowParam.params.startTime;
	var endTime = windowParam.params.endTime;
	if (queryType && queryType =='member') {
		queryParams.memberId = queryData.memberId;
		queryParams.departMentId = queryData.departMentId;
	} else {
		queryParams.departMentId = queryData.departMentId;
	}
	queryParams.queryType = windowParam.params.type;
	if (startTime && startTime != '') {
		queryParams.startTime = startTime;
	}
	if (endTime && endTime != '') {
		queryParams.endTime = endTime;
	}
	exculQuery(queryParams);
});

/**
 * 执行查询
 */
function exculQuery (queryParams) {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'stockStcManager',
	      managerMethod : 'findByApply',
	      callback : function(fpi) {
	    	 showGrid(fpi.data);
	         $('#_afpPage').val(fpi.page);
	         $('#_afpPages').val(fpi.pages);
	         $('#_afpSize').val(fpi.size);
	         $('#_afpTotal').val(fpi.total);
	      }
	});
	$('#ajaxgridbar').ajaxgridbarLoad(queryParams);
}

function showGrid (datas) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;border-left-color:white'>";
	tableHtml += fnCreateTh();
    tableHtml += "<tbody>";
    tableHtml += funCreateTd(datas);
    tableHtml += "</tbody>";
    tableHtml += "</table>";
    $('#queryResult').html(tableHtml);
}

function fnCreateTh () {
	var ItemArray = getTableItems('values');
	return fnSetTh(ItemArray);
}

function funCreateTd (datas) {
	var ItemArray = getTableItems('keys');
	return fnSetData(ItemArray,datas);
}

function getTableItems (type) {
	var itemMap = new Properties();
	itemMap.put('memberName',$.i18n('office.manager.StockStcManagerImpl.sqr.js'));
	itemMap.put('applyDate',$.i18n('office.stock.stockInfoStc.sqsj.js'));
	itemMap.put('stockHouseName',$.i18n('office.manager.StockInfoManagerImpl.ypk.js'));
	itemMap.put('stockTypeName',$.i18n('office.manager.StockStcManagerImpl.ypfl.js'));
	itemMap.put('stockName',$.i18n('office.manager.StockStcManagerImpl.ypmc.js'));
	itemMap.put('stockModelName',$.i18n('office.manager.StockInfoManagerImpl.ypgg.js'));
	itemMap.put('genNum',$.i18n('office.manager.StockStcManagerImpl.sql.js'));
	itemMap.put('applyNum',$.i18n('office.manager.StockStcManagerImpl.lyl.js'));
	itemMap.put('applyTole',$.i18n('office.manager.StockStcManagerImpl.lyzj.js'));
	if (type == 'values') {
		return itemMap.values();
	} else if (type == 'keys'){
		return itemMap.keys();
	} else if (type == 'alls') {
		return itemMap;
	}
	
}

function fnTdCollBack (culmun , index,data) {
	return "";
}