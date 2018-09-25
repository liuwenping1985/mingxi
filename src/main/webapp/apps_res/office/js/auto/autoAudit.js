// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["del"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArgFuncPub").addAll(["applyUser","applyDept","createDate","workFlowState"]).init();
    
    pTemp.tab = officeTab().addAll([ "id", "applyUser","applyDept","passengerNum","applyOrigin","useTime","applyDes","createDate","workFlowState" ]).init("autoAudit", {
        argFunc : "fnTabItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "autoUseManager",
        "managerMethod" : "findAutoAudit"
    });
    
    pTemp.ajaxM = new autoUseManager();
    fnPageInIt();
    
    //$.confirmClose();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	fnPageReload();
}

function fnPageReload(){
	pTemp.tab.load();
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	var param = {applyId:row.id,states:[0,35]};
	//检查有效性,删除和撤销都不能查看
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			fnPageReload();
			$.alert($.i18n('office.auto.apply.deleted.js'));
		}else{
			var affairId = row.workFlow.affairId;
			if (!isAffairValidPub(affairId,"autoAudit")) {
				return;
			}
			var url = "/office/autoUse.do?method=autoAuditEdit&affairId="+ affairId+"&v="+row.v0
			,title = $.i18n('office.app.auto.use.apply.js');
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:1000,height:750,top:20});
		}
	}});
}

/**
 * tBar删除
 */
function fnDel(){
	var rows = pTemp.tab.selectRows();
	if(rows.length == 0){
	 $.alert($.i18n('office.select.del.recored.js'));
	 return;
	}
	 
	for(var i = 0; i < rows.length; i++) {
		if(!rows[i].auditDone){//待审批的申请
			$.alert($.i18n('office.auto.only.del.audited.js'));
			return;
		}
	}
	
	var confirm = $.confirm({
    'msg': $.i18n('office.auto.really.delete.js'),
    ok_fn: function () {
    	var auditMap ={applyIds:pTemp.tab.selectRowIds()}; 
    	pTemp.ajaxM.autoAuditDel(auditMap,{
    		success:function(rval){
    			fnReloadPagePub({page:"autoAudit"});
    			var msg = $.i18n('office.auto.delsuccess.js'),type = 'ok';
        	fnMsgBoxPub(msg,type,function(){
    				fnAutoCloseWindow();
    			});
    		},
    		error : function(rval) {
    			fnReloadPagePub({page:"autoAudit"});
        	var msg = $.i18n('office.auto.delfail.js'),type = 'error';
        	fnMsgBoxPub(msg,type,function(){
    				fnAutoCloseWindow();
    			});
    		}
    	});
    }});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	pTemp.tab.load(cnd);
}

function fnLogList(){
}