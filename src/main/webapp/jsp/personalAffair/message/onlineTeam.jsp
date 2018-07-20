<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
</head>
<body class="easyui-layout">
	<div region="north" border="false" style="height:0px;">
	</div>
		
	<div region="center" border="false">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    	<c:forEach items="${deptList}" var="dept">
	    		<c:set value="${v3x:toString(dept.id)}" var="deptId"/>
	    		<c:choose>
					<c:when test="${!v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}">
						<c:set value="selectTeam('ByDepartment', this, '${dept.id}');top.showIMTab('2', '${dept.id}', '${dept.name}', 'false')" var="onClick"/>	
					</c:when>
					<c:otherwise>
						<c:set value="selectTeam('ByDepartment', this, '${dept.id}')" var="onClick"/>
					</c:otherwise>
				</c:choose>
	    		<tr title="<fmt:message key='org.department.label' />-${dept.name}" class="team-no-select" teamId="${dept.id}" teamType="dept" onclick="${onClick}" ondblclick="top.showIMTab('2', '${dept.id}', '${dept.name}', 'false')">
	    			<td width="40" height="25" align="center"><img src="/seeyon/apps_res/v3xmain/images/message/16/users.gif" align="absmiddle" /></td>
	    			<td>${dept.name}(${onlineNumMap[deptId]}/${numMap[deptId]})</td>
	    		</tr>
			</c:forEach>
			<c:forEach items="${teamList}" var="team">
				<c:set value="${v3x:toString(team.id)}" var="teamId"/>
				<c:choose>
					<c:when test="${team.type == '2'}">
						<c:set value="3" var="teamType" />
						<c:set value="/seeyon/apps_res/v3xmain/images/message/16/project.gif" var="imgSrc" />
						<fmt:message key='message.system' var="altTitle"/>
					</c:when>
					<c:when test="${team.type == '3'}">
						<c:set value="4" var="teamType" />
						<c:set value="/seeyon/apps_res/v3xmain/images/message/16/project.gif" var="imgSrc" />
						<fmt:message key='message.project' var="altTitle"/>
					</c:when>
					<c:when test="${team.type == '4'}">
						<c:set value="5" var="teamType" />
						<c:set value="/seeyon/apps_res/v3xmain/images/message/16/comments.gif" var="imgSrc" />
						<fmt:message key='message.team' var="altTitle"/>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${!v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}">
						<c:set value="selectTeam('ByTeam', this, '${team.id}');top.showIMTab('${teamType}', '${team.id}', '${v3x:toHTMLWithoutSpaceEscapeQuote(team.name)}', 'false')" var="onClick"/>	
					</c:when>
					<c:otherwise>
						<c:set value="selectTeam('ByTeam', this, '${team.id}')" var="onClick"/>
					</c:otherwise>
				</c:choose>
				<tr title="${altTitle}-${v3x:toHTMLWithoutSpaceEscapeQuote(team.name)}" class="team-no-select" teamId="${team.id}" teamType="${team.type}" teamName="${v3x:toHTMLWithoutSpaceEscapeQuote(team.name)}" onclick="${onClick}" ondblclick="top.showIMTab('${teamType}', '${team.id}', '${v3x:toHTMLWithoutSpaceEscapeQuote(team.name)}', 'false')">
	    			<td width="40" height="25" align="center"><img src="${imgSrc}" align="absmiddle" /></td>
	    			<td>${v3x:toHTMLWithoutSpaceEscapeQuote(team.name)}(${onlineNumMap[teamId]}/${numMap[teamId]})</td>
	    		</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>