<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<%@ include file="header.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="common.prompt" bundle="${v3xCommonI18N}" /></title>
</head>
<script type="text/javascript">
<!--
	function ok() {
		var form = document.getElementById("submitData") ;
		var noAlert = document.getElementById("noAlert") ;
		if (noAlert.checked) {
			form.action="/seeyon/agent.do?method=agentNoAlert&ids=${param.ids}";
			form.target="temp_iframe";
			form.submit();
		}else{
			window.parentDialogObj['dialogAgent'].close();
		}
	}
//-->
</script>

<body scroll="no" onkeydown="listenerKeyESC()">
<form id="submitData" action="" method="post">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" width="70px">
			<img align="middle" src="/seeyon/common/images/warring.gif" border="0">
		</td>
		<td>
			<div class="scrollList" style="text-align: left;overflow-x: hidden;height: 150px;">
				<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" >
					<tr>
						<td style="padding: 5px;">${v3x:toHTML(param.message)}</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="30" colspan="2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" class="bg-advance-bottom" nowrap="nowrap">
						<label for="noAlert" style="color: white;padding-left: 30px;">
							<input type="checkbox" value="T" id="noAlert" />
							<fmt:message key="commom.next.stop.prompt" bundle="${v3xCommonI18N}" />
						</label>
						
					</td>
					<td align="right" class="bg-advance-bottom">
						<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="ok()" class="button-default_emphasize">&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe name="temp_iframe" id="temp_iframe" style="display:none;">&nbsp;</iframe>
</body>
</html>