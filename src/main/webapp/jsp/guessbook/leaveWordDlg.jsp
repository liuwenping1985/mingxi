<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../common/INC/noCache.jsp" %>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<c:set value="${from=='calReply' ? 'cal' : 'label'}" var="titleLabel" />
<fmt:message key='guestbook.leaveword.${titleLabel}'/>
</title>
<html:link renderURL="/guestbook.do" var="guestbookURL"/>
<%-- 日程事件 --%>
<html:link renderURL="/calEvent.do" var="calEventURL" />
<script type="text/javascript">
var guestbookURL = "${guestbookURL}";
var currentUserName = "${v3x:escapeJavascript(v3x:showMemberName(v3x:currentUser().id))}";
var from = "${from}";
function check(){
	var chk = document.getElementById("c");
  	if(chk.checked){
		document.getElementById("flag").value = 1;
	}
}
function OK(){
var leaveWordForm = document.getElementById('leaveWordForm');
leaveWordForm.submit();
}
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />" ></script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="doKeyPressedEvent()" >
<c:choose>
	<c:when test="${from != 'calReply'}">
		<c:set value="${guestbookURL}?method=saveLeaveWord&from=guestbook&project=${from}" var="actionForm" />
	</c:when>
	<c:otherwise>
		<c:set value="${calEventURL}?method=calReply" var="actionForm" />
	</c:otherwise>
</c:choose>
<form name="leaveWordForm" id="leaveWordForm" method="post" action="${actionForm}" target="hiddenLeaveWordFrame" onsubmit="return checkLeaveWordFrom(leaveWordForm)">
<input type="hidden" value="${param.departmentId}" name="departmentId">
<input type="hidden" value="${param.from}" name="from">
<input type="hidden" value="${param.projectId}" name="projectId">
<input type="hidden" value="0" id="flag" name="flag">
<table class="popupTitleRight" border="0" cellspacing="0" width="100%" height="100%">
	<tr>
		<td height="20" class="PopupTitle">
		    <fmt:message key="guestbook.leaveword.${titleLabel}"/>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<textarea id="leaveWordContent" name="leaveWordContent" cols="" rows="5" style="width:100%; height: 70%" inputName="<fmt:message key='guestbook.leaveword.label'/>" validate="notNull" maxSize="1200"></textarea>
			<div style="color: green">
				<fmt:message key="guestbook.content.help">
					<fmt:param value="1200" />
				</fmt:message>
			</div>
			<div style="padding-top:4px;">
				<label for="c">		
					<input type="checkbox" name="c" id="c" value="true" checked="checked">
					<fmt:message key="guestbook.sendmessage2dept.label"/>
				</label>
			</div>
		</td>		
	</tr>
	<c:if test="${v3x:getBrowserFlagByUser('OpenDivWindow', v3x:currentUser())==true}">
	<tr>
		<td align="right" class="bg-advance-bottom" colspan="2" height="21">
		<c:if test = "${from != 'project' && from != 'calReply' }" >
			<input type="submit" id="submitBtn" class="button-default-4" value="<fmt:message key="guestbook.leaveword.label"/>"/>&nbsp;&nbsp;&nbsp;&nbsp;
		</c:if>
		
		<c:if test = "${from == 'project'}">
		    <input type="submit" id="submitBtn" class="button-default-4" value="<fmt:message key='guestbook.leaveword.label'/>" onclick="check()"/> &nbsp;&nbsp;&nbsp;&nbsp;
		</c:if>
		
		<c:if test="${from=='calReply'}">
			<input type="submit" id="submitBtn" class="button-default-2" value="<fmt:message key='guestbook.leaveword.ok'/>"/> &nbsp;&nbsp;&nbsp;&nbsp;
        </c:if> 
		    <input type="button" name="close" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="window.close()"/>
		</td>
	</tr>
	</c:if>
</table>
</form>
<iframe name="hiddenLeaveWordFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>