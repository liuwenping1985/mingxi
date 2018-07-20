<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="header.jsp"%>
<%@page import="com.seeyon.apps.taskmanage.util.TaskConstants" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function parseDateFmt(dateStr) {
    return Date.parse(dateStr.replace(/\-/g, '/'));
}

function validateTime() {
        if($("#beginDate").val().length > 0 && $("#endDate").val().length > 0) {
            if (parseDateFmt($("#beginDate").val()) > parseDateFmt($("#endDate").val())) {
                alert('开始时间不能大于结束时间!');
                return false;
            }
        }
}
</script>
</head>
<body onkeypress="listenerKeyESC()" scroll="no" onload='changeDateSelectState(false)'>
<table border="0" cellpadding="0" cellspacing="0" width="100%"	height="100%" align="center">
	<tr>
		<td height='50'>
			<form method="post" id="statisticForm" name="statisticForm" target="statResultFrame" onsubmit="return validateTime()" action="${taskManageUrl}?method=statisticResult">
			<input type="hidden" name="projectId" id="projectId" value="${param.projectId}" />
			<input type="hidden" name="projectPhaseId" id="projectPhaseId" value="${param.projectPhaseId}" />
			<fieldset class="padding10">
			<legend><fmt:message key='task.statcondition' /></legend>
			<table  cellSpacing="0" cellPadding="0"  width="100%" border="0" >
				<tr>
					<td width='10%' align='right' height='24'></td>
					<td width='30%' colspan='2' style="white-space:nowrap;">
						<fmt:message key='task.timerange' />:
						&nbsp;&nbsp;<label for='day'><input type='radio' name='timeRange' id='day' onClick='changeDateSelectState(false)' value='<%=TaskConstants.StatisticPeriod.Day.ordinal()%>' /><fmt:message key='task.timerange.day' /></label>
						&nbsp;&nbsp;&nbsp;<label for='week'><input type='radio' name='timeRange' id='week' onClick='changeDateSelectState(false)' checked value='<%=TaskConstants.StatisticPeriod.Week.ordinal()%>' /><fmt:message key='task.timerange.week' /></label>
						&nbsp;&nbsp;&nbsp;<label for='month'><input type='radio' name='timeRange' id='month' onClick='changeDateSelectState(false)' value='<%=TaskConstants.StatisticPeriod.Month.ordinal()%>' /><fmt:message key='task.timerange.month' /></label>
						&nbsp;&nbsp;&nbsp;<label for='custom'><input type='radio' name='timeRange' id='custom' onClick='changeDateSelectState(true)' value='<%=TaskConstants.StatisticPeriod.Custom.ordinal()%>' /><fmt:message key='task.timerange.custom' /></label>
					</td>
					<td colspan='3' style="white-space:nowrap;">
						&nbsp;&nbsp;<fmt:message key="common.date.begindate.label" bundle='${v3xCommonI18N}'/>:
						<input type="text" id="beginDate" name="beginDate" class="input-datetime" 
							onclick="whenstart('${pageContext.request.contextPath}', this, 675, 140);" readonly>
						&nbsp;&nbsp;<fmt:message key="common.date.enddate.label" bundle='${v3xCommonI18N}'/>:
						<input type="text" id="endDate" name="endDate" class="input-datetime"
							onclick="whenstart('${pageContext.request.contextPath}', this, 675, 140);" readonly>
					</td>
				</tr>
				
				<tr>
					<td width='10%' align='right' height='24'></td>
					<td width='20%' align='left' style="white-space:nowrap;">
						<fmt:message key='task.status' />:&nbsp;&nbsp;
						<select name="status" id="status" class="input-40per">
							<option value='-1'><fmt:message key='task.all' /></option>
<%--老版本已无法使用<v3x:metadataItem metadata="${taskStatusMetadata}" showType="option" name="status" /> --%>
				    		<c:forEach items="${taskStatusMetadata}" var="tsm">
				    		  <option value="${tsm.key}">${tsm.text }</option>
				    		</c:forEach>
				    	</select>
					</td>
					<td width='10%' align='right' style="white-space:nowrap;"><fmt:message key='task.statbymember' />:</td>
					<td width='20%' align='left'>
						<select name="memberIds" id="memberIds" class="input-60per">
							<option value="${memberIdsStr}"><fmt:message key='task.all' /></option>
							<c:forEach items="${memberIds}" var="memberId">
							<option value='${memberId}'>${v3x:showMemberName(memberId)}</option>
							</c:forEach>
						</select>
					</td>
					<td width='14%' align=center>
						<input type="submit" name="submitBtn" value="<fmt:message key='common.button.ok.label'  bundle='${v3xCommonI18N}' />"  class="button-default-2" >
					</td>
					<td width='26%' align='center'>
					</td>
				</tr>
			</table>
			</fieldset>
			</form>
		</td>
	</tr>
	
	<tr>
		<td style="padding-top:10px">
			<iframe name="statResultFrame" id="statResultFrame" src="${taskManageUrl}?method=statisticResult&projectId=${param.projectId}&projectPhaseId=${param.projectPhaseId}&status=-1&memberIds=${memberIdsStr}&timeRange=<%=TaskConstants.StatisticPeriod.Week.ordinal()%>" frameborder="0"  height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>
</table>
</body>
</html>
