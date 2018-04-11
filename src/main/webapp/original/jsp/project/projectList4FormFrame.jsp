<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="projectHeader.jsp"%>
<title><fmt:message key='project.relation.project.label' /></title>
<script type="text/javascript">
function selected(){
	var radio = project4FormFrame.document.getElementsByName("id");
	var dv = window.dialogArguments.extendField;
	for (i=0;i<radio.length;i++){  
		if(radio[i].checked){
			dv.label = radio[i].title;
			dv.value = radio[i].value;
		}  
	}
	window.close();
}
function reset(){
	var dv = window.dialogArguments.extendField;
	dv.label = "";
	dv.value = "";
	window.close();
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="780px" height="580px" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle" colspan="2"><fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}'/>-<fmt:message key='project.relation.project.label' /></td>
	</tr>
	<tr >
		<td class="bg-advance-middel" colspan="2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="relativeDoc padding-5">
						<iframe src="${detailURL}?method=getAllProjectList&isFormRel=${param.isFormRel}" name="project4FormFrame" frameborder="0"  height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="24" align="left" class="bg-advance-bottom">
			<input type="button" onclick="reset()" value="<fmt:message key='common.button.reset.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
		</td>
		<td height="24" align="right" class="bg-advance-bottom">
			<input type="button" onclick="selected()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>