<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用品库设置</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/stockPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockHouse.js"></script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false,border:false">
      <div id="toolbar"></div>
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
      <table id="stockHouse" class="flexme3" style="display: none;"></table>
      <div id="grid_detail">
        <iframe src="${path}/office/stockSet.do?method=stockHouseEdit" id="editIframe" width="100%" height="100%" frameborder="0"></iframe>
      </div>
    </div>
  </div>
</body>
</html>