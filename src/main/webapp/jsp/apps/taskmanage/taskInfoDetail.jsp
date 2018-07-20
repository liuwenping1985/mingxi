<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-11-27 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>任务详情</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<%@ include file="commonTaskUtil.js.jsp" %>
<%@ include file="commonTaskEvent.js.jsp" %>
<%@ include file="taskInfoDetail.js.jsp" %>
<%@ include file="taskInfoDetailEvent.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp" %>
<style>
.stadic_head_height {
    height: 30px;
}

.stadic_body_top_bottom {
    bottom: 5px;
    top: 0px;
    width: auto;
    left: 5px;
    right: 5px;
}
</style>
<script type="text/javascript">
    $(document).ready(function() {
        initData();
        initToolBar();
        initPageEvent();
    }); 
</script>
</head>
<body class="page_color">   
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,border:false,sprit:false">
            <div class="stadic_layout_head stadic_head_height">
                <div id="toolbar"></div>
<%--                     <c:set value="${isEdit ? '' : 'disabled'}" var="editDisabled" /> --%>
<%--                     <c:set value="${isDecompose ? '' : 'disabled'}" var="decomposeDisabled" /> --%>
<%--                     <c:set value="${param.isBtnEidt == 1 ? '' : 'disabled'}" var="isBtnDisabled" /> --%>
<%--                     <a class="img-button margin_r_0" href="javascript:void(0)" style="color: black;" id="update_btn" ${isBtnDisabled == 'disabled' ? isBtnDisabled : editDisabled}><em class="ico16 edit_16"></em>${ctp:i18n("common.toolbar.update.label")}</a>  --%>
<%--                     <a class="img-button margin_r_0" href="javascript:void(0)" style="color: black;" id="decomposition_btn" ${isBtnDisabled == 'disabled' ? isBtnDisabled :decomposeDisabled}><em class="ico16 decomposition_16"></em>${ctp:i18n("taskmanage.decompose")}</a> --%>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false,sprit:false">
            <div class="h100b stadic_layout_body stadic_body_top_bottom border_all" id="task_info_div" style="background: #fff;">
                <div class="people_msg font_size12 margin_lr_5">
                    <table class="padding_l_10">
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: top;">${ctp:i18n("common.subject.label")}：</th>
                            <td width="100%" style="line-height: 25px;" class="word_break_all"><label class="margin_r_5" for="text" id="task_name">9月15日前完成设计</label></td>
                        </tr>
                        <tr id="parent_task">
                            <th nowrap="nowrap" align="right">${ctp:i18n("taskmanage.parentTask")}：</th>
                            <td width="100%">
                            <label class="margin_r_5 display_inline-block" for="text" id="parent_task_name">9月15日前完成设计</label>
                            	<label class="color_gray2">${ctp:i18n("taskmanage.weight")}：</label><label class="margin_r_5" for="text" id="weight">40%</label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right">${ctp:i18n("common.importance.label")}：</th>
                            <td width="100%">
                            	<label class="margin_r_5 display_inline-block" for="text" id="importantlevel" style="width:120px;">普通</label>
                            	<input type="checkbox" id="milestone" name="milestone" disabled="disabled"/>
                                <label class="margin_r_5" for="text">${ctp:i18n("taskmanage.mark.milestone.label")}</label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right">${ctp:i18n("taskmanage.planTime.label")}：</th>
                            <td width="100%">
                                <label class="margin_r_5" for="text" id="plan_time"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right">${ctp:i18n("taskmanage.actualtime.label")}：</th>
                            <td width="100%">
                                <label class="margin_r_5" for="text" id="actual_time"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: top;">${ctp:i18n("taskmanage.manager")}：</th>
                            <td width="100%" colspan="3" style="line-height: 25px;">
                                <label class="margin_r_5" for="text" id="managers"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: top;">${ctp:i18n("taskmanage.inspector")}：</th>
                            <td width="100%" colspan="3" style="line-height: 25px;">
                                <label class="margin_r_5" for="text" id="inspectors"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: top;">${ctp:i18n("taskmanage.participator")}：</th>
                            <td width="100%" colspan="3" style="line-height: 25px;">
                                <label class="margin_r_5" for="text" id="participators"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right">${ctp:i18n("common.creater.label")}：</th>
                            <td width="100%" colspan="3">
                                <label class="margin_r_5" for="text" id="create_user"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: top;">${ctp:i18n("taskmanage.description")}：</th>
                            <td width="100%" colspan="3" style="line-height: 25px;" class="word_break_all">
                                <label class="margin_r_5" for="text" id="content"></label>
                            </td>
                        </tr>
                        <tr id="source_info">
                            <th nowrap="nowrap" align="right">${ctp:i18n("taskmanage.source")}：</th>
                            <td width="100%" colspan="3">
                                <label class="margin_r_5" for="text" id="source_name"></label>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: bottom;">${ctp:i18n("common.attachment.label")}(<span id="attachmentNumberDiv">0</span>)：
                            </th>
                            <td width="100%" colspan="3" style="padding-top:5px;">
                                <div id="attachmentTR" style="display:none;"></div>
                                <div class="comp" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false" attsdata='${ attachmentsJSON}'></div>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap" align="right" style="vertical-align: bottom;">${ctp:i18n("common.toolbar.insert.mydocument.label")}(<span id="attachment2NumberDivposition1">0</span>)：</th>
                            <td width="100%" colspan="3" style="padding-top:5px;">
                                <div class="comp" comp="type:'assdoc',applicationCategory:'30',canDeleteOriginalAtts:false,attachmentTrId:'position1', modids:'1,3'" attsdata='${ attachmentsJSON}'></div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <iframe id="update_iframe" name="update_iframe" width="100%" height="100%" src="" frameborder="no" border="0" class="hidden"></iframe>
        </div>
    </div>
</body>
</html>
