<%--
 $Author: muj $
 $Rev: 5674 $
 $Date:: 2013-04-01 15:39:42#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript" charset="UTF-8"
    src="${path}/apps_res/collaboration/js/comment.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$("#senderpostscriptDiv textarea").live("click",function(){
        $(this).css("color","#111");
       
    });
var openForm = "${ctp:escapeJavascript(param.openFrom)}";
var _currentUserName = "${ctp:escapeJavascript(CurrentUser.name)}";
var contentAffairId = "${contentContext.affairId}";
var workflowTraceType = "${param.trackType}";
var _praiseC = "${ctp:i18n('collaboration.summary.label.praisecancel')}";
var _praise = "${ctp:i18n('collaboration.summary.label.praise')}";

var stateMemberName = "${ctp:escapeJavascript(ctp:showMemberName(contentContext.contentSenderId))}";
var startMemberId = "${contentContext.contentSenderId}";
</script>
<style type="text/css">
.seperate {
	width:1px;
	display:inline-block;
	background:#c0c5c6;
	height:12px;
	vertical-align:middle;
}
.list_style_original ul li{
	list-style:disc;
}
.list_style_original ol{
	padding-left:33px;
	padding-right:20px;
}
.list_style_original ol li{
	list-style:decimal;
	padding-left:0px;
}

/*Firefox*/ @-moz-document url-prefix(){
  .content_view .content ul{padding-left:15px;} 
  .list_style_original ol li{padding-left:2px;}
}

.comment_area_top {
	height: 40px;
	background: #eff3f5;
	border: 1px solid #d7d7d7;
}

.comment_area_top_item{
    height: 24px;
    line-height: 24px;
    margin-top: 8px;
    display:inline-block;
}
.licomContent li{
	list-style:inherit;
	}
.licomContent ul{
	list-style:disc;
	}
	.content_view .content .licomContent ul{
	margin:0;
	}
	.commentForwardDiv .processing_view .content ul ul{
	list-style:disc;
	}
	.commentForwardDiv .processing_view .content ul ul li,.commentForwardDiv .processing_view .content ul ol li{
	list-style:inherit;
	}
.forwardReplyContentDiv{
	    margin: 5px 0 0 0;
		background: #F6F9F9;
	}
</style>
<c:choose>
    <c:when test="${fromTemplate == 'true'}">
        <li class="view_li padding_b_10" id="postscriptli"><span
            class="title">${ctp:i18n('collaboration.sender.postscript')}</span>
                <div class="content">
                    <ul>
                        <c:if test="${commentSenderList != null}">
                            <li>${commentSenderList[0].escapedContent}</li>
                        </c:if>
                    </ul>
                </div>
        </li>   
    </c:when>
    <c:otherwise>
    
    <%-- 查找处理人全局计数器 --%>
    <c:set var="_sscounter" value="1"></c:set>
    <c:if test="${fn:length(commentForwardMap) > 0}">
    <li class="padding_tb_10" id="commentForwardDivOut">
            <div id="_commentAllDiv"><%-- 评论回复转发区 --%> <!-- 查看原协同意见   隐藏原协同意见  -->
            <c:set value="0" var="countBtn" />
            <div id="commentForwardDiv" class="commentForwardDiv" style="line-height: 20px">
			<c:forEach
                items="${commentForwardMap}" var="forward" varStatus="statusForward">
                <ul id="comment_forward_region" class="view_li">
                    
					<c:if test="${statusForward.first}">
						<div class="li_title li_title_repeat">
							
							 <a class="right margin_r_20 font_size14" id="comment_forward_region_btn" showTxt="${ctp:i18n('collaboration.default.findComment')}" hideTxt="${ctp:i18n('collaboration.default.hideColComment')}">${ctp:i18n('collaboration.default.hideColComment')}</a>
						</div>
					</c:if>
                    <div class="processing_view font_size12 padding_b_15">
	                    <span class="font_bold tranform_time font_size16 color_666">${ctp:i18n_1('collaboration.forward.oriOp.level.label',forward.key)}</span>
	                    <c:forEach items="${forward.value}" var="forwardValue"
	                        varStatus="statusForwardValue">
	                        <c:if test="${forwardValue.key == -1}">
	                            <span class="view_li margin_b_10"> 
	                                <div class="font_bold font_size14 li_title no_border_t color_666"  style="margin:25px 25px 0 25px;">${ctp:i18n('collaboration.sender.postscript')}</div>
	                            <div class="content margin_10">
	                                <ul class="font_size14">
	                                <c:forEach items="${forwardValue.value}" var="forwardSender"
	                                    varStatus="statusForwardSender">
	                                    <div class="padding_b_15">
	                                    <div style="word-wrap: break-word">
	                                    	<c:set var="showName" value="${forwardSender.createName}"/>
	                                    	<a onclick="showPropleCard('${forwardSender.createId}')" class="padding_l_5 color_blue" id="commentSearchCreate${_sscounter}">${forwardSender.createName}</a>
	                                    ${(forwardSender.escapedContent)}</div>
	                                    <c:set var="_sscounter" value="${_sscounter+1}"></c:set> <c:if
	                                        test="${forwardSender.hasRelateAttach}">
	                                        <div class="clearfix margin_t_5">
	                                        <div class="font_bold left margin_r_5 margin_t_10"><em class="ico16 affix_16"></em>(<span
	                                            id="attachmentNumberDiv${forwardSender.id}"
	                                            style="margin-right: 0px"></span>)</div>
	                                        <div style="display: none; float: right;" class="comp"
	                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${forwardSender.moduleType}',attachmentTrId:'${forwardSender.id}',canDeleteOriginalAtts:false"
	                                            attsdata="${ctp:toHTML(forwardSender.relateInfo)}"></div>
	                                        </div>
	                                    </c:if> <c:if test="${forwardSender.hasRelateDocument}">
	                                        <div class="clearfix margin_t_5"><!-- 关联 -->
	                                        <div class="font_bold left margin_r_5 margin_t_10"><em
	                                            class="ico16 associated_document_16"></em>(<span
	                                            id="attachment2NumberDiv${forwardSender.id}"
	                                            style="margin-right: 0px"></span>)</div>
	                                        <div style="float: right;" class="comp" style="display:none;"
	                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${forwardSender.moduleType}',referenceId:'${contentContext.moduleId}',attachmentTrId:'${forwardSender.id}',modids:'1,3',canDeleteOriginalAtts:false"
	                                            attsdata="${ctp:toHTML(forwardSender.relateInfo) }"></div>
	                                        </div>
	                                    </c:if>
	                                    <div class="color_gray2 padding_l_5 margin_t_10 font_size12">${forwardSender.createDateStr}</div>
	                                    </div>
	                                </c:forEach>
	                                </ul>
	                            </div>
	                        </span>
	                        </c:if>
	                    </c:forEach>
	                    <c:forEach items="${forward.value}" var="forwardValue" varStatus="statusForwardValue">
	                            <c:if test="${forwardValue.key == 0 && forwardValue.value ne '[]'}">
	                            <div class="view_li"  name='outerPraiseDiv'> 
	                            	<c:set value="${countBtn+1}" var="countBtn" />
	                            	<c:set value="p${countBtn}" var="PCount" />
	                                <div name='ppraiseCount' class="title font_bold font_size14 li_title no_border_t color_666">${ctp:i18n_2("collaboration.opinion.handleOpinion",fn:length(forwardValue.value),forwardPraise[PCount])}</div>
	                            <div class="content font_size12">
	                            <c:forEach items="${forwardValue.value}" var="comment" varStatus="status">
	                            <div class="reply_data_li">
	                                <div class="per_title clearfix">
	                                    <img src="${ctp:avatarImageUrl(comment.createId)}" width="30" height="30" class="left user_photo">
	                                <span class="title font_size12 padding_l_5 left valign_t">
	                                	<c:set var="showName" value="${comment.createName}"/>
	                                    <a onclick="showPropleCard('${comment.createId}')" class="padding_l_5 color_blue"  title="${showName }"
	                                    	id="commentSearchCreate${_sscounter}">${ctp:getLimitLengthString(showName,20,"...")}<c:if test="${comment.extAtt2 ne null }">
	                                    <div class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',comment.extAtt2)}</div>
	                                </c:if></a>&nbsp;&nbsp;&nbsp;&nbsp;<span class="font_bold">${ctp:i18n(comment.extAtt1)}${ctp:isBlank(comment.extAtt1)?'':'&nbsp;&nbsp;'}${ctp:i18n(comment.extAtt3)}</span>&nbsp;&nbsp;&nbsp;&nbsp;
	                                <c:set var="_sscounter" value="${_sscounter+1}"></c:set><span class="color_gray2 font_size12 font_normal">${comment.createDateStr}</span> </span><span class="right margin_r_10"> <span
	                                            class="ico16 ${comment.praiseToComment ? 'like_16' : 'no_like_disable_16'}  cursorDefault font_size12"
	                                            id="likeIco${comment.id}"></span>
	                                        <span class='color_gray font_size12 font_normal cursorDefault'>(<span id='likeIcoNumber${comment.id}'  
	                                            onmouseover="showOrCloseNamesDiv('${comment.id}')">${comment.praiseNumber}</span>)</span>&nbsp;&nbsp;
	                                    </span>
	                                </div>

	                                	<c:set value="${empty comment.content && !comment.praiseToSummary && empty comment.children && !comment.hasRelateAttach && !comment.hasRelateDocument && empty comment.m1Info && empty comment.escapedContent}" var ="_isHiddenComment0" />
	              						<c:if test="${!_isHiddenComment0}">
	                                    <ul id="ulcomContent${comment.id}"  class="font_size14">
	                                    <li>
	                                        <c:if test="${comment.praiseToSummary}">
	                                            <span class='ico16 like_16 cursorDefault' name='praiseInSpan'></span>
	                                        </c:if>
	                                        <c:if test="${not empty comment.escapedContent}">
		                                        ${(comment.escapedContent)}
	                                        </c:if>
	                                        <c:if test="${!comment.canView}">
	                                            <span id='canNotView${comment.id}' style='${comment.escapedContent ? "display:none;" : ""}'></span>
	                                        </c:if>
	                      					<c:if test="${empty comment.content}">
	                                            <span id='emtyContent${comment.id}' style='${empty comment.content ? "display:none;" : ""}'></span>
	                                        </c:if>
	                                        <c:if test="${fn:length(comment.children) > 0}">
	                                    <div id="replyContent_${comment.id}" class="forwardReplyContentDiv border_t">
	                                            <c:forEach items="${comment.children}" var="childComment">
	                                        <div class="comments_title_in"><span class="title left">
	                                        	<c:set var="showName" value="${childComment.createName}"/>
	                                        	<a onclick="showPropleCard('${childComment.createId}')" title="${showName }"
	                                            class="color_blue padding_lr_10 margin_l_5 font_size12" id="commentSearchCreate${_sscounter}">${ctp:getLimitLengthString(showName,20,"...")}<c:if
	                                            test="${childComment.extAtt2 ne null }">
	                                            <div class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',childComment.extAtt2)}</div>
	                                        </c:if></a></span><span class="color_gray2 font_size12 right margin_r_10">${childComment.createDateStr}</span></div>
	                                                <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
	                                        <div class="comments_content">
	                                          <c:choose>
	                                            <c:when test="${childComment.canView }">
	                                              <div class="font_size14" style="line-height:25px;">${(childComment.escapedContent)}</div>
	                                              <c:if test="${childComment.relateInfo != null}">
	                                            <div>
	                                                      <!-- 附件 --> 
	                                                      <c:if test="${childComment.hasRelateAttach}">
	                                                        <div class="clearfix margin_t_10">
	                                                          <div class="color_black left margin_r_5 margin_t_10">
	                                                            <em class="ico16 affix_16"></em>
	                                                            (<span id="attachmentNumberDiv${childComment.id}"style="margin-right: 0px"></span>)
	                                                          </div>
	                                                          <div class="display_none right comp"
	                                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${childComment.id}',canDeleteOriginalAtts:false"
	                                                            attsdata="${ctp:toHTML(childComment.relateInfo)}">
	                                                          </div>
	                                                        </div>
	                                                     </c:if>
	                                                     <%-- 关联文档--%>
	                                                     <c:if test="${childComment.hasRelateDocument}">
	                                                       <div class="clearfix">
	                                                         <div class="color_black left margin_r_5 margin_t_10">
	                                                           <em class="ico16 associated_document_16"></em> 
	                                                           (<span id="attachment2NumberDiv${childComment.id}" style="margin-right: 0px"></span>)
	                                                         </div>
	                                                         <div class="display_none right comp"
	                                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${childComment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
	                                                            attsdata="${ctp:toHTML(childComment.relateInfo)}">
	                                                         </div>
	                                                       </div>
	                                                    </c:if>
	                                            </div>
	                                                                </c:if>
	                                                        </c:when>
	                                                        <c:otherwise>
	                                                            ${(childComment.escapedContent)}
	                                                        </c:otherwise>
	                                                    </c:choose> 
	                                                     <div class="clearfix color_gray">${childComment.m1Info}</div>
	                                                    <!--div class="color_gray2">${childComment.createDateStr}</div-->
	                                                </div>
	                                    	</c:forEach>
	                                    	</div>
	                                    	</c:if>
	                                    </li>
	                                    <c:if test="${comment.hasRelateAttach && comment.canView}">
	                                        <li id="liAtt${comment.id}" class="clearfix" style="list-style:none;margin-bottom: 0px; padding-bottom: 5px;">
	                                          <div class="color_black left margin_r_5 margin_t_10">
	                                            <em class="ico16 affix_16"></em>
	                                            (<span id="attachmentNumberDiv${comment.id}"></span>)
	                                          </div>
	                                          <div style="display: none; float: right;" class="comp"
	                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false"
	                                            attsdata="${ctp:toHTML(comment.relateInfo)}">
	                                          </div>
	                                        </li>
	                                    </c:if>
	                                    <c:if test="${comment.hasRelateDocument && comment.canView}">
	                                        <li class="clearfix" id="liRela${comment.id}" style="list-style:none;margin-bottom: 0px; padding-bottom: 5px;">
	                                          <!-- 关联 -->
	                                          <div class="color_black left margin_r_5 margin_t_10">
	                                            <em class="ico16 associated_document_16"></em> 
	                                            (<span id="attachment2NumberDiv${comment.id}"></span>)
	                                          </div>
	                                          <div style="display: none; float: right;" class="comp"
	                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${comment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
	                                            attsdata="${ctp:toHTML(comment.relateInfo)}">
	                                          </div>
	                                        </li>
	                                    </c:if>
	                                      <c:if test="${not empty comment.m1Info}">
	                                      <li class="clearfix padding_l_20">
						                     <div class="clearfix color_gray">${comment.m1Info}</div>
						                  </li>
						                  </c:if>
	                                    </ul>
	                                    </c:if>
	                            </div>
	                            </c:forEach>
	                            </div>
	                            </div>
	                            </c:if>
	                    </c:forEach>
	                 </div>
	                </ul> 
	            </c:forEach>
	        </div>
            </div>
            </li>
            
            </c:if>
    <%-- 发起人附言区 --%>
          
    <li id="replyContent_sender" class="view_li padding_b_10 margin_t_15">
        <div class="li_title">
            <span class="title font_bold font_size14 color_666">${ctp:i18n('collaboration.sender.postscript')}</span>
            <c:if test="${contentContext.contentSender && contentContext.canReply}">
                <a class='add_new color_blue' name='senderMoreDetail' onclick="commentShowReply('sender','',this);">${ctp:i18n('collaboration.sender.newpostscript')}</a>
            </c:if>
        </div>
        <div id="replyContent_sender_content" class="content font_size12">
            <ul class="replyContent_sender_content_ul">
                <c:forEach items="${commentSenderList}" var="comment" varStatus="status">
                    <li class="comment_li ui_print_li_borderBottom" style="<c:if test='${status.last}'>border-bottom:none;</c:if>">
                            <%--c:choose>
                                <c:when test="${status.last}">
                                    <!-- 判断最后一条没有边线 -->
                                    <li style="border:none;">
                                </c:when>
                                <c:otherwise>
                                    <li>
                                </c:otherwise>
                            </c:choose--%>
                        <div class="font_size14">${(comment.escapedContent)}</div>
                        <c:if test="${comment.hasRelateAttach}">
                            <!-- 插入附件 -->
                        <div class="clearfix margin_t_10" style="${comment.hasRelateDocument ? '':'padding-bottom:5px;'}">
                            <div class="left margin_r_5 margin_t_10">
                                <em class="ico16 affix_16"></em> (<span id="attachmentNumberDiv${comment.id}"></span>)
                            </div>
                            <div  class="display_none right comp" comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false" attsdata="${ctp:toHTML(comment.relateInfo)}"></div>
                        </div>
                        </c:if>
                        <c:if test="${comment.hasRelateDocument}">
                            <!-- 关联文档 -->
                            <div class="clearfix padding_b_5 ${comment.hasRelateAttach ? '':'margin_top10'}">
                                <div class="left margin_r_5 margin_t_10">
                                    <em class="ico16 associated_document_16"></em> (<span id="attachment2NumberDiv${comment.id}"></span>)
                                </div>
                                <div class="display_none right comp" comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',attachmentTrId:'${comment.id}',modids:'1,3',canDeleteOriginalAtts:false"attsdata="${ctp:toHTML(comment.relateInfo) }"></div>
                            </div>
                        </c:if>
                        <div id="${comment.id}" class="color_gray2 margin_t_10">${comment.createDateStr}</div>
                    </li>
                </c:forEach>
                <c:if test="${contentContext.contentSender && contentContext.canReply}">
                    <li id="reply_sender" class="textarea display_none form_area margin_t_15">
                        <div id="senderpostscriptDiv" class="common_txtbox clearfix ">
                        <div style="width: 750px;height: 123px;">
                            <textarea id="content" name="content" onclick="checkCommonContent();" onblur="checkCommonContentOut();" style="color: #a3a3a3; font-size: 14px;width:735px;padding-right:6px;height: 115px;">${ctp:i18n('collaboration.newcoll.fywbzyl')}</textarea>
                        </div>
                        </div>
                        <div class="comment_area_top" style="width: 747px; border-top: 0px;">
                             <!-- 发起者附言的关联文档和附件，受新建节点权限控制 -->
                             <c:if test="${newColNodePolicy.uploadRelDoc || newColNodePolicy.uploadAttachment}">   
                              <span class="area_top_icon relative comment_area_top_item" style="margin-right:2px;" onmouseout="attDivToggle('')" onmouseover="attDivToggle('')">			
                              	<span class="ico24 attachment_24" id="files_upload_type" style="margin-left:4px;vertical-align: top;"></span>
								<ul class="absolute upload_files_msg" style="bottom:auto;left: 11px;top: 0px; border: 1px solid #cacbcb;" id="upload_files_msg">
                             			<c:if test="${newColNodePolicy.uploadAttachment}">
										<li id="uploadAttachmentID" style="float:left;padding-top:0px;width: 100%;text-align: left;" onClick="insertAttachmentPoi('reply_attach_sender');"><span class="ico24 localhost_upload_24 margin_r_10 margin_l_5"></span>${ctp:i18n('collaboration.newcoll.localfile')}</li>
	                             			</c:if>
	                             			<c:if test="${newColNodePolicy.uploadRelDoc }">
										<li id="uploadRelDocID" style="float:left;padding-top:0px;width: 100%;text-align: left;" onClick="quoteDocument('reply_attach_sender');"><span class="ico24 related_document_24 margin_r_10 margin_l_5"></span>${ctp:i18n('collaboration.newcoll.relative')}</li>
									</c:if>	
								</ul>
						</span>
                             </c:if> 
                             <div class="common_checkbox_box left margin_r_5 display_inline comment_area_top_item">
                                 <label class="hand" style="font-size:14px; margin-left:20px;">
                                     <input id="pushMessage" class="radio_com" name="pushMessage" value="" checked type="checkbox">${ctp:i18n('collaboration.sender.postscript.pushMessage')}
                                 </label>
                             </div>
                             
                             <%-- 无用的元素， 防止js把下面的按钮影藏了 --%>
                             <span style="display: none"></span>
                             
                            <span class="right">
                                <a style="width: 63px; height:30px; line-height:30px; margin-top:4px; margin-right:6px; text-align:center; border:1px solid #c7d5e0;" onclick="commentHideReply('sender')"
             						 class="common_button common_button_seeyon right  margin_lr_10">${ctp:i18n('collaboration.sender.postscript.cancel')}</a>
           						<a style="width: 63px;height:30px; line-height:30px; margin-top:4px; text-align:center;" class="common_button common_button_emphasize right margin_lr_10"
              						   onclick="commentSenderReply('{this}','true')">${ctp:i18n('collaboration.sender.postscript.submit')}
            					</a>
                            </span>
                        </div>
                        <input type="hidden" id="pid" value="0"> 
                        <input type="hidden" id="clevel" value="1"> 
                        <input type="hidden" id="path" value="00"> 
                        <input type="hidden" id="moduleType" value="${contentContext.moduleType}"> 
                        <input type="hidden" id="moduleId" value="${contentContext.moduleId}"> 
                        <input type="hidden" id="extAtt1"> 
                        <input type="hidden" id="ctype" value="-1"> 
                        <input type="hidden" id="pushMessageToMembers"/>
                        <input type="hidden" id="affairId" value="${contentContext.affairId}">
                        <input type="hidden" id="title" name="title" value="${ctp:toHTMLWithoutSpace(title)}">

                        <div class='margin_t_10'><!-- 附件 -->
                            <div id="attachmentTRreply_attach_sender" class='clearFlow' style="display: none">
                                <div class="color_black left margin_r_5 font_bold margin_t_5">
                                    <em class="ico16 affix_16"></em>(<span id="attachmentNumberDivreply_attach_sender" style="margin-right: 0px;"></span>)
                                </div>
                                <div id="reply_attach_sender" style="display: none; float: right" isGrid="true" class="comp" comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${contentContext.moduleType}',attachmentTrId:'reply_attach_sender',canDeleteOriginalAtts:false"></div>
                            </div>
                            <%-- 关联文档 --%>
                            <div id="attachment2TRreply_attach_sender" class='clearFlow margin_t_5' style="display: none"><!-- 关联 -->
                                <div class="color_black left margin_r_5 font_bold margin_t_5">
                                    <em class="ico16 associated_document_16"></em>(<span id="attachment2NumberDivreply_attach_sender" style="margin-right: 0px;"></span>)
                                </div>
                                <div id="reply_assdoc_sender" class="comp" isGrid="true" style="display: none; float: right" comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'reply_attach_sender',modids:'1,3',canDeleteOriginalAtts:false"></div>
                            </div>
                        </div>
                    </li>
                </c:if>
            </ul>
        </div>
    </li>
    <%-- 当前协同评论回复区 --%>
    <li class="view_li margin_b_10 margin_t_15 padding_b_20 currentComment" id="currentComment" >
        <div class="li_title">
            <c:choose>
               <c:when test="${hidePraiseInfo || !canPraise}">
                  <%-- 影藏点赞信息 --%>
                  <span class="font_bold  font_size14 color_666">${ctp:i18n_1('collaboration.opinion.handleOpinion1',fn:length(commentList))}</span>
               </c:when>
               <c:otherwise>
                 <span class="font_bold  font_size14 color_666">${ctp:i18n_2('collaboration.opinion.handleOpinion',fn:length(commentList),praiseToSumNum)}</span>
               </c:otherwise>
            </c:choose>
        </div>
        <div class="processing_view">
            <div class="content">
                
                <c:set value="0" var="log_msg_index" />
                
                <c:forEach items="${commentList}" var="comment" varStatus="status">

                <div id="replay_c_${comment.id}" class="reply_data" 
                       mcp="${comment.maxChildPath}"
                       cp="${comment.path}">
                    <div class="per_title">
                        <div id="${comment.id}" class="left title " >
                        	<c:set var="showName" value="${comment.createName}"/>
                        	<img src="${ctp:avatarImageUrl(comment.createId)}" class="left user_photo hand">
                            <a onclick="showPropleCard('${comment.createId}')" class="padding_l_5 color_blue"  title="${showName }"
                                 id="commentSearchCreate${_sscounter}">${ctp:getLimitLengthString(showName,20,"...")}<c:if test="${comment.extAtt2 ne null }">
                                <span class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',comment.extAtt2)}</span>
                              </c:if></a>
                            <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
                            <c:if test="${ctp:isNotBlank(comment.extAtt1)}"><span class="margin_l_20 font_bold">${ctp:i18n(comment.extAtt1)}</span></c:if><span class="margin_l_${ctp:isNotBlank(comment.extAtt1)?1:2}0 font_bold">${ctp:i18n(comment.extAtt3)}</span><span class="color_gray margin_l_10">${comment.createDateStr}</span>
		                    <c:if test="${logDescMap[comment.id] != null}">
		                        <span  class="right margin_l_15 relative log_span" onmouseenter="_logSpanMouseEvent(this, 'enter')" onmouseleave="_logSpanMouseEvent(this, 'leave')">
		                            <span class="log_title current">
		                                <span class="ico16 view_log_16"></span>
		                                	${ctp:i18n('collaboration.summary.label.dealLog')}
		                            </span>
		                             
		                             <c:set value="${log_msg_index+1}" var="log_msg_index" />
		                             
	                                <div id="log_msg_index_${log_msg_index}" class="log_msg display_none">
		                              <c:forEach items="${logDescMap[comment.id]}" var="commentLog" varStatus="status">
		                              		<p title="${commentLog}" class="text_overflow padding_l_10 padding_r_10">${commentLog}</p>
		                              </c:forEach>  
		                            </div>
		                        </span>
		                    </c:if> 
	                    </div> 
	                    <div class="right">  
	                        <c:if test="${contentContext.canReply}"><a class="color_blue  margin_r_10 right font_normal" name='replayMoreDetail' onclick="commentShowReplyComment({id:'${comment.id}',clevel:${comment.clevel+1},moduleType:'${comment.moduleType}',moduleId:'${comment.moduleId}',affairId:'${comment.affairId}', createId:'${comment.createId}', createName: '${comment.createName}'}, this);">${ctp:i18n('collaboration.opinion.reply')}</a></c:if>
	                       <%-- 非隐藏点赞信息 --%><c:if test="${(hidePraiseInfo eq null || !hidePraiseInfo) && canPraise}"><span class="ico16  display_inline-block ${comment.praiseToComment ? 'like_16' : _isffin eq 1 ? 'no_like_disable_16':'no_like_16'} <c:if test='${_isffin eq 1}'>cursorDefault</c:if>" id="likeIco${comment.id}" title="<c:if test='${comment.praiseToComment && _isffin ne 1}'>${ctp:i18n('collaboration.summary.label.praisecancel')}</c:if><c:if test='${!(comment.praiseToComment) && _isffin ne 1}'>${ctp:i18n('collaboration.summary.label.praise')}</c:if>" <c:if test="${contentContext.canReply}">onclick="praiseComment('${comment.id}')"</c:if>></span><span class='color_gray  display_inline-block like_number'>(<span id='likeIcoNumber${comment.id}'  onmouseover="showOrCloseNamesDiv('${comment.id}')">${comment.praiseNumber}</span>)</span></c:if>
                        </div>
                    </div>

                  <c:set value="${empty comment.content && !comment.praiseToSummary && empty comment.children && !comment.hasRelateAttach && !comment.hasRelateDocument && empty comment.m1Info && empty comment.escapedContent}" var ="_isHiddenComment" />
	              <c:if test="${!_isHiddenComment}">
	              <ul id="ulcomContent${comment.id}">
	                   <c:if test="${not empty comment.escapedContent || comment.praiseToSummary}">
	                    	<li id="licomContent${comment.id}" class="licomContent">
		                      <c:if test="${comment.praiseToSummary}">
		                        <span class='ico16 like_16'></span>
		                      </c:if>
		                      <c:if test="${not empty comment.escapedContent}">${(comment.escapedContent)}</c:if>
		                      <c:if test="${!comment.canView}"><span id='canNotView${comment.id}'></span></c:if>
		                      <c:if test="${empty comment.content}"><span id='emtyContent${comment.id}'></span></c:if>
		                    </li>
	                   </c:if>
	                   <c:if test="${comment.hasRelateAttach && comment.canView}">
		                    <li class="clearfix" id="liAtt${comment.id}">
		                       <div class="color_black left margin_r_5 margin_t_10">
		                         <em class="ico16 affix_16"></em>
		                         (<span id="attachmentNumberDiv${comment.id}" style="margin-right: 0px"></span>)
		                       </div>
		                       <div class="right display_none comp"
		                         comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false"
		                         attsdata="${ctp:toHTML(comment.relateInfo)}">
		                       </div>
		                    </li>
	                   </c:if>
	                   <c:if test="${comment.hasRelateDocument && comment.canView}">
		                   <li class="clearfix" id="liRela${comment.id}"><!-- 关联 -->
		                       <div class="color_black left margin_r_5 margin_t_10">
		                         <em class="ico16 associated_document_16"></em>
		                         (<span id="attachment2NumberDiv${comment.id}" style="margin-right: 0px"></span>)
		                       </div>
		                       <div class="right display_none comp"
		                         comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${comment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
		                         attsdata="${ctp:toHTML(comment.relateInfo)}">
		                       </div>
		                   </li>
	                   </c:if>
	                   <c:if test="${not empty comment.m1Info}">
		                   <li class="clearfix">
		                     <div id="m1Info_${comment.id}" class="m1Info_txt clearfix color_gray">${comment.m1Info}</div>
		                   </li>
	                   </c:if>
	              		<%-- 没有二级回复的不输出 --%>
	              		<c:if test="${fn:length(comment.children) > 0}">
	              		    <li id="replyContent_${comment.id}" class="replyContentLi border_t">
                              <c:forEach items="${comment.children}" var="childComment">
                                <p id="${childComment.id}" class="comments_title_in ">
                                    <c:set var="showName" value="${childComment.createName}"/>
                                    <a onclick="showPropleCard('${childComment.createId}');" class="left title color_blue padding_lr_10" title="${showName }"
                                      id="commentSearchCreate${_sscounter}">
                                      ${ctp:getLimitLengthString(showName,20,"...")}
                                     <c:if test="${childComment.extAtt2 ne null}">
                                       <span class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',childComment.extAtt2)}</span>
                                     </c:if>
                                    </a>
                                  <span class="right color_gray margin_t_5 margin_r_10 margin_r_5">${childComment.createDateStr}</span>
                                  <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
                                </p>
                                <div class="comments_content">
                                  <c:choose>
                                    <c:when test="${childComment.canView }">
                                      <p class="font_size14">${childComment.escapedContent}</p>
                                      <c:if test="${childComment.relateInfo != null}">
                                        <div class="clearfix" style="background:none;"><!-- 附件 --> 
                                          <c:if test="${childComment.hasRelateAttach}">
                                            <div class="clearfix" style="padding-top:8px;">
                                              <div class="color_black left margin_r_5 margin_t_10">
                                                <em class="ico16 affix_16"></em>
                                                (<span id="attachmentNumberDiv${childComment.id}" style="margin-right: 0px"></span>)
                                              </div>
                                              <div  class="diaplay_none right comp"
                                                comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${childComment.id}',canDeleteOriginalAtts:false"
                                                attsdata="${ctp:toHTML(childComment.relateInfo)}">
                                              </div>
                                            </div>
                                          </c:if> <%-- 关联文档--%> 
                                          <c:if test="${childComment.hasRelateDocument}">
                                            <div class="clearfix">
                                              <div class="color_black left margin_r_5 margin_t_10">
                                                <em class="ico16 associated_document_16"></em>
                                                (<span id="attachment2NumberDiv${childComment.id}" style="margin-right: 0px"></span>)
                                              </div>
                                              <div class="diaplay_none right comp"
                                                comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${childComment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
                                                attsdata="${ctp:toHTML(childComment.relateInfo)}">
                                              </div>
                                            </div>
                                          </c:if>
                                        </div>
                                      </c:if>
                                    </c:when>
                                    <c:otherwise>
                                      ${(childComment.escapedContent)}
                                    </c:otherwise>
                                  </c:choose>
                                  <c:if test="${ctp:isNotBlank(childComment.m1Info)}">
                                        <div class="clearfix color_gray">${childComment.m1Info}</div>
                                  </c:if>
                                </div>
                             </c:forEach>
                            </li>
	              		</c:if>
	                    <%-- <c:if test="${contentContext.canReply}">
	                     	<li id="reply_${comment.id}" class="textarea display_none form_area"></li>
	                    </c:if> --%>
	               </ul>
	               </c:if>
	           </div>
               </c:forEach>
            </div>
        </div>
    </li>
         <%-- 消息推送弹出窗口区 --%>
         <div id="comment_pushMessageToMembers_dialog" class="h100b w100b" style="display: none;overflow:auto;padding:0px 20px;width:280px;">
           <div class="clearfix padding_b_5">
             <ul class="common_search right" style="padding: 2px 0px 0 0;">
               <li id="inputBorder" class="common_search_input"> 
                 ${ctp:i18n('collaboration.pushMessageToMembers.search')}：
                 <input id="comment_pushMessageToMembers_dialog_searchBox" name="pushMessageSearch" class="search_input" type="text"/>
               </li>
               <li>
                 <a id="comment_pushMessageToMembers_dialog_searchBtn" class="common_button search_buttonHand">
                   <em></em>
                 </a>
               </li>
             </ul> 
           </div>
         <div class="clearfix" style="padding-top:5px;/* height: 235px; */">
         <table id="comment_pushMessageToMembers_grid" class="only_table border_all" cellSpacing="0" cellPadding="0" width="100%">
           <thead>
             <tr style="background-color: rgb(128,171,211);">
               <th style="text-align: center; width: 20px; background-color: rgb(128,171,211);" valign="middle">
                 <input type="checkbox" class="checkclass padding_t_5" id="checkAll">
               </th>
               <th align="left" width="60%" style="background-color: rgb(128,171,211);">${ctp:i18n('collaboration.pushMessageToMembers.name')}</th>
               <th style="background-color: rgb(128,171,211);"></th>
             </tr>
           </thead>
           <tbody id="comment_pushMessageToMembers_tbody">
             <%--
             <c:forEach items="${commentPushMessageToMembersList}" var="affair" varStatus="status">
               <tr class="${affair.state == 2?'_pm_fixed':''}" align="center" memberId="${affair.memberId}">
                 <td class="border_t" style="border-right:none;<c:if test='${!status.last}'>border-bottom: none;</c:if>">
                   <input type="checkbox" class="checkclass" value="${affair.id}" memberName="${ctp:showMemberName(affair.memberId)}" memberId="${affair.memberId}"/>
                 </td>
                 <td align="left" class="border_t" style="border-right:none;<c:if test='${!status.last}'>border-bottom: none;</c:if>word-break: break-all;">${ctp:showMemberName(affair.memberId)}</td>
                 <!-- 发起人     已处理人   已暂存待办  指定回退 回退者 被回退者 -->
                 <td align="left" style="<c:if test='${!status.last}'>border-bottom: none;</c:if>" class="border_t">${affair.state == 2 ? ctp:i18n('cannel.display.column.sendUser.label') : affair.state == 3 ? ctp:i18n('collaboration.default.currentToDo') : affair.state == 4 ? ctp:i18n('collaboration.default.haveBeenProcessedPe') : affair.subState== 15 ? ctp:i18n('collaboration.default.stepBack') : affair.subState== 17 ? ctp:i18n('collaboration.default.specialBacked') : (affair.subState== 16 && affair.state ==1) ? ctp:i18n('cannel.display.column.sendUser.label') : ctp:i18n('collaboration.default.stagedToDo')}</td>
               </tr>
             </c:forEach>
              --%>
           </tbody>
         </table>
       </div>
     </div>
  </c:otherwise>
</c:choose> 



<div id="commentHTMLDiv" style="display: none">
  <input type="hidden" id="pid" value="{comment.id}"/>
  <input type="hidden" id="clevel" value="{comment.clevel}"/>
  <input type="hidden" id="path"/>
  <input type="hidden" id="moduleType" value="{comment.moduleType}"/>
  <input type="hidden" id="moduleId" value="{comment.moduleId}"/>
  <input type="hidden" id="ctype" value="1"/>
  <input type="hidden" id="affairId" value="${contentContext.affairId}"/>
  <%-- 6.0消息改造，取消消息推送 add by xuqw
  <input type="hidden" id="pushMessageToMembers" value='[["{comment.pushMsgAffairId}","{comment.createId}"]]'/> 
  --%>
  <%-- 如果at all, 保存all信息 --%>
  <input type="hidden" id="atAllMembers" name="atAllMembers" value=""/>
  <input id="pushMessage" name="pushMessage" value="true" type="hidden"/>
  <input type="hidden" id="pushMessageToMembers" value=''/> 
  <input type="hidden" id="title" name="title" value="${ctp:toHTMLWithoutSpace(title)}"/>

  <div class="common_txtbox clearfix margin_t_20" style="position: relative;">
    <!-- 意见回复 -->
    <div style="width: 708px;height: 123px;">
    	<textarea id="content" name="content" cols="20" style="font-size: 14px;padding-right:6px;width:693px;height: 115px;"></textarea>
    </div>
    <input id="replyMesP" name="replyMesP"  type="hidden"/>
    <div class="comment_area_top" style="width: 705px; border-top: 0px;">
             
            <c:set value="${canUploadAttachment != null && canUploadAttachment eq true}" var="__canUploadAttachment"/>
            <c:set value="${canUploadRelDoc == null || canUploadRelDoc eq true}" var="__canUploadRelDoc"/>
            <c:if test="${__canUploadAttachment || __canUploadRelDoc}">
            <span class="area_top_icon relative comment_area_top_item" onmouseout="attDivToggle('{comment.id}')" onmouseover="attDivToggle('{comment.id}')">
                <span class="ico24 attachment_24" id="files_upload_type" style="margin-left:4px;vertical-align: top;"></span>
                <ul class="absolute upload_files_msg" style="bottom:auto;left: 11px;top: 0px; border: 1px solid #cacbcb;" id="upload_files_msg{comment.id}">
               		<c:if test="${__canUploadAttachment}">
                    	<li id="uploadAttachmentID" style="float:left;width: 100%;text-align: left;" onClick="insertAttachmentPoi('reply_attach_{comment.id}');"><span class="ico24 localhost_upload_24 margin_r_10 margin_l_10"></span>${ctp:i18n('collaboration.newcoll.localfile')}</li>
                   	</c:if>
                   	<c:if test="${__canUploadRelDoc}">
                    	<li onClick="quoteDocument('reply_attach_{comment.id}');" style="float:left;width: 100%;text-align: left;"><span class="ico24 related_document_24 margin_r_10 margin_l_10"></span>${ctp:i18n('collaboration.newcoll.relative')}</li>
               	 	</c:if>
                </ul>
            </span>
            </c:if>
           <span class="line"></span>
       
      
            <span class="area_top_icon comment_area_top_item" style="padding-left:4px;">
                <span class="ico24 at_24" style="margin-left:-12px;vertical-align: top;" onclick="atMembers4Comment('{comment.id}')"></span>
            </span>
            <span class="line"></span>
            <span class="left comment_area_top_item" style="margin-left:5px;">
              <label class="hand label_safria" style="font-size:14px;margin-top:0px;padding-left:4px;">
                <input id="hidden" class="radio_com" name="hidden" value="true" type="checkbox" onclick="_commentHidden(this);"/>${ctp:i18n('collaboration.opinion.hidden.label')}
              </label>
            </span>
            <span class="left comment_area_top_item" style="display: none;">
              <label class="left margin_l_5 label_safria" style="font-size:14px;margin-top:0px;">${ctp:i18n('collaboration.opinion.doNotInclude')}： </label>
              <span class="margin_r_5 left comment_area_top_item" style="margin: 0px;" id='hidTo{curComment.comId}'>
                <input type="text" id="showToIdText" name="showToIdTex"
                  style="width: 72px;height: 22px;vertical-align: top;" value="{curComment.comName}"
                  title="{curComment.comName}"
                  onclick="showToIdSelectPeople('{curComment.comId}')"/>
                <input type="hidden" id="showToId" name="showToId" value="Member|{curComment.showId}"/>
              </span>
            </span>

             <a style="width: 63px; height:30px; line-height:30px; margin-top:4px; text-align:center; border:1px solid #c7d5e0;" onclick="commentHideReply('{comment.id}')"
              class="common_button common_button_seeyon right  margin_lr_10">${ctp:i18n('collaboration.sender.postscript.cancel')}</a>
            <a style="width: 63px;height:30px; line-height:30px; margin-top:4px; text-align:center;" class="common_button common_button_seeyon common_button_emphasize right margin_lr_10"
              name="buttonsure" onclick="commentReply('{comment.id}',this)">${ctp:i18n('collaboration.sender.postscript.submit')}
            </a>
       
        </div>
  </div>
  <div class="clearfix">
        
  </div>
  <!-- 附件 -->
  <div id="attachmentTRreply_attach_{comment.id}" style="display: none" class="clearFlow margin_t_10">
    <div class="color_black left margin_r_5  margin_t_5">
      <em class="ico16 affix_16"></em>
      (<span id="attachmentNumberDivreply_attach_{comment.id}" style="margin-right: 0px"></span>)
    </div>
    <div id="reply_attach_{comment.id}" style="display: none; float: right;"
      isGrid="true" class="comp"
      comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{comment.moduleType}',attachmentTrId:'reply_attach_{comment.id}',canDeleteOriginalAtts:false">
    </div>
  </div>
  <%-- 关联文档 --%>
  <div id="attachment2TRreply_attach_{comment.id}" style="display: none"
    class="clearFlow">
    <div class="color_black left margin_r_5  margin_t_5">
      <em class="ico16 associated_document_16"></em>
      (<span id="attachment2NumberDivreply_attach_{comment.id}" style="margin-right: 0px"></span>)
    </div>
    <div id="reply_assdoc_{comment.id}" style="display: none; float: right;"
      isGrid="true" class="comp"
      comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'reply_attach_{comment.id}',modids:'1,3',applicationCategory:'{comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false">
    </div>
  </div>
</div>

<script type="text/javascript">
var log_msg_index = '${log_msg_index}';
var _sscounter = '${_sscounter}';
var _commentTotal = parseInt(_sscounter) - 1;
var _scanCodeInput = '${param.scanCodeInput}';

var _xConHeightobj;
function barCode() {
	 var fnx_zwIframe;
	 if($.browser.mozilla){
	 	fnx_zwIframe = document.getElementById("zwIframe").contentWindow;
	 }else{
	 	fnx_zwIframe = document.zwIframe;
	 }
	 fnx_zwIframe.openScanPort();
}

//表单正文切换回调函数， changeViewCallBack 这个函数有时候不执行
function onSwitchFormContent(type){
    if(type=="word"){
        $("#GoTo_Top_scan").hide();
        $("#GoTo_Top_scan_iframe").hide();
    }else{
        $("#GoTo_Top_scan").show();
        $("#GoTo_Top_scan_iframe").show();
    }
}

</script>
<style>
.selectMemberName{
  background-color: #ffff00;
}
@-moz-document url-prefix(){.set_self_marginTop{margin-top:-3px;}}
</style>
