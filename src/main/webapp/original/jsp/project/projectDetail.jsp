<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="projectHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="common.advance.label"
	bundle="${v3xCommonI18N}" /></title>
</head>
<body scroll="auto">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">&nbsp;<fmt:message
			key='project.info.showprojectmember' /></td>
	</tr>
	<tr>
		<td height="100%">
		<div class="scrollList">
		<table width="100%" height="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td width="25%" align="center" valign="top"><Strong><fmt:message
					key='project.body.responsible.label' /></Strong></td>
			</tr>

			</td>
			</tr>
			<tr>
				<td><v3x:table data="${principal}" var="pc"
					htmlId="principalList" showPager="false"
					className="sort manage-stat-1">
					<v3x:column width="25%" label="project.realname" align="center"
						value="${pc.name}"></v3x:column>

					<v3x:column width="35%" label="project.only.dept" className="sort" align="center"
						value="${v3x:getOrgEntity('Department', pc.orgDepartmentId).name}">

					</v3x:column>

					<v3x:column width="45%" label="project.station" className="sort" align="center"
						value="${v3x:getOrgEntity('Post', pc.orgPostId).name}">

					</v3x:column>

				</v3x:table></td>
			</tr>


			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

			<tr>
				<td align="center" valign="top"><Strong><fmt:message
					key='project.body.manger.label' /></Strong></td>

			</tr>

			<tr>
				<td><v3x:table data="${projectCompose.chargeLists }" var="pc"
					htmlId="chargeListsList" showPager="false"
					className="sort manage-stat-1">
					<v3x:column width="25%" label="project.realname" align="center"
						value="${pc.name}"></v3x:column>

					<v3x:column width="35%" label="project.only.dept" className="sort" align="center"
						value="${v3x:getOrgEntity('Department', pc.orgDepartmentId).name}">

					</v3x:column>

					<v3x:column width="45%" label="project.station" className="sort" align="center"
						value="${v3x:getOrgEntity('Post', pc.orgPostId).name}">

					</v3x:column>

				</v3x:table></td>
			</tr>

			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

			<tr>
				<td align="center" valign="top"><Strong><fmt:message
					key='project.body.members.label' /></Strong></td>
			</tr>
			<tr>
				<td><v3x:table data="${projectCompose.memberLists }" var="pc"
					htmlId="memberListsList" showPager="false"
					className="sort manage-stat-1">
					<v3x:column width="25%" label="project.realname" align="center"
						value="${pc.name}"></v3x:column>

					<v3x:column width="35%" label="project.only.dept" className="sort" align="center"
						value="${v3x:getOrgEntity('Department', pc.orgDepartmentId).name}">

					</v3x:column>

					<v3x:column width="45%" label="project.station" className="sort" align="center"
						value="${v3x:getOrgEntity('Post', pc.orgPostId).name}">

					</v3x:column>

				</v3x:table></td>
			</tr>

			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  -->

			<tr>
				<td align="center" valign="top"><Strong><fmt:message
					key='project.body.related.label' /></Strong></td>
			</tr>
			<tr>
				<td><v3x:table data="${projectCompose.interfixLists}" var="pc"
					htmlId="interfixListsList" showPager="false"
					className="sort manage-stat-1">
					<v3x:column width="25%" label="project.realname" align="center"
						value="${pc.name}"></v3x:column>

					<v3x:column width="35%" label="project.only.dept" className="sort" align="center"
						value="${v3x:getOrgEntity('Department', pc.orgDepartmentId).name}">

					</v3x:column>

					<v3x:column width="45%" label="project.station" className="sort" align="center"
						value="${v3x:getOrgEntity('Post', pc.orgPostId).name}">

					</v3x:column>

				</v3x:table></td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom"><input
			type="button" onclick="window.close()"
			value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}' />"
			class="button-default-2"></td>
	</tr>


</table>
</body>
</html>
