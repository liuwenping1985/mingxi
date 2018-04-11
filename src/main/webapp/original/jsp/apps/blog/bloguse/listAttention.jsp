<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Properties;"%>
<html>
<head>
<title><fmt:message key="blog.follow.blog.list"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp"%>
</head>
 <v3x:selectPeople id="per" panels="Department" selectType="Department,Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />
<body>
<table height="100%" width="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>	
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="blog.otherblog"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<div class="scrollList">
		<form id="memberform" name="memberform" method="post">
			<v3x:table htmlId="memberlist" data="AttentionModelList" var="vo" pageSize="5">
			<v3x:column width="30%" label="org.member_form.name.label"  type="string" align="center">
				<a href="${detailURL}?method=listLatestFiveArticleAndAllFamilyOther&userId=${vo.employeeId}"
					class="hyper_link1" title="${vo.userName}" target="_self">
				${v3x:getLimitLengthString(vo.userName,35,"...")} </a>
			</v3x:column>
			</v3x:table>
		</form>
		</div>
		</td>
	</tr>
</table>

</body>
</html>