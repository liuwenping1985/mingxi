<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
<script type="text/javascript">
	function issueNewPost(){
		var boardId = document.boardForm.boardId.value;
		location.href="${detailURL}?method=issuePost&boardId=" + boardId +"&group=${group}";
	}
	
	<c:choose>
		<c:when test="${group=='group'}">
			//getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(24);
		</c:when>
		<c:otherwise>
			//getA8Top().showLocation(701);
		</c:otherwise>
	</c:choose>
</script>
</head>
<body style="padding:5px;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td valign="bottom" height="26" class="tab-tag" colspan="2">
			<form action="" name="boardForm" id="boardForm" method="post" style="margin: 0px">		
			<input type="hidden" name="boardId" value="${param.id}"> 
			<input type="hidden" name="group" value="${group}"> 
			<input type="hidden" name="boardName" id="boardName" value="${board.name}"> 						 
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel">
					<fmt:message key="bbs.see.board.seediscuss.label" />
				</div>
			<div class="tab-tag-right-sel"></div>
			<div class="tab-separator"></div>
				<div class="bbs-div-float-right">
				<c:if test="${dept!=dept }">
			 		<img src="<c:url value='/apps_res/bbs/images/arrow.gif'/>"> 
			 			<fmt:message key="bbs.admin.label" />: ${v3x:showOrgEntitiesOfIds(v3x:joinDirectWithSpecialSeparator(board.admins, ','), 'Member', pageContext)}
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="${detailURL}?method=listBoardElite&id=${param.id}&group=${group}"> [<fmt:message key="bbs.see.board.elite.label" />]</a>&nbsp; 
				</c:if>
					<a href="javascript:refreshIt()" class="hyper_link2"> [<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]</a>&nbsp; 
				<c:if test="${dept!='dept' }">
					<c:choose>
						<c:when test="${ group!=null }">
							<a href="${detailURL}?method=listGroupBoard" class="hyper_link2"> [<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]</a>
						</c:when>
						<c:otherwise>
							<a href="${detailURL}?method=listLatestFiveArticleAndAllBoard&group=${group}" class="hyper_link2"> [<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]</a>
						</c:otherwise>
					</c:choose>
				</c:if>	
				<c:if test="${dept=='dept' }">
                    <%--TODO yangwulin 2012-11-28 javascript:getA8Top().contentFrame.topFrame.back() --%>
					<a href="javascript:getA8Top().back()" class="hyper_link2"> [<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]</a>
				</c:if>
			 	</div>
			</form>
		</td>
	</tr>
	<tr>
	<td class="tab-body-border">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	 <tr>
		<td height="26" width="50%">
	    	<script type="text/javascript">
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}", "gray");
			<c:if test="${issueAuthFlag}">
		    	myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='bbs.issue.post.label' />", "javascript:issueNewPost()", "<c:url value='/common/images/toolbar/new.gif'/>"));
			</c:if>
	    	document.write(myBar);
	    	document.close();
	    	</script>
    	</td>
    	<td class="webfx-menu-bar-gray" width="50%">
			<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method"> 
				<input type="hidden" name="id" value="${board.id}">
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
		<td colspan="2" valign="top">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">				
					<tr>
						<td>
							<div class="scrollList">
							<form name="fm" method="get" action="" onsubmit="">
								<v3x:table htmlId="pending" data="${boardArticle}" isChangeTRColor="false" var="col">
									<v3x:column width="32%" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag}">
										<a href="${detailURL}?method=showPost&articleId=${col.id}&resourceMethod=listBoardArticle&group=${group}"
											class="titleDefaultCss" title="${v3x:toHTML(col.articleName)}">
											${bbs:showSubject(col, 40, pageContext)}
										</a>
									</v3x:column>
									<v3x:column width="12%" type="String" label="common.issuer.label" maxLength="18" symbol="..." value="${v3x:showOrgEntitiesOfIds(col.issueUser, 'Member', pageContext)}" />
									<c:if test="${fn:length(col.issueArea)>0}">
										<c:set value="${v3x:showOrgEntities(col.issueArea, 'moduleId', 'moduleType', pageContext)}" var="issueArea" />
									</c:if>
									<c:if test="${fn:length(col.issueArea)==0}">
										<c:set value="${v3x:showOrgEntitiesOfIds(sessionScope['com.seeyon.current_user'].departmentId, 'Department', pageContext)}" var="issueArea" />
									</c:if>
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
  </td>
 </tr>
</table>
<script type="text/javascript">
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>