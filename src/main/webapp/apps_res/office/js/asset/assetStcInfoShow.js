//查询的所有参数
var queryParams = new Object();
$(function() {
	//获取父级窗口参数
	var windowParam = window.parentDialogObj['showData'].getTransParams();
	//查询数据
	var queryData = windowParam.params.data;
	//获取查询类型
	var queryType = windowParam.queryType;
	//设备类型id
	var assetType = windowParam.params.type;
	if  (queryType == 'member') {
		queryParams.memberId = queryData.memberId;
	}
	queryParams.departMentId = queryData.departMentId;
	queryParams.assetType = assetType;
	exculQuery(queryParams);
});

/**
 * 执行查询
 */
function exculQuery (queryParams) {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'assetStcManager',
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
	itemMap.put('departMentName',$.i18n('office.asset.assetStcInfoShow.sybm.js'));
	itemMap.put('memberName',$.i18n('office.asset.assetUse.syr.js'));
	itemMap.put('assetNum',$.i18n('office.asset.selectAsset.sbbh.js'));
	itemMap.put('assetName',$.i18n('office.auto.bookStcInfo.mc.js'));
	itemMap.put('assetPP',$.i18n('office.asset.selectAsset.pp.js'));
	itemMap.put('assetXH',$.i18n('office.asset.selectAsset.xh.js'));
	itemMap.put('assetDesc',$.i18n('office.asset.selectAsset.sbms.js'));
	itemMap.put('assetNum',$.i18n('office.asset.assetStcInfoShow.sl.js'));
	itemMap.put('applyDate',$.i18n('office.asset.assetStcInfoShow.jcrq.js'));
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