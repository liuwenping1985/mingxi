<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<html>
<head>
<title>${ctp:i18n("subflow.viewNewflow")}</title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body scroll="no" style="overflow: hidden">
    <table class="only_table edit_table no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
        <thead>
            <tr class="sort">
                <td width="60%" type="String">
                    ${ctp:i18n("common.subject.label")}
                </td>
                <td width="100" nowrap="nowrap">${ctp:i18n("subflow.isFinshed.label") }</td>
                <td type="String" nowrap="nowrap">
                    ${ctp:i18n("subflow.view")}
                </td>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${subList}" var="subSet" varStatus="status">
                <c:set value="true" var="isFrist"/>
                <tr>
                    <td title="${subSet.subject }">
                        ${subSet.subject }
                    </td>
                    <td>
                        <c:if test="${subSet.isFinished==1}">
                        ${commonTrue}
                        </c:if>
                        <c:if test="${subSet.isFinished!=1}">
                        ${commonFalse}
                        </c:if>
                    </td>
                    <td>
                        <a id="btnsave" index="${status.index }" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n("subflow.view")}</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowViewRelateFlow_js.jsp"%>
</script>
</body>
</html>