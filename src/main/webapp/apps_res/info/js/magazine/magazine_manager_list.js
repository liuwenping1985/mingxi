 $(document).ready(function () {
        loadStyle();
        loadToolbar();
        loadCondition();
        loadData();
        loadDefaultBodyType();
});

function loadToolbar() {
	var toolbarArray = new Array();
	if(hasMagazineNewRole == 'true') {
		toolbarArray.push({id:"createObj", name:$.i18n('infosend.magazine.manager.new'), className:"ico16", click:createRow});//新建
	    toolbarArray.push({id:"updateObj", name:$.i18n('infosend.magazine.manager.modification'), className:"ico16 editor_16", click:modifyRow});//修改
	}
    toolbarArray.push({id:"deleteObj", name:$.i18n('infosend.magazine.manager.delete'), className:"ico16 del_16 ", click:deleteRow});//删除
    toolbarArray.push({id:"cancelObj", name:$.i18n('infosend.magazine.manager.revocation'), className:"ico16 revoked_process_16", click:cancelRow});//撤销
    toolbarArray.push({id:"transferObj",name:$.i18n('infosend.magazine.manager.transfer'), className:"ico16 forwarding_16", click:transferRow});//转信息
    $("#toolbars").toolbar({
        toolbar: toolbarArray,
        isPager:false
    });
}

function transferRow(){
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){

        $.alert($.i18n('infosend.magazine.manager.selectTransfer'));//请选择一条记录进行转信息
        return;
    }
    if(rows.length>1){
        $.alert($.i18n('infosend.magazine.manager.selectTransferInfo'));//只能选择一条记录进行转信息

        return;
    }
    if(hasOffice("41")) {
    	window.location.href = _ctxPath+"/info/infocreate.do?method=createInfo&action=forward&magazineId="+rows[0].id;
    }
}

function createRow() {
	window.location.href = _ctxPath+"/info/magazine.do?method=newMganzine&action=create&bodyType="+bodyType;
}

function modifyRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){

        $.alert($.i18n('infosend.magazine.manager.selectJournal'));//请选择一条记录   请选择一条期刊！

        return;
    }
    if(rows.length>1){
        $.alert($.i18n('infosend.magazine.manager.selectModified'));//只能选择一条记录进行修改  !

        return;
    }
    if(rows[0].state == "9" || rows[0].state == "3" || rows[0].state == "1" || rows[0].state == "4" || rows[0].state == "7"){

    	$.alert($.i18n('infosend.magazine.manager.notModify'));  // 不允许修改已发期刊！

    	return ;
    }
	window.location.href = _ctxPath+"/info/magazine.do?method=newMganzine&action=modify&id="+rows[0].id;
}

function deleteRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){

    	$.alert($.i18n('infosend.magazine.manager.chooseJournal')); // 请选择要删除的期刊！

        return;
    }
    var magazineIds = "";
    for(var count = 0 ; count < rows.length; count ++) {
    	if(rows[count]!=null && (rows[count].state!='0' && rows[count].state!='2')) {

    		$.alert($.i18n('infosend.magazine.manager.stateJournal'));  // 只能删除待发状态的期刊！

    		return;
    	}
        if(count == rows.length -1){
        	magazineIds += rows[count].id;
        }else{
        	magazineIds += rows[count].id +",";
        }
    }

    if(confirm($.i18n('infosend.magazine.manager.operationNotBeRestored'))) {   // 确定删除期刊吗？该操作不能恢复

    	var manager = new magazineListManager();
        var flag = manager.deleteMagazineManager(magazineIds);
        if(flag == "success") {
        	window.location.reload();
        }
    }
}

var cancelDialog;
function cancelRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){

    	$.alert($.i18n('infosend.magazine.manager.revocationJournal'));  // 请选择需要撤销的期刊！

        return;
    }
    var magazineIds = "";
    for(var count = 0 ; count < rows.length; count ++) {
    	if(rows[count]!=null && (rows[count].state=='0' || rows[count].state=='2' || rows[count].state=='6' || rows[count].state=='5')) {
    		$.alert($.i18n('infosend.magazine.manager.issuedJournals'));  // 只能撤销已发状态的期刊！
    		return;
    	}

    	if(rows[count]!=null && (rows[count].state=='3')) {
    		$.alert($.i18n('infosend.magazine.manager.journalPublished')); // 期刊已被发布，不允许撤销！
    		return;
    	}

    	if(rows[count]!=null && rows[count].auditState !='0' && rows[count].flowState=='3') {//期刊需要审核，状态为待发布
    		$.alert($.i18n('infosend.magazine.manager.auditedEnd'));  // 期刊已被审核结束，不允许撤销！
    		return;
    	}

        if(count == rows.length -1){
        	magazineIds += rows[count].id;
        }else{
        	magazineIds += rows[count].id +",";
        }
    }
    if(rows.length>1){
        $.alert($.i18n('infosend.magazine.manager.selectARecordCancel'));//只能选择一条记录进行撤销
        return;
    }

    cancelDialog = $.dialog({
        url:  _ctxPath + "/info/magazinelist.do?method=openMagazineCancelDialog",
        width: 450,
        height: 240,

        title: $.i18n('infosend.magazine.manager.revocationJournals'), //撤销期刊

        id:'cancelDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
            	cancelDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            btnType : 1,//按钮样式
            handler: function () {
                var comment = cancelDialog.getReturnValue();
                if (!comment) {
                	$.alert($.i18n('infosend.magazine.alert.notNullPostscript'));//撤销附言不能为空！
					return;
				}

                //长度验证
                if(comment.length > 100){
                	$.alert($.i18n('infosend.magazine.alert.maxLenPostscript') + comment.length);//撤销附言不能超过100字，当前字数为
					return;
                }

                cancelDialog.close();
            	var manager = new magazineListManager();
                var flag = manager.updateMagazineManagerToCancel(magazineIds, comment);
                if(flag == "success") {
                	window.location.reload();
                } else if(flag == "failure") {

                	$.alert($.i18n('infosend.magazine.manager.auditedEnd'));  // 期刊已被审核结束，不允许撤销！

                	return;
                }
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	cancelDialog.close();
            }
        }]
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
             }else if(choose === 'state'){
                 o.state = $('#state').val();
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = listType;
                 o.condition = choose;
                 searchConditionObj = o;
                 $("#magazineManagerList").ajaxgridLoad(o);
             }
         },
         conditions: [{
             id: 'subject',
             name: 'subject',
             type: 'input',
             text: $.i18n("infosend.magazine.list.condition.subject"),//标题
             value: 'subject',
             maxLength:100
         },{
             id: 'state',
             name: 'state',
             type: 'select',
             text: $.i18n('infosend.magazine.list.condition.state'),//期刊状态
             value: 'state',
             items: [{
                 text: $.i18n('infosend.magazine.list.state.0'),
                 value: '0,2'
             }, {
                 text: $.i18n('infosend.magazine.list.state.1'),
                 value: '1,3,4,7,9'
             }, {
                 text: $.i18n('infosend.magazine.list.state.5'),
                 value: '5'
             }, {
                 text: $.i18n('infosend.magazine.list.state.6'),
                 value: '6'
             }]
         }]
     });
}

//加载页面数据
var grid;
function loadData() {
	//表格加载
	grid = $('#magazineManagerList').ajaxgrid({
		colModel: [{
			display: 'id',
			name: 'id',
			state:'state',
			flowState:'flowState',
			auditState:'auditState',
			createUserId: 'createUserId',
			width: '5%',
			type: 'checkbox',
			isToggleHideShow:false
		}, {
			display: $.i18n('infosend.magazine.manager.journalName'),//期刊名称

			name: 'subject',
			sortable : true,
			width: '30%'
		}, {

			display: $.i18n('infosend.magazine.manager.issue'),//期号
			name: 'magazineNo',
			sortable : true,
			hide:true,
			width: '12%'
		}, {

			display: $.i18n('infosend.magazine.manager.journalStatus'),//期刊状态

			name: 'stateName',
			sortable : true,
			width: '12%'
		}, {

			display: $.i18n('infosend.magazine.manager.creater'),//创建人
			name: 'creater',
			hide:true,
			sortable : true,
			width: '12%'
		}, {

			display: $.i18n('infosend.magazine.manager.createTime'),//创建时间

			name: 'createTime',
			ifFormat:'%Y-%m-%d',
			sortable : true,
			width: '15%'
		}, {

			display: $.i18n('infosend.magazine.manager.auditStateName'),//是否审核
			name: 'auditStateName',
			sortable : true,
			width: '12%'
		}, {
			display: $.i18n('infosend.magazine.label.auditor'),//审核人
			name: 'auditMemberNames',
			sortable : true,
			width: '11%'
		},{

			display: $.i18n('infosend.magazine.manager.auditTime'),//审核时间

			name: 'auditTime',
			ifFormat:'%Y-%m-%d',
			sortable : true,
			width: '15%'
		}],
		click: dbclickRow,
        dblclick: modifyRow,
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
        managerName : "magazineListManager",
        managerMethod : "getMagazineManagerList"
    });
 }

 var TimeFn = null;
 function clickRow(data, rowIndex, colIndex){
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 TimeFn = setTimeout(function(){
		 $('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Pending&affairId="+data.affairId);}
	 ,400);
 }

 function dbclickRow(data, rowIndex, colIndex) {
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 var affairState = 4;
	 if(data.state == 3) {//已发布
		 affairState = 4;
	 } else {
		 affairState = 3;
	 }
	 if(data.isOld){
		 openMagazineList(data.id, data.subject, affairState, getCtpTop());//老信息报送数据查看详情
	 }else{
		 var _url = _ctxPath+"/info/magazine.do?method=summary&openFrom=manager&magazineId="+data.id;
		 //$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
		 var title = data.subject;
		 doubleClick(_url,escapeStringToHTML(title));
		 grid.grid.resizeGridUpDown('down');
	 }
 }

 function rend(txt, data, r, c) {
	 if(c === 1){
		 txt="<span class='grid_black'>"+txt+"</span>";
	 }
     return txt;
 }

function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listPending')];
	 showSummayDialogByURL(url,title,parmas);
}
