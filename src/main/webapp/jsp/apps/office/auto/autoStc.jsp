<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆统计框架页面</title>
</head>
<body class="h100b over_hidden">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeAutoStc'"></div>
    <div class="margin_5 h100b" id="divId">
        <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
            <div id="tabs_head" class="common_tabs clearfix">
                <ul class="left">
                <c:if test="${isCarsAdmin}">
                    <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoCategory" title="${ctp:i18n('office.auto.use.stc.js')}"><span>${ctp:i18n('office.auto.use.stc.js')} </span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoInfo" title="${ctp:i18n('office.auto.dept.use.stc.js')}"><span>${ctp:i18n('office.auto.dept.use.stc.js')}</span> </a></li>
                </c:if>
                <c:if test="${isCarsAdmin || isCarsDriver}">
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoDriver" title="${ctp:i18n('office.auto.driver.drive.stc.js')}" style="max-width: none;"><span>${ctp:i18n('office.auto.driver.drive.stc.js')}</span> </a></li>
                </c:if>
                <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="officeTemplate" title="${ctp:i18n('office.auto.autoStcInfo.gryctj.js')}"><span>${ctp:i18n('office.auto.autoStcInfo.gryctj.js')}</span> </a></li>
                </ul>
            </div>
            <div id="tabs_body" class="common_tabs_body border_all">
                     <iframe id="autoCategory" border="0" hSrc="${path}/office/autoStc.do?method=autoStcInfo&option=find" frameBorder="0" width="100%"></iframe>
                     <iframe id="autoInfo" class="hidden" border="0" hSrc="${path}/office/autoStc.do?method=autoStcInfo&option=findByDept" frameBorder="0" width="100%"></iframe>
                     <iframe id="autoDriver" class="hidden" border="0" hSrc="${path}/office/autoStc.do?method=autoStcInfo&option=findByDriver" frameBorder="0" width="100%"></iframe> 
                     <iframe id="officeTemplate" class="hidden" border="0" hSrc="${path}/office/autoStc.do?method=autoStcInfo&option=findByMember" frameBorder="0" width="100%"></iframe>
            </div>
        </div>
    </div>
</body>
</html>