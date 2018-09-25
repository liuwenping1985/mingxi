var toolbar;
//显示流程图
function showFlowChart(_contextCaseId,_contextProcessId,_templateId,_contextActivityId){
    var showHastenButton='true';
    var supervisorsId="";
    var isTemplate=false;
    var operationId="";
    var senderName="";
    var openType=getA8Top();
    if(_templateId&&"undefined"!=_templateId){
        isTemplate=true;
    }
    showWFCDiagram(openType,_contextCaseId,_contextProcessId,isTemplate,showHastenButton,supervisorsId,window, 'collaboration', false ,_contextActivityId,operationId,'' ,senderName);
}
//回调函数
function rend(txt, data, r, c) {
    if(c === 1){
    	//标题列加深
	    txt="<span class='grid_black'>"+txt+"</span>";
        //加图标
        //重要程度
        if(data.importantLevel !==""&& data.importantLevel !== 1){
            txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
        }
        //附件
        if(data.hasAttsFlag === true){
            txt = txt + "<span class='ico16 affix_16'></span>" ;
        }
        //表单授权
        if(data.showAuthorityButton){
            txt = txt + "<span class='ico16 authorize_16'></span>";
        }
        //协同类型
        if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
            txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
        }
        //流程状态
        if(data.state !== null && data.state !=="" && data.state != "0"){
            txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
        }
        return txt;
    }else if(c===3){
    	var titleTemp=txt;
    	txt=txt.replace("...","");
        return "<a href='javascript:void(0)' title='"+titleTemp+"' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\")'>"+txt+"</a>";
    }else if(c === 4){
        if(data.processIsCoverTime){
            var title = $.i18n('collaboration.listsent.overtime.title');
            txt = "<span class='color_red' title='"+title+"'>"+txt+"</span>";
        }else{
            var title = $.i18n('collaboration.listsent.overtime.no.title');
            txt = "<span title='"+title+"'>"+txt+"</span>";
        }
        return txt;
    }else if(c === 5){
        //添加跟踪的代码
        if(txt === null || txt === false){
            return "<a href='javascript:void(0)' class='noClick' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.trackType+" senderId="+data.startMemberId+">"+$.i18n('message.no.js')+"</a>";
        }else{
            return "<a href='javascript:void(0)' class='noClick' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.trackType+" senderId="+data.startMemberId+">"+$.i18n('message.yes.js')+"</a>";
        }
    }else if (c === 6){
        return "<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)'></a>";
        }else{
            return txt;
        }
   }     
    
    
    
function transmitCol(){
    transmitColFromGrid(grid);
}

//重复发起
function resendColl(){
    resend(grid);
}
//编辑流程
function editWorkFlow(){
	var affairId = "";
	var id_checkbox = grid.grid.getSelectRows();
	if (id_checkbox.length === 1) {
		var selRow = id_checkbox[0]; 
	    affairId = selRow.affairId;
	}
	var ajaxColManager = new colManager();
    var bean = new Object();
    bean["affairId"] = affairId; 
    _designWorkflow(grid,function(){
    	ajaxColManager.transUpdateCurrentInfo(bean);
   	 	try{
   	 		$("#listSent").ajaxgridLoad();
   	 	}catch(e){
   	 	}
   	});
}
//置灰ToolBar
function disabledToolbar() {
    toolbar.disabled("transmit");
    //归档
    if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
        toolbar.disabled("pigeonhole");
    }
    toolbar.disabled("cancelWorkFlow");
    toolbar.disabled("editWorkFlow");
    toolbar.disabled("resend");
    toolbar.disabled("delete");
    toolbar.disabled("relationAuthority");
}
function enabledToolbar(){
    toolbar.enabled("transmit");
    //归档
    if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
        toolbar.enabled("pigeonhole");
    }
    toolbar.enabled("cancelWorkFlow");
    toolbar.enabled("editWorkFlow");
    toolbar.enabled("resend");
    toolbar.enabled("delete");
    toolbar.enabled("relationAuthority");
}
//撤销流程
function cancelWorkFlow(){
	//js事件接口
	var sendDevelop = $.ctp.trigger('beforeSentCancel');
	if(!sendDevelop){
		 return;
	}
	
    disabledToolbar();
    var id_checkbox = grid.grid.getSelectRows();
    if (id_checkbox.length === 0) {
        //请选择需要撤销的协同！
        $.alert($.i18n('collaboration.listSent.selectRevokeSyn'));
        enabledToolbar();
        return;
    }
    if(id_checkbox.length > 1){
        //只能选择一条记录!
        $.alert($.i18n('collaboration.listSent.selectOneData'));
        enabledToolbar();
        return;
    }
    var selRow = id_checkbox[0];
    var affairId = selRow.affairId;
    var summaryId = selRow.summaryId;
    var processId = selRow.processId;
    //校验开始
    var _colManager = new colManager();
    var params = new Object();
    params["summaryId"] = summaryId;
    //校验是否流程结束、是否审核、是否核定，涉及到的子流程调用工作流接口校验
    var canDealCancel = _colManager.checkIsCanRepeal(params);
    if(canDealCancel.msg != null){
        $.alert(canDealCancel.msg);
        enabledToolbar();
        return;
    }

    if(!isAffairValid(affairId)) {
        enabledToolbar();
    	return;
    }
    //调用工作流接口校验是否能够撤销流程 
    var repeal = canRepeal('collaboration',processId,'start');
    //不能撤销流程
    if(repeal[0] === 'false'){
        $.alert(repeal[1]);
        enabledToolbar();
        return;
    }
    var lockWorkflowRe = lockWorkflow(selRow.processId, $.ctx.CurrentUser.id, 12);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        enabledToolbar();
        return;
    }
    
    if(!executeWorkflowBeforeEvent("BeforeCancel",summaryId,affairId,processId,processId,"","","")){
        enabledToolbar();
    	return;
	}
    
    //撤销流程
    var dialog = $.dialog({
        url: _ctxPath + "/workflowmanage/workflowmanage.do?method=showRepealCommentDialog&affairId="+affairId,
        width:450,
        height:240,
        bottomHTML:'<label for="trackWorkflow" class="margin_t_5 hand">'+
        			'<input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">'+$.i18n("collaboration.workflow.trace.traceworkflow")+
        			'</label><span class="color_blue hand" style="color:#318ed9;" title="'+$.i18n("collaboration.workflow.trace.summaryDetail2")+
        			'">['+$.i18n("collaboration.workflow.trace.title")+']</span>',
        title:$.i18n('common.repeal.workflow.label'),//撤销流程
        targetWindow:getCtpTop(),
        buttons : [ {
            text : $.i18n('collaboration.button.ok.label'),//确定
            btnType:1,
            handler : function() {
        	  enabledToolbar();
              var returnValue = dialog.getReturnValue();
              if (!returnValue){
                  return ;
              }
              //alert(returnValue[1]);
              //return;
              var ajaxSubmitFunc =function(){
                  var ajaxColManager = new colManager();
                  var tempMap = new Object();
                  tempMap["repealComment"] = returnValue[0];
                  tempMap["summaryId"] = summaryId; 
                  tempMap["affairId"] = affairId;
                  tempMap["trackWorkflowType"] =  returnValue[1];
                  ajaxColManager.transRepal(tempMap, {
                      success: function(msg){
                          if(msg==null||msg==""){
                              $("#summary").attr("src","");
                              $(".slideDownBtn").trigger("click");
                              $("#listSent").ajaxgridLoad();
                              $.ajax({
	  								url : "/seeyon/collaboration/collaboration.do?method=revoke",
	  								data : {summaryId : summaryId},
	  								success : function(data){
	  									$("#exchangeDetail").ajaxgridLoad();
	  								}
	  							});
                          }else{
                            $.alert(msg);
                          }
                          //撤销后关闭，子页面
                          try{closeOpenMultyWindow(affairId);}catch(e){};
                      }
                  });
              }
              //V50_SP2_NC业务集成插件_001_表单开发高级
              beforeSubmit(affairId,"repeal", returnValue[0],dialog,ajaxSubmitFunc,null);
              dialog.close();
            }
          }, {
            text : $.i18n('collaboration.button.cancel.label'),//取消
            handler : function() {
                enabledToolbar();
                releaseWorkflowByAction(selRow.processId, $.ctx.CurrentUser.id, 12);
                dialog.close();
            }
          } ],
          closeParam:{
            show:true,
            handler:function(){
                enabledToolbar();
                releaseWorkflowByAction(selRow.processId, $.ctx.CurrentUser.id, 12);
            }
          }
      });
}  

 //删除
function deleteCol(){
    deleteItems('sent',grid,'listSent',paramMethod);
}
 //定义setTimeout执行方法
var TimeFn = null;
var openCount = 0;
//定义单击事件
function clickRow(data,rowIndex, colIndex) {
	openCount++;
	if(openCount>1){
		return;
	}
	setTimeout(function(){
		openCount = 0; 
	},2000) ;
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    //执行延时
    if(!isAffairValid(data.affairId)){
        $("#listSent").ajaxgridLoad();
        $(".spiretBarHidden3").trigger("click");
        return;
    }
    TimeFn = setTimeout(function(){
        $('#summary').attr("src","collaboration.do?method=summary&openFrom=listSent&affairId="+data.affairId);
    },300);
}
//双击事件
function dbclickRow(data,rowIndex, colIndex){
	openCount++;
	if(openCount>1){
		return;
	}
	setTimeout(function(){
		openCount = 0; 
	},2000) ;
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    if(!isAffairValid(data.affairId)){
        $("#listSent").ajaxgridLoad();
        return;
    }
    var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId="+data.affairId;
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listSent&size="+grid.p.total+"&r=" + Math.random());
}


//表单授权
function relationAuthority(){
    var id_checkbox = grid.grid.getSelectRows();
    if (!id_checkbox){
        return;
    }
    var len=id_checkbox.length;
    if (len === 0) {
        //请选择要关联授权的协同!
        $.alert($.i18n('collaboration.listSent.selectAuthorized'));
        return;
    }
    var moduleIds=new Array();
    var affairIds=new Array();
    for (var i = 0; i < len; i++) {       
        if(parseInt(id_checkbox[i].bodyType) !== 20){
            //只能对表单模板进行关联授权!
            $.alert($.i18n('collaboration.listSent.onlyFromAuthorized'));
            return;
        }
        moduleIds.push(id_checkbox[i].summaryId);
        affairIds.push(id_checkbox[i].affairId);
    }
    setRelationAuth(moduleIds,1,function(flag){
         var colM = new colManager();           
         var param = new Object();
         param.affairIds = affairIds;
         param.flag = flag;
         colM.updateAffairIdentifierForRelationAuth(param, {
             success: function(){
                $("#listSent").ajaxgridLoad();
             }
         });
    });
}
         
         
var zzGzr='';
var grid;
$(document).ready(function () {
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
    var submenu = new Array();
    //判断是否有新建协同的资源权限，如果没有则屏蔽转发协同
    if ($.ctx.resources.contains('F01_newColl')) {
        //协同
        submenu.push({name: $.i18n('collaboration.transmit.col.label'),click: transmitCol });
    };
    //判断是否有转发邮件的资源权限，如果没有则屏蔽转发协同
    if ($.ctx.resources.contains('F12_mailcreate')) {
        //邮件
    	if (!emailNotShow) {
           submenu.push({name: $.i18n('collaboration.transmit.mail.label'),click: transmitMail });
    	}
    };
    var toolbarArray = new Array();
    //转发
   // toolbarArray.push({id: "transmit",name:  $.i18n('collaboration.transmit.label'),className: "ico16 forwarding_16",subMenu: submenu});
    //归档
    if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
        toolbarArray.push({id: "pigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click: function(){doPigeonhole("sent", grid, "listSent");}});
    }
    //撤销流程
    toolbarArray.push({id: "cancelWorkFlow",name: $.i18n('common.repeal.workflow.label'),className: "ico16 revoked_process_16",click:cancelWorkFlow});
    //编辑流程
   // toolbarArray.push({id: "editWorkFlow",name: $.i18n('common.design.workflow.label'),className: "ico16 process_16",click:editWorkFlow});
    //重复发起
    //toolbarArray.push({id: "resend",name: $.i18n('common.toolbar.resend.label'),className: "ico16 repeat_launched_16",click:resendColl});
    //删除
   // toolbarArray.push({id: "delete",name: $.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteCol});
    //表单授权(安装了表单高级插件才有表单授权)
    if (isFormAdvanced == "true") {
      //  toolbarArray.push({id: "relationAuthority",name: $.i18n('common.toolbar.relationAuthority.label'),className: "ico16 authorize_16",click:relationAuthority});
    }
    
    //toolbar扩展
    for (var i = 0;i<addinMenus.length;i++) {
        toolbarArray.push(addinMenus[i]);
    }
    //工具栏
    toolbar = $("#toolbars").toolbar({
        toolbar: toolbarArray
    });
    
    //搜索框
    var topSearchSize = 2;
    if($.browser.msie && $.browser.version=='6.0'){
        topSearchSize = 5;
    }
    var searchobj = $.searchCondition({
        top:topSearchSize,
        right:10,
        searchHandler: function(){
            var o = new Object();
            var templeteIds = $.trim(_paramTemplateIds);
            if(templeteIds != ""){
                o.templeteIds = templeteIds;
            }
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            if(choose === 'subject'){
                o.subject = $('#title').val();
            }else if(choose === 'importantLevel'){
                o.importantLevel = $('#importent').val();
            }else if(choose === 'createDate'){
                var fromDate = $('#from_datetime').val();
                var toDate = $('#to_datetime').val();
                var date = fromDate+'#'+toDate;
                o.createDate = date;
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
            }else if(choose === 'deadlineDatetime'){//流程期限
            	o.deadlineDatetime=$('#deadlineDatetime').val();
                var fromDate = $('#from_deadlineDatetime').val();
                var toDate = $('#to_deadlineDatetime').val();
                var date = fromDate+'#'+toDate;
                o.deadlineDatetime = date;
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
            }else if(choose === 'state'){ //流程状态
            	o.workflowState=$('#workflowState').val();
            }else if(choose === 'receiver'){
            	 o.receiver = $('#receiver').val();
            }
            var val = searchobj.g.getReturnValue();
            if(window.location.href.indexOf("condition=templeteAll&textfield=all") != -1){
        		o.templeteAll="all";
        	}
            if(val !== null){
                $("#listSent").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(_summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src","collaboration.do?method=listDesc&type=listSent&size="+grid.p.total+"&r=" + Math.random());	
                	},1000);
                }
            }
        },
        conditions: [{
            id: 'title',
            name: 'title',
            type: 'input',
            text: $.i18n("cannel.display.column.subject.label"),//标题
            value: 'subject',
            maxLength:100
        },{
            id: 'importent',
            name: 'importent',
            type: 'select',
            text: $.i18n("common.importance.label"),//重要程度
            value: 'importantLevel',
            items: [{
                text:  $.i18n("common.importance.putong"),//普通
                value: '1'
            }, {
                text:  $.i18n("common.importance.zhongyao"),//重要
                value: '2'
            }, {
                text:  $.i18n("common.importance.feichangzhongyao"),//非常重要
                value: '3'
            }]
        },{
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: $.i18n("common.date.sendtime.label"),//发起时间
            value: 'createDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        },{
        	id:'deadlineDatetime',
        	name:'deadlineDatetime',
        	type:'datemulti',
        	text:$.i18n("collaboration.process.cycle.label"),
        	value:'deadlineDatetime',
        	ifFormat:'%Y-%m-%d',
        	dateTime:false
        },{
        	id:'workflowState',
        	name:'workflowState',
        	type:'select',
        	text:'流程状态',
        	value: 'state',
            items:[{
            	text:$.i18n("collaboration.unend"),
            	value:'0'
            },{
            	text:$.i18n("collaboration.ended"),
            	value:'1'
            },{
            	text:$.i18n("collaboration.terminated"),
            	value:'2'
            }]
            },{
            	id:'receiver',
            	name:'receiver',
            	type:'input',
            	text:$.i18n("collaboration.listsent.receiver.label"),
            	value:'receiver'
        }]
    });
    //表格加载
        grid = $('#listSent').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '4%',
            type: 'checkbox'
        }, {
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '39%'
        }, {
            display:  $.i18n("common.date.sendtime.label"),//发起时间
            name: 'startDate',
            sortable : true,
            width: '12%'
        },{
            display:  $.i18n("collaboration.list.currentNodesInfo.label"),//当前处理人
            name: 'currentNodesInfo',
            sortable : true,
            width: '10%'
        },{
            display: $.i18n("collaboration.process.cycle.label"),//流程期限
            name: 'processDeadLineName',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("collaboration.isTrack.label"),//跟踪状态
            name: 'isTrack',
            sortable : true,
            width: '10%'                  
        }, {
            display: $.i18n("processLog.list.title.label"),//流程日志
            name: 'processId',
            width: '10%'
        }],
        click: dbclickRow,//clickRow
        dblclick: dbclickRow,
        render : rend,
        height: 200,
        rpMaxSize : 999,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        managerName : "colManager",
        managerMethod : "getSentList"
    });
    
    
    //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listSent&size="+grid.p.total+"&r=" + Math.random());
    //跟踪弹出框js
    $("#gz").change(function () {
        var value = $(this).val();
        var _gz_ren = $("#gz_ren");
        switch (value) {
            case "0":
                _gz_ren.hide();
                break;
            case "1":
                _gz_ren.show();
                break;
        }
    });
  
    $("#radio4").bind('click',function(){
     $.selectPeople({
            type:'selectPeople'
            ,panels:'Department,Team,Post,Outworker,RelatePeople'
            ,selectType:'Member'
            ,text:$.i18n('common.default.selectPeople.value')
            ,showFlowTypeRadio: false
            ,returnValueNeedType: false
            ,params:{
               value: zzGzr
            }
            ,targetWindow:getCtpTop()
            ,callback : function(res){
                if(res && res.obj && res.obj.length>0){
                        $("#zdgzry").val(res.value);
                }
            }
        });
   });
    
   
    
});