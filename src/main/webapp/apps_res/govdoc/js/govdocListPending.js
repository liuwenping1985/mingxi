//批处理
function batchDeal(){
    var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
        $.alert($.i18n('collaboration.listPending.selectBatchData')); //请选择要删除的记录
        return;
    }
    var process = new BatchProcess();
    for(var i = 0 ; i < rows.length;i++){
            var affairId = rows[i].affairId;
            var subject = rows[i].subject;
            var category =  rows[i].category||"1";
            var summaryId =  rows[i].summaryId;
            process.addData(affairId,summaryId,category,subject);
    }
    if(!process.isEmpty()){
        var r = process.doBatch();
    }
    //try{window.location.reload();}catch(e){}
}


//取消加粗
function cancelBold(rowIndex){
    var obj = $("tr:eq("+rowIndex+")").find(".font_bold");
    if(obj!=null && typeof(obj)!='undefined')  obj.removeClass("font_bold");
}
function rend(txt, data, r, c) {
    //未读  11  加粗显示
    var subState = data.subState;
    if(null == txt){//修正  如果是未讀，那麼會顯示null字符串
    	txt = "";
    }
    if(subState === 11){
        txt = "<span class='font_bold'>"+txt+"</span>";
    }
    if(c === 2){
    	//标题列加深
	    txt="<span class='grid_black'>"+txt+"</span>";
        //如果是代理 ，颜色变成蓝色
        if(data.proxy){
            txt = "<span class='color_blue'>"+txt+"</span>";
        }
        //加图标
        //重要程度 1普通 2平急 3加急 4特急 5特提
        if(data.importantLevel !==""&&  data.importantLevel >1 && data.importantLevel<=5){
            txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt;
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
        if(data.nodeDeadLineName !=$.i18n('collaboration.project.nothing.label')){
            if(data.isCoverTime){
                //超期图标
                txt = txt + "<span class='ico16 extended_red_16'></span>" ;
            }else{
                //未超期图标
                txt = txt + "<span class='ico16 extended_blue_16'></span>" ;
            }
        }
    } else if(c == 1){
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
    }else if(c === 10){
        if(data.isCoverTime){
            //超期图标
            txt = "<span class='color_red'>"+txt+"</span>" ;
        }
    }else if(c === 8){
    	if(data.surplusTime == null){
    		return $.i18n("govdoc.none.label");
    	}
    	if(data.surplusTime[0] <= 0 && data.surplusTime[1] <= 0 && data.surplusTime[2] <= 0){
			if(data.isCoverTime){
				//超期图标
				return "<span class='color_red'>"+$.i18n("govdoc.node.isovertime.label")+"</span>" ;
			}
    		return $.i18n("govdoc.node.isovertime.label");
    	}
    	if(data.surplusTime[0] != 0){
    		return data.surplusTime[0] + $.i18n("govdoc.time.day.label");
    	}
    	if(data.surplusTime[1] != 0){
    		return data.surplusTime[1] + $.i18n("govdoc.time.hour.label");
    	}
    	if(data.surplusTime[2] != 0){
    		return data.surplusTime[2] + $.i18n("govdoc.time.minute.label");
    	}
    	
    }else if (c === 12){
    	if(null != data.processId){
    		return "&nbsp;<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)'></a>&nbsp;";
    	}
    	return "";
    }else if(c == 9){
    	 if(data.isCoverTime){
             //超期图标
             txt = "<span class='color_red'>"+txt+"</span>" ;
         }
    }
    
    return txt;
}

//双击事件
function dbclickRow(data,rowIndex, colIndex){
	if(colIndex==11){
		return;
	}
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);

    //取消加粗
    //cancelBold(rowIndex);
    $("#listPending tr").eq(rowIndex).find("span").removeClass("font_bold");

    if(!isAffairValid(data.affairId)){
        $("#listPending").ajaxgridLoad();
        return;
    }
	var url =  "";
	if(data.app == 4){//新公文 //根据 app 判断对应的公文种类
		url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId;
	}else if(data.app == 19){//发文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=Pending&affairId="+data.affairId;
	}else if(data.app == 20){//收文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=Pending&from=Pending&affairId="+data.affairId;
	}else if(data.app == 21){//签报
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=Pending&from=Pending&affairId="+data.affairId;
	}else if(data.app == 22){ //交换 待发送公文
		url =  _ctxPath + "/exchangeEdoc.do?method=sendDetail&modelType=toSend&id="+data.workitemId+"&affairId="+data.affairId;
	}else if(data.app == 23){//待签  收公文
		url =  _ctxPath + "/exchangeEdoc.do?method=receiveDetail&modelType=toReceive&userId=&id="+data.workitemId;
	}else if(data.app == 34){
			parent.window.location.href=_ctxPath + 
			"/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&recListType=listDistribute&id="
			+data.summaryId+"&affairId="+data.affairId+"&sub_app="+sub_app+"&app="+data.app;
		return;
	}else if(data.app == 24){//待登记 公文
		url = _ctxPath + "/edocController.do?method=newEdocRegister&edocType=1&affairId="+data.affairId+
		"&listType=newEdocRegister&recListType=registerPending&comm=create&edocId="+data.summaryId+"&exchangeId="+data.workitemId+"&registerType=1";
		window.location.href = url;
		return;
	}else if(data.app == 40){//待登记 草稿
		url = _ctxPath + "/edocController.do?method=newEdocRegister&comm=edit&edocType=1&recieveId=-1&edocId=-1&registerType=1&sendUnitId=-1&registerId="+data.summaryId+"&listType=registerDraft&recListType=registerDraft";
		window.location.href = url;
		return;
	}
    
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    //$('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total+"&r=" + Math.random());
}
//删除
function deleteCol(){
    deleteItems('pending',grid,'listPending',paramMethod);
}

function transmitCol(){
    transmitColFromGrid(grid);
}

var TimeFn = null;
function clickRow(data,rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);

    //取消加粗
    cancelBold(rowIndex);

    //执行延时
    TimeFn = setTimeout(function(){
        //去掉加粗显示
        $("#listPending tr").eq(rowIndex).find("span").removeClass("font_bold");
        if(!isAffairValid(data.affairId)){
            $("#listPending").ajaxgridLoad();
            return;
        }
        if(!exitWinOpen(data.affairId)) {
            return;
        };
        $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="+data.affairId + "&openNewWindow=false&app=4&summaryId="+data.summaryId);
    },300);
}

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
	
	var onlyQuickSend = "";
	if(!$.ctx.resources.contains('F20_newSend') && $.ctx.resources.contains('F20_fawenNewQuickSend')){
		onlyQuickSend = "true";
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
              var url = "/seeyon/collaboration/collaboration.do?method=newColl&app=4&sub_app=1&forwardAffairId="+forwardAffairId+"&forwardText=" + rv+ "&isQuickSend="+onlyQuickSend;
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
		//alert("不能选择发文流程/交换流程");
		$.alert($.i18n('govdoc.edoc.listDone.dontProcess'));
		return;
	}
	var affairId = rows[0].affairId;
	var summaryId = rows[0].summaryId;
	var ajaxColManager = new colManager();
	var result = ajaxColManager.verifyTurnRecEdoc(affairId);
	if(result != true){
		$.alert("该节点不能转收文");
		return;
	}
	var dialog = $.dialog({
        id : "turnRecEdoc",
        height:"300",
        width:"400",
        targetWindow:getCtpTop(),
        url : _ctxPath + '/collaboration/collaboration.do?method=toTurnRecEdoc',
        title : '转收文',
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

var grid;
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
    if(sub_app.indexOf("2") > -1){
    	//转发文
    	if($.ctx.resources.contains('F20_newSend') || $.ctx.resources.contains('F20_fawenNewQuickSend')){
    		toolbarArray.push({id: "forwardText",name: $.i18n('govdoc.button.forwardText.label') ,className: "ico16 forwardText_16",click:forwardText});
    	}
/*    	//转收文
    	if($.ctx.resources.contains('F20_newDengji') ){
    	    toolbarArray.push({id: "turnRecEdoc",name: $.i18n('govdoc.button.turnRecEdoc.label') ,className: "ico16 forwardText_16",click:turnRecEdoc});
    	}*/
    }
    /*//归档
    if($.ctx.resources.contains('F04_docIndex') || $.ctx.resources.contains('F04_docHomepageIndex')){
        toolbarArray.push({id: "pigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click:  function(){doPigeonhole("pending", grid, "listPending");}});
    }*/
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
    searchobj= $.searchCondition({
        top:topSearchSize,
        right:50,
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
                $("#listPending").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(undefined != _summarySrc && _summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total+"&r=" + Math.random());	
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
        },{
            id:'subState',
            name:'subState',
            type:'select',
            text:$.i18n("collaboration.trans.label"),
            value:'subState',
            ifFormat:'%Y-%m-%d',
            dateTime:false,
            items: [{
                text: $.i18n("collaboration.toolTip.label11"),//未读
                value: '11'
            }, {
                text: $.i18n("collaboration.toolTip.label12"),//已读
                value: '12'
            }, {
                text:$.i18n("collaboration.dealAttitude.temporaryAbeyance"),//暂存待办
                value: '13'
            }, {
                text:$.i18n("collaboration.toolTip.label16"),//被回退
                value: '2'
            }, {
                text:$.i18n("collaboration.default.stepBack"),//指定回退
                value: '15'
            }]
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
        sortable : true,
        width: '5%'
    },{
        display: $.i18n("common.subject.label"),//标题
        name: 'subject',
        sortable : true,
        width: '30%'
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
    }, {
        display: $.i18n("common.date.sendtime.label"),//发起时间
        name: 'startDate',
        sortable : true,
        width: '10%'
    },  {
        display: $.i18n("govdoc.remainingTime.label"),//办理剩余时间
        name: 'surplusTime',//錯誤字段後面需要修改
        sortable : true,
        width: '9%'
    }, {
        display: $.i18n("pending.deadlineDate.label"),//处理期限（节点期限）
        name: 'nodeDeadLineName',
        sortable : true,
        width: '9%'
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
    }, {
        display: $.i18n("processLog.list.title.label"),//流程日志
        name: 'processId',
        width: '9%'
    }];
    if(sub_app.indexOf(",") == -1){
    	colModel[1].hide=true;
    	colModel[1].isToggleHideShow=false;
    };
    //表格加载 密级    紧急程度    标题    公文文号    内部文号    发起人    发起时间    处理期限    办理剩余时间    催办次数    流程日志
    grid = $('#listPending').ajaxgrid({
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
        managerMethod : "getPendingList"
    });
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total+"&r=" + Math.random());



});

function loadPendingGrid() {
	var url = window.location.search;
    var o = new Object();
    setParamsToObject(o,url);
    $("#listPending").ajaxgridLoad(o);
}

//判断当前窗口是否打开了
function exitWinOpen(affairId) {
    var _wmp = getCtpTop()._windowsMap;
    if(_wmp){
    	//参考common-debug.js修改
    	try{
    	   var _wmpKeys= _wmp.keys();
    	}catch(e){//兼容处理，为了解决bug：OA-80754公司协同：连续打开2个新闻、2个公告，页签不关闭，这时，首页待办栏目中的标题点不动，栏目空间都可以刷新。
    	   getCtpTop()._windowsMap= new Properties();
    	   _wmp = getCtpTop()._windowsMap;
    	}
    	
        //不存在的情况删除之前打开的信息
        for(var p = 0;p<_wmp.keys().size();p++){
            var _kkk = _wmp.keys().get(p);
            try{
                var _fff = _wmp.get(_kkk);
                var _dd = _fff.document;
                if(_dd){
                    var _p = parseInt(_dd.body.clientHeight);
                    if(_p == 0){
                        _wmp.remove(_kkk);
                        p--;
                    }
                }else{
                    _wmp.remove(_kkk);
                    p--;
                }
            }catch(e){
                _wmp.remove(_kkk);
                p--;
            }
        }
        var exitWin = _wmp.get(affairId);
        if(exitWin){
            try{
                alert($.i18n("window.already.exit.js"));
                exitWin.focus();
                return false;
            }catch(e){
            }
        }
    }

    return true;
}

function colseQuery() {
    try{
        var dialogTemp=window.parentDialogObj['queryDialog'];
        dialogTemp.close();
    }catch(e){
    }
}