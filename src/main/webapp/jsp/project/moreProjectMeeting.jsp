<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="projectHeader.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body scroll="no" style="overflow: auto;">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="line_project">
  <tr>
	    <td height="77" colspan="10" valign="top">
		    <table width="100%" height="60" border="0" cellpadding="0" cellspacing="0">
			      <tr>
			        <td width="80" height="60" valign="top"><img src="<c:url value="/apps_res/peoplerelate/images/pic1.gif" />" width="80" height="60" /></td>
			        <td class="project-header-bg">
			        	${projectCompose.projectSummary.projectName}
			        </td>
			        
			        <td align="left" valign="bottom" class="page2-header-line" style="padding-top: 4px">
			        	<table width="100%" align="left" height="52" border="0" cellpadding="0" cellspacing="0">
			          		<tr>
			            		<td width="15%" align="right">&nbsp;<fmt:message key='project.body.responsible.label' />:</td>
			            		<td align="left">&nbsp;&nbsp;<a class="cursor-hand" onclick="showV3XMemberCard('${projectCompose.principal.id}')">${projectCompose.principal.name}</a></td>
			          		</tr>
			          		<tr>
			            		<td align="right">&nbsp;<fmt:message key='project.body.manger.label' />:</td>
			            		<td align="left">&nbsp;
			            			${v3x:getLimitLengthString(v3x:join(projectCompose.chargeLists, 'name', pageContext),50,"...")}
			            		</td>
			          		</tr>
			          		<tr>
			            		<td align="right">&nbsp;<fmt:message key='project.body.members.label' />:</td>
			            		<td align="left">&nbsp;
			            			${v3x:getLimitLengthString(v3x:join(projectCompose.memberLists, 'name', pageContext),50,"...")}
					          	</td>
			          		</tr>
			          		<tr>
			            		<td align="right">&nbsp;<fmt:message key='project.body.related.label' />:</td>
			            		<td align="left">&nbsp;
			            			${v3x:getLimitLengthString(v3x:join(projectCompose.interfixLists, 'name', pageContext),50,"...")}
			            		</td>
			          		</tr>
			        	</table>
			        </td>
			      </tr>
		    </table>
	    </td>
  </tr>
  
  <tr>
    <td height="18"></td>
    <td class="txt_1"><fmt:message key='project.more.meeting'/></td>
  </tr>
  <tr>
    <td height="0" rowspan="2" valign="top"></td>
    <td height="1" valign="top" bgcolor="#d9a784"></td>
  </tr>
  
<tr>
<td>
	<div class="scrollList">
	<form>
		<v3x:table htmlId="mt" leastSize="0" data="mtList" var="mt" pageSize="20" showHeader="true" showPager="true" size="1">
						    				<v3x:column width="5%" align="center">
	    										<img src="<c:url value="/apps_res/peoplerelate/images/icon3.gif" />" width="10" height="10" />
	    									</v3x:column>
	    									<v3x:column align="left" width="30%" label="project.title">
	    										<a href="javascript:openDetail('${mtURL}?method=mydetail&id=${mt.id}')">${mt.title}</a>
	    									</v3x:column>
	    									<v3x:column align="center" width="35%" label="project.create.time">
	    										<fmt:formatDate value="${mt.createDate}" pattern="${datePattern}"/>
	    									</v3x:column>
	    									<v3x:column align="center" width="30%" label="project.type">
	    										<a href="${mtURL}?method=listMain"><fmt:message key='project.meeting'/></a>
	    									</v3x:column>
		</v3x:table>
	</form>
	</div>
</td>
</tr>
</table>
</body>
</html>