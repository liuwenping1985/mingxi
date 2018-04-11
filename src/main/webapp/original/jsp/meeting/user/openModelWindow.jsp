<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<html:link renderURL="/calEvent.do" var="calEventURL"/>
<script type="text/javascript">
function returnValueSet()
{
if((window.returnValue==''||window.returnValue==null)&&${!isHasEvent})
{
window.returnValue='close';
}
}

</script>
</head>
<body style="overflow: hidden;height: 100%;width: 100%" onunload="returnValueSet()">
<iframe src="${calEventURL}?method=edit&id=${eventId}&fromMeeting=1&isHasEvent=${isHasEvent}" name="iFrame" frameborder="1" height="100%" width="100%" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
</body>
</html>