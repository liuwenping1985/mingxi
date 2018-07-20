<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>
<body class="h100b over_hidden">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeBookSet'"></div>
  <div class="margin_5 h100b" id="divId">
    <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookHouse" title="${ctp:i18n('office.book.bookSet.ptszlksztszlksz.js') }" style="max-width: none;"><span>${ctp:i18n('office.book.bookSet.ptszlksztszlksz.js') }</span></a></li>
          <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="bookInfo"><span title="${ctp:i18n('office.book.bookSet.ptszldjtszldj.js') }">${ctp:i18n('office.book.bookSet.ptszldjtszldj.js') }</span></a></li>
        </ul>
      </div>
      <div id="tabs_body" class="common_tabs_body border_all">
        <iframe width="100%" border="0" frameborder="0" id="bookHouse" hSrc="${path}/office/bookSet.do?method=bookHouse"></iframe>
        <iframe width="100%" border="0" frameborder="0" id="bookInfo" hSrc="${path}/office/bookSet.do?method=bookInfo"></iframe>
      </div>
    </div>
  </div>
</body>
</html>