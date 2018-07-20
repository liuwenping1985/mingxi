<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-12-12 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="versionFlag" value="${param.versionFlag ne 'HistoryVersion'}"/>
<c:forEach items="${forums}" var="forum" varStatus="index">
    <li class="clearFlow padding_10 border_lr border_b">
        <img class="margin_r_5 left radius" id="personCard${forum.forum.id}" isValid="${forum.forumUserNameValid}"  userId="${forum.forum.createUserId}"  width="42" height="42" src="${v3x:avatarImageUrl(forum.forum.createUserId)}"/>
        <div class="clearFlow">
            <p class="line_height160">
            <c:choose>
                <c:when test="${(versionFlag && forum.forumUserNameValid)}">
                    <a onclick="fnPersonCard('${forum.forum.createUserId}');" href="javascript:void(0)" userId="">
                </c:when>
                <c:otherwise>
                    <a class="disabled_color margin_r_5" title="${ctp:i18n('doc.alert.user.inexistence')}" href="javascript:void(0)" userId="${forum.forum.createUserId}">
                </c:otherwise>
            </c:choose>
             ${forum.name}</a>${ctp:i18n('doc.jsp.open.body.reply')}
            <c:choose>
                <c:when test="${(versionFlag&&docCreateUserValid)}">
                    <a href="javascript:void(0)" onclick="fnPersonCard('${docCreateUserId}');">
                </c:when>
                <c:otherwise>
                    <a href="javascript:void(0)" userId="${docCreateUserId}" class="disabled_color margin_r_5" title="${ctp:i18n('doc.alert.user.inexistence')}">
                </c:otherwise>
            </c:choose>
            ${docCreateUserName}</a>:<br>${ctp:toHTML(forum.body)}    
            </p>
            <p class="clearFlow margin_t_5">
                <span class="color_gray left">
                    ${ctp:formatDateByPattern(forum.time,'yyyy-MM-dd HH:mm:ss')}
                 </span>
                 <c:if test="${versionFlag}"> 
                 <span class="right"> 
                    <a href="javascript:void(0)" docId="${docId}" forumId="${forum.forum.id}" onclick="fnReplyBtn(this);">${ctp:i18n('doc.jsp.open.body.reply')}</a>&nbsp;&nbsp; 
                    <a href="javascript:void(0)"  class="${((forum.forum.createUserId eq loginUserId)||(docCreateUserId eq loginUserId)) ?" ":"display_none"}" docId="${docId}" forumId="${forum.forum.id}" onclick="fnDelForum(this);">${ctp:i18n('doc.jsp.open.body.delete')}</a> 
                 </span>
                 </c:if>
            </p>
            <div id="divForum${forum.forum.id}" class="display_none form_area">
                <div class="clearFlow margin_t_5">
                    <div class="common_txtbox_wrap" style="padding-right:0px;"><textarea id="replyBody${forum.forum.id}" class="validate font_size12" onblur="$('#divForum${forum.forum.id}').resetValidate();" style="_width:100%; width: 100%; height: 60px; border:0;" validate='name:"${ctp:i18n('doc.jsp.knowledge.evaluation')}",notNull:true,maxLength:500,avoidChar:"-!@#$%^~\\]=\{\}\\/;[&*()<>?_+"'></textarea>
                    </div>
                </div>
                <div class="align_right margin_t_5"><a href="javascript:void(0)" parentForumId="${forum.forum.id}" docId="${docId}" onclick="fnReplyForum(this);" class="common_button common_button_gray">${ctp:i18n('doc.knowledge.publication')}</a></div>
            </div>
            <c:forEach items="${forum.replys}" var="reply" varStatus="rIndex">
                <br>
                <c:if test="${rIndex == '0'}"><hr></c:if>
                <img class="margin_r_5 left radius" id="personCard${reply.forum.id}" isValid="${reply.replyUserValid}"  userId="${reply.forum.createUserId}" width="42" height="42" src="${v3x:avatarImageUrl(reply.forum.createUserId)}" />
                    <div class="clearFlow">
                    <p class="line_height160">
                    <c:choose>
                        <c:when test="${(versionFlag&&reply.replyUserValid)}">
                            <a href="javascript:void(0)" onclick="fnPersonCard('${reply.forum.createUserId}');" class="margin_r_5">
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0)" class="disabled_color margin_r_5" title="${ctp:i18n('doc.alert.user.inexistence')}" userId="${reply.forum.createUserId}"  class="margin_r_5">
                        </c:otherwise>
                   </c:choose>
                   ${reply.name}</a>${ctp:i18n('doc.jsp.open.body.reply')}
                  <c:choose>
                        <c:when test="${(versionFlag&&forum.forumUserNameValid)}">
                            <a href="javascript:void(0)" onclick="fnPersonCard('${forum.forum.createUserId}');" class="margin_l_5">
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0)" class="disabled_color margin_r_5" title="${ctp:i18n('doc.alert.user.inexistence')}" userId="${forum.forum.createUserId}" class="margin_l_5">
                        </c:otherwise>
                   </c:choose>
                   ${forum.name}</a>:<br>${ctp:toHTML(reply.body)}
                    </p>
                      <c:if test="${versionFlag}">
                        <p class="clearFlow margin_t_5">
                            <span class="color_gray left">${ctp:formatDateByPattern(reply.time,'yyyy-MM-dd HH:mm:ss')}</span> <span
                                class="right"> <a href="javascript:void(0)" class="${((reply.forum.createUserId eq loginUserId)||(docCreateUserId eq loginUserId)) ?"display_block":"display_none"}" parentFormId="${reply.forum.id}" docId="${docId}" onclick="fnDelForum(this);">${ctp:i18n('doc.jsp.open.body.delete')}</a> 
                            </span>
                        </p>
                      </c:if>
                    </div>
            </c:forEach>
        </div>
  </li>
</c:forEach>
<span id="spanForumsNum" class="display_none">${fn:length(forums)}</span>