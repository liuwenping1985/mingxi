<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>表单查询</title>
</head>
<body id="layout" class="color_gray border_t">

<div class="clearfix margin_t_20 margin_b_10">
		<c:if test = "${param.formType eq '4' }">
        <h2 class="left margin_0">${ctp:i18n('plan.button.planquery')}</h2>
		</c:if>
		<c:if test = "${param.formType ne '4' }">
        <h2 class="left margin_0">${ctp:i18n('form.formquery.label')}</h2>
		</c:if>
        <div class="font_size12 left margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                <span class="font_bold color_black query_count_">${size}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
            </div>
        </div>
    </div>
    <div class="line_height160 font_size12 margin_l_10">
              <p><span class="font_size12">●</span>${ctp:i18n('formsection.infocenter.formquery.desc1')}</p>
              <p><span class="font_size12">●</span>${ctp:i18n('formsection.infocenter.formquery.desc2')}</p>
              <p><span class="font_size12">●</span>${ctp:i18n('formsection.infocenter.formquery.desc3')}</p>
              </div>
</body>
</html>
