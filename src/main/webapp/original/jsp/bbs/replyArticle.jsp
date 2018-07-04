<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.ctp.common.constants.Constants"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../bbs/header.jsp"%>
<script language="javascript">
var editorStartupFocus = false;
var editorDontResize = true;
</script>
<style type="">
.my_border{
  border-bottom: 0px solid #b6b6b6;
}
#cke_content , .cke_wysiwyg_frame{
	width:720px !important;
}
</style>
</head>
<body class="bbs-bg">
<form name="replyForm" id="replyForm" method="post">
<input type="hidden" name="articleId" value="${article.id}">
<input type="hidden" name="replyUserId" value="${v3x:currentUser().id}">
<input type="hidden" name="resourceMethod" value="${resourceMethod}">
<input type="hidden" name="boardId" id="boardId" value="${board.id}">
<input type="hidden" name="postId" id="postId" value="${replyPost.id}">
<input type="hidden" name="useReplyId" value="${useReplyId}">  <%-- 引用他人回复进行回复时，被引用回复的ID --%>
<input type="hidden" name="useReplyFlag" value="${useReplyFlag}">  <%-- 回复类型 --%>
<input type="hidden" name="isCollCube" value="${v3x:toHTML(isCollCube)}">  <%-- 是否来自协同立方 --%>
<input name="group" type="hidden" value="${group}">
<input name="fromIsearch" id="fromIsearch" type="hidden" value="${v3x:toHTML(param.fromIsearch)}">

<table align="center" cellpadding="0" cellspacing="0" class="bbs-view-title-bar page2-list-border my_border" width="720px" height="100%">
	<tr>
		<td>
        <div style="overflow: auto;">
			 <c:choose>
			  	<c:when test="${v3x:getBrowserFlagByUser('HtmlEditer', v3x:currentUser())==true}">
			  		<v3x:editor htmlId="content" content="${replyPost.content}" type="HTML" barType="BbsSimple" category="<%=ApplicationCategoryEnum.bbs.getKey()%>" />
			  	</c:when>
			  	<c:otherwise>
			  		<textarea id="content" name="content" style="height: 100%;width: 100%">${replyPost.content}</textarea>
			  		<input type='hidden' name='bodyType' id='bodyType' value='HTML'>
					<input type="hidden" name="bodyCreateDate" id="bodyCreateDate" value="">
					<input id="contentNameId" type="hidden" name="contentName" value="">	
			  	</c:otherwise>
			  </c:choose>
              </div>
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
	isFormSumit = true;
</script>
</body>
</html>