<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../../common/INC/noCache.jsp" %>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="guestbook.content.label"/></title>
<html:link renderURL="/guestbook.do" var="guestbookURL"/>
<script type="text/javascript">
function openOrClose(){
try{
  var leaveword = '${closeWidow}' ;
  if(leaveword == 'true' ) {
    alert('留言已经被删除') ;
    window.returnValue = 'false' ;
    window.close() ;
  }
}catch(e){
}
}
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />"></script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="doKeyPressedEvent()" onload="openOrClose()">
<form name="leaveWordForm" method="post" action="${guestbookURL}?method=saveLeaveWord" target="hiddenLeaveWordFrame" onsubmit="return checkLeaveWordFrom(leaveWordForm)">

<table class="popupTitleRight" border="0" cellspacing="0" width="100%" height="100%">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="guestbook.content.label"/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<textarea readonly id="leaveWordContent" name="leaveWordContent" cols="" rows="" style="width:100%; height: 90%"   maxSize="300">${leaveword.content}
			</textarea>
			
			<div style="color: green">
			</div>
		</td>
	</tr>
	<tr>
		<td align="right" class="bg-advance-bottom" colspan="2">
		    <input type="button" name="close" class="button-default-2" value="<fmt:message key='message.header.close.alt'/>" onclick="window.close()"/>
		</td>
	</tr>
</table>
</form>
<iframe name="hiddenLeaveWordFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>