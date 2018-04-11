<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.seeyon.ctp.util.ListSearchHelper" %>
<%
	String expressionValue = request.getParameter("expressionValue");
	expressionValue = ListSearchHelper.encodeBase64(expressionValue);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<title><fmt:message key="ntp.org.synchron.log.detail"/></title>
</head>
<body onkeydown="listenerKeyESC()" scroll="no" onresize="flush();">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<tr>
	<td height="25" class="webfx-menu-bar-gray">
		<div class="div-float-right" style="position:absolute;top:5px;right:0px">
		<jsp:include page="../../common/listSearch.jsp">
		<jsp:param name="expressionType" value="${param.expressionType}"/>
		<jsp:param name="expressionValueBase64" value="<%=expressionValue%>"/>
		<jsp:param name="windowToLoad" value="window"/>
		<jsp:param name="expressionTypes" value="option:sap.org.synchLog.option:freeText;data:sap.org.synchLog.data:freeText;desc:sap.org.synchLog.desc:freeText"/>
		</jsp:include>
	</td>
</tr>
<tr height="100%"><td>
<div class="scrollList" id="scrollListDiv">
	<form name="listForm" target="_self" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
		<v3x:table data="detailList" var="detail" className="sort ellipsis">
			<v3x:column width="15%" type="String" label="ntp.org.synchLog.option" className="sort" alt="${detail.action}">
				${v3x:toHTML(detail.action)}
			</v3x:column>
			<v3x:column width="40%" type="String" label="ntp.org.synchLog.data" className="sort" alt="${detail.data}">
				${v3x:toHTML(detail.data)}
			</v3x:column>
			<v3x:column width="45%" type="String" label="ntp.org.synchLog.desc" className="sort" alt="${detail.memo}">
				${v3x:toHTML(detail.memo)}
			</v3x:column>
		</v3x:table>
	</form>
</div>
</td></tr>
</table>
</body>
</html>
<script>
	//设置数据显示div的px高度
	/* initIe10AutoScroll("scrollListDiv",30); */
	//清空查询数据
	var expressionType = document.getElementById("expressionType");
	//expressionType.attachEvent('onchange',editInput);
	function editInput(){
		var freeText = document.getElementsByName("freeText")[0];
		freeText.value = "";
	}
	function flush(){
		location.reload();
	}
</script>