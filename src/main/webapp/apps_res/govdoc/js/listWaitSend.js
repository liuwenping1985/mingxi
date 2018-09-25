//发送
function send(){
    sendFromWaitSend(grid);
}

function rend(txt, data, r, c,col) {
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
	    //协同类型//注释屏蔽列表的正文类型图标
	    //if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
	    //    txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
	    //}
        return txt;
    }else{
    	 if (col.name=='subState') {
             var key = "collaboration.substate.new."+data.subState+".label";
             txt = $.i18n(key);
	    }
        return txt;
    }
}
   
function transmitCol(){
    transmitColFromGrid(grid);
}

 //删除
function deleteCol(){
	//js事件接口
	var sendDevelop = $.ctp.trigger('beforeWaitSendDelete');
	if(!sendDevelop){
		 return;
	}
	
    deleteItems('draft',grid,'listWaitSend',paramMethod,'govdoc');
}
function edit(){
	 var rows = grid.grid.getSelectRows();
	 var count= rows.length;
	 if(count==0){
		// 请选择要编辑的公文
	    $.alert($.i18n('collaboration.edoc.grid.alert.selectEdit'));
	    return;
	 }
	 if(count == 1){
     var obj = rows[0];
     if(obj.govdocType == 1 && !$.ctx.resources.contains('F20_newSend')){//发文
		$.alert($.i18n('edoc.alert.noSendPri.noFunction'));
		return;
     }else if(obj.govdocType == 2 && !$.ctx.resources.contains('F20_newDengji')){//收文
    	 $.alert($.i18n('edoc.alert.noRecPri.noFunction'));
 		 return;
     }
     //老公文待办  屏蔽进入编辑界面
	  if(obj.app > 4){
			//$.alert($.i18n('edoc.alert.oldEdocSummary.noFunction'));
		    dbclickRow(obj);
			return;
		}
	 }
	editFromWaitSend(grid,_app,sub_app);//4为新公文标记
}


//定义setTimeout执行方法
var TimeFn = null;
function clickRow(data,rowIndex, colIndex) {
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    //执行延时
    /*TimeFn = setTimeout(function(){
        $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listWaitSend&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId);
    },300);*/
    var url =  "";
    if(data.app == 4){//新公文 //根据 app 判断对应的公文种类
    	url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listWaitSend&affairId="+data.affairId+"&app=4&summaryId="+data.summaryId;
	}else if(data.app == 19){//发文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listWaitSend&affairId="+data.affairId;
	}else if(data.app == 20){//收文
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listWaitSend&affairId="+data.affairId;
	}else if(data.app == 21){//签报
		url = _ctxPath + "/edocController.do?method=detailIFrame&from=listWaitSend&affairId="+data.affairId;
	}else if(data.app == 22){ //交换 已发送
		//url =  _ctxPath + "/exchangeEdoc.do?method=edit&id="+data.summaryId+"&modelType=sent";
	}else if(data.app == 23){//交换 已签收
		//url =  _ctxPath + "/exchangeEdoc.do?method=edit&modelType=received&upAndDown=true&id="+data.summaryId;
	}else if(data.app == 24){
		//url = _ctxpath + "/exchangeEdoc.do?method=edit&modelType=received&id="+data.summaryId+"&newDate="+new date()+"&nodeAction=swWaitRegister"
	}else if(data.app == 40){//已登记 公文
		url = _ctxPath + "/edocController.do?method=edocRegisterDetail&forwardType=registered&registerId="+data.summaryId;
	}
    var title = data.subject;
    doubleClick(url,escapeStringToHTML(title));
    grid.grid.resizeGridUpDown('down');
}

function dbclickRow(data,rowIndex, colIndex){
	 // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
	//老公文待办  屏蔽进入编辑界面
	var url =  "";
	if(data.app == 4){//新公文 //根据 app 判断对应的公文种类
		editFromWaitSend(grid,_app,data.govdocType);//4为新公文标记
		return;
	}else if(data.app == 19 || data.app == 20 || data.app == 21){//发文
		var entry = "sendManager";
		if(data.app == 20){
			entry = "recManager";
		}else if(data.app == 21){
			entry = "signReport";
		}
		if(parent.window.location.href.indexOf("/main.do?method=main") > -1){
				window.location.href=_ctxPath + "/edocController.do?method=entryManager&entry="+entry+"&toFrom=newEdoc&recListType=listDistribute&summaryId="+data.summaryId+"&affairId="+data.affairId+"&sub_app="+sub_app+"&app="+data.app;
		}else if(parent.parent.window.location.href.indexOf("/main.do?method=main") > -1){
			parent.window.location.href=_ctxPath + "/edocController.do?method=entryManager&entry="+entry+"&toFrom=newEdoc&recListType=listDistribute&summaryId="+data.summaryId+"&affairId="+data.affairId+"&sub_app="+sub_app+"&app="+data.app;
		}
		return;
	}else if(data.app == 22){ //交换 已发送
		//url =  _ctxPath + "/exchangeEdoc.do?method=edit&id="+data.summaryId+"&modelType=sent";
	}else if(data.app == 23){//交换 已签收
		//url =  _ctxPath + "/exchangeEdoc.do?method=edit&modelType=received&upAndDown=true&id="+data.summaryId;
	}else if(data.app == 24){
		//url = _ctxpath + "/exchangeEdoc.do?method=edit&modelType=received&id="+data.summaryId+"&newDate="+new date()+"&nodeAction=swWaitRegister"
	}else if(data.app == 40){//已登记 公文
		url = _ctxPath + "/edocController.do?method=newEdocRegister&comm=edit&edocType=1&recieveId="+data.processId+"&edocId="+data.caseId+"&registerType=1&sendUnitId=-8570577038226994488&listType=registerDraft&recListType=registerDraft&registerId="+data.summaryId;
	}
	var title = data.subject;
	doubleClick(url,escapeStringToHTML(title));
	grid.grid.resizeGridUpDown('down');
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listWaitSend&size="+grid.p.total+"&r=" + Math.random());
}

 var grid ;
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
    //编辑
    toolbarArray.push({id: "edit",name:$.i18n('collaboration.edit.label'),className: "ico16 editor_16",click:edit});
    //删除
    toolbarArray.push({id: "delete",name: $.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteCol});
    //toolbar扩展
    for (var i = 0;i<addinMenus.length;i++) {
        toolbarArray.push(addinMenus[i]);
    }
    $("#toolbars").toolbar({
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
            }else if(choose=='secretLevel'){//密级
            	o.secretLevelQuery=$('#secretLevel').val();
            	//o.accurate='accurate';
            }else if(choose === 'subject'){
                o.subject = $('#subject').val();
            }else if(choose === 'createDate'){
                var fromDate = $('#from_datetime').val();
                var toDate = $('#to_datetime').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.createDate = date;
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
                $("#listWaitSend").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(undefined != _summarySrc && _summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listWaitSend&size="+grid.p.total+"&r=" + Math.random());	
                	},1000);
                }
            }
        },
        conditions: [{
            id: 'subject',
            name: 'subject',
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
        },{
            id: 'secretLevel',
            name: 'secretLevel',
            type: 'select',
            text: $.i18n("govdoc.secretLevel.label"),//密级
            value: 'secretLevel',
            items: secretLevelOptions
        }, {
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: $.i18n("common.date.sendtime.label"),//发起时间
            value: 'createDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }, {
          id: "subState",
          name: 'subState',
          type: 'select',
          text: $.i18n('common.coll.state.label'),//状态
          value: 'subState',
          items: [{
              text: $.i18n("collaboration.substate.3.label"),//撤销
              value: '3'
          }, {
              text:$.i18n("collaboration.substate.1.label"),//草稿
              value: '1'
          }, {
            text: $.i18n("collaboration.substate.new.2.label"),//回退
            value: '2'
          }]
        }]
    });
    var colModel =[{
        display: 'id',
        name: 'id',
        width: '4%',
        type: 'checkbox'
    },{
        display: "分类",//分类
        name: 'govdocType',
        sortable : false,
        width: '5%'
    }, {
        display: $.i18n("common.subject.label"),//标题
        name: 'subject',
        sortable : true,
        width: '36%'
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
    }, {
        display: $.i18n("common.coll.state.label"),//状态
        name: 'subState',
        sortable : true,
        width: '8%'
    },{
        display: $.i18n("common.date.sendtime.label"),//发起时间
        name: 'startDate',
        sortable : true,
        width: '10%'
    },{
        display: $.i18n("collaboration.process.cycle.label"),//流程期限
        name: 'processDeadLineName',
        sortable : true,
        width: '9%'
    }];
    if(sub_app.indexOf(",") == -1){
    	colModel[1].hide=true;
    	colModel[1].isToggleHideShow=false;
    };
    //表格加载
        grid = $('#listWaitSend').ajaxgrid({
        colModel: colModel,
        click: clickRow,
        dblclick: dbclickRow,
        render:rend,
        height: 200,
        showTableToggleBtn: true,
        isHaveIframe:false,
        managerName : "edocManager",
        managerMethod : "getWaitSendList",
        parentId: $('.layout_center').eq(0).attr('id'),
        slideToggleBtn:false,
        vChange: false,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        }
    });
    
    
    //页面底部说明加载
    $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listWaitSend&size="+grid.p.total+"&r=" + Math.random());
    
  
});           