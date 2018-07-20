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
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="hasAtts" value="<span class='ico16 affix_16'></span>"/>
<%--知识广场宣传模版 --%>
<c:forEach items="${hotDoc}" var="docZoneHot" varStatus="index">
<c:set var="isOwner" value="${CurrentUser.id == docZoneHot.id }"/>
    <div id="docEdge" class="file_box_area margin_t_10 ${(index.index+1)% 3 != 0?"margin_r_42":""}">
	<div class="clearfix padding_10">
		<span class="ico32 fileType_${docZoneHot.mimeTypeId} margin_r_10 left"></span>
		<div class="over_auto_hiddenY left_ie6">
			<p class="file_box_area_title" title="${ctp:toHTML(docZoneHot.frName)}">
				<a id="title" href="javascript:fnOpenKnowledge('${docZoneHot.id}',0,null,true);">${ctp:toHTML(docZoneHot.frNameShort)}${docZoneHot.hasAttachments?hasAtts:""}</a>
			</p>
			<c:if test="${!docZoneHot.pig}">
				<span class="${docZoneHot.avgScoreCss}" title="${docZoneHot.avgScore}"></span>
			</c:if>	
            <c:if test="${docZoneHot.pig}">
                <span class="stars0" style="background-image: none;"></span>  
            </c:if>
			<p class="margin_t_5 color_gray clearfix">
                <span class="left">${ctp:i18n('doc.jsp.knowledge.createUser.label')}</span>
            <c:choose>
                <c:when test="${docZoneHot.createUserValid}">
                    <a class="left text_overflow" style="display: inline-block;width: 50px;" onclick='javascript:fnPersonCard(this);' title="${docZoneHot.createUserName}" userId="${docZoneHot.createUserId}">
                </c:when>
                <c:otherwise>
                    <a class='left text_overflow disabled_color' style="display: inline-block;width: 50px;" title="${ctp:i18n('doc.alert.user.inexistence')}" userId="${docZoneHot.createUserId}">
                </c:otherwise>
            </c:choose>
            ${docZoneHot.createUserName}</a>(${ctp:formatDate(docZoneHot.createTime)})
            </p>
		</div>
	</div>
	<div class="clearfix border_t">
            <c:choose>
                <c:when test="${isAccessCount}">
                    <span class="color_gray left padding_tb_5 padding_l_5">${ctp:i18n('doc.knowledge.read')}(${docZoneHot.accessCount})
                </c:when>
                <c:otherwise>
                    <span class="color_gray left padding_tb_5 padding_l_5">${ctp:i18n('doc.jsp.knowledge.evaluation')}(${docZoneHot.commentCount})
                </c:otherwise>
            </c:choose>
			<c:choose>
				<c:when test="${docZoneHot.createUserId != CurrentUser.id && (docZoneHot.potent.all || docZoneHot.potent.edit || docZoneHot.potent.readOnly || docZoneHot.potent.read)}">
                    <a id="favoriteSpan${docZoneHot.id}" class="${docZoneHot.collect ?'display_none':''}" href="javascript:favorite('3','${docZoneHot.id}',false,3);">${ctp:i18n('doc.jsp.knowledge.collection')}(${docZoneHot.collectCount})&nbsp;</a>
                    <a id="cancelFavorite${docZoneHot.id}" class="${!docZoneHot.collect ?'display_none':''}" href="javascript:cancelFavorite('3','${docZoneHot.id}',false,3);">${ctp:i18n('doc.jsp.cancel.collection')}(${docZoneHot.collectCount})&nbsp;</a>
				</c:when>
				<c:otherwise>
					<span>${ctp:i18n('doc.jsp.knowledge.collection')}(${docZoneHot.collectCount})&nbsp;</span>
				</c:otherwise>
			</c:choose>       
			<c:choose>
				<c:when test="${docZoneHot.recommendEnable}">
					<a id="recommend" href="javascript:fnCommend('${docZoneHot.id}', '${docZoneHot.recommendEnable}');">
						${ctp:i18n('doc.jsp.knowledge.recommend')}(${docZoneHot.recommendCount})&nbsp;</a>
				</c:when>
				<c:otherwise>
					<span>${ctp:i18n('doc.jsp.knowledge.recommend')}(${docZoneHot.recommendCount})&nbsp;</span>
				</c:otherwise>
			</c:choose>         
		</span> <span class="right"> <span class="file_box_menu"> <a
				href="javascript:void(0);" class="ico16 FBM_setting"></a>
		</span>
			<div class="file_box_menu_list">
                <c:set value="${ctp:escapeJavascript(docZoneHot.name)}" var="docZoneHotName" />
				<ul class="lvl1">
					<li class="${(docZoneHot.potent.readOnly && (v3x:hasNewCollaboration() || v3x:hasNewMail() )) ? '' :'display_none'}"><a href="javascript:void(0);"><em class="ico16 forwarding_16 lvlIcon"></em>${ctp:i18n('doc.menu.forward.label')}</a><span
						class="ico16 arrow_gray_r left"></span>
						<div class="lvl2_box">
							<ul class="lvl2">
								<li class="${v3x:hasNewCollaboration() ? '' :'display_none'}"><a href="javascript:forwardDocToCol('${docZoneHot.id}', '${docZoneHot.docLibId}', '${docZoneHot.frType}', '${docZoneHot.sourceId}');">${ctp:i18n('doc.jsp.knowledge.forward.collaboration')}</a></li>
								<li class="${v3x:hasNewMail()? '' :'display_none'}"><a href="javascript:forwardDocToEmail('${docZoneHot.id}', '${docZoneHot.docLibId}', '${docZoneHot.frType}', '${docZoneHot.sourceId}');">${ctp:i18n('doc.jsp.knowledge.forward.mail')}</a></li>
							</ul>
						</div>
                    </li>
                    <li class="${(ctp:getBrowserFlagByRequest('HideMenu', pageContext.request) && (docZoneHot.potent.all || docZoneHot.potent.edit || docZoneHot.potent.readOnly || ( docZoneHot.potent.create && docZoneHot.createUserId == CurrentUser.id)) && (docZoneHot.frType != 1)) ? '' :'display_none'}"><a href="javascript:downloadDoc('${docZoneHot.id}','${docZoneHotName}','${docZoneHot.mimeTypeId}','${docZoneHot.sourceId}','${docZoneHot.fileCreateDate}','${docZoneHot.vForDocDownload}');"><em class="ico16 download_16 lvlIcon"></em>${ctp:i18n('doc.menu.download.label')}</a></li>
					<li><a href="javascript:fnViewProperty('${docZoneHot.id}','1','${docZoneHot.docLibId}','${docZoneHot.frType}','${docZoneHot.pig}','${docZoneHot.vForDocPropertyIframe}');"><em class="ico16 attribute_16 lvlIcon"></em>${ctp:i18n('doc.jsp.open.label.prop')}</a></li>
                    <li class="${isAdmin || (docZoneHot.createUserId == CurrentUser.id) ? '':'display_none'}"> <a id="cancelPublicId" href="javascript:fnCancelPublic('${docZoneHot.id}');"><em class="ico16 unPublicSquare_16 lvlIcon"></em>${ctp:i18n('doc.knowledge.square.cancel.public')}&nbsp;</a></li>
				</ul>
			</div>
		</span>
	</div>
</div>
</c:forEach>
<!-- 没有数据时 -->
<c:if test="${empty hotDoc}">
    <div class="align_center padding_tb_10 color_gray"><img class="valign_m margin_r_10" src="${path}/skin/default/images/zszx_empty.png" /><span id="queryEmptyAlert">${ctp:i18n('doc.knowledge.blank.warning')}!</span></div>
</c:if>
<!-- 传递参数 -->
<div id="divHiddenPage" class="display_none">${pages}</div>
<div id="divHiddenTotal" class="display_none">${total}</div>