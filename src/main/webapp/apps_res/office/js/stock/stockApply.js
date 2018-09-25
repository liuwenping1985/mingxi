// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["apply","edit","revoke","del"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArg4UsePub").addAll(["applyDate","applyState"]).init();
    //table
    pTemp.tab = officeTab().addAll([ "id","applyUser","applyDept","applyDate","applyDesc","state"]).init("stockApply", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "stockUseManager",
        "managerMethod" : "findStockUseList"
    });
    $('#stockApply').width("");
    pTemp.ajaxM = new stockUseManager();
    fnPageReload2();
    //窗口高度，宽度
    pTemp.winWidth = 990;
    pTemp.winHeight = 653;
});

/**
 * 刷新页面
 */
function fnPageReload2() {
	var param = {page:'stockApply'};
	if(pTemp.tab.cnd){
		pTemp.tab.load(pTemp.tab.cnd);
	}else{
		pTemp.tab.load(param);
	}
}

function fnPageReload() {
	//加载用品库的名称
    fnPageReload2();
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	var param = {applyId:row.id,states:[0,35]};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			fnPageReload2();
			$.alert($.i18n('office.stock.deled.js'));
		}else{
			var url = "/office/stockUse.do?method=stockApplyIframe&applyId="+ row.id+"&v="+row.v
			,title = $.i18n('office.stock.apply.bill.js');
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
		}
	}});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	cnd.page = 'stockApply';
	pTemp.tab.cnd = cnd;
	pTemp.tab.load(cnd);
}

/**
 *申请 
 */
function fnApply(){
	var url = "/office/stockUse.do?method=stockApplyIframe&applyId=0&operate=add",title = $.i18n('office.stock.new.bill.js');
	if(pTemp.isCarsAdmin!=''){
		url += "&v=" + $.parseJSON(pTemp.isCarsAdmin).v;
	}
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
}

/**
 * 编辑
 */
function fnEdit(){
	 var rows = pTemp.tab.selectRows();
	 if(rows.length == 0){
	   $.alert($.i18n('office.asset.assetApply.qxzyxgdjl.js'));
	   return;
	 }else if(rows.length > 1){
	   $.alert($.i18n('office.asset.assetApply.znxzyxjljxxg.js'));
	   return;
	 }
	 
	 var row = rows[0],state = parseInt(row.state);
	 
	if (state == 1 || state == 5 || state == 6|| state == 10) {
		$.alert($.i18n('office.stock.modify.cond.msg.js'));
		return;
	}
	
	var url = "/office/stockUse.do?method=stockApplyIframe&&operate=modify&applyId="+row.id+"&v="+row.v,title = $.i18n('office.stock.apply.bill.js')+"（"+row.applyUserName+" "+row.applyDate+"）";
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
}

/**
 * 删除
 */
function fnDel(){
	var rows = pTemp.tab.selectRows();
  if(rows.length == 0){
      $.alert($.i18n('office.select.del.recored.js'));
      return;
  }
	// 检查状态
	for ( var i = 0; i < rows.length; i++) {
		var state = parseInt(rows[i].state);
		if (state == 1 || state == 5 || state == 6) {
			$.alert($.i18n('office.stock.del.state.error.js'));
			return;
		}
	}
	
  $.confirm({'msg':$.i18n('office.book.myLend.qdyscyjxzdjl.js'),ok_fn:fnDeleteByIds});
  var rowIds = pTemp.tab.selectRowIds();
	function fnDeleteByIds() {
		pTemp.ajaxM.deleteApplyByIds({applyIds:rowIds},{
			success : function(rval) {
				var msg = $.i18n('office.auto.delsuccess.js'),type = 'ok';
				//1.被别人删除
				//2.不能删除
				if(rval=='stateError'){
					type = "alert";
					msg = $.i18n('office.stock.del.state.error.js');
				}else if(rval=='handled'){
					type = "alert";
					msg = $.i18n('office.stock.deled.js');
				}
				
				if(type == 'error'){
					fnMsgBoxPub(msg, type,function(){
						fnReloadPagePub({page:"stockApply"});
					});
				}else{
					fnMsgBoxPub(msg, type,function(){
						fnReloadPagePub({page:"stockApply"});
					});
				}
			}
		});
	}
}

/**
 * 撤销
 */
function fnRevoke(){
	var rows = pTemp.tab.selectRows();
  if(rows.length == 0){
      $.alert($.i18n('office.auto.select.revoke.js'));
      return;
  }else if(rows.length > 1){
      $.alert($.i18n('office.asset.assetApply.znxzyxjljxcx.js'));
      return;
  }
  
  var row = rows[0];
  var param = {applyId:row.id,states:[1,5]};
  pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			fnWorkFlowRevoke(row);
		}else{
			$.alert($.i18n('office.stock.only.audit.revok.state.js'));
		}
	}});
}

/**
 * 工作流撤销流程
 */
function fnWorkFlowRevoke(row){
	//撤销流程
	var dialog = $.dialog({
	    url: _ctxPath + "/office/officeTemplate.do?method=showOfficeWorkflowRepeal",
	    width:450,height:240,title:$.i18n('common.repeal.workflow.label'),//撤销流程
	    targetWindow:getCtpTop(),
	    closeParam:{
	      show:true,
	      handler:function(){
	          releaseWorkflowByAction(row.processId, $.ctx.CurrentUser.id, 12);
	      }
	    },
	    buttons : [ {
	        text : $.i18n('collaboration.button.ok.label'),//确定
	        isEmphasize:true,
	        handler : function() {
	          var rval = dialog.getReturnValue();
	          if (!rval){
	              return ;
	          }
	          //撤销流程
	          var param = {applyId:row.id,repealComment:rval};
	          pTemp.ajaxM.revokeApplyByIds(param, {
	            success : function(rval2) {
	            	var msg =$.i18n('office.revoke.success.js'),type = 'ok';
	              if(rval2.state == "fail"){
	              	type = 'error';
	              	msg = rval2.msg;
	              }
	              
	              fnMsgBoxPub(msg, type,function(){
	              	fnPageReload2();
	              	dialog.close();
	    					});
	              
	            }
	        });
	        }
	      }, {
	        text : $.i18n('collaboration.button.cancel.label'),//取消
	        handler : function() {
	            releaseWorkflowByAction(row.processId, $.ctx.CurrentUser.id, 12);
	            dialog.close();
	        }
	      } ]
	  });
}