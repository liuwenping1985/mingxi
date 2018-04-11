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
<fmt:message key='meeting.mtMeeting.plan.input' var="planInput" />

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
	var plan = document.getElementById("plan");
	if("${param.isReadOnly}" != "true") {
		

		plan.onfocus = function() {		
			var plan = document.getElementById("plan");
			if(plan.innerHTML == plan.getAttribute("defaultLabel")) {
				plan.innerHTML = "";
				plan.style.color = "#000";
			}
		};
		
		plan.onblur = function() {
			var plan = document.getElementById("plan");
			if(plan.innerHTML == "") {
				plan.innerHTML = plan.getAttribute("defaultLabel");
				plan.style.color = "#D1D1D1";
			}
		};
	} else {
		plan.setAttribute("disabled", true);
	}
	plan.setAttribute("inputName", "<fmt:message key='meeting.mtMeeting.plan' />");
	
	//plan.onfocus();
}

function getStrLength(str) {
	var cArr = str.match(/[^\x00-\xff]/ig);
	return str.length + (cArr == null ? 0 : cArr.length);
}

function ok(){
	var plan = document.getElementById("plan");
	var v = plan.value;
	var len = v.length;
	//特殊字符判断
	if(!notSpecChar(plan)){
		return;
	}

	if(len > 200){
		alert("<fmt:message key='mt.meetingAgenda.input'/>"+len+"<fmt:message key='mt.meetingAgenda.words'/>");
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
		parentWindow.document.getElementById('plan').value = v;
		//parentWindow.document.getElementById('planView').value = view;
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
			<textarea defaultLabel="${planInput }" ${param.isReadOnly=='true'?'readOnly':'' } style="height:84%;width: 470px;padding:6px;" cols="90" id="plan" name="plan">${content}</textarea>
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
if(${content == planInput}){
	document.getElementById("plan").style.color="#d1d1d1";
}
</script>

</body>
</html>