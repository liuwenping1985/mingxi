<%--
 $Author: wuym $
 $Rev: 282 $
 $Date:: 2012-07-31 18:06:42#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:forEach var="comment" items="${commentView.comments}">
	<div class="comment margin_5" id="comment${comment.id}">
		<div class="header">
			<a href="#">${comment.publisher}</a> ${comment.subject}
			${comment.attributes.createDate}
			<div class="right"
				onclick="reply('${commentView.module}',2,${comment.subjectId},${comment.id})">
				<a href="#">回复</a>
			</div>
		</div>

		<div class="content margin_5">
			<c:out value="${comment.content}" />
		</div>
		
		<div class="reply ${fn:length(comment.replies)>0?'':'display_none'}" id="replys_${comment.id}">
			<div class="header">回复意见</div>
			<c:forEach var="reply" items="${comment.replies}">
				<div class="border_b">
					<a href="#"><c:out value="${reply.publisherId}" /> </a>：
					<div class="right">${reply.attributes.createDate}</div>
					<p>
						<c:out value="${reply.content}" />
					</p>
				</div>
			</c:forEach>
		</div>
	</div>
</c:forEach>
<div id="replyForm" class="display_none">
	<textarea class="w90b" name="content"></textarea>
	<br /> <a href="javascript:void(0)"
		class="common_button common_button_gray" id="btnSubmit">提交</a>
</div>
<script>
	// 回调，回复提交以后触发
	function afterReplyCommit(reply){
		$('#replys_' + reply.pid).append('<div><a href="#">${CurrentUser.name}</a>：<div class="right">'+(new Date().format('yyyy-mm-dd HH:MM:ss'))+'</div><p>'+reply.content +'</p></div>');
	}
</script>
