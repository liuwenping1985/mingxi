// 一年时间的毫秒数
var year_milliseconds = 365*24*60*60*1000; 

/**
 * 取得当前年月，例如: 2012-1
 * @returns {String}
 */
function getNowYearMonth() {
	var date = new Date();
	return date.getFullYear() + "-" + (date.getMonth()+1) ;
}
/**
 * upgrageDate 		系统升级到【V3.50】时间
 * 取得一个月日期,格式为 yyyy-MM，例如：当前月为 2012-2，则返回日期为 2012-1
 * 注意：如果系统升级的时间在本月或者本月之前,显示时间为本月
 * @returns {String}
 */
function getLastYearMonth(upgrageDateStr) {
	if (upgrageDateStr != null) {
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth();
		
		if (month.toString().length == 1) {
			month = "0" + month ;
		}
		if(month == "00"){
		    year = year - 1;
		    month = "12";
		}
		
		var upgrageDate = Date.parseString(upgrageDateStr,"y-M-d");
		var formatDate = returnDateFormat(date.getFullYear() + "-" + month + "-" + "01");
		var firstDayOfMonth = Date.parseString(formatDate,"y-M-d");
		
		if (firstDayOfMonth.isBefore(upgrageDate)) {
			var arr = upgrageDateStr.split("-");
			return arr[0] + "-" + arr[1];
		}
		return year + "-" + month;
	}
	return "";
}
/**
 * 取得当前月/上月的第一天 	yyyy-MM-dd
 * upgrageDate 		系统升级到【V3.50】时间
 * isLastMonth		true 上一个月		false 本月
 * 注意：当前月第一天在升级日期日期之前则显示 升级日期，如果 isLastMonth 为 null 则默认取上一个月第一天
 * @returns {String}
 */
function getFirstDayOfMonth(upgrageDateStr, isLastMonth) {
	if (upgrageDateStr != null && isLastMonth != null) {
		var date = new Date();
		var month = date.getMonth();
		
		if (!isLastMonth) {
			month = month + 1;
		}
		
		if (month.toString().length == 1) {
			month = "0" + month ;
		}
		
		var upgrageDate = Date.parseString(upgrageDateStr,"y-M-d");
		var formatDate = returnDateFormat(date.getFullYear() + "-" + month + "-" + "01");
		var firstDayOfMonth = Date.parseString(formatDate,"y-M-d");
		
		if (firstDayOfMonth.isBefore(upgrageDate)) {
			return upgrageDateStr;
		}
		return formatDate;
	}
	return "";
}

/**
 * 取得当前日期 yyyy-MM-dd
 * @returns {String}
 */
function getNowDay() {
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	
	if (month.toString().length == 1) {
		month = "0" + month ;
	}
	var day = date.getDate();
	if (day.toString().length == 1) {
		day = "0" + day ;
	}
	return year + "-" + month + "-" + day;
}
/**
 * 打印方法
 */
function popprint() {
	var printContentBody = "";
	var cssList = new ArrayList();
	var pl = new ArrayList();
	var contentBody = "" ;
	var contentBodyFrag = "" ;
	
	contentBody = document.getElementById("dataListDiv").innerHTML;
	contentBodyFrag = new PrintFragment(printContentBody, contentBody);
	pl.add(contentBodyFrag);
	
	cssList.add("/seeyon/common/skin/default/skin.css");
	
	printList(pl,cssList);
}
/**
 * 根据产过来的对象id获取值，此值已经去掉空格
 * @param name
 */
function getDocValue(name) {
	return document.getElementById(name).value.trim();
}
/**
 *  日期跨年判断
 * @param beginDate
 * @param endDate
 */
function judgeOneYearDate(beginDate,endDate) {
	var value = parseDate(endDate).getTime()-parseDate(beginDate).getTime();
	if (value < 0) {
		alert(v3x.getMessage("V3XLang.common_enddate_cannot_less_startdate_label"));
		return true;
	}
	if (value > year_milliseconds) {
		alert(v3x.getMessage("V3XLang.common_time_ranage_cannot_more_than_one_year_label"));
		return true;
	}
	return false;
}
/**
 * 此方法包装了 whenstart()和selectDates()时间控件方法,用于判断是否选择的时间段在升级之前,综合分析用到的为 yyyy-MM 格式
 * @param contextPath			上下文
 * @param thisObj 				this对象
 * @param compareDate			比较时间
 * @param isYMformat			true ：年月格式，例如：2012-08   false : 年月日格式,例如：2012-03-09
 */
function getChooseDate(contextPath,thisObj,compareDate,isYMformat) {
	var rv = "";
	var isBefore = false;
	var upgrageDate = "";
	var chooseDateLabel = "";
	var chooseDate = null;
	var originalDate = document.getElementById(thisObj.id).value;
	compareDate="2012-4-1";
	// 升级时间
	upgrageDate = Date.parseString(compareDate,"y-M-d");
	if (isYMformat) {
		rv = selectDates(thisObj.id);
		if (!rv) 
			return ;
		var arr1 = compareDate.split("-");
		var arr2 = rv.split("-");
		if (parseInt(arr1[0]) == parseInt(arr2[0]) && parseInt(arr1[1]) == parseInt(arr2[1])) {
			return rv;
		}
		chooseDate = Date.parseString(returnDateFormat(rv),"y-M-d");
	} else {
		rv = whenstart(contextPath,thisObj,575,140);
		if (!rv)
			return;
		chooseDate = Date.parseString(rv,"y-M-d");
	}
	
	if (rv == null || rv == "")
		return ;
	
	if (chooseDate.isBefore(upgrageDate)) {
		document.getElementById(thisObj.id).value = originalDate==null ? "" : originalDate;
		if (compareDate != "") {
			var arr = compareDate.split("-");
			alert(v3x.getMessage("V3XLang.common_cannot_statistic_before_this_date_data_label",arr[0],arr[1],arr[2])) ;
		}
	} else {
		if (compareDate != null && compareDate != "") {
			document.getElementById(thisObj.id).value=isYMformat?returnDateFormat(rv,true):rv;
		} else {
			document.getElementById(thisObj.id).value = originalDate;
		}
	}
}
/**
 * 查看传过来的日期年月格式是否为 2012-7 格式，如果是则返回 2012-07-01 string 类型
 */
function returnDateFormat(originalDate,onlyMonth) {
	if (originalDate != null) {
		var arr = originalDate.split("-");
		if (arr != null && arr.length > 0) {
		    var year = arr[0];
		    var month = arr[1];
		    var day = "01";
			// 保持月份都为两位数 例如：1 则变为 01
			if (month != null){
			    if(month.length < 2){
			        month = "0" + month;
			    }
		        if(month == "00"){
		            year = year - 1;
		            month = "12";
		        }
			} 
			return year + "-" + month + ( onlyMonth ? "" : "-" +day);
		}
	}
}
/**
 * 流程绩效专用从url中解析某个参数的值。此方法不能解析url中?后面的第一个参数
 * @param url
 * @returns
 */
function workflowAnalysisParseParam(url,paramName){
	var params = url.split("&");
	for(var pi=0; pi < params.length; pi++){
		if(params[pi].indexOf(paramName)>=0){
			var temps = params[pi].split("=");
			return temps[1];
		}
	}
	return "";
}
function openDetailWindow(baseUrl,summaryId,subject,_appEnumStr,from) {
	var templeteId = "";
	try{
		templeteId = parent.document.getElementById("templeteId").value;
	}catch(e){
		var hstr = self.location.href;
		templeteId = workflowAnalysisParseParam(hstr,"templeteId");
	}
	if (templeteId == "") {
		alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
		return ;
	}
	var queryParamsAboutApp = "";
	if (_appEnumStr && (_appEnumStr == 'recEdoc' || _appEnumStr == 'sendEdoc'|| _appEnumStr == 'signReport' || 
			_appEnumStr == 'edocSend' || _appEnumStr == 'edocRec' || _appEnumStr == 'edocSign' 
		)) {
		queryParamsAboutApp = "&appName=4&appTypeName="+_appEnumStr;
	}
	v3x.openWindow({
        url: baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=showFlowNodeDetailFrame&summaryId="+summaryId
        					+"&pageFlag="+from+"&templeteId="+templeteId
        					+"&subject="+encodeURI(subject)+queryParamsAboutApp,
        dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1",
        width: "750",
        height: "500"
    });
}

/**
 * 查看帮助信息
 * 来自综合分析、效率分析、超时分析
 * 
 */
function showHelpDescription(baseUrl,from){
	if('efficiency'==from){//效率分析
		from = '1774058961596794554';
	}
	var _url = baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=showHelpDescription&from=" + from;
	if('1774058961596794554'==from){//效率分析
		_url += '&performanceQuery=1774058961596794554';
	}
	var dialog = $.dialog({
	    id: 'url',
	    url: _url,
	    width: 340,
	    height: 280,
	    targetWindow:getCtpTop(),
	    title: '帮助说明',
	    buttons: [{
	        text: "关闭",
	        handler: function () {
	           dialog.close();
	        }
	    }]
	});
}
