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
    <div id="attribute" class="padding_10">
            <fieldset class="fieldset_box" style="background:#FAFAFA;">
                <legend>${ctp:i18n('collaboration.showAttributeSet.basicAttributes')}</legend><!-- 基本属性 -->
                <div class="form_area">
                    <table border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
                        <tbody>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="deadline">${ctp:i18n("collaboration.process.cycle.label")}:</label><!-- 流程期限 -->
                                </th>
                                <td>
                                    <div class="common_txtbox_wrap">
                                        <input type="text" id="deadline" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="canDueReminder">${ctp:i18n('common.remind.time.label')}:</label><!-- 提醒 -->
                                </th>
                                <td>
                                    <div class="common_txtbox_wrap">
                                        <input type="text" id="canDueReminder" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="archiveName">${ctp:i18n('collaboration.showAttributeSet.archivedTo')}:</label><!-- 归档到 -->
                                </th>
                                <td width="100%">
                                    <div class="common_txtbox_wrap">
                                        <input type="text" id="archiveName" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </fieldset>
            <fieldset class="fieldset_box margin_t_5"  style="background:#FAFAFA;">
                <legend>${ctp:i18n("node.state")}</legend><!-- 节点状态 -->
                <div class="form_area">
                    <table border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
                        <tbody>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="flowState">${ctp:i18n("common.deal.state")}:</label><!-- 处理状态 -->
                                </th>
                                <td width="100%">
                                    <div class="common_txtbox_wrap">
                                        <input type="text" id="flowState" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="startDate">${ctp:i18n("common.date.sendtime.label")}:</label><!-- 发起时间 -->
                                </th>
                                <td width="100%">
                                    <div class="common_txtbox_wrap">
                                        <input type="text" id="startDate" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap">
                                    <label class="margin_r_10" for="cOverTime">${ctp:i18n("node.isovertoptime.label")}:</label><!-- 是否超期 -->
                                </th>
                                <td width="100%">
                                    <div class="common_txtbox_wrap">
                                        <input type="text" id="cOverTime" disabled="disabled">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </fieldset>
        </div>
</body>
</html>
