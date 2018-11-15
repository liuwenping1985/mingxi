<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title><%-- 流程导入之后的界面 --%></title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body>
<form id="goodForm" method="post" action="<c:url value='/workflow/cie.do?method=importProcess'/>" enctype="multipart/form-data">
    <input type="file" name="goodFile" value="${ctp:i18n('workflow.designer.branchtitle.formcheck')}"/>
</form>
<script type="text/javascript">
function OK(){
    $("#goodForm").submit();
    return "importStart";
}
</script>
</body>
</html>