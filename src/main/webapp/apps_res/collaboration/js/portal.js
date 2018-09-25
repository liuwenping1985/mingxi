//显示流程图
 function showFlowChart(_contextCaseId,_contextProcessId,_templateId,_contextActivityId,_applicationKey,_showHastenButton){
      var showHastenButton=_showHastenButton;
      var supervisorsId="";
      var isTemplate=false;
      var operationId="";
      var senderName="";
      var openType=getA8Top();
      if(_templateId&&"undefined"!=_templateId){
          isTemplate=true;
      }
      var appName = "edoc";
      if(_applicationKey =='1'){
		appName = 'collaboration';
      }
      showWFCDiagram(openType,_contextCaseId,_contextProcessId,isTemplate,showHastenButton,supervisorsId,window,appName, false ,_contextActivityId,operationId,'' ,senderName);
}