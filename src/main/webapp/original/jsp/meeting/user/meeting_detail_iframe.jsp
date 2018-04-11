<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<title>${v3x:toHTML(meetingTitle) }</title>
<script type="text/javascript">
var baseObjectId = "${id}&app=6";
parent.window.document.title = "${v3x:escapeJavascript(meetingTitle)}";
</script>
</head>
<frameset rows="0,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no" id="df">
  <frame noresize="noresize" src='<c:url value="/common/detail.jsp" />' scrolling="no">
  <frameset  rows="*" cols="*,50" framespacing="0" id="zy">
    <frame frameborder="no" src="${mtMeetingURL}?method=detail&id=${id}&proxyId=${proxyId}&isQuote=${param.isQuote}&baseObjectId=${param.baseObjectId}&baseApp=${param.baseApp}&isCollCube=${isCollCube}&isColl360=${isColl360}&openfrom=${param.openfrom}&statType=${param.statType}&isImpart=${isImpart}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
    <frame frameborder="no" src="${mtMeetingURL}?method=showMtDiagram&id=${id}&fisearch=${fisearch}&fagent=${fagent}&fromdoc=${param.fromdoc}&proxy=${proxy}&proxyId=${proxyId}&eventId=${param.eventId}&isCollCube=${isCollCube}&isColl360=${isColl360}&isQuote=${param.isQuote}&openfrom=${param.openfrom}&baseObjectId=${param.baseObjectId}&category=${param.category}&isImpart=${isImpart}&fromPage=${param.fromPage}" name="detailRightFrame" scrolling="no" id="detailRightFrame" />
  </frameset>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>

</html>