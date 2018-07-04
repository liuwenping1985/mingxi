<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.choice.sending.process'/></title>
<style>
.like-a,.default-a {
    color: #007cd2;
}
.link-blue {
	cursor: pointer;
	text-decoration:none;
}
</style>
<script type="text/javascript">
function OK() {
	return $("input[type='radio']:checked").val();
}
function closeDialog(){
	window.dialogArguments.chooseStepBackDialog.close();
}
</script>
</head>
<body>
<div>
<table align="center" class="popupTitleRight" width="100%" height="100%">
    <tr>
		<td height="20" class="PopupTitle">${ctp:i18n('infosend.label.pleaseSelect')}<!-- 请选择 -->：</td>
	</tr>
	<tr align="left" class="margin_t_20"><td>
		<span class="link-blue" style="font-size:12px;"><input type="radio" name="choose" value="1" id="redo" checked>${ctp:i18n('infosend.label.showLastOption')}<!-- 显示最后一次意见 --></span>
	</td></tr>
	<tr align="left"><td>
	<span class="link-blue" style="font-size:12px;"><input type="radio" name="choose" value="0" id="toContinue">${ctp:i18n('infosend.label.showAllOption')}<!-- 显示全部意见 --></span>
	</td></tr>
</table>
</div>

</body>
</html>