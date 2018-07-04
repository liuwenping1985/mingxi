<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="header.jsp"%>
<script type="text/javascript">
getDetailPageBreak();
function init() {
  try {
    parent.listFrame.location.href = "${ldapSynchron}?method=listUsers&reload=" + 1;
  } catch(e) {
    alert(e);
  }
}
</script>
</head>
<body onload="init()">
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center">

	<tr>
		<td align="center">
		<div style="padding:20px" id="checkRTXMsg" align="center">
		<fieldset style="width:70%;height:20%"><strong
			class="hr-blue-font"><legend><fmt:message key="ldap.alert.bindinglog" bundle="${ldaplocale}"/></legend></strong> 
			<v3x:table htmlId="listTable" data="resultArray" var="bean" width="100%"
			showPager="false">
			<v3x:column width="20%" align="center" type="String" value="${bean}"
				className="cursor-hand sort" alt="${bean}" />
		</v3x:table></fieldset>
		</div>
		<td>
	</tr>
</table>
</body>
</html>
