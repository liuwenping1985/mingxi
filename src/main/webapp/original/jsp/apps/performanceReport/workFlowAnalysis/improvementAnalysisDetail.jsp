<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="common.efficiency.analysis.label" bundle='${v3xMainI18N}' /></title>
</head>
<script type="text/javascript">
<!-- 
	function exportExcel() {
		parent.exportExcelWorkflowStat();
	}
	
	function popprint() {
		var printContentBody = "";
		var cssList = new ArrayList();
		var pl = new ArrayList();
		var contentBody = "" ;
		var contentBodyFrag = "" ;
		
		contentBody = document.getElementById("print").innerHTML;
		contentBodyFrag = new PrintFragment(printContentBody, contentBody);
		pl.add(contentBodyFrag);
		
		cssList.add("/seeyon/common/skin/default/skin.css");
		
		printList(pl,cssList);
	}
//-->
</script>
<body scroll="no" onkeydown="listenerKeyESC()">
<form action="">
<table class="popupTitleRight" width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr>
<td class="PopupTitle">
	这里应该写标题
</td>
</tr>
<tr height="26px;">
	<td>
		<div class="div-float-right" style="margin-right: 20px; display: block;" >
			<table>
				<tr>
					<td>
						<span id="viewWorkflow" title="<fmt:message key='common.view.the.processflow.label' />" style="width: 16px; height: 16px; display: block;" class="download_com cursor-hand margin_r_5" onclick='javascript:exportExcel()'></span>			
					</td>
					<td>
						<a onclick="exportExcel()"><fmt:message key='common.view.the.processflow.label' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<span id="ExcportExcel1Div" title="<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />" style="width: 16px; height: 16px; display: block;" class="download_com cursor-hand margin_r_5" onclick='javascript:exportExcel()'></span>			
					</td>
					<td>
						<a onclick="exportExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<span id="printButton1Div" title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="ico16 print_16 margin_r_5" style="display: block;" onclick='popprint()'></span>
					</td>
					<td>
						<a onclick="popprint()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>
<tr>
<td>
<div id="print" class="scrollList">
<v3x:table data="results" var="result" width="100%" dragable="false">
	<v3x:column width="10%" align="left" type="String" label="common.deal.people.label" value="${appType}"></v3x:column>
	<v3x:column width="10%" align="left" type="String" label="common.node.access.label" value="${v3x:showMemberName(result[1])}"></v3x:column>
	<v3x:column width="10%" align="left" type="String" label="common.processing.status.label" value="${v3x:showMemberName(result[1])}"></v3x:column>
	<v3x:column width="16%" align="left" type="String" label="common.initate.or.receive.time.label" value="${result[2] }" maxLength="36"></v3x:column>
	<fmt:formatDate value="${result[3]}" type="both" dateStyle="full" pattern="yyyy-MM-dd hh:mm" var="createTime"/>
	<v3x:column width="16%" align="left" type="String" label="common.processing.time.label" alt="${createTime}" maxLength="10">
		${createTime }
	</v3x:column>
	<v3x:column width="13%" align="left" type="String" label="common.handling.time.label" value="" />
	<v3x:column width="12%" align="left" type="String" label="common.processing.period.label" value="" />
	<v3x:column width="13%" align="left" type="String" label="common.timeouts.label" value="" />
</v3x:table>
</div>
</td>
</tr>
</table>
</form>
<br>
<iframe name="temp_iframe" id="temp_iframe" style="display: none;">&nbsp;</iframe>
</body>
</html>