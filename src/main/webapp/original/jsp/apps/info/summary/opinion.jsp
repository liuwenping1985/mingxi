<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
.div-float {
	float: left;
}

.body-detail-border {
	background-color: #FFFFFF;
	font-size: 12px;
	line-height: 14px;
}

.wordbreak {
	word-break: break-all;
}

.body-detail-su {
	color: #151B1C;
	font-weight: bold;
	padding: 10px;
	font-size: 12px;
}

.optionContent1 {
	text-align: left;
	margin: 5px 5px 5px 0px;
	font-size: 12px;
	line-height: 20px;
}

.comment-div {
	width: 100%;
	padding: 10px 0px 10px 0px;
	font-size: 12px;
}

.atts-label {
	float: left;
	font-size: 12px;
	line-height: 20px;
	font-weight: bolder;
}

.attsContent {
	text-align: left;
	padding: 2px 0px 10px 10px;
	font-size: 12px;
	line-height: 18px;
}
.like-a,.default-a {
    color: #007cd2;
}
.link-blue {
	color:#0052b8;
	cursor: pointer;
	text-decoration:none;
}
</style>

<div id="opinionDiv" style="float: left; align: left; padding-left: 30px; width: 95%; padding-top: 30px;">

	<!-- 发起人附言 -->
	<div id="colOpinion">
		<c:if test="${senderOpinion ne null || fn:length(senderOpinion) > 0 || isSender}">
			<table align="center" width="95%" border="0" cellspacing="0"
				cellpadding="0" id="printSenderOpinionsTable">
				<tr>
					<td class="body-detail-border" id="senderOpinion">
						<hr style="width: 100%; color: #a4A4A4; border: 1px" size="1">
						<div>
							<div class="body-detail-su div-float" id="sendOpinionTitle"
								style="display: inline;">${ctp:i18n('infosend.label.promoters.postscript')}<!-- 发起人附言 --></div>
							<c:if
								test="${summaryVO.finished == false && isSender && (param.openFrom eq 'Send' || param.openFrom=='Pending')}">
								<div id="addSenderOpinionDiv"
									style="visibility: inherit; display: inline; float: right;"
									class="">
									<a href="javascript:addReplySenderOpinion()" class="font-12px">${ctp:i18n('infosend.label.sender.addnote')}<!-- 增加附言 --></a>
								</div>
							</c:if>
						</div> <br />
					<br />
						<div id="displaySenderOpinoinDiv" name="displaySenderOpinoinDiv"
							class="div-float w100b">
							<c:forEach items="${senderOpinion}" var="opinion">
								<div style="width: 100%">
									<div class="optionContent1 wordbreak div-float" style="margin: 15px;">
										${ctp:formatDateByPattern(opinion.createTime, 'yyyy-MM-dd HH:mm:ss')} &nbsp;&nbsp;${v3x:toHTML(opinion.content)}
										<c:if test="${!empty opinion.proxyName}">
											<div class="opinion-agent"></div>
										</c:if>
									</div>
									<%-- 附件 --%>
									<c:if test="${not empty senderOpinionAttStr[opinion.id]}">
										<div class="div-float attsContent" style="display: block; float: left; width: 100%" id="attsDiv${opinion.id}">
											<div class="atts-label">${ctp:i18n('common.attachment.label')}<!-- 附件 -->:&nbsp;&nbsp;</div>
											${senderOpinionAttStr[opinion.id]}
										</div>
									</c:if>
									<div style="clear:both;">&nbsp;</div>
								</div>
							</c:forEach>
						</div>
						<!-- displaySenderOpinoinDiv --> <%-- 用于存放本次发起人附言的内容 --%>
						<div id="replyDivsenderOpinionDIV"></div> 
						<c:if test="${summaryVO.finished == false && (param.openFrom eq 'Send' || param.openFrom=='Pending')}">
							<%-- 发起人附言框位置 --%>
							<form id="noteForm" name="noteForm" method="post" style="margin: 0px;">
								<div class="comment-div div-float" style="display: none" id="noteOpinion">
									<input type="hidden" name="summaryId" value="${summaryVO.summary.id}"> 
									<input type="hidden" name="opinionId" value=""> 
									<input type="hidden" name="startMemberId" value="${senderId}"> 
									<input type="hidden" name="memberId" value=""> 
									<input type="hidden" name="memberName" value=""> 
									<input type="hidden" name="isProxy" value="false"> 
									<input type="hidden" name="affairId" value="${summaryVO.affair.id}">
									<input type="hidden" id="sendAffairId" value="${summaryVO.sendAffair.id }">
									<input type="hidden" name="nodeId" value="${summaryVO.affair.activityId}"> 
									<input type="hidden" name="isNoteAddOrReply" value="reply">
									<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td colspan="2"><textarea name="noteContent"
													id="noteContent" cols="" rows=""
													style="width: 100%; height: 80px" class="font-12px"
													inputName="${ctp:i18n('infosend.label.topic.reply.content')}" validate="notNull" maxSize="500"></textarea><!-- 附言内容 -->
											</td>
										</tr>
										<tr>
											<td align="right" colspan="2">
												<span class="like-a font-12px" id="uploadAttachmentSpan">${ctp:i18n('common.toolbar.insertAttachment.label')}<!-- 插入附件 --></span>
												<label for="isSendMessage" class="font-12px"> 
													<input name="isSendMessage" type="checkbox" value="1" checked="checked">${ctp:i18n('message.sendDialog.title')}<!-- 发送消息 -->
												</label> 
												<input type="button" name="b12" id="subbtton" class="button-default-2" value="${ctp:i18n('common.button.submit.label')}"> 
												<input type="button" name="b12" class="button-default-2" value="${ctp:i18n('common.toolbar.cancelmt.label')}" onclick="cancelComment()">
											</td>
										</tr>
										<tr id="attachmentTRNoteAtt" style="display: none;">
											<td class="align_right" valign="top" width="88" nowrap="nowrap">
												<div class="div-float">
													${ctp:i18n('common.attachment.label')}<!-- 附件 -->：(<span id="attachmentNumberDivNoteAtt"></span>)
												</div>
											</td>
											<td class="align_left">
												<div id="noteAttFileDomain" class="comp" comp="type:'fileupload',attachmentTrId:'NoteAtt',applicationCategory:'32',canFavourite:'false',canDeleteOriginalAtts:'true',originalAttsNeedClone:'true'" attsdata=''>
												</div>
											</td>
											<td valign="top"></td>
										</tr>
									</table>
								</div>
							</form>
						</c:if>
					</td>
				</tr>
			</table>
		</c:if>
	</div>

	<%--显示未绑定公文元素的节点的处理意见 --%>
	<table align="center" width="95%" border="0" cellspacing="0" cellpadding="0" id="printOtherOpinionsTable">
		<tr id="dealOpinionTitleDiv" style="display: none">
			<td>
				<hr style="width: 100%; color: #a4A4A4; border: 1px" size="1">
				<div class="div-float" style="float: left;">
					<div class="div-float body-detail-su" style="float: left;" id="dealOpinionTitle">${ctp:i18n('infosend.label.element.comment')}<!-- 处理意见区 --></div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div class="wordbreak div-float" id="processOtherOpinions" name="processOtherOpinions" style="display: none; word-break: break-all; width: 100%; float: left;"></div>
				<div class="wordbreak div-float" id="displayOtherOpinions" name="displayOtherOpinions" style="visibility: hidden; word-break: break-all; width: 100%; float: left;"></div>
			</td>
		</tr>
	</table>
	
	<!-- 用于动态显示意见 -->
	<iframe id="sb_option_iframe" src="" style="display: none;"></iframe>
</div>
<!-- 发起人附言 结束-->
