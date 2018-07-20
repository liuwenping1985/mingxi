<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n("node.policy.explain")}</title>
</head>
<style type="text/css">
.workflow_message {
  text-indent: 2em;
  line-height: 15pt;
}
</style>
<body class="h100b" style="overflow: hidden;">
  <c:choose>
    <c:when test="${param.subAppName eq 'auto'}">
      <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">${ctp:i18n("office.template.node.1.label.js")}</div>
        <div class="workflow_message">${ctp:i18n("office.template.node.1.desc.js")}</div>
      </div>
      <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">${ctp:i18n("office.template.node.2.label.js")}</div>
        <div class="workflow_message">${ctp:i18n("office.template.node.2.desc.js")}</div>
      </div>
    </c:when>
    <c:when test="${param.subAppName eq 'stock'}">
      <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">${ctp:i18n("office.template.node.1.label.js")}</div>
        <div class="workflow_message">${ctp:i18n("office.template.node.3.desc.js")}</div>
      </div>
      <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">${ctp:i18n("office.template.node.2.label.js")}</div>
        <div class="workflow_message">${ctp:i18n("office.template.node.4.desc.js")}</div>
      </div>
    </c:when>
    <c:when test="${param.subAppName eq 'asset'}">
      <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">${ctp:i18n("office.template.node.1.label.js")}</div>
        <div class="workflow_message">${ctp:i18n("office.template.node.5.desc.js")}</div>
      </div>
      <div class="margin_5 border_all padding_5 font_size12">
        <div class="font_bold">${ctp:i18n("office.template.node.2.label.js")}</div>
        <div class="workflow_message">${ctp:i18n("office.template.node.6.desc.js")}</div>
      </div>
    </c:when>
  </c:choose>
</body>
</html>