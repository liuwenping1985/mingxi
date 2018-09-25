var layout;
var queryType = "";
var assetTyps = "";
var noAssetType = "";
var assetTypeMap = new Properties();
$(document).ready(function () {
	layout = $('#layout').layout();
	assetTyps = $.parseJSON(jsonParams.assetTypes);
	flowOverTimeStatisticsByMember();
 });

$(function (){
	executeStatistics();
});

function flowOverTimeStatisticsByMember () {
	var dateValue = fnsetDefaultValue("other");
	var startDate = dateValue.get('start');
	var endDate = dateValue.get('end');
	var hh = "";
	hh += "<div class='form_area set_search'>";
	hh += '<table id="stockUseTab" class="w90b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout: fixed;margin-left:0px;">';
    hh += '<tr>';
    hh += '<th width="10%" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.book.bookStcInfo.tjd.js')+':</label></th>';
    hh += '<td align="left" width="12%">';
    hh +="<div class='driver_radio_peopleType  clearfix align_left'>";
    hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
    hh +="<input id='countType'  class='radio_com' value='0' type='radio' onclick='clearInput()' checked='checked' name='countType'/>";
    hh +="<span class='margin_l_5'>"+$.i18n('office.auto.autoStcInfo.bm.js')+"</span>";
    hh +="</label>";
    hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
    hh +="<input id='countType'  class='radio_com' value='1' type='radio' onclick='clearInput()' name='countType'/>";
    hh +="<span class='margin_l_5'>"+$.i18n('office.auto.bookStcInfo.ry.js')+"</span>";
    hh +="</label></div>";
    hh += '</td>';
    hh += '<td width="18%" align="left">';
    hh += '<div class="common_txtbox_wrap">';
    hh += '<input id="entityName" class="font_size12" maxlength="80" onclick="fnSelectEntity()" type="text"><input type="hidden" id="entityId" value="">';
    hh += '</div>';
    hh += '</td>';
    hh += '<td width="50%">';
    hh += '</td>';
    hh += '</tr>';
    hh += '<tr>';
    hh += '<th noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.asset.selectAsset.sbfl.js')+':</label></th>';
    hh += '<td colspan="2">';
    hh += fnGetAssetType();
    hh += '</td>';
    hh += '</td>';
    hh += '<td width="50%">';
    hh += '</td>';
    hh += '</tr>';
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

function fnGetAssetType () {
	assetTypeMap = new Properties();
	var hh = "";
	for (var i = 0 ; i < assetTyps.length ; i++) {
		assetTypeMap.put("x"+assetTyps[i].value+"type",assetTyps[i].value);
		var margin = "";
		margin = "class='margin_r_10 margin_t_5'";
		hh += "<label  for='Checkbox5' "+margin+"><input type='checkbox'  id='assetType' checked='checked' name='assetType' value='"+assetTyps[i].value+"'/>"+assetTyps[i].text+"</label>"
	}
	return hh;
}


/**
 * 执行统计方法
 */
function executeStatistics () {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'assetStcManager',
	      managerMethod : 'findAssetInfoStc',
	      callback : function(fpi) {
	         showGrid(fpi.data);
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
	$('#queryTitle').html($.i18n('office.asset.assetInfoStc.bgsbtj.js'));
	$('#countDate').html($.i18n('office.book.bookStcInfo.tjrq.js')+':' + new Date().format('yyyy-MM-dd'));
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

function fnCreateTh () {
	var ItemArray = getThItemArrayByCars('values');
	return fnSetTh(ItemArray);
}

function funCreateTd (datas) {
	var itemArray = getThItemArrayByCars('alls');
	if (queryType == 'member') {
		var deptDataMap = fnCreateMapByDept(datas,'departMentId');
		itemArray.remove("departMentName");
		return fnSetDateStyeTow(deptDataMap,itemArray.keys(),'departMentName');
	} else {
		return fnSetData(itemArray.keys(),datas);
	}
}


/**
 * 获取普通查询列表头
 * @param type
 * @param _option
 * @returns
 */
function getThItemArrayByCars(type) {
	var itemMap = new Properties();
	if (queryType == "member") {
		itemMap.put('departMentName',$.i18n('office.asset.assetStcInfoShow.sybm.js'));
		itemMap.put('memberName',$.i18n('office.asset.assetUse.syr.js'));
	} else {
		itemMap.put('departMentName',$.i18n('office.asset.assetStcInfoShow.sybm.js'));
	}
	for (var i = 0 ; i < assetTyps.length ; i ++) {
		var key = "x" + assetTyps[i].value +"type";
		itemMap.put(key,assetTyps[i].text);
	}
	var noAsset = noAssetType.split(",");
	for (var j = 0 ; j < noAsset.length ; j ++) {
		itemMap.remove(noAsset[j]);
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
	var assetType = "";
	noAssetType = "";
	var typeLength = $('input:checkbox[name="assetType"]:checked').length;
	var entityId = $('#entityId').val();
	if (typeLength <= 0) {
		$.alert($.i18n('office.asset.assetInfoStc.bxxzyxsblx.js'));
		return null;
	}
	var faces = $('input:checkbox[name="assetType"]').each(function (){
		if ($(this).attr('checked') == 'checked') {
			assetType = assetType + $(this).val()+",";
		} else {
			noAssetType = noAssetType + "x"+$(this).val()+"type,";
		}
	});
	if (assetType != '' && assetType.length > 1) {
		object.assetTypes = assetType.substr(0,assetType.length -1);
	}
	var countType = $('input:radio[name="countType"]:checked').val();
	if (countType && countType != '') {
		if (countType == '0') {
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
	return object;
}

function clearInput () {
	 $('#entityName').val('');
	 $('#entityId').val('');
}

function fnSelectEntity () {
	var countType = $('input:radio[name="countType"]:checked').val();
	var selectType = 'Member';
	var panels = 'Department';
	if (countType == '0') {
		selectType = 'Department';
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
	    minSize:0,
	    showOriginalElement:true,
	    panels:panels
	});
}

function fnTdCollBack (colms,_index,data) {
	var returnValue = "";
	if (colms.indexOf('type') > -1) {
		if (data.assetCount == ""){
			return "0";
		}
		var assetCount =  $.parseJSON(data.assetCount);
		if (assetCount.length > 0) {
			returnValue = assetCount[0][colms];
			if (returnValue != '0') {
				var type = assetTypeMap.get(colms);
				var params = {
						'index':_index,
						'data':data,
						'type':type
				}
				returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+assetCount[0][colms]+"</a>";
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
	    url: _path+"/office/assetStc.do?method=assetStcInfoShow",
	    width: 1000,
	    height: 600,
	    transParams:obj,
	    title: $.i18n('office.auto.autoStcInfo.ckmx.js')
	});
}


function fnDownExcel () {
	var obj = fnGetParams();
	var _url = _path+"/office/assetStc.do?method=expExcel";
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
 * 重置
 */
function resetResult () {
	var assetType = $('input:checkbox[name="assetType"]').each(function (){
		$(this).attr('checked','checked');
	});
	var queryType= $('input:radio[name="countType"]').each(function (){
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
}


$(document).live('keydown',function(event) {
	if (event.keyCode == 13) {
		executeStatistics();
	}
});
