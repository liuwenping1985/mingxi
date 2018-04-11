<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetSet.pbgsbgljcsz.js')}</title>
</head>
<body class="h100b over_hidden">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeAssetSet'"></div>
  <div class="margin_5 h100b" id="divId">
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="assetHouse"><span>${ctp:i18n('office.asset.assetHouse.psbksz.js') }</span></a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="assetInfo"><span>${ctp:i18n('office.asset.assetSet.psbdj.js') }</span></a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="officeTemplate"><span>${ctp:i18n('office.asset.assetSet.psplcsz.js') }</span></a></li>
        </ul>
        
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <iframe width="100%" border="0" frameborder="0" id="assetHouse" hSrc="${path}/office/assetSet.do?method=assetHouse"></iframe>
        <iframe width="100%" border="0" frameborder="0" id="assetInfo" hSrc="${path}/office/assetSet.do?method=assetInfo"></iframe>
        <iframe width="100%" border="0" frameborder="0" id="officeTemplate" class="hidden" hSrc="${path}/office/officeTemplate.do?method=index&officeApp=2"></iframe>
      </div>
    </div>
  </div>
</body>
</html>