<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <html>
<head>
<%@include file="logHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
getA8Top().showLocation(2403);

function doIt(){
	form1.submit();
}

function showAlert(){
	alert(v3x.getMessage("LogLang.logon_clear_sucess"));
}
</script>
</head>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
<%@include file="labelPage.jsp"%>
<tr>
	<td class="page-list-border-LRD" valign="top">
	<form method="post" id="form1" target="formFrame">
	<table width="100%" height="120" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="bg-gray"><fmt:message key="logon.search.selectTime"/>:</td>
			<td width="160">
				<select name="clearMonth">
	            <option value="-1"><fmt:message key="logon.period.1"/></option>
	            <option value="-2"><fmt:message key="logon.period.2"/></option>
	            <option value="-3"><fmt:message key="logon.period.3"/></option>
	            <option value="-6"><fmt:message key="logon.period.6"/></option>
	            <option value="-12"><fmt:message key="logon.period.12"/></option>
	          	</select>			
			</td>
			<td><input type="button"
				value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>"
				class="button-default-2" onclick="doIt()"></td>
		</tr>
  </table>
  </form>
  </td>
</tr>
</table>
<form>
<iframe id="formFrame" name="formFrame" width="0" height="0"></iframe>
</body>
</html>