<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<title><fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body scroll="no">
<form name="fm" id="fm" method="post" action="" onsubmit="">
<input type="hidden" name="id" value="${board.id}">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="popupTitleRight">
	<tr>
		<td height="20" class="PopupTitle padding5" align="right"></td>
	</tr>
	<tr>
		<td class="tab-body-bg2" colspan="2" height="100%" width="100%" valign="top">
			<div class="scrollList">
				<b style="padding: 20px 10px;">
				<c:choose>
					<c:when test="${custom}">
						<fmt:message key="bbs.by.space.label" />
					</c:when>
					<c:otherwise>
						<fmt:message key="bbs.by.department.label" />
					</c:otherwise>
				</c:choose>
				</b>
				<table class="sort manage-stat-1" width="100%" border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
					<thead>
						<tr align="center">
							<c:choose>
								<c:when test="${custom}">
									<td type="String" width="20%"><fmt:message key='bbs.space.label'/></td>
								</c:when>
								<c:otherwise>
									<td type="String" width="20%"><fmt:message key='bbs.department.label'/></td>
								</c:otherwise>
							</c:choose>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.day.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.week.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.month.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.all.label'/></td>
					  	</tr>
				  	</thead>
				  	<tbody>
						<c:forEach items="${list}" var="con">
								<tr align="center">
									<c:choose>
									<c:when test="${custom}">
										<td class="sort">${board.name}</td>
									</c:when>
									<c:otherwise>
										<td class="sort">${v3x:getOrgEntity("Department", con.moduleId).name}</td>
									</c:otherwise>
								</c:choose>
								<td class="sort">${con.dayCount}</td>
								<td class="sort">${con.weekCount}</td>
								<td class="sort">${con.monthCount}</td>
								<td class="sort">${con.allCount}</td>
						  	</tr>
						</c:forEach>
					</tbody>
				</table>
				<br>			
				<b style="padding: 20px 10px;"><fmt:message key="bbs.by.issueuser.label" /></b>
				<table class="sort manage-stat-1" width="100%" border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
					<thead>
						<tr align="center">
							<td type="String" width="20%"><fmt:message key='bbs.boardmanager.column.issueuser.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.day.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.week.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.month.label'/></td>
							<td type="Integer" width="20%"><fmt:message key='bbs.boardmanager.count.all.label'/></td>
					  	</tr>
				  	</thead>
				  	<tbody>
						<c:forEach items="${sendlist}" var="con">
							<tr align="center">
								<td class="sort">${v3x:showMemberName(con.moduleId)}</td>
								<td class="sort">${con.dayCount}</td>
								<td class="sort">${con.weekCount}</td>
								<td class="sort">${con.monthCount}</td>
								<td class="sort">${con.allCount}</td>
						  	</tr>
						</c:forEach>
						<c:if test="${anonymousCount!=null}">
							<tr align="center">
								<td class="sort"><fmt:message key="anonymous.label"/></td>
								<td class="sort">${anonymousCount.dayTotalNum}</td>
								<td class="sort">${anonymousCount.weekTotalNum}</td>
								<td class="sort">${anonymousCount.monthTotalNum}</td>
								<td class="sort">${anonymousCount.allTotalNum}</td>
						  	</tr>									
						</c:if>										
					</tbody>
				</table>
			</div>
		</td>
	</tr>
</table>
</form>
</body>
</html>
