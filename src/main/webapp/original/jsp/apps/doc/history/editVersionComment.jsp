<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<%@ include file="../docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.editversioncomment'/></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docVersion.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
function initLoadComment() {
	var oldComment = transParams.parentWin.document.getElementById("versionCommentDiv_" + '${param.docVersionId}').title;
	document.getElementById("oldComment").value = oldComment;
	document.getElementById("comment").value = oldComment;
}
function returnBack() {
	if(!checkForm(document.getElementById("mainForm")))
		return false;
	document.getElementById("b1").disabled = true;
	document.getElementById("b2").disabled = true;
	
	var newComment = document.getElementById("comment").value;
	var oldComment = document.getElementById("oldComment").value;
	var returnValue = "";
	if(newComment == oldComment) {
		returnValue = ['false', ''];
	}
	else {
		returnValue = ['true', newComment];
	}
	transParams.parentWin.editCommentCollBack(returnValue);
}
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyESC()" onload="initLoadComment()">
<form name="mainForm" id="mainForm" method="post">
	<input type="hidden" name="oldComment" id="oldComment" />
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle"><fmt:message key='doc.menu.history.note.label'/></td>
		</tr>

		<tr>
			<td class="bg-advance-middel">
				<textarea id="comment" name="comment" cols="" rows="" style="width:100%; height: 80%" inputName="<fmt:message key='doc.menu.history.note.label'/>" validate="notNull,maxLength" maxSize="300"></textarea>
				<div style="color: green">
					<fmt:message key="guestbook.content.help" bundle="${v3xMainI18N}" >
						<fmt:param value="300"  />
					</fmt:message>
				</div>
			</td>
		</tr>

		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input id="b1" name='b1' type="button" onclick="returnBack();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize">&nbsp;
				<input id="b2" name='b2' type="button" onclick="getA8Top().docEditCommentWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
</body>
</html>