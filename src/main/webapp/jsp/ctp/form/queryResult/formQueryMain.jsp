<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>表单查询</title>
</head>
<body id="layout" class="page_color">
<div class="explanationh">
    <div class="clearfix">
        <div class="explanationh_title">
            <c:if test="${param.formType eq '4' }">
                ${ctp:i18n('plan.button.planquery')}
            </c:if>
            <c:if test="${param.formType ne 4 }">
                ${ctp:i18n('form.formquery.label')}
            </c:if>
        </div>
        <div class="explanationh_num">( ${ctp:i18n('form.helpinfo.total')}<%--总计 --%>
            <span class="font_bold color_black query_count_">${param.size}</span> ${ctp:i18n('form.helpinfo.article')} )<%--条 --%>
        </div>
    </div>
    <ul class="explanationh_list">
        <li><span>${ctp:i18n('formsection.infocenter.formquery.desc1')}</span></li>
        <li><span>${ctp:i18n('formsection.infocenter.formquery.desc2')}</span></li>
        <li><span>${ctp:i18n('formsection.infocenter.formquery.desc3')}</span></li>
    </ul>
</div>
</body>
</html>
