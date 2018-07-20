<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>督办统计</title>
</head>
	<body class="page_color">
        <div class="explanationh">
            <div class="clearfix">
                <div class="explanationh_title">
					督办统计查看
				</div>
                <div class="explanationh_num">
                	（ ${ctp:i18n('report.common.count.totals')} <span class="font_bold color_black">${ctp:toHTML(reportSize) }</span> ${ctp:i18n('report.common.count.unit')}）
				</div>
            </div>
            <ul class="explanationh_list">
                <li><span>${ctp:i18n('report.queryReport.index_intro.dialog.step1')}</span></li>
                <li><span>可以将统计结果打印，导出操作.</span></li>
                <li><span>${ctp:i18n('report.queryReport.index_intro.dialog.step3')}</span></li>
            </ul>
        </div>
    </body>
</html>
