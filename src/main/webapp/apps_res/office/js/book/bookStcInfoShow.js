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
	var queryType = windowParam.countType;
	var startTime = windowParam.startTime;
	var endTime = windowParam.endTime;
	if (queryOption == 'findByBook') {
		queryParams.bookId = queryData.bookId;
		queryParams.queryType = windowParam.params.type;
	} else {
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
	}
	exculQuery(queryParams);
});

/**
 * 执行查询
 */
function exculQuery (queryParams) {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'bookStcInfoManager',
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
	itemMap.put('bookNum',$.i18n('office.auto.bookStcInfo.bh.js'));
	itemMap.put('bookName',$.i18n('office.auto.bookStcInfo.mc.js'));
	itemMap.put('bookCategory',$.i18n('office.auto.bookStcInfo.lb.js'));
	itemMap.put('bookHouseName',$.i18n('office.book.bookStcInfoShow.tsk.js'));
	itemMap.put('applyCount',$.i18n('office.book.bookStcInfoShow.jysl.js'));
	itemMap.put('applyDate',$.i18n('office.book.bookStcInfoShow.jysj.js'));
	itemMap.put('applyUser',$.i18n('office.book.bookStcInfoShow.jyr.js'));
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