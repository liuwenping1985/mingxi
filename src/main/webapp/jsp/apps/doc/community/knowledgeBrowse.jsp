<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-12-12 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('doc.jsp.knowledge.docopendialogonlyid.title')}</title>
<style type="text/css">
.stadic_head_height {
    height: 85px;
}
.stadic_body_top_bottom {
    bottom: 0;
    top: 85px;
}
.stadic_head_height2 {
    height: 310px;
}
.stadic_body_top_bottom2 {
    bottom: 0px;
    top: 325px;
}
</style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<script type="text/javascript" src="${path}/apps_res/doc/js/docFavorite.js"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>

<script type="text/javascript" charset="UTF-8">
    <%@include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
    <%@include file="/WEB-INF/jsp/apps/doc/js/knowledgeBrowse.js"%>
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
v3x.loadLanguage("/apps_res/doc/i18n");

var fromGenius = false;
try{
	fromGenius = getA8Top().location.href.indexOf('a8genius.do') > -1;
}catch(e){}

var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>"

</script>
</head>
<body class="h100b over_hidden page_color">
<c:set var="isOffice" value="${doc.mimeTypeId==23 || doc.mimeTypeId==24 || doc.mimeTypeId==25 || doc.mimeTypeId==26 || doc.mimeTypeId==101 || doc.mimeTypeId==102 || doc.mimeTypeId==120 || doc.mimeTypeId==121}"/>
<!-- 协同保存附件的标题 -->
<input type="hidden" id="subject" name="subject" value="${ctp:toHTML(doc.frNameRemoveOffficeFromat)}">
<div id="fromDiv"></div>
    <div id='layout'  class="comp" comp="type:'layout'">
		<c:if test="${docOpenFlag eq 'true'}">
        <%--右边区域 --%>
        <div class="layout_east over_hidden" id="east" layout="border:false,width:310,maxWidth:310,minWidth:310,spiretBar:{show:true,handlerL:function(){$('#layout').layout().setEast(310);},handlerR:function(){$('#layout').layout().setEast(0);}}">
            <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
                <span class="ico16 arrow_2_l"></span> ${ctp:i18n('doc.knowledge.operation')}
            </div>
            <div id="deal_area" class="h100b">
                <div class="padding_lr_10 font_size12 h100b border_l">
                    <div class="stadic_layout h100b" >
                        <div class="stadic_layout_head stadic_head_height2" layout="height:30,sprit:false,border:false" id="divToolBarId">
                            <%--菜单 --%>
                            <div id="toolbar"></div>
                            <div class="hr_heng"></div>
                            <div class="font_bold font_size14 margin_t_5">${ctp:i18n('doc.knowledge.doc.info')}</div>
                            <div class="clearFlow color_orange font_size14 margin_t_5" id="divAvgSpanId" style="height:40px;">
                                <span id="spanAvgSpan" class="font_size14 left line_height160 margin_t_10">${avgScore}</span> 
                                <span id="starAvgSpan" docId="${doc.id}" class="${avgScoreCss} left margin_t_15 margin_l_5 hand" title="${ctp:i18n('doc.knowledge.doc.score')} : ${avgScore}"><table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" style="font-szie:10px;"><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></table></span>
                            	<span id="remindToolTipAvgSpan" class="hidden left bg_color_yellow font_size12 border_all margin_l_10"><span class="tooltip absolute"><em class="tooltip_em" style="left: -6px;top:15px; width: 6px; height: 11px; background-position: -22px -160px; "></em></span><table cellpadding='0' cellspacing='0' border='0' ><tr><td><font>${ctp:i18n('doc.knowledge.remindtooltipavgspan')}</font></td><td><span class='mark_score_tip display_inline-block' /></td></tr></table></span>
                            </div>
                            <div class="margin_t_5">
                                <span class="color_gray2" title="${ctp:i18n('doc.metadata.def.size')} : ${prop.size}">${ctp:i18n('doc.metadata.def.size')}: ${prop.size}</span>
                            </div>
                            <div class="margin_t_5">
                                <span class="color_gray2" title="${ctp:i18n('doc.jsp.knowledge.query.key')}: <c:out value='${prop.keywords}' escapeXml='true' />">${ctp:i18n('doc.jsp.knowledge.query.key')} : <c:out value='${prop.keywords}' escapeXml='true' /></span>
                            </div>
                            <div class="margin_t_5">
                                <span class="color_gray2" title="${ctp:i18n('doc.jsp.properties.common.accesscount')}：${prop.accessCount}">${ctp:i18n('doc.knowledge.read')}(${prop.accessCount})</span>
                                 <c:choose>
                                    <c:when test="${ctp:getBrowserFlagByRequest('HideMenu', pageContext.request) && (docPotent.all || docPotent.edit || docPotent.readOnly || (docPotent.create && doc.createUserId == CurrentUser.id))}">
                                        <a href="javascript:void(0);" onclick="fnDocDownLoad();" class="margin_l_5" title="${ctp:i18n('doc.knowledge.download.count')}：${doc.downloadCount}">${ctp:i18n('doc.menu.download.label')}(<span id="spanDownloadCountId">${doc.downloadCount}</span>)</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="color_gray2 margin_l_5" title="${ctp:i18n('doc.knowledge.download.count')}：${doc.downloadCount}">${ctp:i18n('doc.menu.download.label')}(${doc.downloadCount})</span>
                                    </c:otherwise>
                                 </c:choose>     
                                <c:choose>
                                    <c:when test="${((doc.createUserId != CurrentUser.id && isPrivateLib)||(!isPrivateLib)) && param.openFrom != 'glwd' && (docPotent.all || docPotent.edit || docPotent.readOnly || docPotent.read) && !isHistory && !isLinkOpenNoneAcl}">
                                            <a id="favoriteSpan${doc.id}" class="margin_l_5 ${isCollect ?'display_none':''}"  href="javascript:void(0);" onclick="favorite('3','${doc.id}',false,3);" title="${ctp:i18n('doc.knowledge.collect.count')}：${doc.collectCount}">${ctp:i18n('doc.contenttype.shoucang.js')}(<span id="spanCollectCountId">${doc.collectCount}</span>)</a>
                                            <a id="cancelFavorite${doc.id}" class="margin_l_5 ${!isCollect ?'display_none':''}" href="javascript:void(0);" onclick="cancelFavorite('3','${doc.id}',false,3);" title="${ctp:i18n('doc.knowledge.collect.count')}：${doc.collectCount}">${ctp:i18n('doc.jsp.cancel.collection.js')}(<span id="spanCollectCountId2">${doc.collectCount}</span>)</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="color_gray2 margin_l_5" title="${ctp:i18n('doc.knowledge.collect.count')}：${doc.collectCount}">${ctp:i18n('doc.contenttype.shoucang')}(<span id="spanCollectCountId">${doc.collectCount}</span>)</span>
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                	<c:when test="${doc.recommendEnable && param.openFrom != 'glwd' && !isHistory}">
                                		<a id="recommend" href="javascript:void(0);" class="margin_l_5" title="${ctp:i18n('doc.jsp.properties.common.recommendcount')}：${doc.recommendCount}" 
                                			onClick="fnCommend('${doc.id}', '${doc.recommendEnable}');">
											${ctp:i18n('doc.jsp.knowledge.recommend')}(<span id="spanRecommendCountId">${doc.recommendCount}</span>)&nbsp;</a> 
                                	</c:when>
                                	<c:otherwise> 
                                		<span class="color_gray2 margin_l_5" title="${ctp:i18n('doc.jsp.properties.common.recommendcount')}：${doc.recommendCount}">${ctp:i18n('doc.jsp.knowledge.recommend')}(<span id="spanRecommendCountId">${doc.recommendCount}</span>)</span>		
                                	</c:otherwise>
                                </c:choose>                           
                            </div>
                            <div class=" ${(doc.commentEnabled && param.openFrom != 'glwd') ? '' :'display_none'}">
                                <c:set value="onclick='fnPublishComment(this);'" var="clickEvent"/>
                                <c:set value="${param.versionFlag eq 'HistoryVersion'}" var="isHistoryVersion"/>
                                <div class="hr_heng margin_t_5"></div>
                                <div class="color_gray margin_t_5">${ctp:i18n('doc.knowledge.public.comment')}:</div>
                                <div id="submitPublishCommentId" class="form_area margin_t_5">
                                    <div class="margin_t_5 clearFlow">
                                        <div class="common_txtbox_wrap">
                                            <textarea ${isHistoryVersion ? 'disabled="disabled"':''} id="body" class="validate font_size12 ${isHistoryVersion ? 'bg_color_gray':''}"
                                                style="width: 100%; height: 60px; border: 0;" onblur="$('#submitPublishCommentId').resetValidate();"
                                                validate='name:"${ctp:i18n('doc.jsp.knowledge.evaluation')}",notNull:true,maxLength:500,character:"-!@#$%^~\\]=\{\}\\/;[&*()<>?_+"'></textarea>
                                        </div>
                                    </div>
                                    <div class="align_right margin_t_5">
                                        <a id="btnPublish" href="javascript:void(0)" ${isHistoryVersion ? "":clickEvent} 
                                            docId="${doc.id}" class="common_button common_button_gray ${isHistoryVersion ? "common_button_disable":""}">${ctp:i18n('doc.knowledge.publication')}</a>
                                    </div>
                                    <div class="hr_heng margin_t_5"></div>
                                    <div class="color_gray margin_t_5">
                                        ${ctp:i18n('doc.knowledge.current.comment')}(<span id="spanInputForumNum"></span>)
                                    </div>
                                </div>
                                <div class="stadic_layout_body stadic_body_top_bottom2 over_y_auto bg_color_white" id="forumsSpace">
                                    <ul id="forumsId" class="clearFlow border_t">
                                        <%--评论内容位置 --%>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </c:if>
        <div class="layout_center over_hidden h100b"  id="center" layout="border:false">
            <!--查看区域-->
            <div class="h100b stadic_layout border_r" style="overflow: hidden;">
                <div id="layout_hhh" class="stadic_layout_head stadic_head_height  h100b" layout="border:false">
                    <!--标题+附件区域-->
                    <div id="docPrintTitle" class="newinfo_area title_view">
                       <table border="0" cellspacing="0" cellpadding="0" width="100%" style="table-layout : fixed;">
                            <tr>
                                <td width="80" title="${ctp:toHTML(doc.frName)}" id="frName"> 
                                    <div class="color_gray2 align_right">${ctp:i18n('doc.jsp.open.body.name')}:</div>
                                </td>
                                <td class="text_overflow w100b" title="${ctp:i18n('doc.knowledge.doc.title')} : ${ctp:toHTML(doc.frName)}"><b>${ctp:toHTML(doc.frName)}</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="color_gray2 align_right">${ctp:i18n('doc.metadata.def.creater')}:</div>
                                </td>
                                <td><a ${createUserValid?"onclick='fnPersonCard();'":"class='disabled_color'"}
                                    title="${createUserValid?"":"无法"}${ctp:i18n('doc.click.show.person')}${createUserValid?"":"，该人员已离职或者被删除！"}">${createUserName}</a>
                                    (${ctp:formatDateByPattern(isHistory ? doc.lastUpdate:doc.createTime,'yyyy-MM-dd HH:mm:ss')})</td>
                            </tr>
                            <tr id="attachmentTR" style="display:none;">
                                <td class="align_right">
                                    <span class="ico16 affix_16"></span></div>
                                </td>
                                <td id="attachment2">
                                    <div class="affix_area">
                                        <div id="docAttachment">
                                            <span class="attachment_block_number left margin_t_5">(<span id="attachmentNumberDiv"></span>)</span>
                                            <div class="comp" comp="type:'fileupload',canFavourite:${docCollectFlag},takeOver:false,applicationCategory:'1',canDeleteOriginalAtts:false,originalAttsNeedClone:false,isEncrypt:false,quantity:5" attsdata='${attachmentsJSON}'>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr id="attachment2TRposition1" style="display:none;">
                                <td class="align_right">
                                    <span class="ico16 relate_file_16"></span></div>
                                </td>
                                <td id="attachment1">
                                    <div class="affix_area">
                                        <span class="attachment_block_number left margin_t_5">
                                            <span>(<span id="attachment2NumberDivposition1"></span>)</span>
                                        </span>
                                        <div id="relaAttachment">
                                            <div class="comp"  comp="type:'assdoc', canDeleteOriginalAtts:false, attachmentTrId:'position1', modids:'1,3'" attsdata='${attachmentsJSON}'></div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>                 
                    </div>
                    <!--命令按钮区域-->
                    <div id="docPrintTitle2" style="display: none; width: 0px; height: 0px;">
            <table border="0" cellpadding="0" cellspacing="0" width="100%" height="50" align="center">
                <tr>
                    <td height="10" class="detail-summary">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" class="sort ellipsis" align="center">
                          
                            <tr>
                                <td id="nameLabelTD" width="90" height="28" valign="top" nowrap class="bg-gray font-size-12 detail-subject align_right">
                                    ${ctp:i18n('doc.jsp.open.body.name')}:
                                </td>
                                <td id="nameValueTD" title="${v3x:toHTML(doc.frName)}" class="detail-subject font-size-12 breakWord">
                                    <c:out value="${doc.frName}" escapeXml="true" />
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td id="createrLabelTD" height="22" nowrap class="bg-gray font-size-12 align_right">
                                    ${ctp:i18n('doc.metadata.def.creater')}:
                                </td>
                                <td id="createrValueTD" height="22" nowrap class="font-size-12">
                                    <span class="cursor-hand" onclick="showV3XMemberCard('${doc.createUserId}')">${v3x:showMemberName(doc.createUserId)}</span>
                                    (<fmt:formatDate value='${isHistory ? doc.lastUpdate : doc.createTime}' pattern='yyyy-MM-dd HH:mm:ss' />)
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>    
        </div>
                <div class="orderBt right margin_r_10">
                    <table  cellSpacing="0" cellPadding="0" border="0">
                    	<tr>
							<c:if test="${docOpenFlag ne 'true'}">
                    		<td>
                    			<div id="toolbar"></div>
                    		</td>
                    		</c:if>
                    		<td class="common_toolbar_box">
                    <c:if test="${ctp:getBrowserFlagByRequest('HideMenu', pageContext.request) && isOffice && !isHistory && isIE && officeTransFlag}">
                        <a href="#" onClick="popupContentWin()" title="${ctp:i18n('doc.show.original.document')}">${ctp:i18n('doc.show.original.document')}</a> 
                    </c:if>
                    <c:if test="${ctp:getBrowserFlagByRequest('HideMenu', pageContext.request) && (!isUploadFile || canPrint4Upload) && (docPotent.all || docPotent.edit || docPotent.readOnly || (docPotent.create && doc.createUserId == CurrentUser.id))}">
                        <a href="#" onClick="printDocLog();" title="${ctp:i18n('doc.print.current.document')}"><span class="ico16 print_16 margin_l_5"
                             title="${ctp:i18n('doc.menu.print.label')}"></span><span class="margin_l_5">${ctp:i18n('doc.menu.print.label')}</span></a>
                    </c:if>
                    <c:if test="${docOpenFlag ne 'true'}">
                        <span class="margin_lr_5"></span>    
                    </c:if>             
                    	<a href="#" onclick="fnDocProperty();" title="${ctp:i18n('doc.jsp.open.label.prop')}"><span id="attributeSetting" class="ico16 attribute_16"></span>
                    	${ctp:i18n('doc.jsp.open.label.prop')}</a>           
                    		</td>
                    	</tr>
                    </table>
                </div>
                </div>
                    <!--<c:choose>
                        <c:when test="${!isUploadFile}">
                            <iframe id="docOpenBodyFrame" src="${path}/content/content.do?isFullPage=true&moduleId=${doc.id}&moduleType=3&rightId=0&contentType=${doc.mimeTypeId}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                        </c:when>
                        <c:otherwise>
                            <iframe id="docOpenBodyFrame" src="${path}/doc.do?method=docOpenBody&docResId=${doc.id}&docLibId=${doc.docLibId}&docLibType=${docLibType}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                        </c:otherwise>             
                    </c:choose>-->
                 <div id="iframe_area" class="stadic_layout_body stadic_body_top_bottom bg_color_white" layout="border:false">
                    <c:choose>
                    	<c:when test="${isHistory}">
                    		<iframe id="docOpenBodyFrame" src="${path}/doc.do?method=docOpenBody&versionFlag=${param.versionFlag}&docVersionId=${param.docVersionId}&docLibId=${doc.docLibId}&docLibType=${docLibType}&all=${docPotent.all}&edit=${docPotent.edit}&add=${docPotent.create}&readonly=${docPotent.readOnly}&browse=${docPotent.read}&isBorrowOrShare=${isBorrowOrShare}&list=${docPotent.list}&isLink=${isLink}&entranceType=${param.entranceType}" width="100%" height="100%" frameborder="0" scrolling="no" style="overflow: hidden;"></iframe>
                    	</c:when>
                    	<c:when test="${!isIE && isOffice}">
                    		
                    		<span class="">${ctp:i18n('doc.alert.office.nonsupport')}</span>
                    	</c:when>
                    	<c:otherwise>
                    		<iframe id="docOpenBodyFrame" src="${path}/doc.do?method=docOpenBody&docResId=${doc.id}&docLibId=${doc.docLibId}&docLibType=${docLibType}&all=${docPotent.all}&edit=${docPotent.edit}&readOnly=${docPotent.readOnly}&openFrom=${param.openFrom}&isLink=${isLink}&entranceType=${param.entranceType}" width="100%" height="100%" frameborder="0" scrolling="no" style="overflow: hidden;"></iframe>
                    	</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    <iframe id="iframe_empty" name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>