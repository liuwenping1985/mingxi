<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
<script language="JavaScript">
</script>
</head>
<frameset rows="10,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
  <frame src='<c:url value="/common/detail.jsp" />' scrolling="no">
  <frame noresize="noresize" frameborder="no" src="${hrStaffURL}?method=edit${type}&id=${id}&staffId=${staffId}&isReadOnly=${isReadOnly}&isManager=${isManager}&isNew=${isNew}" name="detailListFrame" scrolling="no" id="detailListFrame" />
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html>