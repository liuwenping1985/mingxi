<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%-- 这里是一条回复 --%>
<c:if test="${success }">
	<li class="tabs_reply_list clearfix">
	    <img class="tabs_reply_pic ${comment.handStyle}" src="${comment.personPicUrl }" alt="" onclick="showPropleCard('${comment.presonId}')">
		<ul class="tabs_reply_content">
			<%-- 这里是回复正文 --%>
			<li class="tabs_reply_content_list" cid="${comment.id }" mtp="${comment.moduleType }" mid="${comment.moduleId }">
				<div class="tabs_reply_content_list_title clearfix">
					<span class="left">
					    <a name="memberName" onclick="showPropleCard('${comment.presonId}')" style="font-size: 12px;cursor:${comment.personCursor};color:${comment.textColor};" title="${comment.personNameAll }"><c:out value="${comment.personName }" escapeXml="false"/></a>
					    <span class="margin_l_10" style="font-size: 12px;">${comment.createTime }</span>
					</span>
					<span class="right">
                        <div class="hidden tabs_reply_like">
                            <div></div>
                            <em class="tabs_reply_like_arrow"></em>
                        </div>
					    <em class="ico16 no_like_16" style="font-size: 12px;" title="${comment.priseTipe}" onclick="praiseComment('${comment.id }', this)"></em>
					    <span style="font-size: 12px;" commentId="${comment.id }" class="hand praiseBtn"></span>
					    <a style="font-size: 12px;" class="margin_l_15 padding_l_15 border_l" onclick="showNewCommentComArea(this);">${ctp:i18n('taskmanage.reply.action')}</a>
					</span>
				</div>
				<p class="tabs_reply_content_list_content"><c:out value="${comment.content }" escapeXml="false"/></p>
	            <c:if test="${comment.hasRelateInfo eq 'true' }">
	            <div class="clearfix"><!-- 附件 --> 
	                <c:if test="${comment.attNum > 0}">
                    <div class="clearfix">
                        <div class="color_black left margin_r_5"
                                        style="margin-top: 4px;color: #8d8d8d;font-size: 12px;"><em class="ico16 affix_16"></em>(<span>${comment.attNum}</span>)</div>
                        <div name="attrFileUpload" style="display: none; float: right;" class="comp"
                                        comp="type:'fileupload',canFavourite:false,applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false"
                                        attsdata="${comment.relateInfo}"></div>
                    </div>
                    </c:if>
                    <c:if test="${comment.relNum > 0}">
                    <div class="clearfix">
                        <div class="color_black left margin_r_5"
                                        style="margin-top: 4px;color: #8d8d8d;font-size: 12px;"><em
                                        class="ico16 associated_document_16"></em>(<span>${comment.relNum}</span>)</div>
                        <div name="attachmentResourceTR" style="display: none; float: right;" class="comp"
                                        comp="type:'assdoc',canFavourite:false,attachmentTrId:'${comment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${comment.moduleId}',canDeleteOriginalAtts:false"
                                        attsdata="${comment.relateInfo}"></div>
                    </div>
                    </c:if>
	            </div>
	            </c:if>
			</li>
		</ul>
	</li>
</c:if>
