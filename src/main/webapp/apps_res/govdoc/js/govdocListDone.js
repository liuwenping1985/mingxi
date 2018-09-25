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
function rend(txt, data, r, c,col) {
	if(sub_app.indexOf("1") == -1 && c > 7){
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
	    //如果是代理 ，颜色变成蓝色
	    if(data.proxy){
	        txt = "<span class='color_blue'>"+txt+"</span>";
	    }
	    //加图标
        //重要程度 1普通 2平急 3加急 4特急 5特提
	    if(data.importantLevel !==""&&  data.importantLevel >1 && data.importantLevel<=5){
	        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
	    }
	    //附件
	    if(data.hasAttsFlag === true){
	        txt = txt + "<span class='ico16 affix_16'></span>" ;
	    }
	    //协同类型//注释屏蔽列表的正文类型图标
	    //if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
	    //    txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
	    //}
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
	}else if(c===8){
	    var txt = txt.replace("...","");
	    if(null != data.processId){
	    	return "<a href='javascript:void(0)' class='noClick' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\")'>"+txt+"</a>";
	    }
	    return "";
    }else if (c === 9){
    	if(data.govdocExchangeMainId != "-1" ){
    		return "<a href='javascript:void(0)' class='noClick' onclick='showDistributeState(\"" + data.summaryId + "\")'>查看</a>" + 
    		"  <a href='javascript:void(0)' class='noClick' onclick='createReissue(\"" + data.summaryId + "\")'>补发</a>";
    	}else if(col.name == 'currentNodesInfo') {//当前待办人
    		var titleTemp = txt;
        	txt = txt.replace("...","");
        	if(null != data.processId){
        		return "<a href='javascript:void(0)' class='noClick' title='"+titleTemp+"' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\")'>"+txt+"</a>";
        	}
    		return txt;
    	}else{
    		return "";
    	}
    }else if(c === 13){
    	//新公文和老公文  发文  才有跟踪
    	if(data.app > 19){
    		return "";
    	}
    	//添加跟踪的代码
	    if(!txt || txt === null || txt === false){
	        return "<a href='javascript:void(0)' class='noClick' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.isTrack+" senderId="+data.startMemberId+">"+$.i18n('message.no.js')+"</a>";
	    }else{
	        return "<a href='javascript:void(0)' class='noClick' onclick='setTrack(this)' objState="+data.state+" affairId="+data.affairId+" summaryId="+data.summaryId+" trackType="+data.isTrack+" senderId="+data.startMemberId+">"+$.i18n('message.yes.js')+"</a>";
	    }
	}else if (c === 15){
		if(null != data.processId){
			return "<a class='ico16 view_log_16 noClick' class='noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)'></a>";
		}
		return "";
    }/*else if(c == 15){
    	if(data.govdocExchangeMainId != "-1" ){
    		return "<a href='javascript:void(0)' onclick='createReissue(\"" + data.summaryId + "\")'>补发</a>";
    	}else{
    		return "";
    	}
    }*/
    else{
    
        return txt;
    }
    return txt;
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

  //删除
function deleteCol(){
    deleteItems('finish',grid,'listDone',paramMethod);
}
   
function transmitCol(){
    transmitColFromGrid(grid);
}
//转发文点击事件	
function forwardText(){
	var rows = grid.grid.getSelectRows();
	if(rows.length != 1){
		//alert("选择一条数据");
		$.alert($.i18n('govdoc.edoc.listDone.selectOneData'));
		return;
	}
	var govdocType = rows[0].govdocType;
	//老公文 屏蔽该功能
    if(rows[0].app > 4){
		$.alert("《"+rows[0].subject+"》 为旧公文数据,"+$.i18n('edoc.alert.oldEdocSummary.noFunction'));
		return;
	}
	if(govdocType != 2){
		//alert("不能选择发文流程/交换流程");
		$.alert($.i18n('govdoc.edoc.listDone.dontProcess'));
		return;
	}
	var forwardAffairId = rows[0].affairId;
	var onlyQuickSend = "";
	if(!$.ctx.resources.contains('F20_newSend') && $.ctx.resources.contains('F20_fawenNewQuickSend')){
		onlyQuickSend = "true";
	}
	var dialog = $.dialog({
        url : "/seeyon/govDoc/govDocController.do?method=forwordOption",
        width : 300,
        height : 195,
        title : $.i18n('govdoc.button.forwardText.label'),
        targetWindow:getCtpTop(),
        buttons : [{
            text: $.i18n('collaboration.pushMessageToMembers.confirm'),
            handler : function() {
              var rv = dialog.getReturnValue();
              dialog.close();
              var url = "/seeyon/collaboration/collaboration.do?method=newColl&app=4&sub_app=1&forwardAffairId="+forwardAffairId+"&forwardText=" + rv + "&isQuickSend="+onlyQuickSend;
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

function turnRecEdoc(){
	var rows = grid.grid.getSelectRows();
	if(rows.length != 1){
		//alert("选择一条数据");
		$.alert($.i18n('govdoc.edoc.listDone.selectOneData'));
		return;
	}
	var govdocType = rows[0].govdocType;
	//老公文 屏蔽该功能
    if(rows[0].app > 4){
		$.alert("《"+rows[0].subject+"》 为旧公文数据,"+$.i18n('edoc.alert.oldEdocSummary.noFunction'));
		return;
	}
	if(govdocType != 2){
		$.alert($.i18n('govdoc.edoc.listDone.dontProcess'));
		return;
	}
	var affairId = rows[0].affairId;
	var ajaxColManager = new colManager();
	var result = ajaxColManager.verifyTurnRecEdoc(affairId);
	if(result != true){
		alert("该节点不能转收文");
		return;
	}
    var summaryId = rows[0].summaryId;
	var dialog = $.dialog({
        id : "turnRecEdoc",
        height:"400",
        width:"400",
        targetWindow:getCtpTop(),
        url : _ctxPath + '/collaboration/collaboration.do?method=toTurnRecEdoc&summaryId='+summaryId,
        title : $.i18n('govdoc.button.turnRecEdoc.label'),
        buttons: [{
            id : "okButton",
            text: $.i18n("collaboration.button.ok.label"),
            btnType:1,
            handler: function () {
                var rv = dialog.getReturnValue();
                if(rv == null){
            		$.alert("没有选择单位");
                	return;
                }
                if(rv.opinion.length>1000){
                	$.alert("办理意见不能超过1000字！");
                	return;
                }
                var selectUnitId = rv.selectUnitId;
                var colManagerajax = new colManager();
        		var result = colManagerajax.verifyUnitExists(selectUnitId,summaryId);
        		if(result != null){
        			var confirm = $.confirm({
                        'msg':"已经为以下单位("+ result.names + ")发送，确定继续发送？？(确定继续发送，取消排除已发送单位)",
                        ok_fn: function () {
                            var timestamp = (new Date()).valueOf();
                            $.ajax({
                                url : _ctxPath + '/collaboration/collaboration.do?method=doTurnRecEdoc&timestamp=' + timestamp,
                                data : {affairId : affairId,unitId : selectUnitId,opinion:rv.opinion},
                                success : function(data){
                                	var exchangeManager = new govdocExchangeManager();
                                	var returnVal = exchangeManager.validateExistAccount(selectUnitId);
                                	if(returnVal&&returnVal!=""){
                                		$.alert("以下单位公文发送不成功，详见详情<br/><br/>"+returnVal);
                                	}else{
                                		$.alert("已转收文");
                                	}
                                	dialog.close();
                                }
                            });
                        },
                        cancel_fn:function(){
                        	selectUnitId = result.finalIds;
                        	if(selectUnitId == ""){
                        		$.alert("没有选择单位");
                        		return;
                        	}
                            var timestamp = (new Date()).valueOf();
                            $.ajax({
                                url : _ctxPath + '/collaboration/collaboration.do?method=doTurnRecEdoc&timestamp=' + timestamp,
                                data : {affairId : affairId,unitId : selectUnitId,opinion:rv.opinion},
                                type: "post",
                                success : function(data){
                                	$.alert("已转收文");
                                	dialog.close();
                                }
                            });
                        },
                        close_fn: function (){
                        	confirm.close();
                        }
                    });
        		}else{
        			var timestamp = (new Date()).valueOf();
                    $.ajax({
                        url : _ctxPath + '/collaboration/collaboration.do?method=doTurnRecEdoc&timestamp=' + timestamp,
                        data : {affairId : affairId,unitId : selectUnitId,opinion:rv.opinion},
                        type:"post",
                        success : function(data){
                        	var exchangeManager = new govdocExchangeManager();
                        	var returnVal = exchangeManager.validateExistAccount(selectUnitId);
                        	if(returnVal&&returnVal!=""){
                        		$.alert("以下单位公文发送不成功，详见详情<br/><br/>"+returnVal);
                        	}else{
                        		$.alert("已转收文");
                        	}
                        	dialog.close();
                        }
                    });
        		}
            }
        }, {
            id:"cancelButton",
            text: $.i18n("collaboration.button.cancel.label"),
            handler: function () {
                dialog.close();
            }
        }]
    });
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
        //请选择要取回的公文!
        //$.alert($.i18n('govdoc.listDone.selectBack'));
        $.alert($.i18n('govdoc.edoc.listDone.selectBack'));
        return;
    }
    if (rows.length > 1) {
        //只能选择一项公文进行取回!
        $.alert($.i18n('govdoc.edoc.listDone.selectOneBack'));
        return;
    }
  //老公文 屏蔽该功能
    if(rows[0].app > 4){
		$.alert("《"+rows[0].subject+"》 为旧公文数据,"+$.i18n('edoc.alert.oldEdocSummary.noFunction'));
		return;
	}
    if(!isAffairValid(rows[0].affairId)) {
    	var url = window.location.search;
    	var o = new Object();
        setParamsToObject(o,url);
        $("#listDone").ajaxgridLoad(o);
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
    if(canTakeBackObj !=null && !canTakeBackObj.canTakeBack || canTakeBackObj.state == "-1"){
        var msg = 'collaboration.takeBackErr.'+canTakeBackObj.state+'.msg';
        $.alert($.i18n(msg));
        //$("#listDone").ajaxgridLoad();
        return;
    }
    var a = "1";
    $.ajax({
    	url:"/seeyon/govDoc/govDocController.do?method=judgeFaxing",
    	data:{summaryId:rows[0].summaryId,affairId:rows[0].affairId},
    	async:false,
    	success:function(data){
    		a = data;
    	}
    });
    if(a=="0"){
    	$.alert("该流程已分送，不允许取回");
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
        url: _ctxPath + "/collaboration/collaboration.do?method=showTakebackConfirm&govdoc=1",
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
                                    window.location.href=window.location.href;
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
function clickRow(data,rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    if(!isAffairValid(data.affairId)){
        $("#listDone").ajaxgridLoad();
        return;
    }
    //执行延时
    TimeFn = setTimeout(function(){
        $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId);
    },300);
}

//双击事件
function dbclickRow(data,rowIndex, colIndex){
	if(colIndex==7||colIndex==8||colIndex==12||colIndex==14||colIndex==15){
		return;
	}
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    if(!isAffairValid(data.affairId)){
        $("#listDone").ajaxgridLoad();
        return;
    }
	var url =  "";
	if(data.app == 4){//新公文 //根据 app 判断对应的公文种类
		url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId;
	}else if(data.app == 19){//发文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=Done&affairId="+data.affairId;
	}else if(data.app == 20){//收文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listSent&affairId="+data.affairId;
	}else if(data.app == 21){//签报
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listSent&affairId="+data.affairId;
	}else if(data.app == 22){ //交换 已发送
		url =  _ctxPath + "/exchangeEdoc.do?method=edit&id="+data.workitemId+"&modelType=sent";
	}else if(data.app == 23){//交换 已签收
		url =  _ctxPath + "/exchangeEdoc.do?method=edit&modelType=received&upAndDown=true&id="+data.workitemId;
	}else if(data.app == 24){
		//url = _ctxpath + "/exchangeEdoc.do?method=edit&modelType=received&id="+data.summaryId+"&newDate="+new date()+"&nodeAction=swWaitRegister"
	}else if(data.app == 34){
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listSent&affairId="+data.affairId+"&detailType=listSent&edocType=1&edocId="+data.summaryId;
		//url = _ctxPath + "/edocController.do?method=newEdoc&comm=distribute&recListType=listDistribute&edocType=1&registerId="+data.summaryId;
	}else if(data.app == 40){//已登记 公文
		url = _ctxPath + "/edocController.do?method=edocRegisterDetail&forwardType=registered&registerId="+data.summaryId;
	}
	
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    //$('#summary').attr("src", _ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listDone&size="+grid.p.total+"&r=" + Math.random());
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
    var toolbarArray = new Array();
    //归档
    // if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
    //     toolbarArray.push({id: "pigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click: function(){doPigeonhole("govdocdone", grid, "listDone");}});
    // }
    //删除
   // toolbarArray.push({id: "delete",name:$.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteCol});
    //取回
    //BDGW-2326去掉已办结列表的取回按钮
    if(finishState != "1"){
    	toolbarArray.push({id: "takeBack",name: $.i18n('common.toolbar.takeBack.label'),className: "ico16 retrieve_16",click:takeBack});
    }
    if(sub_app.indexOf("2") > -1){
    	//转发文
    	// if($.ctx.resources.contains('F20_newSend') || $.ctx.resources.contains('F20_fawenNewQuickSend')){
    	// 	toolbarArray.push({id: "forwardText",name: $.i18n('govdoc.button.forwardText.label') ,className: "ico16 forwardText_16",click:forwardText});
    	// }

    }
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
    var condition = [{
        id: 'title',
        name: 'title',
        type: 'input',
        text: $.i18n("cannel.display.column.subject.label"),//标题
        value: 'subject',
        maxLength:100
    },{
        id: 'Document',
        name: 'Document',
        type: 'input',
        text: $.i18n("govdoc.docMark.label"),//公文文号
        value: 'docMark',
        maxLength:100
    },  {
        id: 'Internal',
        name: 'Internal',
        type: 'input',
        text: $.i18n("govdoc.serialNo.label"),//内部文号
        value: 'serialNo',
        maxLength:100
    },  {
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
        text: $.i18n("govdoc.urgentLevel.label"),//密级
        value: 'urgentLevel',
        items: urgentLevelOptions
    }, {
        id: 'dealtime',
        name: 'dealtime',
        type: 'datemulti',
        text: $.i18n("common.date.donedate.label"),//处理时间
        value: 'dealDate',
        ifFormat:'%Y-%m-%d',
        dateTime: false
    }]
    if(finishState!='0'){
    	condition.push({
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
        });
    }
    searchobj = $.searchCondition({
        top:topSearchSize,
        right:50,
        searchHandler: function(){
            var o = new Object();
            //同一流程只显示最后一条
            o.deduplication = "false";
//            var isDedupCheck =  $("#deduplication").attr("checked");
//            if (isDedupCheck) {
//                o.deduplication = "true"; 
//            }
            var templeteIds = $.trim(_paramTemplateIds);
            if(templeteIds != ""){
                o.templeteIds = templeteIds;
            }
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            if(choose=='docMark'){//公文文号
            	o.docMark=$('#Document').val();
            }else if(choose=='serialNo'){//内部文号
            	o.serialNo=$('#Internal').val();
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
            var url = window.location.search;
            setParamsToObject(o,url);
            if(val !== null){
                $("#listDone").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(undefined != _summarySrc && _summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src",_ctxPath +"/collaboration/collaboration.do?method=listDesc&type=listDone&size="+grid.p.total+"&r=" + Math.random());	
                	},1000);
                }
            }
        },
        conditions: condition
    });
    var colModel = [{
            display: 'summaryId',
            name: 'summaryId',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        },{
            display: "分类",//分类
            name: 'govdocType',
            sortable : false,
            width: '5%'
        },{
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '32%'
        },{
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
            display: $.i18n("govdoc.processingtime.label"),//处理时间
            name: 'dealTime',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("govdoc.currentNodesInfo.label"),//当前待办人
            name: 'currentNodesInfo',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("common.date.sendtime.label"),//发起时间
            name: 'startDate',
            sortable : true,
            width: '10%'
        },{
            display: $.i18n("cannel.display.column.sendUser.label"),//发起人
            name: 'startMemberName',
            sortable : true,
            width: '7%'
        }, {
            display: $.i18n("collaboration.col.hasten.number.label"),//催办次数
            name: 'hastenTimes',
            sortable : true,
            width: '9%'
        },  {
            display: $.i18n("govdoc.canTrack.label"),//跟踪状态
            name: 'isTrack',
            sortable : true,
            width: '9%'
        },  {
            display: $.i18n("pending.deadlineDate.label"),//处理期限（节点期限）
            name: 'nodeDeadLineName',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("processLog.list.title.label"),//流程日志
            name: 'processId',
            width: '9%'
        }];
    if(sub_app.indexOf("1") != -1){
    	colModel = [{
            display: 'summaryId',
            name: 'summaryId',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        },{
            display: "分类",//分类
            name: 'govdocType',
            sortable : false,
            width: '5%'
        },{
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '32%'
        },{
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
            display: $.i18n("govdoc.processingtime.label"),//处理时间
            name: 'dealTime',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("govdoc.currentNodesInfo.label"),//当前待办人
            name: 'currentNodesInfo',
            sortable : true,
            width: '10%'
        }, {
        	display : $.i18n("govdoc.DistributeState.label"),//状态
        	name: 'govdocExchangeMainId',
        	width: '9%'
        }, {
            display: $.i18n("common.date.sendtime.label"),//发起时间
            name: 'startDate',
            sortable : true,
            width: '10%'
        },{
            display: $.i18n("cannel.display.column.sendUser.label"),//发起人
            name: 'startMemberName',
            sortable : true,
            width: '7%'
        }, {
            display: $.i18n("collaboration.col.hasten.number.label"),//催办次数
            name: 'hastenTimes',
            sortable : true,
            width: '9%'
        },  {
            display: $.i18n("govdoc.canTrack.label"),//跟踪状态
            name: 'isTrack',
            sortable : true,
            width: '9%'
        },  {
            display: $.i18n("pending.deadlineDate.label"),//处理期限（节点期限）
            name: 'nodeDeadLineName',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("processLog.list.title.label"),//流程日志
            name: 'processId',
            width: '9%'
        }];
    }
    if(sub_app.indexOf(",") == -1){
    	colModel[1].hide=true;
    };
    //表格加载
    grid = $('#listDone').ajaxgrid({
        colModel: colModel,
        click: dbclickRow,
        //dblclick: dbclickRow,
        render : rend,
        height: 200,
        showTableToggleBtn: true,
        parentId: 'center',
        vChange: false,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:false,
        slideToggleBtn:false,
        managerName : "edocManager",
        managerMethod : "getDoneList"
    });
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath +"/collaboration/collaboration.do?method=listDesc&type=listDone&size="+grid.p.total+"&r=" + Math.random());
    
    
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
   //"同一流程只显示最后一条"默认未勾选上
   //$("#deduplication").attr("checked",true);
});

function debupCol(){
    var o = new Object();
    o.deduplication = "false";
//    var isDedupCheck =  $("#deduplication:checked").size();
//    if (isDedupCheck != 0) {
//        o.deduplication = "true"; 
//    }
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
    o.govdoc = 'govdoc';
    var url = window.location.search;
    setParamsToObject(o,url);
    o = addURLPara(o);
    $("#listDone").ajaxgridLoad(o);
}