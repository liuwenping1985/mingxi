<!-- 使用该文件必须得引用 common.jsp -->
<script>
var whereFrom = {
		//待发  已发 
	    'peopleCard' : 'peopleCard'
	}
/**
 * 其他各运用转协同接口
 * 支持两种方式,一种是其他后台Controller请求CollaborationService返回页面
 * 一种是引入该jsp调用apptoColl该JS方法
 * @param from  各运用从哪里来 eg:人员卡片 from="peopleCard"
 * 后续其他各运用需要js接口转协同的一起增加枚举量和参数
 * copy 由F1负责维护与修改 
 */
 function appToColl(wfrom,peopleCardId){
	  if (!wfrom || !whereFrom[wfrom]) {
	        alert('request is illegal:' + wfrom);
	        return;
	    }
	    var url = _ctxPath+"/collaboration/collaboration.do?method=appToColl"+"&wfrom="+wfrom;
	    if(peopleCardId && "" != peopleCardId){
	    url += "&peopleCard="+peopleCardId;
	  }
	    if($(getA8Top().document).find("#main").length==0){
	    	$(getA8Top().getParentWindow().getA8Top().document).find("#main").attr("src",url);
	    	window.close();
	    }else{
	    	$(getA8Top().document).find("#main").attr("src",url);
	    }
	    
	}
/**
 * 通过url打开协同正文
 * dialog方式打开
 */
function showSummayDialogByURL(url,title,isPortal,transParams){
	var width = $(getA8Top().document).width() - 60;
	var height = $(getA8Top().document).height() - 50;
    url+="&isDialog=true";
    var transParamsObj = [$('#summary'),$('.slideDownBtn'),$('#listPending')];
    if(transParams){
      transParamsObj = transParams;
    }
	dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'dialogDealColl',
        transParams:transParamsObj,
        targetWindow:getCtpTop(),
        closeParam: {
          'show':true, 
          autoClose:false, 
          handler:function(){
	        var isWorkflowChange = getCtpTop().$('#dialogDealColl_main_iframe_content')[0].contentWindow.isWorkflowChange;
            if(!isWorkflowChange){
                  if(isPortal){
                        if(url.indexOf("inquirybasic.do?method=showInquiryFrame") != -1){
                          parent.sectionHandler.reload("pendingSection", true);
                        }
                  }
                dialogDealColl.close();
            }else{
              var confirm = $.confirm({
                'msg': "${ctp:i18n('collaboration.common.isWorkflowChange')}",
                ok_fn: function () {
                    if(isPortal){
                      if(url.indexOf("inquirybasic.do?method=showInquiryFrame") != -1){
                        parent.sectionHandler.reload("pendingSection", true);
                      }
                    }
                    dialogDealColl.close();
                    dialogDealColl = null;
                },
                cancel_fn:function(){
                    return;
                }
              });
            }
          }
        }
    });
}
/**
 * 	获取打开正文内容的url
 *
 *	affairId,summaryId,processId 三个参数如果有affairId优先传affairId，如果 取不到affairId传 summaryId或者processId
 * 	openFrom  		从哪里打开的,用来控制协同处理界面右侧处理区域是否显示  从如下字符串中取值：
 *					formStatistical 表单查询统计
 *					docLib	文档中心
 *					supervise 督办
 *					listDone 已办列表
 *					listPending 待办列表
 *                  F8Reprot F8穿透统计
 *					subFlow 子流程查看主流程，或者主流程查看子流程
 *	operationId		表单使用的字段，没有可以传 null
 *  docAcl          文档中心权限串
 */
function getCollDetailUrl(affairId,summaryId,processId,openFrom,operationId,docAcl){
	var url = _ctxPath + "/collaboration/collaboration.do?method=summary";
	if(affairId!=null&&typeof(affairId)!='undefined'){
		url+="&affairId="+affairId;
	}
	if(summaryId!=null&&typeof(summaryId)!='undefined'){
		url+="&summaryId="+summaryId;
	}
	if(processId!=null&&typeof(processId)!='undefined'){
		url+="&processId="+processId;
	}
	if(openFrom!=null&&typeof(openFrom)!='undefined'){
		url+="&openFrom="+openFrom;
	}
	if(operationId!=null&&typeof(operationId)!='undefined'){
		url+="&operationId="+operationId;
	}
	if(docAcl!=null&&typeof(docAcl)!='undefined'){
        url+="&lenPotent="+docAcl;
    }
	return url;
}
/**
 * 	打开正文内容（dialog方式打开）
 *
 *	affairId,summaryId,processId 三个参数如果有affairId优先传affairId，如果 取不到affairId传 summaryId或者processId
 * 	openFrom  		从哪里打开的,用来控制协同处理界面右侧处理区域是否显示  从如下字符串中取值：
 *					formStatistical 表单查询统计
 *					docLib	文档中心
 *					supervise 督办
 *					listDone 已办列表
 *					noNeedForAudit 需要审计
 *					listPending 待办列表
 *	operationId		表单使用的字段，没有可以传 null
 *  docAcl          文档中心权限串
 *  title		    dialog的标题，用affair的subject值
 */
function showSummayDialog(affairId,summaryId,processId,openFrom,operationId,docAcl,title){
	//TODO 如果title为空 aJax查询
	var url = getCollDetailUrl(affairId,summaryId,processId,openFrom,operationId);
	var width = $(getA8Top().document).width() - 60;
	var height = $(getA8Top().document).height() - 50;
	dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'dialogDealColl',
        transParams:[$('#summary'),$('.slideDownBtn'),$('#listPending')],
        targetWindow:getCtpTop()
    });
}
</script>