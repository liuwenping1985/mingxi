<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
	.dialog_main_footer{
		height:37px;
		bottom: 0px;
	}
	.bg-advance-bottom{
		border-bottom: 0px;
	}
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script>

var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

function ret(type) {
	var isBatch = (type == 2);
	if(parentCallback) {
		parentCallback(isBatch);
	} else {
		if("${param.type}" == "edit") {
			closeWindow();
			parentWindow.gotoEditUrl(isBatch);
			
		} else {
			parentWindow.gotoCancelUrl(isBatch);
		}
	}
}

function closeWindow() {
	commonDialogClose('win123');
}
</script>
</head>
<body>

<div style="height:74px;width：300px;">
	<div style="padding:6px 6px 36px;">
		<c:if test="${param.type=='edit' }">
			<fmt:message key='mt.single.or.batch.modify' />?
		</c:if>
		<c:if test="${param.type!='edit' }">
			<fmt:message key='mt.single.or.batch.cancel' />?
		</c:if>
	</div>
</div>

<div class="dialog_main_footer bg-advance-bottom  absolute align_right" style="padding-top:9px;padding-right:12px;">
	<c:if test="${param.type=='edit' }">
		<input type="button" class="button-default_emphasize" value="<fmt:message key='mt.single' /><fmt:message key='mt.admin.button.modify' />" onclick="ret(1);"/>
	</c:if>
	<c:if test="${param.type!='edit' }">
		<input type="button" class="button-default_emphasize" value="<fmt:message key='mt.single' /><fmt:message key='mr.button.cancel' />" onclick="ret(1);"/>
	</c:if>
	<c:if test="${param.type=='edit' }">
		<input type="button" class="button-default_emphasize" value="<fmt:message key='mt.batch' /><fmt:message key='mt.admin.button.modify' />" onclick="ret(2);"/>
	</c:if>
	<c:if test="${param.type!='edit' }">
		<input type="button" class="button-default_emphasize" value="<fmt:message key='mt.batch' /><fmt:message key='mr.button.cancel' />" onclick="ret(2);"/>
	</c:if>
	<input type="button" class="button-default-2" value="<fmt:message key='modifyBody.cancel.label' />" onclick="closeWindow();"/>
</div>

</body>
</html>