$(document).ready(function () {
	loadStyle();
	loadData();
	setGridHeight();
	window.onresize = setGridHeight;
 });
 
//加载页面数据
var grid;
function loadData() {
  //表格加载
	var models = [];
	var pageCustomId = "edoc_stat_result_rec_customId";
	if(edocType == "1") {
		models = getEdocStatResultRecModels();
		pageCustomId = "edoc_stat_result_rec_customId";
	} else if(edocType == "0") {
		models = getEdocStatResultSendModels();
		pageCustomId = "edoc_stat_result_send_customId";
	} else if(edocType=="2") {
		models = getEdocStatResultSignModels();
		pageCustomId = "edoc_stat_result_sign_customId";
	}
	grid = $('#'+getStatResultDivId()).ajaxgrid({
        colModel: models,
        render : rend,
        edocType: edocType,
        managerName : "edocStatNewManager",
        managerMethod : "getEdocStatVoList",
        usepager : false,
        resizable : false,
        customize : true,
        customId : pageCustomId
    });	
	var obj = null;
	if($("#statConditionForm") && $("#statConditionForm").length>0) {
		obj = getConditionObjById();
		$("#statTitle").text($("#condition_statTitle").val());
	} else {
		obj = parent.fnGetParams();
		$("#statTitle").text($.i18n("edoc.stat.result.title", obj.startRangeTime, obj.endRangeTime));
	}
	$('#'+getStatResultDivId()).ajaxgridLoad(obj);
}


function getConditionObjById() {
	var obj = new Object();
	obj.edocType = edocType;
	obj.startRangeTime = $("#condition_startRangeTime").val();
	obj.endRangeTime = $("#condition_endRangeTime").val();
	obj.rangeIds = $("#condition_rangeIds").val();
	obj.displayType = $("#condition_displayType").val();
	obj.displayTimeType = $("#condition_displayTimeType").val();
	obj.sendTypeId  = $("#condition_sendType").val();
	obj.unitLevelId  = $("#condition_unitLevel").val();
	obj.operationType  = $("#condition_operationType").val();
	obj.operationTypeIds = $("#condition_operationTypeIds").val();
	return obj;
}

function getEdocStatResultSendModels() {
	var models = [];
	models.push({display: $.i18n("edoc.stat.org"), name: 'displayName', sortable : true, width: '39%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.totalEdocType0"), name: 'countHandleAll', sortable : true, width: '10%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.finish"), name: 'countFinish', sortable : true, width: '10%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.waitFinish"), name: 'countWaitFinish', sortable : true, width: '10%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.sent"), name: 'countSent', sortable : true, width: '10%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.done"), name: 'countDone', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.pending"), name: 'countPending', sortable : true, width: '10%',align:'center' });
	//models.push({display: $.i18n("edoc.stat.result.list.zcdb"), name: 'countZcdb', sortable : true, width: '10%' });
	return models;
}

function getEdocStatResultRecModels() {
	var models = [];
	models.push({display: $.i18n("edoc.stat.org"), name: 'displayName', sortable : true, width: '39%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.totalEdocType1"), name: 'countDoAll', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.finish"), name: 'countFinish', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.waitFinish"), name: 'countWaitFinish', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.sent"), name: 'countSent', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.done"), name: 'countDone', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.pending"), name: 'countPending', sortable : true, width: '10%' ,align:'center'});
	//models.push({display: $.i18n("edoc.stat.result.list.zcdb"), name: 'countZcdb', sortable : true, width: '10%' });
	if(isG6Version && showBanwenYuewen) {
		models.push({display: $.i18n("edoc.stat.result.list.allread"), name: 'countReadAll', sortable : true, width: '10%', hide: true ,align:'center'});
		models.push({display: $.i18n("edoc.stat.result.list.reading"), name: 'countReading', sortable : true, width: '10%', hide: true ,align:'center'});
		models.push({display: $.i18n("edoc.stat.result.list.readed"), name: 'countReaded', sortable : true, width: '10%', hide: true ,align:'center'});
	}
	//models.push({display: $.i18n("edoc.stat.result.list.undertaker"), name: 'countUndertaker', sortable : true, width: '10%', hide: true ,align:'center'});
	return models;
}

function getEdocStatResultSignModels() {
	var models = [];
	models.push({display: $.i18n("edoc.stat.org"), name: 'displayName', sortable : true, width: '39%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.totalEdocType0"), name: 'countHandleAll', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.finish"), name: 'countFinish', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.waitFinish"), name: 'countWaitFinish', sortable : true, width: '10%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.sent"), name: 'countSent', sortable : true, width: '10%',align:'center' });
	models.push({display: $.i18n("edoc.stat.result.list.done"), name: 'countDone', sortable : true, width: '10%' ,align:'center'});
	models.push({display: $.i18n("edoc.stat.result.list.pending"), name: 'countPending', sortable : true, width: '10%',align:'center' });
	//models.push({display: $.i18n("edoc.stat.result.list.zcdb"), name: 'countZcdb', sortable : true, width: '10%' });
	return models;
}

function getStatResultDivId() {
	var thisListDivId = "edocStatResultRec";
	if(edocType == "0") {
		thisListDivId = "edocStatResultSend";
	} else if(edocType == "2") {
		thisListDivId = "edocStatResultSign";
	}
	return thisListDivId;
}

function rend(txt, data, r, c, cobj) {
	if(c != 0) {
		txt = "<a href='javascript:void(0)' onClick=openStatResultDialog('"+cobj.name+"','"+data.displayId+"','"+data.displayType+"','"+data.displayTimeType+"')>" + txt + "</a>";
	}
    return txt;
}

function openStatResultDialog(cname,displayId,displayType,displayTimeType) {
	var listType = "";
	var listTitle = "";
	if(cname == "countDoAll") {
		listTitle = $.i18n("edoc.stat.result.list.totalEdocType1");
		listType = 1;
	} else if(cname == "countHandleAll")  {
		listTitle = $.i18n("edoc.stat.result.list.totalEdocType0");
		listType = 1;
	} else if(cname == "countFinish") {
		listTitle = $.i18n("edoc.stat.result.list.finish");
		listType = 2;
	} else if(cname == "countWaitFinish") {
		listTitle = $.i18n("edoc.stat.result.list.waitFinish");
		listType = 3;
	} else if(cname == "countSent") {
		listTitle = $.i18n("edoc.stat.result.list.sent");
		listType = 4;
	} else if(cname == "countDone") {
		listTitle = $.i18n("edoc.stat.result.list.done");
		listType = 5;
	} else if(cname == "countPending") {
		listTitle = $.i18n("edoc.stat.result.list.pending");
		listType = 6;
	} else if(cname == "countZcdb") {
		listTitle = $.i18n("edoc.stat.result.list.zcdb");
		listType = 7;
	} else if(cname == "countReadAll") {
		listTitle = $.i18n("edoc.stat.result.list.allread");
		listType = 8;
	} else if(cname == "countReaded") {
		listTitle = $.i18n("edoc.stat.result.list.readed");
		listType = 9;
	} else if(cname == "countReading") {
		listTitle = $.i18n("edoc.stat.result.list.reading");
		listType = 10;
	} else if(cname == "countUndertaker") {
		listTitle = $.i18n("edoc.stat.result.list.undertaker");
		listType = 11;
	}
	listTitle += $.i18n("edoc.stat.result.list.title.label");
	var url = edocStatUrl + "?method=statEdocList&listType="+listType+"&displayId="+displayId+"&listTitle="+encodeURIComponent(listTitle);
	if($("#statConditionForm") && $("#statConditionForm").length>0) {
		o = getConditionObjById();
	} else {
		o = parent.fnGetParams();
	}
	url += "&edocType="+o.edocType
	+"&displayType="+o.displayType+"&rangeIds="+o.rangeIds
	+"&unitLevelId="+o.unitLevelId+"&sendTypeId="+o.sendTypeId+"&operationTypeIds="+o.operationTypeIds+"&operationType="+o.operationType
	+"&startRangeTime="+o.startRangeTime+"&endRangeTime="+o.endRangeTime+"&displayTimeType="+o.displayTimeType;
	showSummayDialogByURL(url, listTitle);
}

var dialogDealColl;
function showSummayDialogByURL(url,title) {
  	var width = $(getA8Top().document).width() - 130;
  	var height = $(getA8Top().document).height() - 50;
  	dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'dialogDealColl',
        targetWindow:getCtpTop(),
        transParams: {'parentWin':window},
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function(){
        	  dialogDealColl.close();
          }
        }        
    });
}

 function loadStyle() {
	//初始化布局
	 new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 30,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
}
 
function setGridHeight() {
	$("div.flexigrid").height($("#center").height()-5);
	$("div.bDiv").height($("div.flexigrid").height()-$("div.hDiv").height());
}

function statResultToExcel() {
	var o = new Object();
	if($("#statConditionForm") && $("#statConditionForm").length>0) {
		o = getConditionObjById();
	} else {
		o = parent.fnGetParams();
	}
	var _url = edocStatUrl + "?method=exportStatResult&edocType="+o.edocType
	+"&displayType="+o.displayType+"&rangeIds="+o.rangeIds
	+"&unitLevelId="+o.unitLevelId+"&sendTypeId="+o.sendTypeId+"&operationTypeIds="+o.operationTypeIds+"&operationType="+o.operationType
	+"&startRangeTime="+o.startRangeTime+"&endRangeTime="+o.endRangeTime+"&displayTimeType="+o.displayTimeType;
	_url += "&statTitle="+$("#statTitle").html();
	
	$("#hiddenIframe").attr("action",	_url);
    $("#hiddenIframe").jsonSubmit();
}

function printStatResult() {
	var html = $('#center').clone(true);
	
	//打印标题
	var titleHTML = document.getElementById("statTitle").outerHTML;
	html.prepend($(titleHTML));
	
	 $("span", html).removeAttr("onclick");
     popprint(html.html());
}

//打印 
function popprint(content) {
	var printContentBody = "";
	var cssList = new ArrayList();
	var pl = new ArrayList();
	var contentBody = content ;
	var contentBodyFrag = "" ;
	cssList.add("${path}/skin/default/skin.css");
	contentBodyFrag = new PrintFragment(printContentBody, contentBody);
	pl.add(contentBodyFrag);
	printList(pl,cssList);
}

