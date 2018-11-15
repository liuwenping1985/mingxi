<%--
 $Author: $
 $Rev: $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<c:forEach var="comment" items="${commentView.comments}">
	<div class="comment border_all margin_5" id="comment${comment.id}">

		<table class="w100b">
			<tr>
				<td class="w10b">

					<p>
						<img width="24" height="32" title="照片" src="" />
					</p>

					<p>
						<a href="#">${comment.publisher}XXX</a>
					</p>
					<p>部门</p>
					<p>岗位</p>
				</td>
				<td>
					<table class="w100b">
						<tr>
							<td>${comment.subject}</td>
							<td><div class="right">回复于
									${comment.attributes.createDate} ${comment.attributes.floor}楼</div></td>
						</tr>
						<tr>
							<td colspan="2"><div class="content">
									${comment.content}</div></td>
						</tr>
						<tr>
							<td></td>
							<td><div class="right">
									<a href="javascript:refComment('${comment.id}')">引用</a>
								</div></td>
						</tr>
					</table></td>
			</tr>


		</table>



	</div>
</c:forEach>
<div id="commentForm1" class="w80b common_center  border_all margin_5">
	<p>
		标题：<input name="subject" size="100" />
	</p>
	<p>
		内容：
		<textarea id="content" name="content" class="comp"
			comp="type:'editor',contentType:'html',toolbarSet:'BbsSimple'"></textarea>
		<a href="javascript:void(0)" class="common_button common_button_gray"
			id="btnSubmit">提交</a>
	</p>
</div>

<script>
// 初始化，包装回复Form
wrapReplyForm('${commentView.module}',1,${commentView.subjectId},${commentView.subjectId},$('#commentForm1'));
// 回调，回复提交以后触发
function afterReplyCommit(reply){
    location.reload();
}

function refComment(id){
	var refHtml = $('#comment' + id +' .content' ).html();
	refHtml = '<div style="border:1px solid #EEEEEE;background-color:#EEEEEE";margin:5px>引用：<br/>' + refHtml + '</div><p> &#160;  </p>';
	$('#content').setEditorContent(refHtml);
}
</script>
