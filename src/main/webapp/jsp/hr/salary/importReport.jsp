<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="../header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="v3xOrganizationI18N"/>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	getDetailPageBreak();
	
	function exportReport(){
		exportReportIframe.location.href = "${urlHrSalary}?method=exportReport";
	}
</script>
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body class="with-header main-bg">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" align="center">
			<tr>
				<td height="25" valign="middle">
					<b><fmt:message key="import.report" bundle="${v3xOrganizationI18N}"/></b>
				</td>
			</tr>
			<tr>
				<td height="38" align="right" class="bg-advance-bottom">
					<input id="b1" name="b1" type="button" onclick="exportReport()" value="<fmt:message key='org.button.exp.label' bundle='${v3xOrganizationI18N}'/><fmt:message key='import.result' bundle='${v3xOrganizationI18N}'/>" class="button-default-2">&nbsp;
				</td>
			</tr>
		</table>
	</div>
	<div class="center_div_row2" id="scrollListDiv">
		<form method="post">
			<fmt:message key='import.data' bundle='${v3xOrganizationI18N}' var="data_label"/>
			<fmt:message key='import.result' bundle='${v3xOrganizationI18N}' var="result_label"/>
			<fmt:message key='import.description' bundle='${v3xOrganizationI18N}' var="description_label"/>
			<v3x:table htmlId="reportList" data="reportList" var="data">
				<fmt:message key='import.report.data' var="data_label_" bundle='${v3xHRI18N}'>
					<fmt:param value="${data.deptName}" />
					<fmt:param value="${data.memberName}" />
				</fmt:message>
				<fmt:message key='import.report.${data.success}' bundle='${v3xHRI18N}' var="result_label_" />
				<fmt:message key='import.report.error.${data.error}' bundle='${v3xHRI18N}' var="description_label_" />
				<v3x:column width="30%" label="${data_label}" type="String" value="${data_label_}" alt="${data_label_}" className="cursor-hand sort" />
				<v3x:column width="10%" label="${result_label}" type="String" value="${result_label_}" alt="${result_label_}" className="cursor-hand sort" />
				<v3x:column width="60%" label="${description_label}" type="String" value="${description_label_}"  alt="${description_label_}" className="cursor-hand sort" />
			</v3x:table>
		</form>
	</div>
</div>
</div>
		
<iframe id="exportReportIframe" name="exportReportIframe" width="0" height="0" style="display:none;"></iframe>
</body>
</html>
<script type="text/javascript">
	setTimeout(function(){
		document.getElementById("bDivreportList").style.height =(document.getElementById("bDivreportList").offsetHeight-16)+"px";
	},500);
</script>