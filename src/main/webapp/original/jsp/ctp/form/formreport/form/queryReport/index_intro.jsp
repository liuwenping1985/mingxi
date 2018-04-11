<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('report.common.crumbs.queryReport')}</title>
</head>
	<body class="page_color">
        <div class="explanationh">
            <div class="clearfix">
                <div class="explanationh_title">
					<c:choose>
					<c:when test="${formType=='4'}">
					${ctp:i18n('plan.button.planstatics')}
					</c:when>
					<c:otherwise>
					${ctp:i18n('report.common.crumbs.queryReport')}
					</c:otherwise>
					</c:choose>
				</div>
                <div class="explanationh_num">
                	（ ${ctp:i18n('report.common.count.totals')} <span class="font_bold color_black">${ctp:toHTML(reportSize) }</span> ${ctp:i18n('report.common.count.unit')}）
				</div>
            </div>
            <ul class="explanationh_list">
                <li><span>${ctp:i18n('report.queryReport.index_intro.dialog.step1')}</span></li>
                <li><span>${ctp:i18n('report.queryReport.index_intro.dialog.step2')}</span></li>
                <li><span>${ctp:i18n('report.queryReport.index_intro.dialog.step3')}</span></li>
            </ul>
        </div>
    </body>
</html>
