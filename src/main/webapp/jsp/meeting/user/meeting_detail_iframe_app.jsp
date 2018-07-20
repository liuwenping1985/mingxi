<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
var baseObjectId = "${id}&app=6";
//alert('${mtMeetingURL}?method=showMtDiagram&id=${id}&fisearch=${fisearch}&fagent=${fagent}&fromdoc=${param.fromdoc}&proxy=${param.proxy}&proxyId=${param.proxyId}&eventId=${param.eventId}');
</script>
</head>
<frameset rows="*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
<%--xiangfan 注释 修复GOV-2350
  <frame noresize="noresize" src='<c:url value="/common/detail.html" />' scrolling="no">
   --%>
  <frameset  rows="*" cols="*,45" framespacing="0" id="zy">
    <frame frameborder="no" src="mtAppMeetingController.do?method=detail&id=${id}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
    <frame frameborder="no" src="mtAppMeetingController.do?method=showMtDiagram&id=${id}&affairId=${param.affairId }&fisearch=${fisearch}&fagent=${fagent}&fromdoc=${param.fromdoc}&proxy=${proxy}&proxyId=${proxyId}&eventId=${param.eventId}&notApprove=${notApprove}" name="detailRightFrame" scrolling="no" id="detailRightFrame" />
  </frameset>
</frameset>

<noframes>
<body scroll="no">浏览器不支持frame框架</body>
</noframes>

</html>