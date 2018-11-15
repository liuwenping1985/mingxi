<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
<title>${ctp:i18n('workflow.deletePeople.title')}</title>
</head>
<body>
<form id="deleteNodeForm" style="display:none" action="<c:url value='/workflow/process.do?method=preDeleteNodeFromDiagram'/>" method="post">
    <input type="hidden" id="processId" name="processId"/>
    <input type="hidden" id="nodeId" name="nodeId"/>
    <input type="hidden" id="processXML" name="processXML"/>
</form>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
var paramObjs= window.parentDialogObj['workflow_dialog_prePreDeleteNodeFromDiagram'].getTransParams();
//if(window.dialogArguments){
if(paramObjs){
    //var param = window.dialogArguments;
    var param = paramObjs;
    if(param.processId){
        $("#processId").val(param.processId);
    }
    if(param.nodeId){
        $("#nodeId").val(param.nodeId);
    }
    if(param.processXML){
        $("#processXML").val(param.processXML);
    }
    $("#deleteNodeForm").jsonSubmit();
}
</script>
</body>
</html>