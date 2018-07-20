<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆基础设置框架页面</title>
<script type="text/javascript">
$(function(){
	fnTabsReLoad4IE8();
});
</script>
</head>
<body class="h100b over_hidden">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F03_officeAutoSet'"></div>
    <div class="margin_5 h100b" id="divId">
        <div id="tabs" class="comp" comp="type:'tab',parentId:'divId'">
            <div id="tabs_head" class="common_tabs clearfix">
                <ul class="left">
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoCategory"><span>${ctp:i18n('office.auto.car.categorySet.js')}</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoInfo"><span>${ctp:i18n('office.auto.car.regedit.js')}</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoDriver"><span>${ctp:i18n('office.auto.driver.regedit.js')}</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="officeTemplate"><span>${ctp:i18n('office.asset.assetSet.psplcsz.js')}</span> </a></li>
                    <li><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="fnTabToggle(this);" tgt="autoNoticeSet"><span>${ctp:i18n('office.auto.dqtxsz.js')}</span> </a></li>
                </ul>
            </div>
            <div id="tabs_body" class="common_tabs_body border_all">
                <iframe id="autoCategory" border="0" hSrc="${path}/office/autoSet.do?method=autoCategory" frameBorder="0" width="100%"></iframe>
                <iframe id="autoInfo" class="hidden" border="0" hSrc="${path}/office/autoSet.do?method=autoInfo" frameBorder="0" width="100%"></iframe>
                <iframe id="autoDriver" class="hidden" border="0" hSrc="${path}/office/autoSet.do?method=autoDriver" frameBorder="0" width="100%"></iframe>
                <iframe id="officeTemplate" class="hidden" border="0" hSrc="${path}/office/officeTemplate.do?method=index&officeApp=0" frameBorder="0" width="100%"></iframe>
                <iframe id="autoNoticeSet" class="hidden" border="0" hSrc="${path}/office/autoSet.do?method=autoNoticeSet" frameBorder="0" width="100%"></iframe>
            </div>
        </div>
    </div>
</body>
</html>