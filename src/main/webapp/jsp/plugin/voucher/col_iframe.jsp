<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_10104_voucherGenerateIndex'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe"><span title="${ctp:i18n('voucher.plugin.generate.untreated')}">${ctp:i18n('voucher.plugin.generate.untreated')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe"><span title="${ctp:i18n('voucher.plugin.generate.treated')}">${ctp:i18n('voucher.plugin.generate.treated')}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" src="${path}/voucher/voucherController.do?method=listCol" frameborder="no"
				border="0"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%"
				src="${path}/voucher/voucherController.do?method=listDoneCol" frameborder="no" border="0"
				class="hidden"></iframe>
		</div>
    </div>
	</div>
</body>
</html>