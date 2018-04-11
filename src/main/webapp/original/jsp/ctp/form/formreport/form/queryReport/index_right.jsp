<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include
	file="/WEB-INF/jsp/ctp/form/component/formFieldConditionComp.js.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript" src="${url_ajax_reportSaveManager}"></script>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=formManager"></script>

<script type="text/javascript"
	src="${path}/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"></script>
<title>${ctp:i18n("report.queryReport.tree.formReport")}</title>
	<style type="text/css">
		.layout_north {
			overflow: auto;
		}
	</style>
<script>
var operat = new Array();
var field;
<c:forEach var="f" items="${fields }">
	field = new Object();
	field.fieldName = '${f.name}';
	field.display = '${f.display}';
	field.inputType = '${f.inputType}';
	field.formatType = '${f.formatType}';
	field.enumId = '${f.enumId}';
	field.enumLevel = '${f.enumLevel}';
	var modifyName="${customSelfConditionMap[f.name]}";
	//要显示 用户自定义统计项修改过的字段名称
	if(!$.isNull(modifyName)){
	 field.display=modifyName;
	}
	operat[operat.length] = field;
</c:forEach>
var queryFormId = '${formid}';
var myConditionData = null;
var item = 0; //监督变量
var showModel = "fast"; //显示普通模式(fast)或者自定义模式(user)
function initFieldOperation() {
	var opt = "<option value=''></option>";
	for (var i = 0; i < operat.length; i++) {
		var f = operat[i];
		opt = opt + "<option value='" + f.fieldName + "'>" + f.display + "</option>";
	}
	$(".fieldName").each(function() {
		var temValue = $(this).val();
		$(this).empty();
		$(this).html(opt);
		$(this).val(temValue);
	});
}
//初始JS
$(document).ready(function() {
	initPage();
	initSet();
	initClickEvent();
	addButtonEvent();
	initPageDisplay();
	initChart();
	initState();
	resetWidthUserFastCondition(); 
	adjustQueryHeight();
	resetWidthUserFastCondition();
	resizeQueryHeight();
	$("#northSp_layout").mouseup(function() {
		search();
	});
// 	titleDefined();

});
// 	OA-125244	
// function titleDefined() {
// 	//控制自定义条件标题长度
// 	var $v=$("#userFastCondition table td:eq(0)");
// 	if($v.length!=0){
// 		var $tr=$("#userFastCondition table tr");
// 		$tr.each(function () {
// 			var v=$("td",$(this))[0].textContent;
// 			$("td",$(this)).each(function (index) {
// 				if(index<2){
// 					$(this).css({"width":"160px","text-overflow":"ellipsis","white-space":"nowrap","overflow":"hidden","display": "block","float":"left"});
// 				}
// 				if(index===0){
// 					var title1=v;
// 					$(this).css({"width":"260px","margin-right":"10px","margin-top":"5px"}).attr("title",title1);
// 				}
// 				if(index===2){
// 					$(this).attr("width","50px");
// 				}
// 			});
// 		});
// 	}
// }
function drawResultTable() {
	content.window.drawTable();
};
var showDataList = ${showDataList};
//汇总方式
var rowSumType = "${rowSumType}";
//统计设置初始化
function initSet() {
	//保存为我的统计的设置
	var saveShowDataList = eval(${saveShowDataList});
	var saveRowSumType = "${saveRowSumType}";
	var titles = "";
	var types = "";
	//是否改变了统计设置项,原来保存我的统计的统计项一个也没有
	for (var i = 0; i < showDataList.length; i++) {
		titles = union(titles, showDataList[i].title);
		var type = isColumn(showDataList[i].code) ? "column": "unselect";
		types = union(types, type);
	}
	if (saveShowDataList != "" && saveShowDataList != undefined) {
		var titles1 = "";
		var types1 = "";
		for (var j = 0; j < saveShowDataList.length; j++) {
			var title = saveShowDataList[j].title;
			//如果我的统计的统计项有在统计设置的统计项里面，就显示显示我的统计的统计项（用于保存我的统计后，统计设置重新选择统计项）
			if ($.inArray(title, titles.split(",")) != -1) {
				titles1 = union(titles1, saveShowDataList[j].title);
				var type = isColumn(saveShowDataList[j].code) ? "column": "unselect";
				types1 = union(types1, type);
			}
		}
		if (titles1 != "") {
			var titles = titles1;
			var types = types1;
		}
	}
	$("#showDataList").val(titles);
	$("#showDataListType").val(types);

	if (rowSumType == "" || rowSumType == undefined) {
		$("#label").hide();
		$("#summaryWay").hide();
	} else {
		//saveRowSumType是可以设置为空，用saveShowDataList判断是否是我的统计
		if (!$.isNull(saveShowDataList)) {
			$("#summaryWay").val(saveRowSumType);
		} else {
			$("#summaryWay").val(rowSumType);
		}
	}
}
//是否是列汇总或公式列
function isColumn(value) {
	if (value == "sum" || value == "count" || value == "avg" || value == "max" || value == "min" || value == "formula") {
		return true;
	}
	return false;
}
//返回值拼接，以“,”隔开的字符串
function union(_self, _new) { (_self == "") ? (_self = _new) : (_self = _self + "," + _new);
	return _self;
}
function initState() {
	var finishedFlagValues = eval(${finishedFlagValues});
	if (finishedFlagValues && finishedFlagValues.length > 0) {
		$("#stateTr input[id^='finishedflag']").attr("checked", false);
		$("#stateTr input[id^='finishedflag']").attr("disabled", true);
	}
	$(finishedFlagValues).each(function(index, finishedFlag) {
		$("#finishedflag" + finishedFlag).attr("checked", true);
		$("#finishedflag" + finishedFlag).attr("disabled", false);
	});

	var stateValues = eval(${stateValues});
	if (stateValues && stateValues.length > 0) {
		$("#stateTr input[id^='state']").attr("checked", false);
		$("#stateTr input[id^='state']").attr("disabled", true);
	}
	$(stateValues).each(function(index, state) {
		$("#state" + state).attr("checked", true);
		$("#state" + state).attr("disabled", false);
	});

	var ratifyFlagValues = eval(${ratifyFlagValues});
	if (ratifyFlagValues && ratifyFlagValues.length > 0) {
		$("#stateTr input[id^='ratifyflag']").attr("checked", false);
		$("#stateTr input[id^='ratifyflag']").attr("disabled", true);
	}
	$(ratifyFlagValues).each(function(index, ratifyFlag) {
		$("#ratifyflag" + ratifyFlag).attr("checked", true);
		$("#ratifyflag" + ratifyFlag).attr("disabled", false);
	});
}
function initChart() {
	$("#selctChart").hide();
	if ($("#selctChart option").length > 0) {
		$("#chartLi").show();
	} else {
		$("#chartLi").hide();
	}
}
function initPageDisplay() {
	var hasFastCondition = true; //普通模式条件
	var hasUserCondition = true; //自定义模式条件
	var hasWorkFlow = true; //有流程表单
	//如果是来自fromPortal
	if (${fromPortal == 'true'} && parent.location.href.indexOf("formStatistics") == -1) { //不是从表单业务配置里面进来的
		try {
			getA8Top().hideLocation();
			getCtpTop().showMoreSectionLocation("${ctp:i18n('report.queryReport.tree.formReport')}");
		} catch(eee) {}
	}
	//当所有功能初始化后处理 普通模式和自定义模式
	if (${fieldSize} == 0) { //判断自定义的字段一个也没有说明不是自定义模式
		hasUserCondition = false;
	}
	hasFastCondition = ${hasFastCondition};
	if ($("#formType").val() != "1") {
		hasWorkFlow = false;
	}
	if (!hasFastCondition && !hasUserCondition && hasWorkFlow) {
		//①-①如果普通模式和自定义模式都没有值,且是有流程则只显示普通模式
		$("#custom_mode_link,#normal_mode_link").hide();
		$("#userConditionDiv").hide();
		$("#userFastCondition").show();
	} else if (!hasFastCondition && !hasUserCondition && !hasWorkFlow) {
		//①-②如果普通模式和自定义模式都没有值，且是无流程则什么都不显示
		//$("#north").hide();
		//$(".spiretBarHidden4").click();
		//$("#userConditionDiv").hide();
		//$(".spiret.align_center").hide();
	} else if (hasFastCondition && !hasUserCondition) {
		//②如果普通模式有值，自定义模式无值：只显示普通模式
		$("#custom_mode_link,#normal_mode_link").hide();
		$("#userConditionDiv").hide();
		$("#userFastCondition").show();
	} else if (!hasFastCondition && hasUserCondition) {
		//③如果普通模式无值，自定义模式有值：只显示自定义模式
		$("#custom_mode_link,#normal_mode_link").hide();
		$("#userConditionDiv").show();
		$("#userFastCondition").hide();
		showModel = "user";
		//$("#formStateDiv").show(); //自定义模式下单据状态默认展开
	} else {
		//如果是我的统计 显示自定义模式
		<c:if test="${type eq 'myQuery' }">
			$("#custom_mode_link").hide();
			$("#normal_mode_link").show();
			$("#saveMyQuerySetSpan").show();
			$("#delMyQuerySet").show();//自定义模式 显示 删除我的统计
			$("#userFastCondition").hide();
			$("#userConditionDiv").show();
			showModel = "user";
			//$("#formStateDiv").show(); //自定义模式下单据状态默认展开
		</c:if>
		//否则显示普通模式
		<c:if test="${type !='myQuery'}">
			//两种模式都在的时候，显示普通模式
			$("#userConditionDiv").hide();
			$("#userFastCondition").show();
			$("#custom_mode_link").show();
			$("#normal_mode_link").hide();
			$("#saveMyQuerySetSpan").hide();
			$("#delMyQuerySet").hide();//普通模式 隐藏  删除我的统计
		</c:if>
       
		$("#custom_mode_link,#normal_mode_link").click(function(){
			$("#custom_mode_link,#normal_mode_link").toggle();
			$("#userConditionDiv,#userFastCondition").toggle();
			$("#saveMyQuerySetSpan,#delMyQuerySet").toggle();
			resetWidthUserFastCondition(); 
			resizeQueryHeight();
			$("#conditionReset").trigger("click");
			if($("#custom_mode_link").is(":hidden")){//自定义模式
			   showModel = "user"; 
			}else{
			   showModel = "fast";
			}
       }); 
	}

	if ("myQuery" == "${ctp:escapeJavascript(type)}") { //我的统计 默认显示统计值
		$("#searchResultDiv").show();
		search();
	} else if (hasFastCondition) {
		delButtonEvent();
		$("#searchResultDiv").hide();
		$("#previewDiv").removeClass("hidden");
		$("#showTable").css("height", 200);
		$("#preview").attr("src", "${url_queryReport_showReportPreview}&reportId=${reportId}");
	} else {
		$("#searchResultDiv").show();
		search();
	}

	if (!$.ctx.resources.contains("F01_newColl")) {
		$("#synergy").attr("disabled", true);
	}
}
function initPage() {
	var decentHeight = 130;
	var heitht = 198;
	var layout = new MxtLayout({
		'id': 'layout',
		'northArea': {
			'id': 'north',
			'height': heitht,
			'sprit': true,
			'maxHeight': 250,
			'minHeight': 0,
			'border': true,
			'spritBar': true,
			spiretBar: {
				show: true,
				handlerB: function() {
					layout.setNorth(200);
					search();
					resizeQueryHeight();
				},
				handlerT: function() {
					search();
					layout.setNorth(0);
				}
			}
		},
		'centerArea': {
			'id': 'center',
			'border': true,
			'minHeight': 20
		}
	});
	$("#layout").attrObj("_layout", layout);
}

//重新计算查询页面的高度
//为了多处用到  先封装成一个方法
function resizeQueryHeight() {
	decentHeight = $("#center").height() - $("#result").height();
	$("#result").attr("_decentHeight", decentHeight);
	adjustQueryHeight();
}
function initClickEvent() {
	//统计设置
	$("#setShowDataList").click(function() {
		var url = url_reporDesign_selectFormField;
		var width = 580;
		var height = 400;
		var titles = $("#showDataList").val();
		var types = $("#showDataListType").val();

		var dialog = $.dialog({
			url: url,
			width: width,
			height: height,
			targetWindow: getCtpTop(),
			title: "${ctp:i18n('report.reportDesign.dialog.excQuerySet')}",
			transParams: {
				showDataList: showDataList,
				titles: titles,
				types: types
			},
			targetWindow: top,
			buttons: [{
				text: "${ctp:i18n('report.reportDesign.button.confirm')}",
				isEmphasize: true,
				handler: function() {
					var returnObj = dialog.getReturnValue();
					if (returnObj.titles != "" && returnObj.titles != undefined) {
						$("#showDataList").val(returnObj.titles);
						$("#showDataListType").val(returnObj.types);
						dialog.close();
					} else {
						$.alert("${ctp:i18n('report.reportDesign.dialog.chooseSummaryItem')}");
					}

				}
			},
			{
				text: "${ctp:i18n('report.reportDesign.button.cancel')}",
				handler: function() {
					dialog.close();
				}
			}]
		});
	});
	$("#formStateHref").click(function() {
		$("#formStateDiv").toggle();
		resizeQueryHeight();
		search();
	});

	$("#reportModel").click(function() {
		$("#commonMode").toggleClass("hidden");
		$("#customMode").toggleClass("hidden");
	});
	//点击表格事件
	$("#gridLi").click(function() {
		item = 0;
		//图切换到表需要重新统计
		$("#chartLi").removeClass("current");
		$("#gridLi").addClass("current");
		$("#content").contents().find("#chartDiv").addClass("hidden");
		$("#content").contents().find("#gridDiv").empty();
		$("#content").contents().find("#gridDiv").removeClass("hidden");
		$("#selctChart").hide();
		search();
	});
	//点击图表事件
	$("#chartLi").click(function() {
		if(null != window.frames["content"] && undefined != window.frames["content"].imgnumber){
			item = 1;
			$("#gridLi").removeClass("current");
			$("#chartLi").addClass("current");
			$("#selctChart").show();
			$("#content").contents().find("#gridDiv").addClass("hidden");
			$("#content").contents().find("#chartDiv").removeClass("hidden");
			var selectChart = $("#selctChart").val();
			if (selectChart != 'null') {
				var values = selectChart.split("="); //获得表单值 values[0] 表单名称values[1]
				window.frames["content"].imgnumber = parseInt(values[0]);
			}
			window.frames["content"].drawingDefualt();
		}
	});

	<c:if test="${fieldSize > 0}">
		$("#userConditionDiv").compCondition({formId:queryFormId,fieldNames:operat,data:$.parseJSON(myConditionData)});
	</c:if>

    $("#excQuery").click(function() {
		$("#previewDiv").addClass("hidden");
		search();
	});
	// 重置
	$("#conditionReset").click(function() {
		//保存为我的统计的设置
		var saveShowDataList = eval(${saveShowDataList});
		var titles = "";
		var types = "";
		//是否改变了统计设置项,原来保存我的统计的统计项一个也没有
		for (var i = 0; i < showDataList.length; i++) {
			titles = union(titles, showDataList[i].title);
			var type = isColumn(showDataList[i].code) ? "column": "unselect";
			types = union(types, type);
		}
		if (saveShowDataList != "" && saveShowDataList != undefined) {
			var titles1 = "";
			var types1 = "";
			for (var j = 0; j < saveShowDataList.length; j++) {
				var title = saveShowDataList[j].title;
				//如果我的统计的统计项有在统计设置的统计项里面，就显示显示我的统计的统计项（用于保存我的统计后，统计设置重新选择统计项）
				if ($.inArray(title, titles.split(",")) != -1) {
					titles1 = union(titles1, saveShowDataList[j].title);
					var type = isColumn(saveShowDataList[j].code) ? "column": "unselect";
					types1 = union(types1, type);
				}
			}
			if (titles1 != "") {
				var titles = titles1;
				var types = types1;
			}
		}
		$("#showDataList").val(titles);
		$("#showDataListType").val(types);
		
		
		var rowSumType = "${rowSumType}";
		var saveRowSumType = "${saveRowSumType}";
		if (!$.isNull(saveRowSumType)) {
			rowSumType = saveRowSumType;
		}
		if (!$.isNull(rowSumType)) {
			$("#summaryWay").val(rowSumType);
		}
		
		if(operat.length != 0){
	        $("#userConditionDiv").empty();
	        var data = myConditionData;
	        if("string" == (typeof myConditionData) ){
	        	data = $.parseJSON(myConditionData);
	        }
	        $("#userConditionDiv").compCondition({formId:queryFormId,fieldNames:operat,data:data});
		}

		$("#userFastCondition").empty();
		$("#userFastCondition").append($("body").data("cloneUserFastCondition").clone(true));
		//$("#userFastCondition").comp();
		$("#stateTr input:enabled[type=checkbox]").attr("checked", true);
		// $(".radio_com:eq(3)").attr("checked", false);
		$("#state0").attr("checked", false);

		$('.comp', "#userFastCondition").each(function() {
			var $t = $(this),
			ct = $t.attr('comp');
			if (ct && ct != '') {
				var j = $.parseJSON('{' + ct + '}');
				var compObj = $(this);
				if (j.type == 'chooseProject') { //关联项目组件重复comp有些问题   在外面处理
					var clObj = $(this).clone();
					var clParent = $(this).parent();
					clParent.empty();
					var clId = clObj.prop("id");
					clObj.prop("id", clId.substring(0, clId.length - 4));
					clObj.prop("name", clId.substring(0, clId.length - 4));
					clParent.append(clObj);
					compObj = clObj;
				} else if (j.type == 'autocomplete' || j.type == "fastSelect") { //重置下拉列表
					var clParent = $(this).parent();
					$(this).width(100);
					clParent.empty();
					clParent.append($(this));
				}
				compObj.comp();
			}
		});
		resetWidthUserFastCondition();
// 		titleDefined();

	});
	$("#saveMyQuerySet").click(function() {
		$.setFieldValueSubmit();
		var checkData = true;
		if ($(".fieldName").length > 0) {
			$(".fieldName").each(function(index) {
				var temValue = $(this).val();
				if (temValue == "") {
					var alertObj = $.alert("${ctp:i18n('report.queryReport.index_right.prompt.noEmpty')}"); //自定义条件字段不能为空!
					checkData = false;
					return false;
				}
			});
		}
		var flag = true;
		if (!checkData) {
			flag = false;
		}
		if (!$.validateBrackets()) { //协同V5.0 OA-18969
			flag = false;
		}
		if (flag) {
			saveMyQuery();
		}
	});

	var reportSaveManager_ = null;
	//删除我的统计 
	$("#delMyQuerySet").click(function() {
		var rSid = $("#rSid").val();
		var confirm = $.confirm({
			'msg': "${ctp:i18n('report.queryReport.index_right.prompt.deleteConfirm')}",
			//你确定删除该统计信息吗?
			ok_fn: function() {
				//OA-27820
				if (reportSaveManager_ == null) {
					reportSaveManager_ = new reportSaveManager();
				}
				reportSaveManager_.deleteMyQuery(rSid);
				parent.location.replace(parent.location.href);
				//parent.location.reload(); firefox下的window.location.reload(true)会引起post请求，ie不会。
			}
		});
	});

	$(":checkbox", "#stateTr").click(function() {
		if ($(this).prop("checked")) {} else {
			if ($(this).prop("id").indexOf("finished") > -1) {
				if ($(":checkbox:checked", $(this).parents("div:eq(0)")).length == 0) {
					$.alert("${ctp:i18n('form.query.chooseOneAtLeast')}");
					$(this).prop("checked", true);
				}
			} else {
				if ($(":checkbox:checked", $(this).parents("#formStateDiv")).length == 0) {
					$.alert("${stateLabel.text },${ratifyLabel.text }${ctp:i18n('form.query.chooseOneAtLeast')}");
					$(this).prop("checked", true);
				}
			}
		}
	});

	var cacheTr = $("tr:eq(0)", $("#userConditionTable")).clone(true);

	//初始化显示自定义查询字段
	<c:if test = "${type eq 'myQuery' or type eq 'drQuery'}"> 
		initFieldOperation();
		myConditionData = '${ctp:escapeJavascript(infoxml)}';
		var condDatas = $.parseJSON(myConditionData);
		myConditionData = (condDatas ==null||condDatas.length==0)? null:condDatas;
		$("#userConditionDiv").empty(); 
		<c:if test = "${fieldSize > 0}"> 
			$("#userConditionDiv").compCondition({
				formId: queryFormId,
				fieldNames: operat,
				data: myConditionData
			}); 
		</c:if>
	</c:if>

	$("#leftChar", cacheTr).val("");
	$("#fieldName", cacheTr).val("");
	$("#operation", cacheTr).val("=");
	$("#fieldValue", cacheTr).val("");
	$("#rightChar", cacheTr).val("");
	$("#rowOperation", cacheTr).val("and");
	$("body").data("cloneUserCondition", cacheTr);
	$("body").data("showTableObject", $("table.flexme1").clone(true));
	$("body").data("defineStateTrObject", $("#stateTr").children().clone(true));
	$("body").data("nomorlStateTrObject", $("#stateTr").children().clone(true));
	$("body").data("cloneUserFastCondition", $("#userFastCondition").children().clone(true));
	initShowTable();

	//确定按钮绘图事件
	$("#btnDrawOK").click(function() {
		if ($("#selctChart").val() == "null") {
			$.alert("${ctp:i18n('report.queryReport.index_right.prompt.selectChart')}"); //请选择图表
		} else {
			if ($("#drawingArea").html());
			window.frames["content"].drawing();
		}
	});
}

function getShow(contain) {
	var showObj = $(":input:visible", contain);
	var returnShowValue = "";
	var tName = showObj.prop("nodeName").toLowerCase();
	if (tName == "select") {
		returnShowValue = $(":selected", showObj).text();
	} else if (tName == "input") {
		if (showObj.is(":radio") || showObj.is(":checkbox")) {
			showObj.each(function(i) {
				if ($(this).is(":checked")) {
					if (returnShowValue != "") {
						returnShowValue = returnShowValue + "," + $(this).parent().text();
					} else {
						returnShowValue = $(this).parent().text();
					}
				}
			});
		} else {
			returnShowValue = showObj.val();
		}
	}
	return returnShowValue;
}

function search() {
	if (!$("#previewDiv").hasClass("hidden")) {
		return false;
	}
	$.setFieldValueSubmit();
	if (showModel == "user") {
		var checkData = true;
		if ($(".fieldName").length > 1) {
			$(".fieldName").each(function(index) {
				var temValue = $(this).val();
				if (temValue == "") {
					var alertObj = $.alert("${ctp:i18n('report.queryReport.index_right.prompt.noEmpty')}"); //自定义条件字段不能为空!
					checkData = false;
					return false;
				}
			});
		}
		if (!checkData) {
			return;
		}
	} 
	
	if (!$.validateBrackets()) { //协同V5.0 OA-18969
		return;
	}
	//===========判断输入是否包含"<"和">"=====
	var checkValidate = true;
	$("#userConditionTable :input").each(function() {
		var value = $(this).val();
		if ($(this).attr("type") == "text" || $(this).attr("type") == "textarea") {
			if (value != null && (value.indexOf("<") != -1 || value.indexOf(">") != -1)) {
				//BUG_重要_V5_V5.1sp1_北京嘀嘀无限科技发展有限公司_部门有“<”新建的时候不报错，查询的时候提示“条件中的输入值有特殊字符！”_20160119016434
				var p = $(this).parent();
				var fieldVal = $(p).attr("fieldVal");
				var needCheck = true;
				if (fieldVal != undefined) {
					fieldVal = $.parseJSON(fieldVal);
					if (fieldVal.inputType == "member" || fieldVal.inputType == "account" || fieldVal.inputType == "department" || fieldVal.inputType == "post" || fieldVal.inputType == "level" || fieldVal.inputType == "multimember" || fieldVal.inputType == "multiaccount" || fieldVal.inputType == "multidepartment" || fieldVal.inputType == "multipost" || fieldVal.inputType == "multilevel") {
						needCheck = false;
					}
				}
				if (needCheck) {
					checkValidate = false;
					clearObj = $(this);
					return false;
				}
			}
		}
	});
	if (checkValidate == true) {
		$("#userFastCondition :input").each(function() {
			var value = $(this).val();
			if ($(this).attr("type") == "text" || $(this).attr("type") == "textarea") {
				if (value != null && (value.indexOf("<") != -1 || value.indexOf(">") != -1)) {
					checkValidate = false;
					clearObj = $(this);
					return false;
				}
			}
		});
	}
	if (!checkValidate) {
		$.alert({
			'msg': "条件中的输入值有特殊字符！",
			ok_fn: function() {
				$(clearObj).val("");
			}
		});
		return;
	}
	//===========判断输入是否包含"<"和">"=====
	var userCondition = $("#userConditionTable").formobj({
		validate: false
	}); //用户自定义查询
	for (var i = 0; i < userCondition.length; i++) {
		var con = userCondition[i];
		var val = con.fieldValue;
		for (var s in con) {
			if (con.fieldName == s) {
				var fieldVal = con[s];
				con[s] = fieldVal.replace(/[\'\"\r\n]/ig, "");
			}
		}
		var val = con.fieldValue;
		con.fieldValue = val.replace(/[\'\"\r\n]/ig, "");
	}
	//普通模式
	$("tr", "#userFastCondition").each(function() { //处理数据
		var ff = $("#user_fieldName", $(this));
		$.getFieldValueByInputType($(this), ff);
	});
	var userFastCon = $("#userFastCondition").formobj({
		validate: true
	});
	var stateCon = $("#stateTr").formobj({
		checked: true
	}); //状态选择
	var show = $("#showCol").formobj(); //查询设置  排序设置  显示设置 
	var baseInfo = $("#baseInfo").formobj(); //reportId
	var url = "${url_queryReport_showReportGrid}&reportId=${reportId}&reportSaveId_=${reportSave.id}&formType=${formBean.formType}";
	//以表单的方式提交统计条件
	//现将自定义和普通的统计条件清理掉
	if ($("#contentForm > input[name='userCondition']").length != 0) {
		$("#contentForm > input[name='userCondition']").remove();
	}
	if ($("#contentForm > input[name='userFastCon']").length != 0) {
		$("#contentForm > input[name='userFastCon']").remove();
	}
	if (showModel == "user") {
		//url = url + "&userCondition="+$.toJSON(userCondition);
		if(userCondition.length > 0){//OA-118171 
			$("<input name='userCondition' type='hidden' value='" + $.toJSON(userCondition) + "'/>").appendTo($("#contentForm"));
		}
	} else if (showModel == "fast") {
		//url = url + "&userFastCon="+$.toJSON(userFastCon);
		$("<input name='userFastCon' type='hidden' value='" + $.toJSON(userFastCon) + "'/>").appendTo($("#contentForm"));
	}
	if ($("#formType").val() == "1") { //无流程不显示
		//url = url + "&stateCon="+$.toJSON(stateCon);
		if ($("#contentForm > input[name='stateCon']").length != 0) {
			$("#contentForm > input[name='stateCon']").remove();
		}
		$("<input name='stateCon' type='hidden' value='" + $.toJSON(stateCon) + "'/>").appendTo($("#contentForm"));
	}
	//url = url + "&show="+$.toJSON(show);
	//url = url + "&baseInfo="+$.toJSON(baseInfo);
	if ($("#contentForm > input[name='baseInfo']").length != 0) {
		$("#contentForm > input[name='show']").remove();
		$("#contentForm > input[name='baseInfo']").remove();
		$("#contentForm > input[name='newDataList']").remove();
		$("#contentForm > input[name='summaryType']").remove();
	}
	$("<input name='show' type='hidden' value='" + $.toJSON(show) + "'/>").appendTo($("#contentForm"));
	$("<input name='baseInfo' type='hidden' value='" + $.toJSON(baseInfo) + "'/>").appendTo($("#contentForm"));

	//统计设置
	var titles = $("#showDataList").val().split(",");
	//统计项
	for (var i = 0; i < titles.length; i++) {
		var title = titles[i];
		for (var j = 0; j < showDataList.length; j++) {
			var obj = showDataList[j].title;
			if (title == obj) {
				$("<input name='newDataList' type='hidden' value='" + $.toJSON(showDataList[j]) + "'/>").appendTo($("#contentForm"));
			}
		}
	}
	//汇总方式
	var summaryWay = $("#summaryWay").val();
	$("<input name='summaryType' type='hidden' value='" + summaryWay + "'/>").appendTo($("#contentForm"));

	//url=encodeURI(url);
	$("#contentForm").attr("action", url);
	$("#contentForm").submit();
	$("#searchResultDiv").show();
	addButtonEvent();
	//OA-63796
	$("#excQuery").focus();
}
function clk(data, r, c) {
	alert("clk:" + $.toJSON(data) + "[" + r + ":" + c + "]");
}

function dblclk(data, r, c) {
	alert("dblclk:" + $.toJSON(data) + "[" + r + ":" + c + "]");
}

function initShowTable() {
	//var showFieldList = $("#currentShowFields").val();
	//var showList = $("#currentShowFieldNames").val();
	$("#resultTable").empty();
	$("#resultTable").append($("body").data("showTableObject").clone(true));
	//if(showFieldList!=""){
	if (false) {
		var fields = showFieldList.split(",");
		var names = showList.split(",");
		var data = new Object();
		var dataFields = new Array();
		var field = new Object();
		var col;
		var colData = new Array();
		for (var i = 0; i < fields.length; i++) {
			col = new Object();
			eval("field.field" + i + "=''");
			col.name = "field" + i;
			col.width = 100 / fields.length + "%";
			col.display = names[i];
			colData[colData.length] = col;
		}
		dataFields[0] = field;
		dataFields[1] = field;
		dataFields[2] = field;
		dataFields[3] = field;
		data.rows = dataFields;

		$("table.flexme1").ajaxgrid({
			datas: data,
			colModel: colData,
			usepager: false,
			showTableToggleBtn: false
		});
	}
}
//另存为我的统计
function valUserCond(arr, value) {
	for (var i = 0; i < arr.length; i++) {
		if (value != null && value.indexOf(arr[i]) >= 0) {
			return false;
			break;
		}
	}
	return true;
}
function saveMyQuery() {
	var dialog = $.dialog({
		htmlId: 'myQueryTable',
		title: "${ctp:i18n('report.queryReport.index_right.myReport')}",
		width: "300px",
		height: "150px",
		buttons: [{
			text: "${ctp:i18n('report.reportDesign.button.confirm')}",
			isEmphasize: true,
			//确定
			id: "sure",
			handler: function() {
				var test = $("#name").validate();
				if (test) {
					$.setFieldValueSubmit();
					//清掉两边的空格
					$("#name").val($.trim($("#name").val()));
					//判断是否为重新保存我的统计
					var rSid = $("#rSid").val();
					var myname = $("#name").val();
					if (rSid != "" && (myname == "${reportSave.name}")) {
						var confirm = $.confirm({
							'msg': "${ctp:i18n('report.queryReport.index_right.prompt.nameExist')}",
							//已存在，你确定覆盖原有信息吗?
							ok_fn: function() {
								saveReportSave();
								dialog.close();
							}
						});
					} else {
						var reportSaveManager_ = new reportSaveManager();
						var params = new Object();
						params['myname'] = myname;
						params['status'] = '0';
						params['reportId'] = $("#reportId").val();
						params['userId'] = '${CurrentUser.id}';
						reportSaveManager_.existsMyReport(params, {
							success: function(msg) {
								if (msg) {
									var win = new MxtMsgBox({
										'type': 0,
										'title': '${ctp:i18n("permission.prompt")}',
										//提示
										'imgType': 2,
										'msg': "${ctp:i18n('report.reportResult.chongfu.label')}",
										//已有同名名称，请重命名
										ok_fn: function() {
											return;
										}
									});
								} else {
									saveReportSave();
									dialog.close();
								}
							},
							error: function(request, settings, e) {
								$.alert(e);
							}
						});
					}
				}
			}
		},
		{
			text: "${ctp:i18n('report.reportDesign.button.cancel')}",
			id: "exit",
			handler: function() {
				dialog.close();
			}
		}]
	});
}

/**
 * 不提交快速选人的select的值
 * @param subitField
 * @returns {boolean}
 */
function submitFilterOtherSave(subitField){
	var fName = subitField.id;
	if(fName&&fName.indexOf("_s")>0){
		return false;
	}else{
		return true;
	}
}

function saveReportSave() {
	$("body").jsonSubmit({
		action: "${path }/report/queryReport.do?method=saveMyQuery",
		domains: ["userConditionDiv", "stateTr", "myQueryTable", "baseInfo", "showDataList", "summaryWay"],
		debug: false,
		validate: false,
		needSubmitFilter:submitFilterOtherSave,
		beforeSubmit: function() {
			processBar = new MxtProgressBar({
				text: "${ctp:i18n('report.queryReport.index_right.prompt.saving')}"
			}); //正在保存我的查询....
		},
		callback: function(objs) {
			if (processBar != undefined) {
				processBar.close();
			}
			if (parent.location.href.indexOf('queryReport.do') > 0) {
				parent.location.replace(parent.location.href);
				//parent.location.reload();
			}
		}
	});
}

function checkMaxZhCharLength(value, param) {
	var numI = 0;
	for (i = 0; i < value.length; i++) {
		if (value.charCodeAt(i) > 255) numI += 3;
		else numI++;
	}
	return (numI >= param[0] && numI <= param[1]);
}

function removeChart() {
	try {
		//协同V5.0 OA-31215 在窗口关闭前后清除图表数据，以防止flash_removeCallback错误
		$("#drawingArea").empty();
	} catch(e) {}
}
function resetWidthUserFastCondition() {
	var hasHide = false;
	if ($("#userFastCondition").hasClass("hidden")) {
		hasHide = true;
		$("#userFastCondition").removeClass("hidden");
	}
	$('.comp', "#userFastCondition").each(function() {
		var $t = $(this),
		ct = $t.attr('comp');
		if (ct && ct != '') {
			var j = $.parseJSON('{' + ct + '}');
			if (j.type == 'selectPeople' || j.type == 'chooseProject' || j.type == 'fastSelect') {
				$t.css('height', '20px').css('width', ($(this).parents("td:eq(0)").width() - 30) + "px");;
			}
		}
	});
	if (hasHide) {
		$("#userFastCondition").addClass("hidden");
	}
}

function dataLoad() { // 用户点击统计后，再点击回退，页面不显示
	try {
		var data = $("#content")[0];
		if (data.contentWindow.location.href) {}
	} catch(e) {
		$("#excQuery").click();
	}
}

</script>
</head>
<body class="h100b overflow_hidden page_color" id="layout"  onunload="removeChart()">
<c:if test = "${param.srcFrom eq 'bizconfig' }">
<div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
</c:if>
<div class="hidden form_area" id="myQueryTable" width="90%" height="100%" style="margin-top: 45px;">
    <div class="left" style="text-align: right;height: 24px;line-height: 24px;width: 100px;">
    <input type="hidden" id="rSid"   value="${reportSave.id }"> 
    <input type="hidden" id="rportname"  value="${reportSave.name}">
    ${ctp:i18n('report.queryReport.index_right.myReport')}:</div>
    <div class="common_txtbox_wrap left" ><input type="text" validate="type:'string',notNull:true,notNullWithoutTrim:true,avoidChar:'\\\&#39;&quot;&lt;&gt;!,@#$%&*()',maxLength:85" class="validate" name="${ctp:i18n('report.queryReport.index_right.myReport')}${ctp:i18n('report.reportDesign.dialog.title')}" id="name" value="${reportSave.name}" /></div>
</div>
<form id="exportForm" method="post" target="_blank"></form>
<form action="#" id="queryConditionForm" method="post" target="main">
        <div id="baseInfo" class="hidden">
            <input id="type" value="${ctp:toHTML(type) }">
            <input type="hidden" id="reportId" value="${ctp:toHTML(reportId)}"/>
            <input type="hidden" id="formid" value="${formid}">
            <input type="hidden" id="formType" value="${formBean.formType }">
        </div>
</form>
    <div class="layout_north " id="north">
        <div class="form_area set_search padding_b_10  margin_5">
        ${ctp:i18n('report.queryReport.index_right_grid.statisticConditions')}:
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" id="allDataTable">
                <tr>
                	<td><div class="align_right" id="mode_set_link_div">
                        <a href="#" id="normal_mode_link" class="hidden">[${ctp:i18n('report.queryReport.index_right.mode.normal')}]</a>
                        <a href="#" id="custom_mode_link" class="hidden">[${ctp:i18n('report.queryReport.index_right.mode.custom')}]</a>
                        </div>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td width="61%" valign="top">
                        <fieldset class="fieldset_box margin_t_5">
                            <legend>${ctp:i18n('report.queryReport.index_right.inputStatCondition')}:</legend>
                                <div style="height:80px; overflow:auto;">
                                    <table width="100%" >
                                    <tr>
                                        <td>
                                           <div  id="userConditionDiv"></div>
                                        </td>
                                    </tr>
                                    <tr id="userFastCondition" class='hidden' isGrid='true'>
                                    	<!-- 请勿换行下面这个td，否则影响td内容判断！ -->
                                        <td>${userFieldTable }</td>
                                    </tr>
                                    <tr id="stateTr" <c:if test="${formBean.formType != 1 }">class='hidden'</c:if>>
                                    <td>
				              <!-- finishedflag:0=未结束→finishedflag:1=已结束→finishedflag:3=终止
				              →state:0=草稿→state:1=未审核→state:2=审核通过→state:3=审核不通过
				              →ratifyflag:0=未核定→ratifyflag:1=核定通过→ratifyflag:2=核定不通过 -->
				              <div class="common_checkbox_box clearfix padding_tb_5">
					              ${ctp:i18n('formquery_sheetfinished.label')}：<label class="margin_r_10 hand" for="finishedflag0"> 
					              <input id="finishedflag0" class="radio_com finishedFlag_class" name="finishedflag0"
					                checked="checked" value="0" type="checkbox">${ctp:i18n('formquery_finishedno.label')}</label> 
					              <label class="margin_r_10 hand" for="finishedflag1"> 
					              <input id="finishedflag1" class="radio_com finishedFlag_class" name="finishedflag1"
					                checked="checked" value="1" type="checkbox">${ctp:i18n('formquery_finished.label')}</label> 
					              <label class="margin_r_10 hand" for="finishedflag3"> 
					              <input id="finishedflag3" class="radio_com finishedFlag_class" name="finishedflag3"
					                checked="checked" value="3" type="checkbox">${ctp:i18n('formquery_stop.label')}</label> 
					              <a href="javascript:void(0)" id="formStateHref">[${ctp:i18n('form.query.sheetstatus.label')}]</a>
				              </div>
				              <div class="common_checkbox_box clearfix hidden" id="formStateDiv">
					              <div>
						              ${stateLabel.text }：
						              <label class="margin_r_10 hand" for="state0"> 
						              <input id="state0" class="radio_com state_class" name="state0" value="0" type="checkbox">${ctp:i18n('form.query.draft.label')}
						              </label>
						              <label class="margin_r_10 hand" for="state1"> 
						              	  <input checked="checked" id="state1" class="radio_com state_class" name="state1" value="1" type="checkbox">${ctp:i18n('form.query.nodealwith.label')}
						              </label>
						              <label class="margin_r_10 hand" for="state2"> 
						              	  <input checked="checked" id="state2" class="radio_com state_class" name="state2" value="2" type="checkbox">${ctp:i18n('form.query.passing.label')}
						              </label>
						              <label class="margin_r_10 hand" for="state3"> 
						              	  <input checked="checked" id="state3" class="radio_com state_class" name="state3" value="3" type="checkbox">${ctp:i18n('form.query.nopassing.label')}
						              </label>
					              </div>
					              <div class="common_checkbox_box clearfix padding_t_5">
						              ${ratifyLabel.text }：
						              <label class="margin_r_10 hand" for="ratifyflag0"> 
						              	  <input checked="checked" id="ratifyflag0" class="radio_com ratify_class" name="ratifyflag0" value="0" type="checkbox">${ctp:i18n('form.query.noapproved.label')}
						              </label>
						              <label class="margin_r_10 hand" for="ratifyflag1"> 
						              	  <input checked="checked" id="ratifyflag1" class="radio_com ratify_class" name="ratifyflag1" value="1" type="checkbox">${ctp:i18n('flowBind.vouch.pass')}
						              </label>
						              <label class="margin_r_10 hand" for="ratifyflag2"> 
						              	  <input checked="checked" id="ratifyflag2" class="radio_com ratify_class" name="ratifyflag2" value="2" type="checkbox">${ctp:i18n('form.query.noapprovedpass.label')}
						              </label>
					              </div>
				              </div>
				         </td>
					             </tr>
					           </table>
					        </div>
      					</fieldset>
                    </td>
                    <td width="39%" valign="top">
                        <fieldset class="fieldset_box margin_l_10 margin_t_5" id="showCol">
                            <legend>${ctp:i18n('report.reportDesign.dialog.excQuerySet')}</legend><!-- 统计设置 -->
                             <div style="height:80px; overflow:auto;">
                            <input id="showFields" type="hidden"><input id="showFieldNames" type="hidden" hideText="showFields">
                            <div class="common_txtbox clearfix margin_5">
                            	<table>
                            		<tr>
                            			<td width="115px"><label class="margin_r_10 right title" for="text">${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}:</label><!-- 统计项 --></td>
                            			<td width="150px"><input readonly="readonly" id="showDataList" name="统计项" class="w100b validate" type="text"></td>
                            			<td><a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="setShowDataList">
                                            ${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                            <input type="hidden" id="showDataListType" value="">
                                        </td>
                            		</tr>
                            		<tr>
                            			<td><label class="margin_r_10 right title" id="label" for="text">${ctp:i18n('report.reportDesign.dialog.summaryWay')}:</label><!-- 汇总方式 --></td>
                            			<td><select class="border_all w100b" id="summaryWay">
                            				<option value=""></option>
											<option value="sum">${ctp:i18n('clacType.Sum')}</option>
											<option value="count">${ctp:i18n('clacType.Count')}</option>
											<option value="avg">${ctp:i18n('clacType.Average')}</option>
											<option value="max">${ctp:i18n('clacType.Max')}</option>
											<option value="min">${ctp:i18n('clacType.Min')}</option>
										</select></td>
                            			<td></td>
                            		</tr>
                            	</table>
                            </div>
                        </fieldset>
                    </td>
                </tr>
            </table>
            <div class="align_center clear margin_t_5">
                <a class="common_button margin_r_10 common_button_emphasize" href="javascript:void(0)" id="excQuery">${ctp:i18n('report.queryReport.index_right.button.excQuery')}</a><!-- 统计 -->
                <a class="common_button margin_r_10" href="javascript:void(0)" id="conditionReset">${ctp:i18n('report.queryReport.index_right.button.conditionReset')}</a><!-- 重置 -->
                
                <c:if test="${fromPortal != 'true'}">
                <span id="saveMyQuerySetSpan">
                	<a class="common_button margin_r_10" href="javascript:void(0)" id="saveMyQuerySet" <c:if test="${fieldSize < 1}"> style="display: none;"</c:if> >
                	${ctp:i18n('report.queryReport.index_right.button.saveMyQuerySet')}</a><!-- 保存我的统计 -->
                </span>
                <c:if test="${type eq 'myQuery' }">
                    <a class="common_button margin_r_10" href="javascript:void(0)" id="delMyQuerySet" >${ctp:i18n('report.queryReport.index_right.button.delMyQuerySet')}</a><!-- 删除我的统计 -->
                </c:if>
                </c:if>
            </div>
        </div>
    </div>

    <!--查询设置end-->
    <div class="layout_center stadic_layout over_hidden" id="center">
        <div class="stadic_layout w100b h100b hidden" style="*position:absolute;" id="searchResultDiv">
        	<div id="gridOrChart" class="common_toolbar_box">
		        <div class="padding_lr_10  set_search align_left">
		            <span>
		            	${ctp:i18n('report.queryReport.index_right.statResult.title')}：<!-- 统计结果 -->
		            </span>
		            <span >
		            <a class="img-button margin_r_5"  href="#" id="synergy">
		                 <em class="ico16 forwarding_16"></em>${ctp:i18n('report.queryReport.index_right.toolbar.synergy')}</a></span><!-- 转发协同 -->
		            <a class="img-button margin_r_5" href="#" id="leadingOut">
		                 <em class="ico16 export_excel_16"></em>${ctp:i18n('report.queryReport.index_right.toolbar.leadingOut')}</a><!-- 导出Excel -->
		            <a class="img-button margin_r_5" href="#" id="print">
		                 <em class="ico16 print_16"></em>${ctp:i18n('report.queryReport.index_right.toolbar.print')}</a><!-- 打印 -->
		            <c:if test="${deeId!=null }"><c:if test="${dee}">
		            	<a class="img-button margin_r_5" href="#" id="exitDee">
		                 <em class="ico16 dee_16"></em>${ctp:i18n('report.index.invoke.dee')}</a><!-- 转DEE -->
		            </c:if></c:if>
		            </span>
	            </div>
	            <div class="common_tabs clearfix stadic_layout_head stadic_head_height">
	                <span class="left margin_b_10">
	                    <li id="gridLi" class="current"><a hideFocus style="WIDTH: auto" class="last_tab" href="javascript:void(0)">
	                    	${ctp:i18n('report.queryReport.index_right.statResult.grid')}</a></li><!-- 表格 -->
	                    <li id="chartLi"><a hideFocus  class="last_tab" href="javascript:void(0)"><span id="myimages">
	                    	${ctp:i18n('report.queryReport.index_right.statResult.chart')}</span></a></li><!-- 图表 -->
	                	<li>&nbsp&nbsp&nbsp&nbsp</li>
	                	<select id="selctChart" style="margin-top: 2px;width:125px;">
			               <c:forEach items="${charts }" var="chart" varStatus="status">
			                    <option value="${status.count-1}=${chart.name }"}">${chart.name }</option>
			               </c:forEach>
			            </select>
	                </span>
	            </div>
        	</div>
            <div id="result" class="align_center border_t stadic_layout_body stadic_body_top_bottom" style="top:57px;bottom:0px; background:#fff;overflow:hidden;">
	            <div id="gridDiv" class="absolute h100b" width="100%" height="100%" style="top:0px;bottom:0px;left:0;right:0;background:#fff;">
	                <iframe id="content"  onload="dataLoad();" name="content" frameborder="0" src="" width="100%" height="100%"  ></iframe>
	                <form id="contentForm"  style="display:none" enctype="multipart/form-data" method="post" target="content">
	                	 <input type="hidden" name="isContinue" id="isContinue" value="false">
	                </form>
	            </div>
        	</div>
        </div>
        <div id="previewDiv" class="hidden h100b stadic_layout_body stadic_body_top_bottom" style="overflow-y:hidden;">
            <fieldset id="showTable" class="bg_color_white">
                <legend><span class="ico16 preview_16"></span><span style="color:blue">${ctp:i18n('report.reportDesign.preview')}</span></legend>
                <iframe id="preview" frameborder="0" src="" width="100%" height="95%"></iframe>
            </fieldset>
        </div>
    </div>
    <script type="text/javascript">
    function addButtonEvent() {
        $("#leadingOut,#print,#synergy,#selctChart,#exitDee").removeAttr("disabled");
        $('#leadingOut,#print,#synergy,#selctChart,#exitDee').unbind("click");
        $("#leadingOut").unbind("click").bind("click").click(function() {
        	if($("#content").contents().find("#reportName").html() == undefined){
        		$.alert("${ctp:i18n('report.reportResult.canNot.this')}");
        		return false;
        	}
        	if(item==1){
        		var echartData = window.frames["content"].echartData;
       			if($.isNull(echartData)){
       				$.alert("${ctp:i18n('report.reportResult.canNot.this')}"); 
       				return false;
       			}
       			if(echartData.getDataURL() == ""){
					$.alert("${ctp:i18n('report.reportResult.Browser.too.low')}");
					return false;
				}
       			var param = new Object();
       			param.base64 = echartData.getDataURL();
       			$('#exportForm').jsonSubmit({
       				action: "${path}/report/queryReport.do?method=exportToImage",
       				paramObj: param,
       				callback:function(rval){}
       			});
       		}else{
       			var a=$("#contentForm").attr("action");
    	       	var b=a.substring(a.indexOf("reportId"),a.length);
    	       	$("#excelCondition").remove();
             	 $("#queryConditionForm").attr("action","${path}/report/queryReport.do?method=exportToExcel&reportId=${reportId}"+b.substring(b.indexOf("&"),b.length));
             	 $("#queryConditionForm").append("<div id='excelCondition'></div>");
             	 $("#excelCondition").append($("#contentForm").html());
             	 $("#queryConditionForm").attr("target","temp_iframe");
                $("#queryConditionForm").submit(); 
       		}
        });
        $("#exitDee").unbind("click").bind("click").click(function() {
        	var isAcross = ${isAcross};  // 交叉项，dee不支持这种格式
        	if(isAcross){
        		$.alert("${ctp:i18n('report.index.right.meg.jiacha')}");
        		return false;
        	}
			 var a=$("#contentForm").attr("action");
       		 var b=a.substring(a.indexOf("reportId"),a.length);
       		 $("#excelCondition").remove();
         	 $("#queryConditionForm").attr("action","${path}/report/queryReport.do?method=toDee&deeId=${deeId}&reportId=${reportId}"+b.substring(b.indexOf("&"),b.length));
         	 $("#queryConditionForm").append("<div id='excelCondition'></div>");
         	 $("#excelCondition").append($("#contentForm").html());
         	 $("#queryConditionForm").attr("target","temp_iframe");
             $("#queryConditionForm").submit(); 
        });
        $("#print").unbind("click").bind("click").click(function() {
            var iframeobj = $("#content").contents().find("body").clone();//获得iframe对象
            var printSubject ="";
            //OA-52486表单统计结果打印，左边的框线丢失
            iframeobj.find("#ftable").attr("style","border-left: display");
            var printsub = $("#content").contents().find("#reportName").html();
            if(printsub == undefined){
            	$.alert("${ctp:i18n('report.reportResult.canNot.this')}");
            	return false;
            }else{
            	printsub = "<center><hr style='height:1px' class='Noprint'&lgt;</hr><span style='font-size:24px;line-height:24px;'>"+printsub+"</span></center>";
				//打印时将标题和正文合并到一起  如果页面只有一个对象则可以出滚动条
				//var printSubFrag = new PrintFragment(printSubject, printsub);
				var colBody ="";
				if(item==1){
					var echartData = window.frames["content"].echartData;
					if(null != echartData){
						if(echartData.getDataURL() == ""){
							$.alert("${ctp:i18n('report.reportResult.Browser.too.low')}");
							return false;
						}else{
							var _chartImg = new chartBaseImgManager;
							var imgId = _chartImg.saveImage( echartData.getDataURL(),2);
							colBody+="<img src='${path}/chartImg.do?method=toImageForIe&imgId="+imgId+"'/>";
						}
					}else{
						$.alert("${ctp:i18n('report.reportResult.canNot.this')}");
						return false;
					}
			   }else{
				   iframeobj.find("#context").find(".dongtaiContent").remove();
				   iframeobj.find("#context").find("td").removeAttr("onclick");
				   colBody = iframeobj.find("#portalHidden tbody").html();
				   if(iframeobj.find("#ftable_tableData").length == 0){
					   colBody = colBody + iframeobj.find("#context").html();
				   }else{
					   colBody = colBody + iframeobj.find("#ftable_tableData").html();
				   }
			   }
				var colBodyFrag = new PrintFragment("", printsub+colBody);         
				var cssList = new ArrayList();
				var pl = new ArrayList();
				pl.add(colBodyFrag);
				printList(pl,cssList);
            }
        });
        
        function synergyLoaded(){
        	var iframe = document.getElementById("content"); 
        	if(iframe.contentWindow.document.readyState === "complete" || iframe.contentWindow.document.readyState == "loaded"){
        		synergyCo();
        	}else{
        		$.alert("${ctp:i18n('report.results.not.loaded')}");
        	}
        } 
        
        $("#synergy").unbind("click").bind("click").click(function(){
        	synergyLoaded();
        });
        
        function synergyCo(){ 
        	//OA-65644 去掉导出excel的内容 
			$("#excelCondition").remove(); 
			
            var echartData = window.frames["content"].echartData; 
            //var iframeobj = $("#content").contents();
            var iframeobj = $("#content").contents().find("body").clone();//获得iframe对象
            var title = iframeobj.find("#reportName").html();//获得标题 
            if(title == undefined){ 
            	$.alert("${ctp:i18n('report.reportResult.canNot.this')}"); 
            	return false;
            }else{ 
				var currentData = iframeobj.find("#currentDate").html(); 
				iframeobj.find("#context").find(".dongtaiContent").remove();
				if(currentData){ 
						if(currentData.indexOf("：") >0 ){//中文下冒号 
							currentData = currentData.split("：")[1]; 
						}else{//英文下冒号 
							currentData = currentData.split(":")[1]; 
						} 
					title = title + " " + currentData; 
				} 
	           	var context=""; 
	           	if(item==1){ 
	            	if(echartData != null){ 
	            		if(echartData.getDataURL() == ""){
							$.alert("${ctp:i18n('report.reportResult.Browser.too.low')}");
							return false;
						}else{
							var _chartImg = new chartBaseImgManager;
							var imgId = _chartImg.saveImage( echartData.getDataURL(),2);
							context+="<img src='${path}/chartImg.do?method=toImageForIe&imgId="+imgId+"'/>";
						} 
	            	}else{
	            		$.alert("${ctp:i18n('report.reportResult.canNot.this')}");
	            		return false;
	            	}
				 }else{
	               	if($("#gridLi").hasClass("current")){ 
		            	//context = iframeobj.find("#gridDiv").html();//获得列表内容 
		            	context = "<td width='100%' colSpan='3'><center><span style='font-size:24px;line-height:24px;'>"+iframeobj.find("#reportName").html()+"</span></center></td>"; 
		            	context = context + iframeobj.find("#portalHidden tbody").html();
		            	
		            	iframeobj.find("#context").find("table").addClass("border_all");
		 				iframeobj.find("#context").find("td").addClass("border_l");
		 				iframeobj.find("#context").find("td").addClass("border_t");
		 				iframeobj.find("#context").find("th").addClass("border_l");
		 				iframeobj.find("#context").find("th").addClass("border_t");
		            	var tableData =  iframeobj.find("#ftable_tableData");
		            	if(tableData.length == 0){
		            		iframeobj.find("#context").find(".dongtaiContent").remove();
		 				    iframeobj.find("#context").find("td").removeAttr("onclick");
		 				   
		 				    context = context + iframeobj.find("#context").html();
		            	}else{
							tableData.find("td").removeAttr("onclick");
							context = context + tableData.html();
		            	}
	               	}else{ 
	               		context = iframeobj.find("#chartDiv").html();//获得图表内容 
	               	} 
	               	context = context.replace(/(<a[^>]*?>.*?)/gi,"").replace(/(<\/a[^>]*>.*?)/gi,""); 
				  } 
	           	var params ={
           			subject :title,
           			bodyContent :context
	           	};
	           	collaborationApi.newColl(params);            
			} 
        }
        //选择图表 下拉框事件
        $("#selctChart").unbind("click").bind("change").change(function(){
           var val= $(this).val();
           if(val!="null"){
               var values=val.split("=");//获得表单值 values[0] 表单名称values[1]
               //$("#myimages").html(values[1]);
               window.frames["content"].imgnumber=parseInt(values[0]);
               if(null != window.frames["content"]){
	               window.frames["content"].drawingDefualt(); //绘图
               }
           }else{
               $("#myimages").html("${ctp:i18n('report.queryReport.index_right.statResult.chart')}");
           }
               
        });
        checkResource();
    }
    //判断菜单资源
  function checkResource(){
     try{
	  if(!$.ctx.resources.contains('F01_newColl')){
		  $("#synergy").hide();
	  }
	  }catch(e){}
  }
    function delButtonEvent() {
        $("#leadingOut,#print,#synergy,#exitDee").bind("click");
        $("#selctChart").bind("change");
        $("#leadingOut,#print,#synergy,#selctChart,#exitDee").attr("disabled",true);
    }
    function deeRval(){
    	var meg = document.temp_iframe.deeMeg;
    	if(meg == 1){
    		$.error("${ctp:i18n('report.index.right.dee.meg.error')}");
    	}else if(typeof(meg) != 'undefined'){
    		$.infor("${ctp:i18n('report.index.right.dee.meg.success')}");
    	}
    }
    </script>
    <input type="hidden" id="isStatisticSvalue" value="1">
    <iframe name="temp_iframe" onload="deeRval();" id="temp_iframe" class="hidden">&nbsp;</iframe>
</body>
</html>
