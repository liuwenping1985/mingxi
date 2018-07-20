//<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
var commonTrue = "${ctp:i18n('common.true')}";
var commonFalse = "${ctp:i18n('common.false')}";
var isHistoryFlag = "${isHistoryFlag}";
var currentProId = "${processId}", subProcessJsonArray = ${subListJson};
$("a.common_button").click(viewRelateColl);
var wfAjax= new WFAjax(); 
function viewRelateColl(){
	var index = parseInt($(this).attr("index"));
	var processId = subProcessJsonArray[index].mainProcessId,
    caseId = subProcessJsonArray[index].mainCaseId
    workitemId = "", nodeId = subProcessJsonArray[index].mainNodeId
    ,width = $(getCtpTop().document).width() - 100
    ,height = $(getCtpTop().document).height() - 50
    ,title = "";
    if(currentProId == subProcessJsonArray[index].mainProcessId){
        processId = subProcessJsonArray[index].subProcessProcessId;
        caseId = subProcessJsonArray[index].subProcessCaseId;
        workitemId = "";
        nodeId = "start";
    }
    var obj = wfAjax.getProcessTitleByAppNameAndProcessId("${appName}", processId);
    if(obj!=null && obj.length>0){
        title = obj[0];
    }
    var url=_ctxPath + "/collaboration/collaboration.do?method=summary&processId="+processId+"&openFrom=subFlow&relativeProcessId="+currentProId+"&formMutilOprationIds=${param.formMutilOprationIds}&isHistoryFlag=" + isHistoryFlag;
    $.dialog({
        url:url
        ,width:width
        ,height:height
        ,title:title
        ,targetWindow:getCtpTop()
    });
}