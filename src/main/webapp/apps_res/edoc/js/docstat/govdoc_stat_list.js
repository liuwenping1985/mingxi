 $(document).ready(function () {
	loadStyle();
	loadToolbar();
	loadData();
 });
 
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
	 
function setGridWidthAndHeight() {
	$(".flexigrid").css("height", "100%");
    $(".flexigrid").css("width", "100%");
    $(".bDiv").css("height", $(".flexigrid").height()-$(".pDiv").height()-$(".hDiv").height()-5);
}

function loadToolbar() {
	$("#toolbars").toolbar({
		isPager:false,
		toolbar: [{
			id: "exportExcel",
			name: $.i18n("common.toolbar.exportExcel.label"),   //  导出Excel
			className: "ico16 export_excel_16",
			click : function() {
				listExportExcel();
			}
		}]
	});
}
 
//加载页面数据
var grid;
function loadData() {
   //表格加载
	var models = [];
	//超期
	if(listType == 4 || listType == 8 || listType == 12) {
		models.push({display: $.i18n("edoc.element.subject"), name: 'subject', sortable : true, width: '35%' });//公文标题
		models.push({display: $.i18n("edoc.element.fromWordNo"), name: 'docMark', sortable : true, width: '34%' });//来文文号		
		models.push({display: '超期最长人员', name: 'maxOverPerson', sortable : true, width: '13%' });//超期最长人员		
		models.push({display: '超期最长节点', name: 'maxNodePolicy', sortable : true, width: '13%' });//超期最长节点
		models.push({display: '所在处室', name: 'operDept', sortable : true, width: '13%' });//所在处室
		models.push({display: '超期总时长', name: 'deadlineOverView', sortable : true, width: '15%' });//超期总时长		
	} else {
		models.push({display: $.i18n("edoc.element.subject"), name: 'subject', sortable : true, width: '25%' });//公文标题
		models.push({display: '发起人', name: 'startUserName', sortable : true, width: '15%' });//发起人
		models.push({display: $.i18n("edoc.list.currentNodesInfo.label"), name: 'currentNodesInfo', sortable : true, width: '15%' });//当前待办人
		if(listType == 1 || listType == 2 || listType == 3 || listType == 4) {//发文
			models.push({display: '拟稿日期', name: 'startTimeView', sortable : true, width: '15%' });//拟稿日期
		}else if(listType == 5 || listType == 6 || listType == 7 || listType == 8){//收文
			models.push({display: '来文日期', name: 'receipDateView', sortable : true, width: '15%' });//来文日期
		}else if(listType == 9 || listType == 10 || listType == 11 || listType == 12) {//总计
			models.push({display: '来文/拟稿日期', name: 'startTimeView', sortable : true, width: '15%' });//来文日期
		}		
		models.push({display: '内部文号', name: 'serialNo', sortable : true, width: '10%' });//内部文号
		models.push({display: '处理部门', name: 'operDept', sortable : true, width: '10%' });//处理部门
		models.push({display: $.i18n("edoc.edoctitle.fromUnit.label"), name: 'sendUnit', sortable : true, width: '10%' });//来文单位	
		
		if(listType == 5 || listType == 6 || listType == 7 || listType == 8) {//收文
			models.push({display: $.i18n("edoc.element.fromWordNo"), name: 'docMark', sortable : true, width: '15%' });//来文文号
		} else {//发文
			models.push({display: '公文文号', name: 'docMark', sortable : true, width: '15%' });//来文文号
		}
		models.push({display: '办结时间', name: 'completeTimeView', sortable : true, width: '12%' });//办结时间
	}
	
    grid = $('#edocStatListRec').ajaxgrid({
        colModel: models,
        render : rend,
        managerName : "edocStatNewManager",
        managerMethod : "statToListGovdoc",
        resizable : false,
        height : 300,
        width : 1000,
		click :statclk,
		dblclick : statdblclk
    });
    if(typeof(transParams) != "undefined") {
    	var o = new Object();
    	o.statId = statId;
    	o.statType = statType;
    	o.listType = listType;
    	o.displayType = displayType;
    	o.displayId = displayId;
    	o.displayName = displayName;
    	o.startTime = startTime;
    	o.endTime = endTime;
    	o.docMark = docMark;
    	o.docMark_txt = docMark_txt;
    	o.serialNo = serialNo;
    	o.serialNo_txt = serialNo_txt;
    	$('#edocStatListRec').ajaxgridLoad(o);
	}
    setGridWidthAndHeight();
}

function rend(txt, data, r, c, cobj) {
	if(cobj.name == "docMark" && (txt=='undefined')) {
		return "";
	}
	if(cobj.name == "serialNo" && (txt=='undefined')) {
		return "";
	}
	if(cobj.name == "deadlineOverView" && txt!="") {
		txt = "<font color='red'>"+txt+"</font>";
	}
    return txt;
}

//导出Excel
function listExportExcel() {
	if(typeof(transParams) != "undefined") {
        document.getElementById("statConditionForm").action = edocStatUrl+"?method=exportGovdocStatDetailList";
        document.getElementById("statConditionForm").target = "export_iframe";
        document.getElementById("statConditionForm").submit();
	}
}
//列表单击事件
function statclk(data, r, c) {
    var summaryId = data.summaryId;
    var govdocType = data.govdocType;
    var affairId = data.affairId;
    openDetail4ColSummary(summaryId,affairId,govdocType);
}
//列表双击事件
function statdblclk(data, r, c){
    var summaryId = data.summaryId;
    var govdocType = data.govdocType;
    var affairId = data.affairId;
    openDetail4ColSummary(summaryId,affairId,govdocType);
}

//打开页面
function openDetail4ColSummary(summaryId,affairId,govdocType){
    //新公文的
    var _url = "/seeyon/collaboration/collaboration.do?method=summary&openFrom=formQuery&summaryId=" + summaryId;
    if(govdocType==0){ //老公文
        //老公文打开和新的公文打开的方式不一样
        _url = "/seeyon/edocController.do?method=detailIFrame&openFrom=glwd&summaryId="+summaryId;
    }
    try {
    	var rv = v3x.openWindow({
            url: _url,
            workSpace: 'yes',
            dialogType: 'open'
        });
    } catch(e) {
    	//用v3x.openWindow会导致ie报错
        window.open(_url);	
    }
}