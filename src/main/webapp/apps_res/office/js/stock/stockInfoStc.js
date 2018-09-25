var layout;
var queryType = "";
var queryCountType = "0";
var queryStartTime;
var queryEndTime;
$(document).ready(function () {
	layout = $('#layout').layout();
	var stockHouses = $.parseJSON(stockParam.stockHouses);
	var stockCategorys = $.parseJSON(stockParam.stockCategorys);
	var param = {
			'stockHouse' : stockHouses,
			'stockCategorys' : stockCategorys
	}
	if (stockParam.option == 'findStockInfoStc') {
		flowOverTimeStatistics(param);
	} else {
		flowOverTimeStatisticsByMember();
	}
 });

$(function() {
	executeStatistics();
});

function flowOverTimeStatisticsByMember () {
	var dateValue = fnsetDefaultValue("other");
	var startDate = dateValue.get('start');
	var endDate = dateValue.get('end');
	var hh = "";
	hh += "<div class='form_area set_search'>";
	hh += '<table  width="90%" id="stockUseTab" class="margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout: fixed;margin-left:0px;">';
    hh += '<tr>';
    	hh += '<th noWrap="nowrap" width="10%" align="right"><label for="text">'+$.i18n('office.book.bookStcInfo.tjd.js')+':</label></th>';
	    hh += '<td align="left" width="15%">';
		    hh +="<div class='driver_radio_peopleType  clearfix align_left'>";
		    hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
		    hh +="<input id='queryType'  class='radio_com' value='0' type='radio' onclick='clearInput()' checked='checked' name='queryType'/>";
		    hh +="<span class='margin_l_5'>"+$.i18n('office.auto.autoStcInfo.bm.js')+"</span>";
		    hh +="</label>";
		    hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
		    hh +="<input id='queryType'  class='radio_com' value='1' type='radio' onclick='clearInput()' name='queryType'/>";
		    hh +="<span class='margin_l_5'>"+$.i18n('office.auto.bookStcInfo.ry.js')+"</span>";
		    hh +="</label></div>";
	    hh += '</td>';
	    hh += '<td colspan="2" width="30%">';
		    hh += '<div class="common_txtbox_wrap">';
		    hh += '<input id="entityName" class="font_size12" maxlength="80" onclick="fnSelectEntity()" type="text"><input type="hidden" id="entityId" value="">';
		    hh += '</div>';
	    hh += '</td>';
	    hh += '<td colspan="2" width="45%">';
	    hh += '</td>';
    hh += '</tr>';
    hh += "<tr>";
    	hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.auto.autoStcInfo.bblx.js')+':</label></th>';
        hh +="<td td colspan='4' align='left' >";
        hh +="<div class='driver_radio_peopleType  clearfix align_left'>";
        hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
        hh +="<input id='countType' onclick='fnShowConn(0)' class='radio_com' value='0' type='radio' checked='checked' name='countType'/>";
        hh +="<span class='margin_l_5'>"+$.i18n('office.auto.autoStcInfo.ry.js')+"</span>";
        hh +="</label>";
        hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
        hh +="<input id='countType' onclick='fnShowConn(1)' class='radio_com' value='1' type='radio' name='countType'/>";
        hh +="<span class='margin_l_5'>"+$.i18n('office.auto.autoStcInfo.ay.js')+"</span>";
        hh +="</label>";
        hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
        hh +="<input id='countType' onclick='fnShowConn(2)' class='radio_com' value='2' type='radio' name='countType' />";
        hh +="<span class='margin_l_5'>"+$.i18n('office.auto.autoStcInfo.an.js')+"</span>";
        hh +="</label></div>";
        hh +="</td>";
        hh += "<td  align='left'>";
        hh +="</td>";
    hh += '</tr>';
    hh += '<tr>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.stock.stockInfoStc.sqsj.js')+':</label></th>'
    hh += "<td colspan='4' align='left'>";
    hh +="<table width='60%' >";
    hh +="<tr id='dateContions'>";
    hh += getDateQueryHtml("other");
    hh +="</tr>"
    hh +="</table>";
    hh +="</td>"
	hh += '<td>';
    hh += '</td>';
    hh += '</tr>';
    hh += '</table>';
    hh += "</div>";
    hh += fuGetButton();
	$("#tabs #queryCondition").html(hh);
    $(".mycal").each(function(){$(this).compThis();});
}
/**
 * 生成查询列
 */
function flowOverTimeStatistics (param) {
	var dateValue = fnsetDefaultValue("other");
	var startDate = dateValue.get('start');
	var endDate = dateValue.get('end');
	var hh = "";
	hh += "<div class='form_area set_search'>";
	hh += '<table id="stockUseTab" class="w90b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout: fixed;">';
    hh += '<tr>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.manager.StockInfoManagerImpl.ypk.js')+':</label></th>';
    hh += '<td colspan="2" align="left" width="200">';
    hh += '<div class="common_selectbox_wrap">';
    hh += '<select id="bookHouse" class="w100b h100b" onchange="checkTypeSelect(this)">';
    hh += '<option value="" selected="selected"></option>';
    for (var i = 0 ; i < param.stockHouse.length ; i ++) {
    	var house = param.stockHouse[i];
    	var text = house.text;
    	hh += '<option value="'+house.value+'" title="'+text+'">'+text.getLimitLength(47,'...')+'</option>';
    } 
    hh +='</select>';
    hh += '</div>';
    hh += '</td>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.book.bookBorrow.ssfl.js')+':</label></th>';
    hh += '<td colspan="2" align="left" width="200">';
    hh += '<div class="common_selectbox_wrap">';
    hh += '<select id="bookCategory" class="w100b h100b" >';
    hh += '<option value="" selected="selected"></option>';
    for (var i = 0 ; i < param.stockCategorys.length ; i ++) {
    	var bookCategory = param.stockCategorys[i];
    	hh += '<option value="'+bookCategory.value+'">'+bookCategory.text+'</option>';
    }
    hh += '</select>';
    hh += '</div>';
    hh += '</td>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.auto.bookStcInfo.mc.js')+':</label></th>';
    hh += '<td colspan="2" width="200">';
    hh += '<div class="common_txtbox_wrap">';
    hh += '<input id="bookName" class="font_size12" maxlength="80" type="text">';
    hh += '</div>';
    hh += '</td>';
    hh += '</tr>';
    for (var i = 0 ; i < 4 ; i ++) {
    	hh += '<tr>';
        hh += '<td colspan="9">&nbsp;';
        hh += '</td>';
        hh += '</tr>';
    }
    hh += '</table>';
    hh += "</div>";
    hh += fuGetButton();
	$("#tabs #queryCondition").html(hh);
    $(".mycal").each(function(){$(this).compThis();});
}

function fuGetButton() {
    return "<div style='margin-top:30px;' class='align_center margin_t_20 clear padding_lr_5 padding_b_5' id='button_div'>" + 
    "<a href='javascript:void(0)' class='common_button common_button_emphasize margin_r_10' id='querySave' onclick='executeStatistics()'>"+$.i18n('office.auto.autoStcinfo.tj.js')+"</a>" +
    "<a id='queryReset' class='common_button common_button_gray margin_r_10' href='javascript:void(0)' onclick='resetResult()'>"+$.i18n('office.auto.autoStcinfo.cz.js')+"</a>"+"</div>";
}


/**
 * 执行统计方法
 */
function executeStatistics () {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'stockStcManager',
	      managerMethod : stockParam.option,
	      callback : function(fpi) {
	    	 if (queryCountType && queryCountType != "0") {
	    		 showGroupGrid(fpi.data);
	    	 } else {
	    		 showGrid(fpi.data);
	    	 }
	         $('#_afpPage').val(fpi.page);
	         $('#_afpPages').val(fpi.pages);
	         $('#_afpSize').val(fpi.size);
	         $('#_afpTotal').val(fpi.total);
	      }
	});
	var obj = fnGetParams();
	if (obj != null) {
		$('#ajaxgridbar').ajaxgridbarLoad(obj);
	}
	$('#countDate').html($.i18n('office.book.bookStcInfo.tjrq.js')+':' + new Date().format('yyyy-MM-dd'));
	if (stockParam.option == 'findStockInfoStc'){
		$('#queryTitle').html($.i18n('office.stock.stockInfoStc.bgyptj.js'));
	} else {
		$('#queryTitle').html($.i18n('office.stock.stockInfoStc.yplytj.js'));
		var timeLength = "";
		if ($('#start_time').val() != '' && $('#end_time').val() != '') {
			timeLength  = $('#start_time').val() + $.i18n('office.stock.stockInfoStc.z.js') +  $('#end_time').val();
		}
		if ($('#start_time').val() == '' && $('#end_time').val() != '') {
			timeLength  = $('#end_time').val() +$.i18n('office.auto.autoStcInfo.yq.js');
		}
		if ($('#end_time').val() == '' && $('#start_time').val() != '') {
			timeLength  = $('#start_time').val() +$.i18n('office.auto.autoStcInfo.zj.js');
		}
		$('#contFace').html($.i18n('office.stock.stockInfoStc.sqsj.js')+":" + timeLength);
	} 
}

function showGrid (datas) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>";
	tableHtml += fnCreateTh();
    tableHtml += "<tbody>";
    tableHtml += funCreateTd(datas);
    tableHtml += "</tbody>";
    tableHtml += "</table>";
    $('#queryResult').html(tableHtml);
}

function showGroupGrid (valueData) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>";
	tableHtml += fnShowThByGroup();
    tableHtml += "<tbody>";
    tableHtml += funCreateTdByGroup(valueData);
    tableHtml += "</tbody>";
    tableHtml += "</table>";
    $('#queryResult').html(tableHtml);
}

function fnShowThByGroup (_option) {
	var forLength = 0;
	if (queryCountType == '1') {
		var startYear = queryStartTime.split('-')[0];
		var startMounth = queryStartTime.split('-')[1];
		var endYear = queryEndTime.split('-')[0];
		var endMounth = queryEndTime.split('-')[1];
		var years = ((parseInt(endYear,10) - parseInt(startYear,10))) * 12;
		var mounths = parseInt(endMounth,10) - parseInt(startMounth,10);
		forLength = years + mounths + 1;
	} else {
		var start = parseInt(queryStartTime,10)- 1;
		forLength = parseInt(queryEndTime,10) - start;
	}
	var thItemArray = getThItemArrayByCars('values');
	var style = queryType == 'member' ? 'style2' : 'style1';
	return fnCreateThByGoup(thItemArray, forLength, style)
}


/**
 * 分组统计生成数据列
 * @param datas
 */
function funCreateTdByGroup (datas,_option){
	var forLength = 0;
	if (queryCountType == '1') {
		var startYear = queryStartTime.split('-')[0];
		var startMounth = queryStartTime.split('-')[1];
		var endYear = queryEndTime.split('-')[0];
		var endMounth = queryEndTime.split('-')[1];
		var years = ((parseInt(endYear,10) - parseInt(startYear,10))) * 12;
		var mounths = parseInt(endMounth,10) - parseInt(startMounth,10);
		forLength = years + mounths + 1;
	} else {
		var start = parseInt(queryStartTime,10)- 1;
		forLength = parseInt(queryEndTime,10) - start;
	}
	var itemArrayMap = getThItemArrayByCars('alls');
	if (queryType == 'member') {
		itemArrayMap.remove('departMentName');
	}
	var itemArray = itemArrayMap.keys();
	var tdHtml ="";
	if (queryType == 'member') {
		tdHtml += fnSetDataByMemberGroup(forLength,itemArray,datas);
	} else {
		tdHtml += fnSetDateByGroup(datas, forLength, itemArray, "departMentName");
	}
	return tdHtml;
}

function fnSetDataByMemberGroup(forLength,itemArray,datas) {
	var dataMap = fnCreateMapByDept(datas,'departMentId');
	return fnSetDataGorupStyleTow(forLength,itemArray,dataMap,'departMentName','memberName');
}

function fnCreateTh () {
	var ItemArray = getThItemArrayByCars('values');
	return fnSetTh(ItemArray);
}

function funCreateTd (datas) {
	var itemArray = getThItemArrayByCars('alls');
	if (stockParam.option == 'findByMemberOrDept' && queryType =='member') {
		var deptDataMap = fnCreateMapByDept(datas,'departMentId');
		itemArray.remove("departMentName");
		return fnSetDateStyeTow(deptDataMap,itemArray.keys(),'departMentName');
	} else {
		return fnSetData(itemArray.keys(),datas);
	}
}

function fnDateParse(dateStr) {
	dateStr = dateStr.replace(/-/g,"/");
	return new Date(dateStr);
}


/**
 * 获取普通查询列表头
 * @param type
 * @param _option
 * @returns
 */
function getThItemArrayByCars(type) {
	var itemMap = new Properties();
	if (stockParam.option == 'findStockInfoStc') {
		itemMap.put('stockNum',$.i18n('office.manager.StockStcManagerImpl.ypbm.js'));
		itemMap.put('stockName',$.i18n('office.manager.StockStcManagerImpl.ypmc.js'));
		itemMap.put('stockTypeName',$.i18n('office.manager.StockStcManagerImpl.ypfl.js'));
		itemMap.put('stockHouseName',$.i18n('office.manager.StockStcManagerImpl.ypk.js'));
		itemMap.put('stockModelName',$.i18n('office.manager.StockInfoManagerImpl.ypgg.js'));
		itemMap.put('stockUnit',$.i18n('office.manager.StockStcManagerImpl.jldw.js'));
		itemMap.put('stockPrice',$.i18n('office.manager.StockStcManagerImpl.pjdj.js'));
		itemMap.put('stockCount',$.i18n('office.manager.StockStcManagerImpl.rkl.js'));
		itemMap.put('stockCountPrice',$.i18n('office.manager.StockStcManagerImpl.rkzj.js'));
		itemMap.put('applyNum',$.i18n('office.manager.StockStcManagerImpl.lyl.js'));
		itemMap.put('applyTole',$.i18n('office.manager.StockStcManagerImpl.lyzj.js'));
		itemMap.put('nowCount',$.i18n('office.manager.StockStcManagerImpl.dqkc.js'));
	} else {
		itemMap.put('departMentName',$.i18n('office.manager.StockStcManagerImpl.sqbm.js'));
		if (queryType == 'member') {
			itemMap.put('memberName',$.i18n('office.manager.StockStcManagerImpl.sqr.js'));
		}
		itemMap.put('genNum',$.i18n('office.manager.StockStcManagerImpl.sql.js'));
		itemMap.put('applyNum',$.i18n('office.manager.StockStcManagerImpl.lyl.js'));
		itemMap.put('applyTole',$.i18n('office.manager.StockStcManagerImpl.lyzj.js'));
	}
	if (type == 'values') {
		return itemMap.values();
	} else if (type == 'keys'){
		return itemMap.keys();
	} else if (type == 'alls') {
		return itemMap;
	}
}

function fnGetParams () {
	var object = new Object();
	var queryTypes = $('input:radio[name="queryType"]:checked').val();
	var countType = $('input:radio[name="countType"]:checked').val();
	var bookHouse = $('#bookHouse').val();
	var bookCategory = $('#bookCategory').val();
	var bookName = $('#bookName').val();
	var entityId = $('#entityId').val();
	var startTime = $('#start_time').val();
	var endTime = $('#end_time').val();
	if (bookHouse && bookHouse != '') {
		object.stockHouse = bookHouse;
	}
	if (bookCategory && bookCategory != '') {
		object.stockType = bookCategory;
	}
	if (bookName && bookName != '') {
		object.stockName = bookName;
	}
	if (queryTypes && queryTypes != '') {
		if (queryTypes == '0') {
			queryType = "departMent";
			object.queryType = "departMent";
		} else {
			queryType = "member";
			object.queryType = "member";
		}
	}
	if (entityId && entityId != '') {
		object.entityId = entityId;
	}
	queryCountType = countType;
	queryStartTime = startTime;
	queryEndTime = endTime;
	if (!countType) {
		countType = "0";
	}
	if (countType == '0') {
		if (startTime && startTime != '') {
			object.startTime = startTime+' 00:00:00';
		}
		if (endTime && endTime != '') {
			object.endTime = endTime+' 23:59:59';
		}
	} else if (countType == '1') {
		if (startTime == '') {
			$.alert($.i18n('office.auto.autoStcInfo.ayhzkssjbnwk.js'));
			return null;
		}
		if (endTime == '') {
			$.alert($.i18n('office.auto.autoStcInfo.ayhzjssjbnwk.js'));
			return null;
		}
		if (fnDateParse(endTime +"-01") > new Date()) {
			$.alert($.i18n('office.auto.autoStcInfo.date1.js'));
			return null;
		}
		if (fnDateParse(endTime+"-01") < fnDateParse(startTime+"-01")) {
			$.alert($.i18n('office.auto.autoStcInfo.ksrqbndydqjsrq.js'));
			return null;
		}
		if (!checkDate(startTime)) {
			$.alert($.i18n('office.auto.autoStcInfo.ksrqbshfrq.js'));
			return null;
		}
		if (!checkDate(endTime)) {
			$.alert($.i18n('office.auto.autoStcInfo.jsrqbshfrq.js'));
			return null;
		}
		var startYear = startTime.split('-')[0];
		var startMounth = startTime.split('-')[1];
		var endYear = endTime.split('-')[0];
		var endMounth = endTime.split('-')[1];
		var years = ((parseInt(endYear,10) - parseInt(startYear,10))) * 12;
		var mounths = parseInt(endMounth,10) - parseInt(startMounth,10);
		if ((years + mounths) > 12) {
			$.alert($.i18n('office.auto.autoStcInfo.qjzd.js'));
			return null;
		}
		object.startTime = startTime;
		object.endTime = endTime;
	} else {
		if (parseInt(endTime,10) > new Date().getFullYear()) {
			$.alert($.i18n('office.auto.autoStcInfo.date2.js'));
			return null;
		}
		if (parseInt(startTime,10) > parseInt(endTime,10)) {
			$.alert($.i18n('office.book.bookStcInfo.ksrqbndydqjsrq.js'));
			return null;
		}
		if (parseInt(endTime,10) - parseInt(startTime,10) > 2) {
			$.alert($.i18n('office.stock.stockInfoStc.tjnfxzcgnqzxxz.js'));
			return null;
		}
		object.startTime = startTime;
		object.endTime = endTime;
	}
	object.countType = countType;
	return object;
}

function clearInput () {
	 $('#entityName').val('');
	 $('#entityId').val('');
}

function fnSelectEntity () {
	var countType = $('input:radio[name="queryType"]:checked').val();
	var selectType = 'Member';
	var panels = 'Department';
	var isConfirmExcludeSubDepartmentFlag = false;
	if (countType == '0') {
		selectType = 'Department';
		isConfirmExcludeSubDepartmentFlag = true;
	}
	var showName = $('#entityName').val();
	var showId = $('#entityId').val();
	$.selectPeople({
	    params : {
	      text : showName,
	      value :showId
	    },
	    callback : function(ret) {
	    	if (ret) {
	    	   $('#entityId').val(ret.value);
	  	       $('#entityName').val(ret.text);
	    	}
	    },
	    selectType :selectType,
	    maxSize:1000,
	    isConfirmExcludeSubDepartment:isConfirmExcludeSubDepartmentFlag,
	    minSize:0,
	    onlyLoginAccount:true,
	    showOriginalElement:true,
	    panels:panels
	});
}


function fnDownExcel () {
	var obj = fnGetParams();
	if (bookParams.option == 'findByBook') {
		obj.expType = bookParams.option;
	} else {
		if (obj.countType == 'member') {
			obj.expType = "findByMember";
		} else {
			obj.expType = "findByDepartMent";
		}
	}
	var parmaStr = fnGetUrlParams(obj);
	var _url = _path+"/office/bookStc.do?method=expExcel"+parmaStr;
	$('#exportAutoStc').jsonSubmit({
		action:_url,
		paramObj:obj,
		callback:function(rval){}
	});
}

function fnGetUrlParams (obj) {
	var returnStr = "";
	for (key in obj) {
		returnStr += "&"+key+"="+obj[key];
	}
	return returnStr;
}

/**
 * 根据统计类型生成默认的控件
 * @param type
 * @returns {String}
 */
function getDateQueryHtml (type) {
	var dateValue = fnsetDefaultValue(type);
	var startDate = dateValue.get('start');
	var endDate = dateValue.get('end');
	var dateHtml = "";
	if (type == 'byYear') {
		dateHtml += "<td width='42%'>";
		dateHtml +='<select id="start_time" class="w100b font_size12">';
		dateHtml += fnGetOption(startDate + 1);
		dateHtml +='</select>';
		dateHtml +='</td>';
		dateHtml += "<td width='5%' align='center'>-</td>";
		dateHtml += "<td width='42%'>";
		dateHtml +='<select id="end_time" class="w100b font_size12">';
		dateHtml += fnGetOption(endDate);
		dateHtml +='</select>';
		dateHtml +="</td>";
	} else if (type == 'byMounth') {
		dateHtml += "<td>";
		dateHtml += "<div class='common_txtbox_wrap '>";
		dateHtml += '<input id="start_time" readonly="readonly" value="'+startDate+'" type="text" style="width:98%;" class="comp mycal"  validate="notNull:true"  width="60" comp="cache:false,type:\'calendar\',ifFormat:\'%Y-%m\'"/>';
		dateHtml += "</div>";
		dateHtml += "</td>";
		dateHtml += "<td align='center'>-</td>";
		dateHtml += "<td><div class='common_txtbox_wrap '>";
		dateHtml +="<input id='end_time' readonly='readonly' value='"+endDate+"' type='text' style='width:98%' class='comp mycal'  validate='notNull:true'  width='60' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m\"'/>";
		dateHtml +="</div></td>";
	} else {
		dateHtml += "<td>";
		dateHtml += "<div class='common_txtbox_wrap'>";
		dateHtml += '<input id="start_time" readonly="readonly" value="'+startDate+'" style="width:98%;" type="text" class="comp mycal"  validate="notNull:true"  width="60" comp="cache:false,type:\'calendar\',ifFormat:\'%Y-%m-%d\'"/>';
		dateHtml += "</div>";
		dateHtml += "</td>";
		dateHtml += "<td align='center'>-</td>";
		dateHtml += "<td><div class='common_txtbox_wrap '>";
		dateHtml +="<input id='end_time' readonly='readonly' value='"+endDate+"' type='text' style='width:98%' class='comp mycal'  validate='notNull:true'  width='60' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/>";
		dateHtml +="</div></td>";
	}
	return dateHtml;
}


function fnGetOption (selectedCheck) {
	var optionHtml = "";
	for (var i = 2010; i <= 2030 ; i ++) {
		if (selectedCheck == i) {
			optionHtml +="<option value='"+i+"' selected='selected'><span class='margin_l_r_10'>&nbsp;&nbsp;&nbsp;&nbsp;"+i+"&nbsp;&nbsp;&nbsp;&nbsp;</span></option>";
		} else {
			optionHtml +="<option value='"+i+"'><span class='margin_l_r_10'>&nbsp;&nbsp;&nbsp;&nbsp;"+i+"&nbsp;&nbsp;&nbsp;&nbsp;</span></option>";
		}
	}
	return optionHtml;
}

function fnShowConn (_type) {
	var queryType = '';
	if (_type == '0') {
		queryType = 'other';
	} else if (_type == '1') {
		queryType = 'byMounth';
	} else {
		queryType = 'byYear';
	}
	$('#dateContions').html(getDateQueryHtml(queryType));
	$(".mycal").each(function(){$(this).compThis();});
}


function fnDownExcel () {
	var obj = fnGetParams();
	var _url = _path+"/office/stockStc.do?method=expStockInfoStc&option="+stockParam.option
	$('#exportAutoStc').jsonSubmit({
		action:_url,
		paramObj:obj,
		callback:function(rval){}
	});
}

/**
 * 重置
 */
function resetResult () {
	//还原查询类型
	var countType= $('input:radio[name="countType"]').each(function (){
		if ($(this).val() == '0') {
			$(this).attr('checked','checked');
		}
	});
	var queryType= $('input:radio[name="queryType"]').each(function (){
		if ($(this).val() == '0') {
			$(this).attr('checked','checked');
		}
	});
	//清空所有input 
	var input= $('input:text').each(function (){
		$(this).val('');
	});
	var input= $('input:hidden').each(function (){
		$(this).val('');
	});
	//设置默认值
	fnShowConn(0);
	$('#bookHouse').val('');
	$('#bookCategory').val('');
}

function fnTdCollBack (colms,_index,data) {
	var returnValue = "";
	var countType = $('input:radio[name="countType"]:checked').val();
	var startTime = "";
	var endTime = "";
	if( countType == '0'){
		startTime = $('#start_time').val()+' 00:00:00';
		endTime = $('#end_time').val()+' 23:59:59';
	}
	if( countType == '1'){
		var startYear = parseInt(queryStartTime.split('-')[0],10);
		var startMounth = parseInt(queryStartTime.split('-')[1],10);
		var mounth = startMounth + _index;
		if (mounth > 12) {
			startYear = startYear + parseInt(mounth/12,10);
			startMounth = mounth - (12*parseInt(mounth/12,10));
		} else {
			startMounth = mounth;
		}
		startTime = startYear + '-'+ startMounth + '-01 00:00:00';
		endTime = startYear + '-'+ startMounth + '-31 23:59:59';
	}
	if( countType == '2'){
		startTime = parseInt(queryStartTime,10)+_index+'-01-01 00:00:00';
		endTime = parseInt(queryStartTime,10)+_index+'-12-31 23:59:59';
	}
	if (stockParam.option != 'findStockInfoStc') {
		if (colms == 'applyTole') {
			var applyTole = data.applyTole.split(',')[_index];
			if(isNaN(applyTole)==false){
				applyTole = parseFloat(applyTole).toFixed(1);
			}
			if(applyTole==='undefined'){
				applyTole = '0.0';
			}
			returnValue = applyTole;
			if (returnValue != '0' && returnValue != '0.00' && returnValue != '0.0') {
				var type = queryType;
				var params = {
						'index':_index,
						'data':data,
						'startTime':startTime,
						'endTime':endTime,
						'type':type
				}
				returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+applyTole+"</a>";
			}
		}
	}
	return returnValue;
}


/**
 * 打开数据
 * @param _index
 * @param data
 * @param type
 */
function openData (_params) {
	var obj = new Object();
	obj.queryType = queryType;
	obj.params = _params;
	var dialog = $.dialog({
	    id: 'showData',
	    url: _path+"/office/stockStc.do?method=stockStcInfoShow",
	    width: 1000,
	    height: 600,
	    transParams:obj,
	    title: $.i18n('office.auto.autoStcInfo.ckmx.js')
	});
}

function checkTypeSelect (obj) {
	var stockHoseId = -1;
	if (obj.value != '') {
		stockHoseId = obj.value;
	}
	var ajaxM = new stockUseManager();
	ajaxM.findStockTypeEnum(stockHoseId,{
		success:function(rval){
			fnShowSelect(rval);
		}
	});
}

function fnShowSelect (datas) {
	$('#bookCategory option').remove();
	$('#bookCategory').prepend('<option value="" ></option>'); 
	for (var i = 0 ; i < datas.length ; i ++) {
    	var bookCategory = datas[i];
    	$('#bookCategory').append('<option value="'+bookCategory.value+'">'+bookCategory.text+'</option>');
	}
}

$(document).live('keydown',function(event) {
	if (event.keyCode == 13) {
		executeStatistics();
	}
});