<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html class="h100b">
<head>
    <title>${ctp:i18n("node.policy.match.scope.explain")}</title>
    <style type="text/css">
        .workflow_message{
            text-indent:2em;
            line-height:15pt;
        }
    </style>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="h100b ">
<div class="margin_5 border_all padding_5 font_size12">
    <div class="font_bold">${ctp:i18n("node.policy.match.scope.help1.title") }:</div>
    <c:if test="${isGroup=='true' }">
      <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.subtitle1")}</div>
      <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg1")}</div>
      <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg2")}</div>
      <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg3")}</div>
      <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg4")}</div>
      <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg5")}</div>
    </c:if>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.subtitle2")}</div>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg6")}</div>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg7")}</div>
    
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.subtitle3")}</div>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg8")}</div>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg11")}</div>
</div>
<div class="margin_5 border_all padding_5 font_size12">
    <div class="font_bold">${ctp:i18n("node.policy.match.scope.help2.title") }:</div>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg9")}</div>
    <div class="workflow_message">${ctp:i18n("node.policy.match.scope.help1.submsg10")}</div>
    <div class="workflow_message">
        <ul>
            <li style="list-style: disc;list-style-position: inside;">${ctp:i18n("node.policy.match.scope.help1.submsg10.li")}</li>
            <li style="list-style: disc;list-style-position: inside;">${ctp:i18n("node.policy.match.scope.help1.submsg10.li1")}</li>
            <li style="list-style: disc;list-style-position: inside;">${ctp:i18n("node.policy.match.scope.help1.submsg10.li2")}</li>
            <li style="list-style: disc;list-style-position: inside;">${ctp:i18n("node.policy.match.scope.help1.submsg10.li3")}</li>
            <li style="list-style: disc;list-style-position: inside;">${ctp:i18n("node.policy.match.scope.help1.submsg10.li4")}</li>
        </ul>
    </div>
</div>
</body>
</html>