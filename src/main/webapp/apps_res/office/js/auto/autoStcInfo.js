var layout;
var queryCountType;
var queryStartTime;
var queryEndTime;
var noCheckedFace;
$(document).ready(function () {
	layout = $('#layout').layout();
	flowOverTimeStatistics(pTemp._option);
 });
$(function() {
	executeStatistics();
});

function flowOverTimeStatistics(_option){
	var showThStr = $.i18n('office.auto.autoStcInfo.xzcl.js');
	if (_option == 'findByDriver') {
		showThStr = $.i18n('office.auto.autoStcInfo.xzjsy.js');
	} else if (_option == 'findByMember') {
		showThStr = $.i18n('office.auto.autoStcInfo.xzry.js');
	} else if (_option == 'findByDept') {
		showThStr = $.i18n('office.auto.autoStcInfo.xzbm.js');
	}
    var hh = "<div class='form_area set_search w100b' style='text-align: left;'>";
    hh += "<table border=0 cellpadding=0 cellspacing=0 class='common_center w80b' style='margin-left:0px;'>";
    hh += "<tbody>";
    hh += "<tr>";
    if (_option == 'findByMember') { 
    	if (pTemp.isCarsAdmin =="true") {
    		 hh += getTh(showThStr);
             hh +="<td align='left' style='width:30%'> <div id='userDiv' class='common_txtbox_wrap'>";
             if (_option == 'findByDriver') {
             	hh +="<input readOnly='true' id='driverName' type='text' onclick='fnSelectCarOrDriverMember(0)'/><input type='hidden' id='driverId'/>";
             } else if (_option == 'findByMember') {
             	hh +="<input type='text' id='memberName' name='memberName' onclick='fnSelectMember()'/><input type='hidden' id='memberId'/>";
             } else if (_option == 'findByDept') {
             	hh +="<input type='text' id='deptName' name='deptName' onclick='fnSelectDept()'/><input type='hidden' id='deptId'/>";
             } else {
             	hh +="<input readOnly='true' id='autoInfoNumber' type='text' onclick='fnSelectCarOrDriverMember(1)'/><input type='hidden' id='autoInfoId'/>";
             }
             hh +="</div>";
             hh +="</td>";
    	} else {
    		hh +="<th></th><td></td>";
    	}
    } else {
    	 hh += getTh(showThStr);
         hh +="<td align='left' style='width:30%'> <div id='userDiv' class='common_txtbox_wrap'>";
         if (_option == 'findByDriver') {
         	hh +="<input readOnly='true' id='driverName' type='text' onclick='fnSelectCarOrDriverMember(0)'/><input type='hidden' id='driverId'/>";
         } else if (_option == 'findByMember') {
         	hh +="<input readOnly='true' id='driverName' type='text' onclick='fnSelectCarOrDriverMember(0)'/><input type='hidden' id='driverId'/>";
         } else if (_option == 'findByDept') {
         	hh +="<input type='text' id='deptName' name='deptName' onclick='fnSelectDept()'/><input type='hidden' id='deptId'/>";
         } else {
         	hh +="<input readOnly='true' id='autoInfoNumber' type='text' onclick='fnSelectCarOrDriverMember(1)'/><input type='hidden' id='autoInfoId'/>";
         }
         hh +="</div>";
         hh +="</td>";
    }
    hh +="<td style='width:25%'  align='left'>";
    if (_option != 'findByDriver') {
    	hh +="<a class='margin_l_10' onclick='fnDispalyfacess()'>["+$.i18n('office.auto.autoStcInfo.gjxx.js')+"]</a>";
    }
    hh +="</td>";
    hh += "</tr>";
    hh += "<tr>";
    hh += getTh($.i18n('office.auto.autoStcInfo.bblx.js'));
    hh +="<td align='left' style='width:30%'>";
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
    hh +="<td style='width:30%'>";
    hh +="</td>";
    hh += "</tr>";
    hh += "<tr>";
    hh += getTh($.i18n('office.auto.autoStcInfo.sj.js'));
    hh += "<td colspan='2' align='left'>";
    hh +="<table width='50%'>";
    hh +="<tr id='dateContions'>";
    hh +=getDateQueryHtml('other');
    hh +="</tr>"
    hh +="</table></td>"
    hh += "</tr>";
    hh += "<tr id='facess' style='visibility:hidden;'>";
    hh += getTh($.i18n('office.auto.autoStcInfo.fy.js'));
    hh +="<td align='left' colspan='2' class='margin_t_5' id='stcFace'>";
    hh += fnGetFaceOptions(_option);
    hh +="</td>";
    hh += "</tr>";
    hh += "</tbody>";
    hh += "</table>";
    hh += "</div>";
    hh += fuGetButton();
    $("#tabs #queryCondition").html(hh);
    $(".mycal").each(function(){$(this).compThis();});
}

function getTh(name) {
    if(name && name.length < 4){
        return "<th nowrap='nowrap' style='width:15%'><label class='margin_r_10 th_name'  for='text'>&nbsp;&nbsp;&nbsp;&nbsp;" + name + ":</label></th>";
    }
    return "<th nowrap='nowrap' style='width:15%'><label class='margin_r_10 th_name'  for='text'>" + name + ":</label></th>";
}
function fnGetFaceOptions (option) {
	var _html = "";
	if (option == 'find') {
		_html +="<label  for='Checkbox5'><input type='checkbox' class='margin_r_5' id='faces' name='faces' value='costs'/>"+$.i18n('office.auto.autoStcInfo.yf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10 margin_r_5' checked='checked' type='checkbox' id='faces' name='faces' value='cardFee'/>"+$.i18n('office.auto.autoStcInfo.jykjyf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10 margin_r_5' checked='checked' type='checkbox' id='faces' name='faces' value='cashFee'/>"+$.i18n('office.auto.autoStcInfo.xjjyf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10 margin_r_5' checked='checked' type='checkbox' id='faces' name='faces' value='roadPrice'/>"+$.i18n('office.auto.autoStcInfo.glgqf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10 margin_r_5' checked='checked' type='checkbox' id='faces' name='faces' value='washesFee'/>"+$.i18n('office.auto.autoStcInfo.xcf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10 margin_r_5' checked='checked' type='checkbox' id='faces' name='faces' value='parkingFee'/>"+$.i18n('office.auto.autoStcInfo.tcf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10 margin_r_5' checked='checked' type='checkbox' id='faces' name='faces' value='otherFee'/>"+$.i18n('office.auto.autoStcInfo.qsfy.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class=' margin_l_10 margin_r_5' type='checkbox' id='faces' name='faces' value='repairFee'/>"+$.i18n('office.auto.autoStcInfo.wxfy.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class=' margin_l_10 margin_r_5' type='checkbox' id='faces' name='faces' value='insureAmount'/>"+$.i18n('office.auto.autoStcInfo.bxf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class=' margin_l_10 margin_r_5' type='checkbox' id='faces' name='faces' value='inspectionFee'/>"+$.i18n('office.auto.autoStcInfo.njf.js')+"</label>";
	} else {
		_html +="<label  for='Checkbox5'><input type='checkbox' id='faces' name='faces' checked='checked' value='costs'/>"+$.i18n('office.auto.autoStcInfo.yf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10' type='checkbox' id='faces' name='faces' value='cardFee'/>"+$.i18n('office.auto.autoStcInfo.jykjyf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10' type='checkbox' id='faces' name='faces' value='cashFee'/>"+$.i18n('office.auto.autoStcInfo.xjjyf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10' checked='checked' type='checkbox' id='faces' name='faces' value='roadPrice'/>"+$.i18n('office.auto.autoStcInfo.glgqf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10' type='checkbox' id='faces' name='faces' value='washesFee'/>"+$.i18n('office.auto.autoStcInfo.xcf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10' checked='checked' type='checkbox' id='faces' name='faces' value='parkingFee'/>"+$.i18n('office.auto.autoStcInfo.tcf.js')+"</label>";
		_html +="<label  for='Checkbox5'><input class='margin_l_10' checked='checked' type='checkbox' id='faces' name='faces' value='otherFee'/>"+$.i18n('office.auto.autoStcInfo.qsfy.js')+"</label>";
	}
	return _html;
}

function fnDispalyfacess () {
	var disStyle = $('#facess').attr('style');
	if (disStyle && disStyle != '') {
		$('#facess').attr('style','');
	} else {
		$('#facess').attr('style','visibility:hidden;');
	}
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

function showGrid (valueData,_option) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>";
	tableHtml += fnCreateTh(_option);
    tableHtml += "<tbody>";
    tableHtml += funCreateTd(valueData,_option);
    tableHtml += "</tbody>";
    tableHtml += "</table>";
    $('#queryResult').html(tableHtml);
}

/**
 * 交叉统计表格
 * @param valueData
 */
function showGroupGrid (valueData,_option) {
	var tableHtml = "";
	tableHtml += "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>";
	tableHtml += fnShowThByGroup(_option);
    tableHtml += "<tbody>";
    tableHtml += funCreateTdByGroup(valueData,_option);
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
	var thItemArray = getGroupThItemArrayByCars('values',_option);
	var style = _option == 'findByMember' ? 'style2' : 'style1';
	return fnCreateThByGoup(thItemArray, forLength, style)
}

function fnCreateTh (_option) {
	var ItemArray = getThItemArrayByCars('alls',_option);
	if (noCheckedFace != '') {
		var noCheckItem = noCheckedFace.split(',');
		for (var i = 0 ; i < noCheckItem.length ; i ++) {
			ItemArray.remove(noCheckItem[i]);
		}
	}
	var thItemArray = ItemArray.values();
	return fnSetTh(thItemArray);
}


/**
 * 普通查询生成数据列
 * @param datas
 * @param _option
 * @returns {String}
 */
function funCreateTd (datas,_option) {
	var itemArray = getThItemArrayByCars('alls',_option);
	if (noCheckedFace != '') {
		var noCheckItem = noCheckedFace.split(',');
		for (var i = 0 ; i < noCheckItem.length ; i ++) {
			itemArray.remove(noCheckItem[i]);
		}
	}
	if (_option == 'findByMember') {
		itemArray.remove("departMentName");
	}
	var tdItemArray = itemArray.keys();
	var tdHtml ="";
	if (_option != 'findByMember') {
		tdHtml += fnSetData(tdItemArray,datas);
	} else {
		tdHtml += fnSetDataByMember(tdItemArray,datas);
	}
	return tdHtml;
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
	var itemArrayMap = getGroupThItemArrayByCars('alls',_option);
	if (_option == 'findByMember') {
		itemArrayMap.remove('departMentName');
	}
	var itemArray = itemArrayMap.keys();
	var tdHtml ="";
	if (_option != 'findByMember') {
		if (_option == 'findByDriver') {
			tdHtml += fnSetDateByGroup(datas, forLength, itemArray, "driverName");
		} else if (_option == 'findByDept') {
			tdHtml += fnSetDateByGroup(datas, forLength, itemArray, "departMentName");
		} else {
			tdHtml += fnSetDateByGroup(datas, forLength, itemArray, "autoNum");
		}
	} else {
		tdHtml += fnSetDataByMemberGroup(forLength,itemArray,datas);
	}
	return tdHtml;
}

function fuGetButton() {
    return "<div class='align_center margin_t_10 clear padding_lr_5 padding_b_5' id='button_div'>" + 
    "<a href='javascript:void(0)' class='common_button common_button_emphasize margin_r_10' id='querySave' onclick='executeStatistics()'>"+$.i18n('office.auto.autoStcinfo.tj.js')+"</a>" +
    "<a id='queryReset' class='common_button common_button_gray margin_r_10' href='javascript:void(0)' onclick='resetResult()'>"+$.i18n('office.auto.autoStcinfo.cz.js')+"</a>"+"</div>";
}

/**
 * 执行统计方法
 */
function executeStatistics () {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'autoStcInfoManager',
	      managerMethod : pTemp._option,
	      callback : function(fpi) {
	    	 if (queryCountType == '0') {
	    		 showGrid(fpi.data,pTemp._option);
	    	 } else {
	    		 showGroupGrid(fpi.data,pTemp._option);
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
		if (pTemp._option != 'findByDriver') {
			showFaces(obj.showFaces);
		}
	}
	$('#countDate').html($.i18n('office.auto.autoStcInfo.tjrq.js') + new Date().format('yyyy-MM-dd'))
	if (pTemp._option == 'findByMember') {
		$('#queryTitle').html($.i18n('office.auto.autoStcInfo.gryctj.js'));
	} else if (pTemp._option == 'findByDriver') {
		$('#queryTitle').html($.i18n('office.auto.autoStcInfo.jsyxstj.js'));
	} else if (pTemp._option == 'findByDept') {
		$('#queryTitle').html($.i18n('office.auto.autoStcInfo.bmyctj.js'));
	} else {
		$('#queryTitle').html($.i18n('office.auto.autoStcInfo.clsyqktj.js'));
	}
	var timeLength = "";
	if ($('#start_time').val() != '' && $('#end_time').val() != '') {
		timeLength  = $('#start_time').val() + "--" +  $('#end_time').val();
	}
	if ($('#start_time').val() == '' && $('#end_time').val() != '') {
		timeLength  = $('#end_time').val() + $.i18n('office.auto.autoStcInfo.yq.js');
	}
	if ($('#end_time').val() == '' && $('#start_time').val() != '') {
		timeLength  = $('#start_time').val() +"--" + $.i18n('office.auto.autoStcInfo.zj.js');
	}
	if ($('#contFace').html() == "" || pTemp._option == 'findByDriver') {
		$('#contFace').html($.i18n('office.auto.autoStcInfo.sj.js') + ":" + timeLength);
		$('#quertTime').html("");
	} else {
		$('#quertTime').html($.i18n('office.auto.autoStcInfo.sj.js') +  ":" + timeLength);
	}
}

/***
 * 显示选择的查询金额类型
 * @param showFaces
 */
function showFaces(showFaces) {
	var allItems = getThItemArrayByCars('alls','find');
	var feces = showFaces.split(',');
	var keysStr = $.i18n('office.auto.autoStcInfo.fy.js') + ':';
	var keyLength = 0;
	for (var i = 0 ; i < feces.length ; i ++) {
		if (allItems.get(feces[i]) != null && typeof(allItems.get(feces[i])) != 'undefined') {
			keyLength ++;
			keysStr += allItems.get(feces[i]) + "、";
		}
	}
	if (keyLength > 0) {
		$('#contFace').html(keysStr.substr(0,keysStr.length-1));
	} else {
		$('#contFace').html("");
	}
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
	//清空所有input 
	var input= $('input[type=text]').each(function (){
		$(this).attr('value','');
	});
	var input= $('input[type=hidden]').each(function (){
		$(this).val('');
	});
	$('#stcFace').html(fnGetFaceOptions(pTemp._option));
	//设置默认值
	fnShowConn(0);
}

/**
 * 获取参数内容
 * @returns
 */
function fnGetParams () {
	var noFacesStr = '';
	var obj = new Object();
	var facesStr = '';
	var faces = $('input:checkbox[name="faces"]').each(function (){
		if ($(this).attr('checked') == 'checked') {
			facesStr = facesStr + $(this).val()+",";
		} else {
			noFacesStr = noFacesStr + $(this).val()+",";
		}
	});
	noCheckedFace = noFacesStr;
	obj.showFaces = facesStr;
	var countType= $('input:radio[name="countType"]:checked').val();
	var startTime = $('#start_time').val();
	var endTime = $('#end_time').val();
	var autoInfoId = $('#autoInfoId').val();
	var driverId = $('#driverId').val();
	var deptId = $('#deptId').val();
	var memberId = $('#memberId').val();
	queryCountType = countType;
	queryStartTime = startTime;
	queryEndTime = endTime;
	if (countType == '0') {
		if (fnDateParse(endTime) < fnDateParse(startTime)) {
			$.alert($.i18n('office.auto.autoStcInfo.ksrqbndydqjsrq.js'));
			return null;
		}
		if (startTime != '') {
			obj.startTime = startTime+' 00:00:00';
		}
		if (endTime != '') {
			obj.endTime = endTime+' 23:59:59';
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
		obj.startTime = startTime;
		obj.endTime = endTime;
	} else {
		
		if (parseInt(endTime,10) > new Date().getFullYear()) {
			$.alert($.i18n('office.auto.autoStcInfo.date2.js'));
			return null;
		}
		if (parseInt(startTime,10) > parseInt(endTime,10)) {
			$.alert($.i18n('office.auto.autoStcInfo.ksrqbndydqjsrq.js'));
			return null;
		}
		if (parseInt(endTime,10) - parseInt(startTime,10) > 11) {
			$.alert($.i18n('office.auto.autoStcInfo.qjzd.js'));
			return null;
		}
		obj.startTime = startTime;
		obj.endTime = endTime;
	}
	obj.countType = countType;
	if (autoInfoId != '' && typeof(autoInfoId) != "undefined") {
		obj.autoInfoId = autoInfoId;
	}
	if (driverId != '' && typeof(driverId) != "undefined") {
		obj.driverId = driverId;
	}
	if (deptId != '' && typeof(deptId) != "undefined") {
		obj.deptId = deptId;
	}
	if (memberId != '' && typeof(memberId) != "undefined") {
		obj.memberId = memberId;
	}
	return obj;
}

function fnSelectCarOrDriverMember (_type) {
	var ids = $('#autoInfoId').val();
	var optType = 'autoChecked';
	if (_type == '0') {
		ids = $('#driverId').val();
		optType = 'driverChecked';
	}
	fnSelectPeoplePub({type:optType,value:ids});
}

function fnSelectPeople(retval){
	if (retval.okParam) {
		var ids = "";
		var names = "";
		if (retval.type == 'autoChecked') {
			for (var i = 0 ; i < retval.okParam.length ; i ++) {
				ids = ids + retval.okParam[i].id +",";
				names = names + retval.okParam[i].autoNum+"、"
			}
			if (ids != '' && ids.length > 1) {
				ids = ids.substr(0,ids.length -1);
			}
			if (names != '' && names.length > 1) {
				names = names.substr(0,names.length -1);
			}
			$('#autoInfoId').val(ids);
			$('#autoInfoNumber').val(names);
		} else {
			for (var i = 0 ; i < retval.okParam.length ; i ++) {
				ids = ids + retval.okParam[i].id +",";
				names = names + retval.okParam[i].memberName+"、"
			}
			if (ids != '' && ids.length > 1) {
				ids = ids.substr(0,ids.length -1);
			}
			if (names != '' && names.length > 1) {
				names = names.substr(0,names.length -1);
			}
			$('#driverId').val(ids);
			$('#driverName').val(names);
		}
	}
	if (retval.dialog) {
		retval.dialog.close();
	}
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
		dateHtml += fnGetOption(startDate);
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
		dateHtml += "<div class='common_txtbox_wrap'>";
		dateHtml += '<input id="start_time" readonly="readonly" value="'+startDate+'" type="text" style="width:98%" class="comp mycal"  validate="notNull:true"  width="60" comp="cache:false,type:\'calendar\',ifFormat:\'%Y-%m\'"/>';
		dateHtml += "</div>";
		dateHtml += "</td>";
		dateHtml += "<td align='center'>-</td>";
		dateHtml += "<td><div class='common_txtbox_wrap'>";
		dateHtml +="<input id='end_time' readonly='readonly' value='"+endDate+"' type='text' style='width:98%' class='comp mycal'  validate='notNull:true'  width='60' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m\"'/>";
		dateHtml +="</div></td>";
	} else {
		dateHtml += "<td>";
		dateHtml += "<div class='common_txtbox_wrap'>";
		dateHtml += '<input id="start_time" readonly="readonly" value="'+startDate+'" type="text" style="width:98%;" class="comp mycal"  validate="notNull:true"  width="60" comp="cache:false,type:\'calendar\',ifFormat:\'%Y-%m-%d\'"/>';
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

function fnDateParse(dateStr) {
	dateStr = dateStr.replace(/-/g,"/");
	return new Date(dateStr);
}


/**
 * 渲染列
 * @param colms
 * @param _index
 * @param data
 * @returns {String}
 */
function fnTdCollBack (colms,_index,data) {
	var returnValue = "";
	if (colms == 'applyNum') {
		var applyNum = data.applyNum.split(',')[_index];
		returnValue = applyNum;
		if (applyNum != '0') {
			var type = "applyNum";
			var params = {
					'index':_index,
					'data':data,
					'type':type
			}
			returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+applyNum+"</a>";
		}
	}
	if (colms == 'repairNum') {
		var repairNum = data.repairNum.split(',')[_index];
		returnValue = repairNum;
		if (repairNum != '0') {
			var type = "repairNum";
			var params = {
					'index':_index,
					'data':data,
					'type':type
			}
			returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+repairNum+"</a>";
		}
	}
	if (colms == 'illegalNum') {
		var illegalNum = data.illegalNum.split(',')[_index];
		returnValue = illegalNum;
		if (illegalNum != '0') {
			var type = "illegalNum";
			var params = {
					'index':_index,
					'data':data,
					'type':type
			}
			returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+illegalNum+"</a>";
		}
	}
	if (colms == 'illegalFlagNum') {
		var illegalFlagNum = data.illegalFlagNum.split(',')[_index];
		returnValue = illegalFlagNum;
		if (illegalFlagNum != '0') {
			var type = "illegalFlagNum";
			var params = {
					'index':_index,
					'data':data,
					'type':type
			}
			returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+illegalFlagNum+"</a>";
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
	var obj = fnGetParams();
	obj.option = pTemp._option;
	obj.params = _params;
	var dialog = $.dialog({
	    id: 'showData',
	    url: _path+"/office/autoStc.do?method=autoStcInfoShow",
	    width: 1000,
	    height: 600,
	    transParams:obj,
	    title: $.i18n('office.auto.autoStcInfo.ckmx.js')
	});
}

function fnSetDataByMember (tdItemArray,datas) {
	var deptDataMap = fnCreateMapByDept(datas,'departMentId');
	return fnSetDateStyeTow(deptDataMap,tdItemArray,'departMentName');
}

function fnSetDataByMemberGroup(forLength,itemArray,datas) {
	var dataMap = fnCreateMapByDept(datas,'departMentId');
	return fnSetDataGorupStyleTow(forLength,itemArray,dataMap,'departMentName','memberName');
}

/**
 * 获取普通查询列表头
 * @param type
 * @param _option
 * @returns
 */
function getThItemArrayByCars(type,_option) {
	var itemMap = new Properties();
	if (_option == 'find') {
		itemMap.put('autoNum',$.i18n('office.auto.autoStcInfo.cph.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('costs',$.i18n('office.auto.autoStcInfo.yf.js'));
		itemMap.put('cardFee',$.i18n('office.auto.autoStcInfo.jykjyf.js'));
		itemMap.put('cashFee',$.i18n('office.auto.autoStcInfo.xjjyf.js'));
		itemMap.put('roadPrice',$.i18n('office.auto.autoStcInfo.glgqf.js'));
		itemMap.put('washesFee',$.i18n('office.auto.autoStcInfo.xcf.js'));
		itemMap.put('parkingFee',$.i18n('office.auto.autoStcInfo.tcf.js'));
		itemMap.put('otherFee',$.i18n('office.auto.autoStcInfo.qsfy.js'));
		itemMap.put('repairFee',$.i18n('office.auto.autoStcInfo.wxfy.js'));
		itemMap.put('insureAmount',$.i18n('office.auto.autoStcInfo.bxf.js'));
		itemMap.put('inspectionFee',$.i18n('office.auto.autoStcInfo.njf.js'));
		itemMap.put('repairNum',$.i18n('office.auto.autoStcInfo.wxcs.js'));
		itemMap.put('allFee',$.i18n('office.auto.autoStcInfo.fyhj.js'));
	} else if (_option == 'findByDriver') {
		itemMap.put('driverName',$.i18n('office.auto.autoStcInfo.jsy.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('illegalNum',$.i18n('office.auto.autoStcInfo.wzcs.js'));
		itemMap.put('illegalFlagNum',$.i18n('office.auto.autoStcInfo.sgcs.js'));
	} else if (_option == 'findByDept') {
		itemMap.put('departMentName',$.i18n('office.auto.autoStcInfo.bm.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('costs',$.i18n('office.auto.autoStcInfo.yf.js'));
		itemMap.put('cardFee',$.i18n('office.auto.autoStcInfo.jykjyf.js'));
		itemMap.put('cashFee',$.i18n('office.auto.autoStcInfo.xjjyf.js'));
		itemMap.put('roadPrice',$.i18n('office.auto.autoStcInfo.glgqf.js'));
		itemMap.put('washesFee',$.i18n('office.auto.autoStcInfo.xcf.js'));
		itemMap.put('parkingFee',$.i18n('office.auto.autoStcInfo.tcf.js'));
		itemMap.put('otherFee',$.i18n('office.auto.autoStcInfo.qsfy.js'));
		itemMap.put('allFee',$.i18n('office.auto.autoStcInfo.fyhj.js'));
	} else {
		itemMap.put('departMentName',$.i18n('office.auto.autoStcInfo.bm.js'));
		itemMap.put('memberName',$.i18n('office.auto.autoStcInfo.ycr.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('costs',$.i18n('office.auto.autoStcInfo.yf.js'));
		itemMap.put('cardFee',$.i18n('office.auto.autoStcInfo.jykjyf.js'));
		itemMap.put('cashFee',$.i18n('office.auto.autoStcInfo.xjjyf.js'));
		itemMap.put('roadPrice',$.i18n('office.auto.autoStcInfo.glgqf.js'));
		itemMap.put('washesFee',$.i18n('office.auto.autoStcInfo.xcf.js'));
		itemMap.put('parkingFee',$.i18n('office.auto.autoStcInfo.tcf.js'));
		itemMap.put('otherFee',$.i18n('office.auto.autoStcInfo.qsfy.js'));
		itemMap.put('allFee',$.i18n('office.auto.autoStcInfo.fyhj.js'));
	}
	if (type == 'values') {
		return itemMap.values();
	} else if (type == 'keys'){
		return itemMap.keys();
	} else if (type == 'alls') {
		return itemMap;
	}
}

/**
 * 获取分组查询列表头
 * @param type
 * @param _option
 * @returns
 */
function getGroupThItemArrayByCars (type,_option) {
	var itemMap = new Properties();
	if (_option == 'find') {
		itemMap.put('autoNum',$.i18n('office.auto.autoStcInfo.cph.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('repairNum',$.i18n('office.auto.autoStcInfo.wxcs.js'));
		itemMap.put('allFee',$.i18n('office.auto.autoStcInfo.fyhj.js'));
	} else if (_option == 'findByDriver') {
		itemMap.put('driverName',$.i18n('office.auto.autoStcInfo.jsy.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('illegalNum',$.i18n('office.auto.autoStcInfo.wzcs.js'));
		itemMap.put('illegalFlagNum',$.i18n('office.auto.autoStcInfo.sgcs.js'));
	} else if (_option == 'findByDept') {
		itemMap.put('departMentName',$.i18n('office.auto.autoStcInfo.bm.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('allFee',$.i18n('office.auto.autoStcInfo.fyhj.js'));
	} else {
		itemMap.put('departMentName',$.i18n('office.auto.autoStcInfo.bm.js'));
		itemMap.put('memberName',$.i18n('office.auto.autoStcInfo.ycr.js'));
		itemMap.put('applyNum',$.i18n('office.auto.autoStcInfo.cccs.js'));
		itemMap.put('travelMileage',$.i18n('office.auto.autoStcInfo.xslc.js'));
		itemMap.put('allFee',$.i18n('office.auto.autoStcInfo.fyhj.js'));
	}
	if (type == 'values') {
		return itemMap.values();
	} else if (type == 'alls'){
		return itemMap;
	} else {
		return itemMap.keys();
	}
}

/**
 * 选择部门
 */
function fnSelectDept () {
	var showName = $('#deptName').val();
	var showId = $('#deptId').val();
	$.selectPeople({
	    params : {
	      text : showName,
	      value :showId
	    },
	    callback : function(ret) {
	    	if (ret) {
	    	   $('#deptId').val(ret.value);
	  	       $('#deptName').val(ret.text);
	    	}
	    },
	    selectType :'Department',
	    maxSize:1000,
	    minSize:0,
	    showOriginalElement:true,
	    panels:'Department'
	});
}

function fnSelectMember () {
	var showName = $('#memberName').val();
	var showId = $('#memberId').val();
	$.selectPeople({
	    params : {
	      text : showName,
	      value :showId
	    },
	    callback : function(ret) {
	    	if (ret) {
	    	   $('#memberId').val(ret.value);
	  	       $('#memberName').val(ret.text);
	    	}
	    },
	    selectType :'Member',
	    maxSize:1000,
	    minSize:0,
	    showOriginalElement:true,
	    panels:'Department'
	});
}

function fnDownExcel () {
	var obj = fnGetParams();
	var parmaStr = fnGetUrlParams(obj);
	var _url = _path+"/office/autoStc.do?method=exportAutoStc&option="+pTemp._option+parmaStr;
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

$(document).live('keydown',function(event) {
	if (event.keyCode == 13) {
		executeStatistics();
	}
});