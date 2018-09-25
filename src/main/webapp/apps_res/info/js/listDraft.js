 $(document).ready(function () {
        loadStyle();
        loadToolbar();
        loadCondition();
        loadData();
    });
 
 function loadToolbar() {
	 var listToolbars = [];
	 if(hasInfoNewRole) {
		 listToolbars.push({id: "send", name: $.i18n('infosend.draft.send'), className: "send_16 ico16", click:send });//发送
	 }
	 listToolbars.push({id: "edit", name: $.i18n('infosend.draft.updateInfo'), className: "editor_16 ico16", click:modifyRow });//修改
	 listToolbars.push({id: "delete", name: $.i18n('infosend.draft.deleteInfo'), className: "del_16 ico16", click:deleteInfo });//删除
	 listToolbars.push({id: "type", name: $.i18n('infosend.draft.classify'), className: "forwarding_16 ico16", click:classifyViews });//分类
	 listToolbars.push({id: "exportExcel", name: $.i18n('infosend.draft.exportExcel'), className: "export_excel_16 ico16", click:doExportExcel });///导出excel
	 $("#toolbars").toolbar({
		 isPager:false,
         toolbar: listToolbars
     });
 }
 
 var queryDialog;
 function classifyViews(){
	 var v = $("#listDraft").formobj({
			gridFilter: function(data, row) {
		 	return $("input:checkbox", row)[0].checked;
	 	}
	 });
	if (v.length < 1) {
		$.alert($.i18n('infosend.listInfo.selectClassInfo'));//请选择要分类的信息！
		return ;
	}
	var ids = "";
	for (i = 0; i < v.length; i++) {
		if (i != v.length - 1) {
			ids = ids + v[i].id + ",";
        } else {
        	ids = ids + v[i].id;
        }
	}
	var _url = _ctxPath + "/info/info.do?method=classifyViews&id_str=" + ids;
	queryDialog = $.dialog({
        url: _url,
        width: 250,
        height: 300,
        title: $.i18n('infosend.draft.classify'), //分类
        id:'showCategory',
        transParams:[window],
        targetWindow:getCtpTop(),
        buttons: [{
        		text:$.i18n("common.button.ok.label"),
        		btnType : 1,//按钮样式
        		handler:function(){
        			var rv = queryDialog.getReturnValue();
        			if(rv === "error"){
        				$.alert($.i18n('infosend.listInfo.selectTypeInfo')); //请选择一条信息类型！
        			}else {
	        			queryDialog.close();
	        			$("#listDraft").ajaxgridLoad();
        			}
        		}
        	},{
        		text:$.i18n("common.button.cancel.label"),
        		handler:function(){
        			queryDialog.close();
        		}
        	}
        ]
    });
 }
 
 var searchobj;
 function loadCondition() {//搜索框
     var topSearchSize = 2;
     if($.browser.msie && $.browser.version=='6.0'){
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
             }else if(choose === 'subState'){
                 o.subState = $('#subState').val();
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = listType;
                 o.condition = choose;
                 searchConditionObj = o;
                 $("#listDraft").ajaxgridLoad(o);
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
             text: $.i18n('infosend.listInfo.reportDate'),//上报日期
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
           id: "subState",
           name: 'subState',
           type: 'select',
           text: $.i18n('common.coll.state.label'),//状态
           value: 'subState',
           items: [{
               text:$.i18n("collaboration.substate.1.label"),//草稿
               value: '1'
           },{
               text: $.i18n("collaboration.substate.3.label"),//撤销
               value: '3'
           },{
             text: $.i18n("collaboration.substate.2.label"),//回退
             value: '2,16,18'
           }]
         }]
     });
  }
 
 function rend(txt, data, r, c) {
     if(c === 1){
    	 txt = "<span class='grid_black'>"+txt;
         //附件
         if(data.hasAttsFlag === true){
             txt = txt + "<span class='ico16 affix_16'></span>" ;
         }
         //信息类型
         if(data.bodyType!=="" && data.bodyType!==null && data.bodyType!=="10" && data.bodyType!=="30"){
             txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
         }
         txt = txt +"</span>";
     }
     return txt;
 }
 //加载页面数据
 var grid;
 function loadData() {
    //表格加载
     grid = $('#listDraft').ajaxgrid({
         colModel: [{
             display: 'id',
             name: 'id',
             affairState:'affairState',
             subState:'subState',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n("cannel.display.column.subject.label"),//标题
             name: 'subject',
             sortable : true,
             width: '30%'
         }, {
             display: $.i18n(unitView),//上报单位
             name: 'reportUnit',
             sortable : true,
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDept'),//上报部门
             name: 'reportDept',
             sortable : true,
             width: '13%'
         }, {
             display: $.i18n('infosend.listInfo.reportDate'),//上报日期
             name: 'reportDate',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '13%'
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
             width: '13%'
         },{
             display: $.i18n('infosend.listInfo.infoTypeName'),//信息类型
             name: 'infoTypeName',
             sortable : true,
             width: '13%'
         },{
             display: $.i18n('infosend.listInfo.subStateName'),//状态
             name: 'subStateName',
             sortable : true,
             width: '13%'
         }],
         click: clickRow,
         dblclick: dbclickRow,
         render : rend,
         showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         vChange: true,
         vChangeParam: {
             overflow: "hidden",
             autoResize:true
         },
         resizable : false,
         slideToggleBtn: true,
         managerName : "infoListManager",
         managerMethod : "getInfoDraftList"
     });
     //$('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+grid.p.total);
 }
 
 function clickRow(data, rowIndex, colIndex){
	 var _url = _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Draft&affairId="+data.affairId;
	 var title = data.subject;
	 doubleClick(_url, escapeStringToHTML(title));
     //$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Draft&affairId="+data.affairId);
 }
 
 function dbclickRow(data, rowIndex, colIndex){
     modifyRow();
 }
 
function doubleClick(url,title){
	var parmas = [$('#summary'),$('.slideDownBtn'),$('#listDraft')];
	 //getCtpTop().showSummayDialogByURL(url,title,parmas);
	showSummayDialogByURL(url,title,parmas);
}

 function deleteInfo() {
     deleteInfoByPramas(grid,"listDraft",listType);
 }
 
 function send(){
     sendFromWaitSend(grid);
 }
 
 //待发列表发送
 function sendFromWaitSend(grid) {
   var rows = grid.grid.getSelectRows();
   if(rows.length > 1){
           //只能选择一条信息进行发送！
     $.alert($.i18n('infosend.listInfo.selectOneInfoSend'));
     return;
   }
   if(rows.length < 1){
     $.alert($.i18n('infosend.listInfo.selectInfoSend')); //请选择要发送的信息!
     return;
   }
   var obj = rows[0];
   var processId = obj.processId;
   var bodyType = obj.bodyType;
   var summaryId =obj.id;
   var orgAccountId = obj.orgAccountId;
   var affairId = obj.affairId;
   $("#summaryId").val(summaryId);
   $("#affairId").val(affairId);
   var templeteId = null;
   if(obj.subState != '16'){
	    templeteId= obj.templeteId;
   }
   // 自动触发的新流程 不校验,指定回退不校验
   if(templeteId != null && templeteId != "" && obj.subState != '16'){
     if(!(checkTemplateCanUse(templeteId))){
             $.alert($.i18n('template.cannot.use'));
             return;
         }
   }
   if(!processId||processId == ""){
       $.alert($.i18n('infosend.listInfo.infoNoFlow')); //信息没有流程，请编辑后发送！
       return;
   }
   if(!$.ctx.resources.contains('F18_infoReport') && !templeteId){
        $.alert($.i18n('infosend.listInfo.infoNoReort')); //没有信息上报权限，不能发送！
        return;
   }
   var infoMan = new infoListManager();
   var isValidationColumn = infoMan.hasRequredElement(summaryId);
   if (isValidationColumn) {
       $.alert($.i18n('infosend.listInfo.infoFormRequired')); //信息上报单中有必填项，请编辑后发送！
       return;
   }
   sendFromWaitSendList(bodyType,processId,templeteId);
 }
 
//待发列表发送 抽取方法 
 function sendFromWaitSendList(bodyType,processId,templeteId){
     if(templeteId){
         isTemplate = true;
         var infoListMan = new infoListManager();
         var sflag = infoListMan.getTemplateId(templeteId);//根据模板ID去查询出流程的Id,顺便判断权限问题
         if(sflag.wflag =='cannot'){
             $.alert($.i18n('collaboration.send.fromSend.templeteDelete'));//模板已经被删除，或者您已经没有该模板的使用权限三
             return;
         }else if(sflag.wflag =='noworkflow'){
             //信息没有流程，请编辑后发送！
             $.alert($.i18n('infosend.listInfo.infoNoFlow'));
             return;
         }
         if(sflag.wflag =='isTextTemplate'){
            if(!processId){
              $.alert($.i18n('infosend.listInfo.infoNoFlow'));
                return;
            }
            processId = processId;
            preSendOrHandleWorkflow(window, '-1', '-1',processId,
                    'start', $.ctx.CurrentUser.id, '-1', $.ctx.CurrentUser.loginAccount,
                    '', 'info','', window);
         }else{
            processId = sflag.wflag;
            preSendOrHandleWorkflow(window, '-1',processId, '-1',
                    'start',$.ctx.CurrentUser.id, '-1', $.ctx.CurrentUser.loginAccount,
                    '', 'info','', window);
         }
      }else{
          if(!processId||processId == ""){
              $.alert($.i18n('infosend.listInfo.infoNoFlow'));
              return;
          }
          preSendOrHandleWorkflow(window, '-1', '-1',processId,
                  'start', $.ctx.CurrentUser.id, '-1', $.ctx.CurrentUser.loginAccount,
                   '', 'info','', window);
       }
 }
 
 function checkTemplateCanUse(templateId){
     var infoListMan = new infoListManager();  
     var strFlag = infoListMan.checkTemplateCanUse(templateId);
     if(strFlag.flag =='cannot'){
        return false;
     }else{
        return true;
     }
}
 $.content.callback.workflowNew = function() {
     $("<input type='hidden' id='workflow_node_peoples_input' name='workflow_node_peoples_input' value='"+$("#workflow_node_peoples_input",window.document)[0].value+"' />").appendTo($("#sendForm"));
     $("<input type='hidden' id='workflow_node_condition_input' name='workflow_node_condition_input' value='"+$("#workflow_node_condition_input",window.document)[0].value+"' />").appendTo($("#sendForm"));
     $("<input type='hidden' id='workflow_newflow_input' name='workflow_newflow_input' value='"+$("#workflow_newflow_input",window.document)[0].value+"' />").appendTo($("#sendForm"));
     $("#sendForm").attr("action",_ctxPath+"/info/infocreate.do?method=sendInfoDraft");
     $("#sendForm").jsonSubmit();
};
 
