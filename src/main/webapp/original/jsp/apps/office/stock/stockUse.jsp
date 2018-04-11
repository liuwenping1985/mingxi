<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.portlet.stock.use.js')}</title>
</head>
<body class="h100b over_hidden">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeStockUse'"></div>
  <div class="margin_5 h100b" id="divId">
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId',showTabIndex:${tabIndex}">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
        <!-- RBAC改造这里将以角色判断是否显示   StocksAdmin-->
          <c:if test="${ctp:hasRoleName('StocksAdmin')}">
            <li ><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockGrant"><span>${ctp:i18n('office.stock.grant.js')}</span> </a></li>
          </c:if>
          <li ><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockApply"><span>${ctp:i18n('office.stock.apply.js')}</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockAudit"><span>${ctp:i18n('office.stock.audit.js')}</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockGrantLog"><span>${ctp:i18n('office.stock.grantlog.js')}</span> </a></li>
        </ul>
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <c:if test="${ctp:hasRoleName('StocksAdmin')}">
          <iframe id="stockGrant" hSrc="${path}/office/stockUse.do?method=stockGrant" border="0" frameBorder="0" width="100%"></iframe>
        </c:if>
        <iframe id="stockApply" hSrc="${path}/office/stockUse.do?method=stockApply" border="0" frameBorder="0" width="100%"></iframe>
        <iframe id="stockAudit" class="hidden" hSrc="${path}/office/stockUse.do?method=stockAudit" border="0" frameBorder="0" width="100%"></iframe>
        <iframe id="stockGrantLog" class="hidden" hSrc="${path}/office/stockUse.do?method=stockLogGrant" border="0" frameBorder="0" width="100%"></iframe>
      </div>
    </div>
  </div>
</body>
</html>