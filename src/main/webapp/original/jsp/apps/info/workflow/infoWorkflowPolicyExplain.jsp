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
    <script type="text/javascript"></script>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="h100b ">
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
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.10.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.10.descp") }</div>
            </div>
            <div class="margin_5 border_all padding_5 font_size12">
                <div class="font_bold">${ctp:i18n("workflow.nodePolicy.11.label") }:</div>
                <div class="workflow_message">${ctp:i18n("workflow.nodePolicy.11.descp") }</div>
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

</body>
</html>