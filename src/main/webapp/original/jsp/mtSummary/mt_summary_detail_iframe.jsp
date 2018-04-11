<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
var baseObjectId = "${id}&app=6";
</script>
</head>
<frameset rows="0,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no" id="df">
<frame noresize="noresize" src='<c:url value="/common/detail.jsp" />' scrolling="no">
  <frameset  rows="*" cols="*,45" framespacing="0" id="zy">
    <frame frameborder="no" src="meetingSummary.do?method=detail&recordId=${recordId}&listType=${param.listType}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
    <frame frameborder="no" src="meetingSummary.do?method=showMtSummaryDiagram&mId=${mId}&recordId=${recordId }&fisearch=${fisearch}&fagent=${fagent}&fromdoc=${param.fromdoc}&proxy=${proxy}&proxyId=${proxyId}&eventId=${param.eventId}&openType=${openType}" name="detailRightFrame" scrolling="no" id="detailRightFrame" /><%--xiangfan 添加openType，修复GOV-2185 2012-04-24 --%>
  </frameset>
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html>