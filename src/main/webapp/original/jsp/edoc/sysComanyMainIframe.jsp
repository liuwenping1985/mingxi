<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/content/workflow.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=edocFormManager"></script>
<html  class="h100b">
<head>
<style>
html{height:100%;}
</style>

<script>

function bindEnum(metadataId,metadataName){
  var obj = new Array();
  obj[0] = window;
  var dialog = $.dialog({
    url:"${path}/enum.do?method=bindEnum&isfinal=0",
        title : '${ctp:i18n("form.field.bindenum.title.label")}',
        width:500,
    height:520,
    targetWindow:top,
    transParams:obj,
        buttons : [{
          text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
          id:"sure",
          handler : function() {
              var result = dialog.getReturnValue();
              if(result){
                metadataId.value = result.enumId;
                metadataName.value = result.enumName;
                dialog.close();
              }
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

function edocSelectTemplate(topWindow,currentWindow,templateId,categoryType,categoryId,currentFormId,appName,defaultPermName,defaultPerm){
	var dialog = $.dialog({
        url : _ctxPath+'/collTemplate/collTemplate.do?method=selectSourceTemplate&templateId=' + templateId + '&categoryId=' + categoryId + '&categoryType=' + categoryType,
        width : 700, 
        height : 430, 
        title : $.i18n('template.systemNewTem.selectSourceTemplate'), //选择源模板
        targetWindow : getCtpTop(),
        buttons : [ {
          isEmphasize:true,
          text :$.i18n('template.category.submit.label'),
          handler : function() {
            var category = dialog.getReturnValue();
            if(category == -1){
                //请选择一个模板!
                $.alert($.i18n('template.systemNewTem.selectOneTemplate'));
                return;
            }
            $("#process_info_bak").val($("#process_info").val());
            $("#process_xml_bak").val($("#process_xml").val());
            
            var manager = new edocFormManager();
            var selectedEdocFormId = manager.getFormIdByWorkflowId(category,true);
            if(selectedEdocFormId){
            	selectedEdocFormId = selectedEdocFormId.formId;
            }
            cloneWFTemplate(topWindow, appName, "", "",category,currentWindow,defaultPerm,$.ctx.CurrentUser.id,$.ctx.CurrentUser.name,
            		$.ctx.CurrentUser.loginAccountName,$.ctx.CurrentUser.loginAccount,null,null,defaultPermName,selectedEdocFormId,currentFormId);
            if(!$.browser.msie){
            	dialog.close();
            }else{
            	dialog.hideDialog();
            }
          }
        }, {
          text : $.i18n('template.category.cancel.label'),
          handler : function() {
        	  if(!$.browser.msie){
              	dialog.close();
              }else{
              	dialog.hideDialog();
              }
          }
        }]
      });
}
</script>


</head>
<body class="h100b over_hidden">

<input type="hidden" id="workFlowContent" />
<iframe id="sysComanyMainIframe" name="sysComanyMainIframe" src="edocController.do?method=sysCompanyMainIframe&categoryType=${param.categoryType}" width="100%" height="100%" style="border:0px;"/>
</body>
</html>
