<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp"%>
<title>Insert title here</title>
</head>
<script type="text/javascript">

showCtpLocation("F13_sysSecurityLog");

function doIt(){
	var startDay = document.getElementById("startDay").value;
	var endDay = document.getElementById("endDay").value;
	if(startDay != "" && endDay != ""){
		if(compareDate(startDay,endDay)>0){
			alert(v3x.getMessage("LogLang.log_search_overtime"))		
			return false;
		}
	}
	form1.submit();
}
</script>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
<%@include file="labelPage.jsp"%>
<tr>
	<td class="page-list-border-LRD" valign="top" align="center">
	<form method="post" id="form1">
	<table width="100%" align="center" height="100" border="0" cellspacing="0"
		cellpadding="0">
		<!-- TR 条件 -->
		<tr>
			<td width="50%" height="100" align="center"><b><fmt:message
				key="logon.templete.branch.search.label" /></b>
			<fmt:message key="logon.search.selectTime" />:
			&nbsp;<input type="text" class="cursor-hand" name="startDay" id="startDay" value="${startDay }"
				onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);"
				readonly="true"><fmt:message key="logon.search.to" /><input
				type="text"  class="cursor-hand"  name="endDay" id="endDay" value="${endDay }"
				onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);"
				readonly="true">
			<input type="button"
				value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>"
				onclick="doIt()" class="button-default-2"></td>
		</tr>
		<tr>
			<td colspan="3">
			<table id="pending" class="page-list-border" width="50%" align="center"  border="0" cellspacing="0" cellpadding="0">
<tr class="sort">
					<td class="sort" align="right" width="50%"><fmt:message key="logon.stat.beginTime" />:</td>
					<td class="sort">${beginStatTime }&nbsp;</td>
				</tr>
				<tr height="33" >
					<td class="sort" align="right"><fmt:message key="logon.stat.totalAcess" />:</td>
					<td class="sort">${totalAccess }&nbsp;</td>
				</tr>
				<tr height="33" >
					<td class="sort" align="right"><fmt:message key="logon.stat.totalDay" />:</td>
					<td class="sort">${days }&nbsp;</td>
				</tr>
				<tr height="33" >
					<td class="sort" align="right"><fmt:message key="logon.stat.maxAccess" />:</td>
					<td class="sort">${maxAccess }&nbsp;</td>
				</tr>
				<tr height="33" >
					<td class="sort" align="right"><fmt:message key="logon.stat.avgAccess">
						<fmt:param value="${fromDate }" />
						<fmt:param value="${toDate }" />
					</fmt:message>:</td>
					<td class="sort">${avgAccess }&nbsp;</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	</form>
</td>
</tr>
</table>
</body>
</html>
