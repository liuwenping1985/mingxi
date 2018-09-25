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
	if(sub_app.indexOf("1") == -1 && c > 8){
		c += 1;
	}
	 if(null == txt){//修正  如果是未讀，那麼會顯示null字符串
	    	txt = "";
	    }
    if(c == 1){
    	switch(data.govdocType){
    	case 1:
    		return "发文";break;
    	case 2:
    		return "收文";break;
    	case 3:
    		return "签报";break;
    	case 4:
    		return "收文";break;
    	default:
    		return "公文";
    	}
    } else if(c === 2){
    	//标题列加深
	    txt="<span class='grid_black'>"+txt+"</span>";
        //加图标
        //重要程度 1普通 2平急 3加急 4特急 5特提
        if(data.importantLevel !==""&& data.importantLevel >1 && data.importantLevel<=5){
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
        //协同类型//注释屏蔽列表的正文类型图标
        //if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
        //    txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
        //}
        //流程状态
        if(data.state !== null && data.state !=="" && data.state != "0"){
            txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
        }
        return txt;
    }else if(c===7){
    	var titleTemp=txt;
    	txt=txt.replace("...","");
    	if(null != data.processId){
    		return "<a href='javascript:void(0)' class='noClick' title='"+titleTemp+"' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\")'>"+txt+"</a>";
    	}
    	return "";
    }else if(c == 8){//是否归档
    	if(txt !=null&&txt!=""){
    		txt = $.i18n('govdoc.canArchive.label.yes');
    	}else{
    		txt = $.i18n('govdoc.canArchive.label.no');
    	}
    	return txt;
    }else if(c === 9){
    	if(data.govdocExchangeMainId != "-1" ){
    		return "<a href='javascript:void(0)' class='noClick' onclick='showDistributeState(\"" + data.summaryId + "\")'>查看</a>  " + 
    		"<a href='javascript:void(0)' class='noClick' onclick='createReissue(\"" + data.summaryId + "\")'>补发</a>";
    	}else{
    		return "";
    	}
    }else if(c === 10){
        if(data.processIsCoverTime){
            var title = $.i18n('collaboration.listsent.overtime.title');
            txt = "<span class='color_red' title='"+title+"'>"+txt+"</span>";
        }else{
            var title = $.i18n('collaboration.listsent.overtime.no.title');
            txt = "<span title='"+title+"'>"+txt+"</span>";
        }
        return txt;
    }else if(c === 11){
    	//新公文和老公文  发文  才有跟踪
    	if(data.app > 19){
    		return "";
    	}
        //添加跟踪的代码
        if(txt === null || txt === false){
            return "<a href='javascript:void(0)' class='noClick' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.trackType+" senderId="+data.startMemberId+">"+$.i18n('message.no.js')+"</a>";
        }else{
            return "<a href='javascript:void(0)' class='noClick' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.trackType+" senderId="+data.startMemberId+">"+$.i18n('message.yes.js')+"</a>";
        }
    }else if (c === 13){
    		if(null != data.processId){
    			return "<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)'></a>";
    		}
    		return "";
        }else{
            return txt;
        }
   }     

function showDistributeState(summaryId){
	var dialog = $.dialog({
        url : "/seeyon/collaboration/collaboration.do?method=showDistributeState&summaryId=" + summaryId,
        width : 1000,
        height : 400,
        title : '分送状态',
        targetWindow:getCtpTop(),
        buttons : [{
            text : $.i18n('collaboration.button.close.label'),
            handler : function() {
              dialog.close();
            }
        }]
    });
}

function createReissue(summaryId){
    $.selectPeople({
        panels: 'Account,Department,OrgTeam',
        selectType: 'Account,Department,OrgTeam',
        hiddenPostOfDepartment:true,//隐藏岗位
        showAllOuterDepartment:true,//显示所有外部单位
        isCanSelectGroupAccount:false,//是否可选集团单位
        unallowedSelectEmptyGroup:true,//不允许为空
        isConfirmExcludeSubDepartment:false,
        isAllowContainsChildDept:true,
        isCheckInclusionRelations:false,
        showAllAccount : 'true',//默认补发可以选择外单位
        callback : function(ret) {
            var exchange = new govdocExchangeManager();
            var result = exchange.validateReissueeRepeat(summaryId,ret.value);
            if(result!=null){
                var con = $.messageBox({
                    'imgType':'3',
                    'type': 100,
                    'msg': "此文("+ result.names + ")已经发送过，是否重新再发送一条新的流程？",
                    buttons: [{
                        id:'btn1',
                        text: "是",
                        handler: function () {
                            send2Account(exchange,summaryId,ret.value);
                            con.close();
                        }
                    }, {
                        id:'btn2',
                        text: "否",
                        handler: function () {
                            if(result.values!=ret.value&&result.values!=""){
                                send2Account(exchange,summaryId,result.values);
                            }

                            con.close();
                        }
                    }, {
                        id:'btn3',
                        text: "取消",
                        handler: function () {con.close();}
                    }],
                    close_fn:function(){enableOperation();}
                });
            }else{
                send2Account(exchange,summaryId,ret.value);
            }

        }
    });

}
function send2Account(exchange,summaryId,retVal){
    $.ajax({
        type:"post",
        url : "/seeyon/collaboration/collaboration.do?method=createReissue",
        data : {summaryId : summaryId,danwei:retVal},
        success:function(data){
            var returnVal = exchange.validateExistAccount(retVal);
            if(returnVal!=""){
                $.alert($.i18n("govdoc.not.signWorkflow")+":<br/> "+returnVal);
            }else{
                $.alert("补发成功");
            }
        }
    });
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
	var id_checkbox = grid.grid.getSelectRows();
	var selRow = id_checkbox[0];
    var affairId = selRow.affairId;
    var summaryId = selRow.summaryId;
    var exchange = new govdocExchangeManager();
    var result = exchange.validateFenban(summaryId);
    if(result == "has"){
    	var win = new MxtMsgBox({
            'type': 0,
            'msg': '该公文已有相关见办文，建议同步撤销!',
            ok_fn:function(){
            	cancelDate();
            }
        });
    }else{
    	cancelDate();
    }
}  

function cancelDate(){
	var id_checkbox = grid.grid.getSelectRows();
	//js事件接口
	var sendDevelop = $.ctp.trigger('beforeSentCancel');
	if(!sendDevelop){
		 return;
	}
	
   disabledToolbar();
   if (id_checkbox.length === 0) {
       //请选择需要撤销的公文！
   	$.alert($.i18n('collaboration.govdoc.listSent.selectRevokeSyn'));
       enabledToolbar();
       return;
   }
   if(id_checkbox.length > 1){
       //只能选择一条记录!
       $.alert($.i18n('collaboration.listSent.selectOneData'));
       enabledToolbar();
       return;
   }
	//老公文 屏蔽该功能
   if(id_checkbox[0].app > 4){
		$.alert("《"+id_checkbox[0].subject+"》 为旧公文数据,"+$.i18n('edoc.alert.oldEdocSummary.noFunction'));
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
       			'<input type="checkbox" checked id="trackWorkflow" name="trackWorkflow" class="radio_com">'+$.i18n("collaboration.workflow.trace.traceworkflow")+
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
                             var url = window.location.search;
                             var o = new Object();
                             setParamsToObject(o,url);
                             $("#listSent").ajaxgridLoad(o);
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
    deleteItems('sent',grid,'listSent',paramMethod,'govdoc');
}
 //定义setTimeout执行方法
var TimeFn = null;
//定义单击事件
function clickRow(data,rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    //执行延时
    if(!isAffairValid(data.affairId)){
        $("#listSent").ajaxgridLoad();
        $(".spiretBarHidden3").trigger("click");
        return;
    }
    TimeFn = setTimeout(function(){
        $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId);
    },300);
}
//双击事件
function dbclickRow(data,rowIndex, colIndex){
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    if(!isAffairValid(data.affairId)){
        $("#listSent").ajaxgridLoad();
        return;
    }
    var url =  "";
    if(data.app == 4){//新公文 //根据 app 判断对应的公文种类
    	url = url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId;
	}else if(data.app == 19){//发文
//		url = _ctxPath + "/edocController.do?method=edocRegisterDetail&forwardType=registered&registerId="+data.summaryId;
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listSent&affairId="+data.affairId+"&detailType=listSent&edocType=1&edocId="+data.summaryId;
	}else if(data.app == 20){//收文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listSent&affairId="+data.affairId+"&detailType=listSent&edocType=1&edocId="+data.summaryId;
	}else if(data.app == 21){//签报
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listSent&affairId="+data.affairId+"&detailType=listSent&edocType=2&edocId="+data.summaryId;
	}else if(data.app == 22){ //交换 已发送
		//url =  _ctxPath + "/exchangeEdoc.do?method=edit&id="+data.summaryId+"&modelType=sent";
	}else if(data.app == 23){//交换 已签收
		//url =  _ctxPath + "/exchangeEdoc.do?method=edit&modelType=received&upAndDown=true&id="+data.summaryId;
	}else if(data.app == 24){
		//url = _ctxpath + "/exchangeEdoc.do?method=edit&modelType=received&id="+data.summaryId+"&newDate="+new date()+"&nodeAction=swWaitRegister"
	}else if(data.app == 40){//已登记 公文
		
	}
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    //$('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listSent&size="+grid.p.total+"&r=" + Math.random());
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

function forwardText(){
	var rows = grid.grid.getSelectRows();
	if(rows.length != 1){
		$.alert($.i18n('govdoc.edoc.listDone.selectOneData'));
		return;
	}
	var govdocType = rows[0].govdocType;
	if(govdocType != 2){
		$.alert($.i18n('govdoc.edoc.listDone.dontProcess'));
		return;
	}
	var forwardAffairId = rows[0].affairId;
	var dialog = $.dialog({
        url : "/seeyon/govDoc/govDocController.do?method=forwordOption",
        width : 300,
        height : 195,
        title : '转发文',
        targetWindow:getCtpTop(),
        buttons : [{
            text: $.i18n('collaboration.pushMessageToMembers.confirm'),
            handler : function() {
              var rv = dialog.getReturnValue();
              dialog.close();
              var url = "/seeyon/collaboration/collaboration.do?method=newColl&app=4&sub_app=1&forwardAffairId="+forwardAffairId+"&forwardText=" + rv;
              var title = "新建公文";
              doubleClick(url,escapeStringToHTML(title));
            }
        },{
            text : $.i18n('collaboration.button.close.label'),
            handler : function() {
              dialog.close();
            }
        }]
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
  
    var toolbarArray = new Array();
    //归档
    if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
        toolbarArray.push({id: "pigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click: function(){doPigeonhole("govdocsent", grid, "listSent");}});
    }
    //撤销流程
    toolbarArray.push({id: "cancelWorkFlow",name: $.i18n('common.repeal.workflow.label'),className: "ico16 revoked_process_16",click:cancelWorkFlow});


    if('${sub_app}'.indexOf("2") > -1){
    	//转发文 $.i18n('govdoc.button.forwardText.label')
    	if($.ctx.resources.contains('F20_newSend')){
    		toolbarArray.push({id: "forwardText",name: $.i18n('govdoc.button.forwardText.label') ,className: "ico16 forwardText_16",click:forwardText});
    	}
    }
    //删除
    //toolbarArray.push({id: "delete",name: $.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteCol});
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
            if(choose=='docMark'){//公文文号
            	o.docMark=$('#docMark').val();
            }else if(choose=='serialNo'){//内部文号
            	o.serialNo=$('#serialNo').val();
            }else if(choose=='secretLevel'){//密级
            	o.secretLevelQuery=$('#secretLevel').val();
            	//o.accurate='accurate';
            }else if(choose=='urgentLevel'){//紧急程度
            	o.urgentLevel=$('#urgentLevel').val();
            }else if(choose === 'subject'){
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
            }else if(choose === 'receiveDate'){
                var fromDate = $('#from_receivetime').val();
                var toDate = $('#to_receivetime').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.receiveDate = date;
            }else if(choose === 'expectprocesstime'){
                var fromDate = $('#from_nodeDeadLine').val();
                var toDate = $('#to_nodeDeadLine').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.expectprocesstime = date;
            }else if(choose === 'subState'){
            	o.subState=$('#subState').val();
            }
            var val = searchobj.g.getReturnValue();
            if(window.location.href.indexOf("condition=templeteAll&textfield=all") != -1){
        		o.templeteAll="all";
        	}
            var url = window.location.search;
            setParamsToObject(o,url);
            if(val !== null){
                $("#listSent").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(undefined != _summarySrc && _summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listSent&size="+grid.p.total+"&r=" + Math.random());	
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
            id: 'docMark',
            name: 'docMark',
            type: 'input',
            text: $.i18n("govdoc.docMark.label"),//公文文号
            value: 'docMark',
            maxLength:100
        },  {
            id: 'serialNo',
            name: 'serialNo',
            type: 'input',
            text: $.i18n("govdoc.serialNo.label"),//内部文号
            value: 'serialNo',
            maxLength:100
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
            id:'receivetime',
            name:'receivetime',
            type:'datemulti',
            text: $.i18n("cannel.display.column.receiveTime.label"),//接受时间
            value:'receiveDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        },{
            id: 'secretLevel',
            name: 'secretLevel',
            type: 'select',
            text: $.i18n("govdoc.secretLevel.label"),//密级
            value: 'secretLevel',
            items: secretLevelOptions
        },{
            id: 'urgentLevel',
            name: 'urgentLevel',
            type: 'select',
            text: $.i18n("govdoc.urgentLevel.label"),//紧急程度
            value: 'urgentLevel',
            items: urgentLevelOptions
        },{
        	id:'nodeDeadLine',
        	name:'nodeDeadLine',
        	type:'datemulti',
        	text:$.i18n("collaboration.process.label"),
        	value:'expectprocesstime',
        	ifFormat:'%Y-%m-%d',
        	dateTime:false
        }]
    });
    var colModel = [{
        display: 'id',
        name: 'affairId',
        width: '4%',
        type: 'checkbox',
        isToggleHideShow:false
    },{
        display: "分类",//分类
        name: 'govdocType',
        sortable : false,
        width: '5%'
    },  {
        display: $.i18n("common.subject.label"),//标题
        name: 'subject',
        sortable : true,
        width: '30%'
    }, {
        display: $.i18n("govdoc.docMark.label"),//公文文号
        name: 'docMark',
        sortable : true,
        width: '9%'
    },{
        display: $.i18n("govdoc.serialNo.label"),// 内部文号
        name: 'serialNo',
        sortable : true,
        width: '9%'
    }, {
        display: $.i18n("govdoc.urgentLevel.label"),//紧急程度
        name: 'urgentLevel',
        sortable : true,
        width: '9%'
    },{
        display: $.i18n("govdoc.secretLevel.label"),//密级
        name: 'secretLevel',
        sortable : true,
        width: '9%'
    },{
        display:  $.i18n("collaboration.list.currentNodesInfo.label"),//当前处理人
        name: 'currentNodesInfo',
        sortable : true,
        width: '9%'
    }, {
        display: $.i18n("govdoc.canArchive.label"),//是否归档
        name: 'archiveId',
        sortable : true,
        width: '9%'                  
    },{
        display: $.i18n("collaboration.process.cycle.label"),//流程期限
        name: 'processDeadLineName',
        sortable : true,
        width: '9%'
    }, {
        display: $.i18n("collaboration.isTrack.label"),//跟踪状态
        name: 'isTrack',
        sortable : true,
        width: '9%'                  
    },{
        display:  $.i18n("common.date.sendtime.label"),//发起时间
        name: 'startDate',
        sortable : true,
        width: '9%'
    }, 
    {
        display: $.i18n("processLog.list.title.label"),//流程日志
        name: 'processId',
        width: '9%'
    }];
    if(sub_app.indexOf("1") != -1){
    	colModel = [{
            display: 'id',
            name: 'affairId',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        },{
            display: "分类",//分类
            name: 'govdocType',
            sortable : false,
            width: '5%'
        },  {
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '30%'
        }, {
            display: $.i18n("govdoc.docMark.label"),//公文文号
            name: 'docMark',
            sortable : true,
            width: '9%'
        },{
            display: $.i18n("govdoc.serialNo.label"),// 内部文号
            name: 'serialNo',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("govdoc.urgentLevel.label"),//紧急程度
            name: 'urgentLevel',
            sortable : true,
            width: '9%'
        },{
            display: $.i18n("govdoc.secretLevel.label"),//密级
            name: 'secretLevel',
            sortable : true,
            width: '9%'
        },{
            display:  $.i18n("collaboration.list.currentNodesInfo.label"),//当前处理人
            name: 'currentNodesInfo',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("govdoc.canArchive.label"),//是否归档
            name: 'archiveId',
            sortable : true,
            width: '9%'                  
        }, {
        	display : $.i18n("govdoc.DistributeState.label"),//状态
        	name: 'govdocExchangeMainId',
        	width: '9%'
        },{
            display: $.i18n("collaboration.process.cycle.label"),//流程期限
            name: 'processDeadLineName',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("collaboration.isTrack.label"),//跟踪状态
            name: 'isTrack',
            sortable : true,
            width: '9%'                  
        },{
            display:  $.i18n("common.date.sendtime.label"),//发起时间
            name: 'startDate',
            sortable : true,
            width: '9%'
        }, 
        {
            display: $.i18n("processLog.list.title.label"),//流程日志
            name: 'processId',
            width: '9%'
        }];
    }
    if(sub_app.indexOf(",") == -1){
    	colModel[1].hide=true;
    	colModel[1].isToggleHideShow=false;
    };
    //表格加载
        grid = $('#listSent').ajaxgrid({
        colModel: colModel,
        click: dbclickRow,
        //dblclick: dbclickRow,
        render : rend,
        height: 200,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: false,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:false,
        slideToggleBtn:false,
        managerName : "edocManager",
        managerMethod : "getSentList"
    });
    
    
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listSent&size="+grid.p.total+"&r=" + Math.random());
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