<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html class="h100b">
<head>
    <title>${ctp:i18n("node.policy.explain") }</title>
    <style type="text/css">
        .workflow_message{
            text-indent:2em;
            line-height:15pt;
        }
    </style>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="h100b ">
    <%--<textarea class="w100b h100b" readonly>${des}</textarea>
    <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">
            ${ctp:i18n("workflow.help1.label") }:
        </div>
        <div class="workflow_message">${ctp:i18n("workflow.help.1.label") }</div>
    </div>
    --%>
    <c:choose>
        <c:when test="${type eq '1'}">
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.1.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.1.descp") }</div>
            </div>
            <c:if test="${isGovVersion}">
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.2.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.2.descp") }</div>
            </div>
            </c:if>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.3.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.3.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.4.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.4.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.5.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.5.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.6.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.6.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.8.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.8.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.9.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.9.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.10.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.10.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.11.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.11.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.12.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.12.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.13.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.13.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.14.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.14.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.15.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.15.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.16.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.16.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.17.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.17.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.18.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.18.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.19.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.19.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.20.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.20.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.21.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.21.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.22.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.22.descp") }</div>
            </div>
            <c:if test="${!isGovVersion}">
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.23.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.23.descp") }</div>
            </div>
            </c:if>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.24.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.24.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.25.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.25.descp") }</div>
            </div>
        </c:when>
        <c:when test="${type eq '2' }">
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help1.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help32.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help32.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help33.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help33.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help34.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help34.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help2.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help2.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help3.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help3.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help29.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help29.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help5.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help5.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help6.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help6.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help7.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help7.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help8.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help8.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help9.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help9.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help10.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help10.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help11.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help11.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help12.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help12.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help13.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help13.1.label") }</div>
            </div><%--
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help14.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help14.1.label") }</div>
            </div>--%>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help15.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help15.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help16.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help16.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help17.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help17.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help18.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help18.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help19.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help19.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help20.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help20.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help21.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help21.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help22.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help22.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help23.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help23.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help24.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help24.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help25.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help25.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help26.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help26.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help27.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help27.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help28.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help28.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help30.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help30.1.label") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.help31.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.help31.1.label") }</div>
            </div>
        </c:when>
    </c:choose>
</body>
</html>