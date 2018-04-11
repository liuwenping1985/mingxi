<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
  try{
    <c:if test="${editFlag=='true'}">
    var parWin = window.dialogArguments;
    $("#name").val( $("#name", parWin.document).val());
    $("#taskName").val($("#taskName", parWin.document).val());
    $("#operationType").val($("#operationType", parWin.document).val());
    $("#model").val($("#model", parWin.document).val());
    $("#taskType").val($("#taskType", parWin.document).val());
    
    $("#taskId").val($("#taskId", parWin.document).val());
    $("#taskResult").val($("#taskResult", parWin.document).val());
    $("#refFieldTable").val($("#refFieldTable", parWin.document).val());
    $("#taskParam").val($("#taskParam", parWin.document).val());
    $("#taskField").val($("#taskField", parWin.document).val());
    
    if ($("#taskResult", parWin.document).val() == 'dee' || $("#taskType", parWin.document).val() == 'dee') {
        $("#taskNameDEE").val($("#taskName", parWin.document).val());
    }
    </c:if>
    }catch(e){
      alert(e.message);
    }
    if($("#taskType").val()=='dee'){
      $("#divtext").show();
      $("#divtextselect").hide();
    }else{
      $("#divtext").hide();
      $("#divtextselect").show();
    }
   
    //$("#taskField").val($("#taskField", parWin.document).val();
    //alert($("#taskField").val());
    $("#taskType").change(function(){
      if($("#taskType").val()=='dee'){
        $("#divtext").show();
        $("#divtextselect").hide();
      }else{
        $("#divtext").hide();
        $("#divtextselect").show();
      }
     });
    
    $("#taskNameDEE").click(function(){
      if($("#model").val()=='concurrent'){
        var dialog = $.dialog({
          targetWindow:getCtpTop(),
          isDrag:true,
          width:900,
          height:450,
          scrolling:false,
          url:encodeURI("${path}/dee/deeTrigger.do?method=triggerDEETask&&taskType=data"),
          title : '${ctp:i18n("form.trigger.triggerSet.dee.label")}',
          buttons : [ {
            text : "${ctp:i18n('common.button.ok.label')}",
            id:"sure",
            handler : function() {
                var retValue = dialog.getReturnValue();
                if(retValue){
	                $("#taskId").val(retValue.taskId);
	                $("#taskNameDEE").val(retValue.taskName);
	                dialog.close();
                }
            }
          }, {
            text : "${ctp:i18n('common.button.cancel.label')}",
            id:"exit",
            handler : function() {
              dialog.close();
            }
          } ]
        });
      }else{
          var taskId=$("#taskId").val();
          var taskParam=$("#taskParam").val();
          var taskField=$("#taskField").val();
          var taskResult=$("#taskResult").val();
          var dialog = $.dialog({
          url:encodeURI("${path}/dee/deeDesign.do?method=setDEETask&isCanChange=true&highOperation=highOperation&random="+Math.round()+"&taskId="+taskId+"&taskParam="+taskParam
              +"&taskField="+taskField+"&taskResult="+taskResult),
          title : '${ctp:i18n("form.create.input.setting.deetask.label")}',
          width:500,
          height:300,
          targetWindow:getCtpTop(),
          buttons : [{
            text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
            id:"sure",
            handler : function() {
                var condi = dialog.getReturnValue();
                if(condi == "error"){
                    return;
                }else{
                    var taskName = condi.taskName;
                    var taskId = condi.taskId;
                    var taskResult = condi.taskResult;
                    var refFieldTable=condi.refFieldTable;
                    var taskParam=condi.taskParam;
                    var taskField=condi.taskField;
                    $("#taskId").val(taskId);
                    $("#taskNameDEE").val(taskName);
                    $("#taskResult").val(taskResult);
                    $("#refFieldTable").val(refFieldTable);
                    $("#taskParam").val(taskParam);
                    $("#taskField").val(taskField);
                  //  var refFieldDisplay = condi.refFieldDisplay;
                  //  if(refFieldDisplay ==""){
                    //    $("#nameAndFieldForSearch"+index).val(taskName);
                   // }else{
                        //$("#nameAndField"+index).val(taskName+"-"+refFieldDisplay); 
                    ///}
                   // setExchangeTaskData(condi,index);
                }
                dialog.close();
            }
          }, {
            text : "${ctp:i18n('form.query.cancel.label')}",
            id:"exit",
            handler : function() {
              dialog.close();
            }
          }]
        });
      }

    });
});


function OK() {
  try{
  var editName  = $.trim($("#name").val());
  var taskType=$("#taskType").val();
  var taskName = $("#taskName").val();
  if(taskType=='dee'){
   	var taskNameDEE= $("#taskNameDEE").val();
   	if(taskNameDEE==""){
     	$.alert("${ctp:i18n('form.event.task.null')}");
     	return 'false';
   	}
   	var taskId = $("#taskId").val();
   	if (taskId == null || taskId == undefined || taskId == '') { 
   		$.alert("dee任务id为空,绑定失败");
   		return 'false';
   	}
  }
  if(editName==""){
    $.alert("${ctp:i18n('form.event.name.null')}");
    return 'false';
  }else if(taskType=='ext'&&taskName==""){
    $.alert("${ctp:i18n('form.event.task.null')}");
    return 'false';
  }else{
    if(editName.indexOf("&") > -1){
      $.alert("${ctp:i18n('form.oper_unlawfulchar')}");
      return 'false';
    }if(editName.indexOf("<") > -1){
      $.alert("${ctp:i18n('form.oper_unlawfulchar')}");
      return 'false';
    }if(editName.indexOf(">") > -1){
      $.alert("${ctp:i18n('form.oper_unlawfulchar')}");
       return 'false';
    }if(editName.indexOf("\r\n") > -1){
      $.alert("${ctp:i18n('form.oper_unlawfulchar')}");
       return 'false';
    }if(editName.indexOf('"') > -1){
      $.alert("${ctp:i18n('form.oper_unlawfulchar')}");
       return 'false';
    }
  }
  return window;
  }catch(e){
    alert(e.message)
  }
 // window.dialogArguments.eventBind.name=document.getElementById("name").value;
}
</script>
</head>
<body style="overflow: hidden;" class="common_txtbox margin_10">

<div class="form_area">
    <form id="theForm" name="theForm" method="post" action="">
        <input type="hidden" id="eventBindId" name="eventBindId" value="${eventBindId}">
        <table border="0" cellspacing="0" cellpadding="0" style="margin: 0 auto;">
            <tbody>
            <tr>
                <th nowrap="nowrap">
                    <label class="margin_r_10" for="name"><font color='red'>*</font>${ctp:i18n('DataDefine.Name')}：</label></th>
                <td style="position: relative" width="60%">
                    <div class="common_txtbox_wrap">
                        <input type="text" id="name" name="name">
                        <span id="error_title" class="error-title" style="position: absolute;top:7px;right: -20px;"
                              title='${ctp:i18n('form.create.namecannotinput.label')}'/></span>
                    </div>

                </td>
            </tr>
            <tr>
                <th nowrap="nowrap">
                    <label class="margin_r_10" for="operationType">${ctp:i18n('DataDefine.Operation')}：</label></th>
                <td>
                    <div class="common_selectbox_wrap">
                        <select id="operationType" name="operationType">
                            <c:if test="${authTypeValue == 'add'}">
                                <option value="start">${ctp:i18n('form.operhigh.start.label')}</option>
                                <option value="repeal">${ctp:i18n('form.operhigh.repeal.label')}</option>
                            </c:if>
                            <c:if test="${authTypeValue == 'update' || authTypeValue == 'readonly'}">
                                <option value="submit">${ctp:i18n('form.operhigh.submit.label')}</option>
                                <option value="stepback">${ctp:i18n('form.operhigh.rollback.label')}</option>
                                <option value="takeback">${ctp:i18n('form.operhigh.takeback.label')}</option>
                                <option value="stepstop">${ctp:i18n('formquery_stop.label')}</option>
                                <option value="repeal">${ctp:i18n('form.operhigh.repeal.label')}</option>
                                <option value="dealSaveWait">${ctp:i18n('processLog.action.18')}</option>
                            </c:if>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap">
                    <label class="margin_r_10" for="model">${ctp:i18n('form.operhigh.model.label')}：</label></th>
                <td>
                    <div class="common_selectbox_wrap">
                        <select id="model" name="model">
                            <option value="block">${ctp:i18n('form.operhigh.block.label')}</option>
                            <option value="concurrent">${ctp:i18n('form.operhigh.concurrent.label')}</option>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap">
                    <label class="margin_r_10" for="taskType">${ctp:i18n('form.operhigh.tasktype.label')}：</label></th>
                <td>
                    <div class="common_selectbox_wrap">
                        <select id="taskType" name="taskType">

                            <option value="ext">${ctp:i18n('form.operhigh.ext.label')}</option>
                            <c:if test="${isHasDee eq true}">
                                <option value="dee">DEE</option>
                            </c:if>
                            <%--
                            <option value="other"><fmt:message key="form.operhigh.other.label"/></option>
                            --%>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap">
                    <label class="margin_r_10"><font color='red'>*</font>${ctp:i18n('form.operhigh.task.label')}：</label></th>
                <td>
                    <div>
                        <div id="divtext" style="display:none" class="common_txtbox_wrap">
                            <input type="hidden" id="taskId" name="taskId">
                            <input type="text" id="taskNameDEE" name="taskNameDEE">
                            <input type="hidden" id="taskResult" name="taskResult">
                            <input type="hidden" id="refInputField" name="refInputField">
                            <input type="hidden" id="refFieldTable" name="refFieldTable">
                            <input type="hidden" id="taskParam" name="taskParam">
                            <input type="hidden" id="taskField" name="taskField">
                        </div>
                        <div id="divtextselect" class="common_selectbox_wrap">
                            <select id="taskName" name="taskName">
                                <option value=""></option>
                                <c:forEach items="${taskList}" var="task" >
                                    <option value="${task[0]}">${task[1]}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
</div>
</body>
</html>