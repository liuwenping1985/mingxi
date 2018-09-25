// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["out","recede"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArgFuncPub").addAll(["applyUser","applyDept","applyAutoIdName","realOuttime","realBacktime","outRedeceState"]).init();
    
    pTemp.tab = officeTab().addAll([ "id", "applyUser","applyDept","applyAutoId","useTime","realOuttime","realBacktime","applyDes","applyDriver","state" ]).init("autoRecedeOut", {
      argFunc : "fnTabItems",
      parentId : $('.layout_center').eq(0).attr('id'),
      slideToggleBtn : false,// 上下伸缩按钮是否显示
      resizable : false,// 明细页面的分隔条
      render:fnUseTimeRenderPub,
      "managerName" : "autoUseManager",
      "managerMethod" : "findAutoUseList"
    });
    
    pTemp.ajaxM = new autoUseManager();
    fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	fnPageReload();
}

/**
 * 刷新页面
 */
function fnPageReload() {
	var param = {type:'autoRecedeOut'};
	 pTemp.tab.load(param); 
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	//检查有效性,删除和撤销都不能查看
	var param = {applyId:row.id,states:[10,15,20]};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			var url = "/office/autoUse.do?method=autoApplyIframe&applyId="+ row.id+"&state="+row.state+"&v="+row.v,
			title = $.i18n('office.app.auto.use.apply.bill.js');
			if(row.processId == null){//直接派车单
				title = $.i18n('office.auto.use.dosend.bill.js');
			}
			if(parseInt(row.state) == 10){//待出车
				url += "&isEdit=true";
			}else if(parseInt(row.state)==15){//带还车
				url += "&isRecedeEdit=true";
			}
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:840,height:540});
		}else{
			fnPageReload();
			$.alert($.i18n('office.auto.apply.processbyother.js'));
		}
	}});
}

/**
 * 还车
 */
function fnRecede(){
	var rows = pTemp.tab.selectRows();
	
	if(rows.length == 0){
    $.alert($.i18n('office.select.one.record.js'));
    return;
	}else if(rows.length > 1){
    $.alert($.i18n('office.select.onlyone.js'));
    return;
	}
	var row = rows[0];
	//提示：已办理出车
	if(row.state == 20){//20=已还车
		$.alert($.i18n('office.auto.use.receded.js'));
		return;
	}
	
	if(row.state == 10){//待出车
		$.alert($.i18n('office.auto.use.waitout.js'));
		return;
	}
	
	var url = "/office/autoUse.do?method=autoRecedeEdit&isRecedeEdit=true",title = $.i18n('office.tbar.recede.js');
	var row = pTemp.tab.selectRows()[0];
	url += "&applyId=" + row.id + "&v=" + row.v;
	
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:800,height:520});
}

/**
 * 出车
 */
function fnOut(){
	var rows = pTemp.tab.selectRows();
	//提示：已办理出车
	if(rows.length == 0){
    $.alert($.i18n('office.select.one.record.js'));
    return;
	}else if(rows.length > 1){
    $.alert($.i18n('office.select.onlyone.js'));
    return;
	}
	var row = rows[0];
	//提示：已办理出车
	if(row.state == 15||row.state > 10){//待出车
		$.alert($.i18n('office.auto.use.outed.js'));
		return;
	}
	
	var url = "/office/autoUse.do?method=autoFastOutEdit&isEdit=true",title = $.i18n('office.tbar.out.js');
	var row = pTemp.tab.selectRows()[0];
	url += "&applyId=" + row.id + "&v=" + row.v;
	
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:500,height:320});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	cnd.type = 'autoRecedeOut';
	pTemp.tab.load(cnd);
}