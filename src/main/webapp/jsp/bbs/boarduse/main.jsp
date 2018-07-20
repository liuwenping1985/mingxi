<!-- 此页面暂废止不用 commented by Meng Yang 2009-05-12 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
<script type="text/javascript">
window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}

<c:choose>
		<c:when test="${group=='group'}">
			//getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(24);
		</c:when>
		<c:otherwise>
			//getA8Top().showLocation(701);
		</c:otherwise>
</c:choose>

function showBoardArticle(boardId){
	 var requestCaller = new XMLHttpRequestCaller(this, "ajaxBbsBoardManager", "isBoardExist", false);
	 requestCaller.addParameter(1, "Long", boardId);
	 var ds = requestCaller.serviceRequest();
	 if(ds=='false'){
	 	alert("此讨论板块已被管理员删除!");
	 	window.location.reload(true);
	 	return;
	 }
	 location.href = "${detailURL}?method=listBoardArticle&id="+boardId+"&group=${group}";
}
</script>
</head>
<body class="padding5" style="overflow: auto;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
      <td valign="bottom" height="28" class="tab-tag">
		<div class="div-float">
			<div id="Tag0_left" class="tab-tag-left-sel"></div>
			<div id="Tag0_middle" class="tab-tag-middel-sel" onclick="cursorTag(0)"><fmt:message key="bbs.latest.post.label" /></div>			
			<div id="Tag0_right" class="tab-tag-right-sel"></div>
			<div class="tab-separator"></div>
			<div id="Tag1_left" class="tab-tag-left"></div>
			<div id="Tag1_middle" class="tab-tag-middel" onclick="cursorTag(1)"><fmt:message key="bbs.board.label.label" /></div>
			<div id="Tag1_right" class="tab-tag-right"></div>
		</div>
		</td>
		<td class="tab-tag">
			<div class="div-float-right">
				<a href="${detailURL}?method=listAllElite&group=${group}" class="hyper_link2">[<fmt:message key="bbs.see.HavingBoard.elite.label" />]</a>
			</div>
		</td>
	</tr>
	<tr id="content0">
	    <td valign="top" class="tab-body-bg" height="100%" style="padding: 0px;" colspan="2">
	    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="webfx-menu-bar-gray" height="25" width="100%">
					<form action="${detailURL}" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
						<input type="hidden" value="listLatestFiveArticleAndAllBoard" name="method">
						<input type="hidden" name="group" value="${group}">
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
				<td height="100%" valign="top">
				<div class="scrollList">
				<form action="" name="articleForm" id="articleForm" method="post" onsubmit="return false" style="margin: 0px">
				<v3x:table htmlId="pending" data="articleModellist" var="col">
					<v3x:column width="30%" label="common.subject.label" className="cursor-hand sort" hasAttachments="${col.attachmentFlag}" alt="${col.articleName}" onClick="location.href='${detailURL}?method=showPost&articleId=${col.id}&resourceMethod=listLatestFiveArticleAndAllBoard&group=${group}'">
						${bbs:showSubject(col, 40, pageContext)}
					</v3x:column>
					<v3x:column width="15%" label="bbs.board.label" value="${bbs:showBoardName(col)}" maxLength="18" symbol="..."
					 href="${detailURL}?method=listBoardArticle&id=${col.board.id}&group=${group}" />
					<v3x:column width="15%" label="common.issuer.label" value="${v3x:showOrgEntitiesOfIds(col.issueUser, 'Member', pageContext)}" />
					<v3x:column width="18%" align="left" label="common.issueDate.label">
						<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
					</v3x:column>
					<v3x:column width="10%" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
					<v3x:column width="12%" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
				</v3x:table>
				</form>
				</div>
				</td>
			</tr>
		</table>
	</td>
	</tr>
	<tr id="content1" style="display:none;">
		<td valign="top" class="tab-body-bg" height="100%" style="padding: 0px;" colspan="2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div class="scrollList">
						<form name="fm" method="post" action="" onsubmit="">
						<v3x:table htmlId="pending" data="boardModelList" var="col2" showPager="false" showHeader="true">
							<c:choose>
								<c:when test="${col2.otherAccount == true}">
									<c:set value="${detailURL}?method=listOtherAccountBoardArticle&group=${group}" var="href" />
								</c:when>
								<c:otherwise>
									<c:set value="${detailURL}?method=listBoardArticle&id=${col2.id}&group=${group}" var="href" />
								</c:otherwise>
							</c:choose>
							<v3x:column width="50%" type="String" label="bbs.board.label" className="cursor-hand sort" onClick="showBoardArticle('${col2.id}');">
								<div title="${col2.boardName}${col2.boardDescription!=null? ':&#13;':''}${col2.boardDescription}">
									<span class="text-blue"><b>${v3x:getLimitLengthString(col2.boardName,20,"...")}</b></span>&nbsp;&nbsp;
									<span>${v3x:getLimitLengthString(col2.boardDescription, 50, '...')}</span>
								</div>
							</v3x:column>
							<v3x:column width="15%" type="Number" align="center" label="bbs.subject.number.label" value="${col2.articleNumber}">
							</v3x:column>
							<v3x:column width="15%" type="Number" href="${detailURL}?method=listBoardElite&id=${col2.id}"
							 value="${col2.elitePostNumber}" align="center" label="bbs.elite.number.label" />
							<c:set value="${v3x:showOrgEntitiesOfIds(v3x:joinDirectWithSpecialSeparator(col2.board.admins, ','), 'Member', pageContext)}" var="admins" />
							<v3x:column label="bbs.admin.label" alt="${admins}" value="${admins}" maxLength="20" symbol="..." />
						</v3x:table>
						</form>
						</div>
					</td>
				</tr>
			</table>
		</td>
		</tr>
	</table>
</body>
</html>
