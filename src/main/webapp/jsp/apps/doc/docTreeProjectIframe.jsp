<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="docHeader.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.tree.move.title'/></title>

</head>
<body bgColor="#f6f6f6" scroll="no">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle"><fmt:message key='doc.tree.move.pigeonhole.project'/></td>
		</tr>
		<tr>
			<td valign="top">
				<iframe src="${detailURL}?method=listProjectRoots&projectId=${param.projectId}&appName=${param.appName}&ids=${param.ids}" width="100%" height="100%" frameborder="0" name="treeProjectFrame" id="treeMoveFrame" marginheight="0" marginwidth="0" scrolling="yes">
				</iframe>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" onclick="treeProjectFrame.moveGo();" name="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		
	</table>
</body>
</html>