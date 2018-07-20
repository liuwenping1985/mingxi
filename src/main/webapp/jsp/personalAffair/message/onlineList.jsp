<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/addressbook/js/addressbook.js${v3x:resSuffix()}'/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/docMenu.css${v3x:resSuffix()}' />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/default.css${v3x:resSuffix()}" />">
<c:set var="hasNewMail" value="${v3x:hasNewMail() }"/>
<c:set var="hasNewColl" value="${v3x:hasNewCollaboration() }"/>
<script type="text/javascript">
	var rightMenu = new RightMenu("${pageContext.request.contextPath}");
	rightMenu.AddItem("viewMember", _("MainLang.section_info_member"), "", "rbpm", "viewMember", "viewMember");
	document.writeln(rightMenu.GetMenu());
	
	$(document).ready(function(){
		$("#showOfflineList").attr("checked","${param.showoffline}");
		if(${isRoot && !isRootQuery}){
			$("#showOfflineList").attr("disabled",true);
			$("#showOfflineList").attr("checked",false);
		}
		$("#showOfflineList").click(function(){
			showOfflineList();
		});
	});
</script>
<style>
.panel-body{
overflow:hidden;
}
</style>
</head>
<body class="easyui-layout">
	<div region="north" border="false" style="height:30px;">
		<form name="userForm" action="${messageURL}" method="get" onsubmit="return false;">
			<table height="20" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" class="message-header-color">
						<div>
							<div class="div-float" style="width: 5px;">&nbsp;</div>
							<div class="div-float im_search_input_div"><input type="text" id="userName" name="userName" class="im_search_input" maxlength="150" value="${userName}" onkeydown="onEnterPress('${isRoot}', '${queryType}', '${queryValue}')"/><input type="button" class="im_search_input_btn" onclick="showByName('${isRoot}', '${queryType}', '${queryValue}')"/></div>
							<div class="div-float">
							<c:if test="${isShowMemberMenu && currentUser.internal}">
								&nbsp;&nbsp;&nbsp;&nbsp;
						    	<img src="/seeyon/apps_res/v3xmain/images/message/16/home.gif" align="absmiddle" alt="<fmt:message key='message.button.myDepartment' />" class="cursor-hand" onclick="showMyDeptUser()" />
								&nbsp;&nbsp;
						    	<img src="/seeyon/apps_res/v3xmain/images/message/16/relate.gif" align="absmiddle" alt="<fmt:message key='org.RelatePeople.label' />" class="cursor-hand" onclick="showMyRelate()" />
							</c:if>
						    	&nbsp;&nbsp;
						    	<input id="showOfflineList" type="checkbox" class="cursor-hand"/><fmt:message key="message.checkbox.showOfflineList" bundle="${wim}"/>
							</div>
						</div>
				    </td>
				</tr>
			</table>
		</form>
	</div>
	<div region="center" border="false" style="overflow-y:auto">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sort" onclick="sortColumn(event, true)">
						<thead>
							<tr class="sort">
								<td width="30" align="center">&nbsp;</td>
								<td width="25%" type="String"><fmt:message key="org.member.name.title" /></td>
								<td width="30%" type="String"><fmt:message key="${isRoot ? 'org.account.label' : 'org.department.label'}" /></td>
								<td width="${canMoveToOffline ? '30%' : '40%'}" type="String"><fmt:message key="org.post.label" /></td>
								<c:if test="${canMoveToOffline}">
									<td width="10%" align="center"><fmt:message key="message.moveToOffline.label"/></td>
								</c:if>
							</tr>
						</thead>
						<tbody>
							<fmt:message key="message.tip.leave.label" var="leaveTip" />
							<c:forEach items="${onlineUserList}" var="user">
								<c:set value="${v3x:checkLevelScope(currentUserId, user.id)}" var="isCanAccess"/>
								<c:choose>
									<c:when test="${isShowMemberMenu && isCanAccess && user.id != currentUserId}">
										<c:set value="" var="onDblclick" />
										<c:set value="" var="onClick"/>
										<c:if test="${!v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}">
											<c:set value="selectListRow(this);" var="onClick"/>	
										</c:if>
									</c:when>
									<c:otherwise>
										<c:set value="" var="onDblclick" />
										<c:set value="" var="onClick"/>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${user.id != currentUserId}">
										<c:set var="onmouseover" value="showEditImage('${user.id}')"/>
										<c:set var="onmouseout" value="removeEditImage('${user.id}')"/>
									</c:when>
									<c:otherwise>
										<c:set var="onmouseover" value=""/>
										<c:set var="onmouseout" value=""/>
									</c:otherwise>
								</c:choose>
								<tr height="25" class="sort cursor-hand" onclick="${onClick}" ondblclick="${onDblclick}" onmouseover="${onmouseover}" onmouseout="${onmouseout}">
									<td align="center" class="sort">
										<c:set var="pcOnline" value="inline-block state_online_${v3x:getEnumOrdinal(user.onlineSubState)}" />
										<span class="${(!user.fromM1) ? pcOnline : 'mobileOnline inline-block'}" style="margin-bottom: 0px;"></span>
									</td>
									<td class="sort">
										<c:choose>
											<c:when test="${isRoot}">
												${v3x:toHTMLWithoutSpaceEscapeQuote(user.name)}
											</c:when>
											<c:otherwise>
												${isShowAccountShortName? v3x:showMemberName(user.id) : v3x:toHTMLWithoutSpaceEscapeQuote(user.name)}
											</c:otherwise>
										</c:choose>
									</td>
									<c:choose>
										<c:when test="${isRoot}">
											<td class="sort">
												${v3x:getAccount(user.loginAccountId).shortName}&nbsp;
											</td>
										</c:when>
										<c:otherwise>
											<td class="${user.pluralist? 'proxy-true' : ''} sort">
												${not empty user.departmentName ? user.departmentName : ''}&nbsp;
											</td>
										</c:otherwise>
									</c:choose>
									<td class="${user.pluralist? 'proxy-true' : ''} sort">
										${(not empty user.postName && user.postName != 'null') ? user.postName: ''}&nbsp;
									</td>
									<c:if test="${canMoveToOffline}">
										<td align='center' class="sort">
										<c:choose>
											<c:when test="${currentUser.systemAdmin || currentUser.groupAdmin || (currentUser.administrator && currentUser.loginAccount == user.loginAccountId)}">
												<a class='link-blue' href="${onlineURL}?method=moveMemberToOffline&loginName=${user.loginName}&currentAccountId=${currentAccountId}"><fmt:message key="message.moveToOffline.label" /></a>
											</c:when>
											<c:otherwise>
												&nbsp;
											</c:otherwise>
										</c:choose>
										</td>
									</c:if>
								</tr>
							</c:forEach>
							
							<c:forEach items="${offlineUserList}" var="offuser">
								<c:set value="${v3x:checkLevelScope(currentUserId, offuser.id)}" var="isCanAccess"/>
								<c:choose>
									<c:when test="${isShowMemberMenu && isCanAccess && offuser.id != currentUserId}">
										<c:set value="" var="onDblclick" />
										<c:set value="" var="onClick"/>
										<c:if test="${!v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}">
											<c:set value="selectListRow(this);" var="onClick"/>	
										</c:if>
									</c:when>
									<c:otherwise>
										<c:set value="" var="onDblclick" />
										<c:set value="" var="onClick"/>
									</c:otherwise>
								</c:choose>
								<c:set var="onmouseover" value="showEditImage('${offuser.id}')"/>
								<c:set var="onmouseout" value="removeEditImage('${offuser.id}')"/>
								<tr id="off${offuser.id}" height="25" class="sort cursor-hand offline" onclick="${onClick}" ondblclick="${onDblclick}" onmouseover="${onmouseover}" onmouseout="${onmouseout}">
									<td align="center" class="sort">
										<span class="pcOffline"></span>
									</td>
									<td class="sort">
										<c:choose>
											<c:when test="${isRoot}">
												${v3x:toHTMLWithoutSpaceEscapeQuote(offuser.name)}
											</c:when>
											<c:otherwise>
												${isShowAccountShortName? v3x:showMemberName(offuser.id) : v3x:toHTMLWithoutSpaceEscapeQuote(offuser.name)}
											</c:otherwise>
										</c:choose>
									</td>
									<c:choose>
										<c:when test="${isRoot}">
											<td class="sort">
												${v3x:getAccount(offuser.loginAccountId).shortName}&nbsp;
											</td>
										</c:when>
										<c:otherwise>
											<td class=" sort">
												${v3x:toHTML(offuser.departmentName)}&nbsp;
											</td>
										</c:otherwise>
									</c:choose>
									<td class=" sort">
										${(not empty offuser.postName && offuser.postName != 'null') ? offuser.postName: ''}&nbsp;
									</td>
									<c:if test="${canMoveToOffline}">
										<td align='center' class="sort">
											&nbsp;
										</td>
									</c:if>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>
			<c:if test="${isRoot && !isRootQuery}">
				<tr><td align="center"><br/><span style="font-size: 20; color: #a0a0a0;"><fmt:message key="select.condition.search"/></span></td></tr>
			</c:if>
		</table>
	</div>
</body>
</html>