<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>
<body class="h100b over_hidden">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeBookStc'"></div>
  <div class="margin_5 h100b" id="divId">
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <c:if test="${isBooksAdmin}">
            <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockInfoStc"><span>${ctp:i18n('office.book.bookStc.ptszltj.js') }</span></a></li>
          </c:if>
          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="stockUseStc"><span>${ctp:i18n('office.book.bookStc.pjytj.js') } </span></a></li>
        </ul>
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <iframe id="stockInfoStc" border="0" hSrc="${path}/office/bookStc.do?method=bookStcInfo&option=findByBook" frameBorder="0" width="100%"></iframe>
        <iframe id="stockUseStc" class="hidden" border="0" hSrc="${path}/office/bookStc.do?method=bookStcInfo&option=findByMemberOrDepartMent" frameBorder="0" width="100%"></iframe>
      </div>
    </div>
  </div>
</body>
</html>