<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>
<script>
function articleDetail(articleId){
	var acturl = "${detailURL}?method=showPost&articleId="+articleId+"&&resourceMethod=listBoardElite&boardId=${param.boardId}&group=${group}";
	openWin(acturl);
}
</script>
</head>
<body scroll="no" class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
		<td width="100%" height="40" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line" height="40">
		        <td class="page2-header-bg">${board.name}--<fmt:message key="bbs.board.label"/><fmt:message key="bbs.elite.post.label"/></td>
		        <td class="page2-header-line " align="right">
			        <div class="div-float-right">
					<img src="<c:url value='/apps_res/bbs/images/arrow.gif'/>"> <fmt:message key="bbs.admin.label" />: ${v3x:showOrgEntitiesOfIds(v3x:joinDirectWithSpecialSeparator(board.admins, ','), 'Member', pageContext)}
					&nbsp;&nbsp;&nbsp;&nbsp;
					</div>
		        </td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table align="center" width="100%" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="webfx-menu-bar page2-list-header">
						<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="<c:out value='${param.method}' />" name="method"> 
							<input type="hidden" name="id" value="${board.id}">
							<input type="hidden" name="_spage" value="${param._spage}"> 
							<input type="hidden" name="group" value="${group}"> 
							<div class="div-float-right">
								<div class="div-float">
								<select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
									<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
									<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
									<option value="issueUser"><fmt:message key="common.issuer.label" bundle="${v3xCommonI18N}"/></option>
									<option value="issueTime"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}"/></option>
								</select></div>
								<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
								<div id="issueUserDiv" class="div-float hidden"><input type="text" name="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
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
			</table>	
		</td>
	</tr>	
</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="fm" method="post" action="" onsubmit="">
		<v3x:table htmlId="pending" data="${boardElite}" var="col" isChangeTRColor="false" showHeader="true">
			<v3x:column width="36%" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag}">
				<a href="javascript:articleDetail('${col.id}');" class="hyper_link1" title="${col.articleName}" >
					${bbs:showSubject(col, 40, pageContext)}
				</a>
			</v3x:column>
			<c:set value="${v3x:currentUser().id}" var="currentUserId" />
			<c:choose>
					<c:when test="${col.anonymousFlag && currentUserId!=col.issueUser}">
						<fmt:message key="anonymous.label" var="createrUser"/>
					</c:when>
					<c:otherwise>
						<c:set value="${v3x:showOrgEntitiesOfIds(col.issueUser, 'Member', pageContext)}" var="createrUser"/>
					</c:otherwise>
			</c:choose>
			<v3x:column width="16%" type="String" label="common.issuer.label" maxLength="18" symbol="..." value="${createrUser}"/>
			<v3x:column width="12%" type="Number" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
			<v3x:column width="12%" type="Number" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
			<v3x:column type="Date" align="left" label="common.issueDate.label">
				<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
			</v3x:column>
		</v3x:table>
		</form>
    </div>
  </div>
</div>
<script type="text/javascript">
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>
