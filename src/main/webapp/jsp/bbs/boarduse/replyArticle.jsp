<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.v3x.common.constants.Constants"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<script language="javascript">
function replyPost2(fromPigeonhole){
	if(checkForm(document.replyForm)){
		replyPost(fromPigeonhole);
	}
}
var editorStartupFocus = false;
var editorDontResize = true;
</script>
<style type="">
.my_border{
  border-bottom: 0px solid #b6b6b6;
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
<input name="fromPigeonhole" id="fromPigeonhole" type="hidden" value="${v3x:toHTML(param.fromPigeonhole)}">
<input name="fromIsearch" id="fromIsearch" type="hidden" value="${v3x:toHTML(param.fromIsearch)}">

<table align="center" cellpadding="0" cellspacing="0" class="bbs-view-border-top bbs-view-title-bar page2-list-border my_border" width="100%" height="100%">	
	<tr>
		<td height="23" class="bbs-view-title-bar" colspan="3">&nbsp;&nbsp;<fmt:message key="quick.reply.label" /></td>
	</tr>
	<tr>
		<td width="80px" height="24" align="right" class="tbCellTemp bbs-bg"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;</td>
		<td  height="24" class="bbs-bg" >
			<c:choose>
				<c:when test="${replyOrEdit}">
					<input id="replyName" name="replyName" maxlength="80" value="<c:out value='${replyPost.replyName}' escapeXml='true' />" style="width: 40%;" class="input-100per bbs-readonly" readonly>
				</c:when>
				<c:otherwise>
					<input id="replyName" name="replyName"  maxlength="80"  value="<c:out value='RE：${article.articleName}' escapeXml='true' />" style="width: 40%;" inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />"  validate="notNull"/>
				</c:otherwise>
			</c:choose>
			<c:if test="${article.anonymousReplyFlag && board.anonymousReplyFlag==0}">
				<label for="b"><input type="checkbox" name="anonymous" id="b"><fmt:message key="anonymous.reply" /></label>
			</c:if>
			<c:if test="${article.messageNotifyFlag}">
				&nbsp;&nbsp;&nbsp;&nbsp; 
				<label for="a">
					<input type="checkbox" name="messageNotifyFlag_checkbox" id="a" checked />
					<fmt:message key="send.message.to.issue.user.label"/>
				</label>
			</c:if>
			<c:if test="${v3x:getBrowserFlagByUser('HtmlEditer', v3x:currentUser())==true}">
				<span onclick="javascript:insertAttachment()" class="like-a">[<fmt:message key='common.toolbar.insertAttachment.label' bundle="${v3xCommonI18N}" />]</span>
			</c:if>
		</td>
		<td width="80px" height="24" class="bbs-bg"></td>
	</tr>
	<tr id="attachmentTR" style="display:none;">
		<td width="80px" nowrap="nowrap" height="26"  class="bbs-bg tbCellTemp"  valign="middle" align="right">
			<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;
		</td>
		<td valign="top" height="26" class="bbs-bg">
			<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
			<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true"/>
		</td>
		<td width="80px" height="24" class="bbs-bg"></td>
	</tr>  
	<tr>
		<td width="80px" align="right" class="bbs-bg tbCellTemp">
			<fmt:message key="bbs.content.label"/>:&nbsp;&nbsp;
		</td>
		<td height="250px">
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
		<td width="80px" height="24" class="bbs-bg"></td>
	</tr>
	<tr class="padding_tb_5" align="right">
		<td width="80px" class="bbs-bg">&nbsp;</td>
		<td height="25px" class="bbs-bg">
			<c:choose>
				<c:when test="${replyOrEdit}">
					<input type="button" id="reply" name="reply" value="<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />" onclick="modifyPost('${param.pageSizePara}', '${param.nowPagePara}' ,'${v3x:toHTML(param.fromPigeonhole)}')" class="button-default-2">
				</c:when>
				<c:otherwise>
					<input type="button" id="reply" name="reply" value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>" onclick="javascript:replyPost2('${v3x:toHTML(param.fromPigeonhole)}')" class="button-default-2">
				</c:otherwise>
			</c:choose>
		</td>
		<td width="80px" height="24" class="bbs-bg"></td>
	</tr>
</table>
</form>
<script type="text/javascript">
	isFormSumit = true;
</script>
</body>
</html>