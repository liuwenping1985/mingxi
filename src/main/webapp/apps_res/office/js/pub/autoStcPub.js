
/**
 * 通用方法设置时间默认值
 * @param _type
 * @returns {Properties}
 */
function fnsetDefaultValue(_type) {
	var dateValue = new Properties();
	var nowDate = new Date();
	var startDateStr = "";
	var endDateStr = "";
	if (_type == 'byYear') {
		startDateStr = parseInt(nowDate.getFullYear(),10) -3;
		endDateStr = nowDate.getFullYear();
	} else if (_type == 'byMounth') {
		endDateStr = nowDate.format("yyyy-MM");
		var startDate = nowDate;
		startDate.setMonth(startDate.getMonth() -6);
		startDateStr = startDate.format("yyyy-MM");
	} else {
		startDateStr = nowDate.getFullYear() +"-01-01";
		endDateStr = nowDate.format('yyyy-MM-dd');
	}
	dateValue.put('end',endDateStr);
	dateValue.put('start',startDateStr);
	return dateValue;
}

/**
 * 通用方法，设置数据，样式一
 * @param tdItemArray
 * @param _index
 * @param datas
 * @returns {String}
 */
function fnSetData (tdItemArray,datas) {
	var tdHtml = "";
	for (var j = 0 ; j < datas.length ; j++) {
		tdHtml += "<tr>";
		for (var i = 0; i < tdItemArray.size(); i ++ ) {
			var valueStr = '';
			if (typeof (fnTdCollBack) !== 'undefined') {
				 valueStr = fnTdCollBack(tdItemArray.get(i), 0, datas[j]);
		    }
			if (valueStr == '' && valueStr != '0') {
				valueStr = datas[j][tdItemArray.get(i)];
				if (valueStr) {
					try{
						valueStr = valueStr.escapeHTML();
					}catch(e){
						valueStr = valueStr;
					}
				}
			}
			if(valueStr.length > 20 && valueStr.indexOf("<a") == -1){
				tdHtml += "<td align='center' nowrap='nowrap' style='min-width:58px;text-align:left;text-align:center;' title='"+valueStr+"'>"+valueStr.getLimitLength(20,"...")+"</td>";
			}else{
				tdHtml += "<td align='center' nowrap='nowrap' style='min-width:58px;text-align:left;text-align:center;'>"+valueStr+"</td>";
			}
		}
		tdHtml += "</tr>";
	}
	return tdHtml;
}
/**
 * 通用方法，设置列表头，样式一
 * @param tdItemArray
 */
function fnSetTh (thItemArray) {
	var thHTML = "";
	thHTML += "<thead>";
	thHTML += "<tr>";
	for (var i = 0 ; i < thItemArray.size() ; i ++) {
		thHTML += "<th style='text-align: center;line-height：20px;background-color:#c8ebf9;' nowrap='nowrap'>"+thItemArray.get(i)+"</th>";
	}
	thHTML += "</tr>";
	thHTML += "</thead>";
	return thHTML;
}

/**
 * 通用方法设置列数据 样式二
 * @param dataMap
 * @param tdItemArray
 * @param fistKey
 * @returns {String}
 */
function fnSetDateStyeTow (dataMap,tdItemArray,fistKey) {
	var dataHtml = "";
	var keys = dataMap.keys();
	for (var i = 0 ; i < keys.size() ; i ++ ) {
		var key = keys.get(i);
		var dataList = dataMap.get(key);
		var stcData = dataList.get(0);
		var rowlength = dataList.size() + 1;
		dataHtml += "<tr>";
		dataHtml += "<td align='center' rowspan='"+rowlength+"' nowrap='nowrap' style='min-width:58px;text-align:left;text-align:center;'>"+stcData[fistKey]+"</td>";
		dataHtml += "</tr>";
		dataHtml += fnSetData(tdItemArray,dataList.toArray());
	}
	return dataHtml;
}

/**
 * 通用方法，根据指定的key列生成map对象，用于table样式二的生成
 * @param datas
 * @param key
 * @returns {Properties}
 */
function fnCreateMapByDept (datas,key) {
	var deptDataMap = new Properties();
	for (var j = 0 ; j < datas.length ; j++) {
		var deptId = datas[j][key];
		var dataList = new ArrayList();
		if (deptDataMap.get(deptId) != null) {
			dataList = deptDataMap.get(deptId);
		} else {
			dataList = new ArrayList();
		}
		dataList.add(datas[j]);
		deptDataMap.put(deptId,dataList);
	}
	return deptDataMap;
}

/**
 * 通用方法，分组查询更具样式类型生成列表头
 * @param thItemArray
 * @param forLength
 * @param style
 * @returns {String}
 */
function fnCreateThByGoup (thItemArray,forLength,style) {
	var thHTML = "";
	thHTML += "<thead>";
	thHTML += "<tr>";
	var itemLength = 1;
	thHTML += "<th rowspan='2' style='text-align: center;line-height：20px; background-color:#c8ebf9;' nowrap='nowrap'>"+thItemArray.get(0)+"</th>";
	if (style == 'style2') {
		thHTML += "<th rowspan='2' style='text-align: center;line-height：20px; background-color:#c8ebf9;' nowrap='nowrap'>"+thItemArray.get(1)+"</th>";
		itemLength ++ ;
	}
	var cospaln = thItemArray.size() -itemLength;
	for (var j = 0 ; j < forLength; j ++) {
		var showTime = "";
		if (queryCountType == '1') {
			var startYear = parseInt(queryStartTime.split('-')[0],10);
			var startMounth = parseInt(queryStartTime.split('-')[1],10);
			var mounth = startMounth + j;
			if (mounth > 12) {
				startYear = startYear + parseInt(mounth/12,10);
				startMounth = mounth - (12*parseInt(mounth/12,10));
			} else {
				startMounth = mounth;
			}
			showTime = startYear + $.i18n('office.auto.year.js')+ startMounth +$.i18n('office.auto.month.js');
		} else {
			showTime = parseInt(queryStartTime,10)+j + $.i18n('office.auto.year.js');
		}
		thHTML += "<th colspan='"+cospaln+"' style='text-align: center;line-height：20px; background-color:#c8ebf9;' nowrap='nowrap'>"+showTime+"</th>";
	} 
	thHTML += "</tr>";
	thHTML += "<tr>";
	for (var j = 0 ; j < forLength; j ++) {
		for (var i = itemLength ; i < thItemArray.size() ; i ++) {
			thHTML += "<th style='text-align: center;line-height：20px; background-color:#c8ebf9;' nowrap='nowrap'>"+thItemArray.get(i)+"</th>";
		}
	}
	thHTML += "</tr>";
	thHTML += "</thead>";
	return thHTML;
}

/**
 * 通用方法分组查询设置列数据
 * @param datas
 * @param forLength
 * @param itemArray
 * @param firstKey
 * @returns {String}
 */
function fnSetDateByGroup (datas,forLength,itemArray,firstKey) {
	var tdHtml = "";
	for (var j = 0 ; j < datas.length ; j++) {
		tdHtml += "<tr>";
		tdHtml += "<td align='center' nowrap='nowrap' style='min-width:58px;text-align:left;text-align:center;'>"+datas[j][firstKey]+"</td>";
		for (var k = 0 ; k < forLength; k ++) {
			for (var i = 1; i < itemArray.size(); i ++ ) {
				var valueStr = '';
				var valueStr = '';
				if (typeof (fnTdCollBack) !== 'undefined') {
					 valueStr = fnTdCollBack(itemArray.get(i), k, datas[j]);
			    }
				if (valueStr == '') {
					if (datas[j][itemArray.get(i)]) {
						if (datas[j][itemArray.get(i)].split(',').length > k) {
							valueStr = datas[j][itemArray.get(i)].split(',')[k];
						} else {
							valueStr = datas[j][itemArray.get(i)];
						}
					}
					if (valueStr) {
						try{
							valueStr = valueStr.escapeHTML();
						}catch(e){
							valueStr = valueStr;
						}
					}
				}
				tdHtml += "<td align='center' nowrap='nowrap' style='min-width:58px;text-align:left'>"+valueStr+"</td>";
			}
		}
		tdHtml +="</tr>";
	}
	return tdHtml;
}

/**
 * 通用方法分组查询设置列数据 ，样式二
 * @param forLength
 * @param itemArray
 * @param dataMap
 * @param fistKey
 * @param lastKey
 * @returns {String}
 */
function fnSetDataGorupStyleTow (forLength,itemArray,dataMap,fistKey,lastKey) {
	var keys = dataMap.keys();
	var dataHtml = "";
	for (var i = 0 ; i < keys.size() ; i ++) {
		var mapKey = keys.get(i);
		var dataList = dataMap.get(mapKey);
		var rowlength = dataList.size() + 1;
		dataHtml += "<tr>";
		dataHtml += "<td align='center' rowspan='"+rowlength+"' nowrap='nowrap' style='min-width:58px;text-align:left;text-align:center;'>"+dataList.get(0)[fistKey]+"</td>";
		dataHtml += "</tr>";
		dataHtml += fnSetDateByGroup(dataList.toArray(), forLength, itemArray, lastKey)
	}
	return dataHtml;
}

function checkDate (dateStr) {
	if (dateStr == '%Y-%m') {
		return false;
	}
	return true;
}

/**
 * 综合办公所有统计页面打印功能
 */
function printColl () {
	var printSubject = "";
	var printSubFrag = new PrintFragment(printSubject, "");
	var printSenderInfo = "";
	var printSenderFrag = new PrintFragment(printSenderInfo, "");
	var printColBody= "";
	var html = "";
	var trIndexFirst = $('#oper')[0].innerHTML.indexOf('<tr>');
	var trIndexLast = $('#oper')[0].innerHTML.indexOf('</tr>');
	var startHtml = "";
	var endHtml = "";
	if (trIndexFirst > -1) {
		startHtml = $('#oper')[0].innerHTML.substr(0,trIndexFirst);
	}
	if (trIndexLast > -1) {
		endHtml =  $('#oper')[0].innerHTML.substr(trIndexLast);
	}
	html += "<div>" + startHtml + endHtml;
	html += $('#queryResult')[0].innerHTML+"</div>";
	var colBody = html; 
	var colBodyFrag = new PrintFragment(printColBody, colBody);
	var cssList = new ArrayList();
	var pl = new ArrayList();
	pl.add(printSubFrag);
	pl.add(printSenderFrag);
	pl.add(colBodyFrag);
	printList(pl,cssList);
	
}