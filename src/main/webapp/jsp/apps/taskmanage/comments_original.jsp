<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.taglibs.functions.Functions"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<div id="replyArea" class="tabs_area_body" prise="${ctp:i18n('collaboration.summary.label.praise')}"
            priseCancel="${ctp:i18n('collaboration.summary.label.praisecancel')}"
            moduleId="${param.moduleId}">
		<div class="have_a_rest_area" style="display:none;">${ctp:i18n('taskmanage.condition.no.content')}</div>
    <c:choose>
	<c:when test="${(from eq 'bnOperate' and not taskHasComment) or (from eq 'planTask' and not taskHasComment)}">
		<%--<div class="have_a_rest_area">${ctp:i18n('taskmanage.condition.no.content')}</div>
	--%></c:when>
	<c:otherwise>
		<div class="tabs_reply">
			<ul class="commentParent">
				<%-- 这里是回复框 --%>
				<li class="tabs_reply_list clearfix" id="reply_li"><img class="tabs_reply_pic hand"
					src="<%= Functions.getAvatarImageUrl(AppContext.currentUserId()) %>"
					alt="" onclick="showPropleCard('<%=AppContext.currentUserId() %>')">
					<div class="tabs_reply_content">
						<div
							class="projectTask_reply projectTask_reply_big margin_t_20 margin_b_10">
							<div class="common_txtbox left clearfix">
								<textarea id="commentContent" cols="" rows="" class="w100b" defaultValue="${ctp:i18n('taskmanage.reply.contentAreaTitle')}"></textarea>
							</div>
							<!--
							<div class="left clearfix w100b font_size12">
								<div id="attachmentTR" class="clearfix">
									<div id="content_deal_attach_comment" isGrid="true" class="comp"
										comp="type:'fileupload',applicationCategory:'${param.moduleType}',attachmentTrId:'_comment',canFavourite:false,canDeleteOriginalAtts:true"
										attsdata='[]'></div>
									</div>
								<div id="attachment2TR" class="clearfix">
									<div id="content_deal_assdoc_comment" isGrid="true" class="comp"
										comp="type:'assdoc',applicationCategory:'${param.moduleType}',attachmentTrId:'_comment',modids:'1,3',canFavourite:false,canDeleteOriginalAtts:true"
										attsdata='[]'></div>
									</div>
								</div>
							</div>
							-->
							<div id="commentsAttmentDiv" class="left clearfix w100b font_size12" moduleType="${param.moduleType}">
								<div id="attachmentTR" style="display:none;"></div>
								<div id="content_deal_attach_comment" class="comp clearfix" comp="type:'fileupload',applicationCategory:'${param.moduleType}',attachmentTrId:'_comment',canDeleteOriginalAtts:false,canFavourite:true" attsdata=''></div>
								<div id="content_deal_assdoc_comment" class="comp clearfix" comp="type:'assdoc',applicationCategory:'${param.moduleType}',attachmentTrId:'_comment',canDeleteOriginalAtts:false, modids:'1,3,6',canFavourite:true,originalAttsNeedClone:true" attsdata=''></div>
							</div>
							<div class="left clearfix w100b padding_t_3 padding_b_3">
							   <div class="projectTask_reply_affix border_r left"  onclick="insertAttachmentComment();">
								   <em class="ico16 affix_16" id="uploadAttachmentID"></em>
							   </div>
							   <div class="projectTask_reply_affix left" onclick="quoteDocumentComment();">
								   <em class="ico16 associated_document_16" id="uploadRelDocID"></em>
							   </div>
							   <div id="commentErrorArea" class="hidden tabs_reply_error">
									<div>
										<em class="rateNumber_error_arrow"></em><em class="ico16 stop_contract_16"></em>
										<span id="commentContentErrorText"></span>
									</div>
								</div>
							   <a href="javascript:void(0)" onclick="addNewComment(this, '${param.moduleType }', '${param.moduleId}')"
									class="common_button common_button_emphasize common_button_big right margin_r_10">${ctp:i18n('taskmanage.reply.action')}</a>
							</div>
							<!--
							<div class="left clearfix w100b padding_t_3 padding_b_3">
								<div class="padding_lr_10 padding_tb_5 border_r left" onclick="insertAttachmentComment();"><em class="ico16 affix_16"></em></div>
								<div class="padding_lr_10 padding_tb_5 left" onclick="quoteDocumentComment();"><em class="ico16 associated_document_16"></em></div>
								<div class="tabs_reply_error">
									<div><em class="rateNumber_error_arrow"></em><em class="ico16"></em>不不不不不不不不不</div>
								</div>
								<a href="javascript:void(0)" onclick="addNewComment(this, '${param.moduleType }', '${param.moduleId}')"
									class="common_button common_button_emphasize common_button_big right margin_r_10">${ctp:i18n('taskmanage.reply.action')}</a>
							</div>
							-->
						</div>
					</div></li>
				<%-- 这里是一条回复 --%>
				<li class="tabs_reply_list clearfix hidden"><img
					class="tabs_reply_pic hand"
					src=""
					alt="">
					<ul class="tabs_reply_content">
						<%-- 这里是回复正文 --%>
						<li class="tabs_reply_content_list">
							<div class="tabs_reply_content_list_title clearfix">
								<span class="left"><a>李洪泽</a><span class="margin_l_10">2014-12-12</span><span
									class="margin_l_10">12:12</span></span> <span class="right"><em
									class="ico16"></em><a class="margin_l_15 padding_l_15 border_l">${ctp:i18n('taskmanage.reply.action')}</span></a>
							</div>
							<p class="tabs_reply_content_list_content">报告展现非常清楚，大家辛苦了！任务延期小组不少，请各位及时更新状态。注：对于延期任务，标注延期天数报告展现非常清楚，大家辛苦了！任务延期小组不少，请各位及时更新状态。注：对于延期任务，标注延期天数</p>
						</li>
						<%-- 这里是震荡回复 --%>
						<li class="tabs_reply_content_list">
							<div class="tabs_reply_content_list_title clearfix">
								<span class="left"><a>李洪泽</a><span class="margin_l_10">2014-12-12</span><span
									class="margin_l_10">12:12</span></span>
							</div>
							<p class="tabs_reply_content_list_content">大家辛苦了！</p>
						</li>
						<%-- 这里是震荡回复框 --%>
						<li id="comcomArea" class="tabs_reply_content_list">
							<div
								class="projectTask_reply projectTask_reply_big margin_t_20 margin_b_10">
								<div class="common_txtbox left clearfix">
									<textarea cols="" rows="" class="w100b" defaultValue="${ctp:i18n('taskmanage.reply.contentAreaTitle')}"></textarea>
								</div>
								<div class="left clearfix w100b padding_b_3">
									<a href="javascript:void(0)" class="common_button common_button_gray margin_r_10 right">${ctp:i18n('common.button.cancel.label')}</a>
									<div class="hidden tabs_reply_error">
										<div>
											<em class="rateNumber_error_arrow"></em><em class="ico16 stop_contract_16"></em>
											<span class=""></span>
										</div>
									</div>
									<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10 right">${ctp:i18n('taskmanage.reply.action')}</a>
								</div>
							</div>
						</li>
					</ul></li>
			</ul>
		</div>
	</c:otherwise>
	</c:choose>
</div>
