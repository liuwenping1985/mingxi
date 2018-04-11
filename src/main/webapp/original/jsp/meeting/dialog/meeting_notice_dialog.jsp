<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html>
<head>

<%@ include file="../../migrate/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
	<fmt:message key='meeting.admin.label.yc1'/>
</title>
<fmt:message key='meeting.mtMeeting.note.input' var="noticeInput" />

<c:set value="${(param.content==null || param.content=='') ? planInput : param.content}" var="content" ></c:set>

<script type="text/javascript">

var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

window.onload = function() {
	var notice = document.getElementById("notice");
	if("${param.isReadOnly}" != "true") {
		
		defaultPlaceholder();
		notice.onfocus = function() {		
			var notice = document.getElementById("notice");
			if(notice.innerHTML == notice.getAttribute("defaultLabel")) {
			    notice.innerHTML = "";
			    notice.style.color = "#000";
			}
		};
		
		notice.onblur = function() {
			defaultPlaceholder();
		};
	} else {
	    notice.setAttribute("disabled", true);
	}
	notice.setAttribute("inputName", "<fmt:message key='mt.mtMeeting.note' />");
}

function defaultPlaceholder(){
	var notice = document.getElementById("notice");
	if(notice.innerHTML == "") {
	    notice.innerHTML = notice.getAttribute("defaultLabel");
	    notice.style.color = "#D1D1D1";
	}
}

function getStrLength(str) {
	var cArr = str.match(/[^\x00-\xff]/ig);
	return str.length + (cArr == null ? 0 : cArr.length);
}

function ok(){
	var notice = document.getElementById("notice");
	var v = notice.value;
	var len = v.length;
	//特殊字符判断
	if(!notSpecChar(notice)){
		return;
	}

	if(len > 200){
		alert("<fmt:message key='mt.meetingNote.input'/>"+len+"<fmt:message key='mt.meetingAgenda.words'/>");
		return;
	}
	
	var view = v;
	var maxlength = 30;
	if(v.length > maxlength){
		view = v.substring(0,maxlength)+"...";
	}
	
	if(parentCallback) {
		parentCallback(v, view);
	} else {
		parentWindow.document.getElementById('notice').value = v;
		//parentWindow.document.getElementById('noticeView').value = view;
	}	
	closeWindow();
}

function closeWindow() {
	commonDialogClose('win123');
}

</script>
</head>
<body scroll='no' style="overflow: hidden;">

<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel" style="padding:26px 15px 12px;">
			<textarea defaultLabel="${noticeInput }" ${param.isReadOnly=='true'?'readOnly':'' } style="height:84%;width: 470px;padding:6px;" cols="90" id="notice" name="notice">${content}</textarea>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<c:if test="${param.isReadOnly!='true'}">
			<input type="button"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize" onclick="ok();" /> &nbsp;
			&nbsp;&nbsp;
			<input type="button" id="cancel" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="javascript:closeWindow();" />
			</c:if>
			<c:if test="${param.isReadOnly=='true'}">
			<input type="button"  value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="javascript:closeWindow();" />
			</c:if>
		</td>
	</tr>
</table>

<script type="text/javascript">
if(${content == noticeInput}){
	document.getElementById("notice").style.color="#d1d1d1";
}
</script>

</body>
</html>