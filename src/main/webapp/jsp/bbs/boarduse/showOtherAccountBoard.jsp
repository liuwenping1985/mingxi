<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
</head>
<body class="tab-body">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td valign="bottom" height="26" class="tab-tag" colspan="2">
			<form action="" name="boardForm" id="boardForm" method="post" style="margin: 0px">		
			<input type="hidden" name="boardId" value="${param.id}"> 
			<input type="hidden" name="group" value="${group}"> 
			<input type="hidden" name="boardName" id="boardName" value="${board.name}"> 						 
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel">
					<a href="#" class="non-a">
						<fmt:message key="bbs.see.board.seediscuss.label" />
					</a>
				</div>
			<div class="tab-tag-right-sel"></div>
			<div class="tab-separator"></div>
				<div class="bbs-div-float-right">
					<a href="${detailURL}?method=listOtherAccountBoardElite&group=${group}" class="hyper_link2"> [<fmt:message key="bbs.see.board.elite.label" />]</a>&nbsp; 
					<a href="javascript:refreshIt()" class="hyper_link2"> [<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]</a>&nbsp; 
					<a href="${detailURL}?method=listLatestFiveArticleAndAllBoard&group=${group}" class="hyper_link2"> [<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]</a>
			 	</div>
			</form>
		</td>
	</tr>
	<tr>
		<td height="26" width="50%">
	    	<script type="text/javascript">
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}", "gray");
	    	document.write(myBar);
	    	document.close();
	    	</script>
    	</td>
    	<td class="webfx-menu-bar-gray" width="50%">
			<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method"> 
				<input type="hidden" name="group" value="${group}"> 
				<input type="hidden" name="_spage" value="${param._spage}"> 
				<div class="div-float-right">
					<div class="div-float">
					<select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
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
		<td class="tab-body-border" colspan="2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">				
					<tr>
						<td>
							<div class="scrollList">
							<form name="fm" method="get" action="" onsubmit="">
								<v3x:table htmlId="pending" data="${boardArticle}" isChangeTRColor="false" var="col">
									<v3x:column width="20%" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag}">
										<a href="${detailURL}?method=showPost&articleId=${col.id}&resourceMethod=listOtherAccountBoardArticle&group=${group}"
											class="hyper_link1" title="${col.articleName}">
											${bbs:showSubject(col, 25, pageContext)}
										</a>
									</v3x:column>
									<c:set value="${v3x:getOrgEntity('Account', col.accountId).shortname}" var="accountName" />
									<v3x:column width="12%" type="String" label="bbs.board.label" value="(${accountName})${col.board.name}" maxLength="15" symbol="..."
									 href="${detailURL}?method=listBoardArticle&id=${col.board.id}&group=${group}" />
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
									<c:set value="${v3x:showOrgEntities(col.issueArea, 'moduleId', 'moduleType', pageContext)}" var="issueArea" />
									<v3x:column width="12%" type="String" label="common.issueScope.label" value="${issueArea}" maxLength="16" symbol="..." />
									<v3x:column width="10%" type="Number" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
									<v3x:column width="16%" type="Number" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
									<v3x:column width="18%" type="Date" label="common.issueDate.label">
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
