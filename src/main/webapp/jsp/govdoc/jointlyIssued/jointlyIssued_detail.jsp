<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" src="/seeyon/ajax.do?managerName=govdocExchangeManager,colManager"></script>
</head>
<body>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
    <thead>
        <tr>
            <th width="30%">单位名称</th>
            <th width="20%">联合日期</th>
            <th>分类</th>
            <c:if test="${canOpe == true }">
            <th width="10%">操作</th>
            <th width="10%">状态</th>
            <th width="20%">日志</th>
             </c:if>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="vo" items="${lists }" varStatus="status">
        <tr <c:if test="${status.index % 2==0 }"> class="erow" </c:if>>
            <td>
	            <c:if test="${canOpe == true && vo.sendUserFlag==true}">
	            	<a href='javascript:void(0);' onclick="opens('/seeyon/collaboration/collaboration.do?method=summary&openFrom=listSent&type=&summaryId=${vo.summaryId}&isRecSendRel=1&isJointly=true');">${vo.summary_unit }</a>
	            </c:if>
	            <c:if test="${canOpe != true || vo.sendUserFlag!=true}">
	            	<a href='javascript:void(0);' onclick="opens('/seeyon/collaboration/collaboration.do?method=summary&openFrom=formQuery&type=&summaryId=${vo.summaryId}&isRecSendRel=1&isJointly=true');">${vo.summary_unit }</a>
	            </c:if>
            </td>
            <td>${vo.lDate }</td>
            <td>${vo.type_str }</td>
            <c:if test="${canOpe == true }">
            <td>${vo.oper_str}</td>
            <td>
            <c:choose>
				<c:when test="${vo.state == 0}">
					待交换
				</c:when>
				<c:when test="${vo.state == 1}">
					待签收
				</c:when>
				<c:when test="${vo.state == 2}">
					已签收
				</c:when>
				<c:when test="${vo.state == 3}">
					已分办
				</c:when>
				<c:when test="${vo.state == 4}">
					进行中
				</c:when>
				<c:when test="${vo.state == 10}">
					已回退
				</c:when>
				<c:when test="${vo.state == 11}">
					已撤销
				</c:when>
				<c:when test="${vo.state == 12}">
					已终止
				</c:when>
				<c:when test="${vo.state == 13}">
					已结束
				</c:when>
			</c:choose>
            </td>
            <td>
	            <a href="javascript:void(0);" onclick="showOpinion('${vo.exchangeDetailId}');">日志</a>
            </td>
            </c:if>
        </tr>
        </c:forEach>
    </tbody>
</table>
</body>
<script type="text/javascript">
	function showOpinion(detailId){
		var dialog = $.dialog({
            url: "/seeyon/collaboration/collaboration.do?method=showLog&from=lianhe&detailId=" + detailId,
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
    $("#btn").click(function(){
        var dialog = $.dialog({
         targetWindow:getCtpTop(),
         url:"/seeyon/test.jsp",
         width: 570,
          title:'联合单位',
          buttons: [ {
              text:"关闭", //取消
              handler: function () {
                  dialog.close();
              }
          }]
      });
    })
    
    function opens(url){
    	openCtpWindow({"url":url});
    }
    
  //cx 重发
	function reSend(id){
		$.ajax({
	        type:"post",
	        url : "/seeyon/collaboration/collaboration.do?method=reSend",
	    	data : {detailId : id},
	    	success:function(data){
	    		if(data=="1"){
	    			alert("重发成功");
	    			window.location.href = window.location.href;
	    		}else if(data=="0"){
	    			alert("此单位未设置或已经停用联合发文模板，重发失败");
	    			window.location.href = window.location.href;
			    }
	    	}
	    });
		
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
					/* $.ajax({
							url : "/seeyon/collaboration/collaboration.do?method=revoke",
							data : {summaryId : summaryId},
							success : function(data){
								$("#exchangeDetail").ajaxgridLoad();
							}
						}); */
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
			        enabledToolbar();
			        return;
			    }

			    if(!isAffairValid(affairId)) {
			        enabledToolbar();
			    	return;
			    }
			    //调用工作流接口校验是否能够撤销流程 
			    var repeal = canRepeal('collaboration',processId,'start');
			    //不能撤销流程
			    if(repeal[0] === 'false'){
			        $.alert(repeal[1]);
			        enabledToolbar();
			        return;
			    }
			    var lockWorkflowRe = lockWorkflow(processId, $.ctx.CurrentUser.id, 12);
			    if(lockWorkflowRe[0] == "false"){
			        $.alert(lockWorkflowRe[1]);
			        try{
				        enabledToolbar();
			        }catch(e){}
			        return;
			    }
			    
			    if(!executeWorkflowBeforeEvent("BeforeCancel",summaryId,affairId,processId,processId,"","","")){
			        try{
				        enabledToolbar();
			        }catch(e){}
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
					closeParam:{	
			 			show:true,
			 			autoClose:true,
			 			handler:function(){		
			 			   releaseWorkflowByAction(processId, $.ctx.CurrentUser.id, 12);
						}
			        },
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
			  									window.location.href = window.location.href;
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
</html>