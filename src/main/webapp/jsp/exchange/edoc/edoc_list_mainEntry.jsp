<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../exchangeHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
onLoadLeft();
</script>
</head>
<body style="overflow: hidden;background:#EDEDED;" scroll="no" class="padding5" onunload="unLoadLeft()">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr id="tabTr" style="display:none">
<td valign="bottom" height="26" class="tab-tag">

<div class="tab-separator"></div>

<%--公文交换——待发送 --%>
<span class="resCode" resCode="F07_exWaitSend" resCodeParent="F07_edocExchange" current="${modelType=='toSend'?'true':'false'}">
	<div class="${modelType=='toSend'?'tab-tag-left-sel':'tab-tag-left'}"></div>
	<div class="${modelType=='toSend'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='exchangeEdoc.do?method=listMainEntry&modelType=toSend&from=toSend&listType=listExchangeToSend' />'">
		<fmt:message key='common.toolbar.presend.label' bundle='${v3xCommonI18N}' />
	</div>
	<div class="${modelType=='toSend'?'tab-tag-right-sel':'tab-tag-right'}"></div>
	<div class="tab-separator"></div>	
</span>

<%--公文交换——待签收 --%>
<span class="resCode" resCode="F07_exToReceive" resCodeParent="F07_edocExchange" current="${modelType=='toReceive'?'true':'false'}">
	<div class="${modelType=='toReceive'?'tab-tag-left-sel':'tab-tag-left'}"></div>
	<div class="${modelType=='toReceive'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='exchangeEdoc.do?method=listMainEntry&modelType=toReceive&from=toReceive&listType=listExchangeToRecieve' />'">
		<fmt:message key='common.toolbar.presign.label' bundle='${v3xCommonI18N}' />
	</div>
	<div class="${modelType=='toReceive'?'tab-tag-right-sel':'tab-tag-right'}"></div>
	<div class="tab-separator"></div>	
</span>

<%--公文交换——已发送 --%>
<span class="resCode" resCode="F07_exSent" resCodeParent="F07_edocExchange" current="${modelType=='sent'?'true':'false'}">
	<div class="${modelType=='sent'?'tab-tag-left-sel':'tab-tag-left'}"></div>
	<div class="${modelType=='sent'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='exchangeEdoc.do?method=listMainEntry&modelType=sent&from=sent&listType=listExchangeSent' />'">
		<fmt:message key='common.toolbar.sent.label' bundle='${v3xCommonI18N}' />
	</div>
	<div class="${modelType=='sent'?'tab-tag-right-sel':'tab-tag-right'}"></div>
	<div class="tab-separator"></div>	
</span>

<%--公文交换——已签收 --%>
<span class="resCode" resCode="F07_exReceived" resCodeParent="F07_edocExchange" current="${modelType=='received'?'true':'false'}">
	<div class="${modelType=='received'?'tab-tag-left-sel':'tab-tag-left'}"></div>
	<div class="${modelType=='received'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='exchangeEdoc.do?method=listMainEntry&modelType=received&from=received&listType=listExchangeReceived' />'">
		<fmt:message key='common.toolbar.sign.label' bundle='${v3xCommonI18N}' />
	</div>
	<div class="${modelType=='received'?'tab-tag-right-sel':'tab-tag-right'}"></div>
	<div class="tab-separator"></div>	
</span>

<%-- 权限控制  --%>
<%@ include file="/WEB-INF/jsp/migrate/checkResource.jsp" %>
<%-- 当前位置 --%>
<%@ include file="../../edoc/currentLocation.jsp" %>

</td>
</tr>

<tr class="border_b">
<td valign="top" width="100%" height="100%" align="center" class="page-list-border-LRD" style="padding-top:1px;">
<iframe frameborder="no" scrolling="no" src="${exchange}?method=listMain&modelType=${modelType}&listType=${listType }" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>
</td>
</tr>
</table>

</body>
</html>
