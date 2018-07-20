<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>系统提示</title>

<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

	var pb_strConfirmCloseMessage = "将已填写的内容保存至草稿箱？";

	window.onload = function() {


		$("input[@type='button']").click(function(){
			window.returnValue = $(this).attr("name");
			window.close();
		});
		
	}

</script>
</head>
<body scroll="no">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">
			
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<div id="msg" style="padding:0 12px;height:60px;"><fmt:message key='edoc.newEdoc.saveToDraft'/>?</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" style="padding-top:0px;">
		       <input class="button-default-2" type="button" name="saveYes" value="<fmt:message key='modifyBody.save.label'/>" />
			   <input class="button-default-2" type="button" name="saveNo" value="<fmt:message key='edoc.newEdoc.notSave'/>" />
               <input class="button-default-2" type="button" name="saveCancel" value="<fmt:message key='modifyBody.cancel.label'/>" />
		</td>
	</tr>
</table>
</body>
</html>