<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文档密级</title>
<script type="text/javascript">
var currentSecretLevel = "${currentSecretLevel}";
function OK(){
	var docResId = document.getElementById("docResId").value;
	var docResId = document.getElementById("secretLevel").value;
	var form = document.getElementById("mainForm");
	form.action = detailURL+"?method=changeDocSecretLevel&docResId="+docResId+"&secretLevel="+secretLevel;
	form.submit();
}
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" style="overflow:hidden;" onkeydown="listenerKeyESC()" onunload="unlockAfterAction('${param.rowid}');">
<form name="mainForm" id="mainForm" action="${detailURL}?method=changeDocSecretLevel"
	  method="post" target="renameIframe">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle" align="center"><fmt:message key='secret.doc.set.label'/></td>
		</tr>

		<tr>
			<td class="bg-advance-middel" align="center">
				<div>
					<fmt:message key='secret.doc.secretLevel'/>:
				</div>
				<input type="hidden" name="docResId" value="${docResId}" >
				<select name="secretLevel" id="secretLevel" style="width:90px">
					<option value="">  </option>
		    		<c:forEach items="${secretLevelList }" var="item" varStatus="status">
						<option value="${item.value }"<c:if test="${item.value == currentSecretLevel}" > selected="selected"</c:if>>${item.label }</option>
					</c:forEach>
   				</select>
			</td>
		</tr>
		<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
		<tr>
			<td height="42" align="center" class="bg-advance-bottom">
				<input name='b1' type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default-2">&nbsp;
				<input name='b2' type="button" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		</c:if>
	</table>

	<table cellSpacing=0 cellPadding=0 align=center>
		<tbody>
			<tr>
				<td height="100"></td>
			</tr>
		</tbody>
	</table>
</form>
<iframe name="renameIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>