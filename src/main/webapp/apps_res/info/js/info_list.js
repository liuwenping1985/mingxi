
var searchConditionObj;
//刷新当前页面
function refreshW() {
	parent.location.reload();
}

/****** 列表操作：新建 *****/
function createRow() {
	window.location.href = _ctxPath+"/info/infocreate.do?method=createInfo&action=create&listType="+listType;
}

/****** 列表操作：修改 *****/
function modifyRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
        $.alert($.i18n('infosend.listInfo.selectEditInfo'));//请选择要修改的信息!
        return;
    }
    if(rows.length > 1) {
    	$.alert($.i18n('infosend.listInfo.selectOneInfoEdit'));//请选择一条记录
    	return;
    }
    window.location.href = _ctxPath+"/info/infocreate.do?method=createInfo&action=modify&id="+rows[0].id+"&affairId="+rows[0].affairId;
}

//回调函数
function rend(txt, data, r, c) {
	if(c===1){
		txt ="<span class='grid_black'>"+text+"</span>";
	}
	return txt;
}

//定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    TimeFn = setTimeout(function(){
    	$('#summary').attr("src", _ctxPath+"/info/score.do?method=edit&openForm=view&id="+data.id);
    }, 10);
}
//定义双击事件
function clickModifyRow(data, rowIndex, colIndex) {
	 clearTimeout(TimeFn);
	    TimeFn = setTimeout(function(){
	    	$('#summary').attr("src", _ctxPath+"/info/score.do?method=edit&openForm=edit&id="+data.id);
	    }, 10);
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
var queryDialog;
function openQueryViews(openFrom){
    searchobj.g.clearCondition();
    queryDialog = $.dialog({
        url:  _ctxPath + "/info/infoList.do?method=combinedQuery&listType="+openFrom,
        width: 500,
        height: 240,
        title: $.i18n('infosend.listInfo.combinedQuery'), //组合查询
        id:'queryDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
                queryDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
                var o = queryDialog.getReturnValue();
                o = $.toJSON(o);
                o = $.parseJSON(o);
                queryDialog.close();
                loadFormData(o);
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
                queryDialog.close();
            }
        }]
    });
}

function loadFormData(o) {
	searchConditionObj = o;
    $('#'+o.listFrom).ajaxgridLoad(o);
}

function colseQuery() {
    try{
        var dialogTemp=window.parentDialogObj['queryDialog'];
        dialogTemp.close();
    }catch(e){
    }
}

function doExportExcel(){
	var _url = _ctxPath + "/info/infoList.do?method=listInfoExport&listType="+listType;
	var o = new Object();
	if(searchConditionObj){
	    var choose = searchConditionObj.condition;
	    if(choose && choose != ""){
	    	_url += "&condition="+choose;
	    	var _subject = searchConditionObj.subject;
	    	var _reportUnit = searchConditionObj.reportUnit;
	    	var _reportDept = searchConditionObj.reportDept;
	    	var _reportDate = searchConditionObj.reportDate;
	    	var _subState = searchConditionObj.subState;
	    	var _reporter = searchConditionObj.reporter;
		    if(choose === 'subject' || (_subject != null && _subject != "")){
		        o.subject = _subject;
		        _url += "&subject="+o.subject;
		    }
		    if(choose === 'reportUnit' || (_reportUnit != null && _reportUnit !="")){
		        o.reportUnit = _reportUnit;
		        _url += "&reportUnit="+o.reportUnit;
		    }
		    if(choose === 'reportDept' || (_reportDept != null && _reportDept != "")){
		        o.reportDept = _reportDept;
		        _url += "&reportDept="+o.reportDept;
		    }
		    if(choose === 'reportDate' || (_reportDate != null && _reportDate != "#")){
		        var fromDate = _reportDate.split("#")[0];
		        var toDate = _reportDate.split("#")[1];
		        if(fromDate != "" && toDate != "" && fromDate > toDate){
		            $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
		            return;
		        }
		        if(fromDate != ""){
		            _url += "&fromReportDate=" + fromDate;;
		        }
		        if (toDate != "") {
		            _url += "&toReportDate=" + toDate;;
		        }
		    }
		    if(choose === 'subState' || (_subState != null && _subState != "")){
		        o.subState = _subState;
		        _url += "&subState="+o.subState;
		    }
		    if(choose === "comQuery" && (_reporter != null && _reporter != "")){
		    	_url += "&reporter="+_reporter;
		    }
		    //o.condition = choose;
	        //_url += "&condition="+o.condition;
	    }
	}
	
	
	var downLoadIframe = document.getElementById("hiddenIframe"); 
    if(downLoadIframe){ 
        downLoadIframe.src = encodeURI(_url); 
    }
}

function deleteInfoByPramas(grid,listFrom,listType){
    var rows = grid.grid.getSelectRows();
    var affairIds ="";
    if(rows.length <= 0) {
        // 请选择要删除的信息。
        $.alert($.i18n('infosend.listInfo.selectDeleteInfo'));
        return true;
    }
    var obj;
    var alertMsg = "";
    var alertCount = 0;
    for (var i = 0; i < rows.length; i++) {
        obj = rows[i];
        // 指定回退状态不能删除
        if(obj.affairState == '1' && obj.subState=='16') {
        	alertMsg += "<br/>&lt;" + obj.subject + "&gt;<br/>" + $.i18n('infosend.alert.cause', $.i18n("infosend.alert.flowfallback"));
        	alertCount++;
            obj.checked = false;
          //$.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
          //return true;
        }
    }
    
    if(alertCount > 0){
    	//$.alert($.i18n('collaboration.alert.CantModifyBecauseOfAppointStepBack'));
    	alertMsg = $.i18n('infosend.alert.cannotBatchDeal') + "("+alertCount+"/" + rows.length + ")<br/>" + alertMsg;
    	$.alert(alertMsg);
    	return true;
    }
    var infoList = new infoListManager();
    var confirm = $.confirm({
        // 该操作不能恢复，是否进行删除操作
        'msg': $.i18n('collaboration.confirmDelete'),
        ok_fn: function () {
            for(var count = 0 ; count < rows.length; count ++){
                if(count == rows.length -1){
                    affairIds += rows[count].affairId;
                }else{
                    affairIds += rows[count].affairId +",";
                }
            }
            var ids = affairIds.split(",");
            for(var i=0 ;i<ids.length;i++){
                infoList.deleteInfoAffair(listType,ids[i]);
            }
            //成功删除，并刷新列表
            $.messageBox({
                'title':$.i18n('collaboration.system.prompt.js'),
                'type': 0,
                'msg': $.i18n('collaboration.link.prompt.deletesuccess'),
                'imgType':0,
                ok_fn:function(){
                    $("#"+listFrom).ajaxgridLoad();
                    var totalNum = grid.p.total - 1;
                    $('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+totalNum);
                },
            	cancel_fn:function(){
            		$("#"+listFrom).ajaxgridLoad();
                    var totalNum = grid.p.total - 1;
                    $('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+totalNum);
            	}
            });
        }
    });
}
