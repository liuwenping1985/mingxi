<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetApply.pbgsbsq.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/myAsset.js"></script>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp page_color" comp="type:'layout'">
  <div class="layout_center page_color over_hidden" layout="border:false">
    <table id="myAssetTab" class="flexme3" style="display: none;"></table>
  </div>
</div>
</body>
</html>