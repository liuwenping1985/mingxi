<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2017/2/13
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>${ctp:i18n('system.menuname.mobileDashboardCreate')}</title>
</head>
<body id="layout">
<div class="color_gray margin_l_20">
    <div class="clearfix margin_t_20 margin_b_10">
        <h2 class="left margin_0">${ctp:i18n('system.menuname.mobileDashboardCreate')}</h2>
        <div class="font_size12 left margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('form.helpinfo.total')} <span id= "sizespan" class="font_bold color_black">${param.total}</span>${ctp:i18n('form.helpinfo.article')}</div>
        </div>
    </div>
    <div class="line_height160 font_size14">
        <p><span class="font_size12">●</span> ${ctp:i18n('biz.dashboard.helpinfo.label1')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('biz.dashboard.helpinfo.label2')}</p>
        <p><span class="font_size12">●</span> ${ctp:i18n('biz.dashboard.helpinfo.label3')}</p>
    </div>
</div>
</body>
</html>

