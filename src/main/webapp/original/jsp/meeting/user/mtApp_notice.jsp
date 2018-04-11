<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html:link renderURL='/meetingroom.do' var='mrUrl' />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="../../migrate/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>
	<c:choose>
		<c:when test="${param.disabled eq 'disabled'}">
			<fmt:message key='admin.label.zysx1'/>
		</c:when>
		<c:otherwise>
			<fmt:message key='admin.label.zysx'/>
		</c:otherwise>
	</c:choose>
	</title>
<fmt:message key='meeting.mtMeeting.note.input' var="noteInput" />
<c:set value="${content == null ? noteInput : content}" var="content" ></c:set>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
$(document).ready(function() {
	//document.getElementById("cancel").focus();
	//document.getElementById("cancel").focus();
	//$("#notice").bind("focus",function(){alert(22);});
});

function mfocus(){alert(1);
	//$("#notice").text("");
}
function mblur(){

}

function getStrLength(str) {
	var cArr = str.match(/[^\x00-\xff]/ig);
	return str.length + (cArr == null ? 0 : cArr.length);
}

function save(){
	var notice = document.getElementById("notice");
	var v = notice.value;
	//var len = getStrLength(v);
	var len = v.length;

	//特殊字符判断
	if(!notSpecChar(notice)){
		return;
	}

	if(len > 200){
		alert("<fmt:message key='mt.meetingNote.input'/>"+len+"<fmt:message key='mt.meetingNote.words'/>");
		return;
	}

	var maxlength = 30;
	var view = v;
	if(v.length > maxlength){
		view = v.substring(0,maxlength)+"...";
	}
	var initW = null; //获得父窗口对象
	if(typeof(transParams)!="undefined"){
		initW = transParams.parentWin;
	}else{
		initW = dialogArguments;
	}
	initW.document.getElementById('notice').value = v;
	initW.document.getElementById('noticeView').value = view;
	commonDialogClose('win123');
}
</script>
</head>
<body scroll='no' style="overflow: hidden;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel" style="padding:26px 15px 12px;">
			<textarea  <c:if test="${param.disabled ne 'disabled'}"> onfocus="if(this.innerHTML=='${noteInput}'){this.innerHTML='';this.style.color='#000'}" onblur="if(this.innerHTML==''){this.innerHTML='${noteInput}';this.style.color='#D1D1D1'}"</c:if>  style="height:84%; width: 470px;padding:6px;" cols="90" id="notice" name="notice" <c:if test="${param.disabled=='disabled'}">disabled="disabled"</c:if> inputName="<fmt:message key='mt.mtMeeting.note' />">${content}</textarea>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<c:if test="${empty param.type }">
			<input type="button"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize" onclick="save();" /> &nbsp;
			&nbsp;&nbsp;
			<input type="button" id="cancel" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="javascript:commonDialogClose('win123');" />
			</c:if>
			<c:if test="${param.type == 'view'}">
			<input type="button"  value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="javascript:commonDialogClose('win123');" />
			</c:if>
		</td>
	</tr>
</table>
<script type="text/javascript">
if(${content == noteInput}){
	document.getElementById("notice").style.color="#d1d1d1";
}
</script>
</body>
</html>