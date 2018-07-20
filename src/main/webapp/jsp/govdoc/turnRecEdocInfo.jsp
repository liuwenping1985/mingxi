<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="/seeyon/ajax.do?managerName=govdocExchangeManager,colManager"></script>
<script type="text/javascript">
	var chuantouchakan2 = '${chuantouchakan2}';
	function rend(txt, data, r, c) {
		if(c == 1){
			if(chuantouchakan2 == 'true'&&data.status!=0){
				return "<a href='#' onclick='showSummary(\""+data.summaryId+"\")'>"+txt+"</a>";
			}else{
				return txt;
			}
		}
		if(c == 4){
			var str = "";
			if(data.status == 1){
				str += "<a href='javascript:void(0)' onclick='revoke(\"" + data.summaryId + "\",\"" + data.id + "\")'>[撤销]</a>&nbsp;&nbsp;";
			}
			if(data.status == 0||data.status == 10||data.status == 11){
				str += "<a href='javascript:void(0)' onclick='reSend(\""+ data.recOrgId+"\",\"" + data.id + "\",\"" + data.canSend + "\")'>[重发]</a>&nbsp;&nbsp;";
			}
			if(typeof(data.canThrough)!='undefined'&&data.canThrough == '1'){
				//穿透功能以后实现
				//str+= "<a href='javascript:void(0)' >[查看流程]</a>";
			}
			return str;
		}
		if(c == 5){
			return "<a href='javascript:void(0)' onclick='showLog(\""+data.detailId+"\")'>日志</a>";
		}
	    return txt;
	}
	
	function showLog(id) {
        var dialog = $.dialog({
            url: "/seeyon/collaboration/collaboration.do?method=showLog&detailId=" + id,
            width: 800,
            height: 400,
            title: '流程日志',
            targetWindow: getCtpTop(),
            buttons: [{
                text: $.i18n('collaboration.button.close.label'),
                handler: function () {
                    dialog.close();
                }
            }]
        });
    }
	
	function showSummary(summaryId){
	    window.parent.showDetail(summaryId);
	}
	
	$(function(){
		$('#turnRecEdocInfo').ajaxgrid({
	        colModel: [{
	            display: '日期',
	            name: 'sendTime',
	            sortable : true,
	            width: '25%'
	        },{
	            display: '送往单位',
	            name: 'recOrgName',
	            sortable : true,
	            width: '20%'
	        },{
	            display: '办理意见',
	            name: 'opinion',
	            sortable : true,
	            width: '25%'
	        },{
	            display: '状态',
	            name: 'statusName',
	            sortable : true,
	            width: '10%'
	        },{
	            display: '操作',
	            name: 'opinion',
	            sortable : true,
	            width: '10%'
	        },{
	            display: '日志',
	            name: 'detailId',
	            sortable : true,
	            width: '10%'
	        }],
	        render : rend,
	        height: 255,
	        showTableToggleBtn: true,
	        vChange: true,
	        vChangeParam: {
	            overflow: "hidden",
	            autoResize:true
	        },
	        isHaveIframe:false,
	        slideToggleBtn:false,
	        managerName : "govdocExchangeManager",
	        managerMethod : "findDetailList"
	    });
	});
	function loadData(){
		var o = new Object();
	    o.summaryId = parent.summaryId;
	    $('#turnRecEdocInfo').ajaxgridLoad(o);
	}
	//cx 重发
	function reSend(recOrgId,id,canSend){
		if(canSend=='1'){
			$.ajax({
		        type:"post",
		        url : "/seeyon/collaboration/collaboration.do?method=reSend",
		    	data : {detailId : id},
		    	success:function(data){
		    		if(data=="1"){
		    			var proce = $.progressBar();
		    			setTimeout(function(){
		    				proce.close();
		    				var exchange = new govdocExchangeManager();
                        	var changeId = exchange.changeOrgId(recOrgId);
                        	var returnVal = exchange.validateExistAccount(changeId);
                        	if(returnVal && returnVal !=""){
                        		$.alert("该单位未设置收文交换流程，流程处于待交换状态，请在状态中查看！");
                        	}else{
                        		$.alert("重发成功");
                        	}
		    				var o = new Object();
		    			    o.mainIds = $("#mainIds").val();
		    			    $('#turnRecEdocInfo').ajaxgridLoad();
		    			},1500);
		    			
		    		}
		    	}
		    });
		}else{
			$.alert("发送失败，文号已被占用");
		}
		
	}
function revoke(summaryId,exchangeDetailId){
		
		//js事件接口
		var sendDevelop = $.ctp.trigger('beforeSentCancel');
		if(!sendDevelop){
			 return;
		}
		var affairId;
		var startAffairId;
		var processId;
		$.ajax({
			url : "/seeyon/collaboration/collaboration.do?method=forRevokeGetParams",
			data : {summaryId : summaryId},
			success : function(data){
				if(data == "error"){
					alert("此数据不允许撤销");
					return;
				}
				var arr = eval("(" + data + ")");
				affairId = arr.affairId;
				startAffairId = arr.startAffairId;
				processId = arr.processId;
				//校验开始
			    var _colManager = new colManager();
			    var params = new Object();
			    params["summaryId"] = summaryId;
			    //校验是否流程结束、是否审核、是否核定，涉及到的子流程调用工作流接口校验
			    var canDealCancel = _colManager.checkIsCanRepeal(params);
			    if(canDealCancel.msg != null){
			        $.alert(canDealCancel.msg);
			        return;
			    }

			    if(!isAffairValid(affairId)) {
			    	return;
			    }
			    //调用工作流接口校验是否能够撤销流程 
			    var repeal = canRepeal('collaboration',processId,'start');
			    //不能撤销流程
			    if(repeal[0] === 'false'){
			        $.alert(repeal[1]);
			        return;
			    }
			    var lockWorkflowRe = lockWorkflow(processId, $.ctx.CurrentUser.id, 12);
			    if(lockWorkflowRe[0] == "false"){
			        $.alert(lockWorkflowRe[1]);
			        return;
			    }
			    
			    if(!executeWorkflowBeforeEvent("BeforeCancel",summaryId,affairId,processId,processId,"","","")){
			    	return;
				}
			    
			    //撤销流程
			    var dialog = $.dialog({
			        url: _ctxPath + "/workflowmanage/workflowmanage.do?method=showRepealCommentDialog&affairId="+affairId,
			        width:450,
			        height:240,
			        bottomHTML:'<label for="trackWorkflow" class="margin_t_5 hand">'+
			        			'<input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">'+$.i18n("collaboration.workflow.trace.traceworkflow")+
			        			'</label><span class="color_blue hand" style="color:#318ed9;" title="'+$.i18n("collaboration.workflow.trace.summaryDetail2")+
			        			'">['+$.i18n("collaboration.workflow.trace.title")+']</span>',
			        title:$.i18n('common.repeal.workflow.label'),//撤销流程
			        targetWindow:getCtpTop(),
			        buttons : [ {
			            text : $.i18n('collaboration.button.ok.label'),//确定
			            btnType:1,
			            handler : function() {
			              var returnValue = dialog.getReturnValue();
			              if (!returnValue){
			                  return ;
			              }
			              //alert(returnValue[1]);
			              //return;
			              var ajaxSubmitFunc =function(){
			                  var ajaxColManager = new colManager();
			                  var tempMap = new Object();
			                  tempMap["repealComment"] = returnValue[0];
			                  tempMap["summaryId"] = summaryId; 
			                  tempMap["affairId"] = startAffairId;
			                  tempMap["trackWorkflowType"] =  returnValue[1];
			                  ajaxColManager.transRepal(tempMap, {
			                      success: function(msg){
			                          if(msg==null||msg==""){
			                        	  $.ajax({
			  								url : "/seeyon/collaboration/collaboration.do?method=revoke",
			  								data : {summaryId : summaryId},
			  								success : function(data){
			  									$("#turnRecEdocInfo").ajaxgridLoad();
			  								}
			  							});
			  			              dialog.close();
			                          }else{
			                            $.alert(msg);
			                          }
			                          //撤销后关闭，子页面
			                          try{closeOpenMultyWindow(affairId);}catch(e){};
			                      }
			                  });
			              }
			              //V50_SP2_NC业务集成插件_001_表单开发高级
			              beforeSubmit(affairId,"repeal", returnValue[0],dialog,ajaxSubmitFunc,null);
			            }
			          }, {
			            text : $.i18n('collaboration.button.cancel.label'),//取消
			            handler : function() {
			                releaseWorkflowByAction(processId, $.ctx.CurrentUser.id, 12);
			                dialog.close();
			            }
			          } ]
			      });
			}
		});
	    
	}
	//ajax判断事项是否可用。
   function isAffairValid(affairId){
     var cm = new colManager();
     var msg = cm.checkAffairValid(affairId);
     if($.trim(msg) !=''){
          $.alert(msg);
          return false;
     }
     return true;
   }
</script>
</head>
<body onload="loadData()">
<input id="mainIds" type="hidden" value="${mainIds }"/>
        <table  class="flexme3 " id="turnRecEdocInfo"></table>
</body>
</html>