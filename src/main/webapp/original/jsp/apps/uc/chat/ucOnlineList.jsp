<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
		//动态调整页面布局大小
		/* window.parent.addResizeAction(); */
		$("#showOfflineList").attr("checked","${param.showoffline}");
		if(${isRoot && !isRootQuery}){
			$("#showOfflineList").attr("disabled",true);
			$("#showOfflineList").attr("checked",false);
		}
		$("#showOfflineList").click(function(){
			showOfflineList();
		});
	});
	
	/**
	 * 按姓名搜索在线人员列表-回车
	 */
	function ucOnEnterPress(isRoot, queryType, queryValue){
		if(v3x.getEvent().keyCode == 13){
			ucShowByName(isRoot, queryType, queryValue);
		}
	}
	
	/**
	 * 按姓名搜索在线人员列表-点击查询按钮
	 */
	function ucShowByName(isRoot, queryType, queryValue){
		var userName = document.userForm.userName.value;
		if(userName.trim() == ""){
			alert(_("V3XLang.index_input_error"));
			return;
		}
		var url = v3x.baseURL + "/uc/chat.do?method=showOnlineUserList&condition=ByName&isRoot=" + isRoot + "&queryType=" + queryType + "&queryValue=" + queryValue + "&userName=" + encodeURI(userName.trim());
		var a = parent.onlineUserListIframe.document;
		a = a.getElementById("showOfflineList");
		if(a && a.checked){
			url += "&showoffline=checked";
		}
		parent.onlineUserListIframe.location.href = url;
	}
</script>
<style>
.panel-body{
overflow:hidden;
}
  .im_search_input#userName, .im_search_input{
    padding: 0 10px;
    outline: 0px;
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
							<div class="div-float im_search_input_div"><input type="text" id="userName" name="userName" class="im_search_input" maxlength="150" value="${userName}" onkeydown="ucOnEnterPress('${isRoot}', '${queryType}', '${queryValue}')"/><input type="button" class="im_search_input_btn" onclick="ucShowByName('${isRoot}', '${queryType}', '${queryValue}')"/></div>
							<div class="div-float">
							<%-- <img src="/seeyon/apps_res/v3xmain/images/message/16/home.gif" align="absmiddle" title="<fmt:message key='message.button.myDepartment' />" alt="<fmt:message key='message.button.myDepartment' />" class="cursor-hand" onclick="showMyDeptUser()"/>
    &nbsp;&nbsp;
      <img src="/seeyon/apps_res/v3xmain/images/message/16/relate.gif" align="absmiddle" title="<fmt:message key='org.RelatePeople.label' />" alt="<fmt:message key='org.RelatePeople.label' />" class="cursor-hand" onclick="showMyRelate()"/>
 --%>
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
								<td width="120" type="String"><fmt:message key="org.member.name.title" /></td>
								<td width="100" type="String"><fmt:message key="${isRoot ? 'org.account.label' : 'org.department.label'}" /></td>
								<td width="${canMoveToOffline ? '30%' : '40%'}" type="String"><fmt:message key="org.post.label" /></td>
								<td width="100">操作</td>
							<!-- <c:if test="${canMoveToOffline}">
									<td width="10%" align="center"><fmt:message key="message.moveToOffline.label"/></td>
								</c:if> -->
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
										<span class="${(user.loginType == 'pc') ? pcOnline : 'mobileOnline inline-block'}" style="margin-bottom: 0px;"></span>
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
												<c:forEach items="${user.loginAccountId}" begin="0" end="0" var="accountId">
                                                  ${v3x:getAccount(accountId).shortName}&nbsp;
                                                </c:forEach>
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
									<td class="${user.pluralist? 'proxy-true' : ''} sort">
										<c:if test="${currentUser.id!=user.id}">
											<a href="javascript:void(0);" onclick="window.parent.connWin.openWinIM('${v3x:toHTMLWithoutSpaceEscapeQuote(user.name)}', '${user.id}@localhost')" >发起交流</a>
										</c:if>
									</td>
									
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
									<td class="${user.pluralist? 'proxy-true' : ''} sort">
										<a href="javascript:void(0);" onclick="window.parent.connWin.openWinIM('${v3x:toHTMLWithoutSpaceEscapeQuote(offuser.name)}', '${offuser.id}@localhost')" >发起交流</a>
									</td>
									
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
<script language="javascript" >
window.onload = function(){
	document.getElementsByTagName("body")[0].style.display = "block";
}
</script>
</html>
