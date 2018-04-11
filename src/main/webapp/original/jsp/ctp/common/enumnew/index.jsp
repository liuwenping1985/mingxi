<%--
 $Author: renhy $
 $Rev: 48960 $
 $Date:: 2015-04-22 17:11:18#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>枚举管理首页</title>
</head>
<body>
	<div id="tabs" class="comp border_r" comp="type:'tab'">
		<c:if test="${adminRoleType == 1}">
		<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F13_systemEnum'"></div>
		</c:if>
		<c:if test="${adminRoleType == 2}">
			<c:if test="${isOrgAdmin == true}">
				<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F13_unitEnum'"></div>
			</c:if>
			<c:if test="${isOrgAdmin == false}">
				<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_enumManager'"></div>
			</c:if>
		</c:if>
		<div id="tabs_head" class="common_tabs clearfix margin_t_5">
			<ul class="left margin_l_10">
				<!-- 系统管理员登录页签 -->
				<c:if test="${adminRoleType == 1}">
					<li class="current"><a hideFocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span title="${ctp:i18n("metadata.manager.public")}">${ctp:i18n("metadata.manager.public")}</span></a></li>
					<li><a  hideFocus="true" href="javascript:void(0)" tgt="tab2_iframe"><span title="${ctp:i18n("metadata.manager.metadataItem")}">${ctp:i18n("metadata.manager.metadataItem")}</span></a></li>
					<li><a  hideFocus="true" href="javascript:void(0)" tgt="tab3_iframe"><span title="${ctp:i18n("metadata.manager.account")}">${ctp:i18n("metadata.manager.account")}</span></a></li>
				</c:if>
				<!-- 单位管理员或表单管理员登录页签 -->
				<c:if test="${adminRoleType == 2}">
					<li class="current"><a  hideFocus="true" href="javascript:void(0)" tgt="tab3_iframe"><span title="${ctp:i18n("metadata.manager.account")}">${ctp:i18n("metadata.manager.account")}</span></a></li>
                    <!-- A6企业版本，不出现图片枚举 -->
                    <c:if test="${ctp:hasPlugin('formAdvanced')}">
                        <li ><a  hideFocus="true" href="javascript:void(0)" tgt="tab4_iframe"><span title="${ctp:i18n("metadata.unitImageEnum.tab.label")}">${ctp:i18n("metadata.unitImageEnum.tab.label")}</span></a></li>
					</c:if>
					<!-- A6企业版本，单位管理员可以看到系统枚举页签 -->
					<c:if test="${isOrgAdmin == true && (productId == 0 || productId == 7)}">
						<li><a hideFocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span title="${ctp:i18n("metadata.manager.public")}">${ctp:i18n("metadata.manager.public")}</span></a></li>
						<li><a  hideFocus="true" href="javascript:void(0)" tgt="tab2_iframe"><span title="${ctp:i18n("metadata.manager.metadataItem")}">${ctp:i18n("metadata.manager.metadataItem")}</span></a></li>
					</c:if>
					<c:if test="${(productId != 0  &&  productId != 7) || isOrgAdmin == false && (productId == 0 || productId == 7)}">
						<li><a hideFocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span title="${ctp:i18n("metadata.manager.public")}">${ctp:i18n("metadata.manager.public")}</span></a></li>
					</c:if>
				</c:if>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body">
			<c:if test="${adminRoleType == 1}">
				<iframe id="tab1_iframe" border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=2" frameBorder="no" width="100%"></iframe>
				<iframe id="tab2_iframe" class="hidden" border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=1" frameBorder="no" width="100%"></iframe>
				<iframe id="tab3_iframe" class="hidden" border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=3" frameBorder="no" width="100%"></iframe>
			</c:if>
			<c:if test="${adminRoleType == 2}">
				<iframe id="tab3_iframe"  border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=3" frameBorder="no" width="100%"></iframe>
                <iframe id="tab4_iframe"  border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=5" frameBorder="no" width="100%"></iframe>
				<c:if test="${isOrgAdmin == true && (productId == 0 || productId == 7)}">
					<iframe id="tab1_iframe" class="hidden"  border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=2" frameBorder="no" width="100%"></iframe>
					<iframe id="tab2_iframe" class="hidden" border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=1" frameBorder="no" width="100%"></iframe>
				</c:if>
				<c:if test="${(productId != 0  &&  productId != 7)  || isOrgAdmin == false && (productId == 0 || productId == 7)}">
					<iframe id="tab1_iframe" class="hidden"  border="0" src="${path}/enum.do?method=enumTemplate&roleType=${adminRoleType}&enumType=2" frameBorder="no" width="100%"></iframe>
				</c:if>
			</c:if>
		</div>
	</div>
</body>
</html>