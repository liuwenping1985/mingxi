<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>${ctp:i18n('subflow.setting.selectFlow')}</title>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="">
    <table class="only_table edit_table no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
        <thead>
            <tr>
                <th width="20"> </th>
                <th>${ctp:i18n('subflow.setting.formTempleteTitle')}</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${templateList}" var="formTemplete" varStatus="status">
                <c:if test="${formTemplete.id ne currentFormTempleteId}">
                <c:set value="true" var="isFrist"/>
                <tr class="">
                    <td>
                        <input type="radio" id="radio${status.index}" name="templeteId" templeteName="${formTemplete.processName}" ${(formTemplete.id eq subProcessTempleteId) ? 'checked':''} value="${formTemplete.id}">
                    </td>
                    <td class="checkedFirstTdRadio">
                        ${formTemplete.processName}
                    </td>
                </tr>
                <c:set value="false" var="isFrist"/>
                </c:if>
            </c:forEach>
        </tbody>
    </table>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowSelectTemplate_js.jsp"%>
</script>
</body>
</html>