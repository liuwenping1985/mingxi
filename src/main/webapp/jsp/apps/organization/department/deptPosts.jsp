<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@include file="../common/organizationHeader.jsp"%>
<base target=_self>
</head>
<body  onkeydown="listenerKeyESC()" scroll="no">
<form name="deptForm" id="deptForm" method="post" target="deptFormFrame" action="${organizationPortalURL}&method=updateDeptPosts&id=${dept.v3xOrgDepartment.id}" onsubmit="return(checkForm(this))">   
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north padding_5" layout="height:70,sprit:false,border:false">
			<table class="padding_5" width="100%" height="" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="20" colspan="2" class="">	
					<div style="overflow:hidden">	
			            <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			                <tr>
				                <td class="departmentMessage" align="right" width="20%" nowrap="nowrap">
				                    <label for="name"><strong><span title="${dept.v3xOrgDepartment.name}">${v3x:getLimitLengthString(dept.v3xOrgDepartment.name, 30, "...")}</span></strong></label>
				                    ${ctp:i18n('organization.totals')}&nbsp;&nbsp;<span style="color: red">${fn:length(postList)}</span>&nbsp;&nbsp;${ctp:i18n('import.type.posts')}
				                </td>
				                <td width="80%">
				                </td>
				            </tr>
				        </table>
				    </div>
				    </td>
				</tr>
				<tr>
					<td colspan="2" height="20" >${ctp:i18n('org.dept_form.deptLeader.label')}:&nbsp;&nbsp;
						<% String delimeter= "";%>
						<c:forEach items="${managerList}" var="manager">
							<%=delimeter%>
							<c:out value="${v3x:showMemberName(manager.id)}"/>
							<% delimeter=",";%>
						</c:forEach>
					
					</td>
				</tr>
				<tr>
					<td colspan="2" height="20">${ctp:i18n('org.dept.members')}:&nbsp;&nbsp;${memberListLength}</td>
				</tr>
			</table>
        </div>
        <div class="layout_center" layout="border:false">
			<c:if test="${postsSize != 0}">	
				<div id="posts" class="padding_5">
					<table class="sort" width="100%" cellspacing="0">
						<thead>
							<tr class="sort">
								<td width='30%' type='String'>${ctp:i18n('common.member.name')}</td>
								<td width='40%' type='String'>${ctp:i18n('common.member.post')}</td>
								<td width='30%' type='String'>${ctp:i18n('common.member.code')}</td>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${memberList}" var="user">
								<tr>
						        	<td class='sort'><c:out value='${user.typeName}' escapeXml='true'/></td>
									<td class='sort'>${v3x:getLimitLengthString(user.postName, 24, '...')}&nbsp;</td>
									<td class='sort'>${user.v3xOrgMember.code}&nbsp;</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
			   </div>	
	   </c:if>
	   	<c:if test="${postsSize == 0}">
	   	<div class="bg-advance-middel" align="center" valign="middle">
            <font style="font-size: 20px;color: #6c82ac">${ctp:i18n('org.dept_form.post.member.label.alert')}</font>		
            </div>
	   </c:if>
        </div>
    </div>
</form>
<iframe name="deptFormFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>