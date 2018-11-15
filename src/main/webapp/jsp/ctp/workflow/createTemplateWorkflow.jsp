<%--
/**
 * $Author: zhoulj $
 * $Rev: 28502 $
 * $Date:: 2013-08-15 10:30:13#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="workflowDesigner_js_api.jsp" %>
<script type="text/javascript" src="<c:url value='/common/SelectPeople/js/orgDataCenter.js' />"></script>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=selectPeopleManager,WFAjax' />"></script>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.designer.title')}</title>
</head>
<body class="page_color">
<div name="form" id="form" class="form_area" action="<c:url value='/workflow/designer.do?method=addProcessTemplate'/>" method="post">
<input type="hidden" name="from" value="${from }"/>
<input type="hidden" name="state" value="1"/>
<input type="hidden" name="templateId" value=""/>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
<tr>
    <th align="right">流程模版名称</th>
    <td align="left">
    <input type="text" id="process_name" name="process_name" value="" class="validate" validate="type:'string',name:'流程模版名称',notNull:true"></td>
    <th align="right">描述格式</th>
    <td align="left"><input type="text" id="process_desc_by" name="process_desc_by" value="" readonly="readonly"></td>
</tr>
<c:if test="${from=='form' }">
<tr>
    <th align="right">表单Id</th>
    <td align="left" colspan="3">
        <input id="formId" type="text" name="formId" value="${formApp }" class="validate" validate="isNumber:true,name:'表单Id',notNull:true"/>
    </td>
</tr>
</c:if>
<tr>
    <th align="right">导入流程</th>
    <td align="left" colspan="3">
        <input type="button" value="导入" onclick="importTemplate();"/>
    </td>
</tr>
<tr>
    <th align="right">流程信息</th>
    <td align="left" colspan="3"><textarea type="text" id="process_info" name="process_info" value="" readonly="readonly"></textarea></td>
</tr>
<tr>
    <th align="right">流程规则内容</th>
    <td align="left" colspan="3"><textarea type="text" id="process_rulecontent" name="process_rulecontent" style="width: 90%" value="" readonly="readonly"></textarea></td>
</tr>
<tr>
    <th align="right">子流程触发设置</th>
    <td align="left" colspan="3"><textarea id="process_subsetting" name="process_subsetting" value="" readonly="readonly"></textarea></td>
</tr>
<tr>
    <th align="right">流程模版定义xml内容<a href="javascript:createTemplate();">编辑流程图</a></th>
    <td align="left" colspan="3"><textarea cols="100" rows="10" id="process_xml" name="process_xml" value="" class="validate" validate="type:'string',name:'流程模版定义xml内容',notNull:true"></textarea></td>
</tr>
</table>
<table align="center">
    <tr>
        <td>
        <input type="button" value="确定" onclick="addWorkFlowTempalte();">
        </td>
        <td>
        <input type="button" value="另存为" onclick="addNewWorkFlowTempalte();">
        </td>
        <td>
        <input type="button" value="取消" onclick="cancelWorkFlowTempalte();">
        </td>
    </tr>
</table>
</div>
<iframe id="goodIframe" name="goodIframe" style="display:none"></iframe>
</body>
</html>
<script>
function importTemplate(){
    var dialog = $.dialog({
        url : '<c:url value="/workflow/cie.do?method=importProcessPre"/>',
        width : 400,
        height : 280,
        title : '导入',
        buttons : [
            {
                text : '${ctp:i18n("common.button.ok.label") }',
                handler : function(){
                    try{
                        var result = dialog.getReturnValue();
                        if(result!=null){
                            if(result!="importStart"){
                                result = $.parseJSON(result);
                                var xml = result.process_xml;
                                if(result.checkForm){
                                    if(result.nodes && result.nodes.length>0){
                                        var wfAjax= new WFAjax();
                                        var res = wfAjax.validateFailReSelectPeople(result.process_xml, result.nodes);
                                        xml = res.process_xml;
                                    }
                                    $("input[name=templateId]").val(result.templateId);
                                    $("#process_xml").val(xml);
                                    dialog.close();
                                }
                            }
                        }
                    }catch(e){$.alert(e.message);}
            }},
            {
                text : '${ctp:i18n("common.button.cancel.label") }',
                handler : function(){
                    dialog.close();
            }}
        ],
        targetWindow: getCtpTop()
    });
}
function createTemplate(){
  <c:choose>
  <c:when test="${from == 'form' }">
  createWFTemplate(window,'collaboration',$("#formId").val(),'1','',window,'shenpi','<%=AppContext.currentUserId()%>','<%=AppContext.currentUserName()%>','<%=AppContext.currentAccountName()%>','<%=AppContext.currentAccountId()%>','-1','-1');
  </c:when>
  <c:when test="${from == 'edoc' }">
  createWFTemplate(window,'edoc','','','',window,'collaboration','<%=AppContext.currentUserId()%>','<%=AppContext.currentUserName()%>','<%=AppContext.currentAccountName()%>','<%=AppContext.currentAccountId()%>','-1','-1');
  </c:when>
  <c:when test="${from == 'person' }">
  createWFPersonal(window,'collaboration','<%=AppContext.currentUserId()%>','<%=AppContext.currentUserName()%>','<%=AppContext.currentAccountName()%>');
  </c:when>
  <c:otherwise>
  createWFTemplate(window,'collaboration','-1','-1','',window,'collaboration','<%=AppContext.currentUserId()%>','<%=AppContext.currentUserName()%>','<%=AppContext.currentAccountName()%>','<%=AppContext.currentAccountId()%>','-1','-1');
  </c:otherwise>
  </c:choose>
}

function addWorkFlowTempalte(){
  /*var process_name= $("#process_name")[0].value;
  var process_xml= $("#process_xml")[0].value;
  if(process_xml=='' ){
    showFlashAlert("请新建流程，再保存！");
  }else if(process_name==''){
    showFlashAlert("请输入流程模版名称，再保存！");
  }else{
    document.getElementById("form").submit();
  }*/
  var templateId = $("input[name=templateId]").val();
  if(templateId!=null){
    var wfAjax= new WFAjax();
    var res = wfAjax.templateExist(templateId);
    if(res.exist){
      $.alert("该模版已存在，请删除后再进行导入！");
      return;
    }
  }
  var result = $("#form").validate();
  if(result){
    $("#form").jsonSubmit({debug:true});
  }
}
function addNewWorkFlowTempalte(){
  $("input[name=templateId]").val("");
  var result = $("#form").validate();
  if(result){
    $("#form").jsonSubmit({debug:true});
  }
}
function cancelWorkFlowTempalte(){
  window.location.href= "<c:url value='/workflow/designer.do'/>";
}
</script>
