<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="header.jsp"%>
<%@page import="com.seeyon.apps.taskmanage.util.TaskConstants" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<%-- 记录当前聚焦的单元格 --%>
var currentTD = null;
var TASK_PREFIX = "<fmt:message key='application.30.label' bundle='${v3xCommonI18N}'/>";
var TITLE = []; 
TITLE[TITLE.length] = TASK_PREFIX + "(<fmt:message key='task.status.notstarted' />)", 
TITLE[TITLE.length] = TASK_PREFIX + "(<fmt:message key='task.status.marching' />)", 
TITLE[TITLE.length] = TASK_PREFIX + "(<fmt:message key='task.status.delayed' />)", 
TITLE[TITLE.length] = TASK_PREFIX + "(<fmt:message key='task.status.finished' />)", 
TITLE[TITLE.length] = TASK_PREFIX + "(<fmt:message key='task.status.canceled' />)";
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/workManage.js${v3x:resSuffix()}" />"></script>
</head>
<body srcoll="no" style="overflow:auto;">
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="colI18N"/>
<div width="100%" height="100%" class="scrollList">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<input type='hidden' name='memberIdsStr' id='memberIdsStr' value='${memberIdsStr}' />
	<c:set value="${status == -1}" var="selectAllStatus" />
	<tr>
		<td colspan="2" valign="top">
			<table class="manage-stat-1" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr align="center" class="manage-bg">
					<td height="22" width="${selectAllStatus ? '10%' : '20%'}" rowspan="2" class="sorttd"><fmt:message key="stat.member.title" bundle='${colI18N}' /></td>
					<td colspan="2" width="${selectAllStatus ? '15%' : '80%'}" class="sorttd">
						<c:if test="${selectAllStatus}">
							<fmt:message key='task.status.notstarted' />
						</c:if>
						<c:if test="${!selectAllStatus}">
							<fmt:message key="task.status.${status == 1 ? 'notstarted' : status == 2 ? 'marching' : status == 3 ? 'delayed' : status == 4 ? 'finished' : 'canceled'}" />
						</c:if>
					</td>
					<c:if test="${selectAllStatus}">
						<td colspan="2" width="15%" class="sorttd"><fmt:message key="task.status.marching" /></td>
						<td colspan="2" width="15%" class="sorttd"><fmt:message key="task.status.finished" /></td>
						<td colspan="2" width="15%" class="sorttd"><fmt:message key="task.status.delayed" /></td>
						<td colspan="2" width="15%" class="sorttd" nowrap="nowrap"><fmt:message key="task.status.canceled" /></td>
						<td colspan="2" width="15%" class="sorttd" nowrap="nowrap"><fmt:message key="task.statsum" /></td>
					</c:if>
			  	</tr>
			  	
				<tr align="center" class="manage-bg">
					<c:set var="total" value="${selectAllStatus ? 5 : 0}" />
					<c:forEach begin="0" end="${total}" step="1">
						<td class="sorttd" width='${selectAllStatus ? 7.5 : 40}%'><fmt:message key='task.statcount' /></td>
						<td class="sorttd" width='${selectAllStatus ? 7.5 : 40}%'><fmt:message key='task.stattime' /></td>
					</c:forEach>
			  	</tr>
			  	
			  	<tbody>
		  		<c:set var="x" value="0"/>
			  	<c:forEach items="${memberIds}" var="memberId">
					<tr id="TR_${memberId}" align="center">
						<td class="sorttd" style="height: 24" id="TD0_${memberId}">${v3x:showMemberName(memberId)}</td>
					<c:choose>
					<c:when test="${selectAllStatus}">
						<td id="TD1_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',1, 1)" onmouseover="cursorTD('${memberId}',1,true,'TaskStat')" onmouseout="cursorTD('${memberId}',1,false,'TaskStat')">${ststMap[memberId][0]}</td>
						<td id="TD2_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',1, 2)" onmouseover="cursorTD('${memberId}',2,true,'TaskStat')" onmouseout="cursorTD('${memberId}',2,false,'TaskStat')">${ststMap[memberId][1]}</td>
						<td id="TD3_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',2,3)" onmouseover="cursorTD('${memberId}',3,true,'TaskStat')" onmouseout="cursorTD('${memberId}',3,false,'TaskStat')">${ststMap[memberId][2]}</td>
						<td id="TD4_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',2,4)" onmouseover="cursorTD('${memberId}',4,true,'TaskStat')" onmouseout="cursorTD('${memberId}',4,false,'TaskStat')">${ststMap[memberId][3]}</td>
						<td id="TD5_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',4,5)" onmouseover="cursorTD('${memberId}',5,true,'TaskStat')" onmouseout="cursorTD('${memberId}',5,false,'TaskStat')">${ststMap[memberId][4]}</td>
						<td id="TD6_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',4,6)" onmouseover="cursorTD('${memberId}',6,true,'TaskStat')" onmouseout="cursorTD('${memberId}',6,false,'TaskStat')">${ststMap[memberId][5]}</td>
						<td id="TD7_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',3,7)" onmouseover="cursorTD('${memberId}',7,true,'TaskStat')" onmouseout="cursorTD('${memberId}',7,false,'TaskStat')">${ststMap[memberId][6]}</td>
						<td id="TD8_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',3,8)" onmouseover="cursorTD('${memberId}',8,true,'TaskStat')" onmouseout="cursorTD('${memberId}',8,false,'TaskStat')">${ststMap[memberId][7]}</td>
						<td id="TD9_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',5,9)" onmouseover="cursorTD('${memberId}',9,true,'TaskStat')" onmouseout="cursorTD('${memberId}',9,false,'TaskStat')">${ststMap[memberId][8]}</td>
						<td id="TD10_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',5,10)" onmouseover="cursorTD('${memberId}',10,true,'TaskStat')" onmouseout="cursorTD('${memberId}',10,false,'TaskStat')">${ststMap[memberId][9]}</td>
						<td id="TD11_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',-1,11)" onmouseover="cursorTD('${memberId}',11,true,'TaskStat')" onmouseout="cursorTD('${memberId}',11,false,'TaskStat')"></td>
						<td id="TD12_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',-1,12)" onmouseover="cursorTD('${memberId}',12,true,'TaskStat')" onmouseout="cursorTD('${memberId}',12,false,'TaskStat')"></td>
			  		</c:when>
			  		<c:otherwise>
			  			<td id="TD1_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',${status},1)" onmouseover="cursorTD('${memberId}',1,true,'TaskStat')" onmouseout="cursorTD('${memberId}',1,false,'TaskStat')">${ststMap[memberId][0]}</td>
						<td id="TD2_${memberId}" class="manageTD" onclick="openProjectStatList('${memberId}',${status},2)" onmouseover="cursorTD('${memberId}',2,true,'TaskStat')" onmouseout="cursorTD('${memberId}',2,false,'TaskStat')">${ststMap[memberId][1]}</td>
			  		</c:otherwise>
			  		</c:choose>
			  		<c:if test="${x=='0'}">
						<script type="text/javascript">
							document.getElementById("TD1_${memberId}").className = "manageTD-sel";
							currentTD = "TD1_${memberId}";
						</script>
					</c:if>
					<c:set var="x" value="x+1"/>
			  		</tr>
			  	</c:forEach>
			  	
			  	<%-- 统计人数多于一个时，才有必要在最下方显示合计行 --%>
			  	<c:if test="${fn:length(memberIds) > 1}">
				  	<tr id='TR_<%=TaskConstants.STATISTIC_SUM_MEMBERS%>' align="center">
				  		<td class="sorttd" style="height: 24"><fmt:message key='task.statsum' /></td>
				  		<c:forEach begin="0" end="${selectAllStatus ? 11 : 1}" step="1" varStatus="sta">
				  		<td id="TD${sta.index + 1}_<%=TaskConstants.STATISTIC_SUM_MEMBERS%>" class="manageTD" onclick="openProjectStatSumList(${sta.index + 1}, ${status})" onmouseover="cursorSumTD(${sta.index + 1}, true)" onmouseout="cursorSumTD(${sta.index + 1}, false)">${ststMap[-1][sta.index]}</td>
				  		</c:forEach>
				  	</tr>
			  	</c:if>
			  	</tbody>
			</table>
		</td>
	</tr>
</table>
</div>
<script type="text/javascript">
	showSumValues('${memberIdsStr}', '${selectAllStatus}');
</script>
</body>
</html>