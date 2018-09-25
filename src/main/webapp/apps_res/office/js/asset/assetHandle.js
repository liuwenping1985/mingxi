// js开始处理
$(function() {
	 //toolbar
  	pTemp.TBar = officeTBar().addAll(["dLend","imp"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArg4UsePub").addAll(["applyUser","assetType","createDate","state"]).init();
    //table
    pTemp.hideCheckbox = true;
    pTemp.tab = officeTab().addAll(["id","assetNum","assetTypeName","assetName","useTime","applyDesc","startMemberIdName","createDate","state"]).init("assetHandleTab", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "assetUseManager",
        "managerMethod" : "findHandleList"
    });
    //窗口高度，宽度
    pTemp.winWidth = 750;
    pTemp.winHeight = 600;
    pTemp.ajaxM = new assetUseManager();
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
	var param = {applyId:row.id,states:[0,25]};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			fnPageReload();
			$.alert($.i18n('office.asset.assetHandle.bgsbsqybsc.js'));
		}else{
			var operate = "view",state = parseInt(row.state);
			if(state == 10 || state == 15){
				operate = "remind";
			}else if(state == 5){
				operate = "lend";
			}
			var url = "/office/assetUse.do?method=assetApplyIframe&operate="+operate+"&applyId="+ row.id+"&v="+row.v
			,title = $.i18n('office.asset.assetHandle.bgsbsqd.js');
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:750,height:550});
		}
	}});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	pTemp.cnd = cnd;
	pTemp.tab.load(cnd);
}

/**
 * 直接借出 
 */
function fnDLend(){
	var url = "/office/assetUse.do?method=assetApplyIframe&applyId=0&operate=dLend",title = $.i18n('office.asset.assetApply.dLend.js');
	if(pTemp.jval!=''){
		url += "&v=" + $.parseJSON(pTemp.jval).v;
	}
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
}

/**
 * 导入
 */
function fnImp(){
	$.dialog({
			id: 'importAssetApply',
	    url: _path +"/office/assetUse.do?method=importAssetApply",
	    width: 440,height: 210,
	    title: $.i18n('office.assetinfo.fileupload.js'),
	    targetWindow : getCtpTop(),
	    closeParam:{'show':true,handler:function(){
	    	pTemp.tab.load();
	    }}
	});
}

/**
 * 模版下载 
 */
function fnDownLoadTemplate(){
	$("#empty").attr("src", _path + "/office/assetUse.do?method=exportAssetTemplete");
}
