<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../header.jsp"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title>${article.subject}</title>
<script type="text/javascript">
<!--
	showAttachment('<c:out value="${article.id}" />', 0, '', '');

	function showAddReply(useReplyFlag,useReplyId){		
		if (useReplyFlag == 0 ){
			document.getElementById("useReplyFlag").value = 0;
		}
		if (useReplyFlag == 3 ){
			document.getElementById("useReplyFlag").value = 3;
		}
		document.getElementById("useReplyId").value = useReplyId;
		document.getElementById("addReply").style.display="";
		document.getElementById("content").focus();
		
		return true;
	}

	function hiddenAddReply(){
		document.getElementById("addReply").style.display="none";
	}

	function replyPost(){
		if(!checkForm(postForm))
			return;
	
		saveAttachment();
		document.postForm.action = "${detailURL}?method=createReplyArticle";
		document.postForm.submit();
	}

	function openTheWindow(){
		v3x.openWindow({
			url : "${detailURL}?method=blogFavorites&&articleId=${article.id}&&familyid=${familyId}&&resourceMethod=showPost",
			width : "380",
			height : "200",
			resizable : "true",
			scrollbars : "true"
		});
		window.location.href = window.location.href;
	}
	var srcMethod = '${resourceMethod}';
	var docHomepage = (srcMethod == 'docHomepage');
	var windowUrl = window.location.href;
	function articleDel(){
		if(!confirm('<fmt:message key='delete.article.notice.label'/>'))
			return;
			
		var url_ = '${detailURL}?method=deleteArticle&&affairId=${article.id}&&familyid=${familyId}&&resourceMethod=${resourceMethod}';
		if(docHomepage){
			postForm.action = url_;
			postForm.target = "blogIframe";
			postForm.submit();
			parent.window.transParams.parentWin.openBlogDetailCallBack('false');
		}else{
			window.location.href = url_;
		}
	}
	function articleRefresh(){
		window.location.href = windowUrl;
	}
	function articleBack(){
		if(docHomepage){
			parent.window.transParams.parentWin.openBlogDetailCallBack('false');
		}else{
			var _url = '${detailURL}?method=${resourceMethod}&resourceMethod=${resourceMethod}&id=${article.familyId}&userId=${article.employeeId}';
			window.location.href = _url;
		}
		if(sectionOpenDetailDialog){//从首页打开
		    sectionOpenDetailDialog.close();
		}
	}

//-->
</script>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</head>
<body style="margin: 0px; overflow: auto;">

<form name="postForm" id="postForm" method="post"  style="margin:0px">
<input type="hidden" name="articleId" value="${article.id}">
<input type="hidden" name="replyUserId" value="${replyUserId}">
<input type="hidden" name="resourceMethod" value="${resourceMethod}">
<input type="hidden" name="familyId" value="${familyId}">
<input type="hidden" name="useReplyFlag" value="0">
<input type="hidden" name="useReplyId" value="${replyPost.id}">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="blue"
style="word-break:break-all;word-wrap:break-word"
>		
	<tr class="page2-header-line">
		<td height="60">
			<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line">
		        <td width="80" height="60"><span class="new_img"></span></td>
		        <td class="page2-header-bg"><fmt:message key="blog.label" /></td>
		        <td class="page2-header-line page2-header-link" align="right">&nbsp;</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="3" class="paddingLR blogViewTitle" height="30" valign="bottom">
			${article.subject}
		
		</td>
	</tr>
		<tr>
		<td align="right" colspan="3" height="24" valign="bottom" class="paddingLR ">

			<!-- 删除 -->
			
					<a   
						href="javascript:articleDel()" class="font-12px hyper_link2">
				[<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />]</a>&nbsp;
			
			<!-- 刷新 -->
			<a   href="javascript:articleRefresh()" class="font-12px hyper_link2"> 
				[<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp;
			<!--编辑 --> 
			<a   href="javascript:editBlog()" class="font-12px hyper_link2"> 
				[<fmt:message key="common.toolbar.update.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp;
			<!-- 返回 -->
 			<a  href="javascript:articleBack()" class="font-12px hyper_link2">
				[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp;&nbsp;
			<hr size="1" class="blogBorder">
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center" class="paddingLR font-12px" height="40" valign="top">
			<fmt:formatDate value="${article.issueTime}" pattern="${dataPattern}"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			${issueUserName}
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="blog.clicknumber.label"/>:${article.clickNumber}
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="blog.replynumber.label"/>:${article.replyNumber}
		</td>
	</tr>

	<tr>
		<td colspan="3" class="paddingLR" valign="top" height="100%">

<div class="contentText">${article.content}</div>

		</td>
	</tr>
	<tr>
		<td colspan="3" class="paddingLR" height="10" valign="top">
			<hr size="1" class="blogBorder">
		</td>
	</tr>


		<tr id="attachmentTr" style="display: none">
		<td colspan="3" class="paddingLR" height="30">
			<%-- 附件显示 --%>
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50" nowrap="nowrap" class="font-12px"><b><fmt:message key="common.attachment.label"  bundle="${v3xCommonI18N}" /></b>:&nbsp;</td>
					<td width="100%" class="font-12px ">
						<v3x:attachmentDefine attachments="${attachments}" />
						<%-- 
						(<span id="attachmentNumberDiv"></span>)
						--%>
						<script type="text/javascript">
							showAttachment('${article.id}', 0, 'attachmentTr', '');
						</script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="paddingLR" height="30">	
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr height="30">
					<td class="font-12px" ><b><fmt:message key="blog.reply.label"/></b></td>
					<td align="right"><a  class="font-12px hyper_link2" onclick="javascript:showAddReply(0,-1)" href="#buttom"><fmt:message key="blog.reply.action"/></a>&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" height="30">	
						<!-- 评论栏 -->
				<c:forEach items="${replyModelList}" var="replyPost">
					<div class="font-12px">
							<div class="div-float font-12px">
							<!-- 评论于 -->
								<b>${replyPost.replyUserName}</b>
								<span class="topic-attitude"><fmt:message key="blog.reply.at.label" /></span>
								<fmt:formatDate value="${replyPost.issueTime}" pattern="${dataPattern}"/>
							</div>				
								
									<a class="font-12px hyper_link2"  onclick="return confirm('<fmt:message key='delete.reply.post.notice.label'/>')" href="${detailURL}?method=deleteReplyPost&&postId=${replyPost.id}&&articleId=${article.id}&&resourceMethod=${resourceMethod}" class="hyper_link2">
									<fmt:message key="delete.label"/></a>&nbsp;
								
								<a  class="font-12px hyper_link2" onclick="javascript:showAddReply(3,'${replyPost.id}')" href="#buttom"><fmt:message key="blog.reply.post.label"/></a>
								<input type="hidden" name="replyId" value="${replyPost.id}">
						
						<!-- 评论意见 -->
							<!-- 评论内容 -->
							<div class="optionContent wordbreak">
							${replyPost.content}
							<!-- <v3x:showContent content="${replyPost.content}" type="HTML"/>&nbsp; -->
							<!-- 附件 -->
							<div class="div-float attsContent" style="display: none" id="attsDiv${replyPost.id}">
								<div class="atts-label">
								<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
								<v3x:attachmentDefine attachments="${replyPost.attachment}" />
								<script type="text/javascript">showAttachment('${replyPost.id}', 0, 'attsDiv${replyPost.id}');</script>
							</div>
							</div>
						
						<!-- 回复意见 -->
							
						<!-- 回复的评论 -->
						<c:if test="${replyPost.useReplyFlag == 3 }">
							<c:forEach items="${refPostReplyModelList}" var="refReplyPost">
							<c:if test="${refReplyPost.parentId == replyPost.id }">
								<!-- 回复于 -->
								<div style="padding: 0px 50px 0px 50px"><hr color="#CCCCCC" size="1" noshade="noshade"></div>
									<div class="comment-div cursor-hand">
									<b>${refReplyPost.replyUserName}</b>
									<fmt:message key="blog.reply.at.label" />
									<fmt:formatDate value="${refReplyPost.issueTime}" pattern="${dataPattern}"/>
									
									<!-- 删除 -->
									<!-- <div class="div-float-right"> -->
										
												<a  class="font-12px hyper_link2" onclick="return confirm('<fmt:message key='delete.reply.post.notice.label'/>')" href="${detailURL}?method=deleteReplyPost&&postId=${refReplyPost.id}&&articleId=${article.id}&&resourceMethod=${resourceMethod}" class="hyper_link2">
											<fmt:message key="delete.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
										
										</div>
									<!-- 回复内容 -->
										<div class="comment-content wordbreak">
										${refReplyPost.content}
										<!-- <v3x:showContent content="${refReplyPost.content}" type="HTML"/>&nbsp; -->
										<!-- 附件 -->
										<div class="div-float attsContent" style="display: none" id="attsDiv${refReplyPost.id}">
											<div class="atts-label">
											<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
											<v3x:attachmentDefine attachments="${refReplyPost.attachment}" />
											<script type="text/javascript">showAttachment('${refReplyPost.id}', 0, 'attsDiv${refReplyPost.id}');</script>
										</div>
										</div>
							</c:if>
							</c:forEach>
						</c:if>
						</div>
						<!-- 回复的评论结束 -->
					</c:forEach>
			<!-- 评论意见结束 -->
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" align="center" >	
					<div id="addReply" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="body-detail">
				<tr>
					<td class="blog-title-bar" colspan="2" height="26" valign="middle">
						<div class="blog-div-float-left"><fmt:message
						key="blog.reply.action" /></div></td>
				</tr>
						
				<tr>
					<td width="20%" height="24" align="right" class="font-12px">
						<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;
					</td>
					<td width="80%" height="24" class="font-12px">
						RE：${v3x:getLimitLengthString(article.subject,70,"...")}
						<input type="hidden" name="subject"  value="RE：${article.subject}">
					</td>
				</tr>
			
				<tr id="attachmentTR" style="display:none;">
					<td nowrap height="26" class="font-12px" valign="middle" align="right">
						<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;
					</td>
					<td valign="top" height="26" class="font-12px">
						<div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
						<v3x:fileUpload/>
					</td>
				</tr>  
						
				<tr>
					<td align="right" class="font-12px">
						<fmt:message key="blog.content.label"/>:&nbsp;&nbsp;
					</td>
					<td class="font-12px">
						<textarea  rows="5" name="content" id="content" style="width: 87%"
						maxSize="120" validate="notNull" inputName="<fmt:message key="blog.content.label"/>"
						></textarea>
					</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td class="font-12px">
						<input type="button" name="reply" value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>" onclick="replyPost()" class="button-default-2"> 
						<input type="button" onclick="javascript:hiddenAddReply()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" height="30">&nbsp;
		</td>
	</tr>
	
</table>

<a name="buttom" id="buttom"></a>
</form>
<iframe name="blogIframe" frameBorder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />

</body>
</html>


















