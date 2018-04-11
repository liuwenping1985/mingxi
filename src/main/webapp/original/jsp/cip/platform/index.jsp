<%@page import="com.seeyon.ctp.common.i18n.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>${ctp:i18n('cip.integrated.platform')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=cipMenuManager"></script>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/index.css"/>
</head>
<script type="text/javascript">
<%= ResourceUtil.getString("")%>
</script>
<body>
    <div class="frame-layout">
        <div class="left-layout">
            <div class="title">
                <i class="title-icon"></i>
                <span>${ctp:i18n('cip.integrated.platform')}</span>
            </div>
            <div class="menu">
                <div class="menu-list">
                </div>
            </div>
        </div>
        <div class="right-layout">
            <iframe class="iframe-layout" width="100%" height="100%" style="border: none;">
            	<img alt="" src="${path}/" />
            </iframe>
        </div>
        <div style="clear: both;"></div>
    </div>
    <script src="${path}/apps_res/cip/common/js/index.js"></script>
</body>
</html>