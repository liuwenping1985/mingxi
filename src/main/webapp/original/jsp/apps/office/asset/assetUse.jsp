<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetUse.pbgsbsy.js') }</title>
</head>
<body class="h100b over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeAssetUse'"></div>
<div class="margin_5 h100b" id="divId">
  <div id="tabs" class="comp" comp="type:'tab',parentId:'divId',showTabIndex:${tabIndex}">
    <div id="tabs_head" class="common_tabs clearfix">
      <ul class="left">
          <c:if test="${ctp:hasResourceCode('F03_officeAssetRecede')}">
            <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="assetHandle"><span>${ctp:i18n('office.asset.assetUse.pjcgh.js') }</span> </a></li>
          </c:if>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="assetApply"><span>${ctp:i18n('office.asset.assetUse.psbsq.js') }</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="assetAudit"><span>${ctp:i18n('office.asset.assetUse.psbsp.js') }</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="myAsset"><span>${ctp:i18n('office.asset.assetUse.pwdsb.js') }</span> </a></li>
           <c:if test="${ctp:hasResourceCode('F03_officeAssetQuery')}">
            <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="assetInfoQuery"><span>${ctp:i18n('office.asset.assetUse.psbcx.js') }</span> </a></li>
          </c:if>
      </ul>
    </div>
    <div id="tabs_body" class="common_tabs_body border_all">
      <c:if test="${ctp:hasResourceCode('F03_officeAssetRecede')}">
        <iframe id="assetHandle" class="hidden" border="0" hSrc="${path}/office/assetUse.do?method=assetHandle" frameBorder="0" width="100%"></iframe>
      </c:if>
      <c:if test="${ctp:hasResourceCode('F03_officeAssetQuery')}">
        <iframe id="assetInfoQuery" class="hidden" border="0" hSrc="${path}/office/assetUse.do?method=assetInfoQuery" frameBorder="0" width="100%"></iframe>
      </c:if>
      <iframe id="assetApply" border="0" hSrc="${path}/office/assetUse.do?method=assetApply" frameBorder="0" width="100%"></iframe>
      <iframe id="assetAudit" class="hidden" border="0" hSrc="${path}/office/assetUse.do?method=assetAudit" frameBorder="0" width="100%"></iframe>
      <iframe id="myAsset" class="hidden" border="0" hSrc="${path}/office/assetUse.do?method=myAsset" frameBorder="0" width="100%"></iframe>
    </div>
  </div>
</div>
</body>
</html>