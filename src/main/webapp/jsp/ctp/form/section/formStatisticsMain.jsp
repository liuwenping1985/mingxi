<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('report.common.crumbs.queryReport')}</title>
</head>
<body class="color_gray" >
<div class="clearfix margin_t_20 margin_b_10">
    <h2 class="left margin_0">${ctp:i18n('report.common.crumbs.queryReport')}</h2>
    <div class="font_size12 left margin_l_10">
        <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                <span class="font_bold color_black query_count_">${size}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
            </div>
    </div>
</div>
    <div class="line_height160 font_size12 margin_l_10">
        <p><span class="font_size12">●</span>${ctp:i18n('report.queryReport.index_intro.dialog.step1')}</p>
        <p><span class="font_size12">●</span>${ctp:i18n('report.queryReport.index_intro.dialog.step2')}</p>
        <p><span class="font_size12">●</span>${ctp:i18n('report.queryReport.index_intro.dialog.step3')}</p>
    </div>
</body>
</html>
