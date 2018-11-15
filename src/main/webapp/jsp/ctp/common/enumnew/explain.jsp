<%--
 $Author: dengxj $
 $Rev: 21924 $
 $Date:: 2013-05-08 21:12:23#$:
  
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
<title>说明页面</title>
</head>
<body scrolling="no">
	<div class="color_gray margin_l_20">
		<div class="clearfix margin_t_20 margin_b_10">
			<h2 class="left margin_0">
			<c:if test="${enumType == 1}">${ctp:i18n("metadata.manager.system")}</c:if>
			<c:if test="${enumType == 2}">${ctp:i18n("metadata.manager.public")}</c:if>
			<c:if test="${enumType == 3}">${ctp:i18n("metadata.manager.account")}</c:if>
			</h2>
			<div class="font_size12 left margin_l_10">
				<div class="margin_t_10 font_size14">
					  ${ctp:i18n("form.helpinfo.total")} <span class="font_bold color_black" id="totalNum">${total}</span>  ${ctp:i18n("formsection.infocenter.num")}
				</div>
			</div>
		</div>
		<div class="font_size14" style="line-height: 120%;">
		<c:if test="${enumType == 1 || enumType == 2}">
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.one.label")}
			</p>
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.two.label")}
			</p>
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.three.label")}
			</p>
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.four.label")}
			</p>
			</c:if>
			<c:if test="${enumType == 3}">
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.five.label")}
			</p>
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.six.label")}
			</p>
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.seven.label")}
			</p>
			<p>
				<span class="font_size12">●</span> ${ctp:i18n("metadata.detail.explain.eight.label")}
			</p>
			</c:if>
		</div>
	</div>
</body>
</html>
