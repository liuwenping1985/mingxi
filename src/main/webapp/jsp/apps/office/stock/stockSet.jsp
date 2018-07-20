<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>办公用品管理-基础设置</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/stockPub.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeStockSet'"></div>
  <div class="margin_5 h100b" id="divId">
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockHouse"><span>${ctp:i18n('office.asset.assetInfo.pypksz.js')}</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockReg"><span>${ctp:i18n('office.stock.regedit.js')}</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="officeTemplate"><span>${ctp:i18n('office.asset.assetSet.psplcsz.js')}</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockAddLibLog"><span>${ctp:i18n('office.stock.in.story.reg.js')}</span> </a></li>
        </ul>
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <iframe width="100%" border="0" frameborder="0" id="stockHouse" hSrc="${path}/office/stockSet.do?method=stockHouse"></iframe>
        <iframe width="100%" border="0" frameBorder="0" id="stockReg" class="hidden" hSrc="${path}/office/stockSet.do?method=stockInfo"></iframe>
        <iframe width="100%" border="0" frameborder="0" id="officeTemplate" class="hidden" hSrc="${path}/office/officeTemplate.do?method=index&officeApp=1"></iframe>
        <iframe width="100%" border="0" frameborder="0" id="stockAddLibLog" class="hidden" hSrc="${path}/office/stockSet.do?method=stockRecord"></iframe>
      </div>
    </div>
  </div>
</body>
</html>