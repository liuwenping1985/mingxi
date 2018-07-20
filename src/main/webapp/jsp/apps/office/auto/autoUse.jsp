<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function(){
	//IE8下不刷新问题
  fnTabsReLoad4IE8();
});
</script>
</head>
<body class="h100b over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeAutoUse'"></div>
<div class="margin_5 h100b" id="divId">
  <div id="tabs" class="comp" comp="type:'tab',parentId:'divId',showTabIndex:${tabIndex}">
    <div id="tabs_head" class="common_tabs clearfix">
      <ul class="left">
        <c:if test="${ctp:hasResourceCode('F03_officeAutoSend')}">
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoSend"><span>${ctp:i18n('office.tbar.send.js')}</span> </a></li>
        </c:if>
        <c:if test="${ctp:hasResourceCode('F03_officeAutoRecedeOut')}">
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoRecedeOut"><span>${ctp:i18n('office.auto.out.reback.car.js')}</span> </a></li>
        </c:if>
        <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoApply"><span>${ctp:i18n('office.portlet.auto.apply.js')}</span> </a></li>
        <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoAudit"><span>${ctp:i18n('office.auto.apply.audit.js')}</span> </a></li>
      </ul>
    </div>
    <div id="tabs_body" class="common_tabs_body border_all">
      <c:if test="${ctp:hasResourceCode('F03_officeAutoSend')}">
      	<iframe id="autoSend" border="0" hSrc="${path}/office/autoUse.do?method=autoSend" frameBorder="0" width="100%"></iframe>
      </c:if>
      <c:if test="${ctp:hasResourceCode('F03_officeAutoRecedeOut')}">
        <iframe id="autoRecedeOut" border="0" hSrc="${path}/office/autoUse.do?method=autoRecedeOut" frameBorder="0" width="100%"></iframe>
      </c:if>
      <iframe id="autoApply" border="0" hSrc="${path}/office/autoUse.do?method=autoApply" frameBorder="0" width="100%"></iframe>
      <iframe id="autoAudit" border="0" hSrc="${path}/office/autoUse.do?method=autoAudit" frameBorder="0" width="100%"></iframe>
    </div>
  </div>
</div>
</body>
</html>