// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["apply","edit","revoke","del"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArg4UsePub").addAll(["applyUser","assetType","createDate","applyState"]).init();
    //table
    pTemp.tab = officeTab().addAll([ "id","assetNum","assetTypeName","assetName","useTime","applyDesc","createDate","state"]).init("assetApply", {
        argFunc : "fnTabItem4UsePub",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "assetUseManager",
        "managerMethod" : "findApplyList"
    });
    
    pTemp.ajaxM = new assetUseManager();
    fnPageReload();
    //窗口高度，宽度
    pTemp.winWidth = 750;
    pTemp.winHeight = 550;
});

/**
 * 刷新页面
 */
function fnPageReload() {
	var param = {page:'assetApply'};
	if(pTemp.tab.cnd){
		pTemp.tab.load(pTemp.tab.cnd);
	}else{
		pTemp.tab.load(param);
	}
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	var param = {applyId:row.id,states:[0]};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			fnPageReload();
			$.alert($.i18n('office.asset.assetApply.dbqgsbsqybsc.js'));
		}else{
			var url = "/office/assetUse.do?method=assetApplyIframe&applyId="+ row.id+"&v="+row.v
			,title = $.i18n('office.asset.assetHandle.bgsbsqd.js');
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
		}
	}});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	cnd.page = 'assetApply';
	pTemp.tab.cnd = cnd;
	pTemp.tab.load(cnd);
}

/**
 *申请 
 */
function fnApply(){
	var url = "/office/assetUse.do?method=assetApplyIframe&applyId=0&operate=add",title = $.i18n('office.asset.assetApply.xjsbsqd.js');
	if(pTemp.jval!=''){
		url += "&v=" + $.parseJSON(pTemp.jval).v;
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
	 
	if (state != 25 && state != 30 && state != 35) {
		$.alert($.i18n('office.asset.assetApply.znxgspbtgjcbtghycxdjl.js'));
		return;
	}
	
	var url = "/office/assetUse.do?method=assetApplyIframe&&operate=modify&applyId="+row.id+"&v="+row.v,title = "办公设备申请单（"+row.applyUserName+" "+row.createDate+"）";
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:pTemp.winWidth,height:pTemp.winHeight});
}

/**
 * 删除
 */
function fnDel(){
	var rows = pTemp.tab.selectRows();
  if(rows.length == 0){
      $.alert($.i18n('office.asset.assetApply.qxzyscdjl.js'));
      return;
  }
  
  var count =0;
	// 检查状态
	for ( var i = 0; i < rows.length; i++) {
		var state = parseInt(rows[i].state);
		if (state == 1 || state == 5|| state == 10 || state == 15) {
			count ++;
		}
	}
	
	if (count == rows.length) {
		//$.alert("只能删除已归还、审批不通过、借出不通过、已撤销的记录！");
		//return;
	}
	
  $.confirm({'msg':$.i18n('office.asset.assetApply.qdyscyjxzdjl.js'),ok_fn:fnDeleteByIds});
  var rowIds = pTemp.tab.selectRowIds();
	function fnDeleteByIds() {
		pTemp.ajaxM.deleteApplyByIds({applyIds:rowIds},{
			success : function(rval) {
				var msg = $.i18n('office.book.myLend.sccg.js'),type = 'ok';
				if(rval.state =='stateError'){
					type = "alert";
					msg = $.i18n('office.asset.assetApply.znscyghspbtgjcbtgycxdjl.js')+rval.msg;
				}else if(rval.state =='handled'){
					type = "error";
					msg = $.i18n('office.asset.assetApply.dbqscczsbdqsqybsc.js');
				}
				
				if(type == 'error'){
					fnMsgBoxPub(msg, type,function(){
						fnReloadPagePub({page:"assetApply"});
					});
				}else{
					fnMsgBoxPub(msg, type,function(){
						fnReloadPagePub({page:"assetApply"});
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
      $.alert($.i18n('office.asset.assetApply.qxzycxdjl.js'));
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
			$.alert($.i18n('office.asset.assetApply.zncxdsphdjcdjl.js'));
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
	            	var msg =$.i18n('office.asset.assetApply.cxcg.js'),type = 'ok';
	              if(rval2.state == "fail"){
	              	type = 'error';
	              	msg = rval2.msg;
	              }
	              
	              fnMsgBoxPub(msg, type,function(){
	              	fnPageReload();
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