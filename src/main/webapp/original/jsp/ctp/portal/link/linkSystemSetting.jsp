<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n('calendar.event.list.title')}</title>
<style>
.stadic_head_height {
	height: 30px;
}

.stadic_body_top_bottom {
	bottom: 0px;
	top: 30px;
}
#tabs_head{
	background:#fafafa;
}
</style>
</head>
<body class="h100b over_hidden page_color">
	<c:if test="${isKnowledge == 'true'}">
	<div class="comp" comp="type:'breadcrumb',code:'T03_linkSystemUser'"></div>
		<div id="center" class="h100b">
			<DIV id=tabs class=comp
				comp="type:'tab',parentId:'center',refreashTab:true">
				<DIV id=tabs_head class="common_tabs clearfix">
					<UL class=left>
						<LI class=current><A hideFocus style="WIDTH: auto"
							href="javascript:void(0)" class=" border_b" tgt="tab1_iframe"
							id="tab1_iframe_a"><SPAN>${ctp:i18n("link.category.personal")}</SPAN></A></LI>
						<LI><A id="tab2_iframe_a" hideFocus style="WIDTH: auto;"
							href="javascript:void(0)" tgt="tab2_iframe" class=" border_b"><SPAN>${ctp:i18n("link.category.system")}</SPAN></A>
						</LI>
					</UL>
				</DIV>
				<DIV id="tabs_body" class="common_tabs_body border_t">
					<c:if test="${isKnowledge == 'true'}">
						<iframe id="tab1_iframe"
							src="${path}/portal/linkSystemController.do?method=linkSystemMain&isAdmin=false"
							border="0" frameborder="no" width="100%"></iframe>
						<iframe id="tab2_iframe"
							src="${path}/portal/linkSystemController.do?method=userLinkSetting&isKnowledge=true"
							border="0" class="hidden" frameborder="no" width="100%"></iframe>
					</c:if>
				</DIV>
			</DIV>
		</div>
	</c:if>
	<c:if test="${isKnowledge != 'true'}">
		<iframe id="current" style="height:100%"
			src="${path}/portal/linkSystemController.do?method=userLinkSetting"
			border="0" frameborder="no" width="100%"></iframe>
	</c:if>
</body>
</html>

