<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title><%-- 流程导入之后的界面 --%></title>
<body class="h100b">
<c:choose>
    <c:when test="${success==true }">
    ${ctp:i18n("workflow.label.importCheckSuccess")}
        <%-- 校验通过，请点击确定关闭页面！ --%>
    </c:when>
    <c:otherwise>
        <table class="form_area only_table edit_table margin_l_10" id="formTable" style="margin-top: 0px; table-layout: fixed;width:98%" border="0" cellspacing="0" cellpadding="0">
            <thead>
                <tr>
                    <th style="width: 60px;"><!-- 名称 -->${ctp:i18n("common.name.label") }</th>
                    <th style="width: 340px;"><!-- 类型 -->${ctp:i18n("workflow.replaceNode.14")}</th>
                    <th style="width: 100px;"><!-- 位置 -->${ctp:i18n("flowperm.auth.location") }</th>
                    <th style="width: 140px;"><!-- 对象值 -->${ctp:i18n("bizconfig.import.redirectform.dialog.objectval") }</th>
                    <th style="width: 80px;"><!-- 重定向 -->${ctp:i18n("bizconfig.import.redirectform.dialog.redirect") }</th>
                </tr>
             </thead>
             <tbody id="peoplesTbody">
                 <c:choose>
                    <c:when test="${validateResults==null || fn:length(validateResults)<=0}">
                        <tr class="erow" colspan="5">
                            <td style="border-right:0;">${ctp:i18n("workflow.deletePeople.noChildren") }</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${validateResults}" var="vd" varStatus="status">
                           <tr class="selectedTr">
                            <td>${vd.entityTypeName }</td>
                            <td>${vd.processName }---${vd.flowTypeLabel }</td>
                            <td>${vd.myPositionLabel }</td>
                            <td><input type="text" value="${vd.objectName }" readonly style="color:red;"></td>
                            <td>
                             ${vd.actionLabel }
                             <input type="hidden" name="templateId" value="${vd.templateId }"/>
                             <input type="hidden" name="nodeId" value="${vd.nodeId }"/>
                            </td>
                           </tr>
                         </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>
<script type="text/javascript">
    var success = ${success },process_xml = '${process_xml}',templateId = "${templateId}";
    //$("a.selectPeople").click(importSelectPeople);
    function OK(){
        var result = {process_xml : process_xml,checkForm:true,templateId:templateId}
        if(!success){
            var nodes = [];
            $("tr.selectedTr").each(function(){
                if($(this).find("input[name=nodeName]").val()==""){
                    result.checkForm = false;
                    //$.alert("请为下列节点选人："+$(this).find("input[name=nodeNameOld]").val());
                    $.alert($.i18n("workflow.label.dialog.selectStaff4Node.js", $(this).find("input[name=nodeNameOld]").val()));
                    return false;
                }
                nodes.push($(this).formobj());
            });
            result.nodes = nodes;
        }
        return $.toJSON(result);
    }
    var workfowFlashDialog= null;
    var _wfctxPath = '<%=request.getContextPath()%>';
    var _ctxPath = '<%=request.getContextPath()%>';
    var currentUserId = '<%=AppContext.currentUserId()%>'+'';
    function modifyWorkflowTemplate(ptemplateId,nodeId){
      var returnValueWindow= window;
      var tWindow= getCtpTop();
      if(workfowFlashDialog){
        workfowFlashDialog.isHide = false;
        workfowFlashDialog.close();
      }
      var dwidth= $(tWindow).width();
      var dheight= $(tWindow).height();
      workfowFlashDialog = $.dialog({
            isHide : true,
            url : _wfctxPath+'/workflow/designer.do?method=showDiagram&isDebugger=false&scene=0&isModalDialog=true'
                + '&appName=form'
                + '&processId='
                + ptemplateId
                + '&currentUserId='
                + currentUserId
                + '&currentNodeId='
                + nodeId,
            width : dwidth-20,
            height : dheight-100,
            title : $.i18n('workflow.designer.title'),
            targetWindow: tWindow,
            transParams : {
              subProcessJson : $("#process_subsetting",returnValueWindow.document).val(),
              formId : $("#formId").val(),
              dwidths: dwidth,
              dheights: dheight-20,
              workflowRule: $("#process_rulecontent",returnValueWindow.document).val(),
              returnValueWindow:returnValueWindow,
              verifyResultXml:"<vr s=\"false\"><n id=\""+nodeId+"\"><r0>false</r0><r0msg>${ctp:i18n('workflow.label.notExist')}</r0msg><r1>true</r1><r1msg></r1msg><r2>true</r2><r2msg></r2msg></n></vr>"
            },
            closeParam : {
              'show' : true
              ,handler : function(){
                  if(typeof recoverWorkFlowHistoryData == 'function'){
                      recoverWorkFlowHistoryData();
                  }
              }
            },
            minParam:{show:false},
            maxParam:{show:false},
            buttons : [ {
              text : $.i18n('workflow.designer.page.button.ok'),
              handler : function() {
                var returnValue = workfowFlashDialog.getReturnValue({"innerButtonId":"ok"});
                if(returnValue){
                  //从flash流程设计器中获得流程xml内容
                  initDialogDataToParentPage(returnValue,returnValueWindow,tWindow);
                  if(!$.browser.msie){
                    workfowFlashDialog.close();
                  }else{
                    workfowFlashDialog.hideDialog();
                  }
                  if(typeof finishWorkFlowModify == 'function'){
                      finishWorkFlowModify();
                  }
                }
              }
            }, {
              text : $.i18n('workflow.designer.page.button.cancel'),
              handler : function() {
                if(!$.browser.msie){
                  workfowFlashDialog.close();
                }else{
                  workfowFlashDialog.hideDialog();
                }
                if(typeof recoverWorkFlowHistoryData == 'function'){
                  recoverWorkFlowHistoryData();
                }
              }
            } ]
          });
    }
    function importSelectPeople(){
        if(window.nodeName){
            window.nodeName = null;
        }
        var tempThis = $(this);
        $.selectPeople({
            type:'selectPeople'
            ,panels:'Department,Team,Post,Outworker,RelatePeople'
            ,selectType:'Member,Department,Team,Post,Outworker,RelatePeople'
            ,text:"${ctp:i18n('workflow.insertPeople.urgerAlt')}"
            ,showFlowTypeRadio: false
            ,params:{
               value: ''
            }
            ,targetWindow:getCtpTop()
            ,callback : function(res){
                if(res && res.obj && res.obj.length>0){
                    var id , name , type , excludeChild , accountId , accountName;
                    id = res.obj[0].id;
                    name = res.obj[0].name;
                    type = res.obj[0].type;
                    if("Member"==type){type="user";}
                    excludeChild = res.obj[0].excludeChildDepartment;
                    accountId = res.obj[0].accountId;
                    accountName = res.obj[0].accountShortname;
                    var tempParent = tempThis.parent();
                    tempParent.find("input[name=partyId]").val(id);
                    tempParent.find("input[name=nodeName]").val(name);
                    tempParent.find("input[name=partyTypeId]").val(type);
                    tempParent.find("input[name=accountId]").val(accountId);
                    tempParent.find("input[name=accountShortname]").val(accountName);
                    tempParent.find("input[name=includeChild]").val(excludeChild);
                    tempParent = tempThis = null;
                } else {
                    //$.alert("请选择至少一个人！");
                    $.alert("${ctp:i18n('workflow.label.selectOneAtLeast')}");
                }
            }
        });
    }
</script>
</body>
</html>