<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp" %>
<style type="text/css">
<!--
td {
	font-family: "Arial", "Helvetica", "sans-serif";
	font-size: 12px;
	line-height: 24px;
	text-decoration: none;
}
.title {
	font-size: 14px;
	font-weight: bolder;
	color: #0066FF;
}
-->
</style>
</head>
<body>
<table width="100%" height="100%" border="0" align="center" cellpadding="2" cellspacing="2">
  <tr>
    <td valign="middle">
    <p>
    <fmt:message key="download.description.IESet">
    	<fmt:param>
    		<c:url value="/autoinstall.do?method=regInstallDown" />
    	</fmt:param>
    </fmt:message>
    </p>
      </td>
  </tr>
  <tr>
    <td height="20" align="right"></td>
  </tr>
  <tr>

  </tr>
</table>
</body>
</html>