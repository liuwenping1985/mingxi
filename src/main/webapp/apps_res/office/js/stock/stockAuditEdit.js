// js开始处理
$(function() {
	pTemp.ajaxM = new stockUseManager();
	pTemp.auditDiv = $("#auditDiv");
	if (pTemp.jval != '') {
		pTemp.row = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pTemp.row.workFlow;
	}
	fnSetCss();
});

function fnOK() {
	var isAgree = pTemp.auditDiv.validate();
	if (!isAgree){
		return;
	}
	
	if (!isAffairValidPub($("#affairId").val(),"stockAudit")) {
		return;
	}
	
	//检查affair是否是代办状态
	var param = {affairId:$("#affairId").val(),isAudit:"true"};
	
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			var audit = pTemp.auditDiv.formobj();
			//处理radio
			var auditAttitude = audit.agree ? audit.agree : audit.notagree;
			if (parseInt(auditAttitude) == 0) {
				openProcePub();
				//工作流预提交
				var user = $.ctx.CurrentUser;
				var applyUser = pTemp.row.applyUser;// 申请人
				var applyDept = pTemp.row.applyDept;// 申请部门
				var applyDesc = pTemp.row.applyDesc;// 申请说明
				var applyTotal = pTemp.row.applyTotal;// 总价
			  var wfOBJ = {UseMember:applyUser,UseDept:applyDept,UseReason:applyDesc,ApplyTotal:applyTotal};
				pTemp.workFlowJSON = $.toJSON(wfOBJ);
			  preSendOrHandleWorkflow(window,pTemp.workFlow.workItemId,"-1",pTemp.workFlow.processId,pTemp.workFlow.activityId,user.id,pTemp.workFlow.caseId,user.loginAccount,pTemp.workFlowJSON,"office",null,window,null,fnWorkFlowCallSubmit);
			}else{
				var confirm = $.confirm({
			    'msg': $.i18n('office.stock.not.agree.workflow.reback.js'),
			    ok_fn: function () {
			    	fnWorkFlowCallSubmit();
			    }
				});
			}
		}else{
			fnMsgBoxPub($.i18n('office.stock.con.apply.num.handled.js'), "alert", function() {
				fnReloadPagePub({page : "stockAudit"});
				fnAutoCloseWindow();
			});
		}
	}});
}

/**
 * 工作流预提交后回调提交
 */
function fnWorkFlowCallSubmit(){
	var audit = pTemp.auditDiv.formobj();
	//处理radio
	var auditAttitude = audit.agree ? audit.agree : audit.notagree;
	var auditPO ={applyId:pTemp.row.id,"auditAttitude":auditAttitude,auditOpinion:audit.auditOpinion};
	auditPO.workFlow = $("#workFlowDiv").formobj();
	auditPO.workFlow.workItemId = pTemp.workFlow.workItemId;
	auditPO.workFlow.workFlowJSON = pTemp.workFlowJSON;
	auditPO.affairMemberId = pTemp.workFlow.affairMemberId;
	
	pTemp.ajaxM.stockAudit(auditPO, {
		success : function(rval) {
			//刷新工作桌面
			try{
			   if (window.top.opener.getCtpTop && window.top.opener.getCtpTop().refreshDeskTopPendingList) {
		          window.top.opener.getCtpTop().refreshDeskTopPendingList();
		       }
			}catch(e){
			}
			if (rval == 0) {
				endProcePub();
				fnReloadPagePub({page : "stockAudit"});
				fnAutoCloseWindow();
			} else if (rval == 2) {
				fnMsgBoxPub($.i18n('office.stock.apply.bill.revock.js'), "alert", function() {
					fnReloadPagePub({page : "stockAudit"});
					fnAutoCloseWindow();
				});
			}else{//rval == 1
				fnMsgBoxPub($.i18n('office.stock.apply.workflow.over.js'), "alert", function() {
					fnReloadPagePub({page : "stockAudit"});
					fnAutoCloseWindow();
				});
			}
		},
    error : function(rval) {
      endProcePub();
    }
	});
}


/**
 * 页面样式控制
 */
function fnSetCss() {
	var showOpt ={eastWidth:260,sprit:true,maxWidth:500,spiretBarShow:true,border:true};
	var hideOpt ={eastWidth:-2,sprit:false,maxWidth:0,spiretBarShow:false,border:false};
	var opt = showOpt;
	if(pTemp.row.workFlow.auditState || pTemp.row.state != 1){
		opt = hideOpt;
		//禁用提交按钮
		$("#agreeHref").removeAttr("onclick");
		pTemp.auditDiv.disable();
	}
	
  var layout = new MxtLayout({
      'id' : 'layout',
      'eastArea' : {
          'id' : 'east',
          'width' : opt.eastWidth+2,
          'sprit' : opt.sprit,
          'minWidth' : opt.eastWidth+2,
          'maxWidth' : opt.maxWidth,
          'border' : opt.border,
          spiretBar : {
              show : opt.spiretBarShow,
              handlerL : function() {
                  layout.setEast(opt.eastWidth);
                  $("#deal_area").show();
                  $("#deal_area_show").hide();
                  $("#stockApplyIframe")[0].contentWindow.$("#tabs").tab().resetSize();
              },
              handlerR : function() {
                  layout.setEast(30);
                  $("#deal_area").hide();
                  $("#deal_area_show").show();
                  $("#stockApplyIframe")[0].contentWindow.$("#tabs").tab().resetSize();
              }
          }
      },
      'centerArea' : {
          'id' : 'center',
          'border' : opt.border,
          'minHeight' : 20
      }
  });

  $("#deal_area_show").click(function() {
      $("#layout #eastSp_layout .spiretBarHidden2").trigger("click");
  });
  
  $("#deal_area #hidden_side").click(function() {
      if ($("#east").outerWidth() == (eastWidth+2)) {
          layout.setEast(window.document.body.clientWidth / 2);
      } else {
          layout.setEast(eastWidth);
      }
  });
}