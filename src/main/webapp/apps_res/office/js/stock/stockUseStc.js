$(function() {
  pTemp.TBar = officeTBar().addAll([ "export" ]).init("toolbar");
  pTemp.tab = officeTab().addAll([ "dept","member","applyAmount", "grantAmount", "grantTotal"]);
  for ( var i = 0; i < 6; i++) {
  	pTemp.tab.addAll([ "applyAmount", "grantAmount", "grantTotal"]);
	}
  pTemp.tab.init("stockInfoStcTab", {
      argFunc : "fnStockUseStcTab",
      parentId : $('.stadic_layout_body').eq(0).attr('id'),
      slideToggleBtn : false,
      resizable : false,
      customize:false,
      onSuccess:sdfsdf,
      "managerName" : "stockStcManager",
      "managerMethod" : "findStockUseStc"
  });
  
  pTemp.ajaxM = new stockStcManager();
  pTemp.layout = $('#layout').layout();
  pTemp.useTab = $("#stockUseTab");
  fnPageReload();
});


function sdfsdf(){
	var header = $("<tr><th colspan='2' valign='middle'><div class='align_center'></div></th><th colspan='3'><div class='align_center'>2013年6月</div></th><th colspan='3'><div class='align_center'>2013年6月</div></th><th colspan='3'><div class='align_center'>2013年6月</div></th><th colspan='3'><div class='align_center'>2013年6月</div></th><th colspan='3'><div class='align_center'>2013年6月</div></th></tr>");
	//removeHeader
	var htab = $("#stockInfoStcTabDiv .hDivBox").find("table");
	//removes
	$("#stockInfoStcTabDiv .cDrag").remove();
	htab.addClass("font_size12 only_table edit_table");
//	
//	var tr1 = htab.find("tr th").first().attr("rowspan",'2').clone(true);
//	htab.find("tr th").first().remove();
//	
//	var tr2 = htab.find("tr th").first().attr("rowspan",'2').clone(true);
//	htab.find("tr th").first().remove();
//	
//	htab.find("tr").before(header);
//	htab.find("tr th").first().before(tr2);
//	htab.find("tr th").first().before(tr1);
	
	//pTemp.tab.reSize();
}

function fnPageReload() {
	pTemp.tab.load();
  if (pTemp.jval) {
    var jval = $.parseJSON(pTemp.jval);
    pTemp.row = jval;
		pTemp.useTab.fillform(jval);
}
}

function fnParseStcArg() {
	var applyDate = ['',''];
	var useMap = pTemp.useTab.formobj();
	var queryMap = {};
	for (var name in useMap) {
		if(name =="stcTime0"){
			if (useMap[name] != null && useMap[name] != '') {
				applyDate[0] = useMap[name];
				queryMap.applyDate = applyDate;
			}
		}else	if(name == "stcTime1"){
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
 * 统计
 */
function fnStc() {
  var stcMap = fnParseStcArg();
  pTemp.tab.load(stcMap);
}

/**
 * 重置
 */
function fnCancel() {
	pTemp.useTab.clearform();
	pTemp.useTab.fillform(pTemp.row);
	fnFillRadioPub(pTemp.useTab,{stcType:'dept',reportType:'general'});
}

/**
 * 导出Excel
 */
function fnExp() {
  var stcMap = fnParseStcArg();
  $("#btnok").jsonSubmit({
		action : _path + "/office/stockStc.do?method=expStockInfoStc",
		paramObj:stcMap,
    callback: function() {
    }
  });
}

function fnStockUseStcTab() {
    return {
	    	"dept" : {
	        display :$.i18n('office.auto.autoStcInfo.bm.js'),
	        name : 'dept',
	        width : '80',
	        sortable : false,
	        align : 'left',
	        isToggleHideShow:false
    		},
    		"member" : {
	        display :$.i18n('office.auto.bookStcInfo.ry.js'),
	        name : 'dept',
	        width : '80',
	        sortable : false,
	        align : 'left',
	        isToggleHideShow:false
	  		},
        "applyAmount" : {
            display : $.i18n('office.stock.price.total.4.apply.js'),
            name : 'applyAmount',
            width : '48',
            sortable : false,
            isToggleHideShow:false,
            align : 'right'
        },
        "grantAmount" : {
          display : $.i18n('office.stock.price.total.4.num.js'),
          name : 'grantAmount',
          width : '48',
          isToggleHideShow:false,
          sortable : false,
          align : 'right'
        },
        "grantTotal" : {
          display : $.i18n('office.stock.price.total.4.con.js'),
          name : 'grantTotal',
          width : '48',
          isToggleHideShow:false,
          sortable : false,
          align : 'right'
        }
    };
}

function fnInitYear(curtYear){
	
}

function fnStcTypeClk(type) {
	var dept = $("#stcDept_txt"), user = $("#stcUser_txt");
	if (type == 'dept') {
		dept.show();
		user.hide();
	} else if (type == 'user') {
		dept.hide();
		user.show();
	}
}

function fnReportTypeClk(type){
	var generalTR = $("#generalTR"),crossTR = $("#crossTR");
	if (type == 'general') {
		generalTR.show();
		crossTR.hide();
	} else if (type == 'cross') {
		generalTR.hide();
		crossTR.show();
	}
}

function fnStcTypeYear2MonthClk(type){
	var crossYearDiv = $("#crossYearDiv"),crossMonthDiv = $("#crossMonthDiv");
	if (type == 'year') {
		crossYearDiv.show();
		crossMonthDiv.hide();
	} else if (type == 'month') {
		crossYearDiv.hide();
		crossMonthDiv.show();
	}
}