<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style type="text/css">
.aboutBg {
	background: url("${path}/skin/default/images/about_bg${ctp:getSystemProperty('system.ProductId')}${ctp:getSystemProperty('portal.about')}.png${v3x:resSuffix()}") no-repeat #ededed;
}
</style>
<title>${ctp:i18n("product.about.title")}</title>
</head>
<body style="overflow: hidden; background: #ededed" scroll="no" onkeydown="listenerKeyESC()">
<table width="504" height="303" border="0" cellspacing="0" cellpadding="0" class="aboutBg font_size12">
	<tr>
		<td height="182">
		<table cellpadding="0" cellspacing="5" border="0" width="100%" class="font_size12">
			<tr>
				<td height="80" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="25%" align="right" height="20">${ctp:i18n("product.version.label")}:</td>
				<td width="75%">&nbsp;${productVersion}</td>
			</tr>
			<tr>
				<td align="right" height="20">${ctp:i18n("product.category") }:</td>
				<td>&nbsp;${ctp:i18n(productCategory)}</td>
			</tr>
			<tr>
				<c:set value="product.maxOnline.label.${ctp:getSystemProperty('system.ProductId')}" var="maxOnlineLabel" />
				<c:set value="product.maxOnline.label${serverType}" var="extendLabel"></c:set>
				<c:choose>
					<c:when test="${ctp:getSystemProperty('portal.about') == 'U8' }">
						<td align="right" height="20">${ctp:i18n(extendLabel)}:</td>
					</c:when>
					<c:when test="${ctp:getSystemProperty('portal.about') == 'NC' }">
						<td align="right" height="20">${ctp:i18n(extendLabel)}:</td>
					</c:when>
					<c:otherwise>
						<td align="right" height="20">${ctp:i18n(maxOnlineLabel)}${ctp:i18n(extendLabel)}:</td>
					</c:otherwise>
				</c:choose>
				<td>&nbsp;${maxOnline}</td>
			</tr>
			<c:if test="${m1MaxOnline > 0}">
				<tr>
				    <c:set value="product.maxOnline.label${m1ServerType}" var="extendM1Label"></c:set>
					<td align="right" height="20">${ctp:i18n("product.maxOnline.M1.label")}${ctp:i18n(extendM1Label)}:</td>
					<td>&nbsp;${m1MaxOnline}</td>
				</tr>
			</c:if>
			<tr>
				<td align="right" height="20">Build Id:</td>
				<td>&nbsp;${buildId}</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="38" colspan="2" align="center" class="lest-shadow">${ctp:i18n_1("product.copyright", releaseYear)}</td>
	</tr>
</table>
</body>
</html>