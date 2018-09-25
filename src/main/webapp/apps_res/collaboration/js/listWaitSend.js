//发送
function send(){
    sendFromWaitSend(grid);
}

function rend(txt, data, r, c,col) {
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
	    //协同类型
	    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
	        txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
	    }
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
	
    deleteItems('draft',grid,'listWaitSend',paramMethod);
}
function edit(){
    editFromWaitSend(grid);
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
    //执行延时
    TimeFn = setTimeout(function(){
        $('#summary').attr("src","collaboration.do?method=summary&openFrom=listWaitSend&affairId="+data.affairId);
    },300);
}

function dbclickRow(){
	openCount++;
	if(openCount>1){
		return;
	}
	setTimeout(function(){
		openCount = 0; 
	},2000) ;
    // 取消上次延时未执行的方法
    clearTimeout(TimeFn);
    editFromWaitSend(grid);
    //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listWaitSend&size="+grid.p.total+"&r=" + Math.random());
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
    var submenu = new Array();
    //判断是否有新建协同的资源权限，如果没有则屏蔽转发协同
    if ($.ctx.resources.contains('F01_newColl')) {
    	submenu.push({name:  $.i18n('collaboration.transmit.col.label'),click: transmitCol });
    };
    //判断是否有转发邮件的资源权限，如果没有则屏蔽转发协同
    if ($.ctx.resources.contains('F12_mailcreate')) {
        //邮件
    	if (!emailNotShow) {
    		submenu.push({name:  $.i18n('collaboration.transmit.mail.label'),click: transmitMail });
    	}
    };
    var toolbarArray = new Array();
    //发送
    //toolbarArray.push({id: "send",name: $.i18n('collaboration.newcoll.send'),className: "ico16 send_16",click:send});
    //编辑
    toolbarArray.push({id: "edit",name:$.i18n('collaboration.edit.label'),className: "ico16 editor_16",click:edit});
    //转发
    //toolbarArray.push({id: "transmit",name: $.i18n('collaboration.transmit.label'),className: "ico16 forwarding_16",subMenu: submenu});
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
            if(choose === 'subject'){
                o.subject = $('#title').val();
            }else if(choose === 'importantLevel'){
                o.importantLevel = $('#importent').val();
            }else if(choose === 'createDate'){
                var fromDate = $('#from_datetime').val();
                var toDate = $('#to_datetime').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能大于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.createDate = date;
            }else if(choose === 'subState'){
                o.subState = $('#subStateName').val();
            }
            var val = searchobj.g.getReturnValue();
            if(window.location.href.indexOf("condition=templeteAll&textfield=all") != -1){
        		o.templeteAll="all";
        	}
            if(val !== null){
                $("#listWaitSend").ajaxgridLoad(o);
                var _summarySrc =  $('#summary').attr("src");
                if(_summarySrc.indexOf("listDesc") != -1){
                	setTimeout(function(){
                		$('#summary').attr("src","collaboration.do?method=listDesc&type=listWaitSend&size="+grid.p.total+"&r=" + Math.random());	
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
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: $.i18n("common.date.create.label"),//创建时间
            value: 'createDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }, {
          id: "subStateName",
          name: 'subStateName',
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
    //表格加载
        grid = $('#listWaitSend').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '4%',
            type: 'checkbox'
        }, {
            display: $.i18n("common.subject.label"),//标题
            name: 'subject',
            sortable : true,
            width: '66%'
        }, {
          display: $.i18n("common.coll.state.label"),//状态
          name: 'subState',
          sortable : true,
          width: '8%'
        }, {
            display: $.i18n("common.date.create.label"),//创建时间
            name: 'createDate',
            sortable : true,
            width: '10%'
        }, {
            display: $.i18n("collaboration.process.cycle.label"),//流程期限
            name: 'processDeadLineName',
            sortable : true,
            width: '9%'
        }],
        click: dbclickRow,//clickRow
        dblclick: dbclickRow,
        render:rend,
        height: 200,
        showTableToggleBtn: true,
        isHaveIframe:true,
        rpMaxSize : 999,
        managerName : "colManager",
        managerMethod : "getWaitSendList",
        parentId: $('.layout_center').eq(0).attr('id'),
        slideToggleBtn:true,
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        }
    });
    
    
    //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listWaitSend&size="+grid.p.total+"&r=" + Math.random());
    
  
});           