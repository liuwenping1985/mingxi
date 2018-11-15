
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>表单升级</title>
<script type="text/javascript">
function toUpgrade(){
	if(formUpgradeFrame.document.getElementById("upgradeForm")){
		$.progressBar();
		formUpgradeFrame.document.getElementById("upgradeForm").submit();
		document.getElementById("b1").disabled=true;
	}
}
</script>
</head>

<body bgColor="#f6f6f6" scroll="no" >
	<table class="popupTitleRight" width="100%" height="600px" border="1" cellspacing="0" cellpadding="0">
	<tr height="90%">
			<td valign="top">
				<iframe src="${path}/form/formUpgrade.do?method=toUpgrade" width="100%" height="100%" frameborder="0" name="formUpgradeFrame" id="formUpgradeFrame" marginheight="0" marginwidth="0" scrolling="auto">
				</iframe>
			</td>
		</tr>
		<tr>
            <td height="42" align="center" class="bg-advance-bottom">
            
				<c:if test="${viewUpgrade}">
				<input type="button" onclick="toUpgrade()" name="b1" id="b1" value="${ctp:i18n('common.button.ok.label')}" class="button-default-2">&nbsp;
				</c:if>
				<input type="button" name="b2" id="b2" onclick="window.close();"  value="${ctp:i18n('common.button.cancel.label')}" class="button-default-2">
			</td>
		</tr>
	</table>
</body>
</html>