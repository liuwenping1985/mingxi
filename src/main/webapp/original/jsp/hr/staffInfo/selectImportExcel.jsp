<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../../organization/organizationHeader.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<title><fmt:message key="import.local.excel" /></title>
<script type="text/javascript">
	function listenerKeyPress(){
		if(event.keyCode == 27){
			window.close();
		}
	}
	
	function returnURL(){
		//文件名后缀
		var fileURL = document.getElementById('file1').value;
		var filePostfix = fileURL.substring(fileURL.lastIndexOf('.')+1);
		if(filePostfix!=""&&filePostfix!='xls'){
			alert(v3x.getMessage("HRLang.hr_staffInfo_file_error_choose_excel"));
			return;
		}
		if(document.getElementById('file1').value!=""&&document.getElementById('file1').value.length!=0){
			var repeatItems = document.getElementsByName('repeat');
			var repeat = "";
			if(repeatItems[0].checked){
				repeat = repeatItems[0].value;
			}else{
				repeat = repeatItems[1].value;
			}
			var language = document.all.language.value;
			window.returnValue = document.getElementById('file1').value+"|"+repeat+"#"+language;
			window.close();
		}else{
			alert(v3x.getMessage("HRLang.hr_staffInfo_choose_import_file"));
		}
	}
	
	function initLanguage(){
		var language = "${v3x:getLanguage(pageContext.request)}";
		var sel = document.all.language;
		if(language == 'zh-cn'){
			sel.options[0].selected = true;
		}else if(language == 'en'){
			sel.options[1].selected = true;
		}
	}
</script>
<style>
<!--
MARQUEE {
	BACKGROUND: window; BORDER-BOTTOM: buttonshadow 1px solid; BORDER-LEFT: buttonshadow 1px solid; BORDER-RIGHT: buttonshadow 1px solid; BORDER-TOP: buttonshadow 1px solid; DISPLAY: block; FONT-SIZE: 1px; HEIGHT: 12px; MARGIN: 1px; OVERFLOW: hidden; WIDTH: 147px; moz-binding: url("marquee-binding.xml#marquee"); moz-box-sizing: border-box
}
MARQUEE SPAN {
	BACKGROUND: highlight; FLOAT: left; FONT-SIZE: 1px; HEIGHT: 8px; MARGIN: 1px; WIDTH: 6px
}
.progressBarHandle-0 {
	FILTER: alpha(opacity=20); moz-opacity: 0.20
}
.progressBarHandle-1 {
	FILTER: alpha(opacity=40); moz-opacity: 0.40
}
.progressBarHandle-2 {
	FILTER: alpha(opacity=60); moz-opacity: 0.6
}
.progressBarHandle-3 {
	FILTER: alpha(opacity=80); moz-opacity: 0.8
}
.progressBarHandle-4 {
	FILTER: alpha(opacity=100); moz-opacity: 1
}
//-->
</style>
</head>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyPress()">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle">
				<c:choose>
					<c:when test="${importType == 'level' }">
						<fmt:message key="import.level"/>
					</c:when>
					<c:when test="${importType == 'post' }">
						<fmt:message key="import.post"/>
					</c:when>
					<c:when test="${importType == 'member' }">
						<fmt:message key="import.member"/>
					</c:when>
					<c:when test="${importType == 'dept' }">
						<fmt:message key="import.dept"/>
					</c:when>
					<c:when test="${importType == 'team' }">
						<fmt:message key="import.team"/>
					</c:when>
					<c:when test="${importType == 'account' }">
						<fmt:message key="import.account"/>
					</c:when>
					<c:when test="${importType == 'organization' }">
						<fmt:message key="org.button.imp.label"/><fmt:message key="import.type.organization"/>
					</c:when>
				</c:choose>
			</td>
		</tr>
		<tr>
			<td id="upload1" class="bg-advance-middel">
			<div><fmt:message key="import.choose.file" /></div>
			<INPUT type="file" name="file1" id="file1" style="width: 100%"></td>
		</tr>
		<tr>
			<td height="30" align="left" style="padding-left: 15px">
				<fmt:message key="import.choose.language"/>:&nbsp;
				<c:set var="currentLocale" value="${v3x:getLocale(pageContext.request)}" />
				<select name="language">
				    <c:forEach var="l" items="${v3x:getAllLocales()}">
				        <option value="${l}" ${currentLocale == l ? "selected" : ""}><fmt:message key="localeselector.locale.${l}" bundle="${locale }"/></option>
				    </c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td height="30" align="left" style="padding-left: 15px">
				<fmt:message key="import.option"/>:&nbsp;
				<label for="overcast">
					<input type="radio" name="repeat" value="0" checked="checked" id="overcast">
					<fmt:message key="import.repeatitem.overcast"/>&nbsp;&nbsp;
				</label>
				<label for="overleap">
					<input type="radio" name="repeat" value="1" id="overleap">
					<fmt:message key="import.repeatitem.overleap"/>
				</label>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" name="b1" onclick="returnURL()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input type="button" name="b2" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</body>
</html>