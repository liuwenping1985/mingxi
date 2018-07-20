<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<title></title>
</head>
<frameset rows="10,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
  <frame src='<c:url value="/common/detail.jsp" />' scrolling="no">
  <frame noresize="noresize" frameborder="no" src="${detailURL}?method=categoryModify&id=${param.id}&update=${param.update}&isDetail=${param.isDetail}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html>