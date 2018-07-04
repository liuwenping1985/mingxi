<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<style type="text/css">
.stadic_layout_body {
	bottom: 0px;
}
</style>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/book/bookBorrow.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b">
<div id="tabs"  class="stadic_layout" style="*position:absolute;height:98%;width:100%">
		<ul id="queryResult" class="align_center border_tb common_tabs_body stadic_body_top_bottom h100b" style="top:40px;bottom:35px;overflow:auto; background:#fff;width: 100%;">
        </ul>
</div>
</body>
</html>