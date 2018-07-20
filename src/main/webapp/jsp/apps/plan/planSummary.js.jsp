<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript" src="${path}/apps_res/plan/js/planSummary.js"></script>
<html class="h100b w100b">
<head>
<title>planSummary</title>
</head>
<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<body>
	<input type="hidden" id="plan_Id" name="plan_Id" value="${param.planId}"/>
	<input type="hidden" id="planPublishStatus" name="planPublishStatus" value="${publishStatus}"/>
	<input type="hidden" id="plan_Statu" name="plan_Status" value="${planStatus}"/>
	<input type="hidden" id="finishRatio" name="finishRatio" value="${finishRatio}"/>
	<input type="hidden" id="planCreateUser" name="planCreateUser" value="${createUser}"/>
	<input type="hidden" id="publishStatus" name="publishStatus" value="${publishStatus}"/>
	<input type="hidden" id="param_planId" name="param_planId" value="${param.planId}"/>	
	<input type="hidden" id="commentMaxPathStr" name="commentMaxPathStr" value="${commentMaxPathStr}"/>
	<input type="hidden" id="param_readOnly" name="param_readOnly" value="${param.readOnly}"/>
	<input type="hidden" id="i18n_reply" name="i18n_reply" value="${ctp:i18n('plan.summary.tab.reply')}"/>
	<input type="hidden" id="i18n_replyOpinion" name="i18n_replyOpinion" value="${ctp:i18n('collaboration.opinion.replyOpinion')}"/>
	<input type="hidden" id="i18n_lengthRange" name="i18n_lengthRange" value="${ctp:i18n('collaboration.sender.postscript.lengthRange')}"/>
	<input type="hidden" id="i18n_opinionhide" name="i18n_opinionhide" value="${ctp:i18n('plan.summary.tab.opinionhide')}"/>
	<input type="hidden" id="i18n_submit" name="i18n_submit" value="${ctp:i18n('plan.submit')}"/>
	<input type="hidden" id="i18n_cancel" name="i18n_cancel" value="${ctp:i18n('plan.alert.plannew.cancel')}"/>
	<input type="hidden" id="attachment_label" name="attachment_label" value="${ctp:i18n('common.attachment.label')}"/>
	
</body>
</html>