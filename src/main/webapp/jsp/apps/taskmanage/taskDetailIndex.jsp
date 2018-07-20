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
<style>
.stadic_head_height {
    height: 35px;
}

.stadic_body_top_bottom {
    bottom: 5px;
    top: 165px;
    width: auto;
    left: 5px;
    right: 5px;
}
.stadic_left_head_height {
    height: 31px;
}

.stadic_left_body_top_bottom {
    bottom: 0px;
    top: 36px;
    width: auto;
    left: 0px;
    right: 0px;
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskInfoManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<%@ include file="commonTaskUtil.js.jsp" %>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskDetailIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
        initTaskInfoDatailPage();
        initPersonName();
        judgeHiddenInspectors();
        initUIEvent();
        try{ fnGetDialog(118);  }catch(e){}
    });
</script>
</head>
<body class="page_color">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:57,border:false,sprit:false">
            <c:set value="${empty param.isBtnEidt ? 1 : param.isBtnEidt}" var="isBtnEidt" />
            <c:set value="${isRely ? 1 : 0}" var="isRely" />
            <c:set value="${isBtnEidt == 0 ? isBtnEidt : isRely}" var="isUpdate" />
            <table cellpadding="0" cellspacing="0" align="left" width="100%" id="head_taskinfo" class="font_size12 margin_t_5">
                <tr>
                    <td rowspan="2" class="padding_l_5" id="head_task_name" style="font-size: 14px;font-weight:bold;"><span class='ico16 much_important_16'></span><span
                        class='ico16 milestone'></span><span class='ico16 risk_16'></span>9月15日前完成设计<span
                        class='ico16 affix_16'></span></td>
                    <td width="300" height="25"><span class='left margin_lr_5' id="status_text" style="padding-left: 12px">已延期：</span>
                        <p id="finish_rate_text" class='task_rate adapt_w left' style='margin-top: 0; width: 100px;'>
                            <a href='#' class='rate_delay' style='width: 30%;'></a>
                        </p>
                        <span class='left margin_l_5' id="finish_rate">100%</span>
                    </td>
                    <td width="220">
                        <span class="valign_m">${ctp:i18n("taskmanage.manager")}：</span>
                        <label class="margin_r_5 valign_m" for="text" id="managerNames" style="text-overflow:ellipsis;white-space:nowrap;width:130px;overflow:hidden;display:inline-block;">李立、皓月、乔力</label>
                        <input type="hidden" id="manager_name_text" name="manager_name_text"/>
                    </td>
                </tr>
                <tr>
                    <td height="25"><span class='left margin_lr_5'>${ctp:i18n("taskmanage.currentTime")}：</span><label class="margin_r_5" for="text" id="actual_tasktime_text">57小时</label></td>
                    <td id="inspectors">
                        <span class="valign_m">${ctp:i18n("taskmanage.inspector")}：</span>
                        <label class="margin_r_5 valign_m" for="text" id="inspectors_name" style="text-overflow:ellipsis;white-space:nowrap;width:130px;overflow:hidden;display:inline-block;">李立、皓月、乔力</label>
                        <input type="hidden" id="inspectors_name_text" name="inspectors_name_text"/>
                    </td>
                </tr>
            </table>
            <div class="hr_heng clear"></div>
        </div>
        <div class="layout_east" layout="width:300,sprit:false" style="border-top: none;">
            <div class="stadic_head_height">
                <a id="task_reply_btn" class="common_button common_button_gray right margin_t_5" href="javascript:void(0)" style="position:relative;right:15px;">${ctp:i18n("taskmanage.reply.action")}</a>
                <input type="hidden" id="is_task_reply" name="is_task_reply" value="${isUpdate == 1 ? 1 : 0}"/>
            </div>
            <div id="replyFormArea" class="common_txtbox clearfix w90b hidden margin_l_5" style="">
                    <input type="hidden" id="contxt_affairId" name="contxt_affairId" value="${contentContext.affairId}" />
            		<form id="replyForm">
            			<input type="hidden" id="moduleId" name="moduleId" value="${param.id }" /> 
						<input type="hidden" id="moduleType" name="moduleType" value="${appType }" /> 
						<input type="hidden" id="content" name="content" value="" />
						<input type="hidden" id="hidden" name="hidden" value="0" />
						<input type="hidden" id="pid" name="pid" value="0"/>
						<input type="hidden" id="clevel" name="clevel" value="1"/>
						<input type="hidden" id="ctype" name="ctype" value="0"/>
						<input type="hidden" id="pushMessage" name="pushMessage" value="true"/>
            		</form>
					<textarea id="replyContent" name="回复内容"  class='w100b' rows="6" cols="37" style="resize: none;"></textarea>
					<div class="padding_t_5">
					<span class="left"><input type="checkbox" id="sendMessage" name="sendMessage" checked="checked" /><span class="margin_l_5">${ctp:i18n("taskmanage.sendMessage.label")}</span></span>
					<span class='green right'>${ctp:i18n("collaboration.sender.postscript.lengthRange")}</span>
					</div>
					<br>
					<a style="padding-left:5px;padding-right:5px;" class="common_button common_button_gray right margin_5" href="javascript:void(0)" onclick="closeReplyForm()">${ctp:i18n("common.button.cancel.label")}</a>
					<a style="padding-left:5px;padding-right:5px;" class="common_button common_button_gray right margin_tb_5" href="javascript:void(0)" onclick="submitReplyForm()">${ctp:i18n("common.button.ok.label")}</a>
			</div>
			<div class="stadic_body_top_bottom" style="height:50px;">
               <jsp:include page="/WEB-INF/jsp/common/content/comment.jsp">
                   <jsp:param value="${isUpdate}" name="isBtnEidt"/>
               </jsp:include>
			</div>
        </div>
        <div class="layout_center over_hidden" layout="sprit:false">
            <div class="stadic_layout_head stadic_left_head_height">
                <div class="common_tabs clearfix margin_5 ">
                    <ul class="left" id="tab_list">
                        <li class="current"><a hideFocus="true" class="border_b" href="javascript:void(0)" onclick="changeMenuTab(this)" url="${path}/taskmanage/taskinfo.do?method=taskInfoDetail&id=${param.id}&isBtnEidt=${isUpdate}&viewType=${empty param.viewType ? 2 : param.viewType}">${ctp:i18n("taskmanage.detail")}</a></li>
                        <li><a hideFocus="true" href="javascript:void(0)" onclick="changeMenuTab(this)" url="${path}/taskmanage/taskinfo.do?method=viewTaskTree&id=${param.id}&isBtnEidt=${isUpdate}&viewType=${empty param.viewType ? 2 : param.viewType}&isFromTree=${empty param.isFromTree ? 1 : param.isFromTree}&isViewTree=${empty param.isViewTree ? 0 : param.isViewTree}">${ctp:i18n("taskmanage.tree")}</a></li>
                        <li><a hideFocus="true" href="javascript:void(0)" onclick="changeMenuTab(this)" url="${path}/taskmanage/taskfeedback.do?method=listTaskFeedback&id=${param.id}&isBtnEidt=${isUpdate}&viewType=${empty param.viewType ? 2 : param.viewType}">${ctp:i18n("taskmanage.progress")}</a></li>
                        <li><a hideFocus="true" class="last_tab" href="javascript:void(0)" onclick="changeMenuTab(this)" url="${path}/plan/plan.do?method=getRefPlans&sourceId=${param.id}&viewType=${empty param.viewType ? 2 : param.viewType}">${ctp:i18n("taskmanage.relevantPlan")}</a></li>
                    </ul>
                </div>
                <div class="font_size12 margin_t_5 hidden">
                    <a class="img-button margin_r_0" href="javascript:void(0)"><em class="ico16 edit_16"></em>修改</a> 
                    <a class="img-button margin_r_0" href="javascript:void(0)"><em class="ico16 affix_16 "></em>分解</a>
                </div>
            </div>
            <div class="stadic_layout_body stadic_left_body_top_bottom" id="static_layout_body" style="overflow: visible;">
                <iframe id="taskDetail_content_iframe" name="taskDetail_content_iframe" width="100%" height="100%" src="" frameborder="no" border="0"></iframe>
                <input type="hidden" id="is_update" name="is_update" value="0"/>
            </div>
        </div>
    </div>
</body>

</html>
