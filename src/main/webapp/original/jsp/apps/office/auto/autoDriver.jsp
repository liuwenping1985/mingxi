<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.auto.drivermanage.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"  src="${path}/apps_res/office/js/auto/autoDriver.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:40,sprit:false,border:false">
      <div id="toolbar"></div>
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
      <table id="autoDriver" class="flexme3" style="display: none;"></table>
      <div id="grid_detail" class="h100b">
        <iframe src="${path}/office/autoSet.do?method=autoDriverEdit" id="editIframe" width="100%" height="100%" frameborder="0"></iframe>
      </div>
    </div>
  </div>
</body>
</html>