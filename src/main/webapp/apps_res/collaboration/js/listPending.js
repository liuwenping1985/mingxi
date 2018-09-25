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
    if(subState === 11){
        txt = "<span class='font_bold'>"+txt+"</span>";
    }
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
            txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt;
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
        if(data.nodeDeadLineName !=$.i18n('collaboration.project.nothing.label')){
            if(data.isCoverTime){
                //超期图标
                txt = txt + "<span class='ico16 extended_red_16'></span>" ;
            }else{
                //未超期图标
                txt = txt + "<span class='ico16 extended_blue_16'></span>" ;
            }
        }
    } else if(c === 5){
        if(data.isCoverTime){
            //超期图标
            txt = "<span class='color_red'>"+txt+"</span>" ;
        }
    }else if(c === 7){
        var titleTip = subState;
        if (subState === 16 || subState === 17 || subState === 18 ) {
           titleTip  = 16;
        };
        var toolTip = $.i18n('collaboration.toolTip.label' + subState);
        var backFromId = data.backFromId;
        var isBackfrom = false;
        if (backFromId != null) {
            isBackfrom = true;
        }
        if(isBackfrom && subState != 13){//被回退并且暂存待办后不显示。被回退图标
            toolTip = $.i18n('collaboration.toolTip.label' + 16);
//            if(subState ==15 || subState ==16){
//            	toolTip =$.i18n("collaboration.default.stepBack");
//            }
            return "&nbsp;<span class='ico16 be_rolledback_16' title='"+ toolTip +"'></span>&nbsp;" ;
        }else if(subState === 12) {
            return "&nbsp;<span class='ico16 viewed_16' title='"+ toolTip +"'></span>&nbsp;" ;
        }else{
        	if(subState ==15 || subState == 17){
            	toolTip =$.i18n("collaboration.default.stepBack");
            	if(subState == 17){
            		//指定回退中间节点的时候按照指定回退发起方显示图标
            		subState = 15; 
            	}
            }
            return "&nbsp;<span class='ico16 pending" + subState + "_16' title='"+ toolTip +"'></span>&nbsp;" ;
        }
    }else if (c === 8){
        return "&nbsp;<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)'></a>&nbsp;";
    }
    return txt;
}
var openCount = 0;
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
   // alert(1);
    //取消加粗
    //cancelBold(rowIndex);
    $("#listPending tr").eq(rowIndex).find("span").removeClass("font_bold");

    if(!isAffairValid(data.affairId)){
        $("#listPending").ajaxgridLoad();
        return;
    }
    var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="+data.affairId;
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total+"&r=" + Math.random());
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
	openCount++;
	if(openCount>1){
		return;
	}
	setTimeout(function(){
		openCount = 0; 
	},2000) ;
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
        $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId="+data.affairId + "&openNewWindow=false");
        $(".slideUpBtn").click(function(){
        	//重新刷新子页面iframe框架
        	$('#summary').contents().find("#formRelativeDiv").get(0).contentWindow.location.reload(true)
        })
    },300);
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
   //     toolbarArray.push({id: "pigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click:  function(){doPigeonhole("pending", grid, "listPending");}});
    }
    //删除
    //toolbarArray.push({id: "delete",name: $.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteCol});
    //批处理
    toolbarArray.push({id: "batchDeal",name: $.i18n('collaboration.batch.title'),className: "ico16 batch_16",click:batchDeal});
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
            // o.templeteIds="-2371613798075315656";
            // alert(1);
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
            if(val !== null){
                $("#listPending").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(_summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src","collaboration.do?method=listDesc&type=listPending&size="+grid.p.total+"&r=" + Math.random());	
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
                text: $.i18n("common.importance.putong"),//普通
                value: '1'
            }, {
                text: $.i18n("common.importance.zhongyao"),//重要
                value: '2'
            }, {
                text: $.i18n("common.importance.feichangzhongyao"),//非常重要
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
            id:'receivetime',
            name:'receivetime',
            type:'datemulti',
            text: $.i18n("cannel.display.column.receiveTime.label"),//接受时间
            value:'receiveDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
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
    //表格加载
    grid = $('#listPending').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'affairId',
            width: '4%',
            type: 'checkbox',
            isToggleHideShow:false
        }, {
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '32%'
        },{
            display: $.i18n("cannel.display.column.sendUser.label"),//发起人
            name: 'startMemberName',
            sortable : true,
            width: '7%'
        }, {
            display: $.i18n("common.date.sendtime.label"),//发起时间
            name: 'startDate',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("cannel.display.column.receiveTime.label"),//接收时间
            name: 'receiveTime',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("pending.deadlineDate.label"),//处理期限（节点期限）
            name: 'nodeDeadLineName',
            sortable : true,
            width: '9%'
        }, {
            display: $.i18n("collaboration.col.hasten.number.label"),//催办次数
            name: 'hastenTimes',
            sortable : true,
            width: '9%'
        }, {
            display:$.i18n("common.deal.state"),//处理状态
            name: 'subState',
            width: '9%'
        },{
            display: $.i18n("processLog.list.title.label"),//流程日志
            name: 'processId',
            width: '9%'
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
        managerMethod : "getPendingList"
    });
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+grid.p.total+"&r=" + Math.random());



});

function loadPendingGrid() {
    $("#listPending").ajaxgridLoad();
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