<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="height:100%;">
<head>
<title>个人空间设置</title>
<link rel="stylesheet" href="${path}/decorations/css/skin.css">
<script>
function OK(){
  return $("input[name=layoutFront]:checked").val();
}
</script>
</head>
<body style="height:100%;">
    <!-- 显示模式弹出的布局切换 -->
	<div id="layout-select-front">
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" class="bg_color_white">
	    <tr>
	    <c:forEach items="${allLayout}" var="layoutKeyFront">
	        <td>
	            <fieldset style="padding: 10px 10px ; border: 1px #ffffff solid;">
	            <c:set var = "layoutCssFront" value="decorations.layout.${layoutKeyFront}" />
	            <div style="padding:3px 0px;">${ctp:i18n(layoutCssFront)}</div>
	            <c:set var="coIdFront" value="0"/>
	            <c:forEach items="${layoutTypes[layoutKeyFront]}" var="decoFront">
	                <c:set var="coIdFront" value="${coIdFront+1}"/>
	                <c:set value="${idIndexFront+1}" var="idIndexFront"/>
	                <div style="float:left;cursor: pointer;">
	                <table align="center" border="0" cellspacing="3" cellpadding="3">
	                    <tr>
	                        <td align="center">
	                        <div id="layout-front-img-${idIndexFront}" class="layout-img-${decoFront}" style="margin-left: 5px"></div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td nowrap align="center" class="padding_t_5"><label for="layout-front-${idIndexFront}"><input type="radio" id="layout-front-${idIndexFront}" name="layoutFront" value="${decoFront}" ${decoFront==decorationId ? 'checked' : '' } ${isDisabledStr}/>${ctp:i18n('channel.logo.version.label')}${idIndexFront}</label></td>
	                    </tr>
	                </table>
	                </div>
	            </c:forEach>
	            </fieldset>
	        </td>
	        <td width="5%">&nbsp;</td>
	    </c:forEach>
	    </tr>
	</table>
	</div>
<!-- 显示模式弹出的布局切换结束 -->
</body>
</html>