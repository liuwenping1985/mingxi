// js开始处理
$(function() {
    //searchBar
    pTemp.SBar = officeSBar("fnSBArg4UsePub").addAll(["applyUser","applyDept","applyDate","state"]).init();
    //table
    pTemp.tab = officeTab().addAll(["id","applyUser","applyDept","applyDate","applyDesc","state"]).init("stockGrant", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "stockUseManager",
        "managerMethod" : "findStockUseList"
    });
    $('#stockGrant').width("");
    pTemp.ajaxM = new stockUseManager();
    fnPageReload();
});

/**
 * 刷新页面
 */
function fnPageReload() {
	var param = $.extend(true,{page:'stockGrant'},pTemp.cnd);
	pTemp.tab.load(param);
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	var param = {applyId:row.id,states:[0,25]};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			fnPageReload();
			$.alert($.i18n('office.asset.assetAudit.dbqgsqybcxhsc.js'));
		}else{
			var url = "/office/stockUse.do?method=stockApplyIframe&operate=grant&applyId="+ row.id+"&v="+row.v
			,title = $.i18n('office.stock.apply.bill.js');
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:1000,height:650});
		}
	}});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	cnd.page = 'stockGrant';
	pTemp.cnd = cnd;
	pTemp.tab.load(cnd);
}
