/**
 *taskId:任务ID
 *callBack:点击汇报窗口确定按钮后的执行回调函数
 */
function addTaskFeedback(taskId,callBack) {
  var src = _ctxPath+"/taskmanage/taskfeedback.do?method=newTaskFeedbackPage&isEidt=1&operaType=new&taskId="+taskId+"&isDialog=1";
  var feedbackDialog = $.dialog({
    id: 'newFeedbackDialog',
        url: src,
        width: 580,
        height: 118,
        top:100,
        title: $.i18n('taskmanage.feedback.new'),
        targetWindow:getCtpTop(),
        transParams:{callBack: callBack }, 
        buttons: [
           {
              id : "sure",
              text : $.i18n('common.button.ok.label'),
              isEmphasize: true, 
              handler : function() {
                    feedbackDialog.getReturnValue();
                  }
              },
            {
                id : "cancel",
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                  feedbackDialog.close();
                }
            } 
        ]
  });
}