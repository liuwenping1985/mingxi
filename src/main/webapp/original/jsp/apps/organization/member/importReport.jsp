<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/organizationHeader.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title><fmt:message key="import.report"/></title>
</head>
<body bgColor="#f6f6f6">
<table  border="0" align="center" width="95%"><tr><td height="50">
<form id="datamatch" method="post" onSubmit="" name="datamatch"  >
    <table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height="20" style="padding-top: 12px">
        	<td height="20" colspan="1" style="padding-left: 12px">
                ${ctp:i18n('member.photo.upload.report.error.message')}&nbsp;
            </td>
            <td height="20" align="right"  colspan="2">
                <a id="exportReportBtn" class="common_button common_button_gray" href="member.do?method=exportReport">${ctp:i18n('org.button.exp.label')}${ctp:i18n('import.result')}</a>&nbsp;
            </td>
        </tr>
       <%--  <tr>
            <td height="42" align="right"  colspan="3">
                <a id="exportReportBtn" class="common_button common_button_gray" href="member.do?method=exportReport">${ctp:i18n('org.button.exp.label')}${ctp:i18n('import.result')}</a>&nbsp;
            </td>
        </tr> --%>
	</table>
</form>
</td></tr><tr><td>
 	<div class="scrollList" id="scrollListDiv" style="height:320px;">
		<form id="resulttable" method="post">
	<table  border="0" align="center" width="90%"><tr><td>
			<v3x:table htmlId="resultlst" data="resultlst" var="data" pageSize="10">
					<v3x:column width="15%" align="left" label="${ctp:i18n('import.data')}" type="String"
							value="${data.name}" className="cursor-hand sort"
							maxLength="35"  symbol="..." alt="${data.name}" />
					<v3x:column width="10%" align="left" label="${ctp:i18n('import.result')}" type="String"
							value="${data.success}" className="cursor-hand sort"
							maxLength="20"  symbol="..." alt="${data.success}" />
					<v3x:column width="60%" align="left" label="${ctp:i18n('import.description')}" type="String"
							value="${data.description}" className="cursor-hand sort"
							maxLength="70"  symbol="..." alt="${data.description}"  />
			</v3x:table>
		</td></tr></table></form></div>
</td></tr>
<!-- <tr><td height="10">&nbsp;</td></tr> -->
</table>
	<iframe name="hidden_iframe" style="display:none"></iframe>
</body>
</html>