//显示流程图
function showFlowChart(_contextCaseId,_contextProcessId,_templateId,_contextActivityId){
    var showHastenButton='false';
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
function rend(txt, data, r, c) {	
	if(c === 1){
		//标题列加深
	    txt="<span class='grid_black'>"+txt+"</span>";
	    //如果是代理 ，颜色变成蓝色
	    if(data.proxy){
	        txt = "<span class='color_blue'>"+txt+"</span>";
	    }
	    //加图标
	    //重要程度
	    if(data.importantLevel !==""&& data.importantLevel !== 1){
	        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
	    }
	    //附件
	    if(data.hasAttsFlag === true){
	        txt = txt + "<span class='ico16 affix_16'></span>" ;
	    }
	    //协同类型
	    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
	        txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
	    }
	    //流程状态
	    if(data.state !== null && data.state !=="" && data.state != "0"){
	        txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
	    }
	    //如果设置了处理期限(节点期限),添加超期图标
	    if(data.deadLineDate != null && data.deadLineDate !=="" && data.deadLineDate != "0"){
	        if(data.isCoverTime){
	            //超期图标
	            txt = txt + "<span class='ico16 extended_red_16'></span>" ;
	        }else{
	            //未超期图标
	            txt = txt + "<span class='ico16 extended_blue_16'></span>" ;
	        }
	    }
	    return txt;
	}else if(c===5){
	    var txt = txt.replace("...","");
    	return "<a href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\")'>"+txt+"</a>";
    }else if(c === 7){
	    //添加跟踪的代码
	    if(txt === null || txt === false){
	        return "<a href='javascript:void(0)' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.track+" senderId="+data.startMemberId+">"+$.i18n('message.no.js')+"</a>";
	    }else{
	        return "<a href='javascript:void(0)' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.track+" senderId="+data.startMemberId+">"+$.i18n('message.yes.js')+"</a>";
	    }
	}else if (c === 8){
	    return "<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)'></a>";
    }else{
        return txt;
    }
    return txt;
}
function createReissue(summaryId){
	$.selectPeople({
        panels: 'Account,Department',
        selectType: 'Account,Department',
        hiddenPostOfDepartment:true,//隐藏岗位
        showAllOuterDepartment:true,//显示所有外部单位
        isCanSelectGroupAccount:false,//是否可选集团单位
        unallowedSelectEmptyGroup:true,//不允许为空
        callback : function(ret) {
        	$.ajax({
        		type:"post",
        		url : "/seeyon/collaboration/collaboration.do?method=createReissue",
    			data : {summaryId : summaryId,danwei:ret.value.toString()},
    			success:function(data){
    				if(data=="1"){
    					alert("补发成功");
    				}
    			}
        	});
        }
    });
        
}
function showDistributeState(summaryId){
	var dialog = $.dialog({
        url : "/seeyon/collaboration/collaboration.do?method=showDistributeState&summaryId=" + summaryId,
        width : 1000,
        height : 400,
        title : '分办状态',
        targetWindow:getCtpTop(),
        buttons : [{
            text : $.i18n('collaboration.button.close.label'),
            handler : function() {
              dialog.close();
            }
        }]
    });
}

  //删除
function deleteCol(){
    deleteItems('finish',grid,'listDone',paramMethod);
}
   
function transmitCol(){
    transmitColFromGrid(grid);
}



 //取回
function takeBack() {
	//js事件接口
	var sendDevelop = $.ctp.trigger('beforeDoneTakeBack');
	  if(!sendDevelop){
		 return;
	  }
	
    var rows = grid.grid.getSelectRows();
    if (rows.length === 0) {
        //请选择要取回的协同!
        $.alert($.i18n('collaboration.listDone.selectBack'));
        return;
    }
    if (rows.length > 1) {
        //只能选择一项协同进行取回!
        $.alert($.i18n('collaboration.listDone.selectOneBack'));
        return;
    }
    if(!isAffairValid(rows[0].affairId)) {
        $("#listDone").ajaxgridLoad();
        return;
    }
    /**
     * 是否允许取回
     * 返回值是一个js对象，有以下属性
     * canTakeBack 是否允许取回
     * state:
     *  -1表示程序或数据发生异常,不可以取回
     *  0表示正常状态,可以取回
     *  1表示当前流程已经结束,不可以取回
     *  2表示后面节点任务事项已处理完成,不可以取回
     *  3表示当前节点触发的子流程已经结束,不可以取回
     *  4表示当前节点触发的子流程中已核定通过,不可以取回
     *  5表示当前节点是知会节点,不可以取回
     *  6表示当前节点为核定节点,不可以取回
     *  7表示当前节点为封发节点，不可以取回
     */
    var workitemId = rows[0].workitemId;
    var processId = rows[0].processId;
    var caseId = rows[0].caseId;
    var appName = "collaboration";
    var nodeId = rows[0].activityId;
    var isForm = (rows[0].bodyType=='20');
    var canTakeBackObj = canTakeBack(workitemId, processId, nodeId, null, caseId, appName, isForm);
    if(canTakeBackObj !=null && !canTakeBackObj.canTakeBack){
        var msg = 'collaboration.takeBackErr.'+canTakeBackObj.state+'.msg';
        $.alert($.i18n(msg));
        //$("#listDone").ajaxgridLoad();
        return;
    }

    var lockWorkflowRe = lockWorkflow(processId, $.ctx.CurrentUser.id, 13);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        return;
    }
    
    if(!executeWorkflowBeforeEvent("BeforeTakeBack",rows[0].summaryId,rows[0].affairId,processId,processId,nodeId,"",appName)){
    	return;
    }
    
    var dialog = $.dialog({
        url: _ctxPath + "/collaboration/collaboration.do?method=showTakebackConfirm",
        width: 350,
        height: 160,
        targetWindow:getCtpTop(),
        title: $.i18n('collaboration.system.prompt.js'),
        buttons: [{
            text: $.i18n('collaboration.pushMessageToMembers.confirm'),
            handler: function () {
                var rv = dialog.getReturnValue();
                if (rv) {
                	
                	var ajaxSubmitFunc = function(){
                    	var saveOpinion = (rv !="1");
                        var ajaxColManager = new colManager();
                        var takeBackBean = new Object();
                        takeBackBean["affairId"] = rows[0].affairId;
                        takeBackBean["isSaveOpinion"] = saveOpinion;                    
                        ajaxColManager.transTakeBack(takeBackBean, {
                            success: function(msg){
                                if(msg==null||msg==""){
                                    $("#summary").attr("src","");
                                    $(".slideDownBtn").trigger("click");
                                    $("#listDone").ajaxgridLoad();
                                }else{
                                    $.alert(msg);
                                }
                                //撤销后关闭，子页面
                                try{closeOpenMultyWindow(rows[0].affairId);}catch(e){};
                            }
                        });
                        setTimeout(function(){ajaxColManager.transUpdateCurrentInfo(takeBackBean);},300);
                    }
                	
                   //V50_SP2_NC业务集成插件_001_表单开发高级
	               beforeSubmit(rows[0].affairId,"takeback","",dialog,ajaxSubmitFunc);
	               
                }
                dialog.close();
            }
        }, {
            text: $.i18n('collaboration.pushMessageToMembers.cancel'),
            handler: function () {
                releaseWorkflowByAction(processId, $.ctx.CurrentUser.id, 13);
                dialog.close();
            }
        }],
        closeParam:{
            show:true,
            handler:function(){
                releaseWorkflowByAction(processId, $.ctx.CurrentUser.id, 13);
            }
          }
    });
}


//定义setTimeout执行方法
var TimeFn = null;
var openCount = 0;
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
    if(!isAffairValid(data.affairId)){
        $("#listDone").ajaxgridLoad();
        return;
    }
    //执行延时
    TimeFn = setTimeout(function(){
        $('#summary').attr("src","collaboration.do?method=summary&openFrom=listDone&affairId="+data.affairId);
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
        $("#listDone").ajaxgridLoad();
        return;
    }
    var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId="+data.affairId;
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listDone&size="+grid.p.total+"&r=" + Math.random());
}


var zzGzr='';
var grid='';
var isFirstClickRow=true;
var searchobj;
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
   // toolbarArray.push({id: "transmit",name: $.i18n('collaboration.transmit.label'),className: "ico16 forwarding_16",subMenu: submenu});
    //归档
    if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
      //  toolbarArray.push({id: "pigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click: function(){doPigeonhole("done", grid, "listDone");}});
    }
    //删除
    //toolbarArray.push({id: "delete",name:$.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteCol});
    //取回
    toolbarArray.push({id: "takeBack",name: $.i18n('common.toolbar.takeBack.label'),className: "ico16 retrieve_16",click:takeBack});
    //同一流程只显示最后一条
    //toolbarArray.push({id: "deduplication",type: "checkbox",checked:false,text: $.i18n('collaboration.portal.listDone.isDeduplication'),value:"1",click:debupCol});
    //toolbar扩展
    for (var i = 0;i<addinMenus.length;i++) {
        toolbarArray.push(addinMenus[i]);
    }
    //工具栏
    $("#toolbars").toolbar({
        toolbar: toolbarArray
    });
    //搜索框
    var topSearchSize = 2;
    if($.browser.msie && $.browser.version=='6.0'){
        topSearchSize = 5;
    }
    searchobj = $.searchCondition({
        top:topSearchSize,
        right:50,
        searchHandler: function(){
            var o = new Object();
            //同一流程只显示最后一条
            o.deduplication = "false";
            var isDedupCheck =  $("#deduplication").attr("checked");
            if (isDedupCheck) {
                o.deduplication = "true"; 
            }
            var templeteIds = $.trim(_paramTemplateIds);
            if(templeteIds != ""){
                o.templeteIds = templeteIds;
            }
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            if(choose === 'subject'){
                o.subject = $('#title').val();
            }else if(choose === 'importantLevel'){
                o.importantLevel = $('#importent').val();
            }else if(choose === 'startMemberName'){
                o.startMemberName = $('#spender').val();
            }else if(choose === 'createDate'){
                var fromDate = $('#from_datetime').val();
                var toDate = $('#to_datetime').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.createDate = date;
            }else if(choose === 'dealDate'){
                var fromDate = $('#from_dealtime').val();
                var toDate = $('#to_dealtime').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.dealDate = date;
                //当按照处理时间查询时候，查询所有的信息
                //o.deduplication = "false";
            }else if(choose === 'workflowState'){
                o.workflowState = $('#status').val();
            }
            var val = searchobj.g.getReturnValue();
            if(window.location.href.indexOf("condition=templeteAll&textfield=all") != -1){
        		o.templeteAll="all";
        	}
            if(val !== null){
                $("#listDone").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(_summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src","collaboration.do?method=listDesc&type=listDone&size="+grid.p.total+"&r=" + Math.random());	
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
        }, {
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
        }, {
            id: 'spender',
            name: 'spender',
            type: 'input',
            text: $.i18n("cannel.display.column.sendUser.label"),//发起人
            value: 'startMemberName'
        }, {
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: $.i18n("common.date.sendtime.label"),//发起时间
            value: 'createDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }, {
            id: 'dealtime',
            name: 'dealtime',
            type: 'datemulti',
            text: $.i18n("common.date.donedate.label"),//处理时间
            value: 'dealDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }, {
            id: 'status',
            name: 'status',
            type: 'select',
            text: $.i18n("common.flow.state.label"),//流程状态
            value: 'workflowState',
            items: [{
                text: $.i18n("collaboration.unend"),//未结束
                value: '0'
            }, {
                text: $.i18n("collaboration.ended"),//已结束
                value: '1'
            }, {
                text: $.i18n("collaboration.terminated"),//已终止
                value: '2'
            }]
        }]
    });
    //表格加载
    grid = $('#listDone').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '4%',
            type: 'checkbox'
        }, {
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '34%'
        },{
            display: $.i18n("cannel.display.column.sendUser.label"),//发起人
            name: 'startMemberName',
            sortable : true,
            width: '8%'
        }, {
            display:  $.i18n("common.date.sendtime.label"),//发起时间
            name: 'startDate',
            sortable : true,
            width: '12%'
        }, {
            display: $.i18n("common.date.donedate.label"),//处理时间
            name: 'dealTime',
            sortable : true,
            width: '12%'
        },{
            display:  $.i18n("collaboration.list.currentNodesInfo.label"),//当前处理人
            name: 'currentNodesInfo',
            sortable : true,
            width: '9%'
        },{
            display:  $.i18n("pending.deadlineDate.label"),//处理期限（节点期限）
            name: 'nodeDeadLineName',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("collaboration.isTrack.label"),//跟踪状态
            name: 'isTrack',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("processLog.list.title.label"),//流程日志
            name: 'processId',
            width: '9%'
        }],
        click: dbclickRow,//clickRow
        dblclick: dbclickRow,
        render : rend,
        height: 200,
        showTableToggleBtn: true,
        parentId: 'center',
        rpMaxSize : 999,
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        managerName : "colManager",
        managerMethod : "getDoneList"
    });
    //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listDone&size="+grid.p.total+"&r=" + Math.random());
    
    
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
            ,panels:'Department,Team,Post,Level,Role,Outworker,FormField'
            ,selectType:'FormField,Department,Team,Post,Level,Role,Member'
            ,text:$.i18n('common.default.selectPeople.value')
            ,showFlowTypeRadio: true
            ,returnValueNeedType: false
            ,params:{
               value: zzGzr
            }
            ,targetWindow:getCtpTop()
            ,callback : function(res){
                if(res && res.obj && res.obj.length>0){
                        $("#zdgzry").val(res.value);
                } else {
                       
                }
            }
        });
   });
   
  
});

function debupCol(){
    var o = new Object();
    o.deduplication = "false";
    var isDedupCheck =  $("#deduplication:checked").size();
    if (isDedupCheck != 0) {
        o.deduplication = "true"; 
    }
    //加上搜索条件
    var choose = $('#'+searchobj.p.id).find("option:selected").val();
    if(choose === 'subject'){
        o.subject = $('#title').val();
    }else if(choose === 'importantLevel'){
        o.importantLevel = $('#importent').val();
    }else if(choose === 'startMemberName'){
        o.startMemberName = $('#spender').val();
    }else if(choose === 'createDate'){
        var fromDate = $('#from_datetime').val();
        var toDate = $('#to_datetime').val();
        if(fromDate != "" && toDate != "" && fromDate > toDate){
            $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
            return;
        }
        var date = fromDate+'#'+toDate;
        o.createDate = date;
    }else if(choose === 'dealDate'){
        var fromDate = $('#from_dealtime').val();
        var toDate = $('#to_dealtime').val();
        if(fromDate != "" && toDate != "" && fromDate > toDate){
            $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
            return;
        }
        var date = fromDate+'#'+toDate;
        o.dealDate = date;
        //当按照处理时间查询时候，查询所有的信息
        //o.deduplication = "false";OA-70783
    }else if(choose === 'workflowState'){
        o.workflowState = $('#status').val();
    }
    
    var templeteIds = $.trim(_paramTemplateIds);
    if(templeteIds != ""){
        o.templeteIds = templeteIds;
    }
    o = addURLPara(o);
    $("#listDone").ajaxgridLoad(o);
}