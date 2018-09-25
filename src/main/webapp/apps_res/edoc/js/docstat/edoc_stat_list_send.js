 $(document).ready(function () {
	loadStyle();
	loadToolbar();
	loadCondition();
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
         }, {
             id: "print",
             name: $.i18n("edoc.tbar.print.js"),  //打印
             className: "ico16 print_16",
             click : function(){
            	 var html = $('#center').clone(true);
             	 $("span", html).removeAttr("onclick");
                 popprint(html.html());
              }
         }]
     });
}

var searchobj;
function loadCondition() {//搜索框
    var topSearchSize = 2;
    if($.browser.msie && $.browser.version=='6.0') {
        topSearchSize = 5;
    }
    var conditionArray = [];
    conditionArray.push({id: 'subject', name: 'subject', type: 'input', text: $.i18n("edoc.element.subject"),value: 'subject', maxLength:100 });//公文标题
    conditionArray.push({id: 'docMark', name: 'docMark', type: 'input', text: $.i18n("edoc.element.wordno.label"), value: 'docMark', maxLength:100 });//来文文号
    conditionArray.push({id: 'serialNo', name: 'serialNo', type: 'input', text: $.i18n("edoc.element.wordinno.label"), value: 'serialNo', maxLength:100 });//收文编号
    conditionArray.push({id: 'sendUnit', name: 'sendUnit', type: 'input', text: $.i18n("edoc.edoctitle.fromUnit.label"), value: 'sendUnit', maxLength:100 });//来文单位
    conditionArray.push({id: 'coverTime', name: 'coverTime', type: 'select', text: $.i18n("node.isovertoptime"), value: 'coverTime', 
   	 items: [{
            text:$.i18n("edoc.stat.result.list.label.yes"),//是
            value: '1'
        },{
          text: $.i18n("edoc.stat.result.list.label.no"),//否
          value: '0'
        }] 
    });//是否超期
    if(listType == "5") {
    	conditionArray.push({id: 'nodePolicy', name: 'nodePolicy', type: 'select', text: $.i18n("edoc.form.flowperm.name.label"), value: 'nodePolicy', items: nodeList });///节点权限	 
    }
    searchobj = $.searchCondition({
        top:topSearchSize,
        right:15,
        searchHandler: function() {
        	var o = new Object();
        	try {
        		o = transParams.parentWin.parent.fnGetParams();
        	} catch(e) {
        		o = transParams.parentWin.getConditionObjById();
        	}
        	o.listType = listType;
        	o.displayType = displayType;
        	o.displayId = displayId;
        	o.displayTimeType = displayTimeType;
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            if(choose === 'subject'){
                o.subject = $('#subject').val();
            }else if(choose === 'sendUnit'){
                o.sendUnit = $('#sendUnit').val();
            }else if(choose === 'docMark'){
                o.docMark = $('#docMark').val();
            }else if(choose === 'serialNo'){
            	o.serialNo = $('#serialNo').val();
            }else if(choose === 'coverTime'){
                o.coverTime = $('#coverTime').val();
            }else if(choose === 'nodePolicy'){
                o.nodePolicy = $('#nodePolicy').val();
            }
            o.condition = choose;
            var val = searchobj.g.getReturnValue();
            if(val !== null) {
                $("#edocStatListSend").ajaxgridLoad(o);
            }
        },
        conditions: conditionArray
    });
 }

//加载页面数据
var grid;
function loadData() {
   //表格加载
	var models = [];
	models.push({display: $.i18n("edoc.element.subject"), name: 'subject', sortable : true, width: '43%' });//公文标题
	models.push({display: $.i18n("edoc.element.wordno.label"), name: 'docMark', sortable : true, width: '15%' });//公文文号
	models.push({display: $.i18n("edoc.element.wordinno.label"), name: 'serialNo', sortable : true, width: '10%', hide:true });//内部文号
	models.push({display: $.i18n("edoc.element.sendunit"), name: 'sendUnit', sortable : true, width: '10%' });//发文单位
	models.push({display: $.i18n("edoc.element.createdate"), name: 'startTimeView', sortable : true, width: '12%' });//拟稿日期
	models.push({display: $.i18n("edoc.element.author"), name: 'startUserName', sortable : true, width: '10%', hide:true });//拟稿人
	models.push({display: $.i18n("edoc.list.currentNodesInfo.label"), name: 'currentNodesInfo', sortable : true, width: '15%' });//当前待办人
	models.push({display: $.i18n("node.isovertoptime"), name: 'coverTimeView', sortable : true, width: '8%' });//是否超期
	models.push({display: $.i18n("process.deadlineTime.label"), name: 'deadlineTimeView', sortable : true, width: '10%' });//流程期限
	models.push({display: $.i18n("edoc.stat.result.list.coverTime"), name: 'deadlineOverView', sortable : true, width: '10%' });//流程超期时长
	models.push({display: $.i18n("edoc.stat.result.list.isFinish"), name: 'isFinishView', sortable : true, width: '8%', hide:true });//是否办结
	models.push({display: $.i18n("edoc.stat.result.list.hasAchrive"), name: 'hasArchiveView', sortable : true, width: '8%', hide:true });//是否单位归档
	models.push({display: $.i18n("edoc.stat.result.list.achriveName"), name: 'archiveName', sortable : true, width: '10%', hide:true });//单位归档路径
	models.push({display: $.i18n("edoc.element.senddepartment"), name: 'sendDepartment', sortable : true, width: '10%', hide:true });//发文部门
	models.push({display: $.i18n("edoc.element.unitLevel"), name: 'unitLevelName', sortable : true, width: '10%', hide:true });//公文级别
	models.push({display: $.i18n("edoc.element.issuer"), name: 'issuer', sortable : true, width: '10%', hide:false });//签发人
	models.push({display: $.i18n("edoc.element.sendingdate"), name: 'signingDate', sortable : true, width: '10%', hide:false });//签发日期
    grid = $('#edocStatListSend').ajaxgrid({
        colModel: models,
        render : rend,
        managerName : "edocStatNewManager",
        managerMethod : "getEdocVoList",
        resizable : false,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: false,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        resizable : false,
        slideToggleBtn: true,
		click :statclk,
		dblclick : statdblclk
    });
    if(typeof(transParams) != "undefined") {
    	var o = new Object();
    	try {
    		o = transParams.parentWin.parent.fnGetParams();
    	} catch(e) {
    		o = transParams.parentWin.getConditionObjById();
    	}
		o.edocType=0;
		o.listType = listType;
		o.displayType = displayType;
		o.displayId = displayId;
		o.displayTimeType = displayTimeType;
		$('#edocStatListSend').ajaxgridLoad(o);
	}
    setGridWidthAndHeight();
}

function rend(txt, data, r, c, cobj) {
	if(cobj.name == "docMark" && txt=='undefined') {
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
		var o = new Object();
		try {
    		o = transParams.parentWin.parent.fnGetParams();
    	} catch(e) {
    		o = transParams.parentWin.getConditionObjById();
    	}
		o.listType = listType;
    	o.displayType = displayType;
    	o.displayId = displayId;
    	o.displayTimeType = displayTimeType;
		var _url = edocStatUrl + "?method=exportStatEdocList&edocType="+o.edocType+"&listType="+o.listType
		+"&displayId="+o.displayId+"&displayType="+o.displayType+"&rangeIds="+o.rangeIds
		+"&unitLevelId="+o.unitLevelId+"&sendTypeId="+o.sendTypeId+"&operationTypeIds="+o.operationTypeIds+"&operationType="+o.operationType
		+"&startRangeTime="+o.startRangeTime+"&endRangeTime="+o.endRangeTime+"&displayTimeType="+o.displayTimeType;
		//查询条件是否要过滤
		var choose = $('#'+searchobj.p.id).find("option:selected").val();
		if(choose === 'subject'){
	         o.subject = $('#subject').val();
	     }else if(choose === 'sendUnit'){
	         o.sendUnit = $('#sendUnit').val();
	     }else if(choose === 'docMark'){
	         o.docMark = $('#docMark').val();
	     }else if(choose === 'serialNo'){
	     	o.serialNo = $('#serialNo').val();
	     }else if(choose === 'coverTime'){
	         o.coverTime = $('#coverTime').val();
	     }else if(choose === 'nodePolicy'){
             o.nodePolicy = $('#nodePolicy').val();
         }
		o.condition = choose;
		var val = searchobj.g.getReturnValue();
		if(o.condition!="" && val != null) {
	     	if(o.condition && o.condition!=null) {
	     		_url += "&condition="+o.condition;
	     	}
	     	if(o.subject && o.subject!=null) {
	     		_url += "&subject="+o.subject;
	     	}
	     	if(o.docMark && o.docMark!=null) {
	     		_url += "&docMark="+o.docMark;
	     	}
	     	if(o.serialNo && o.serialNo!=null) {
	     		_url += "&serialNo="+o.serialNo;
	     	}
	     	if(o.sendUnit && o.sendUnit!=null) {
	     		_url += "&serialNo="+o.sendUnit;
	     	}
	     	if(o.coverTime && o.coverTime!=null) {
	     		_url += "&coverTime="+o.coverTime;
	     	}
	     	if(o.nodePolicy && o.nodePolicy!=null) {
	     		_url += "&nodePolicy="+o.nodePolicy;
	     	}
		}
		_url += "&listTitle="+listTitle;
		var downLoadIframe = document.getElementById("hiddenIframe");
		if(downLoadIframe){
		    downLoadIframe.src = encodeURI(_url);
		}
	}
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
