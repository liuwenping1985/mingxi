<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@include file="../header.jsp"%>
<title><fmt:message key="processLog.list.title.label" bundle="${v3xCommonI18N}"/></title>
</head>
<script type="text/javascript">
<!-- 
	function exportExcel() {
		var searchForm = document.getElementById("searchForm") ;
		var url = "${processLogURL}?method=exportExcelEdoc&processId=${param.processId}";
		searchForm.action = url;
		searchForm.target = "temp_iframe";
		searchForm.submit();
	}
	
	function popprint() {
		var printContentBody = "";
		var cssList = new ArrayList();
		var pl = new ArrayList();
		var contentBody = "" ;
		var contentBodyFrag = "" ;
		
		cssList.add("/seeyon/common/skin/default/skin.css");
		contentBody = window.frames["workflowDetailFrame"].document.getElementById("print").innerHTML;
		contentBodyFrag = new PrintFragment(printContentBody, contentBody);
		pl.add(contentBodyFrag);
		printList(pl,cssList);
	}
//-->
</script>
<body onkeydown="listenerKeyESC()" scroll="no">
<form action="" id="searchForm" method="post">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle" ><fmt:message key="processLog.list.title.label" bundle="${v3xCommonI18N}"/></td>
	</tr>
	<tr>
		<td valign="top" height="26" class="tab-tag" style="border: 0">								
			<div class="div-float-right" style="margin-right: 20px;">
				<table>
					<tr>
						<td>
							<span id="ExcportExcel1Div" title="<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />" style="width: 16px; height: 16px; display: block;" class="download_com cursor-hand" onclick='javascript:exportExcel(1)'></span>			
						</td>
						<td>
							<span id="" class="cursor-hand" onclick='javascript:exportExcel(1)'><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}'  /></span>&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td>
							<span id="printButton1Div" title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="cursor-hand coll_print" style="display: block;" onclick='popprint(1)'></span>
						</td>
						<td>
							<span id="" class="cursor-hand" onclick='popprint(1)'><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></span>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td ><iframe src="${processLogURL}?method=processLogList&processId=${param.processId}" name="workflowDetailFrame" id="workflowDetailFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0" ></iframe></td>
	</tr>
</table>
</form>
<iframe name="temp_iframe" id="temp_iframe" style="display: none;"></iframe>
</body>
</html>