<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
</head>
<body scroll="no" style="overflow: no">
<form name="fm" method="post" action="" onsubmit="return checkForm(this)">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="bbs.detailInfo.label"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" width="100%">
			<div class="categorySet-body">
				<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="bg-gray" width="12%" nowrap>
							<fmt:message key="common.subject.label"  bundle="${v3xCommonI18N}"/>:
						</td>
						<td class="new-column" width="38%" nowrap>
							<input name="name" type="text" value="${article.articleName}" class="input-100per , bbs-readonly" readonly="readonly">
						</td>
						<td class="bg-gray" width="12%" nowrap>
							<fmt:message key="common.issuer.label" bundle="${v3xCommonI18N}" />:
						</td>
						<td class="new-column" width="38%" nowrap>
							<c:set value="${v3x:currentUser().id}" var="currentUserId" />
							<c:choose>
								<c:when test="${article.anonymousFlag && currentUserId!=article.issueUserID}">
									<fmt:message key="anonymous.label" var="createrUser"/>
								</c:when>
								<c:otherwise>
									<c:set value="${issueUserName}" var="createrUser"/>
								</c:otherwise>
							</c:choose>
							<input name="name" type="text" value="${createrUser}" class="input-100per , bbs-readonly" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="bg-gray" nowrap>
							<fmt:message key="common.issueScope.label"  bundle="${v3xCommonI18N}"/>:
						</td>
						<td class="new-column" nowrap>
							<input name="name" type="text" value="${issueArea}" class="input-100per , bbs-readonly" readonly="readonly">
						</td>
						<td class="bg-gray" nowrap>
							<fmt:message key="common.issueDate.label"   bundle="${v3xCommonI18N}"/>:
						</td>
						<td class="new-column" nowrap>
							<input name="name" type="text" value="<fmt:formatDate value='${article.issueTime}' pattern='${dataPattern}'/>" class="input-100per , bbs-readonly" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="bg-gray" nowrap>
							<fmt:message key="bbs.clicknumber.label" />:
						</td>
						<td class="new-column" nowrap>
							<input name="name" type="text" value="${article.clickNumber}" class="input-100per , bbs-readonly" readonly="readonly">
						</td>
						<td class="bg-gray" nowrap>
							<fmt:message key="bbs.sourceFlag.label"/>:
						</td>
						<td class="new-column" nowrap>
							<c:choose>
								<c:when test="${article.resourceFlag==0}">
									<input name="name" type="text" value="<fmt:message key="bbs.showArticle.Noth"/>" class="input-100per , bbs-readonly" readonly="readonly">
								</c:when>
								<c:when test="${article.resourceFlag==1}">
									<input name="name" type="text" value="<fmt:message key="bbs.showArticle.Author"/>" class="input-100per , bbs-readonly" readonly="readonly">
								</c:when>
								<c:when test="${article.resourceFlag==2}">
									<input name="name" type="text" value="<fmt:message key="bbs.showArticle.Transmit"/>" class="input-100per , bbs-readonly" readonly="readonly">
								</c:when>
							</c:choose>
						</td>
					</tr>
					<tr>
						<td  class="bg-gray" nowrap>
							<fmt:message key="bbs.content.label"/>:
						</td>
						<td  class="new-column" colspan="3">
							<textarea rows="5" readonly="readonly" class="input-100per , bbs-readonly">${article.content}</textarea>
						</td>
					</tr>
				</table>
			</div>		
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom"></td>
	</tr>
</table>
</form>
</body>
</html>