<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="hr.Laws.staff.files" bundle="${v3xHRI18N}" /></title>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
    <frame noresize="noresize" frameborder="0" src="${hrStaffURL}?method=initUserDefinedPage&page_id=${param.page_id}&staffId=${param.staffId}&isManager=${param.isManager}" name="spaceFrame" scrolling="no" id="spaceFrame" />
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>