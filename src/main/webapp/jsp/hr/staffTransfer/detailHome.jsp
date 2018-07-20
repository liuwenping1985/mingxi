<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
</head>
<frameset rows="10,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
  <frame src='<c:url value="/common/detail.jsp" />' scrolling="no">
  <frame noresize="noresize" frameborder="no" src="${hrStaffTransferURL}?method=editTransfer&id=${id}&staffid=${staffid}&isReadOnly=${isReadOnly}&isNew=${isNew}" name="detailListFrame" scrolling="no" id="detailListFrame" />
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html>