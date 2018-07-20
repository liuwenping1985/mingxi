<%-- 废弃jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.v3x.common.constants.Constants"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title><fmt:message key='bbs.reply.edit.label' /></title>
<script type="text/javascript">
function editReply(){
	var oEditorFCK = FCKeditorAPI.GetInstance('content');  
 	var content = oEditorFCK.EditingArea.Document.body.innerHTML;
 	if(content.length > 1024){
 		alert(v3x.getMessage("BBSLang.bbs_reply_content_too_long"))
 	 	return false;
 	}
	saveAttachment();
	
	document.getElementById('save').disabled = true;
	document.getElementById('insert').disabled = true;
    isFormSumit = true;
	document.replyPostForm.submit();
}
</script>
</head>
<body scroll="no">
<form name="replyPostForm" action="${detailURL}?method=editReply&postId=${replyPost.id}&articleId=${article.id}&boardId=${board.id}&group=${group}&pageSizePara=${param.pageSizePara}&nowPagePara=${param.nowPagePara}" id="replyForm" method="post" style="margin: 0px" target="emptyIframe">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="60" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
			     <tr class="page2-header-line" height="60">
			        <td width="80" height="60"><img src="<c:url value="/apps_res/bbs/images/bbsHeader.gif" />" width="80" height="60" /></td>
			        <td class="page2-header-bg"><fmt:message key="bbs.reply.edit.label" /></td>
			        <td class="page2-header-line page2-header-link" align="right"></td>
				 </tr>
			 </table>
		</td>
	</tr>
	<tr>
		<td style="padding: 5px 5px 0 5px;">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
				<tr>
					<td colspan="4" height="22" valign="top">
						<script type="text/javascript">
					    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
					    	
					    	var insert = new WebFXMenu;
							insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
							
					    	myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "editReply()", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));
					    	myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
					    	myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "javascript:self.history.back();", "<c:url value='/common/images/toolbar/back.gif'/>", "",null ));
					    	
					    	document.write(myBar);
					    	document.close();
				    	</script>
			    	</td>
				</tr>
				<tr class="bg-summary lest-shadow">
					<td width="9%" height="24" class="bg-gray">
						<fmt:message key="bbs.board.label"/>
					</td>
					<td width="40%">
						<input value="<c:out value='${board.name}' escapeXml='true' />" class="input-100per , bbs-readonly" readonly />
					</td>
					<td class="bg-gray" width="11%" height="24">
						<fmt:message key="bbs.reply.user.label" />
					</td>
					<td width="40%" class="bg-column">
						<input value="<c:out value='${replyUserName}' escapeXml='true' />" class="input-100per , bbs-text-marge , bbs-readonly" readonly />
					</td>
				</tr>
				<tr class="bg-summary">
					<td nowrap="nowrap" height="24" class="bg-gray" >
						<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />
					</td>
					<td nowrap="nowrap">
						<input name="replyName" value="<c:out value='${replyPost.replyName}' escapeXml='true' />" class="input-100per bbs-readonly" readonly/>
					</td>
					<td nowrap="nowrap" class="bg-gray">
					</td>
					<td  nowrap="nowrap">
						<c:if test="${article.anonymousReplyFlag}">
							<label for="b">
								<input type="checkbox" name="anonymousReplyFlag_checkbox" id="b" disabled ${replyPost.anonymousFlag == true ? 'checked' : ''}><fmt:message key="anonymous.reply" />
							</label>
						</c:if>
					
						<c:if test="${article.messageNotifyFlag}">
							<label for="a">
								<input type="checkbox" name="messageNotifyFlag_checkbox" id="a" checked /><fmt:message key="send.message.to.issue.user.label" />
							</label>
						</c:if>
					</td>
				</tr>
				<tr id="attachmentTR" class="bg-summary , bbs-attachment-padding" style="display:none;">
			      <td nowrap="nowrap" height="18" class="bg-gray , bbs-attachment-padding" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
			      <td colspan="8" valign="top">
					<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
					<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
			      </td>
			  </tr>
				<tr>
					<td colspan="4" height="6" class="bg-b">
					</td>
				</tr>
				<tr valign="top">
					<td colspan="4">
						<v3x:editor htmlId="content" content="${replyPost.content}" type="HTML" category="<%=ApplicationCategoryEnum.bbs.getKey()%>" />
					</td>
				</tr>		
			</table>
		</td>
	</tr>
</table>
</form>
<iframe name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>
