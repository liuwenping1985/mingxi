<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆申请</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoIllegal.js"></script>
</head>
<body class="h100b over_hidden">
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div class="layout_center page_color over_hidden" layout="border:false">
            <table id="autoIllegal" class="flexme3" style="display: none;">
            </table>
        </div>
    </div>
</body>
</html>