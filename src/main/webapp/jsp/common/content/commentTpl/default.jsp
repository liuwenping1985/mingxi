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
<script type="text/javascript"
    src="${path}/ajax.do?managerName=ctpCommentManager"></script>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=colManager"></script>
<script type="text/javascript" charset="UTF-8"
    src="${path}/apps_res/collaboration/js/comment.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$("#senderpostscriptDiv textarea").live("click",function(){
        $(this).css("color","#111");
       
    });
var newGovdocView="${newGovdocView}";
var openForm = "${ctp:escapeJavascript(param.openFrom)}";
var _currentUserName = "${ctp:escapeJavascript(CurrentUser.name)}";
var contentAffairId = "${contentContext.affairId}";
var workflowTraceType = "${param.trackType}";
var _praiseC = "${ctp:i18n('collaboration.summary.label.praisecancel')}";
var _praise = "${ctp:i18n('collaboration.summary.label.praise')}";
var affairId="${affair.id}";
</script>
<style type="text/css">
.autoSizeSet {
    position:absolute;
    z-index: 200;
    padding:0 10px;
    line-height:25px;
    max-height: 114px;
    max-width: 394px;
    overflow: auto;
    background: #fff;
    font-size: 12px;
    font-weight: normal;
}
.seperate {
	width:1px;
	display:inline-block;
	background:#c0c5c6;
	height:12px;
	vertical-align:middle;
}
.hiddenNullOpinion{
    	display:none;
}

</style>
<!-- 如果是新公文页面 -->
<c:if test="${newGovdocView ==1}">
	<style>
		.content_view .content li textarea{
			/*width:370px;*/
			width:100%;
		}
		/*xl 6-24*/
		.content_view{
			background-color:#f0f6f8;
		}
		.content_view li.view_li{
			width:100%;
		}
		/*xl 7-1*/
		.content_view div.li_title{
			padding:5px 16px;
		}
		.processing_view .content ul li.textarea{
			padding:0;
		}
		.common_txtbox{
			margin-top:0;
		}
		/*xl 7-7说小左边距*/
		.content_view li .li_title,.processing_view .content .xl_p_l_5{
			padding-left:5px;
		}
		.xl_m_l_5{
			margin-left:5px;
		}
		/*xl 7-12*/
		.content_view .content ul{
			margin-left:10px;
		}
	</style>
</c:if>
<ul>
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
    <li class="padding_tb_10">
            <div id="_commentAllDiv"><%-- 评论回复转发区 --%> <!-- 查看原协同意见   隐藏原协同意见  -->
            <div class="view_li clearfix padding_tb_10" style="text-align: right"><a
                style="font-size: 12px; padding-right: 5px;"
                id="comment_forward_region_btn"
                showTxt="${ctp:i18n('collaboration.default.findComment')}" 
                hideTxt="${ctp:i18n('collaboration.default.hideColComment')}">${ctp:i18n('collaboration.default.hideColComment')}</a>
            </div>
            <div id="commentForwardDiv" style="line-height: 20px"><c:forEach
                items="${commentForwardMap}" var="forward" varStatus="statusForward">
                <ul id="comment_forward_region" class="view_li">
                    <div class="font_bold margin_l_20 font_size12">${ctp:i18n_1('collaboration.forward.oriOp.level.label',forward.key)}</div>
                    <div style="width: 98%;">
                    <hr style="margin-left: 15px; border-bottom: 1px solid #b6b6b6;"
                        align="center"></hr>
                    </div>
                    <c:forEach items="${forward.value}" var="forwardValue"
                        varStatus="statusForwardValue">
                        <c:if test="${forwardValue.key == -1}">
                            <span class="view_li margin_b_10"> <span
                                class="font_bold font_size12 margin_l_15">${ctp:i18n('collaboration.sender.postscript')}</span>
                            <div class="content margin_10">
                                <ul class="font_size12">
                                <c:forEach items="${forwardValue.value}" var="forwardSender"
                                    varStatus="statusForwardSender">
                                    <div class="padding_b_15">
                                    <div style="word-wrap: break-word"><a
                                        onclick="showPropleCard('${forwardSender.createId}')"
                                        class="padding_l_5 color_blue"
                                        id="commentSearchCreate${_sscounter}">${forwardSender.createName}</a>
                                    ${forwardSender.escapedContent}</div>
                                    <c:set var="_sscounter" value="${_sscounter+1}"></c:set> <c:if
                                        test="${forwardSender.hasRelateAttach}">
                                        <div class="clearfix margin_t_5">
                                        <div class="font_bold left margin_r_5"
                                            style="margin-top: 7px;"><em class="ico16 affix_16"></em>(<span
                                            id="attachmentNumberDiv${forwardSender.id}"
                                            style="margin-right: 0px"></span>)</div>
                                        <div style="display: none; float: right;" class="comp"
                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${forwardSender.moduleType}',attachmentTrId:'${forwardSender.id}',canDeleteOriginalAtts:false"
                                            attsdata="${ctp:toHTML(forwardSender.relateInfo)}"></div>
                                        </div>
                                    </c:if> <c:if test="${forwardSender.hasRelateDocument}">
                                        <div class="clearfix margin_t_5"><!-- 关联 -->
                                        <div class="font_bold left margin_r_5"
                                            style="margin-top: 7px;"><em
                                            class="ico16 associated_document_16"></em>(<span
                                            id="attachment2NumberDiv${forwardSender.id}"
                                            style="margin-right: 0px"></span>)</div>
                                        <div style="float: right;" class="comp" style="display:none;"
                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${forwardSender.moduleType}',referenceId:'${contentContext.moduleId}',attachmentTrId:'${forwardSender.id}',modids:'1,3',canDeleteOriginalAtts:false"
                                            attsdata="${ctp:toHTML(forwardSender.relateInfo) }"></div>
                                        </div>
                                    </c:if>
                                    <div class="color_gray2 padding_l_5">${forwardSender.createDateStr}</div>
                                    </div>
                                </c:forEach>
                                </ul>
                            </div>
                        </span>
                        </c:if>
                    </c:forEach>
                    <div class="processing_view font_size12 padding_b_10"><c:forEach
                        items="${forward.value}" var="forwardValue"
                        varStatus="statusForwardValue">
                            <c:if test="${forwardValue.key == 0}">
                            <span class="view_li"   name='outerPraiseDiv'
                                style="margin-bottom: -2px; padding-bottom: -2px;"> <span name='ppraiseCount'
                                class="title font_bold padding_l_15">${ctp:i18n_2('collaboration.opinion.handleOpinion',fn:length(forwardValue.value),count)}</span>
                            <div class="content font_size12 padding_l_15"><c:forEach
                                items="${forwardValue.value}" var="comment" varStatus="status">
                                <h3 class="per_title clearfix"><span
                                    class="title font_size12 padding_l_15 left"
                                    style="margin-bottom: auto;"> <a
                                    onclick="showPropleCard('${comment.createId}')"
                                    class="padding_l_5 color_blue"
                                    id="commentSearchCreate${_sscounter}">${comment.createName}<c:if
                                    test="${comment.extAtt2 ne null }">
                                    <div class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',comment.extAtt2)}</div>
                                </c:if></a>&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n(comment.extAtt1)}${ctp:isBlank(comment.extAtt1)?'':'&nbsp;&nbsp;'}${ctp:i18n(comment.extAtt3)}&nbsp;&nbsp;&nbsp;&nbsp;
                                <c:set var="_sscounter" value="${_sscounter+1}"></c:set><span class="color_gray2" style="font-weight: normal;">${comment.createDateStr}</span> </span>
                                <span class="right">
										<span class="ico16 ${comment.praiseToComment ? 'like_16' : 'no_like_disable_16'}  cursorDefault font_size12"
                                            id="likeIco${comment.id}"></span>
                                        <span class='color_gray font_size12' style="font-weight:normal;">(<span id='likeIcoNumber${comment.id}' style="cursor:pointer"
                                            onclick="showOrCloseNamesDiv('${comment.id}')">${comment.praiseNumber}</span>)</span>&nbsp;&nbsp;
                                        <div id="likeIcoDiv${comment.id}" class="hidden autoSizeSet" style="white-space:nowrap;"></div>
                                    </span>
                                    </h3>
                                	<ul id="ulcomContent${comment.id}" style="padding:0px" <c:if test="${empty comment.content && !comment.praiseToSummary && empty comment.children && !comment.hasRelateAttach && !comment.hasRelateDocument && empty comment.m1Info && empty comment.escapedContent}"> class="hiddenNullOpinion"</c:if>>
                                    <li style="padding-left: 20px"><c:if test="${comment.praiseToSummary}">
                                                                    <span class='ico16 like_16' name='praiseInSpan' style='cursor:default'></span><br/>
                                                                 </c:if><span class="font_size12" id="comContent${comment.id}">${comment.escapedContent}</span>
                                                                 <c:if test="${!comment.canView}"><span id='canNotView${comment.id}'></span></c:if>
                      										     <c:if test="${empty comment.content}"><span id='emtyContent${comment.id}'></span></c:if>
                                       <%--  <div class="color_gray2">${comment.createDateStr}</div>--%>
                                    <span id="replyContent_${comment.id}"
                                        class="${fn:length(comment.children) > 0?'':'display_none'}">
                                            <h4>${ctp:i18n('collaboration.opinion.replyOpinion')}</h4>
                                            <c:forEach items="${comment.children}" var="childComment">
                                        <div class="comments_title_in"><span class="title"><a
                                            onclick="showPropleCard('${childComment.createId}')"
                                            class="padding_l_5" id="commentSearchCreate${_sscounter}">${childComment.createName}<c:if
                                            test="${childComment.extAtt2 ne null }">
                                            <div class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',childComment.extAtt2)}</div>
                                        </c:if></a></span><span class="color_gray2">${childComment.createDateStr}</span></div>
                                                <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
                                        <div class="comments_content">
                                          <c:choose>
                                            <c:when test="${childComment.canView }">
                                              <div id="hideReplay${comment.id}">${childComment.escapedContent}</div>
                                              <c:if test="${childComment.relateInfo != null}">
                                            <div>
                                                      <!-- 附件 --> 
                                                      <c:if test="${childComment.hasRelateAttach}">
                                                        <div class="clearfix">
                                                          <div class="color_black left margin_r_5" style="margin-top: 7px">
                                                            <em class="ico16 affix_16"></em>
                                                            (<span id="attachmentNumberDiv${childComment.id}"style="margin-right: 0px"></span>)
                                                          </div>
                                                          <div style="display: none; float: right" class="comp"
                                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${childComment.id}',canDeleteOriginalAtts:false"
                                                            attsdata="${ctp:toHTML(childComment.relateInfo)}">
                                                          </div>
                                                        </div>
                                                     </c:if>
                                                     <%-- 关联文档--%>
                                                     <c:if test="${childComment.hasRelateDocument}">
                                                       <div class="clearfix">
                                                         <div class="color_black left margin_r_5" style="margin-top: 7px">
                                                           <em class="ico16 associated_document_16"></em> 
                                                           (<span id="attachment2NumberDiv${childComment.id}" style="margin-right: 0px"></span>)
                                                         </div>
                                                         <div style="display: none; float: right" class="comp"
                                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${childComment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
                                                            attsdata="${ctp:toHTML(childComment.relateInfo)}">
                                                         </div>
                                                       </div>
                                                    </c:if>
                                            </div>
                                                                </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${childComment.escapedContent}
                                                        </c:otherwise>
                                                    </c:choose> 
                                                    <!--div class="color_gray2">${childComment.createDateStr}</div-->
                                                </div>
                                    </c:forEach> </span>
                                    </li>
                                    <c:if test="${comment.hasRelateAttach && comment.canView}">
                                        <li id="liAtt${comment.id}" class="clearfix" style="margin-bottom: 0px; padding-bottom: 5px;">
                                          <div class="color_black left margin_r_5" style="margin-top: 5px;">
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
                                        <li class="clearfix" id="liRela${comment.id}" style="margin-bottom: 0px; padding-bottom: 5px;">
                                          <!-- 关联 -->
                                          <div class="color_black left margin_r_5" style="margin-top: 5px;">
                                            <em class="ico16 associated_document_16"></em> 
                                            (<span id="attachment2NumberDiv${comment.id}"></span>)
                                          </div>
                                          <div style="display: none; float: right;" class="comp"
                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},displayMode:'auto',attachmentTrId:'${comment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
                                            attsdata="${ctp:toHTML(comment.relateInfo)}">
                                          </div>
                                        </li>
                                    </c:if>
                                    </ul>
                            </c:forEach></div>
                            </span>
                            </c:if>
                    </c:forEach></div>
                </ul> 
            </c:forEach></div>
            </div>
            </li>
            
            </c:if>
            <%-- 发起人附言区 --%>
          
            <li id="replyContent_sender" class="view_li padding_b_10">
        <div class="li_title"><span class="title font_bold font_size12">${ctp:i18n('collaboration.sender.postscript')}</span>
        <c:if
            test="${contentContext.contentSender && contentContext.canReply}">
            <a class='add_new color_blue' name='senderMoreDetail'
                onclick="commentShowReply('sender','',this);">${ctp:i18n('collaboration.sender.newpostscript')}</a>
        </c:if></div>
        <div id="replyContent_sender_content" class="content font_size12"
            style="word-break: normal; word-wrap: break-word; text-justify: auto; text-align: justify;">
                    <ul style="border:none;padding:0;">
            <c:forEach items="${commentSenderList}" var="comment"
                varStatus="status">
                <li>
                            <%--c:choose>
                                <c:when test="${status.last}">
                                    <!-- 判断最后一条没有边线 -->
                                    <li style="border:none;">
                                </c:when>
                                <c:otherwise>
                                    <li>
                                </c:otherwise>
                            </c:choose--%>
                            <div style="font-size:12px;">${comment.escapedContent}</div>
                            <c:if test="${comment.hasRelateAttach}">
                            <!-- 插入附件 -->
                            <div class="clearfix">
                    <div class="left margin_r_5" style="margin-top: 7px;"><em
                        class="ico16 affix_16"></em> (<span
                        id="attachmentNumberDiv${comment.id}" style="margin-right: 0px"></span>)
                    </div>
                    <div style="display: none; float: right" class="comp"
                        comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false"
                        attsdata="${ctp:toHTML(comment.relateInfo)}"></div>
                            </div>
                            </c:if>
                            <c:if test="${comment.hasRelateDocument}">
                            <!-- 关联文档 -->
                            <div class="clearfix">
                    <div class="left margin_r_5" style="margin-top: 7px;"><em
                        class="ico16 associated_document_16"></em> (<span
                        id="attachment2NumberDiv${comment.id}" style="margin-right: 0px"></span>)
                    </div>
                    <div style="float: right" class="comp" style="display:none;"
                        comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',attachmentTrId:'${comment.id}',modids:'1,3',canDeleteOriginalAtts:false"
                        attsdata="${ctp:toHTML(comment.relateInfo) }"></div>
                            </div>
                            </c:if>
                            <div id="${comment.id}" class="color_gray2">${comment.createDateStr}</div>
                        </li>
                    </c:forEach>
        <c:if
            test="${contentContext.contentSender && contentContext.canReply}">
                        <li id="reply_sender" class="textarea display_none form_area">
            <div id="senderpostscriptDiv"
                class="common_txtbox clearfix margin_t_15"><textarea
                id="content" name="content" cols="20" rows="5"
                onclick="checkCommonContent();" onblur="checkCommonContentOut();"
                style="color: #a3a3a3; font-size: 12px;">${ctp:i18n('collaboration.newcoll.fywbzyl')}</textarea>
                            </div>
            <div class="clearfix padding_t_5"><span class="left">
            <a class='left margin_r_5 margin_t_5'
                title="${ctp:i18n('collaboration.summary.label.att')}"
                onClick="insertAttachmentPoi('reply_attach_sender');"
                style="white-space: normal; max-width: 300px;"><em
                class="ico16 affix_16"></em></a> <a class='left margin_r_5 margin_t_5'
                title="${ctp:i18n('collaboration.summary.label.ass')}"
                onClick="quoteDocument('reply_attach_sender');"
                style="white-space: normal; max-width: 300px;"><em
                class="ico16 associated_document_16"></em></a>
            <div
                class="common_checkbox_box left margin_t_5 margin_r_5 display_inline"><label
                class="hand"><input id="pushMessage" class="radio_com"
                name="pushMessage" value="" checked type="checkbox">${ctp:i18n('collaboration.sender.postscript.pushMessage')}</label></div>
            </span> <span class="right"> <a style="width: 25px"
                class="common_button common_button_emphasize "
                onclick="commentSenderReply(this)">${ctp:i18n('collaboration.sender.postscript.submit')}</a>
            <a style="width: 25px" id="cancel"
                class="common_button common_button_gray"
                onclick="commentHideReply('sender')">${ctp:i18n('collaboration.sender.postscript.cancel')}</a>
            </span></div>
            <input type="hidden" id="pid" value="0"> <input type="hidden"
                id="clevel" value="1"> <input type="hidden" id="path"
                value="00"> <input type="hidden" id="moduleType"
                value="${contentContext.moduleType}"> <input type="hidden"
                id="moduleId" value="${contentContext.moduleId}"> <input
                type="hidden" id="extAtt1"> <input type="hidden" id="ctype"
                value="-1"> <input type="hidden" id="pushMessageToMembers">
                            <input type="hidden" id="affairId" value="${contentContext.affairId}">
            <input type="hidden" id="title" name="title"
                value="${ctp:toHTMLWithoutSpace(title)}">
            <div class='margin_t_10'><!-- 附件 -->
            <div id="attachmentTRreply_attach_sender" class='clearFlow'
                style="display: none">
            <div class="color_black left margin_r_5 font_bold"><em
                class="ico16 affix_16"></em>(<span
                id="attachmentNumberDivreply_attach_sender"></span>)</div>
            <div id="reply_attach_sender" style="display: none; float: right"
                isGrid="true" class="comp"
                comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${contentContext.moduleType}',attachmentTrId:'reply_attach_sender',canDeleteOriginalAtts:false"></div>
                            </div>
                            <%-- 关联文档 --%>
            <div id="attachment2TRreply_attach_sender"
                class='clearFlow margin_t_5' style="display: none"><!-- 关联 -->
            <div class="color_black left margin_r_5 font_bold"><em
                class="ico16 associated_document_16"></em>(<span
                id="attachment2NumberDivreply_attach_sender"></span>)</div>
            <div id="reply_assdoc_sender" class="comp" isGrid="true"
                style="display: none; float: right"
                comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'reply_attach_sender',modids:'1,3',canDeleteOriginalAtts:false"></div>
                            </div>
                            </div>
                        </li>
                    </c:if>
                    </ul>
                </div>
            </li>
            <%-- 当前协同评论回复区 --%>
            <li class="view_li margin_b_10" id="currentComment">
              <div class="li_title">
                <c:choose>
                   <c:when test="${hidePraiseInfo}">
                      <%-- 影藏点赞信息 --%>
                      <span class="font_bold font_size12">${ctp:i18n_1('collaboration.opinion.handleOpinion1',fn:length(commentList))}</span>
                   </c:when>
                   <c:otherwise><!-- 加入公文取消点赞判断 -->
                     <span class="font_bold font_size12">${isGovdocForm == '1' ? (ctp:i18n_1('collaboration.opinion.handleOpinion1',fn:length(commentList))) : (ctp:i18n_2('collaboration.opinion.handleOpinion',fn:length(commentList),praiseToSumNum))}</span>
                   </c:otherwise>
                </c:choose>
              </div>
              <div class="processing_view font_size12" style="line-height: 20px;">
                <div class="content">
                  <c:forEach items="${commentList}" var="comment" varStatus="status">
                    <h3 class="per_title xl_p_l_5">
                      <span id="${comment.id}" class="left title font_size12">
                        <a onclick="showPropleCard('${comment.createId}')" class="padding_l_5 color_blue" 
                             id="commentSearchCreate${_sscounter}">${ctp:showMemberName(comment.createId)}
                          <c:if test="${comment.extAtt2 ne null }">
                            <div class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',comment.extAtt2)}</div>
                          </c:if>
                        </a>
                        <c:if test='${comment.extAtt3 eq null || comment.extAtt3 eq "" }'>
                        	<span class="xl_m_l_5 margin_l_${ctp:isBlank(comment.extAtt1)?1:2}0 font_bold">${ctp:i18n(comment.extAtt1)}</span>
                        </c:if>
                        <c:if test='${comment.extAtt3 ne null && comment.extAtt3 ne "" }'>
                        	<span class="xl_m_l_5 margin_l_${ctp:isBlank(comment.extAtt3)?1:2}0 font_bold">${ctp:i18n(comment.extAtt3)}</span>
                        </c:if>
                        <span class="xl_m_l_5 color_gray margin_l_10" style="font-weight: normal;">${comment.createDateStr}</span>
                        <c:if test="${isGovdocForm=='1' }">
                        	<span class="margin_l_10 xl_m_l_5">${comment.policyName}</span>
                        </c:if>
                     </span>
                     <span class="right">
                     	<c:if test="${contentContext.canReply}">
                         <a class="color_blue font_size12 margin_r_10" style="font-weight: normal;" name='replayMoreDetail'
                            onclick="commentShowReplyComment({id:'${comment.id}',clevel:${comment.clevel+1},moduleType:'${comment.moduleType}',moduleId:'${comment.moduleId}',affairId:'${comment.affairId}', createId:'${comment.createId}', createName: '${ctp:escapeJavascript(comment.createName)}'}, this);">
                            ${ctp:i18n('collaboration.opinion.reply')}
                         </a>
                       </c:if>
                     </span>
                     <%-- 非影藏点赞信息 --%>
                     <c:if test="${isGovdocForm != '1'}">
                     <c:if test="${hidePraiseInfo eq null || !hidePraiseInfo}">
                       <span class="right">
                         <span class="ico16 ${comment.praiseToComment ? 'like_16' : _isffin eq 1 ? 'no_like_disable_16':'no_like_16'} <c:if test='${_isffin eq 1}'>cursorDefault</c:if>" id="likeIco${comment.id}" style="font-size:12px;" 
                           title="<c:if test='${comment.praiseToComment && _isffin ne 1}'>${ctp:i18n('collaboration.summary.label.praisecancel')}</c:if><c:if test='${!(comment.praiseToComment) && _isffin ne 1}'>${ctp:i18n('collaboration.summary.label.praise')}</c:if>" <c:if test="${contentContext.canReply}">onclick="praiseComment('${comment.id}')"</c:if>>
                         </span>
                        <span class='color_gray' style="font-weight:normal;font-size:12px;padding-right:12px;">(<span id='likeIcoNumber${comment.id}' style="cursor:pointer;" onclick="showOrCloseNamesDiv('${comment.id}')"><span style="font-size: 12px;">${comment.praiseNumber}</span></span>)</span><c:if test="${contentContext.canReply}"><span style="padding-right:12px;"><em class="seperate"></em></span></c:if>
                         <div id="likeIcoDiv${comment.id}" class="hidden autoSizeSet" style="white-space:nowrap;"></div><div id="triangle${comment.id}" style="margin-top: -30px;margin-left:20px;" class="hidden likeAreaArrow"></div>
                       </span>
                     </c:if>
                     </c:if>
                  </h3>
                  <!-- xl 7-7 将编辑和删除按钮的位置移到下方 -->
                  <div class="clearfix">
                  	<span class="right">
                       <c:set var="_sscounter" value="${_sscounter+1}"></c:set>                       
                       <!-- 显示意见编辑和删除按钮区域  -->                   
                       <c:if test="${isChangeOpinion && isGovdocForm==1}">                        
                        <a class="color_blue font_size12 margin_r_10" style="font-weight: normal;" name='changeDetail'
                          onclick="ModifyComment({id:'${comment.id}',moduleId:'${comment.moduleId}',affairId:'${comment.affairId}',content:'${ctp:toHTMLWithoutSpaceEscapeQuote(comment.content)}'}, this);">
                          ${ctp:i18n('collaboration.opinion.modify')}
                       </a>
                        <a class="color_blue font_size12 margin_r_10" style="font-weight: normal;" name='delDetail'
                          onclick="delComment('${comment.id}');">
                          ${ctp:i18n('collaboration.opinion.del')}
                       </a>
                       </c:if>                      
                     </span>
                  </div>
                  <input type="hidden" id="mcp_${comment.id}" value="${comment.maxChildPath}"/>
                  <input type="hidden" id="cp_${comment.id}" value="${comment.path}"/>
                  <ul id="ulcomContent${comment.id}" style="padding:0px">
                    <li id="licomContent${comment.id}" style="<c:if test="${empty comment.content}">display:none;</c:if>word-break: normal; word-wrap: break-word; text-justify: auto; text-align: justify; clear: both;">
                      <c:if test="${comment.praiseToSummary}">
                        <span class='ico16 like_16' style='cursor:default'></span>
                      </c:if>
                      <div id="comContent${comment.id}" class="font_size12 padding_b_10">${comment.escapedContent}</div>
                      <c:if test="${!comment.canView}"><span id='canNotView${comment.id}'></span></c:if>
                      <c:if test="${empty comment.content}"><span id='emtyContent${comment.id}'></span></c:if>
                    </li>
                    <li id="replyContent_${comment.id}" class="border_t bg_color ${fn:length(comment.children) > 0?'':'display_none'}">
                      <c:forEach items="${comment.children}" var="childComment">
                        <div class="comments_title_in">
                          <span id="${childComment.id}" class="left title">
                            <a onclick="showPropleCard('${childComment.createId}');" class="font_bold color_blue padding_lr_10"
                              id="commentSearchCreate${_sscounter}">
                              ${ctp:showMemberName(childComment.createId)}
                             <c:if test="${childComment.extAtt2 ne null}">
                               <div class="display_inline color_red">${ctp:i18n_1('collaboration.agent.label',childComment.extAtt2)}</div>
                             </c:if>
                            </a>
                          </span>
                          <span class="right font_size12 color_gray margin_t_5">${childComment.createDateStr}</span>
                                        <!-- <span class="color_gray">${ctp:i18n('collaboration.opinion.reply')} ${ctp:showMemberName(comment.createId)}</span> -->
                          <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
                        </div>
                        <div class="comments_content" style="word-break: normal; word-wrap: break-word; text-justify: auto; text-align: justify;">
                          <c:choose>
                            <c:when test="${childComment.canView }">
                              <div id='hideReplay${comment.id}' class="font_size12">${childComment.escapedContent}</div>
                              <c:if test="${childComment.relateInfo != null}">
                                <div class="clearfix"><!-- 附件 --> 
                                  <c:if test="${childComment.hasRelateAttach}">
                                    <div class="clearfix">
                                      <div class="color_black left margin_r_5" style="margin-top: 7px;">
                                        <em class="ico16 affix_16"></em>
                                        (<span id="attachmentNumberDiv${childComment.id}" style="margin-right: 0px"></span>)
                                      </div>
                                      <div style="display: none; float: right;" class="comp"
                                        comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${childComment.id}',canDeleteOriginalAtts:false"
                                        attsdata="${ctp:toHTML(childComment.relateInfo)}">
                                      </div>
                                    </div>
                                  </c:if> <%-- 关联文档--%> 
                                  <c:if test="${childComment.hasRelateDocument}">
                                    <div class="clearfix">
                                      <div class="color_black left margin_r_5" style="margin-top: 7px;">
                                        <em class="ico16 associated_document_16"></em>
                                        (<span id="attachment2NumberDiv${childComment.id}" style="margin-right: 0px"></span>)
                                      </div>
                                      <div style="display: none; float: right;" class="comp"
                                        comp="type:'assdoc',displayMode:'auto',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${childComment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
                                        attsdata="${ctp:toHTML(childComment.relateInfo)}">
                                      </div>
                                    </div>
                                  </c:if>
                                </div>
                              </c:if>
                            </c:when>
                            <c:otherwise>
                              ${childComment.escapedContent}
                            </c:otherwise>
                          </c:choose>
                          <div class="clearfix color_gray">${childComment.m1Info}</div>
                        </div>
                     </c:forEach>
                   </li>
                   <c:if test="${comment.hasRelateAttach && comment.canView}">
                     <li class="clearfix" id="liAtt${comment.id}">
                       <div class="color_black left margin_r_5" style="margin-top: 7px;">
                         <em class="ico16 affix_16"></em>
                         (<span id="attachmentNumberDiv${comment.id}" style="margin-right: 0px"></span>)
                       </div>
                       <div style="display: none; float: right;" class="comp"
                         comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false"
                         attsdata="${ctp:toHTML(comment.relateInfo)}">
                       </div>
                     </li>
                   </c:if>
                   <c:if test="${comment.hasRelateDocument && comment.canView}">
                     <li class="clearfix" id="liRela${comment.id}"><!-- 关联 -->
                       <div class="color_black left margin_r_5" style="margin-top: 7px;">
                         <em class="ico16 associated_document_16"></em>
                         (<span id="attachment2NumberDiv${comment.id}" style="margin-right: 0px"></span>)
                       </div>
                       <div style="display: none; float: right;" class="comp"
                         comp="type:'assdoc',displayMode:'auto',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'${comment.id}',modids:'1,3',applicationCategory:'${comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
                         attsdata="${ctp:toHTML(comment.relateInfo)}">
                       </div>
                     </li>
                   </c:if>
                   <c:if test="${contentContext.canReply || isGovdocForm==1}">
                     <li id="reply_${comment.id}" class="textarea display_none form_area"></li>
                   </c:if>
                   <li class="clearfix">
                     <div class="clearfix color_gray">${comment.m1Info}</div>
                   </li>
                 </ul>
               </c:forEach>
             </div>
           </div>
         </li>
         <%-- 消息推送弹出窗口区 --%>
         <div id="comment_pushMessageToMembers_dialog" style="display: none">
           <div class="clearfix">
             <ul class="common_search right" style="padding: 2px 5px 0 0;">
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
         <div class="clearfix" style="padding-top:5px">
         <table id="comment_pushMessageToMembers_grid" class="only_table border_all" cellSpacing="0" cellPadding="0" width="100%">
           <thead>
             <tr style="background-color: #F6F6F6;">
               <th style="text-align: center; width: 20px;" valign="middle">
                 <input type="checkbox" class="checkclass padding_t_5" id="checkAll">
               </th>
               <th align="left" width="60%">${ctp:i18n('collaboration.pushMessageToMembers.name')}</th>
               <th></th>
             </tr>
           </thead>
           <tbody id="comment_pushMessageToMembers_tbody">
             <c:forEach items="${commentPushMessageToMembersList}" var="affair" varStatus="status">
               <tr class="${affair.state == 2?'_pm_fixed':''}" align="center" memberId="${affair.memberId}">
                 <td class="border_t">
                   <input type="checkbox" class="checkclass" value="${affair.id}" memberName="${ctp:showMemberNameOnly(affair.memberId)}" memberId="${affair.memberId}"/>
                 </td>
                 <td align="left" class="border_t">${ctp:showMemberNameOnly(affair.memberId)}</td>
                 <%-- 发起人     已处理人   已暂存待办  指定回退 回退者 被回退者 --%>
                 <td align="left" class="border_t">${affair.state == 2 ? ctp:i18n('cannel.display.column.sendUser.label') : affair.state == 3 ? '当前待办人' : affair.state == 4 ? ctp:i18n('collaboration.default.haveBeenProcessedPe') : affair.subState== 15 ? ctp:i18n('collaboration.default.stepBack') : affair.subState== 17 ? ctp:i18n('collaboration.default.specialBacked') : (affair.subState== 16 && affair.state ==1) ? ctp:i18n('cannel.display.column.sendUser.label') : ctp:i18n('collaboration.default.stagedToDo')}</td>
               </tr>
             </c:forEach>
           </tbody>
         </table>
       </div>
     </div>
  </c:otherwise>
</c:choose> 
</ul>


<div id="commentHTMLDiv" style="display: none">
  <input type="hidden" id="pid" value="{comment.id}"/>
  <input type="hidden" id="clevel" value="{comment.clevel}"/>
  <input type="hidden" id="path"/>
  <input type="hidden" id="moduleType" value="{comment.moduleType}"/>
  <input type="hidden" id="moduleId" value="{comment.moduleId}"/>
  <input type="hidden" id="ctype" value="1"/>
  <input type="hidden" id="affairId" value="${contentContext.affairId}"/>
  <input type="hidden" id="pushMessageToMembers" value='[["{comment.pushMsgAffairId}","{comment.createId}"]]'/>
  <input type="hidden" id="title" name="title" value="${ctp:toHTMLWithoutSpace(title)}"/>

  <div class="common_txtbox clearfix margin_t_20">
    <!-- 意见回复 -->
    <textarea id="content" name="content" cols="20" rows="5" style="font-size: 12px;"></textarea>
    <input id="replyMesP" name="replyMesP"  type="hidden"/>
  </div>
  <div class="clearfix">
    <table style="border:0;width: 100%">
      <tr>
        <td nowrap="nowrap" width="90%">
          <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td width="60" nowrap="nowrap">
                <c:if test="${canUploadAttachment == null || canUploadAttachment eq true}">
                  <span class="left" baseAction="UploadAttachment">
                    <span class="hand color_blue"
                      title="${ctp:i18n('collaboration.summary.label.att')}"
                      onclick="insertAttachmentPoi('reply_attach_{comment.id}');">
                      <em class="ico16 affix_16"></em>
                    </span>
                  </span>
                </c:if>
                <c:if test="${canUploadRelDoc == null || canUploadRelDoc eq true}">
                  <span class="left" baseAction="UploadRelDoc">
                    <span class="hand color_blue"
                      title="${ctp:i18n('collaboration.summary.label.ass')}"
                      onClick="quoteDocument('reply_attach_{comment.id}');">
                      <em class="ico16 associated_document_16"></em>
                    </span>
                  </span>
                </c:if>
              </td>
              <td width="1%" nowrap="nowrap">
			  <c:if test="${isGovdocForm != '1'}">
                <span>
                  <label class="hand">
                    <input id="hidden" class="radio_com" name="hidden" value="true" type="checkbox" onclick="_commentHidden(this);"/>${ctp:i18n('collaboration.opinion.hidden.label')}
                  </label>
                </span>
			  </c:if>
                <span style="display: none;">
                  <label>${ctp:i18n('collaboration.opinion.doNotInclude')}： </label>
                  <span class="margin_r_5">
                    <input type="text" id="showToIdText" name="showToIdTex"
                      style="width: 72px;" value="${ctp:showMemberName(contentContext.contentSenderId)}"
                      title="${ctp:showMemberName(contentContext.contentSenderId)}"
                      onclick="showToIdSelectPeople('{comment.id}')"/>
                    <input type="hidden" id="showToId" name="showToId" value="Member|${contentContext.contentSenderId}"/>
                  </span>
                </span>
              </td>
              <td width="1%" nowrap="nowrap">
                <div class="margin_r_5">
                  <span>
                    <label class="margin_r_5 hand">
                      <input id="pushMessage" class="radio_com" name="pushMessage" value="true" type="checkbox" onclick="_pushMessageHidden(this);"/>${ctp:i18n('collaboration.sender.postscript.pushMessage')}
                    </label>
                  </span>
                  <span style="display: none" id="reply_pushMessage_div_{comment.id}" class="display_inline">
                    <input id="reply_pushMessage_{comment.id}" value=""
                      type="text"
                      onclick="pushMessageToMembers($(this),$('#reply_{comment.id} #pushMessageToMembers'),null,'{comment.createId}','${contentContext.affairId}')"
                      style="width: 66px;"/>
                  </span>
                </div>
              </td>
              <td nowrap="nowrap" align="right">
                <a style="width: 25px; margin-bottom: 1px;" class="common_button common_button_emphasize"
                  name="buttonsure" onclick="commentReply('{comment.id}',this)">${ctp:i18n('collaboration.sender.postscript.submit')}</a>
                <a style="width: 25px; margin-bottom: 1px;" onclick="commentHideReply('{comment.id}')"
                  class="common_button common_button_gray">${ctp:i18n('collaboration.sender.postscript.cancel')}</a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
  <!-- 附件 -->
  <div id="attachmentTRreply_attach_{comment.id}" style="display: none" class="clearFlow">
    <div class="color_black left margin_r_5 font_bold" style="margin-top: 2px;">
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
    <div class="color_black left margin_r_5 font_bold" style="margin-top: 2px;">
      <em class="ico16 associated_document_16"></em>
      (<span id="attachment2NumberDivreply_attach_{comment.id}" style="margin-right: 0px"></span>)
    </div>
    <div id="reply_assdoc_{comment.id}" style="display: none; float: right;"
      isGrid="true" class="comp"
      comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'reply_attach_{comment.id}',modids:'1,3',applicationCategory:'{comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false">
    </div>
  </div>
</div>
<!-- 编辑意见区域 -->
<form id="opinionForm">
<div id="modifyCommentHTMLDiv" style="display: none">
  <input type="hidden" id="pid" value="{comment.id}"/>
  <input type="hidden" id="path"/>
  <input type="hidden" id="moduleId" value="{comment.moduleId}"/>
  <input type="hidden" id="affairId" value="${contentContext.affairId}"/>
  <input type="hidden" id="title" name="title" value="${ctp:toHTMLWithoutSpace(title)}"/>
  <div class="common_txtbox clearfix margin_t_20">
    <!-- 意见回复 -->
    <textarea id="modifyContent" name="modifyContent" cols="20" rows="5" style="font-size: 12px;"></textarea>
  </div>
  <div class="clearfix">
    <table style="border:0;width: 100%">
      <tr>
        <td nowrap="nowrap" width="90%">
          <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td width="80" nowrap="nowrap">
                <c:if test="${canUploadAttachment == null || canUploadAttachment eq true}">
                  <span class="left" baseAction="UploadAttachment">
                    <span class="hand color_blue"
                      title="${ctp:i18n('collaboration.summary.label.att')}"
                      onclick="opinionEditAttachment('{comment.id}');">
                      <em class="ico16 affix_16"></em>修改附件
                    </span>
                  </span>
                </c:if>
              </td>    
              <td nowrap="nowrap" align="right">
                <a style="width: 25px; margin-bottom: 1px;" class="common_button common_button_emphasize"
                  name="buttonsure" onclick="saveCommentModfiy('{comment.id}',this)">${ctp:i18n('collaboration.sender.postscript.submit')}</a>
                <a style="width: 25px; margin-bottom: 1px;" onclick="commentHideReply('{comment.id}')"
                  class="common_button common_button_gray">${ctp:i18n('collaboration.sender.postscript.cancel')}</a>
              </td>
            </tr>
          </table>
          <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td width="80" nowrap="nowrap">
                <c:if test="${canUploadAttachment == null || canUploadAttachment eq true}">
                <!-- 附件 -->
				  <div id="attachmentTRreply_modify_attach_{comment.id}" style="display: none" class="clearFlow">
				    <div class="color_black left margin_r_5 font_bold" style="margin-top: 2px;">
				      <em class="ico16 affix_16"></em>
				      (<span id="attachmentNumberDivreply_modify_attach_{comment.id}" style="margin-right: 0px"></span>)
				    </div>
				    <div id="reply_attach_{comment.id}" style="display: none; float: right;"
				      isGrid="true" class="comp"
				      comp="type:'fileupload',canFavourite:false,applicationCategory:'{comment.moduleType}',attachmentTrId:'reply_modify_attach_{comment.id}',canDeleteOriginalAtts:false">
				    </div>
				  </div>
				  <%-- 关联文档 --%>
				  <div id="attachment2TRreply_modify_attach_{comment.id}" style="display: none"
				    class="clearFlow">
				    <div class="color_black left margin_r_5 font_bold" style="margin-top: 2px;">
				      <em class="ico16 associated_document_16"></em>
				      (<span id="attachment2NumberDivreply_modify_attach_{comment.id}" style="margin-right: 0px"></span>)
				    </div>
				    <div id="reply_modify_assdoc_{comment.id}" style="display: none; float: right;"
				      isGrid="true" class="comp"
				      comp="type:'assdoc',canFavourite:false,attachmentTrId:'reply_modify_attach_{comment.id}',modids:'1,3',applicationCategory:'{comment.moduleType}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false">
				    </div>
				  </div>
                </c:if>
              </td>    
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</div>
</form>
<script type="text/javascript">
var _sscounter = '${_sscounter}';
var  _commentTotal = parseInt(_sscounter) - 1;
var _xConHeightobj;
function init_goToTop () {
    var _goToReplyHeight = $("#cc").height();
    // 返回顶部
    new GoTo_Top({ showHeight: $(window).height(), marginLeft: 790, sTitle: "返回顶部" });

    // 滚动到回复区
    if (_goToReplyHeight == 0) {
        _goToReplyHeight = 786;
    };
    _xConHeightobj = new GoTo_Top({
        id: "goToReply",
        btnClass: "goToReply",
        showHeight: $(window).height(),
        marginLeft: 792,
        nGoToHeight: _goToReplyHeight,
        sTitle: "返回意见区"
    });
}
$(function(){
    //###特殊处理### ie8下延时3秒来设置返回顶部按钮。因为$("#cc")页面加载完还没有内容，获取的高度不对
    setTimeout(function(){
        init_goToTop();
    },2000);
    //xl 7-12 取消发起人附言中关联文档的滚动条
    if(newGovdocView ==1){
    	$("#attachment2Areareply_attach_sender").css("max-height","none");
    }
});
</script>
<style>
.selectMemberName{
  background-color: #ffff00;
}
</style>