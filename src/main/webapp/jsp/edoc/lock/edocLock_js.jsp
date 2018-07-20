
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script>
var EdocLock = {};
EdocLock.STEP_BACK = 9;//回退加锁action
EdocLock.STEP_STOP = 11;//终止加锁action
EdocLock.REPEAL_ITEM = 12;//撤销加锁action
EdocLock.REPEAL_ITEM_SENDED = 12;//已发撤销加锁action
EdocLock.TAKE_BACK = 13;//取回加锁action
EdocLock.UPDATE_CONTENT = 15;//修改正文加锁action
EdocLock.UPDATE_ATT = 16;//修改附件加锁action
EdocLock.SUBMIT = 14;//提交时加锁action (暂存待办)
EdocLock.QIAN_ZHANG = 18;//签章时加锁action

EdocLock.lockWorkflow=function(processId,currentUser,action){
  var requestCaller = new XMLHttpRequestCaller(this, "WFAjax", "lockWorkflow",false);
  requestCaller.addParameter(1, "String", processId);  
  requestCaller.addParameter(2, "String", currentUser);  
  requestCaller.addParameter(3, "int", action);  
  var rs = requestCaller.serviceRequest();
  return rs;
}


EdocLock.checkWorkflowLock = function(processId, currentUser,action){
  var requestCaller = new XMLHttpRequestCaller(this, "WFAjax", "checkWorkflowLock",false);
  requestCaller.addParameter(1, "String", processId);  
  requestCaller.addParameter(2, "String", currentUser);  
  requestCaller.addParameter(3, "int", action);  
  var rs = requestCaller.serviceRequest();
  return rs;
}

EdocLock.releaseWorkflowByAction = function(processId, currentUser,action){
  var requestCaller = new XMLHttpRequestCaller(this, "WFAjax", "releaseWorkflow",false);
  requestCaller.addParameter(1, "String", processId);  
  requestCaller.addParameter(2, "String", currentUser);  
  requestCaller.addParameter(3, "int", action);  
  var rs = requestCaller.serviceRequest();
  return rs;
}

EdocLock.releaseWorkflow = function(processId, currentUser){
  var requestCaller = new XMLHttpRequestCaller(this, "WFAjax", "releaseWorkflow",false);
  requestCaller.addParameter(1, "String", processId);  
  requestCaller.addParameter(2, "String", currentUser); 
  var rs = requestCaller.serviceRequest();
  return rs;
}

</script>

