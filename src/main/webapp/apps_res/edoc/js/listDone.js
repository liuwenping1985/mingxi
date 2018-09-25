$(document).ready(function () {
		$("#deduplication").val(isGourpBy);
		$("#isGourpBy").click(function(){
		    var isDedupCheck =  $("#isGourpBy:checked").size();
		    if (isDedupCheck != 0) {
		      	$("#deduplication").val("true");
		    } else {
		    	$("#deduplication").val("false");
			}
		    doSearch();
		});
	});
//显示流程图
function showFlowChart(_contextCaseId,_contextProcessId,_templateId,_contextActivityId){
    var showHastenButton='false';
    var supervisorsId="";
    var isTemplate=false;
    var operationId="";
    var senderName="";
    var openType=getA8Top();
    if(_templateId&&"undefined"!=_templateId){
        isTemplate=true;
    }
    V5_Edoc().showWFCDiagram(openType,_contextCaseId,_contextProcessId,isTemplate,showHastenButton,supervisorsId,window, 'edoc', false ,_contextActivityId,operationId,'' ,senderName);
}