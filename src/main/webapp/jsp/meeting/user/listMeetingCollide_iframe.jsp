<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<c:set var="controller" value="mtMeeting.do"/>
<html>
<head>
<title>
	<fmt:message key="meeting.collide.remind"/>
</title>
</head>
<script type="text/javascript">
function doAction(type){
  var params = [];
  if(type == "Cancel"){
    params[0] = "false";
  }else if(type == "OK"){
    params[0] = "true";
  }
  if(typeof(transParams)!="undefined"){
	  transParams.parentWin.meetingColliedValidateCallback(params);
  }
  commonDialogClose('win123');
}
function doInit(){
	var _p = null;
	if(typeof(transParams)!="undefined"){
		_p = transParams.parentWin.conferees_str;
	}else{
		_p = window.dialogArguments.conferees_str;
	}
	
	document.getElementById("conferees").value = _p;
	
	var myform = document.getElementsByName("submitDataForm")[0];
    myform.submit();
}
</script>
<body onload="doInit();" scroll="no" style="padding:0;margin:0;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="meeting.collide.remind"/>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" sytle="padding:0;">
		<form method="post" id="submitDataForm" name="submitDataForm" target="myiframe" action="${controller}?method=listMeetingCollide&mtId=${v3x:toHTML(param.mtId)}&emcee=${param.emcee}&recorder=${v3x:toHTML(param.recorder)}&beginDate=${param.beginDate}&endDate=${v3x:toHTMLWithoutSpace(param.endDate)}&periodicityType=${param.periodicityType}&scope=${v3x:toHTMLWithoutSpace(param.scope)}&periodicityStartDate=${param.periodicityStartDate}&periodicityEndDate=${v3x:toHTMLWithoutSpace(param.periodicityEndDate)}">
		   <input type="hidden" id="conferees" name="conferees"/>
		</form>
			<iframe src="about:blank" name="myiframe" id="myiframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="doAction('OK');" onfocus="this.blur();" style="line-height:16px;outline:none;" value="<fmt:message key="meeting.collied.continue"/>" class="button-default_emphasize">
            <input type="button" onclick="doAction('Cancel');" style="line-height:16px" value="<fmt:message key="modifyBody.cancel.label"/>" class="button-default-2">&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>
	
</body>
</html>
