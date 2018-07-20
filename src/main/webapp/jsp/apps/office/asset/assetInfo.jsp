<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetInfo.pypksz.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetInfo.js"></script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false,border:false">
      <div id="toolbar"></div>
    </div>
    <!-- 这是是tree -->
    <div class="layout_west bg_color_white stadic_layout_body stadic_body_top_bottom" id="west" layout="width:200">
        <div id="assetTypeTree"  ></div>
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
      <table id="assetInfo" class="flexme3" style="display: none;"></table>
      <div id="grid_detail">
        <iframe src="${path}/office/assetSet.do?method=assetInfoEdit" id="editIframe" width="100%" height="100%" frameborder="0"></iframe>
      </div>
    </div>
    <form id="expOrImp" action="${path }/office/stockSet.do?method=exportStockInfo" method="post"></form>
    <div id="dyncid"></div>
  </div>
</body>
</html>