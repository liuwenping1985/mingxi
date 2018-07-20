<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>系统提示</title>

<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

	var pb_strConfirmCloseMessage = "<fmt:message key='edoc.newEdoc.saveToDraft'/>"+"?";

	window.onload = function() {


		$("input[@type='button']").click(function(){
			window.returnValue = $(this).attr("name");
			window.close();
		});
		
	}

</script>
</head>
<body style="overflow:hidden;" scroll="no">
<table class="popupTitleRight" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" id="msg" style="height:50px;">
<fmt:message key='edoc.newEdoc.saveToDraft'/>？

</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" style="padding-top:0;">
			<input type="button" name="saveYes" value="<fmt:message key='modifyBody.save.label'/>" />
<input type="button" name="saveNo" value="<fmt:message key='edoc.newEdoc.notSave'/>" />
<input type="button" name="saveCancel" value="<fmt:message key='modifyBody.cancel.label'/>" />
		</td>
	</tr>
</table>

</body>
</html>