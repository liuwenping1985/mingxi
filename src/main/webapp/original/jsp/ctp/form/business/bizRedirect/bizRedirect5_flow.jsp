<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="bizRedirectUtil.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务重定向</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
<!-- 工具方法 -->
<script>
var resultObj = {};
var currentSet;

var startOperationId = "${startOperation}";//默认开始节点表单权限
var nomorlOperationId = "${nomorlOperation}";//默认处理节点表单权限
/**
 * 切换页签回掉函数,返回obj 对象
 * obj.complateRedirect 是否完成当前页面所有重定向
 * obj.bizObj 当前页面返回的 json 对象
 */
 function getResultJSON(){
    resultObj.completeRedirect = redirectGrid.checkRedirectRight();
    resultObj.bizObj = redirectGrid.getResultJSON();
   return resultObj;
 }

var redirectGrid;
$(document).ready(function(){
  redirectJSON = parent.getData();
  resultObj.completeRedirect = false;
  resultObj.bizObj = redirectJSON;
  var redirectJSON = $.parseJSON(redirectJSON);
    redirectGrid = new RedirectGrid({data:redirectJSON,dom:$("#first")[0],showInputType:false,headType:2});
    $("input[id='location4System'][value='workFlow']",$("#first")).each(function(){
        var parentTr = $(this).parents("tr");
        var workFlowId = $("#value4System",parentTr).val();
        var cloneDiv = $("#second").clone();
        cloneDiv.attr("id",cloneDiv.attr("id")+"_" + workFlowId)
        $("#process_id",cloneDiv).val(workFlowId);
        $("input",cloneDiv).each(function(){
            //$(this).attr("id",$(this).attr("id")+"_" + workFlowId);
        });
        $("td:first-child",parentTr).append(cloneDiv);
    });
    parent.window.endLoadingData();
});

</script>
</head>
<body style="overflow: auto;">
<div id="second" class="hidden">
    <input id="isFlowCopy" name="isFlowCopy" type="hidden" value='0'>
    <input id="process_id" name="process_id" type="hidden">
    <input id="process_xml" name="process_xml" type="hidden">
    <input id="process_desc_by" name="process_desc_by" type="hidden">
    <input id="process_subsetting" name="process_subsetting" type="hidden">
    <input id="process_rulecontent" name="process_rulecontent" type="hidden">
    <input id="workflow_newflow_input" name="workflow_newflow_input" type="hidden">
    <input id="workflow_node_peoples_input" name="workflow_node_peoples_input" type="hidden">
    <input id="workflow_node_condition_input" name="workflow_node_condition_input" type="hidden">
    <input id="process_xml_clone" name="process_xml_clone" type="hidden">
    <input id="process_xml_clone2flowCopy" name="process_xml_clone2flowCopy" type="hidden">
    <input id="process_event" name="process_event" type="hidden">
</div>
<div id = "first">
    </div>
</body>
</html>