<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="caaccountHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">

<title><fmt:message key="import.report"/></title>
<script type="text/javascript">
getDetailPageBreak();
	function exportReport(){
	//v3x.openWindow({
	//			url		: organizationURL+'?method=exportReport',
	//			width	: 600,
	//			height	: 530,
	//			resizable	: "yes"
	//		});	
	//document.hidden_iframe.location.href="${organizationURL}?method=exportReport";		//tanglh
	hidden_iframe.location.href = "<c:url value='/organization.do?method=exportReport' />";
	//document.sendMessageFrame.location.href		
	//window.close();
	}
	
	function closeReport(){
		//var form = document.getElementById("datamatch");
		//form.action="${organizationURL}?method=closeWin";
		//form.submit();
		//window.close();
	}
	//<form id="datamatch" method="post" onSubmit="" name="datamatch"  target="listFrame">
</script>
</head>
<body bgColor="#f6f6f6" scroll="no">
<table width="100%" height="100%" border="0" align="center"><tr><td height="122">
	<form id="datamatch" method="post" onSubmit="" name="datamatch"  >
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr valign="top" height="20">
			<td colspan="3">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td height="20" colspan="3" class="PopupTitleImport">
							<fmt:message key="import.report"/>—
							<fmt:message key="import.caaccount"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td height="20" style="padding-left: 20px">
				<fmt:message key="import.filename"/>:
			</td>
			<td colspan="2">
				<c:out value="${impURL}"/>
			</td>
		</tr>		
		
		<tr>
			<td height="20" style="padding-left: 20px;border-bottom: #cec6b5 1px solid">
				<fmt:message key="import.option"/>:
			</td>
			<td colspan="2" style="border-bottom: #cec6b5 1px solid">
				<c:choose>
					<c:when test="${repeat == '0'}">
						<fmt:message key="import.repeatitem.overcast"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="import.repeatitem.overleap"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom" colspan="3">
			<!--
				<input id="submintButton" type="button" name="b1" onclick="exportReport()" 
				          value="<fmt:message key="org.button.exp.label"/><fmt:message key="import.result"/>" class="button-default-2">&nbsp;
			 -->
						  <!--
				<input id="submintCancel" type="button" name="b2" onclick="closeReport()"
				                 value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
								 -->
			</td>
		</tr>
	</table>
	</form>
</td></tr><tr><td>
	<div class="scrollList">
		<form id="resulttable" method="post">
	<table width="98%" height="100%" border="1" align="center" ><tr><td>
			<v3x:table htmlId="resultlst" data="webImportCAAccountResultVoList" var="data" showPager="false">
					<v3x:column width="20%" align="left" label="ca.loginName.label" type="String"
							value="${data.loginName}" className="cursor-hand sort"
							maxLength="25"  symbol="..." alt="${data.loginName}" />
					<v3x:column width="20%" align="left" label="ca.keyNum.label" type="String"
							value="${data.keyNum}" className="cursor-hand sort"
							maxLength="25"  symbol="..." alt="${data.keyNum}" />		
					<v3x:column width="20%" align="center" label="import.result" type="String"
							value="${data.result}" className="cursor-hand sort"
							maxLength="20"  symbol="..." alt="${data.result}" />
		</v3x:table>
		</td></tr></table></form></div>
</td></tr><tr><td height="10">&nbsp;</td></tr></table>
	<iframe name="hidden_iframe" style="display:none"></iframe>
</body>
</html>