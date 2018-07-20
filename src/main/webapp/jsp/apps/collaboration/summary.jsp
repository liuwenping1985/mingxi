<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>

<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<%@ include file="/WEB-INF/jsp/apps/collaboration/new_print.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Create_addData_js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<%@ include file="/WEB-INF/jsp/bulletin/bulletin_issue_js.jsp" %>
<%@ include file="/WEB-INF/jsp/news/news_issue_js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<!-- 查看处理页面 -->
<title>${(summaryVO.subject)}</title>
<style type="text/css">
    .stadic_head_height{}
    .stadic_body_top_bottom{bottom: 0;overflow:hidden;}
</style>
<c:set value='${summaryVO.openFrom == "repealRecord" || summaryVO.openFrom == "stepBackRecord" || summaryVO.openFrom == "stepbackRecord"}' var="isFromTraceFlag"></c:set>
<c:set value="${summaryVO.affair.state eq 3 and param.openFrom eq 'listPending'}" var ="hasDealArea" />
</head>
<body class="h100b over_hidden page_color"  onunload="colDelLock('${summaryVO.affairId}');">
<%-- fb 获取密级,为选人界面提供  --%>
<input type="hidden" name="secretLevel" id="secretLevel" value="${summaryVO.summary.secretLevel}">
    <v3x:attachmentDefine attachments="${attachments}" />
    <div id='layout'>
        <%@ include file="/WEB-INF/jsp/common/supervise/supervise.js.jsp" %>
        <input type="hidden" id="affairId" value="${summaryVO.affairId}">
        <div class="layout_east bg_color_blueLight2" id="east">
            <!--处理区域-->
            <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
              <table width="100%" height="100%"><tr><td align="center" id='_opinionArea' valign="middle"><span class="ico16 arrow_2_l"></span><br />${ctp:i18n('collaboration.summary.handleOpinion')}</td></tr></table>
            </div>
            <jsp:include page="/WEB-INF/jsp/common/content/contentDeal.jsp" />
        </div>
        <div class="layout_center over_hidden h100b" id="center">
                <c:set var="affair" value="${summaryVO.affair}" />
                <c:set var="summary" value="${summaryVO.summary}" />
                <!--查看区域-->
                <div class="h100b stadic_layout">
                    <div class="stadic_head_height" id="summaryHead">
                        <!--标题+附件区域-->
                        <div id="colSummaryData" class="newinfo_area title_view">
                            <input type="hidden" id="contentDataId" name ="contentDataId" value="${summaryVO.summary.formRecordid }"/>
                            <input type="hidden" id="contentTemplateId" name ="contentTemplateId" value="${summaryVO.summary.formAppid }"/>
                            <input type="hidden" value="" id="contentstr" name ="contentstr"/>
                            <input type="hidden" id="summaryId" value="${summary.id}">
                            <input type="hidden" name="isDeleteSupervisior" id="isDeleteSupervisior" value="false">
                            <input id="processId" name="processId" type="hidden" value="${summary.processId}">
                            <input id="subject" name="subject" type="hidden" value="${summary.subject}">
                            <input id="createDate" name="createDate" type="hidden" value="${ctp:formatDateByPattern(summaryVO.createDate, 'yyyy-MM-dd HH:mm:ss')}">
                            <input id="canDeleteORarchive" name="canDeleteORarchive" type="hidden" value="${summaryVO.canDeleteORarchive}">
                            <input id="cancelOpinionPolicy" name="cancelOpinionPolicy" type="hidden" value="${summaryVO.cancelOpinionPolicy}">
                            <input id="disAgreeOpinionPolicy" name="disAgreeOpinionPolicy" type="hidden" value="${summaryVO.disAgreeOpinionPolicy}">
                            <input id="bodyType" name="bodyType" type="hidden" value="${summary.bodyType}">
                            <input id="modifyFlag" name="modifyFlag" type="hidden" value="0"/>
                            <input id="isLoadNewFile" name="isLoadNewFile" type="hidden" value="0"/>
                            <input id="attModifyFlag" name="attModifyFlag" type="hidden" value="0"/><!-- 修改附件标志位 -->
                            <input id="flowPermAccountId" name="flowPermAccountId" type="hidden" value="${summaryVO.flowPermAccountId}" />
                            <input id="openNewWindow" name="openNewWindow" type="hidden" value="${openNewWindow}" />
                            <input id="isDistribureOperate" name="isDistribureOperate" type="hidden" value="0" />
                            <table border="0" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;">
                                <tr>
                                    <td class="text_overflow title" nowrap="nowrap"><span class="padding_l_25 font_size18 font_family_yahei color_black2">
                                        <c:if test="${summaryVO.summary.importantLevel ne null && summaryVO.summary.importantLevel ne '1'}">
                                            <span class='ico16 important${summaryVO.summary.importantLevel}_16 '></span>
                                        </c:if>
                                        <strong title='${(summaryVO.subject)}'>${(summaryVO.subject)}</strong>
                                      <span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <span class="padding_l_25">
                                      <a href="#" class="color_gray2" id="panleStart">${ctp:toHTML(summaryVO.startMemberName)}</a> <span class="color_gray2">${ctp:formatDateByPattern(summaryVO.createDate, 'yyyy-MM-dd HH:mm')}</span>
                                      </span>
                                    </td>
                                </tr>
                              </table>

                        </div>
                        <!--视图切换区域-->
                        <div class="common_tabs common_tabs_big clearfix margin_t_5">
                            <ul class="left margin_l_25">
                                <!-- 正文 -->
                                <li id="content_view_li" class="current"><a onclick="showContentView()">${ctp:i18n('collaboration.summary.text')}</a></li>
                                <!-- 流程 -->
                                <li id="workflow_view_li"><a onclick="refreshWorkflow()" >${ctp:i18n('collaboration.workflow.label')}</a></li>

                                <!-- 相关查询 :当有处理区或者已办列表中才显示。-->

                                <c:if test = "${ not empty affair.formRelativeQueryIds && (hasDealArea or param.openFrom eq 'listDone')}">
                                    <li id="query_view_li"><a onclick="showFormRelativeView('query','${affair.formRelativeQueryIds}','${summaryVO.summary.formAppid}')" >${ctp:i18n('collaboration.summary.formquery.label')}</a></li>
                                </c:if>
                                <c:if test = "${not empty affair.formRelativeStaticIds  && (hasDealArea or param.openFrom eq 'listDone')}">
                                    <li id="statics_view_li"><a onclick="showFormRelativeView('report','${affair.formRelativeStaticIds}','${summaryVO.summary.formAppid}')" >${ctp:i18n('collaboration.summary.formstatic.label')}</a></li>
                                 </c:if>
                            </ul>
                            <!--命令按钮区域-->
                        <div class="orderBt right margin_r_10 margin_t_10 align_center">
                             <div style="position:absolute; right:50px; top:125px; width:220px; z-index:200; background-color: #ececec;display:none;overflow:auto;text-align:left;border: 1px #dadada solid; padding: 5px;" id="processAdvanceDIV">
                                <input type="text" id="searchText" onkeypress="enterKeySearch(event)" name="searchText" onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)" deaultvalue="&lt;${ctp:i18n('collaboration.summary.label.search')}&gt;" value="&lt;${ctp:i18n('collaboration.summary.label.search')}&gt;">
                                <span class="ico16 arrow_1_b" onclick="javascript:doSearch('forward')" class="cursor-hand"></span>
                                <span class="ico16 arrow_1_t" onclick="javascript:doSearch('back')" class="cursor-hand"></span>
                                <span class="ico16 close_16" onclick="javascript:advanceViews(false)" class="cursor-hand"></span>
                             </div>

                             <!-- 流程最大化，意见查找，附件列表，收藏，新建会议，即时交流，明细日志，属性状态，打印，督办
                              -->
                             <c:set value="1" var="countBtn" />
                             <%-- 查看原文档--%>
                             <c:set value="${summaryVO.summary.bodyType}" var = "bodyType"/>
                             <c:if test="${(bodyType eq '41' || bodyType eq '42') && v3x:isOfficeTran()}">
                                <a href="javascript:popupContentWin()" id="viewOriginalContentA" class="left" style="margin-right:5px;line-height:19px;overflow:visible">${ctp:i18n("collaboration.content.viewOriginalContent")}</a>
                             </c:if>

                             <!-- 打印 -->
                             <c:if test="${summaryVO.officecanPrint && !isFromTraceFlag}">
                                <c:set value="${countBtn+1}" var="countBtn" />
                                <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="print"><span class="ico16 print_16 margin_lr_5" title="${ctp:i18n('collaboration.newcoll.print')}"></span>${ctp:i18n('collaboration.newcoll.print')}</span>
                                </c:if>
                             </c:if>

                             <!-- 附件列表 -->
                             <c:if test='${!isFromTraceFlag}'>
                             <c:set value="${countBtn+1}" var="countBtn" />
                                <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="attachmentListFlag1" onclick="javascript:showOrCloseAttachmentList(true)"><span class="ico16 affix_16 margin_lr_5" title="${ctp:i18n('collaboration.summary.findAttachmentList')}"></span>${ctp:i18n('collaboration.common.flag.attachmentList')}</span>
                                </c:if>
                                <c:if test="${countBtn>5}">
                                      <input id="attachmentListFlag" type="hidden"/>
                             </c:if>
                             </c:if>

                             <!-- 意见查找 -->
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                <span class="hand left" id='msgSearch' onclick="javascript:advanceViews(null,this)" title="${ctp:i18n('collaboration.summary.advanceViews')}"><span class="ico16 search_16 margin_lr_5"></span>${ctp:i18n('collaboration.summary.opinionFind')}</span>
                             </c:if>

                             <!-- 隐藏空意见 add by libing
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                <span class="hand left" id='hidNullOpinion' title="${ctp:i18n('collaboration.summary.hideNull')}"><span id='hidNullOpinionIco' class="ico16 hide_opinion_16 margin_lr_5"></span>${ctp:i18n('collaboration.summary.hideNull')}</span>
                                <span class="hand left display_none" id='showNullOpinion' title="${ctp:i18n('collaboration.summary.showNull')}"><span id='hidNullOpinionIco' class="ico16 cancel_opinion_16 margin_lr_5"></span>${ctp:i18n('collaboration.summary.showNull')}</span>
                             </c:if>-->

                             <%--收藏 --%>
                             <%--判断是否有处理后归档权限或者发送协同时勾选了‘归档’，如果没有，则不能收藏 ,a6没有收藏功能--%>
                             <c:if test="${canFavorite && !isFromTraceFlag}">
                                <c:if test="${param.openFrom ne 'favorite' and param.openFrom ne 'listWaitSend'  and param.openFrom ne 'glwd' and productId ne '0' and summaryVO.affair.state ne '1'}">
                                    <c:set value="${countBtn+1}" var="countBtn" />
                                     <c:if test="${countBtn<=5}">
                                        <span class="hand left ${isCollect ? 'display_none':''}" id="favoriteSpan${summaryVO.affairId}"><span class="ico16 unstore_16 margin_lr_5 " title="${ctp:i18n('collaboration.summary.favorite')}"></span>${ctp:i18n('collaboration.summary.favorite')}</span>
                                        <span class="hand left ${!isCollect ? 'display_none':''}" id="cancelFavorite${summaryVO.affairId}"><span class="ico16 stored_16 margin_lr_5" title="${ctp:i18n('collaboration.summary.favorite.cancel')}"></span>${ctp:i18n('collaboration.summary.favorite.cancel')}</span>

                                     </c:if>
                                     <c:if test="${countBtn>5}">
                                      <input id="favoriteFlag" type="hidden"/>
                                </c:if>
                                </c:if>
                             </c:if>
                             <!-- 跟踪 -->
                             <c:if test="${(param.openFrom eq 'listSent' or param.openFrom eq 'listDone') and isHistoryFlag ne 'true'}">
                                <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="gzbutton"><span class="ico16 track_16 margin_lr_5" title="${ctp:i18n('collaboration.forward.page.label4')}"></span>${ctp:i18n('collaboration.forward.page.label4')}</span>
                                 </c:if>
                                <c:if test="${countBtn>5}">
                                      <input id="gzbuttonFlag" type="hidden"/>
                                </c:if>
                             </c:if>

                             <!-- 明细日志 -->
                             <c:if test='${!isFromTraceFlag}'>
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                 <span class="hand left" id="showDetailLog"><span class="ico16 view_log_16 margin_lr_5" title="${ctp:i18n('collaboration.sendGrid.findAllLog')}"></span>${ctp:i18n('collaboration.common.flag.showDetailLog')}</span>
                             </c:if>
                             <c:if test="${countBtn>5}">
                                 <input id="showDetailLogFlag" type="hidden"/>
                             </c:if>
                             </c:if>


                              <!-- 属性状态 -->
                              <c:if test='${!isFromTraceFlag}'>
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                <span class="hand left" id="attributeSetting"><span class="ico16 attribute_16 margin_lr_5 display_none" title="${ctp:i18n('collaboration.common.flag.findAttributeSetting')}"></span>${ctp:i18n('collaboration.common.flag.attributeSetting')}</span>
                             </c:if>
                             <c:if test="${countBtn>5}">
                                  <input id="attributeSettingFlag" type="hidden"/>
                             </c:if>
                             </c:if>

                             <!-- 新建会议  & 及时交流  在已发已办中始终都有，不管流程结束与否，在文档中心等其他都地方没有 -->
                             <c:if test="${((param.openFrom eq 'listSent')
                                        or (param.openFrom eq 'listDone')
                                        or (param.openFrom eq 'listPending')
                                        or (param.openFrom eq 'supervise'))&& !isFromTraceFlag && (isHistoryFlag ne 'true')}">
                                 <!-- 新建会议 -->
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                     <span class="hand left" id="createMeeting"><span class="ico16 margin_lr_5" title="${ctp:i18n('collaboration.summary.createMeeting')}"></span>${ctp:i18n('collaboration.summary.createMeeting')}</span>
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="createMeetingFlag" type="hidden"/>
                                 </c:if>
                                 <!-- 即时交流 -->
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="timelyExchange"><span class="ico16 communication_16 margin_lr_5" title="${ctp:i18n('collaboration.summary.timelyExchange')}"></span>${ctp:i18n('collaboration.summary.timelyExchange')}</span>
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="timelyExchangeFlag" type="hidden"/>
                                 </c:if>
                             </c:if>

                             <!-- 表单授权：已发表单或者已发归档的表单并且有高级表单插件的可以设置表单授权 -->
                             <c:if test="${((summaryVO.summary.startMemberId eq CurrentUser.id and summaryVO.openFrom eq 'docLib') or summaryVO.openFrom eq 'listSent') and summaryVO.bodyType eq '20' and ctp:hasPlugin('formAdvanced')}">
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="formAuthority"><span class="ico16 authorize_16 margin_lr_5" title="${ctp:i18n('common.toolbar.relationAuthority.label')}"></span>${ctp:i18n('common.toolbar.relationAuthority.label')}</span>3
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="formAuthorityFlag" type="hidden"/>
                                 </c:if>
                             </c:if>

                             <!-- 追溯流程 -->
                             <c:if test="${hasWorkflowDataaButton && summaryVO.openFrom == 'listPending'}">
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                     <span class="hand left" id="showWorkflowtrace"><span class="ico16 review_flow_16 margin_lr_5" title="${ctp:i18n('collaboration.workflow.label.lczs')}"></span>${ctp:i18n('collaboration.workflow.label.lczs')}</span>
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="showWorkflowtraceFlag" type="hidden"/>
                                 </c:if>
                             </c:if>


                             <c:choose>
                                  <c:when test="${param.openFrom eq 'listSent' and (isHistoryFlag ne 'true')}">
                                      <%--如果是已发，则显示督办设置 --%>
                                      <c:set value="${countBtn+1}" var="countBtn" />
                                      <c:if test="${countBtn<=5}">
                                          <span class="hand left" id="showSuperviseSettingWindow"><span class="ico16 setting_16 margin_lr_5" title="${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}"></span>${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}</span>
                                      </c:if>
                                      <c:if test="${countBtn>5}">
                                          <input id="showSuperviseSettingWindowFlag" type="hidden"/>
                                      </c:if>
                                  </c:when>
                                  <c:when test="${((param.openFrom eq 'listDone' and summaryVO.isCurrentUserSupervisor) or param.openFrom eq 'supervise') and (isHistoryFlag ne 'true')}">
                                      <c:set value="${countBtn+1}" var="countBtn" />
                                          <c:if test="${countBtn<=5}">
                                              <!-- 督办 -->
                                              <span class="hand left"  id="showSuperviseWindow"><span class="ico16 meeting_look_1 margin_lr_5" title="${ctp:i18n('collaboration.common.flag.showSupervise')}"></span>${ctp:i18n('collaboration.common.flag.showSupervise')}</span>
                                          </c:if>
                                          <c:if test="${countBtn>5}">
                                             <input id="showSuperviseWindowFlag" type="hidden"/>
                                          </c:if>
                                  </c:when>
                              </c:choose>


                              <!--流程最大化 -->
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                 <span class="hand left" id="processMaxFlag" title="${ctp:i18n('collaboration.summary.flowMax')}"><span class="ico16 process_max_16 margin_lr_5 "></span>${ctp:i18n('collaboration.summary.flowMax')}</span>
                             </c:if>
                             <c:if test="${countBtn>5}">
                                 <input id="_processMaxFlag" type="hidden"/>
                             </c:if>


                             <c:if test="${countBtn>5}">
                                <span id="caozuo_more" style="display:none" class="ico16 arrow_2_b left margin_l_5"></span>
                             </c:if>
                        </div>
                        <div style="clear: both;"></div>
                        </div>
                        <table class="" border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td colspan="2">
                                <div id="attachmentTRshowAttFile" class="margin_t_5" style="display: none;">
                                      <div style="float:left;padding-top:5px;" class="margin_l_25 margin_r_5"><span class="ico16 affix_16"></span> (<span id="attachmentNumberDivshowAttFile"></span>) </div>
                                      <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'showAttFile',canFavourite:${canFavorite},applicationCategory:'1',canDeleteOriginalAtts:false" attsdata='${attListJSON }'> </div>
                                </div>
                               </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <%--关联文档 --%>
                                    <div id="attachment2TRDoc1" style="display: none;">
                                        <div style="float:left;padding-top:5px;" class="margin_l_25 margin_r_5"><span class="ico16 associated_document_16"></span> (<span id="attachment2NumberDivDoc1"></span>)</div>
                                        <div style="float: right;" id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'1',referenceId:'${vobj.summary.id}',modids:1,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                                    </div>
                                    <div id="attActionLogDomain" style="display: none;"></div>
                                </td>
                            </tr>
                        </table>
                        <div class="padding_l_25 padding_t_5 hidden" id="show_edit_workFlow">
                            <%-- 修改流程 --%>
                            <a id="edit_workFlow" class="common_button common_button_gray" >${ctp:i18n('collaboration.summary.updateFlow')}</a>
                        </div>
                   </div>
                   <div id="content_workFlow" class="stadic_layout_body stadic_body_top_bottom processing_view align_center" style="width: 100%;top:30;visibility: visible;">
                        <div style="position:absolute; overflow:hidden; width:100%; height:10px; -moz-box-shadow:inset 0px 3px 5px #A8A8A8; box-shadow:inset 0px 3px 5px #A8A8A8;">&nbsp;</div>
                        <iframe  frameborder="0" style="display:none;position:absolute;top:0px;right:20px;width:650px;z-index:200;height: 180px" id="attachmentList" class="over_auto align_right" src="" >
                        </iframe>
                        <iframe id="iframeright" class="hidden bg_color_white" src="about:blank"  width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                        <c:set var="securityCheckParam" value="&docResId=${param.docResId}&docId=${param.docId}&baseObjectId=${param.baseObjectId}&baseApp=${param.baseApp}&fromEditor=${param.fromEditor}&eventId=${param.eventId}&relativeProcessId=${param.relativeProcessId}&processId=${param.processId}"/>
                        <iframe id="componentDiv" name="componentDiv" width="100%" height="100%" frameborder="0"
                            src='${path }/collaboration/collaboration.do?method=componentPage&templateId=${summaryVO.summary.templeteId}&affairId=${summaryVO.affairId}&formAppid=${summaryVO.summary.formAppid }&rightId=${rightId}&canFavorite=${canFavorite}&isHasPraise=${isHasPraise}&readonly=${summaryVO.readOnly}&openFrom=${summaryVO.openFrom}&isHistoryFlag=${isHistoryFlag}&trackType=${param.trackTypeRecord}${securityCheckParam}&r=<%=Math.random()%>'></iframe>
                        <iframe id="formRelativeDiv" name="formRelativeDiv" width="100%" height="100%" frameborder="0" class="hidden bg_color_white" src=""></iframe>
                        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
                    </div>
                    <%-- 跟踪区域开始 --%>
                         <input type="hidden" id="zdgzry" name="zdgzry" />
                         <div id="htmlID" class="hidden">
                        <div class="padding_tb_10 padding_l_10">
                        <input type="text" style="display: none" id="zdgzryName" name="zdgzryName" size="30" onclick="$('radio4').click()"/>
                            <%-- 跟踪 --%>
                            <span class="valign_m">${ctp:i18n('collaboration.forward.page.label4')}:</span>
                            <select id="gz" class="valign_m">
                                <option value="1">${ctp:i18n('message.yes.js')}</option><%-- 是 --%>
                                <option value="0">${ctp:i18n('message.no.js')}</option><%-- 否 --%>
                            </select>
                            <div id="gz_ren" class="common_radio_box clearfix margin_t_10">
                                <label for="radio1" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="radio1" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.all')}</label><!-- 全部 -->
                                <label for="radio4" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="radio4" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.designee')}</label><!-- 指定人 -->
                            </div>
                        </div>
                    </div>
                    <%-- 跟踪区域结束 --%>
                    <input type="hidden" name="can_Track" id="can_Track" value="${summary.canTrack ? 1 : 0}" />
                    <input type="hidden" name="trackType" id="trackType" value="${trackType}" />
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
var summaryId = '${summaryVO.summary.id}';
var affairId  = '${summaryVO.affairId}';

var isCollect = '${isCollect}' == 'true';

<%-- 解锁Param--%>
var formAppId = '${summaryVO.summary.formAppid}';
var fromRecordId = '${summaryVO.summary.formRecordid}';
var deeReadOnly = '${deeReadOnly}' =='1';

<%--后台已经使用ctp:toHTML()进行了一次转义了，所以这个地方不能重复转义了--%>
var subject = "${ctp:escapeJavascript(summaryVO.summary.subject)}";

var _trackTitle = "${ctp:i18n('collaboration.newColl.alert.zdgzrNotNull')}";
var _summaryProcessId = '${summaryVO.summary.processId}';
var _summaryActivityId = '${summaryVO.activityId}';
var _summaryCaseId = '${summaryVO.summary.caseId}';
var _summaryItemId=  '${summaryVO.workitemId}';

var _contextProcessId = '${contentContext.wfProcessId}';
var _contextActivityId = '${contentContext.wfActivityId}';
var _contextCaseId = '${contentContext.wfCaseId}';
var _contextItemId = '${contentContext.wfItemId}';
var _scene = "${scene}";
var show1 = '${show1}';
var show2 = '${show2}';

var _currentUserId = '${CurrentUser.id}';
var _currentUserName = '${ctp:escapeJavascript(CurrentUser.name)}';
var _loginAccountId = '${CurrentUser.loginAccount}';
var isFromTemplate = '${summaryVO.summary.templeteId ne null}';
var templateType = '${templateType}';
var affairState = "${summaryVO.affair.state}";
var affairSubState = '${summaryVO.affair.subState}';
var isCurrentUserSupervisor = "${summaryVO.isCurrentUserSupervisor}";
var isFinshed = "${summaryVO.flowFinished}";
var isFinish = ${(summaryVO.summary.finishDate!= null) ? true : false};
var commentId = "${commentId}";
var _isOfficeTrans = ${v3x:isOfficeTran()};
var openFrom = "${ctp:escapeJavascript(summaryVO.openFrom)}";
//致信打开协同的时候会传递这个参数ucpc。
var extFrom = "${param.extFrom}";
var summaryReadOnly = '${summaryVO.readOnly}';
var templateId = '${summaryVO.summary.templeteId}';
var isSupervise = '${summaryVO.openFrom}'=='supervise';
var isCurSuperivse = '${summaryVO.openFrom}'=='listDone' && '${summaryVO.isCurrentUserSupervisor}' == 'true';
var _moduleTypeName = '${contentContext.moduleTypeName}';
var _affairMemberId = '${summaryVO.affair.memberId}';
var _startMemberId = "${summaryVO.summary.startMemberId}";
var _canFavorite = "${canFavorite}";
var trackType = '${trackType}';
var bodyType = '${summaryVO.summary.bodyType}';
var formRecordid = '${summaryVO.summary.formRecordid}';
var operationId = '${summaryVO.operationId}';

//控制OFFICE正文能否打印，OFFICE组件中会读取这个变量
var isFromTrace = openFrom == "repealRecord" || openFrom == 'stepBackRecord' || openFrom == 'stepbackRecord';
var officecanPrint = isFromTrace ? 'false' : '${summaryVO.officecanPrint}';
var canEdit  =  isFromTrace ? 'false' : '${canEdit and summaryVO.affair.state eq 3}';
var officecanSaveLocal = isFromTrace ? 'false' : '${summaryVO.officecanSaveLocal}';
var forTrackShowString='${forTrackShowString}';
var openType = "";
var proce = "";
var contentAnchor = "${ctp:escapeJavascript(contentAnchor)}";
var nodePerm_baseActionList = <c:out value="${nodePerm_baseActionList}" default="null" escapeXml="false"/>;
var nodePerm_commonActionList = <c:out value="${nodePerm_commonActionList}" default="null" escapeXml="false"/>;
var nodePerm_advanceActionList = <c:out value="${nodePerm_advanceActionList}" default="null" escapeXml="false"/>;
var isDealPageShow = "${isDealPageShow}";
var flowPermAccountId= '${summaryVO.flowPermAccountId}';
var nodePolicy = "${ctp:escapeJavascript(nodePolicy)}";
var hasAttsFlag = '${summaryVO.hasAttsFlag}';
var templateWorkflowId =  '${templateWorkflowId}';
var supervisorsId = '${summaryVO.summary.supervisorsId }';
var hasPluginUC = ${ctp:hasPlugin('uc')};
var layout = null;
var rightId = '${rightId}' ;
//当前节点是否加盖html签章 false：未盖章，true：加盖印章
var nowNodeIsSignatureHtml = "false";
//dialog方式打开协同，dialog的ID可以默认，也可以通过参数传过来，目前表单统计查询都是传递过来的。
var dialogId = "${param.dialogId eq null ? 'dialogDealColl' : param.dialogId}";
var isHasDealPage = "${ summaryVO.affair.state eq 3 and param.openFrom eq 'listPending'}";
var isTimeLine ='${param.isTimeLine}';
var noConfigItem = "${noFindPermission}";
// var defaultWidth;
var customSetTrackFlag = '${customSetTrack}' == 'true';
var isHistoryFlag = "${isHistoryFlag}";
//var _affairSubState=affairSubState;
var affairMemberName="${ctp:escapeJavascript(summaryVO.affairMemberName)}";//当前待办事项的所属人Name

var currentUserLocale = "${CurrentUser.locale}"
var currentUserloginName = "${ctp:escapeJavascript(CurrentUser.loginName)}";
var _sid = "<%=session.getId()%>";
var xmlDoc = null;
var _isSystemAdmin = "${CurrentUser.systemAdmin}";
var _trackTypeRecord = '${trackTypeRecord}';
var isCollCube = '${isCollCube}' ;
var isColl360 = '${isColl360}' ;



var hasDealArea = "${hasDealArea}";

</script>
<script type="text/javascript" src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/knowledgeBrowseUtils.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/summary.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
//OfficeObjExtshowExt定义在summary.js中，所以需要先引用summary.js
OfficeObjExt.showExt = OfficeObjExtshowExt;
</script>
</html>
