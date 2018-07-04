<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>
<body class="h100b over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeBookUse'"></div>
<div class="margin_5 h100b" id="divId">
  <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
    <div id="tabs_head" class="common_tabs clearfix">
      <ul class="left">
          <c:if test="${ctp:hasResourceCode('F03_officeBookAudit')}">
	          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookAudit"><span>${ctp:i18n('office.book.bookUse.ptszlsp.js') }</span> </a></li>
	          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookLend"><span>${ctp:i18n('office.book.bookUse.ptszljc.js') }</span> </a></li>
	          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookRemand"><span>${ctp:i18n('office.book.bookUse.ptszlgh.js') }</span> </a></li>
          </c:if>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookLib"><span>${ctp:i18n('office.book.bookUse.ptszlk.js') }</span> </a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookMyLend"><span>${ctp:i18n('office.book.bookUse.pwdjy.js') }</span> </a></li>
      </ul>
    </div>
    <div id="tabs_body" class="common_tabs_body border_all">
      <c:if test="${ctp:hasResourceCode('F03_officeBookAudit')}">
	      <iframe id="bookAudit" class="hidden" border="0" hSrc="${path}/office/bookUse.do?method=bookAudit" frameBorder="0" width="100%"></iframe>
	      <iframe id="bookLend" class="hidden" border="0" hSrc="${path}/office/bookUse.do?method=bookLend" frameBorder="0" width="100%"></iframe>
	      <iframe id="bookRemand" class="hidden" border="0" hSrc="${path}/office/bookUse.do?method=bookRemand" frameBorder="0" width="100%"></iframe>
      </c:if>
      <iframe id="bookLib" class="hidden" border="0" hSrc="${path}/office/bookUse.do?method=bookLib" frameBorder="0" width="100%"></iframe>
      <iframe id="bookMyLend" class="hidden" border="0" hSrc="${path}/office/bookUse.do?method=myLend" frameBorder="0" width="100%"></iframe>
    </div>
  </div>
</div>
</body>
</html>