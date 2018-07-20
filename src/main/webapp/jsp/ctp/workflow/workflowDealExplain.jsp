<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<html class="h100b">
<head>
    <title>${ctp:i18n("workflow.designer.node.deal.explain")}</title>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="page_color h100b over_hidden">
    <textarea class="w100b h100b" readonly id="content">${desc}</textarea>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
</body>
</html>