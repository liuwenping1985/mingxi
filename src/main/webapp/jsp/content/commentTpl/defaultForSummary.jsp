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
var _replyI18n = "${ctp:i18n('collaboration.opinion.reply')}";

var stateMemberName = "${ctp:escapeJavascript(ctp:showMemberName(contentContext.contentSenderId))}";
var startMemberId = "${contentContext.contentSenderId}";

var canPraise = "${canPraise}" == "true";
var _isffin = "${_isffin}";
var logDescMap1 = '${logDescMap}';
var logDescMap;
if(logDescMap1 =="" ){
	logDescMap = "";
}else{
	logDescMap = $.parseJSON(logDescMap1);
}
var senderLabel =  "${ctp:i18n('collaboration.sender.postscript')}";
var hideColCommentLabel =  "${ctp:i18n('collaboration.default.hideColComment')}";
var findCommentLabel = "${ctp:i18n('collaboration.default.findComment')}"
var a =0 ;
var contentAnchor = "${param.contentAnchor}";
var tps = "${param.tps}";
try{
	if(openFrom && openFrom =='newColl'){
		var style = document.createElement("link");
		style.href = "${path}/apps_res/collaboration/css/cancelHover.css";
		style.rel = "stylesheet";
		style.type = "text/css";
		document.getElementsByTagName("HEAD").item(0).appendChild(style);
	}
}catch(e){}
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
   .commentloadProcess { width: 786px; background: #fff; text-align: center; margin: 0 auto; background: #fff; color: #5891fb;padding-bottom:15px }
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

	<%-- 转发-发起人附言区DIV模板--%>
	<script type="text/html" id="forwardSenderDIVTpl">
		<span class="view_li margin_b_10">
			<div class="font_bold font_size14 li_title no_border_t color_666"
				style="margin: 25px 25px 0 25px;">{{senderLabel}}</div>
			<div class="content margin_10">
				<ul class="font_size14" id="forwardSenderDiv{{d.forwardCount}}">
					<%--138到168 转发区的发起人附言模板 --%>

				</ul>
			</div>
		</span>			
    </script>
    
	<%-- 转发-意见区模板--%>
	<script type="text/html" id="forwardCommentDIVTpl">
  		 <div class="view_li" name='outerPraiseDiv'>
			<div name='ppraiseCount' class="title font_bold font_size14 li_title no_border_t color_666">{{d.countLabel}}</div>
			<div class="content font_size12" id="forwardCommentDiv{{d.forwardCount}}">
				<%--转发区的回复意见 182-306 --%>

			</div>
		</div>
    </script>
    
    <%-- 转发-第XXX次转发的模板（发起人附言& 意见区模板）--%>
    <script type="text/html" id="fowardDIVTpl">
    	<ul id="comment_forward_region" class="view_li">

			{{# if(d.forwardCount == 1){ }}
			<div class="li_title li_title_repeat">
				<a class="right margin_r_20 font_size14" id="comment_forward_region_btn"
					showTxt="{{findCommentLabel}}" hideTxt="{{hideColCommentLabel}}">{{hideColCommentLabel}}</a>
			</div>
			{{# } }}
			<div id="fowardContainerDIV{{d.forwardCount}}" class="processing_view font_size12 padding_b_15">
				<span class="font_bold tranform_time font_size16 color_666">{{d.forwardCountLable}}</span>


			</div>
		</ul>			
    </script>

		

	<%-- 查找处理人全局计数器 --%>
	

	<li class="padding_tb_10" id="forwardAllTopDIVTpl" style="display: none">
		<div id="_commentAllDiv">
			<%-- 评论回复转发区 --%>
			<!-- 查看原协同意见   隐藏原协同意见  -->
			<c:set value="0" var="countBtn" />
			<div id="commentForwardDiv" class="commentForwardDiv" style="line-height: 20px"></div>
			<div id="forwardCommentMoreBtn" style="line-height: 40px" onclick="loadNextPageComment('1')" class='col_MoreBtn'><span class='hand'>${ctp:i18n('collaboration.summary.showMore.js')}</span></div>
		</div>
	</li>

		
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
                <%--c:forEach items="${commentSenderList}" var="comment" varStatus="status">
                    <li class="comment_li ui_print_li_borderBottom" style="<c:if test='${status.last}'>border-bottom:none;</c:if>">
                            
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
                </c:forEach--%>
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
    <li class="view_li margin_t_15 padding_b_20 currentComment" id="currentComment" >
        <div class="li_title">
            <c:choose>
               <c:when test="${hidePraiseInfo || !canPraise}">
                  <%-- 影藏点赞信息 --%>
                  <span id='_commentInfo' class="font_bold  font_size14 color_666">${ctp:i18n_1('collaboration.opinion.handleOpinion1',fn:length(commentList))}</span>
               </c:when>
               <c:otherwise>
               	 <c:set value = "${praiseToSumNum == null ? 0 : praiseToSumNum}" var = "_praiseToSumNum"/>
                 <span id="_commentInfo" class="font_bold  font_size14 color_666">${ctp:i18n_2('collaboration.opinion.handleOpinion',fn:length(commentList),_praiseToSumNum)}</span>
               </c:otherwise>
            </c:choose>
        </div>
        <div class="processing_view">
            <div class="content">
                
                <c:set value="0" var="log_msg_index" />
                
                
            </div>
        </div>
    </li>
    	<li id="commentloadProcess" class='commentloadProcess'><img src="/seeyon/common/images/load.gif"></li>	
    	<li id="curComMoreBtn" style="display: none;line-height: 40px"  class='col_MoreBtn' onclick="loadNextPageComment('2')"><span class="hand">${ctp:i18n('collaboration.summary.showMore.js')}</span></li>
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
var _commentTotal = 0;
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
<script type="text/html" id="comTemp">
{{# var comment = d; }}
{{# for(var i =0,len = comment.length;i<len;i++){ }}
<div id="replay_c_{{comment[i].id}}" class="reply_data" 
                       mcp="{{comment[i].maxChildPath}}"
                       cp="{{comment[i].path}}">
                    <div class="per_title">
                        <div id="{{comment[i].id}}" class="left title " >
							{{# var  showName = comment[i].createName; }}
							{{# var nshowName = showName.getLimitLength(20,"..."); }}								
                        	<img src="{{comment[i].avatarImageUrl}}" class="left user_photo hand">
                            <a onclick="showPropleCard('{{comment[i].createId}}')" class="padding_l_5 color_blue"  title="{{showName}}"
                                 name="commentSearchCreate">{{nshowName}}
									 {{# if(comment[i].extAtt2){ }}
                                <span class="display_inline color_red">{{comment[i].extAtt2I18n}}</span>
									{{# } }}
									</a>
							
								{{# if(comment[i].extAtt1){ }} 
								<span class="margin_l_20 font_bold">{{comment[i].extAtt1I18n}}</span>
							    {{# } }} 
							<span class="margin_l_{{# if(comment[i].extAtt1){ }}1{{# }else{ }}2{{# }}}0 font_bold">{{comment[i].extAtt3I18n}}</span><span class="color_gray margin_l_10">{{comment[i].createDateStr}}</span> 
	                    	{{# if(logDescMap[comment[i].id] != null){ }}
		                        <span  class="right margin_l_15 relative log_span" onmouseenter="_logSpanMouseEvent(this, 'enter')" onmouseleave="_logSpanMouseEvent(this, 'leave')">
		                            <span class="log_title current">
		                                <span class="ico16 view_log_16"></span>
		                                	${ctp:i18n('collaboration.summary.label.dealLog')}
		                            </span>
		                             
		                             {{# log_msg_index = log_msg_index +1; }}
	                                <div id="log_msg_index_{{log_msg_index}}" class="log_msg display_none">
									  {{# for(var n=0,len3=logDescMap[comment[i].id].length;n<len3;n++){ var commentLog = logDescMap[comment[i].id][n];  }}
		                              		<p title="{{commentLog}}" class="text_overflow padding_l_10 padding_r_10">{{commentLog}}</p>
		                              {{# } }}  
		                            </div>
		                        </span>
		                    {{# } }}
						</div> 
	                    <div class="right">  
	                        {{# if("${contentContext.canReply}" == "true"){ }}
								{{# var clc = comment[i].clevel + 1; }}
								<a class="color_blue  margin_r_10 right font_normal" name='replayMoreDetail' onclick="commentShowReplyComment({id:'{{comment[i].id}}',clevel:{{clc}},moduleType:'{{comment[i].moduleType}}',moduleId:'{{comment[i].moduleId}}',affairId:'{{comment[i].affairId}}', createId:'{{comment[i].createId}}', createName: '{{comment[i].createName}}'}, this);">{{_replyI18n}}</a>
							{{# } }}
	                       <%-- 非隐藏点赞信息 --%>
							{{#if(canPraise){ }}
								<span class="ico16  display_inline-block {{ comment[i].praiseToComment ? 'like_16' : (_isffin == 1) ? 'no_like_disable_16':'no_like_16'}} {{# if(_isffin == 1){ }}cursorDefault{{# } }}" id="likeIco{{comment[i].id}}" title="{{# if(comment[i].praiseToComment && _isffin != 1){ }} ${ctp:i18n('collaboration.summary.label.praisecancel')} {{# } }} {{# if(!comment[i].praiseToComment && _isffin !=1 ){ }} ${ctp:i18n('collaboration.summary.label.praise')} {{# } }}"
								{{# if(${contentContext.canReply}){ }}onclick="praiseComment('{{comment[i].id}}')" {{# } }}></span><span class='color_gray  display_inline-block like_number'>(<span id='likeIcoNumber{{comment[i].id}}'  onmouseover="showOrCloseNamesDiv('{{comment[i].id}}')">{{comment[i].praiseNumber}}</span>)</span>
							{{# } }}
                        </div>
                    </div>

                  {{# var _isHiddenComment = comment[i].content=="" && !comment[i].praiseToSummary && comment[i].children.length == 0 && !comment[i].hasRelateAttach && !comment[i].hasRelateDocument && comment[i].m1Info=="" && comment[i].escapedContent==""; }}
	              {{# if(!_isHiddenComment){ }}
	              <ul id="ulcomContent{{comment[i].id}}">
	                   {{# if(comment[i].escapedContent !="" || comment[i].praiseToSummary){ }}
	                    	<li id="licomContent{{comment[i].id}}" class="licomContent" style="list-style-type:none;">
		                      {{# if(comment[i].praiseToSummary){}}
		                        <span class='ico16 like_16'></span>
		                      {{# } }}
		                      {{# if(comment[i].escapedContent  !=""){ }}{{ comment[i].escapedContent}}{{# } }}
		                      {{# if(!comment[i].canView){ }}<span id='canNotView{{comment[i].id}}'></span>{{# } }}
		                      {{# if(comment[i].content =="" ){ }}<span id='emtyContent{{comment[i].id}}'></span>{{# } }}
		                    </li>
	                   {{# } }}
	                   {{# if(comment[i].hasRelateAttach && comment[i].canView){ }}
		                    <li class="clearfix" id="liAtt{{comment[i].id}}" style="list-style-type:none;">
		                       <div class="color_black left margin_r_5 margin_t_10">
		                         <em class="ico16 affix_16"></em>
		                         (<span id="attachmentNumberDiv{{comment[i].id}}" style="margin-right: 0px"></span>)
		                       </div>
							   <div class="right display_none comp"
		                         comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{comment[i].moduleType}}',attachmentTrId:'{{comment[i].id}}',canDeleteOriginalAtts:false"
		                         attsdata="{{=comment[i].relateInfo}}">
		                       </div>
		                    </li>
	                   {{# } }}
	                   {{# if(comment[i].hasRelateDocument && comment[i].canView){ }}
		                   <li class="clearfix" id="liRela{{comment[i].id}}" style="list-style-type:none;"><!-- 关联 -->
		                       <div class="color_black left margin_r_5 margin_t_10">
		                         <em class="ico16 associated_document_16"></em>
		                         (<span id="attachment2NumberDiv{{comment[i].id}}" style="margin-right: 0px"></span>)
		                       </div>
							   <div class="right display_none comp"
		                         comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'{{comment[i].id}}',modids:'1,3',applicationCategory:'{{comment[i].moduleType}}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
		                         attsdata="{{= comment[i].relateInfo}}">
		                       </div>
		                   </li>
	                   {{# } }}
	                   {{# if(comment.m1Info != ""){ }}
		                   <li class="clearfix" style="list-style-type:none;">
		                     <div id="m1Info_{{comment[i].id}}" class="m1Info_txt clearfix color_gray">{{comment[i].m1Info}}</div>
		                   </li>
	                   {{# } }}
	              		<%-- 没有二级回复的不输出 --%>
	              		{{# if(comment[i].children && comment[i].children.length > 0){  }}
	              		    <li id="replyContent_{{comment[i].id}}" class="replyContentLi border_t" style="list-style-type:none;">
                              {{# for(var m =0,len2=comment[i].children.length;m<len2;m++){ }}
								{{# var childComment = comment[i].children[m]; }}
                                <p id="{{childComment.id}}" class="comments_title_in ">
                                    {{# var showName2 = childComment.createName; }}
									{{# var nshowName = showName2.getLimitLength(20,"..."); }}
                                    <a onclick="showPropleCard('{{childComment.createId}}');" class="left title color_blue padding_lr_10" title="{{showName }}"
                                      name="commentSearchCreate">
                                      {{ nshowName }}
                                     {{# if(childComment.extAtt2){ }}
                                       <span class="display_inline color_red">{{ childComment.extAtt2I18n}}</span>
                                     {{# } }}
                                    </a>
                  <span class="right color_gray margin_t_5 margin_r_10 margin_r_5">{{childComment.createDateStr}}</span>
                                  
                                </p>
                                <div class="comments_content">
                                  
                                    {{# if(childComment.canView){ }}
                                      <p class="font_size14">{{childComment.escapedContent}}</p>
                                      {{# if(childComment.relateInfo){ }}
                                        <div class="clearfix" style="background:none;"><!-- 附件 --> 
                                          {{# if(childComment.hasRelateAttach){ }}
                                            <div class="clearfix" style="padding-top:8px;">
                                              <div class="color_black left margin_r_5 margin_t_10">
                                                <em class="ico16 affix_16"></em>
                                                (<span id="attachmentNumberDiv{{childComment.id}}" style="margin-right: 0px"></span>)
                                              </div>
                                              <div  class="diaplay_none right comp"
                                                comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{comment[i].moduleType}}',attachmentTrId:'{{childComment.id}}',canDeleteOriginalAtts:false"
                                                attsdata="{{= childComment.relateInfo}}">
                                              </div>
                                            </div>
                                          {{# } }} <%-- 关联文档--%> 
                                          {{# if(childComment.hasRelateDocument){ }}
                                            <div class="clearfix">
                                              <div class="color_black left margin_r_5 margin_t_10">
                                                <em class="ico16 associated_document_16"></em>
                                                (<span id="attachment2NumberDiv{{childComment.id}}" style="margin-right: 0px"></span>)
                                              </div>
                                             <div class="right display_none comp"
		                        				 comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'{{childComment.id}}',modids:'1,3',applicationCategory:'{{childComment.moduleType}}',referenceId:'${contentContext.moduleId}',canDeleteOriginalAtts:false"
		                         				attsdata="{{= childComment.relateInfo}}">
		                      				 </div>
                                            </div>
                                          {{# } }}
                                        </div>
                                      {{# } }}
                                    {{# }else{ }}
                                      {{childComment.escapedContent}}
                                    {{# } }}
                                  
                                  {{# if(childComment.m1Info != ""){ }}
                                        <div class="clearfix color_gray">{{childComment.m1Info}}</div>
                                  {{# } }}
                                </div>
                             {{# } }}
                            </li>
	              		{{# } }}
	               </ul>
	               {{# } }}
	           </div>

{{# } }}
</script>
<script type="text/html" id='senderTpl'>
{{# var commentSenderList = d; }}
{{# for(var a=0,len3 =commentSenderList.length;a<len3;a++){ }}
					{{#  var comment =commentSenderList[a]; }}
					{{# var isLast = a == commentSenderList.length-1; }}
                    <li class="comment_li ui_print_li_borderBottom" style="{{# if(isLast){ }} border-bottom:none;{{# } }}">
                        <div id="{{comment.id}}" class="font_size14">{{comment.escapedContent}}</div>
						{{# if(comment.hasRelateAttach){ }}
                            <!-- 插入附件 -->
                        <div class="clearfix margin_t_10" style="${comment.hasRelateDocument ? '':'padding-bottom:5px;'}">
                            <div class="left margin_r_5 margin_t_10">
                                <em class="ico16 affix_16"></em> (<span id="attachmentNumberDiv{{comment.id}}"></span>)
                            </div>
                            <div  class="display_none right comp" comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{comment.moduleType}}',attachmentTrId:'{{comment.id}}',canDeleteOriginalAtts:false" attsdata="{{=comment.relateInfo}}"></div>
                        </div>
                        {{# } }}
						{{# if(comment.hasRelateDocument){ }}
                            <!-- 关联文档 -->
                            <div class="clearfix padding_b_5 ${comment.hasRelateAttach ? '':'margin_top10'}">
                                <div class="left margin_r_5 margin_t_10">
                                    <em class="ico16 associated_document_16"></em> (<span id="attachment2NumberDiv{{comment.id}}"></span>)
                                </div>
                                <div class="display_none right comp" comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{comment.moduleType}}',referenceId:'{{_summaryId}}',attachmentTrId:'{{comment.id}}',modids:'1,3',canDeleteOriginalAtts:false" attsdata="{{= comment.relateInfo}}"></div>
                            </div>
                        {{# } }}
                        <div  class="color_gray2 margin_t_10">{{comment.createDateStr}}</div>
                    </li>
{{# } }}
</script>
<script type="text/html" id='forwardSenderDATATpl'>

{{# for(var b=0,len5 = d.length; b<len5; b++ ){  }}  
{{# var forwardSender=d[b]; }}	                                    
	                                    <div class="padding_b_15">
	                                    <div style="word-wrap: break-word">
										{{# var showName5 = forwardSender.createName; }}
	                                    	<a onclick="showPropleCard('{{forwardSender.createId}}')" class="padding_l_5 color_blue" name="commentSearchCreate">{{forwardSender.createName}}</a>
												{{forwardSender.escapedContent}}</div>
													 
										{{# if(forwardSender.hasRelateAttach){ }}
	                                        <div class="clearfix margin_t_5">
	                                        <div class="font_bold left margin_r_5 margin_t_10"><em class="ico16 affix_16"></em>(<span
	                                            id="attachmentNumberDiv{{forwardSender.id}}"
	                                            style="margin-right: 0px"></span>)</div>
	                                        <div style="display: none; float: right;" class="comp"
	                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{forwardSender.moduleType}}',attachmentTrId:'{{forwardSender.id}}',canDeleteOriginalAtts:false"
	                                            attsdata="{{=forwardSender.relateInfo}}"></div>
	                                        </div>
										{{# } }}
										{{# if(forwardSender.hasRelateDocument){ }}
	                                        <div class="clearfix margin_t_5"><!-- 关联 -->
	                                        <div class="font_bold left margin_r_5 margin_t_10"><em
	                                            class="ico16 associated_document_16"></em>(<span
	                                            id="attachment2NumberDiv{{forwardSender.id}}"
	                                            style="margin-right: 0px"></span>)</div>
	                                        <div style="float: right;" class="comp" style="display:none;"
	                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{forwardSender.moduleType}}',referenceId:'{{_summaryId}}',attachmentTrId:'{{forwardSender.id}}',modids:'1,3',canDeleteOriginalAtts:false"
	                                            attsdata="{{=forwardSender.relateInfo}}"></div>
	                                        </div>
	                                    {{# } }}
	                                    <div class="color_gray2 padding_l_5 margin_t_10 font_size12">{{forwardSender.createDateStr}}</div>
	                                    </div>
{{# } }}
</script>
<script type="text/html"  id="forwardCommentDATATpl">
{{# for(var k=0,s = d.length;k < s ;k++){ }}
	{{# var comment =  d[k];  }}
	                            <div class="reply_data_li">
	                                <div class="per_title clearfix">
	                                    <img src="{{comment.avatarImageUrl}}" width="30" height="30" class="left user_photo">
	                                <span class="title font_size12 padding_l_5 left valign_t">
											{{# var showName6 = comment.createName; }}
											{{# var nshowName6 = showName6.getLimitLength("20","...");}}
	                                    <a onclick="showPropleCard('{{comment.createId}}')" class="padding_l_5 color_blue"  title="{{showName6 }}"
	                                    	name="commentSearchCreate">{{nshowName6}}
											{{# if(comment.extAtt2){ }}
	                                    <div class="display_inline color_red">{{comment.extAtt2I18n}}</div>
{{# } }}</a>&nbsp;&nbsp;&nbsp;&nbsp;<span class="font_bold">{{# if(comment.extAtt1){ }}{{comment.extAtt1I18n}}&nbsp;&nbsp;{{# }else{ } }}{{# if(comment.extAtt3){ }}{{comment.extAtt3I18n}}{{# }else{ } }}</span>&nbsp;&nbsp;&nbsp;&nbsp;
	<span class="color_gray2 font_size12 font_normal">{{comment.createDateStr}}</span> </span><span class="right margin_r_10"> <span
	                                            class="ico16 {{# if(comment.praiseToComment){ }} like_16 {{# }else{ }} no_like_disable_16 {{# } }}  cursorDefault font_size12"
	                                            id="likeIco{{comment.id}}"></span>
	                                        <span class='color_gray font_size12 font_normal cursorDefault'>(<span id='likeIcoNumber{{comment.id}}'  
	                                            onmouseover="showOrCloseNamesDiv('{{comment.id}}')">{{comment.praiseNumber}}</span>)</span>&nbsp;&nbsp;
	                                    </span>
	                                </div>
										{{# var _isHiddenComment0 = comment.content == "" && !comment.praiseToSummary && comment.children == null && !comment.hasRelateAttach && !comment.hasRelateDocument && comment.m1Info =="" && comment.escapedContent == ""; }}
										{{# if(!_isHiddenComment0){ }} 
	                                    <ul id="ulcomContent{{comment.id}}"  class="font_size14">
	                                    <li style="list-style-type:none;">
											{{# if(comment.praiseToSummary){ }} 
	                                            <span class='ico16 like_16 cursorDefault' name='praiseInSpan'></span>
	                                        {{# } }}
											{{# if(comment.escapedContent !=""){ }}
		                                        {{comment.escapedContent}}
											{{# } }}
											{{#if(!comment.canView){ }}
	                                            <span id='canNotView{{comment.id}}' style='{{# if(comment.escapedContent){ }} ? "display:none;" {{# }else{ }} ""{{# } }}'></span>
											{{# } }}
											{{# if(comment.content ==""){ }}
	                                            <span id='emtyContent${comment.id}' style='${empty comment.content ? "display:none;" : ""}'></span>
	                                        {{# } }}
											{{# if(comment.children && comment.children.length > 0){ }}
	                                    <div id="replyContent_{{comment.id}}" class="forwardReplyContentDiv border_t">
	                                            {{# for(var l=0,p=comment.children.length;l<p;l++){ }}
												{{# var childComment =comment.children[l]; }}
	                                        <div class="comments_title_in"><span class="title left">
	                                        	{{# var showNamek =childComment.createName; }}
												{{# var nshowNamek =showNamek.getLimitLength("20","..."); }}
	                                        	<a onclick="showPropleCard('{{childComment.createId}}')" title="{{showNamek }}"
	                                            class="color_blue padding_lr_10 margin_l_5 font_size12" name="commentSearchCreate">{{nshowNamek}}{{# if(childComment.extAtt2){ }}
	                                            <div class="display_inline color_red">{{childComment.extAtt2I18n}}</div>
												{{# } }}</a></span><span class="color_gray2 font_size12 right margin_r_10">{{childComment.createDateStr}}</span></div>
													
	                                        <div class="comments_content">
												{{# if(childComment.canView){ }}
	                                              <div class="font_size14" style="line-height:25px;">{{childComment.escapedContent}}</div>
													{{# if(childComment.relateInfo != null){ }}
	                                            <div>
	                                                     <%-- 附件--%>  
	                                                      {{# if(childComment.hasRelateAttach){ }}
	                                                        <div class="clearfix margin_t_10">
	                                                          <div class="color_black left margin_r_5 margin_t_10">
	                                                            <em class="ico16 affix_16"></em>
	                                                            (<span id="attachmentNumberDiv{{childComment.id}}"style="margin-right: 0px"></span>)
	                                                          </div>
	                                                          <div class="display_none right comp"
	                                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{comment.moduleType}}',attachmentTrId:'{{childComment.id}}',canDeleteOriginalAtts:false"
	                                                            attsdata="{{=childComment.relateInfo}}">
	                                                          </div>
	                                                        </div>
														  {{# } }}
	                                                     <%-- 关联文档--%>
	                                                     {{# if(childComment.hasRelateDocument){ }}
	                                                       <div class="clearfix">
	                                                         <div class="color_black left margin_r_5 margin_t_10">
	                                                           <em class="ico16 associated_document_16"></em> 
	                                                           (<span id="attachment2NumberDiv{{childComment.id}}" style="margin-right: 0px"></span>)
	                                                         </div>
	                                                         <div class="display_none right comp"
	                                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'{{childComment.id}}',modids:'1,3',applicationCategory:'{{comment.moduleType}}',referenceId:'{{_summaryId}}',canDeleteOriginalAtts:false"
	                                                            attsdata="{{=childComment.relateInfo}}">
	                                                         </div>
	                                                       </div>
														 {{# } }}
	                                            </div>
													{{# } }}
												{{# }else{ }}
													{{childComment.escapedContent}}
												{{# } }} 
	                                                     <div class="clearfix color_gray">{{childComment.m1Info}}</div>
	                                                    <!--div class="color_gray2">{{childComment.createDateStr}}</div-->
	                                                </div>
												{{# } }}
	                                    	</div>
	                                    	{{# } }}
	                                    </li>
	                                    {{# if(comment.hasRelateAttach && comment.canView){ }}
	                                        <li id="liAtt{{comment.id}}" class="clearfix" style="list-style:none;margin-bottom: 0px; padding-bottom: 5px;">
	                                          <div class="color_black left margin_r_5 margin_t_10">
	                                            <em class="ico16 affix_16"></em>
	                                            (<span id="attachmentNumberDiv{{comment.id}}"></span>)
	                                          </div>
	                                          <div style="display: none; float: right;" class="comp"
	                                            comp="type:'fileupload',canFavourite:${param.canFavorite ? param.canFavorite:false},applicationCategory:'{{comment.moduleType}}',attachmentTrId:'{{comment.id}}',canDeleteOriginalAtts:false"
	                                            attsdata="{{=comment.relateInfo}}">
	                                          </div>
	                                        </li>
										{{# } }}
											{{# if(comment.hasRelateDocument && comment.canView){ }}
	                                        <li class="clearfix" id="liRela{{comment.id}}" style="list-style:none;margin-bottom: 0px; padding-bottom: 5px;">
	                                          <!-- 关联 -->
	                                          <div class="color_black left margin_r_5 margin_t_10">
	                                            <em class="ico16 associated_document_16"></em> 
	                                            (<span id="attachment2NumberDiv{{comment.id}}"></span>)
	                                          </div>
	                                          <div style="display: none; float: right;" class="comp"
	                                            comp="type:'assdoc',canFavourite:${param.canFavorite ? param.canFavorite:false},attachmentTrId:'{{comment.id}}',modids:'1,3',applicationCategory:'{{comment.moduleType}}',referenceId:'{{_summaryId}}',canDeleteOriginalAtts:false"
	                                            attsdata="{{=comment.relateInfo}}">
	                                          </div>
	                                        </li>
											{{# } }} 
										{{# if(comment.m1Info){  }}
	                                      <li class="clearfix padding_l_20">
						                     <div class="clearfix color_gray">{{comment.m1Info}}</div>
						                  </li>
						                {{# } }}
	                                    </ul>
	                                    {{# } }}
	                            </div>
{{# } }}

</script>

<style>
.selectMemberName{
  background-color: #ffff00;
}
@-moz-document url-prefix(){.set_self_marginTop{margin-top:-3px;}}
</style>
