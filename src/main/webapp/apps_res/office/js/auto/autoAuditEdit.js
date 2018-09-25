// js开始处理
$(function() {
    pTemp.TBar = officeTBar().addAll(["print"]).init("toolbar");
    pTemp.auditDiv = $("#auditDiv");
    pTemp.autoUseTab = $("#autoUseTab");
    pTemp.ajaxM = new autoUseManager();
    
    fnPageInIt();
    fnSetCss();
});
/**
 * 页面初始化
 */
function fnPageInIt() {
	if (pTemp.jval != '') {
		var pData = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pData.workFlow;
		pTemp.row = pData;
		// 加载打开页面数据
		fnPageReload(pData);
	}
	//待审批，不显示派车意见
	if(pTemp.row && parseInt(pTemp.row.state)==1){
		 $("#dispatchOpinionTR").hide();
	}
	pTemp.autoUseTab.disable();
	pTemp.autoUseTab.find("#auditContent").enable();
	pTemp.autoUseTab.find("tr[nodePostion=autoOut]").hide();
}

/**
 * 刷新页面
 * @param areaId，刷新野蛮部分的id
 */
function fnPageReload(p) {
  pTemp.auditDiv.fillform(p);
  $("#applyDiv").fillform(p);
	//选人组件回填
  $("#userDiv").comp({value : p.applyUser,text : p.applyUserName});
  $("#depDiv").comp({value : p.applyDept,text : p.applyDeptName});
  $("#passengerDiv").comp({value : p.passenger,text : p.passengerName});
  //自驾处理
  if (pTemp.row.selfDriving != null && pTemp.row.selfDriving) {
	  $("#applyDriverName").val("");
  }
}

/**
 * 工作流预提交
 */
function fnOK(){
	//竞争执行时，是否已被执行
	if (!isAffairValidPub($("#affairId").val(),"autoAudit")) {
		return;
	}
	var audit = pTemp.auditDiv.formobj();
	
	//检查affair是否是代办状态
	var param = {affairId:$("#affairId").val(),isAudit:"true"};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
				//处理radio
				var auditAttitude = audit.agree?audit.agree:audit.notagree;
				if(parseInt(auditAttitude)==0){
				  //工作流预提交
				  var user = $.ctx.CurrentUser;
				  var UseMember = $("#applyUser").val();//用车人
				  var UseDept = $("#applyDept").val();//用车部门
				  var UseType = $("#applyDepartType option:selected").attr("enumId");//用车性质
				  var UseReason = $("#applyOrigin").val().escapeJavascript();//用车事由
				  var UseAutoNum = $("#applyAutoIdName").val().escapeJavascript();//车辆
				  pTemp.officeData = "{\"UseMember\":\"" + UseMember + "\",\"UseDept\":\"" + UseDept + "\",\"UseType\":\"" + UseType + "\",\"UseReason\":\"" + UseReason + "\",\"UseAutoNum\":\"" + UseAutoNum + "\"}";
				  preSendOrHandleWorkflow(window,pTemp.workFlow.workItemId,"-1",pTemp.workFlow.processId,pTemp.workFlow.activityId,user.id,pTemp.workFlow.caseId,user.loginAccount,pTemp.officeData,"office",null,window,"-1",fnAutoAudit);
				}else{
					var confirm = $.confirm({
				    'msg': $.i18n('office.auto.applyflow.rollback.js'),
				    ok_fn: function () {
				    	fnAutoAudit();
				    }
					});
				}
		}else{
			fnMsgBoxPub($.i18n('office.auto.apply.processbyother.js'), "alert", function() {
				fnReloadPagePub({page : "autoAudit"});
				fnAutoCloseWindow();
			});
		}
	}});
}

/**
 * 审核
 */
function fnAutoAudit() {
	var isAgree = pTemp.auditDiv.validate();
	if (!isAgree){
		return;
	}
	
	openProcePub();
	var audit = pTemp.auditDiv.formobj();
	//处理radio
	var auditAttitude = audit.agree?audit.agree:audit.notagree;
	var auditPO ={applyId:audit.id,"auditAttitude":auditAttitude,auditOpinion:audit.auditOpinion};
	auditPO.workFlow = $("#workFlowDiv").formobj();
	auditPO.workFlow.workItemId = pTemp.workFlow.workItemId;
	auditPO.workFlow.officeData = pTemp.officeData;
	auditPO.affairMemberId = pTemp.workFlow.affairMemberId;
	
	pTemp.ajaxM.autoAudit(auditPO, {
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
				fnReloadPagePub({page : "autoAudit"});
				fnAutoCloseWindow();
			} else if (rval == 2) {
				fnMsgBoxPub($.i18n('office.auto.apply.revoked.js'), "alert", function() {
					fnReloadPagePub({page : "autoAudit"});
					fnAutoCloseWindow();
				});
			}else{//rval == 1
				fnMsgBoxPub($.i18n('office.auto.audit.fail.js'), "error", function() {
					fnReloadPagePub({page : "autoAudit"});
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
 * 打印
 */
function fnPrint(){
  var applyOuttimeObj=this.document.getElementById("applyOuttime");
  var applyBacktimeObj=this.document.getElementById("applyBacktime");
  var outtimeValue = $(applyOuttimeObj).val();
  var backtimeDate = $(applyBacktimeObj).val();
  $(applyOuttimeObj).attr('value',outtimeValue);
  $(applyBacktimeObj).attr('value',backtimeDate);
  var obj = this;
  //var table = obj.document.getElementById("autoUseTab");
  //var items = table.document.getElementsByTagName("input");
  var items = obj.$("#autoUseTab input");
  for(var i = 0;i<items.length;i++){
	    var targetObj =items[i];
	    var targetValue = $(targetObj).val();
	    $(targetObj).attr('value',targetValue);
  }
  $('applyDepartType').hide();
  var applyDepartType = obj.$("select option:selected").html();//用车范围
  obj.$("td:has(#applyDepartType)").attr("id","tempSelect").html("<DIV id='applyDepartTypeDiv' class='common_txtbox_wrap'><input disabled='disabled' class='validate font_size12 w100b' id='applyDepartType' type='text' maxLength='80' value='"+applyDepartType+"' validate='type:'string',name:'出发地'' _da='true'></div>");
  obj.$('.stadic_layout_body').find('.calendar_icon_area ').hide();
  var formDivHtml = "<div style='width:700px;height: 600px;font-size:12px' align='center'>"+ obj.$('#autoApplyDiv').html()+"</div>";
  var printFrame = new PrintFragment("", "<style type='text/css'>.common_txtbox_wrap span{width:98%;height:20px;}</style><div style='height: 600px;margin-left: 75px;' align='center'>"+ formDivHtml+"</div>");
  var mainList = new ArrayList();
  mainList.add(printFrame);
  var cssList = new ArrayList();
  printList(mainList, cssList);
  obj.$('#tempSelect').html("<select disabled='disabled' class='w100b font_size12' id='applyDepartType' _da='true'><option value='0' selected = 'selected'>"+applyDepartType+"</option></select>");
  obj.$('.stadic_layout_body').find('.calendar_icon_area ').show();
  //原方法
  //var bodyContent ="<iframe id='autoApplyEdit' border='0' src='/seeyon/office/autoUse.do?method=autoApplyEdit&applyId="+pTemp.row.id+"' frameBorder='0' height='600' width='100%'></iframe>";
  //var printFrame = new PrintFragment("", bodyContent);
  //var mainList = new ArrayList();
  //mainList.add(printFrame);
  //var cssList = new ArrayList();
  //printList(mainList, cssList);
}

/**
 * 页面样式控制
 */
function fnSetCss() {
		var showOpt ={eastWidth:300,sprit:true,maxWidth:500,spiretBarShow:true,border:true};
		var hideOpt ={eastWidth:-2,sprit:false,maxWidth:0,spiretBarShow:false,border:false};
		var opt = showOpt;
		if(pTemp.row.auditDone){
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
                },
                handlerR : function() {
                    layout.setEast(30);
                    $("#deal_area").hide();
                    $("#deal_area_show").show();
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
    //去掉必填
    $("#applyDriverSpan").remove();
  	$("#applyAutoSpan").remove();
}
