<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="2" height="86">
			<img height="86" width="390" src="<c:url value='/apps_res/bbs/images/back.gif'/>">
		</td>
	</tr>
	<tr>
		<td valign="bottom" height="18" align="right" >
			<a href="${detailURL}?method=listOtherAccountBoardArticle&group=${group}" class="hyper_link2">[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]</a>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="bbs-table">
				<tr>					
					<td class="bbs-title-bar" height="26">
						<div class="bbs-div-float-left"><fmt:message key="bbs.otherAccount.label" />--<fmt:message key="bbs.board.label" /><fmt:message key="bbs.elite.post.label" /></div>
					</td>
					<td class="bbs-title-bar">
						<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="<c:out value='${param.method}' />" name="method"> 
							<input type="hidden" name="_spage" value="${param._spage}"> 
							<input type="hidden" name="group" value="${group}"> 
							<div class="div-float-right">
								<div class="div-float">
								<select name="condition"   id="condition" onChange="showNextCondition(this)" class="condition">
									<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
									<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
									<option value="issueUser"><fmt:message key="common.issuer.label" bundle="${v3xCommonI18N}"/></option>
									<option value="issueTime"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}"/></option>
								</select></div>
								<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
								<div id="issueUserDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
								<div id="issueTimeDiv" class="div-float hidden"><input
									type="text" name="textfield" class="input-date"
									onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
									readonly> - <input type="text" name="textfield1" class="input-date"
									onclick="whenstart('${pageContext.request.contextPath}',this,720,265);" readonly></div>
								<div onclick="javascript:doSearch()" class="condition-search-button , button-font-color"></div>
							</div>
						</form>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="scrollList">
							<form name="fm" method="post" action="" onsubmit="">
							<v3x:table htmlId="pending" data="${boardElite}" var="col" isChangeTRColor="false" showHeader="true">
								<v3x:column width="32%" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag}">
									<a href="${detailURL}?method=showPost&articleId=${col.id}&resourceMethod=listOtherAccountBoardElite&boardId=${param.boardId}&group=${group}"
										class="hyper_link1" title="${col.articleName}">
										${bbs:showSubject(col, 40, pageContext)}
									</a>
								</v3x:column>
								<c:set value="${v3x:getOrgEntity('Account', col.accountId).shortname}" var="accountName" />
								<v3x:column width="14%" type="String" label="bbs.board.label" value="(${accountName})${col.board.name}" maxLength="15" symbol="..."
									 href="${detailURL}?method=listBoardArticle&id=${col.board.id}&group=${group}"  />
								<!-- 对外单位的新闻是否匿名进行判断, 如果是匿名发起且当前查看用户不为发起者, 显示为匿名 -->
								<c:set value="${v3x:currentUser().id}" var="currentUserId" />
								<c:choose>
										<c:when test="${col.anonymousFlag && currentUserId!=col.issueUser}">
											<fmt:message key="anonymous.label" var="memberName"/>
										</c:when>
										<c:otherwise>
											<c:set value="${bbs:showName(col, pageContext)}" var="memberName" />
										</c:otherwise>
								</c:choose>
								<v3x:column width="12%" type="String" label="common.issuer.label" maxLength="15" symbol="..." value="${memberName}" />
								<v3x:column width="10%" type="Number" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
								<v3x:column width="12%" type="Number" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
								<v3x:column type="Date" label="common.issueDate.label">
									<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
								</v3x:column>
							</v3x:table>
							</form>
						</div>
					</td>
				</tr>				
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>
