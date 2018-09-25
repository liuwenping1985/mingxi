var layout;
var queryType = "";
$(document).ready(function () {
	layout = $('#layout').layout();
	var bookHouse = $.parseJSON(bookParams.bookHouse);
	var bookCategroy = $.parseJSON(bookParams.bookCategroy);
	var param = {
			'bookHouse' : bookHouse,
			'bookCategroy' : bookCategroy
	}
	if (bookParams.option == 'findByBook') {
		flowOverTimeStatistics(param);	
	} else {
		flowOverTimeStatisticsByMember();
	}
 });

$(function() {
	executeStatistics();
});

function flowOverTimeStatisticsByMember () {
	var isBooksAdmin = bookParams.isBooksAdmin;
	var disable = "disabled";
	var userName = $.ctx.CurrentUser.name;
	var userId = "Member|" + $.ctx.CurrentUser.id;
	var checkedByDept = "";
	var checkedByMember = "checked";
	if (isBooksAdmin && isBooksAdmin=='true') {
		disable = "";
		userName = "";
		userId = "";
		checkedByDept = "checked";
		checkedByMember = "";
	}
	var dateValue = fnsetDefaultValue("other");
	var startDate = dateValue.get('start');
	var endDate = dateValue.get('end');
	var hh = "";
	hh += "<div class='form_area set_search'>";
	hh += '<table id="stockUseTab" class="w90b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout: fixed;margin-left:0px;">';
    hh += '<tr>';
    hh += '<th width="10%" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.book.bookStcInfo.tjd.js')+':</label></th>';
    hh += '<td colspan="2" align="left" width="10%">';
    hh +="<div class='driver_radio_peopleType  clearfix align_left margin_l_5'>";
    hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
    hh +="<input id='countType' "+disable+"  class='radio_com' value='0' type='radio' onclick='clearInput()' "+checkedByDept+" name='countType'/>";
    hh +="<span class='margin_l_5'>"+$.i18n('office.auto.autoStcInfo.bm.js')+"</span>";
    hh +="</label>";
    hh +="<label class='margin_r_10 hand' for='isIncidentFlag'>";
    hh +="<input id='countType' "+disable+" class='radio_com' value='1' type='radio' onclick='clearInput()' "+checkedByMember+" name='countType'/>";
    hh +="<span class='margin_l_5'>"+$.i18n('office.auto.bookStcInfo.ry.js')+"</span>";
    hh +="</label></div>";
    hh += '</td>';
    hh += '<td colspan="2" width="20%">';
    hh += '<div class="common_txtbox_wrap">';
    hh += '<input id="entityName" '+disable+' class="font_size12" maxlength="80" onclick="fnSelectEntity()" type="text" value="'+userName+'"><input type="hidden" id="entityId" value="'+userId+'">';
    hh += '</div>';
    hh += '</td>';
    hh += '<td colspan="4" width="40%">';
    hh += '</td>';
    hh += '</tr>';
    hh += '<tr>';
    hh += '<th noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.auto.autoStcInfo.sj.js')+':</label></th>';
    hh += '<td colspan="8">';
    hh +="<table width='31%'>";
    hh +="<tr id='dateContions'>";
    hh +="<td width='15%'>";
    hh += '<div class="common_txtbox_wrap left">';
    hh += '<input id="start_time" value="'+startDate+'" readonly="readonly" style="width:98%;"  type="text" class="comp mycal"  validate="notNull:true"  width="100" comp="cache:false,type:\'calendar\',ifFormat:\'%Y-%m-%d\'"/>';
    hh += '</div>';
    hh +="</td>";
    hh += "<td align='center' width='1%'>-</td>";
    hh += "<td width='15%'>";
    hh += '<div class="common_txtbox_wrap left">';
    hh += '<input id="end_time" value="'+endDate+'" readonly="readonly"  style="width:98%;"  type="text" class="comp mycal"  validate="notNull:true"  width="100" comp="cache:false,type:\'calendar\',ifFormat:\'%Y-%m-%d\'"/>';
    hh += '</div>';
    hh += "</td>";
    hh +="</tr>";
    hh += "</table>";
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
	var hh = "";
	hh += "<div class='form_area set_search'>";
	hh += '<table id="stockUseTab" class="w90b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout: fixed;">';
    hh += '<tr>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.book.bookStcInfo.tszlk.js')+':</label></th>';
    hh += '<td colspan="2" align="left" width="200">';
    hh += '<div class="common_selectbox_wrap">';
    hh += '<select id="bookHouse" class="w100b h100b" onchange="checkTypeSelect(this)">';
    hh += '<option value="" selected="selected" ></option>';
    for (var i = 0 ; i < param.bookHouse.length ; i ++) {
    	var house = param.bookHouse[i];
    	var text = house.text;
    	hh += '<option value="'+house.value+'" title="'+text+'">'+text.getLimitLength(47,'...')+'</option>';
    } 
    hh +='</select>';
    hh += '</div>';
    hh += '</td>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.book.bookStcInfo.ssfl.js')+':</label></th>';
    hh += '<td colspan="2" align="left" width="200">';
    hh += '<div class="common_selectbox_wrap">';
    hh += '<select id="bookCategory" class="w100b h100b" >';
    hh += '<option value="" selected="selected"></option>';
    for (var i = 0 ; i < param.bookCategroy.length ; i ++) {
    	var bookCategory = param.bookCategroy[i];
    	hh += '<option value="'+bookCategory.value+'">'+bookCategory.text+'</option>';
    }
    hh += '</select>';
    hh += '</div>';
    hh += '</td>';
    hh += '<th width="80" noWrap="nowrap" align="right"><label for="text">'+$.i18n('office.asset.apply.assetName.js')+':</label></th>';
    hh += '<td colspan="2" width="200">';
    hh += '<div class="common_txtbox_wrap">';
    hh += '<input id="bookName" class="font_size12" maxlength="80" type="text">';
    hh += '</div>';
    hh += '</td>';
    hh += '</tr>';
    hh += '<tr>';
    hh += '<td colspan="9">&nbsp;</td>';
    hh += '</td>';
    hh += '</tr>';
    hh += '<tr>';
    hh += '<td colspan="9">&nbsp;</td>';
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


/**
 * 重置
 */
function resetResult () {
	//还原查询类型
	if (bookParams.isBooksAdmin && bookParams.isBooksAdmin == 'true') {
		var countType= $('input:radio[name="countType"]').each(function (){
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

	//设置默认值
	var dateValue = fnsetDefaultValue('other');
	var startDate = dateValue.get('start');
	var endDate = dateValue.get('end');
	$('#start_time').val(startDate);
	$('#end_time').val(endDate);
	$('#bookHouse').val('');
	$('#bookCategory').val('');
}


/**
 * 执行统计方法
 */
function executeStatistics () {
	$('#ajaxgridbar').ajaxgridbar({
	      managerName : 'bookStcInfoManager',
	      managerMethod : bookParams.option,
	      callback : function(fpi) {
	         showGrid(fpi.data,bookParams.option);
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
	$('#countDate').html($.i18n('office.book.bookStcInfo.tjrq.js') + ':' + new Date().format('yyyy-MM-dd'));
	if (bookParams.option == 'findByBook') {
		$('#queryTitle').html($.i18n('office.book.bookStcInfo.tszltj.js'));
	} else {
		$('#queryTitle').html($.i18n('office.book.bookStcInfo.jytj.js'));
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
		$('#contFace').html($.i18n('office.book.bookStcInfo.jcsj.js')+":" + timeLength);
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

function fnCreateTh () {
	var ItemArray = getThItemArrayByCars('values');
	return fnSetTh(ItemArray);
}

function funCreateTd (datas,_option) {
	var itemArray = getThItemArrayByCars('keys');
	return fnSetData(itemArray,datas);
}


/**
 * 获取普通查询列表头
 * @param type
 * @param _option
 * @returns
 */
function getThItemArrayByCars(type) {
	var itemMap = new Properties();
	if (bookParams.option == 'findByBook') {
		itemMap.put('bookHouseName',$.i18n('office.book.bookStcInfo.tszlk.js'));
		itemMap.put('bookCatoryName',$.i18n('office.book.bookStcInfo.tszlfl.js'));
		itemMap.put('bookName',$.i18n('office.auto.bookStcInfo.mc.js'));
		itemMap.put('bookTypeName',$.i18n('office.auto.bookStcInfo.lb.js'));
		itemMap.put('bookUnit',$.i18n('office.book.bookStcInfo.jldw.js'));
		itemMap.put('bookCount',$.i18n('office.book.bookStcInfo.kcsl.js'));
		itemMap.put('readCount',$.i18n('office.book.bookStcInfo.jyl.js'));
		itemMap.put('notCount',$.i18n('office.book.bookStcInfo.wghl.js'));
	} else if (bookParams.option == 'findByMemberOrDepartMent') {
		if (queryType == 'member') {
			itemMap.put('memberName',$.i18n('office.book.bookStcInfo.rymc.js'));
		} else {
			itemMap.put('departMentName',$.i18n('office.auto.autoStcInfo.bm.js'));
		}
		itemMap.put('readCount',$.i18n('office.book.bookStcInfo.jyl.js'));
		itemMap.put('notCount',$.i18n('office.book.bookStcInfo.wghl.js'));
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
	var countType = $('input:radio[name="countType"]:checked').val();
	var bookHouse = $('#bookHouse').val();
	var bookCategory = $('#bookCategory').val();
	var bookName = $('#bookName').val();
	var entityId = $('#entityId').val();
	var startTime = $('#start_time').val();
	var endTime = $('#end_time').val();
	if (endTime && startTime) {
		if (fnDateParse(endTime) < fnDateParse(startTime)) {
			$.alert($.i18n('office.book.bookStcInfo.ksrqbndydqjsrq.js'));
			return null;
		}
	}
	if (bookHouse && bookHouse != '') {
		object.bookHouse = bookHouse;
	}
	if (bookCategory && bookCategory != '') {
		object.bookCategory = bookCategory;
	}
	if (bookName && bookName != '') {
		object.bookName = bookName;
	}
	if (countType && countType != '') {
		if (countType == '0') {
			queryType = "departMent";
			object.countType = "departMent";
		} else {
			queryType = "member";
			object.countType = "member";
		}
	}
	if (entityId && entityId != '') {
		object.entityId = entityId;
	}
	if (startTime && startTime != '') {
		object.startTime = startTime+" 00:00:00";
	}
	if (endTime && endTime != '') {
		object.endTime = endTime+" 23:59:59";
	}
	return object;
}

function clearInput () {
	 $('#entityName').val('');
	 $('#entityId').val('');
}

function fnDateParse(dateStr) {
	dateStr = dateStr.replace(/-/g,"/");
	return new Date(dateStr);
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
	if (colms == 'notCount') {
		var notCount = data.notCount.split(',')[_index];
		returnValue = notCount;
		if (notCount != '0') {
			var type = "notCount";
			var params = {
					'index':_index,
					'data':data,
					'type':type
			}
			returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+notCount+"</a>";
		}
	}
	if (colms == 'readCount') {
		var readCount = data.readCount.split(',')[_index];
		returnValue = readCount;
		if (readCount != '0') {
			var type = "readCount";
			var params = {
					'index':_index,
					'data':data,
					'type':type
			}
			returnValue = "<a style='color:blue;' onclick='openData("+$.toJSON(params)+")'>"+readCount+"</a>";
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
	    url: _path+"/office/bookStc.do?method=bookStcInfoShow",
	    width: 1000,
	    height: 600,
	    transParams:obj,
	    title: $.i18n('office.book.bookStcInfo.ckmx.js')
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


function checkTypeSelect (obj) {
	var stockHoseId = -1;
	if (obj.value != '') {
		stockHoseId = obj.value;
	}
	var ajaxM = new bookStcInfoManager();
	ajaxM.findBookTypeEnum(stockHoseId,{
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