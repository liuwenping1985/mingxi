<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.car.maintain.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function(){
    //IE8下不刷新问题
  fnTabsReLoad4IE8();
});
</script>
</head>
<body class="h100b over_hidden">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeAutoMgr'"></div>
    <div class="margin_5 h100b" id="divId">
        <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
            <div id="tabs_head" class="common_tabs clearfix">
                <ul class="left">
                    <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoRepair"><span>${ctp:i18n('office.auto.repair.js') }</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoIllegal"><span>${ctp:i18n('office.auto.illegal.js') }</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoSafety"><span>${ctp:i18n('office.auto.safety.js') }</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoInspection"><span>${ctp:i18n('office.auto.inspection.js') }</span> </a></li>
                </ul>
            </div>
            <div id="tabs_body" class="common_tabs_body border_all">
                <iframe id="autoRepair" border="0" hSrc="${path}/office/autoMgr.do?method=autoRepair" frameBorder="0" width="100%"></iframe>
                <iframe id="autoIllegal" class="hidden" border="0" hSrc="${path}/office/autoMgr.do?method=autoIllegal" frameBorder="0" width="100%"></iframe>
                <iframe id="autoSafety" class="hidden" border="0" hSrc="${path}/office/autoMgr.do?method=autoSafety" frameBorder="0" width="100%"></iframe>
                <iframe id="autoInspection" class="hidden" border="0" hSrc="${path}/office/autoMgr.do?method=autoInspection" frameBorder="0" width="100%"></iframe>
            </div>
        </div>
    </div>
</body>
</html>