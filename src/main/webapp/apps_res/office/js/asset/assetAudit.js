// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["del"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArg4UsePub").addAll(["applyUser","createDate","workFlowState"]).init();
    //table
    pTemp.tab = officeTab().addAll(["id","assetNum","assetTypeName","assetName","useTime","applyDesc","startMemberIdName","createDate","workFlowState"]).init("assetAudit", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "assetUseManager",
        "managerMethod" : "findAuditList"
    });
    
    pTemp.ajaxM = new assetUseManager();
    //窗口高度，宽度
    pTemp.winWidth = 990;
    pTemp.winHeight = 650;
    fnPageReload();
});

/**
 * 刷新页面
 */
function fnPageReload() {
	pTemp.tab.load(pTemp.cnd);
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
				if (!isAffairValidPub(row.affairId,"assetAudit")) {
					return;
				}
				var url = "/office/assetUse.do?method=assetAuditEdit&operate=audit&affairId="+ row.affairId+"&v="+row.v0
				, title = $.i18n('office.asset.assetHandle.bgsbsqd.js');
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
	cnd.page = 'assetAudit';
	pTemp.cnd = cnd;
	pTemp.tab.load(cnd);
}

/**
 * tBar删除
 */
function fnDel(){
	var rows = pTemp.tab.selectRows();
	if(rows.length == 0){
	 $.alert($.i18n('office.asset.assetAudit.qxzyscdsbsq.js'));
	 return;
	}
	 
	for(var i = 0; i < rows.length; i++) {
		if(!rows[i].isAudit){//待审批的申请
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
    	pTemp.ajaxM.deleteAudit(auditMap,{
    		success:function(rval){
    			fnReloadPagePub({page:"assetAudit"});
    			var msg = $.i18n('office.book.myLend.sccg.js'),type = 'ok';
        	fnMsgBoxPub(msg,type,function(){
    				fnAutoCloseWindow();
    			});
    		},
    		error : function(rval) {
    			fnReloadPagePub({page:"assetAudit"});
        	var msg = $.i18n('office.asset.assetAudit.dbqscsb.js'),type = 'error';
        	fnMsgBoxPub(msg,type,function(){
    				fnAutoCloseWindow();
    			});
    		}
    	});
    }});
}
