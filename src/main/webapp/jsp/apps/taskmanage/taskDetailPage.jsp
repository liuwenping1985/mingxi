<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body class="h100b over_hidden">
  <!-- 项目任务－查看页－内容 -->
  <div id="taskDetailInfo">
  <%-- 添加项目ID回填 --%>
  <input type="hidden" value="${projectId }" id="projectId"/>
   <input type="hidden" value="${task_finish_rate_data }" id="task_finish_rate_data"/>
  <input type="hidden" value="${task_status_num }" id="task_status_num"/>
  <input type="hidden" value="${isNew}" id="isNew"/>
  <div class="projectTask_detail">
    <div class="head_area clearfix">
      <input type="hidden" id="fullTime" value="${fullTime}"/>
      <span class="title" id="task_title" title="${taskTitle}"></span>
      <c:if test="${from !='msg' and drillDown!='true'}">
      	<span class="taskClose"><em class="ico24 close_24" onclick='refreshAndClose()'></em></span>
      </c:if>
      <c:if test="${(isEdit eq true and isDelete eq true and isDecompose eq true) or isManageFlag eq 1 or isParentTaskManage}">
      <c:if test="${from !='bnOperate' and from !='planTask' and drillDown!='true'}">
      	<!--绩效日常工作统计不能对任务进行操作-->
      	<span class="taskClose" style="border: 0px;"><em class="ico24 project_search_24" id="taskSet"></em></span>
      </c:if>
      </c:if>
    </div>
    <div class="body_area" style="width:100%;" id="body_area">
      <div class="padding_lr_15">
        <div class="clearfix">
          <div class="time">
            <em class="ico16 time_16"></em><span id="plan_end_time" <c:if test="${isOverTime eq true}">style="color:red"</c:if>></span>
          </div>
          <div class="common_rateProgress clearfix left">
          	<span id="task_status"></span>
            <span class="rateProgress_box">
            	${rateProgress}
            </span>
            <span id="task_finish_rate"></span>
          </div>
        </div>
        <div class="content word_break_all">
         	<label id="task_content"></label>
        </div>
        <div class="origin word_break_all ${hasSource}">${ctp:i18n("taskmanage.source")} : <span id="task_source"></span></div>
        <c:if test="${not empty hasAtachmentsFile}">
        <div class="margin_t_10">
        	<div id="attachmentTR" class="left" style="display:none;"><span class='ico16 margin_l_5 v_align affix_16' style="cursor:default"></span>(<span id="attachmentNumberDiv">0</span>)</div>
        	<div class="comp" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false" attsdata="${ attachmentFile}"></div>
        </div>
        </c:if>
        <c:if test="${not empty hasAttachmentDoc}">
        <div class="margin_l_5">
        	<div class="left"><span class="ico16 associated_document_16"></span>(<span id="attachment2NumberDivposition1">0</span>)</div>
        	<div class="comp" comp="type:'assdoc',applicationCategory:'30',canDeleteOriginalAtts:false,attachmentTrId:'position1', modids:'1,3'" attsdata="${ attachmentDoc}"></div>
        </div>
        </c:if>
        <ul class="tabs_area clearfix">
          <li class="current" id="task_reply_li" onclick="taskLiEvent(0)" style="font-size: 14px;">${ctp:i18n('taskmanage.reply.action')}</li>
          <li onclick="taskLiEvent(1)" id="task_sta_li" style="font-size: 14px;">${ctp:i18n('taskmanage.detail.report.label')}</li>
          <li onclick="taskLiEvent(2)" id="task_log_li" style="font-size: 14px;">${ctp:i18n('taskmanage.detail.log.label')}</li>
        </ul>
      </div>
      <!-- 页签－回复 -->
      <div class="tabs_area_body" id="tabs_area">
        <jsp:include page="/WEB-INF/jsp/apps/taskmanage/comments_original.jsp?moduleType=30&moduleId=${taskId}&subject=${subject}"></jsp:include>
        <iframe class="hidden" id="feedbackAreaIframe" hrefAttr='${path}/taskmanage/taskfeedback.do?method=displayTaskFeedback&taskId=${taskId}&isTimeLine=${param.isTimeLine}' frameborder='0' width='100%' style='overflow:hidden;'></iframe>
        <div id="logArea" style='display:none;'>
        <iframe  id='task_log_iframe' name='task_log_iframe' hrefAttr='${path}/taskmanage/taskinfo.do?method=showTaskLog&taskId=${taskId}' frameborder='0' width='100%' style='overflow:hidden;'></iframe>
        </div>
      </div>
      	<!--[if IE 7]>
	      <script type="text/javascript">
      			//IE7 高度设置为x%失效，兼容
	      		var bodyHeight = $("#body_area").height()-$(".padding_lr_15").height()-100;
	      		$("#feedbackAreaIframe").height(bodyHeight);
	      		$("#logArea").height(bodyHeight);
	      </script>
		<![endif]-->
<!-- 页签－汇报 -->

<!-- 页签－日志 -->
    </div>
  </div>
  </div>
</body>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=ctpCommentManager,taskAjaxManager,taskDetailTreeManager'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/taskmanage/js/taskDetailPage.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/taskmanage/js/comments.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript">
	var ulObj,areaObj;
	var planEndTime="${planEndTime}";
	var fullTime="${fullTime}";
	var taskId="${taskId}";
	var from="${from}";
	var timeLineTyoe="${param.isTimeLine}";//时间线类型：=2表示时间视图
	if(getCtpTop().fromType!=""&&from==""){
		from=getCtpTop().fromType;
	}
	var hasLoadingFeedback = false;
	var hasLoadingLog =false;
	var category="${category}";
	$(function(){
		setAttachCss();
		loadMenu();
		$("#replyArea").loadCommentArea(30, taskId);
        $("#commentContent").textareaGray();
        if(from=='bnOperate'||from=='planTask'){
	        $("#reply_li").hide();
			//$(".have_a_rest_area").show();
			$("#taskSet").remove();
		}
		if(category=="feedback"){
			taskLiEvent(1);
		}
	});
</script>
</html>