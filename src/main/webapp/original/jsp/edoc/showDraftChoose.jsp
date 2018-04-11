<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="edocHeader.jsp"%> 
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.choice.sending.process'/></title>
<script type="text/javascript">
function ok(){
	/** 打开进度条 */
	//try { getA8Top().startProc(); } catch(e) {}
	var toContinue = document.getElementById("toContinue");
	var redo = document.getElementById("redo");
	if(toContinue && toContinue.checked){
		window.returnValue = "toContinue";
	}else if(redo && redo.checked){
		window.returnValue = "redo";
	}
	window.close();
}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body>
<table align="center" class="popupTitleRight" width="100%" height="100%">
    <tr>
		<td height="20" class="PopupTitle"><fmt:message key='common.pleaseSelect.label'/>
		</td>
	</tr>
    <tr><td class="">
    <table align="center"  width="100%" height="100%">
	<tr>
		<td style="padding:0 12px; height:22px;">
	<table>
		<tr align="left"><td><input type="radio" name="choose" id="toContinue" checked><fmt:message key='edoc.Send.returner'/></td></tr>
		<tr align="left"><td><input type="radio" name="choose" id="redo"><fmt:message key='edoc.original.flow.process'/></td></tr>
	</table>
	</td>
	</tr>
	<td align="right" height="42" class="bg-advance-bottom"  valign="middle" >
	<input type="button" class="button-default_emphasize" value="<fmt:message key='edoc.form.button.ok'/>" onclick="ok()"><input class="button-default-2" type="button" value="<fmt:message key='edoc.form.button.cancel'/>" onclick="javascript:window.close()">
	</td>
	</tr>
</table>
</body>
</html>