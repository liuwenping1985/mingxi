<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title></title>
    <script type="text/javascript" src="/seeyon/ajax.do?managerName=govdocExchangeManager,colManager"></script>
</head>
<body id='layout' class="comp" comp="type:'layout'">
<div id="showCount">本次共计发送<span id="totalCount" style="color:red;cursor:hand!important">0</span>家单位，已签收<span id="sendCount" style="color:red;cursor:hand!important;">0</span>家，待签收<span id="waitSignCount" style="color:red;cursor:hand!important;">0</span>家，已回退<span id="backCount" style="color:red;cursor:hand!important;">0</span>家 </div>
<div id="distributeStateToolbar"></div>
<table class="flexme3" id="exchangeDetail"></table>
</body>
<script type="text/javascript">
    var mainSummaryId = "${summaryId}";
    var chuantouchakan1 = "${chuantouchakan1}";
    var exchangeStatus = "${exchangeStatus}";
    var height= 369;
    initCount();
    $.ctx._pageSize = -1;// 去掉分页，不做查询条数限制
    var colmodel = [{
        display: 'summaryId',
        name: 'summaryId',
        width: '5%',
        type: 'checkbox'
    }, {
        display: $.i18n("govdoc.ExchangeUnit.label"),//交换单位
        name: 'sendOrgName',
        width: '15%'
    }, {
        display: $.i18n("govdoc.RecieveUnit.label"),//签收单位
        name: 'recOrgName',
        width: '15%'
    }, {
        display: $.i18n("govdoc.RecieveNo.label"),//签收编号
        name: 'recNo',
        width: '12%'
    }, {
        display: $.i18n("govdoc.RecieveUser.label"),//签收人
        name: 'recUserName',
        width: '8%'
    }, {
        display: $.i18n("govdoc.RecieveDate.label"),//签收日期
        name: 'recTime',
        width: '12%'
    },{
        display: $.i18n("govdoc.DistributeState.label"),//状态
        name: 'statusName',
        width: '10%'
    }, {
        display: '流程日志',//操作
        name: 'id',
        width: '11%'
    },{
        display: $.i18n("govdoc.CreateDate.label"),//创建日期
        name: 'createTime',
        width: '12%'
    }];
    if(exchangeStatus==1){//待签收
    	colmodel = [{
            display: 'summaryId',
            name: 'summaryId',
            width: '5%',
            type: 'checkbox'
        },{
            display: $.i18n("govdoc.ExchangeUnit.label"),//交换单位
            name: 'sendOrgName',
            width: '20%'
        }, {
            display: $.i18n("govdoc.RecieveUnit.label"),//签收单位
            name: 'recOrgName',
            width: '20%'
        }, {
            display: $.i18n("govdoc.DistributeState.label"),//状态
            name: 'statusName',
            width: '15%'
        }, {
            display: '流程日志',//操作
            name: 'id',
            width: '20%'
        },{
            display: $.i18n("govdoc.CreateDate.label"),//创建日期
            name: 'createTime',
            width: '20%'
        }];
    }else if(exchangeStatus==10){//已回退
    	height = 380;
    	colmodel = [{
            display: $.i18n("govdoc.ExchangeUnit.label"),//交换单位
            name: 'sendOrgName',
            width: '15%'
        }, {
            display: $.i18n("govdoc.RecieveUnit.label"),//签收单位
            name: 'recOrgName',
            width: '15%'
        }, {
            display: "回退意见",//回退意见
            name: 'opinion',
            width: '17%'
        }, {
            display:"回退人",//回退人
            name: 'recUserName',
            width: '8%'
        }, {
            display:"回退日期",//回退日期
            name: 'recTime',
            width: '12%'
        },{
            display: $.i18n("govdoc.DistributeState.label"),//状态
            name: 'statusName',
            width: '10%'
        }, {
            display: '流程日志',//操作
            name: 'id',
            width: '11%'
        },{
            display: $.i18n("govdoc.CreateDate.label"),//创建日期
            name: 'createTime',
            width: '12%'
        }];
    }else if(exchangeStatus==23){
    	height=380;
    	colmodel = [{
            display: $.i18n("govdoc.ExchangeUnit.label"),//交换单位
            name: 'sendOrgName',
            width: '15%'
        }, {
            display: $.i18n("govdoc.RecieveUnit.label"),//签收单位
            name: 'recOrgName',
            width: '15%'
        }, {
            display: $.i18n("govdoc.RecieveNo.label"),//签收编号
            name: 'recNo',
            width: '12%'
        }, {
            display: $.i18n("govdoc.RecieveUser.label"),//签收人
            name: 'recUserName',
            width: '8%'
        }, {
            display: $.i18n("govdoc.RecieveDate.label"),//签收日期
            name: 'recTime',
            width: '12%'
        },{
            display: $.i18n("govdoc.DistributeState.label"),//状态
            name: 'statusName',
            width: '10%'
        }, {
            display: '流程日志',//操作
            name: 'id',
            width: '11%'
        },{
            display: $.i18n("govdoc.CreateDate.label"),//创建日期
            name: 'createTime',
            width: '12%'
        }];
    }
    $(document).ready(function () {	
    $('#exchangeDetail').ajaxgrid({
        colModel:colmodel,
        render: rend,
        height: height,
        showTableToggleBtn: true,
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize: true
        },
        isHaveIframe: true,
        managerName: "govdocExchangeManager",
        managerMethod: "getGovdocExchangeDetail",
        usepager: false,
        onSuccess:function(){
            var colIndex = getStateAndOrgColIndex();
            var stateColIndex = colIndex[0];
            $('.bDiv table tr').each(function (index, ele) {
                var state = $(this).find("td a[status]").attr('status');//发行状态
                if (state == 2 || state == 12 || state == 11 || state == 0|| state==10) {//已签收或已结束、已经撤销、待交换、已回退
                    $(this).find('td:first-child input').attr("disabled", 'disabled');
                }
            });
        }
    });
	var obj = new Object();
	obj.summaryId = "${summaryId}";
	if(exchangeStatus&&exchangeStatus!=""){
		obj.status = exchangeStatus;
	}
    $("table.flexme3").ajaxgridLoad(obj);
    });
    function showDetail(summaryId,isCurrentUser){
    	if(summaryId == null || summaryId == ""){
    		alert("流程已经撤销");
    		return;
    	}
    	var openFrom = "listSent";
    	if(isCurrentUser=="0"){
    		openFrom="formQuery";
    	}
    	var url = "/seeyon/collaboration/collaboration.do?method=summary&chuantou=1&openFrom="+openFrom+"&isFromSendPro=1&summaryId=" + summaryId;
    	openCtpWindow({"url":url,"id":"showDetail"});
    }
    function rend(txt, data, r, c) {
    	if( (c == 2 && (exchangeStatus=="" ||exchangeStatus==1)) ||(c==1&&(exchangeStatus==23||exchangeStatus==10))){
    		if(chuantouchakan1 == 'true'&&data.status!=0){
				return "<a href='#' onclick='showDetail(\""+data.summaryId+"\",\"" + data.isCurrentUser + "\")'>"+txt+"</a>";
			}else{
				return txt;
			}
    	}
    	if (("${param.exchangeStatus}"=="" && c==7)
    			||("${param.exchangeStatus}"=="10" && c==6)
    			||(exchangeStatus==1&&c==4)
    			||(exchangeStatus==23&&c==6)) {
            var str = "";
            if (data.status == 1) {
                str += "<a href='javascript:void(0)' onclick='revoke(\"" + data.summaryId + "\",\"" + data.id + "\"," + true + ")'>[撤销]</a>&nbsp;&nbsp;";
            }
            if (data.status == 0 || data.status == 10 || data.status == 11) {
                str += "<a href='javascript:void(0)' onclick='reSend(\""+ data.recOrgId+"\",\"" + data.id + "\",\"" + data.canSend + "\")'>[重发]</a>&nbsp;&nbsp;";
            }
            str += "<a status='"+data.status+"' href='javascript:void(0)' onclick='showLog(\"" + data.id + "\")'>[日志]</a>";
            if (typeof(data.canThrough) != 'undefined' && data.canThrough == '1') {
                //穿透功能以后实现
                //str+= "<a href='javascript:void(0)' >[查看流程]</a>";
            }
            return str;
    	}
    	if(exchangeStatus==""&&(c==3||c==4||c==5)&&(data.status==10||data.status==11)){
    		return "";
    	}
        return txt;
    }
    function showLiucheng() {
        //var wfurl = _ctxPath+"/workflow/designer.do?method=showDiagram&showHastenButton=true&isModalDialog=false&isDebugger=false&scene="+_scene+"&processId="+_contextProcessId+"&caseId="+_contextCaseId+"&currentNodeId="+_contextActivityId+"&appName=collaboration&formMutilOprationIds="+operationId;
    }
	//加载统计数量 
	function initCount(){
		$.ajax({
            url: "/seeyon/collaboration/collaboration.do?method=initCount&summaryId="+mainSummaryId,
            data: {},
            dataType:"json",
            success: function (res) {
            	if(res.sendCount==null){
            		res.sendCount=0;
            	}
            	if(res.waitSignCount==null){
            		res.waitSignCount=0;
            	}
            	if(res.backCount==null){
            		res.backCount=0;
            	}
      		   $("#totalCount").text(res.totalCount);
      		   $("#sendCount").text(res.sendCount);
      		   $("#waitSignCount").text(res.waitSignCount);
      		   $("#backCount").text(res.backCount);
            }
        });	
	}
    //cx 重发
    function reSend(recOrgId,id, canSend) {
	        if (canSend == '1') {
	            $.ajax({
	                url: "/seeyon/collaboration/collaboration.do?method=reSend&dd="+new Date(),
	                data: {detailId: id},
					dataType:"text",
	                success: function (res) {
	                    if (res == "1") {
	                        var proce = $.progressBar();
	                        setTimeout(function () {
	                            proce.close();
	                            var exchange = new govdocExchangeManager();
	                        	var changeId = exchange.changeOrgId(recOrgId);
	                        	var returnVal = exchange.validateExistAccount(changeId);
	                        	if(returnVal && returnVal !=""){
	                        		$.alert("该单位未设置收文交换流程，流程处于待交换状态，请在分送状态中查看！");
	                        	}
	                        	window.location.reload();
	                        }, 4000);
	
	                    }else{
							$.alert("补发失败！");
						}
	                }
	            });
	        } else {
	            $.alert("发送失败，文号已被占用");
	        }
    	
    }
    //cx 日志
    function showLog(id) {
        var dialog = $.dialog({
            url: "/seeyon/collaboration/collaboration.do?method=showLog&detailId=" + id,
            width: 800,
            height: 400,
            title: '流程日志',
            targetWindow: getCtpTop(),
            buttons: [{
                text: $.i18n('collaboration.button.close.label'),
                handler: function () {
                    dialog.close();
                }
            }]
        });
    }

    var waitRevokeSummaryIds = [];//待撤销公文id
    var invalidSummaryIds = [];//不能撤销的公文id
    var validProcessIds = [];//待撤销的公文的process id
    var validAffairIds = [];//待撤销对的公文对应的affair id？
    var validStartAffairIds = [];//待撤销公文对应的发起节点affair id？

    function _concatArray(originalArray,validSummaryId) {
        if (validSummaryId != null && validSummaryId != '') {
            originalArray=originalArray.concat(validSummaryId.split(','));
        }
        return originalArray;
    }

    /**
     * 检查并撤销
     * @param summaryId
     * @param summaryIds 多个待撤销公文
     * @param isTrace 是否显示追溯流程的checkbox
     */
    function checkAndRevoke(summaryId, summaryIds, isTrace) {
        var affairId;
        var startAffairId;
        var processId;
        var validSummaryId;
        var _data = {summaryId: summaryId};
        if (summaryIds != null) {
            _data = {
                summaryIds: summaryIds
            };
            waitRevokeSummaryIds = summaryIds.split(',');
        }
        // 1.为了回退获取某些参数验证是否可以回退
        $.ajax({
            url: "/seeyon/collaboration/collaboration.do?method=forRevokeGetParams",
            data: _data,
            success: function (data) {
               
                var arr = eval('(' + data + ')');
                if (arr['error'] != null) {
                    alert("此数据不允许撤销");
                    return;
                }
                affairId = arr.affairId;
                startAffairId = arr.startAffairId;
                processId = arr.processId;
                var onlyOneAffair = arr.onlyOneAffair;
                validSummaryId = arr.validSummaryId;
                if (arr['error'] == !null) {//summaryIds场景
                    invalidSummaryIds = _concatArray(invalidSummaryIds,arr['error']);
                }
                waitRevokeSummaryIds = validSummaryId.split(',');
                validProcessIds = _concatArray(validProcessIds,processId);
                validAffairIds = _concatArray(validAffairIds,affairId);
                validStartAffairIds = _concatArray(validStartAffairIds,startAffairId);

                // 2.判断是否可以撤销.
                // 有审核(表单审核、新闻审核、公告审核)
                // 核定节点已处理过的，不允许撤销.<br>
                // 流程结束的不能撤销<br>
                // TODO 根据交换的逻辑，不需要检查表单相关的限制，先注释下面的逻辑，持续观察！
//                var _colManager = new colManager();
//                var params = new Object();
//                params["summaryId"] = waitRevokeSummaryIds.join(',');
//                //校验是否流程结束、是否审核、是否核定，涉及到的子流程调用工作流接口校验
//                var canDealCancel = _colManager.checkIsCanRepeal(params);//
//                if (canDealCancel.msg != null) {
//                    $.alert(canDealCancel.msg);
//                    return;
//                }
//                if (canDealCancel.errorSummaryIds != null) {// 多个待撤销summaryIds场景
//                    filterErrorSummaryId(canDealCancel.errorSummaryIds);
//                }

                // 3.事项是否可用
                if (!isAffairValid(affairId, waitRevokeSummaryIds.join(','))) {
                    return;
                }
                // 4.调用工作流接口校验是否能够撤销流程
                if(onlyOneAffair != "true"){
	                var repeal = canRepealMultiple('collaboration', validProcessIds.join(','), 'start');//
	                //不能撤销流程
	                if (repeal[0] == 'multiple') {//多公文
	                    var repealInfo = eval('(' + repeal[1] + ')');
	                    for (var rep in repealInfo) {
	                        if (repealInfo[rep][0] == 'false') {
	                            filterErrorSummaryId(rep);
	                        }
	                    }
	                } else if (repeal[0] === 'false') {//单公文
	                    $.alert(repeal[1]);
	                    return;
	                }
                }
                // 5.锁定工作流
                var lockWorkflowRe = lockWorkflowMultiple(validProcessIds.join(','), $.ctx.CurrentUser.id, 12);//
                if (lockWorkflowRe[0] == "false") {
                    $.alert(lockWorkflowRe[1]);
                    return;
                }else if(lockWorkflowRe[0]=='multiple'){//多公文
                    var lockInfo = eval('('+lockWorkflowRe[1]+')');
                    for (var lock in lockInfo) {
                        if (lockInfo[lock][0]=='false') {
                            filterErrorProcessId(lock);
                        }
                    }
                }

                // 6.在BeforeCancel之前处理下工作流
                if (!executeWorkflowBeforeEventMultiple("BeforeCancel", waitRevokeSummaryIds.join(','),
                                validAffairIds.join(','), validProcessIds.join(','), validProcessIds.join(','), "", "", "")) {//
                    return;
                }
                var bottomHtml ='<label for="trackWorkflow" class="margin_t_5 hand">' +
                        '<input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">' + $.i18n("collaboration.workflow.trace.traceworkflow") +
                        '</label><span class="color_blue hand" style="color:#318ed9;" title="' + $.i18n("collaboration.workflow.trace.summaryDetail2") +
                        '">[' + $.i18n("collaboration.workflow.trace.title") + ']</span>'
                if((typeof isTrace!="undefined")&&isTrace==false){
                    bottomHtml = '';
                }
                // 7.撤销流程
                var dialog = $.dialog({
                    url: _ctxPath + "/workflowmanage/workflowmanage.do?method=showRepealCommentDialog&affairId=" + affairId,
                    width: 450,
                    height: 240,
                    bottomHTML: bottomHtml,
                    title: $.i18n('common.repeal.workflow.label'),//撤销流程
                    targetWindow: getCtpTop(),
                    buttons: [{
                        text: $.i18n('collaboration.button.ok.label'),//确定
                        btnType: 1,
                        handler: function () {
                            var returnValue = dialog.getReturnValue();
                            if (!returnValue) {
                                return;
                            }
                            dialog.startLoading();
                            var ajaxSubmitFunc = function () {
                                var ajaxColManager = new colManager();
                                var tempMap = new Object();
                                tempMap["repealComment"] = returnValue[0];
                                if (waitRevokeSummaryIds.length > 0) {
                                    summaryId = waitRevokeSummaryIds.join(',');
                                }
                                tempMap["summaryId"] = summaryId;

                                tempMap["affairId"] = validStartAffairIds.join(',');
                                tempMap["trackWorkflowType"] = returnValue[1];

                                // 8.已发列表撤销流程
                                ajaxColManager.transRepal(tempMap, {
                                    success: function (msg) {
                                        // 9.全文检索，撤销已经重发部分
                                        var reIndex = false;
                                        if (msg == null || msg == "") {//
                                            reIndex = true;

                                        } else {
                                            var infos = eval('(' + msg + ')');
                                            if (infos == msg) {
                                                $.alert(msg);
                                            } else {//多公文
                                                for (var info in infos) {
                                                    if(infos[info]!=''){
                                                        filterErrorSummaryId(info);
                                                    }
                                                }
                                                reIndex = true;
                                            }
                                        }
                                        if (reIndex) {
                                            $.ajax({
                                                url: "/seeyon/collaboration/collaboration.do?method=revoke",
                                                data: {summaryId: summaryId},
                                                success: function (data) {
                                                	 var proce = $.progressBar();
                         	                        setTimeout(function () {
                         	                            proce.close();
                         	                           window.location.reload();
                         	                        }, 2000);
                                                }
                                            });
                                            dialog.close();
                                        }
                                        dialog.endLoading();
                                        //
                                        if (invalidSummaryIds != null&&invalidSummaryIds.length>0) {
                                            showInvalideOrg();
                                        }

                                        //撤销后关闭，子页面
                                        try {
                                            closeOpenMultyWindow(affairId);//TODO？感觉没意义
                                        } catch (e) {
                                        }

                                        waitRevokeSummaryIds = [];
                                        invalidSummaryIds = [];
                                        validProcessIds = [];
                                        validAffairIds = [];
                                        validStartAffairIds = [];
                                    }
                                });
                            }
                            //V50_SP2_NC业务集成插件_001_表单开发高级
                            // 10.
                            beforeSubmitMultiple(validAffairIds.join(','), "repeal", returnValue[0], dialog, ajaxSubmitFunc, null);//
                        }
                    }, {
                        text: $.i18n('collaboration.button.cancel.label'),//取消
                        handler: function () {
                            // 11.
                            releaseWorkflowByActionMultiple(validProcessIds.join(','), $.ctx.CurrentUser.id, 12);
                            dialog.close();
                        }
                    }]
                });
            }
        });
    }

    /**
     * 根据无效的公文id（errSummaryIds），
     * 处理waitRevokeIds，invalidSummaryIds，validProcessIds，validAffairIds,validStartAffairIds
     */
    function filterErrorSummaryId(errSummaryIds) {
        var errIds = errSummaryIds.split(',');
        // 过滤不能撤销的id
        var index = [];
        waitRevokeSummaryIds = $.grep(waitRevokeSummaryIds, function (val) {
            for (var i = 0; i < errIds.length; i++) {
                if (errIds[i] == val) {
                    invalidSummaryIds.push(val);
                    index.push(i);
                    return false;
                }
            }
            return true;
        });
        if(index.length>0){
            for(var i = index.length-1;i >=0 ; i--){
                validProcessIds=validProcessIds.splice(index[i], 1);
                validAffairIds=validAffairIds.splice(index[i], 1);
                validStartAffairIds=validStartAffairIds.splice(index[i], 1);
            }
        }
    }

    function filterErrorProcessId(errProcessIds){
        var errIds = errProcessIds.split(',');
        // 过滤不能撤销的id
        var index = [];
        validProcessIds=$.grep(validProcessIds, function (val) {
            for (var i = 0; i < errIds.length; i++) {
                if (errIds[i] == val) {
                    invalidSummaryIds.push(waitRevokeSummaryIds[i]);

                    return false;
                }
            }
            return true;
        });
        if(index.length>0){
            for(var i = index.length-1;i >=0 ; i--){
                waitRevokeSummaryIds=waitRevokeSummaryIds.splice(index[i], 1);
                validAffairIds=validAffairIds.splice(index[i], 1);
                validStartAffairIds=validStartAffairIds.splice(index[i], 1);
            }
        }
    }

    function revoke(summaryId, exchangeDetailId,isTrace) {
        //js事件接口
        var sendDevelop = $.ctp.trigger('beforeSentCancel');
        if (!sendDevelop) {
            return;
        }
        checkAndRevoke(summaryId,null,isTrace);
    }
    //ajax判断事项是否可用。
    function isAffairValid(affairId) {
        var cm = new colManager();
        var msg = cm.checkAffairValid(affairId);
        msg = $.trim(msg);
        if (msg != '' && msg.indexOf('error') == -1) {
            $.alert(msg);
            return false;
        } else if (msg != '') {//多公文且有错
            var data = eval('(' + msg + ')');
            for (var summaryId in data.error) {
                filterErrorSummaryId(summaryId);
            }
            return false;
        }
        return true;
    }

    /**
     * 改造自workflowDesigner_api.js(canRepeal())
     */
    function canRepealMultiple(appName, processId, nodeId) {
        try {
            var cm = new colManager();
            return cm.canRepeal(appName, processId, nodeId);
        } catch (e) {
            alert(e.message);
        }
    }

    /**
     * 工作流流程事件前端JS执行函数
     * 改造自workflowDesigner_api.js(executeWorkflowBeforeEvent)
     */
    function executeWorkflowBeforeEventMultiple(event, bussinessId, affairId, processTemplateId, processId, activityId, formData, appName) {
        if (hasWorkflowEvent == "false" || hasWorkflowEvent == false) {
            return true;
        }
        if ((processTemplateId == null || processTemplateId == "") && (processId == null || processId == "")) {
            return true;
        }
        var context = new Object();
        context["formData"] = formData;
        context["mastrid"] = formData;
        context["processTemplateId"] = processTemplateId;
        context["processId"] = processId;
        context["currentActivityId"] = activityId;
        context["bussinessId"] = bussinessId;
        context["affairId"] = affairId;
        context["appName"] = appName;

        var cm = new colManager();
        var result = cm.executeWorkflowBeforeEvent(event, context);
        if(result && result != ""){
        	result = eval('('+result+')');
        }
        if (result && result != "" && result[0]!='multiple') {
            $.alert(result);
            try {
                releaseApplicationButtons();//回调
            } catch (e) {
            }
            return false;
         }else if(result && result != ""){//多正文
            var res = result[1];
            var hasError = false;
            for (var pId in res) {
                if (res[pId]!='') {
                    hasError = true;
                    filterErrorProcessId(pId);
                }
            }
            return !hasError;
        }
        return true;
    }

    /**
     * 改造自workflowDesigner_api.js(lockWorkflow())
     * @param processId
     * @param currentUserId
     * @param action
     * @returns {*}
     */
    function lockWorkflowMultiple(processId, currentUserId, action) {
        try {
            var cm = new colManager();
            var result = cm.lockWorkflow(processId, currentUserId, action);
            if (result == null) {
                result = new Array("false", $.i18n('workflow.wapi.exception.msg002'));
            }
            return result;
        } catch (e) {
            alert(e.message);
        }
    }

    /**
     * 解除流程锁
     * 改造自workflowDesigner_api.js(releaseWorkflowByAction())
     * @processId:流程ID
     * @currentUserId:当前登录用户ID
     * @action 14: preSendOrHandleWorkflow时
     * 返回String[2]:String[0]:"true":表示解锁成功,"false":表示解锁失败;String[1]:当前占用锁的操作类型提示信息
     */
    function releaseWorkflowByActionMultiple(processId, currentUserId, action) {
        try {
            var cm = new colManager();
            return cm.releaseWorkflow(processId, currentUserId, action);
        } catch (e) {
            alert(e.message);
        }
    }

    function handleTask(taskType, r, affairid, attitude, content, object, failedCallBack, dialog, sucessCallback) {
        var ds1;
        if ("ext" == taskType) {
            ds1 = r.preHandler(affairid, attitude, content);

            if (ds1 && typeof (ds1) == "object") {
                if (ds1[0] == '1') {
                    if (object != null) {
                        object.close();
                    }
                    var extContent = ds1[1].replace(/[\r\n]/g, "");
                    var dialog = $.dialog({
                        url: "${path}/genericController.do?ViewPage=ctp/form/design/eventTip&content="
                        + encodeURIComponent(extContent),
                        title: "审核结果",
                        width: 300,
                        height: 300,
                        buttons: [
                            {
                                text: "转审核意见",
                                id: "sure1",
                                handler: function () {
                                    if (content != "") {
                                        content = content + "\r\n" + "-----------------------------" + "\r\n";
                                    }
                                    $("#content_deal_comment").val(content + extContent);
                                    failedCallBack();
                                    dialog.close();
                                }
                            },
                            {
                                text: "${ctp:i18n('form.query.cancel.label')}",
                                id: "exit1",
                                handler: function () {
                                    failedCallBack();
                                    dialog.close();
                                }
                            }
                        ]
                    });
                }
            } else {
                sucessCallback();
            }
        } else if ("dee" == taskType) {
            executeDeeTask(r, affairid, attitude, content, null, "false", sucessCallback, failedCallBack);
        } else {
            sucessCallback();
        }
        return content;
    }
    /**
     * 改造自formDevelopmentOfadv.jsp的beforeSubmit方法
     * @param affairid
     * @param attitude
     * @param content
     * @param object
     * @param sucessCallback
     * @param failedCallBack
     */
    function beforeSubmitMultiple(affairid, attitude, content, object, sucessCallback, failedCallBack) {
        var r = new collaborationFormBindEventListener();

        var taskType = r.achieveTaskType(affairid, attitude, content);
        if (taskType) {
            taskType = eval('(' + typeType + ')');
            if (typeof taskType == 'object') {//多正文
                for (var aId in taskType) {
                    handleTask(taskType, r, aId, attitude, content, object, failedCallBack, dialog, null);
                }
                sucessCallback();
            } else {
                content = handleTask(taskType, r, affairid, attitude, content, object, failedCallBack, dialog, sucessCallback);
            }
        } else {
            sucessCallback();
        }
    }

    function getStateAndOrgColIndex(){
        var recOrgColIndex = 1;
        $('.hDiv table tr th').each(function (index, ele) {
            var colmode = $(this).attr('colmode');
            if (colmode == 'recOrgName') {
                recOrgColIndex = index + 1;
                return false;
            }
        });
        return recOrgColIndex;
    }
    function showInvalideOrg() {
        var invalidUnit = [];
        var recOrgColIndex = getStateAndOrgColIndex();

        var fTds = $('.bDiv table tr td:first-child');
        $.grep(invalidSummaryIds, function (ele, index) {
            var input = fTds.find('input[value="' + ele + '"]');
            if (input.length == 1) {
                invalidUnit.push(input.parents('tr').find('td:nth-child(' + recOrgColIndex + ') div').text().trim());
            }
        });
        $.alert($.i18n('govdoc.distribute.revoke.warning') + '\n' + invalidUnit.join('，'));
    }
    $(document).ready(function () {
		 //相应统计数据点击事件
		 //总数
		 $("#totalCount").click(function() {
			 location.href="/seeyon/collaboration/collaboration.do?method=showDistributeState&summaryId="+mainSummaryId;
		 });
		 //已签收
		 $("#sendCount").click(function() {
			 location.href="/seeyon/collaboration/collaboration.do?method=showDistributeState&exchangeStatus=23&summaryId="+mainSummaryId;
		 });
		 //待签收
		 $("#waitSignCount").click(function() {
			 location.href="/seeyon/collaboration/collaboration.do?method=showDistributeState&exchangeStatus=1&summaryId="+mainSummaryId;
		 });
		 //已退回
		 $("#backCount").click(function() {
			 location.href="/seeyon/collaboration/collaboration.do?method=showDistributeState&exchangeStatus=10&summaryId="+mainSummaryId;
		 });

        // 工具栏
        if(exchangeStatus!=23&&exchangeStatus!=10){
	      	$('#distributeStateToolbar').toolbar({
	            toolbar: [{
	                id: 'revoke',
	                name: $.i18n('govdoc.Revoke.label'),
	                className: 'ico16 revoked_process_16',
	                click: function () {
	                    invalidSummaryIds = [];
	                    var checked = $('.bDiv table tr td input:checked');
	                    if (checked.length == 0) {
	                        $.alert($.i18n('collaboration.govdoc.listSent.selectRevokeSyn'));
	                    } else {
	                        var summaryIds = [];
	                        checked.each(function (index, ele) {
	                            summaryIds.push($(this).val());
	                        });
	                        if (summaryIds.length > 0) {
	                            //js事件接口
	                            var sendDevelop = $.ctp.trigger('beforeSentCancel');
	                            if (!sendDevelop) {
	                                return;
	                            }
	                            if(summaryIds.length==1){
	                                checkAndRevoke(summaryIds[0],null);
	                            }else{
	                                checkAndRevoke(null, summaryIds.join(','));
	                            }
	                        }
	                    }
	                }
	            }]
	
	        });
        }
    });
</script>
</html>