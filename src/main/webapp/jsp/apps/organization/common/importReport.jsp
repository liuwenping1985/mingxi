<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="organizationHeader.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title><fmt:message key="import.report"/></title>
</head>
<body bgColor="#f6f6f6">
<table  border="0" align="center" width="95%"><tr><td height="122">
<form id="datamatch" method="post" onSubmit="" name="datamatch"  >
    <table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height="20"style="padding-top: 12px">
        	<td height="20" colspan="1" style="padding-left: 12px">
                ${ctp:i18n('import.report')}:&nbsp;
            </td>
            <td colspan="2" style="padding-left: 5px">
				<c:if test="${importType=='level' }">
                    ${ctp:i18n('import.type.level')}
                </c:if>
                <c:if test="${importType=='post' }">
                    ${ctp:i18n('import.type.post')}
                </c:if>
                <c:if test="${importType=='team' }">
                    ${ctp:i18n('import.type.team')}
                </c:if>
                <c:if test="${importType=='department' }">
                    ${ctp:i18n('import.type.dept')}<c:if test="${deptOrRole=='0' }">${ctp:i18n('import.type.dept.role')}</c:if>
                </c:if>
                <c:if test="${importType=='member' }">
                    ${ctp:i18n('import.type.member')}
                </c:if>
                <c:if test="${importType=='account' }">
                    ${ctp:i18n('import.type.account')}
                </c:if>
			</td>
        </tr>
		<tr>
			<td height="20" style="padding-left: 12px">
				${ctp:i18n('import.filename')}:
			</td>
			<td style="padding-left: 5px">
				<c:out value="${impURL}"/>
			</td>
		</tr>
		
		<tr>
			<td height="20" style="padding-left: 12px">
				${ctp:i18n('import.choose.language')}:
			</td>
			<td colspan="2" style="padding-left: 5px">
				<c:set var="key" value="localeselector.locale.${language}" />
				${ctp:i18n(key)}
			</td>
		</tr>
        <c:if test="${importType!='department' }">
		<tr>
			<td height="20" style="padding-left: 12px">
				${ctp:i18n('import.option')}:
			</td>
			<td style="padding-left: 5px">
				<c:choose>
					<c:when test="${repeat=='0'}">
						${ctp:i18n('import.repeatitem.overcast')}
					</c:when>
					<c:otherwise>
						${ctp:i18n('import.repeatitem.overleap')}
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
        </c:if>
        <tr>
            <td height="42" align="right" class="bg-advance-bottom" colspan="3">
                <a id="exportReportBtn" class="common_button common_button_gray" href="organizationControll.do?method=exportReport">${ctp:i18n('org.button.exp.label')}${ctp:i18n('import.result')}</a>&nbsp;
            </td>
        </tr>
	</table>
</form>
</td></tr><tr><td>
 	<div class="scrollList">
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
</td></tr><tr><td height="10">&nbsp;</td></tr></table>
	<iframe name="hidden_iframe" style="display:none"></iframe>
</body>
</html>