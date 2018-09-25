// js开始处理
$(function() {
	// toolbar
	pTemp.TBar = officeTBar().addAll([ "export", "print" ]).init("toolbar");
	// table
	pTemp.tab = officeTab().addAll(
			[ "id", "stockHouseName", "stockType", "stockName", "stockModel", "recordCount","stockPrice","stockUnit", "recordDate","createUser" ]).init("stockRecord", {
		argFunc : "fnStockInfoItems",
		parentId : $('.stadic_layout_body').eq(0).attr('id'),
		slideToggleBtn : false,// 上下伸缩按钮是否显示
		resizable : false,// 明细页面的分隔条
		"managerName" : "stockRecordManager",
		"managerMethod" : "find"
	});
	$('#stockRecord').width("");
	pTemp.layout = $('#layout').layout();
	pTemp.useTab = $("#stockUseTab");
	pTemp.ajaxM = new stockRecordManager();
	pTemp.stockUse = new stockUseManager();
	fnPageReload();
	//记录系统传过来的入库时间范围、以便重置的时候使用
	pTemp.lastdate = $("#recordDate0").val(); //开始日期
	pTemp.curdate = $("#recordDate1").val(); //当前日期
});

/**
 * 根据当前选中的用品库，初始化用品库中有用品的分类
 */
function fnHouseChange(){
	var typeOfHouse = pTemp.stockUse.findStockTypeEnum($("#stockHouseId").val());
	var stockTypeOptions = fnNewOptionPub(typeOfHouse);
	$("#stockType").html(stockTypeOptions);
}

/**
 * 刷新页面
 */
function fnPageReload() {
	pTemp.tab.load();
	// 加载页面枚举
	if (pTemp.jval != '') {
		var enums = $.parseJSON(pTemp.jval);
		var uesedHouseOptions = fnNewOptionPub(enums.uesedHouseEnums);
		var stockTypeOptions = fnNewOptionPub(enums.stockTypeEnums);
		$("#stockHouseId").html(uesedHouseOptions);
		$("#stockType").html(stockTypeOptions);
	}
}

/**
 * 导出
 */
function fnExp() {
	var queryMap = fnParseQueryArg();
	$("#btnok").jsonSubmit({
		action : _path + "/office/stockSet.do?method=expStockRecords",
		paramObj : queryMap,
		callback : function() {
		}
	});
}

function fnPrint() {
	var printSubject = "";
	var printsub = "${ctp:i18n('calendar.event.list.toexcel.title')}";
	printsub = "<center><span style='font-size:24px;line-height:24px;'>"
			+ printsub.escapeHTML()
			+ "</span><hr style='height:1px' class='Noprint'&lgt;</hr></center>";

	var printColBody = "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
	var colBody = stockRecord();
	var colBodyFrag = new PrintFragment(printSubject, colBody);

	var cssList = new ArrayList();
//	cssList.add("/apps_res/collaboration/css/collaboration.css")

	var pl = new ArrayList();
	// pl.add(printSubFrag);
	pl.add(colBodyFrag);
	printList(pl, cssList)
}

function stockRecord(){
    var mxtgrid = $("#stockRecord");
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

function fnParseQueryArg() {
	var applyDate = [ '', '' ];
	var useMap = pTemp.useTab.formobj();
	var queryMap = {};
	for ( var name in useMap) {
		if (name == "applyDate0") {
			if (useMap[name] != null && useMap[name] != '') {
				applyDate[0] = useMap[name];
				queryMap.applyDate = applyDate;
			}
		} else if (name == "applyDate1") {
			if (useMap[name] != null && useMap[name] != '') {
				applyDate[1] = useMap[name];
				queryMap.applyDate = applyDate;
			}
		} else if (name == "applyDept" && useMap[name] != null
				&& useMap[name] != '') {
			queryMap.applyDept = useMap[name].split("|")[1];
		} else if (useMap[name] != null && useMap[name] != ''
				&& useMap[name] != '-1' && useMap[name] != -1) {
			queryMap[name] = useMap[name];
		}
	}
	return queryMap;
}

/**
 * 查询
 */
function fnQuery() {
	var queryMap = fnParseQueryArg();
	if(TimeVer()){
	  return ;
	}
	pTemp.tab.load(queryMap);
}

/**
 * 重置
 */
function fnCancel() {
	var enums = $.parseJSON(pTemp.jval);
	var stockTypeOptions = fnNewOptionPub(enums.stockTypeEnums);
	$("#stockType").html(stockTypeOptions);
	pTemp.useTab.clearform();
	//以下两行  是为了兼容IE6
	$("#stockHouseId").val(-1);
	$("#stockType").val(-1);
	//重置入库日期范围
	$("#recordDate0").val(pTemp.lastdate); //开始日期
	$("#recordDate1").val(pTemp.curdate); //当前日期
}

function fnStockInfoItems() {
	return {
		"id" : {
			display : 'id',
			name : 'id',
			width : '5%',
			sortable : false,
			align : 'center',
			hide : true,
			type : 'checkbox',
			isToggleHideShow : false
		},
		"stockHouseName" : {
			display : $.i18n('office.stock.house.js'),
			name : 'stockHouseName',
			width : '12%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		},
		"stockType" : {
			display : $.i18n('office.stock.type.js'),
			name : 'stockTypeName',
			width : '10%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"stockName" : {
			display : $.i18n('office.stock.name.js'),
			name : 'stockName',
			width : '12%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"stockModel" : {
			display : $.i18n('office.manager.StockInfoManagerImpl.ypgg.js'),
			name : 'stockModel',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"stockPrice" : {
			display : $.i18n('office.stock.stockprice.js'),
			name : 'stockPrice',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"recordCount" : {
			display : $.i18n('office.stock.storagecount.js'),
			name : 'recordCount',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"stockUnit" : {
			display : $.i18n('office.stock.unit.js'),
			name : 'stockUnit',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"recordDate" : {
			display : $.i18n('office.stock.storagedate.js'),
			name : 'recordDate',
			width : '15%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"createUser" : {
			display : $.i18n('office.stock.createuser.js'),
			name : 'createUser',
			width : '10%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		}
	}
}

/**
 * 转换日期
 */
function fnDateParse(dateStr) {
  dateStr = dateStr.replace(/-/g,"/");
  return new Date(dateStr);
}

/**
 * 查询时间校验
 */
function TimeVer() {
  var recordDate0 = fnDateParse($('#recordDate0').val());
  var recordDate1 = fnDateParse($('#recordDate1').val());
  if (recordDate0 > recordDate1) {
    $.alert($.i18n('office.stock.date.error.js'));
    return true;
  }else{
    return false;
  }
}  