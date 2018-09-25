var type = 1;
var typePrompt = "up";
var isModify = false;

$(function() {
	type = $("#type").val();
	if(type == "2") {
		typePrompt = "down";
	}
	$("#queryButton").click(function() {
		var options = {
			url: 'edocMark.do?method=listEdocMarkReserve',
			params: {queryNumber: $("#queryNumber").val(), type:$("#type").val(), markDefineId:$("#markDefineId").val()},
			success: function(json) {
				$("#ul_reserve").find("li").each(function() {
					$(this).remove();
				});	
				var liHtml = "";
				for (var i = 0; i < json.length; i++) {
					liHtml += '<li style="font-size:12px;font-family:SimSun;" title="'+json[i].docMarkDisplay+'" class="padding_t_5 margin_r_5" reservedId="'+json[i].optionReservedId+'" type="'+type+'" startNo="' + json[i].optionStartNo + '" endNo="' + json[i].optionEndNo + '" >' + json[i].docMarkDisplay + '<span onClick="deleteMarkReserve(this)" class="ico16 g6_del_16 margin_l_5"></span></li>';
				}
				$("#ul_reserve").append(liHtml);
			}
		};
		getJetspeedJSON(options);
	});
});

function addMarkReserve() {
	var startNo = $("#startNo").val();
	var endNo = $("#endNo").val();
	var reserveNo = $("#wordNo").val()+$("#formatA").val()+$("#yearNo").val()+$("#formatB").val();
	if(startNo=="") {
		alert($.i18n("edoc.alert_doc_mark_reserve_"+typePrompt+"_min_not_null"));//预留文号最小值不能为空！
		return ;
	} else if(startNo!="" && endNo=="") {
		endNo = startNo;
		reserveNo += getNumberByFormat(startNo) + $("#formatC").val();
	} else if(startNo!="" && endNo!="") {
		if(parseInt(startNo, 10) > parseInt(endNo, 10)) {
			alert($.i18n("edoc.alert_doc_mark_reserve_"+typePrompt+"_min_larger_than_max"));//预留文号最小值不能大于最大值！
			return;
		} else if(parseInt(startNo, 10) == parseInt(endNo, 10)) {
			reserveNo += getNumberByFormat(startNo) + $("#formatC").val();
		} else {
			reserveNo += getNumberByFormat(startNo) + $("#formatC").val() + " "+reserveToLabel+" " + getNumberByFormat(endNo) + $("#formatC").val();
		}
	}
	var sNo = parseInt($("#startNo").val(), 10);
	var eNo = parseInt($("#endNo").val(), 10);
	if($("#endNo").val() == "") {
		eNo = sNo;
	}
	var maxNo = parseInt($("#maxNo").val(), 10);
	if(parseInt(endNo, 10) > parseInt(maxNo, 10)) {
		alert($.i18n("edoc.alert_doc_mark_reserve_"+typePrompt+"_max_to_long"));//预留文号不能大于公文文号最大值！
		return;
	}
	if(parseInt(startNo, 10)<parseInt(endNo, 10) && (parseInt(endNo, 10)-parseInt(startNo, 10))>maxDiffNumber) {
		alert($.i18n("edoc.alert_doc_mark_reserve_"+typePrompt+"_min_max_difference_to_long"));//预留文号的最大值和最小值的差不能大于1000！
		return;
	}

	var repeatFlags = getCacheReserveRepeatFlag(sNo, eNo);
	if(type == 1) {
		if(repeatFlags[0]) {
			alert($.i18n('edoc.alert_doc_mark_reserved_repeat_not_set'));//该文号有重复的预留文号流水，请重新设置！
			return;
		} else if(repeatFlags[1]) {
			alert($.i18n('edoc.alert_doc_mark_reserved_down_repeat_not_set'));//该文号有重复的线下占用文号流水，请重新设置！
			return;
		}
	} else {
		if(repeatFlags[1]) {
			alert($.i18n('edoc.alert_doc_mark_reserved_down_repeat_not_set'));//该文号有重复的线下占用文号流水，请重新设置！
			return;
		} else if(repeatFlags[0]) {
			alert($.i18n('edoc.alert_doc_mark_reserved_repeat_not_set'));//该文号有重复的预留文号流水，请重新设置！
			return;
		}
	}
	
	var liHtml = $("#ul_reserve").html();
	liHtml = "<li style='font-size:12px;font-family:SimSun;' class='add_now padding_t_5' type='"+type+"' startNo='"+startNo+"' endNo='"+endNo+"'>" + reserveNo + "<span onClick='deleteMarkReserve(this)' class='ico16 g6_del_16 margin_l_5'></span></li>" + liHtml;
	$("#ul_reserve").html(liHtml);
	
	//本次预留添加到js缓存数组中
	addNumberToObjArray(sNo, eNo);

	$("#startNo").val("");
	$("#endNo").val("");
	
	isModify = true;
}

function getCacheReserveRepeatFlag(startNo, endNo) {
	var repeatUpFlag = false;
	var repeatDownFlag = false;
	if(type == 1) {
		repeatUpFlag = checkRepeatFlag(1, startNo, endNo);
		if(!repeatUpFlag) {
			repeatDownFlag = checkRepeatFlag(2, startNo, endNo);
		}
	} else {
		repeatDownFlag = checkRepeatFlag(2, startNo, endNo);
		if(!repeatDownFlag) {
			repeatUpFlag = checkRepeatFlag(1, startNo, endNo);
		}
	}
	var repeatFlags = [];
	repeatFlags[0] = repeatUpFlag;
	repeatFlags[1] = repeatDownFlag;
	return repeatFlags;
}

function checkRepeatFlag(checkType, startNo, endNo) {
	if(checkType == 1) {
		var repeatFlag = false;
		for(var i=0; i<reserveLineObjArray.length; i++) {
			var startNo_reserved = reserveLineObjArray[i].startNo;
			var endNo_reserved = reserveLineObjArray[i].endNo;
			var startNoIn = startNo>=startNo_reserved && startNo<=endNo_reserved;//最小值在最小值与最大值之间
			var endNoIn = endNo>=startNo_reserved && endNo<=endNo_reserved;//最大值在最小值与最大值之间
			var startAndEndIn1 = startNo>=startNo_reserved && endNo<=endNo_reserved;//最小值与最大值在最小值与最大值之间
			var startAndEndIn2 = startNo<=startNo_reserved && endNo>=endNo_reserved;//最小值与最大值大于最小值与最小值
			if(startNoIn || endNoIn || startAndEndIn1 || startAndEndIn2) {
				repeatFlag = true;
				break;
			}
		}
		return repeatFlag;
	} else {
		var repeatFlag = false;
		for(var i=0; i<reserveDownObjArray.length; i++) {
			var startNo_reserved = reserveDownObjArray[i].startNo;
			var endNo_reserved = reserveDownObjArray[i].endNo;
			var startNoIn = startNo>=startNo_reserved && startNo<=endNo_reserved;//最小值在最小值与最大值之间
			var endNoIn = endNo>=startNo_reserved && endNo<=endNo_reserved;//最大值在最小值与最大值之间
			var startAndEndIn1 = startNo>=startNo_reserved && endNo<=endNo_reserved;//最小值与最大值在最小值与最大值之间
			var startAndEndIn2 = startNo<=startNo_reserved && endNo>=endNo_reserved;//最小值与最大值大于最小值与最小值
			if(startNoIn || endNoIn || startAndEndIn1 || startAndEndIn2) {
				repeatFlag = true;
				break;
			}
		}
		return repeatFlag;
	}
}

function removeObjArrayElement(array, startNo, endNo) {
	for(var i=0,n=0; i<array.length; i++) { 
        if(array[i].startNo != startNo && array[i].endNo!=endNo) { 
        	array[n++] = array[i];
        }
    }
	if(array.length > 0) {
		array.length -= 1;
	}
}

function deleteNumberToObjArray(startNo, endNo) {
	if(type == 1) {//线上
		removeObjArrayElement(reserveLineObjArray, startNo, endNo);
	} else {//线下
		removeObjArrayElement(reserveDownObjArray, startNo, endNo);
	}
}

function addNumberToObjArray(startNo, endNo) {
	var reserveObj = new Object();
	reserveObj.startNo = startNo;
	reserveObj.endNo = endNo;
	if(type == 1) {
		reserveLineObjArray.push(reserveObj);
	} else {
		reserveDownObjArray.push(reserveObj);
	}
}

function getNumberByFormat(number) {
	var length = parseInt($("#length").val(), 10);
	var number_str = "";
	var number_s = number+"";
	for(var i=number_s.length; i<length; i++) {
		number_str += "0";
	}
	number_str += number;
	return number_str;
}

function deleteMarkReserve(thisSpan) {
	var liClass = $(thisSpan).parent("li").attr("class");
	if(liClass==undefined || liClass=='' || liClass.indexOf("add_now") < 0) {
		var reservedId = $(thisSpan).parent().attr("reservedId");
		if(reservedId!=undefined && reservedId != "") {
			$("#delReserveIds").append("<input type='hidden' id='delReservedId' name='delReservedId' value='"+reservedId+"' />");
			deleteNumberToObjArray(parseInt($(thisSpan).parent().attr("startNo"), 10), parseInt($(thisSpan).parent().attr("endNo"), 10));
		}
	}else if(liClass && liClass.indexOf("add_now")>=0){
		deleteNumberToObjArray(parseInt($(thisSpan).parent().attr("startNo"), 10), parseInt($(thisSpan).parent().attr("endNo"), 10));
	}
	$(thisSpan).parent("li").remove();
	isModify = true;
}

function doIt(type) {
	$("#addReserveIds").html("");
//	if($("#ul_reserve").find("li.add_now").length == 0){
//		if(type==1){
//			alert("请选择预留文号!");
//		}else{
//			alert("请选择线下占用文号!");
//		}
//		return;
//	}
	$("#ul_reserve").find("li.add_now").each(function() {
		var min = parseInt($(this).attr("startNo"), 10);
		var max = parseInt($(this).attr("endNo"), 10);
		$("#addReserveIds").append("<input type='hidden' id='addReservedId' name='addReservedId' value='"+min+"-"+max+"' />");
	});
	var domains = [];
	domains.push('reserveData');
	domains.push('addReserveIds');
	domains.push('delReserveIds');
	domains.push('thisReservedIds');
	$("#markReserveForm").attr("action", "edocMark.do?method=saveMarkReserve");
	$("#submitBtn").removeAttr("onclick");//移除事件，防止重复提交
	$("#markReserveForm").jsonSubmit({
		domains: domains,
		debug : false,
        callback: function(data) {
        	if(data=="repeat") {
        		alert($.i18n('edoc.alert_doc_mark_reserved_repeat_not_set'));//该文号有重复的预留文号流水，请重新设置！
        		$("#submitBtn").attr("onclick","doIt();");//添加事件
        		return;
        	} else if(data=="markDef_is_nul") {
        		alert($.i18n('edoc.alert_doc_mark_definition_alter_deleted'));//公文文号已被删除
        	} else if(data=="success") {
        		if(isModify==true) {
        			alert($.i18n('edoc.alert_doc_mark_setting_success'));//预留文号设置成功！	
        		}
        	}
        	try {
	        	setTimeout("reserveDialogCallBack()", 5);
        	} catch(e) {
        		alert(e);
        		getA8Top().win123.close();
        		parent.location.reload();
        	}
       	}
    });
}

function reserveDialogCallBack() {
	if(typeof(transParams) != "undefined") {
		transParams.parentWin.location.reload();
	}
	commonDialogClose('win123');
}

function commonDialogClose(winName,callBack){
	if(typeof(winName) == 'string'){
		var strWinName = "getA8Top()."+winName+".close()";
		eval(strWinName)
	}
	if(typeof(callBack) == 'string')eval(callBack)
}

