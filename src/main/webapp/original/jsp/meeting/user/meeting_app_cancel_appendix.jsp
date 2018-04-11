<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

	function sure() {
		var html = document.getElementById("content").value;
		if(html=='' || $.trim(html)=='') {
			alert("撤销附言不能为空");
			init();
			return;
		}
		if(html.length>100) {
			alert("100<fmt:message key='mt.list.toolbar.cancel.appendix.word.note'/>。");
			init();  
			return;
		}
		if(typeof(transParams)!="undefined"){
			transParams.parentWin.cancelMeetingSummaryCallback(html);
			commonDialogClose('win123');
		}else{
			window.returnValue = html;
			window.close();
		}
	}
	function init(){
		var content=document.getElementById("content");    
		content.focus();  
	}
</script>
</head>
<body class="h100b" style="background:#EDEDED" onload="init()">
<form style="position:fixed;top:0;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='meetingLang.meeting_action_cancel'/>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" style="padding:6px 12px;">
		    <script>
		    document.write(v3x.getMessage("meetingLang.meeting_list_toolbar_cancel_alert"));
			</script>
			100<fmt:message key='mt.list.toolbar.cancel.appendix.word.note'/>
			<textarea name="content" id="content" style="width:100%;height:125px" onblur="init();"></textarea>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" style="border:none;">
			<input type="button" id="ok" value="<fmt:message key='mt.list.toolbar.cancel.appendix.ok'/>" onclick="sure()" class="button-default-2  button-default_emphasize" />
		    <input type="button" id="exit" value="<fmt:message key='mt.list.toolbar.cancel.appendix.exit'/>" onclick="commonDialogClose('win123');" class="button-default-2" />
		</td>
	</tr>
</table>
</form>
</body>
</html>