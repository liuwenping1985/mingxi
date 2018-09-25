 $(document).ready(function () {
        loadStyle();
        loadToolbar();
        loadCondition();
        loadData();
        loadLocation();
 });
 function loadLocation() {
	 parent.initInfoLeftLocation(listType);
 }
 function loadToolbar() {
     $("#toolbars").toolbar({
    	 isPager:false,
         toolbar: [{
             id: "revoked",
             name: $.i18n('infosend.listInfo.revoked'),//撤销
             className: "ico16 revoked_process_16",
             click:cancelWorkFlow
         },{
             id: "filing",
             name:$.i18n("infosend.listInfo.file"),//归档
             className: "ico16 filing_16",
             click:checkArchive
         },{
             id: "delete",
             name:$.i18n("infosend.listInfo.deleteInfo"),//删除
             className: "ico16 del_16",
             click:deleteInfo
         },{
             id: "exportExcel",
             name: $.i18n('infosend.draft.exportExcel'),//导出excel
             className: "ico16 export_excel_16", // click:exportExcel
             click:doExportExcel
         }]
     });
 }
 
 var searchobj;
 function loadCondition() {//搜索框
     var topSearchSize = 2;
     if($.browser.msie && $.browser.version=='6.0') {
         topSearchSize = 5;
     }
     searchobj = $.searchCondition({
         top:topSearchSize,
         right:85,
         searchHandler: function(){
             var o = new Object();
             var choose = $('#'+searchobj.p.id).find("option:selected").val();
             if(choose === 'subject'){
                 o.subject = $('#subject').val();
             }else if(choose === 'reportUnit'){
                 o.reportUnit = $('#reportUnit').val();
             }else if(choose === 'reportDept'){
                 o.reportDept = $('#reportDept').val();
             }else if(choose === 'reportDate'){
                 var fromDate = $('#from_reportDate').val();
                 var toDate = $('#to_reportDate').val();
                 if(fromDate != "" && toDate != "" && fromDate > toDate){
                     $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
                     return;
                 }
                 var date = fromDate+'#'+toDate;
                 o.reportDate = date;
             }else if(choose === 'publishState'){
                 o.publishState = $('#publishState').val();
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = listType;
                 o.condition = choose;
                 searchConditionObj = o;
                 $("#listSend").ajaxgridLoad(o);
             }
         },
         conditions: [{
             id: 'subject',
             name: 'subject',
             type: 'input',
             text: $.i18n("cannel.display.column.subject.label"),//标题
             value: 'subject',
             maxLength:100
         },{
             id: 'reportDate',
             name: 'reportDate',
             type: 'datemulti',
             text: $.i18n('infosend.listInfo.reportDate'),//上报时间
             value: 'reportDate',
             ifFormat:'%Y-%m-%d',
             dateTime: false
         },{
             id: 'reportUnit',
             name: 'reportUnit',
             type: 'input',
             text: $.i18n(unitView),//上报单位
             value: 'reportUnit',
             maxLength:100
         },{
             id: 'reportDept',
             name: 'reportDept',
             type: 'input',
             text: $.i18n('infosend.listInfo.reportDept'),//上报部门
             value: 'reportDept',
             maxLength:100
         },{
           id: "publishState",
           name: 'publishState',
           type: 'select',
           text: $.i18n('common.coll.state.label'),//状态
           value: 'publishState',
           items: [{
               text:$.i18n("infosend.label.reportSent"),//已上报
               value: '1'
           },{
             text: $.i18n("infosend.listInfo.scored"),//已评分
             value: '3'
           }]
         }]
     });
  }
 //加载页面数据
 var grid;
 function loadData() {
    //表格加载
     grid = $('#listSend').ajaxgrid({
         colModel: [{
             display: 'id',
             name: 'id',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n("cannel.display.column.subject.label"),//标题
             name: 'subject',
             sortable : true,
             width: '39%'
         }, {
             display: $.i18n(unitView),//上报单位
             name: 'reportUnit',
             hide:true,
             sortable : true,
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDept'),//上报部门
             name: 'reportDept',
             hide:true,
             sortable : true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDate'),//上报日期
             name: 'reportDate',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.flowlimit'),//流程期限
             name: 'flowLimit',
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reporter'),//上报人
             name: 'reporter',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.listInfo.rsEditor'),//责任编辑
             name: 'rsEditor',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.listInfo.infoTypeName'),//信息类型
             name: 'infoTypeName',
             sortable : true,
             width: '13%'
         },{
             display: $.i18n("infosend.listInfo.subStateName"),//状态
             name: 'publishName',
             sortable : true,
             width: '13%'
         },{
             display: $.i18n("infosend.listInfo.score.scoreAutoMatic"),//系统积分
             name: 'scoreAutoMatic',
             sortable : true,
             width: '10%'
         },{
             display: $.i18n("infosend.listInfo.score.scoreManual"),//手工评分
             name: 'scoreManual',
             sortable : true,
             width: '10%'
         },{
             display: $.i18n("infosend.listInfo.score.scoreTotal"),//总分
             name: 'scoreTotal',
             sortable : true,
             width: '10%'
         },{
             display: $.i18n("infosend.label.usingState"),//采用状态
             name: 'publishState',
             hide:true,
             sortable : true,
             width: '10%'
         }],
         click: dblclickRow,
         //dblclick: dbclickRow,
         render : rend,
         showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         vChange: false,
         vChangeParam: {
             overflow: "hidden",
             autoResize:true
         },
         resizable : false,
         slideToggleBtn: true,
         managerName : "infoListManager",
         managerMethod : "getInfoSendList"
     });
     //页面底部说明加载
     //$('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+grid.p.total);
 }
 
 var TimeFn = null;
 function clickRow(data, rowIndex, colIndex){
	 clearTimeout(TimeFn);
	 
	 TimeFn = setTimeout(function() {
		 $('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
	 },400);
 }
 function dblclickRow(data, rowIndex, colIndex) {
	 if(colIndex == 10 || colIndex == 11) {
		 return;
	 }
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 
	 var _url = _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId;
	 //$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
	 var title = data.subject;
	 doubleClick(_url,escapeStringToHTML(title));
	 grid.grid.resizeGridUpDown('down');
 }
function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listSend')];
	 //getCtpTop().showSummayDialogByURL(url,title,parmas);
	 showSummayDialogByURL(url,title,parmas);
}

function deleteInfo() {
    deleteInfoByPramas(grid,"listSend",listType);
}
function rend(txt, data, r, c) {
    if(c === 1){
    	txt = "<span class='grid_black'>"+txt;
        //附件
        if(data.hasAttsFlag === true){
            txt = txt + "<span class='ico16 affix_16'></span>" ;
        }
        //信息类型
        if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
            txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
        }
        //流程状态
        if(data.state !== null && data.state !=="" && data.state != "0"){
            txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
        }
        txt = txt +"</span>";
    }
    
    if(c === 5){
    	if(txt.indexOf("extended|") != -1){
    		txt = txt.replace("extended\|", "");
        	txt = "<font color=\"red\" title=\""+$.i18n('infosend.label.processExtended')+"\">" + txt + "</font>";
    	}else{
    		txt = "<span title=\""+$.i18n('infosend.label.processNotExtended')+"\">" + txt + "</span>";
    	}
    }
    
    if(c == 10) {//自动评分
		 txt = "<a class='scoreA color_blue' onClick='openInfoScoreAutoMaticRecord(\""+data.id+"\")'>" + txt + "</a>" ;
	 } else if(c == 11) {//手工评分
		 txt = "<a class='scoreA color_blue' onClick='openInfoScoreManualRecord(\""+data.id+"\")'>" + txt + "</a>" ;
	 }
    
    if(c == 13){//引用状态修改
    	if(data.publishState == 1){
    		txt = $.i18n("infosend.label.usingState.used");//已采用
    	}else{
    		txt = $.i18n("infosend.label.usingState.notUsed");//未采用
    	}
    }
    return txt;
}

//撤销流程
function cancelWorkFlow(){
  var id_checkbox = grid.grid.getSelectRows();
  if (id_checkbox.length === 0) {
      //请选择需要撤销的协同！
      $.alert($.i18n('infosend.listInfo.selectCancelInfo'))
      return;
  }
  if(id_checkbox.length > 1){
      //只能选择一条记录!
      $.alert($.i18n('infosend.listInfo.selectOneInfoCancel'));
      return;
  }
  var selRow = id_checkbox[0];
  var affairId = selRow.affairId;
  var summaryId = selRow.id;
  var processId = selRow.processId;
  var checkIsCanBeRepealedFlg = checkIsCanBeRepealed(summaryId);
  if(checkIsCanBeRepealedFlg && "Y" != checkIsCanBeRepealedFlg && "" != checkIsCanBeRepealedFlg) {
	  $.alert(checkIsCanBeRepealedFlg);
      return;
  }
  var lockWorkflowRe = lockWorkflow(processId, $.ctx.CurrentUser.id, 12);
  if(lockWorkflowRe[0] == "false"){
      $.alert(lockWorkflowRe[1]);
      return;
  }
  //校验开始
  var _infoListManager = new infoListManager();
  var params = new Object();
  params["summaryId"] = summaryId;
  //撤销流程
  var dialog = $.dialog({
      url: _ctxPath + "/workflowmanage/workflowmanage.do?method=showRepealCommentDialog&openFromFlag=infoFlag",
      width:450,
      height:240,
      title:$.i18n('common.repeal.workflow.label'),//撤销流程
      targetWindow:getCtpTop(),
      buttons : [ {
          text : $.i18n('collaboration.button.ok.label'),//确定
          btnType : 1,//按钮样式
          handler : function() {
            var returnValue = dialog.getReturnValue();
            if (!returnValue){
                return ;
            }
            var ajaxSubmitFunc =function(){
                var tempMap = new Object();
                tempMap["repealComment"] = returnValue[0];
                tempMap["summaryId"] = summaryId; 
                tempMap["affairId"] = affairId;
                _infoListManager.transRepal(tempMap, {
                    success: function(msg){
                        if(msg==null||msg==""){
                            $("#summary").attr("src","");
                            $(".slideDownBtn").trigger("click");
                            $("#listSend").ajaxgridLoad();
                        }else{
                          $.alert(msg);
                        }
                    }
                });
            }
            ajaxSubmitFunc();
            dialog.close();
          }
        }, {
          text : $.i18n('collaboration.button.cancel.label'),//取消
          handler : function() {
              releaseWorkflowByAction(selRow.processId, $.ctx.CurrentUser.id, 12);
              dialog.close();
          }
        } ],
        closeParam:{
          show:true,
          handler:function(){
              releaseWorkflowByAction(selRow.processId, $.ctx.CurrentUser.id, 12);
          }
        }
    });
}  


function checkIsCanBeRepealed(summaryId) {
	var isCanBeRepealedFlag;
	var im = new infoManager();
	var object = new Object();
	object.summaryId = summaryId;
	var map = im.checkIsCanRepeal(object);
	return map!=null && map["msg"];
}
