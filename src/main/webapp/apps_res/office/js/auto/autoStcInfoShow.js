//查询的所有参数
var queryParams = new Object();
$(function() {
	var method = "";
	//获取父级窗口参数
	var windowParam = window.parentDialogObj['showData'].getTransParams();
	//获取查询模块
	var queryOption = windowParam.option;
	//查询数据
	var queryData = windowParam.params.data;
	//获取查询类型
	var queryType = windowParam.countType;
	//获取查询的开始时间和结束时间
	var startTime = windowParam.startTime;
	var endTime = windowParam.endTime;
	var _type = windowParam.params.type;
	var _index = windowParam.params.index;
	queryParams.index = _index;
	queryParams.countType = queryType;
	if (queryOption == "find") {
		if (_type == "applyNum") {
			method = "findByApplyNum";
			queryParams.autoInfoId = queryData.applyAutoId;
		} else if (_type == "repairNum") {
			method = "findByRepair";
			queryParams.autoInfoId = queryData.applyAutoId;
		}
	} else if (queryOption == "findByDept"){
		if (_type == "applyNum") {
			method = "findByApplyNum";
			queryParams.departMentId = queryData.departMentId;
		}
	} else if (queryOption == "findByMember") {
		if (_type == "applyNum") {
			method = "findByApplyNum";
			queryParams.departMentId = queryData.departMentId;
			queryParams.memberId = queryData.memberId;
			queryParams.autoInfoId = queryData.applyAutoId;
		}
	} else if (queryOption == "findByDriver") {
		if (_type == "applyNum") {
			method = "findByApplyNum";
			queryParams.driverId = queryData.driverId;
		} else if (_type == "illegalNum") {
			method = "findByIllegal";
			queryParams.driverId = queryData.driverId;
		} else if (_type == "illegalFlagNum"){
			method = "findByIllegal";
			queryParams.driverId = queryData.driverId;
			queryParams.illegalFlag = 0;
		}
	}
	queryParams.startTime = startTime;
	queryParams.endTime = endTime;
	exculQuery(queryParams,method);
});

/**
 * 执行查询
 */
function exculQuery (queryParams,method) {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'autoStcInfoManager',
	      managerMethod : method,
	      callback : function(fpi) {
	    	 showGrid(fpi.data,method);
	         $('#_afpPage').val(fpi.page);
	         $('#_afpPages').val(fpi.pages);
	         $('#_afpSize').val(fpi.size);
	         $('#_afpTotal').val(fpi.total);
	      }
	});
	$('#ajaxgridbar').ajaxgridbarLoad(queryParams);
}

function showGrid (datas,_type) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;border-left-color:white'>";
	tableHtml += fnCreateTh(_type);
    tableHtml += "<tbody>";
    tableHtml += funCreateTd(datas,_type);
    tableHtml += "</tbody>";
    tableHtml += "</table>";
    $('#queryResult').html(tableHtml);
}

function fnCreateTh (_option) {
	var ItemArray = getTableItems('values',_option);
	return fnSetTh(ItemArray);
}

function funCreateTd (datas,_type) {
    var ItemArray = getTableItems('keys',_type);
    for(var i =0;i<datas.length;i++){
        if(datas[i].applyOrigin!=null){
            datas[i].applyOrigin = datas[i].applyOrigin.getLimitLength(20, "...");
        }
        if(datas[i].repairProject!=null){
            datas[i].repairProject = datas[i].repairProject.getLimitLength(20, "...");
        }
        if(datas[i].repairRemarks!=null){
            datas[i].repairRemarks = datas[i].repairRemarks.getLimitLength(20, "...");
        }
    }
    return fnSetData(ItemArray,datas);
}

function getTableItems (type,_option) {
	var itemMap = new Properties();
	if (_option == 'findByApplyNum') {
		itemMap.put('applyUserName',$.i18n('office.auto.autoStcInfo.ycr.js'));
		itemMap.put('applyDeptName',$.i18n('office.auto.autoStcInfoShow.ycbm.js'));
		itemMap.put('passengerNum',$.i18n('office.auto.autoStcInfoShow.ccrs.js'));
		itemMap.put('applyOrigin',$.i18n('office.auto.autoStcInfoShow.ycsy.js'));
		itemMap.put('applyOuttime',$.i18n('office.auto.autoStcInfoShow.ccsj.js'));
		itemMap.put('applyDes',$.i18n('office.auto.autoStcInfoShow.mdd.js'));
		itemMap.put('applyAutoIdName',$.i18n('office.auto.autoStcInfo.cph.js'));
		itemMap.put('applyDriverName',$.i18n('office.auto.autoStcInfo.jsy.js'));
	} else if (_option == 'findByRepair') {
		itemMap.put('autoInfoNumber',$.i18n('office.auto.autoStcInfo.cph.js'));
		itemMap.put('routineStr',$.i18n('office.auto.autoStcInfoShow.lxby.js'));
		itemMap.put('repairTime',$.i18n('office.auto.autoStcInfoShow.wxsj.js'));
		itemMap.put('retrievalTime',$.i18n('office.auto.autoStcInfoShow.qhsj.js'));
		itemMap.put('repairFee',$.i18n('office.auto.autoStcInfoShow.wxfy.js'));
		itemMap.put('repairProject',$.i18n('office.auto.autoStcInfoShow.wxxm.js'));
		itemMap.put('memberName',$.i18n('office.auto.autoStcInfoShow.jsr.js'));
	} else if (_option == "findByIllegal") {
		itemMap.put('autoInfoNumber',$.i18n('office.auto.autoStcInfo.cph.js'));
		itemMap.put('illegalDate',$.i18n('office.auto.autoStcInfoShow.wzsj.js'));
		itemMap.put('illegalAddr',$.i18n('office.auto.autoStcInfoShow.wzdd.js'));
		itemMap.put('illegalAction',$.i18n('office.auto.autoStcInfoShow.wzxw.js'));
		itemMap.put('mark',$.i18n('office.auto.autoStcInfo.kf.js'));
		itemMap.put('illegalFlagStr',$.i18n('office.auto.autoStcInfoShow.zcsg.js'));
		itemMap.put('driverMemberName',$.i18n('office.auto.autoStcInfo.jsy.js'));
		itemMap.put('dealStateStr',$.i18n('office.auto.autoStcInfoShow.clzs.js'));
	}
	if (type == 'values') {
		return itemMap.values();
	} else if (type == 'keys'){
		return itemMap.keys();
	} else if (type == 'alls') {
		return itemMap;
	}
	
}

function fnTdCollBack (culmun , index,data) {
	if (culmun == "passengerNum") {
		if (data["passengerNum"] == null) {
			return " ";
		}
	}
	return "";
}