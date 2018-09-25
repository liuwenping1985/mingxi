// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["del"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArg4UsePub").addAll(["applyUser","applyDept","applyDate","workFlowState"]).init();
    //table
    pTemp.tab = officeTab().addAll(["id","applyUser","applyDept","applyDate","applyDesc","workFlowState"]).init("stockAudit", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "stockUseManager",
        "managerMethod" : "findStockAuditList"
    });
    $('#stockAudit').width("");
    pTemp.ajaxM = new stockUseManager();
    //窗口高度，宽度
    pTemp.winWidth = 990;
    pTemp.winHeight = 650;
    fnPageReload();
});

/**
 * 刷新页面
 */
function fnPageReload() {
	var param = $.extend(true,{type:'stockAudit'},pTemp.cnd);
	pTemp.tab.load(param);
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	var param = {applyId:row.id,states:[0]};
	pTemp.ajaxM.isApplyHasState(param,{
		success:function(rval){
			if(!rval){
				if (!isAffairValidPub(row.affairId,"stockAudit")) {
					return;
				}
				var url = "/office/stockUse.do?method=stockAuditEdit&affairId="+ row.affairId+"&v="+row.v0
				, title = $.i18n('office.stock.apply.bill.js');
				fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
			}else{
				fnPageReload();
				$.alert($.i18n('office.asset.assetAudit.dbqgsqybcxhsc.js'));
			}
		}
	});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	cnd.page = 'stockAudit';
	pTemp.cnd = cnd;
	pTemp.tab.load(cnd);
}

/**
 * tBar删除
 */
function fnDel(){
	var rows = pTemp.tab.selectRows();
	if(rows.length == 0){
	 $.alert($.i18n('office.book.myLend.qxzyscdsqjl.js'));
	 return;
	}
	 
	for(var i = 0; i < rows.length; i++) {
		if(parseInt(rows[i].state)== 1){//待审批的申请
			$.alert($.i18n('office.auto.only.del.audited.js'));
			return;
		}
	}
	
	var affairIds = [];
	for ( var i = 0; i < rows.length; i++) {
		affairIds[i] = rows[i].affairId;
	}
	
	var confirm = $.confirm({
    'msg': $.i18n('office.book.myLend.qdyscyjxzdjl.js'),
    ok_fn: function () {
    	var auditMap ={affairIds:affairIds}; 
    	pTemp.ajaxM.stockAuditDel(auditMap,{
    		success:function(rval){
    			fnReloadPagePub({page:"stockAudit"});
    			var msg = $.i18n('office.auto.delsuccess.js'),type = 'ok';
        	fnMsgBoxPub(msg,type,function(){
    				fnAutoCloseWindow();
    			});
    		},
    		error : function(rval) {
    			fnReloadPagePub({page:"stockAudit"});
        	var msg = $.i18n('office.asset.assetAudit.dbqscsb.js'),type = 'error';
        	fnMsgBoxPub(msg,type,function(){
    				fnAutoCloseWindow();
    			});
    		}
    	});
    }});
}
