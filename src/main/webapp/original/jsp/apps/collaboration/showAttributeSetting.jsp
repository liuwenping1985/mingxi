<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>查看属性设置</title>
    <style>
        .stadic_body_top_bottom { bottom: 0px; top: 5px; }
        .common_txtbox_wrap{background:#ededed;}
    </style>
</head>
<body class="page_color">
    <div id="attribute" class="padding_10 margin_t_10" style="padding:0px 20px;color:#333;background:rgb(250,250,250);">
            <fieldset class="fieldset_box" style="background:rgb(250,250,250);border:1px solid rgb(199,199,199);">
                <legend style="color:#333">${ctp:i18n('collaboration.showAttributeSet.basicAttributes')}</legend><!-- 基本属性 -->
                <div class="form_area">
                    <table border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
                        <tbody>
                            <c:if test="${openFrom ne 'edoc'}">
                            <tr>
                                <td nowrap="nowrap">
                                    <label class="margin_r_10" for="importantLevel">${ctp:i18n('collaboration.pending.importantLevel')}:</label><!-- 重要程度 -->
                                </td>
                                <td width="100%">
                                    <div class="common_txtbox_wrap"style="background:rgb(255,255,255)">
                                        <input style="background:rgb(255,255,255)" type="text" id="importantLevel" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            </c:if>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="deadline">${ctp:i18n("collaboration.process.cycle.label")}:</label><!-- 流程期限 -->
                                </th>
                                <td>
                                    <div class="common_txtbox_wrap" style="background:rgb(255,255,255)" >
                                        <input style="background:rgb(255,255,255)"  type="text" id="deadline" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="canDueReminder">${ctp:i18n('common.remind.time.label')}:</label><!-- 提醒 -->
                                </th>
                                <td>
                                    <div class="common_txtbox_wrap" style="background:rgb(255,255,255)" >
                                        <input style="background:rgb(255,255,255)"  type="text" id="canDueReminder" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <c:if test="${openFrom ne 'edoc' && (v3x:getSysFlagByName('col_showRelatedProject') == true) && ctp:hasPlugin('project')}">
	                            <tr>
	                                <th nowrap="nowrap">
	                                    <label class="margin_r_10" for="projectName">${ctp:i18n('collaboration.newcoll.relatepro2')}:</label><!-- 关联项目 -->
	                                </th>
	                                <td>
	                                    <div class="common_txtbox_wrap" style="background:rgb(255,255,255)" >
	                                        <input style="background:rgb(255,255,255)"  type="text" id="projectName" disabled="disabled">
	                                    </div>
	                                </td>
	                            </tr>
                            </c:if>
                            <!-- 归档 -->
                            <c:if test="${ctp:hasPlugin('doc')}">
	                            <tr><!-- 协同归档 -->
	                                <th nowrap="nowrap">
	                                    <label class="margin_r_10" for="archiveName">${ctp:i18n('collaboration.showAttributeSet.archivedTo')}:</label><!-- 归档到 -->
	                                </th>
	                                <td width="100%">
	                                    <div class="common_txtbox_wrap" style="background:rgb(255,255,255)" >
	                                        <input  style="background:rgb(255,255,255)" type="text" title="${v3x:toHTML(archiveAllName)}" id="archiveName" disabled="disabled">
	                                    </div>
	                                </td>
	                            </tr>
	                            <c:if test="${openFrom != 'edoc'}">
	                            <tr><!-- 附件归档 -->
	                                <th nowrap="nowrap">
	                                    <label class="margin_r_10" for="attachmentArchiveName">${ctp:i18n('collaboration.showAttributeSet.archivedAttachmentTo')}:</label><!-- 归档到 -->
	                                </th>
	                                <td width="100%">
	                                    <div class="common_txtbox_wrap" style="background:rgb(255,255,255)" >
	                                        <input  style="background:rgb(255,255,255)" type="text" title="${v3x:toHTML(attachmentArchiveName)}" id="attachmentArchiveName" disabled="disabled">
	                                    </div>
	                                </td>
	                            </tr>
	                            </c:if>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </fieldset>
            <fieldset class="fieldset_box margin_t_5"  style="background:rgb(250,250,250);border:1px solid rgb(199,199,199);">
                <legend style="color:#333">${ctp:i18n("node.state")}</legend><!-- 节点状态 -->
                <div class="form_area">
                    <table border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
                        <tbody>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="flowState">${ctp:i18n("common.deal.state")}:</label><!-- 处理状态 -->
                                </th>
                                <td width="100%">
                                    <div style="background:rgb(255,255,255)"  class="common_txtbox_wrap">
                                        <input style="background:rgb(255,255,255)"  type="text" id="flowState" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="startDate">${ctp:i18n("common.date.sendtime.label")}:</label><!-- 发起时间 -->
                                </th>
                                <td width="100%">
                                    <div style="background:rgb(255,255,255)"  class="common_txtbox_wrap">
                                        <input style="background:rgb(255,255,255)"  type="text" id="startDate" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="cOverTime">${ctp:i18n("node.isovertoptime.label")}:</label><!-- 是否超期 -->
                                </th>
                                <td width="100%">
                                    <div style="background:rgb(255,255,255)"  class="common_txtbox_wrap">
                                        <input style="background:rgb(255,255,255)"  type="text" id="cOverTime" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </fieldset>
            <c:if test="${supervise=='supervise' && openFrom ne 'edoc'}">
                <fieldset class="fieldset_box margin_t_5" style="background:rgb(250,250,250);border:1px solid rgb(199,199,199);">
                <legend style="color:#333">${ctp:i18n('collaboration.nodePerm.superviseOperation.label')}</legend><!-- 督办设置 -->
                <div class="form_area">
                    <table border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
                        <tbody>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="flowState">${ctp:i18n("edoc.supervise.supervisor")}:</label><!-- 督办人 -->
                                </th>
                                <td width="100%">
                                    <div style="background:rgb(255,255,255)"  class="common_txtbox_wrap">
                                        <input style="background:rgb(255,255,255)"  type="text" id="supervisors" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="startDate">${ctp:i18n("edoc.supervise.deadline")}:</label><!-- 督办期限 -->
                                </th>
                                <td>
                                    <div style="background:rgb(255,255,255)"  class="common_txtbox_wrap">
                                        <input style="background:rgb(255,255,255)"  type="text" id="awakeDate" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </fieldset>
            </c:if>
            <c:if test="${not empty ffattribute.formOperation && openFrom ne 'edoc'}">
                <fieldset class="fieldset_box margin_t_5" style="background:rgb(250,250,250);border:1px solid rgb(199,199,199);">
                <legend>${ctp:i18n("collaboration.saveAsTemplate.formBound")}</legend><!-- 表单绑定 -->
                <div class="form_area">
                    <table border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
                        <tbody>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="formOperation">${ctp:i18n("collaboration.saveAsTemplate.bindOperation")}:</label><!-- 绑定操作 -->
                                </th>
                                <td width="100%">
                                    <div style="background:rgb(255,255,255)"  class="common_txtbox_wrap">
                                        <input style="background:rgb(255,255,255)"  type="text" id="formOperation" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </fieldset>
            </c:if>
            <c:if test="${openFrom ne 'edoc'}">
            <fieldset class="fieldset_box margin_t_5"  style="background:rgb(250,250,250);border:1px solid rgb(199,199,199);margin-bottom:25px;">
                <legend>${ctp:i18n("common.purview.option.label")}</legend><!-- 权限设置 -->
                <!--最后一个不用margin_r_10-->
                <div class="common_checkbox_box clearfix margin_l_10 padding_b_10">
                    <label for="canForward" class="margin_t_5 hand display_block">
                        <input type="checkbox" value="1" id="canForward" class="radio_com" disabled="disabled">${ctp:i18n('common.toolbar.transmit.label')}</label><!-- 转发 -->
                    <label for="canModify" class="margin_t_5 hand display_block">
                        <input type="checkbox" value="1" id="canModify" class="radio_com"  disabled="disabled">${ctp:i18n('collaboration.allow.chanage.flow.label')}</label><!-- 改变流程 -->
                    <label for="" class="margin_t_5 hand display_block">
                        <input type="checkbox" value="1" id="canEdit" class="radio_com" disabled="disabled">${ctp:i18n('collaboration.allow.edit.label')}</label><!-- 修改正文 -->
                    <label for="canEditAttachment" class="margin_t_5 hand display_block"  >
                        <input type="checkbox" value="1" id="canEditAttachment"  class="radio_com"  disabled="disabled">${ctp:i18n('collaboration.allow.edit.attachment.label')}</label><!-- 修改附件 -->
                    <c:if test="${ctp:hasPlugin('doc')}">
	                    <label for="canArchive" class="margin_t_5 hand display_block">
	                        <input type="checkbox" value="1" id="canArchive" class="radio_com" disabled="disabled">${ctp:i18n('common.toolbar.pigeonhole.label')}</label><!-- 归档 -->
                    </c:if>
                    <label for="canAutoStopFlow" class="margin_t_5 hand display_block">
                        <input type="checkbox" value="1" id="canAutoStopFlow"class="radio_com" disabled="disabled">${ctp:i18n('collaboration.newcoll.lcqxdszdzz')}</label><!-- 流程期限到时自动终止 -->
                     <label for="canMergeDeal" class="margin_t_5 hand display_block">
                        <input type="checkbox" value="1" id="canMergeDeal" class="radio_com" disabled="disabled">${ctp:i18n('collaboration.allow.canmergedeal.label')}</label><!-- 自動合併處理 -->
                    <label for="canAnyMerge" class="margin_t_5 hand display_block">
                        <input type="checkbox" value="1" id="canAnyMerge" class="radio_com" disabled="disabled">${ctp:i18n('collaboration.allow.before.same.merge.label')}</label><!-- 自動合併處理 -->
                    <c:if test="${ffattribute.isFormTemplete}">
                        <label for="canPraise" class="margin_t_5 hand display_block"  >
                            <input type="checkbox" value="1" id="canPraise"  class="radio_com"  disabled="disabled">${ctp:i18n('collaboration.allow.praise.label')}</label><!-- 允许点赞 -->
                    </c:if>
                </div>
            </fieldset>
            </c:if>
        </div>
</body>
</html>
