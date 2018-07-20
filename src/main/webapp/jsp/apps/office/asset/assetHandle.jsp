<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetHandle.pbgsbjcgh.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetHandle.js"></script>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp page_color" comp="type:'layout'">
  <div class="layout_north" layout="height:30,sprit:false,border:false">
    <div id="toolbar"></div>
  </div>
  <div class="layout_center page_color over_hidden" layout="border:false">
    <table id="assetHandleTab" class="flexme3" style="display: none;"></table>
  </div>
</div>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</body>
</html>