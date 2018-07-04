<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
</script>
</head>
<frameset rows="40,*" id='sx1' cols="*" framespacing="0">
	<frame src="${detailURL}?method=getToolbar&deptId=${deptId}" name="listFrame" id="listFrame" frameBorder="no" border='0' scrolling="no" noresize="noresize"/>
	<frameset cols="20%,*" id='sx2' cols="*" frameBorder="1" framespacing="5" bordercolor="#ececec">
		<frame src="${detailURL}?method=treeDeptAdmin" name="leftFrame" id="leftFrame" frameBorder="0" scrolling="no"/>
		<frameset rows="42%,*" id='sx' cols="*" frameBorder="0" border="0">
			<frame src="${detailURL}?method=initListAdmin&deptId=${deptId}" id="detailFrame" name="detailFrame" scrolling="yes"/>
			<frame src="<c:url value='/common/detail.jsp?direction=Down'/>" id="bottom" name="bottom" scrolling="no" />
		</frameset>
	</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>
