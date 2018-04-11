<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:set value="${v3x:parseElements(memberList, 'id', 'entityType')}" var="members"/>
<script type="text/javascript">
<!--
var excludeElements_selectForCreateTeam = parseElements('${members}');
//-->
</script>
</head>
<body>
	<form id="teamForm" name="teamForm" action="" method="post">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr bgcolor="#BADCE8">
			  	<td width="15%" height="30" align="right" valign="middle">
		  			<fmt:message key="message.team.name"/>：
				</td>
				<td width="80%">
		  			<input type="text" id="name" name="name" style="width: 99%;" value="${v3x:toHTML(teamName)}" ${updateTeam == 'true' ? 'readonly' : ''}>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2" class="dialog-button">
					<v3x:selectPeople id="selectForCreateTeam" panels="Department,Post,Team,RelatePeople" selectType="Member" showMe="false" maxSize="${memberSize}" minSize="${param.createType == '1' ? '2' : '1'}" jsFunction="" include="true"/>
				</td>
		  	</tr>
		</table>
	</form>
</body>
</html>