<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%--此处对计划模块有强关联，后期要收拾 --%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>任务详情页面</title>
	<style type="text/css">
	  .red{color:red}
	  .projectTask_detail .body_area .origin a {color: #318ed9;}
	</style>
</head>
<body class="h100b over_hidden">
  <div id="taskDetailInfo">
  
	  <%-- 添加项目ID回填 --%>
	  <input type="hidden" value="${task.projectId }" id="projectId"/>
	  <input type="hidden" value="${task.finishRate }" id="task_finish_rate_data"/>
	  <input type="hidden" value="${task.status }" id="task_status_num"/>
      <input type="hidden" value="${task.fullTime ? "1" : "0" }" id="fullTime"/>
      
      
	  <div class="projectTask_detail">
	  	
		  	<%-- 任务的头部 --%>
		    <div class="head_area clearfix">
		      <span class="title" title="${ctp:toHTML(task.subject)}">${taskTitleDisplay }</span>
		      
		      <c:if test="${param.from !='msg' and param.drillDown!='true'}">
		      		<span class="taskClose"><em class="ico24 close_24" onclick='refreshAndClose()'></em></span>
		      </c:if>
		      
		      <c:if test="${taskAuth.canDelete || taskAuth.canUpdate || taskAuth.canDecompose}">
			      <c:if test="${param.from !='bnOperate' and param.from !='planTask' and param.drillDown != 'true'}">
			      	<!--绩效日常工作统计不能对任务进行操作-->
			      	<span class="taskClose" style="border: 0px;"><em class="ico24 project_search_24" id="taskSet"></em></span>
			      </c:if>
		      </c:if>
		    </div>
		    
		    <%-- 任务的内容 --%>
		    <div class="body_area" style="width:100%;" id="body_area">
		    
			      <div class="padding_lr_15">
				        <div class="clearfix">
					          <div class="time">
					            <em class="ico16 time_16"></em>
					            <span class="${isOverTime ? 'red' : '' }">${plannedEndTime }</span>
					          </div>
					          <div class="common_rateProgress clearfix left">
					          	<span id="task_status">${taskStatusDisplay }</span>
					            <span class="rateProgress_box">
					            	<span class='${rateProgressColor }' style='width:${taskfinishRate }%;'></span>
					            </span>
					            <span id="task_finish_rate">${taskfinishRate }%</span>
					          </div>
					          
					          <%-- 催办按钮    --%>
							  <c:choose>
							  	<c:when test="${taskAuth.canHasten && task.status < 4 && task.finishRate < 100 }">
									<a href="javascript:void(0)" id="task-hasten-btn" onclick="hasten('${com.seeyon.apps.task.id}')" class="common_button common_button_emphasize" style="margin-top: -15px;">${ctp:i18n("taskmanage.toolbar.hasten.label") }</a>
							  	</c:when>
							  	<c:when test="${taskAuth.canHasten}">
							  		<a href="javascript:void(0)" id="task-hasten-btn" onclick="hasten('${com.seeyon.apps.task.id}')" class="common_button common_button_emphasize" style="margin-top: -15px; display:none;">${ctp:i18n("taskmanage.toolbar.hasten.label") }</a>
							  	</c:when>
							  </c:choose>
				        </div>
				        
				        <div class="content" style="word-break:normal">
				         	<label>${ctp:toHTMLWithoutSpace(taskContent) }</label>
				        </div>
				        
				        <div class="origin word_break_all ${hasSource ? '' : 'hidden' }">
				        	${ctp:i18n("taskmanage.source")} : 
				        	<span id="task_source">
				        		${sourceLabel }
				        	</span>
				        </div>
				        
				        <c:if test="${not empty hasAtachmentsFile}">
				        <div class="margin_t_10">
				        	<div id="attachmentTR" class="left" style="display:none;">
				        		<span class='ico16 margin_l_5 v_align affix_16' style="cursor:default"></span>(<span id="attachmentNumberDiv">0</span>)
				        	</div>
				        	<div class="comp" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false" attsdata="${ attachmentFile}"></div>
				        </div>
				        </c:if>
				        
				        <c:if test="${not empty hasAttachmentDoc}">
				        <div class="margin_l_5">
				        	<div class="left">
				        		<span class="ico16 associated_document_16"></span>(<span id="attachment2NumberDivposition1">0</span>)
				        	</div>
				        	<div class="comp" comp="type:'assdoc',applicationCategory:'30',canDeleteOriginalAtts:false,attachmentTrId:'position1', modids:'1,3'" attsdata="${ attachmentDoc}"></div>
				        </div>
				        </c:if>
				        
				        <ul class="tabs_area clearfix">
				          <li class="current" id="task_reply_li" onclick="taskLiEvent(0)" style="font-size: 14px;">${ctp:i18n('taskmanage.reply.action')}</li>
				          <li onclick="taskLiEvent(1)" id="task_sta_li" style="font-size: 14px;">${ctp:i18n('taskmanage.detail.report.label')}</li>
				          <li onclick="taskLiEvent(2)" id="task_log_li" style="font-size: 14px;">${ctp:i18n('taskmanage.detail.log.label')}</li>
				        </ul>
			      </div>
			      
			      <div class="tabs_area_body" id="tabs_area">
		      	  <%-- 回复页签 --%>
		          <jsp:include page="/WEB-INF/jsp/apps/taskmanage/detail/taskCommentArea.jsp">
		        	 <jsp:param value="${task.subject}" name="subject"/>
		        	 <jsp:param value="${task.id}" name="moduleId"/>
		        	 <jsp:param value="30" name="moduleType"/>
		        	 <jsp:param value="${currentUserId}" name="currentUserId"/>
		          </jsp:include>
			        
			      	<%-- 汇报页签 --%>
			        <iframe class="hidden" id="feedbackAreaIframe" hrefAttr='${path}/taskmanage/taskinfo.do?method=taskFeedbackDetail&taskId=${task.id}&isTimeLine=${param.isTimeLine}' frameborder='0' width='100%' style='overflow:hidden;'></iframe>
			      	
			      	<%-- 任务日志页签 --%>
			        <div id="logArea" style='display:none;'>
			        	<iframe  id='task_log_iframe' name='task_log_iframe' hrefAttr='${path}/taskmanage/taskinfo.do?method=taskLogDetail&taskId=${task.id}' frameborder='0' width='100%' style='overflow:hidden;'></iframe>
			        </div>
			      </div>
			      
		    </div>
		    <%-- 任务的内容end --%>
	  	</div>
  </div>
</body>
<!--[if IE 7]>
<script type="text/javascript">
 	//IE7 高度设置为x%失效，兼容
    var bodyHeight = $("#body_area").height()-$(".padding_lr_15").height()-100;
    $("#feedbackAreaIframe").height(bodyHeight);
    $("#logArea").height(bodyHeight);
</script>
<![endif]-->
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/taskmanage/js/detail/com.seeyon.apps.task-detail-main-debug.js${v3x:resSuffix()}"></script>
<script type="text/javascript" src="${path }/apps_res/taskmanage/js/detail/com.seeyon.apps.task-comment-detail-debug.js${v3x:resSuffix()}"></script>
<script type="text/javascript" src="${path }/common/content/formCommon.js${ctp:resSuffix()}"></script>

<script type="text/javascript">
	var ulObj,areaObj;
	var planEndTime="${task.plannedEndTime}";
	var fullTime="${task.fullTime ? "1" : "0" }";
	var taskId="${task.id}";
	var from="${param.from}";
	var timeLineTyoe="${param.isTimeLine}";//时间线类型：=2表示时间视图
	if(getCtpTop().fromType!=""&&from==""){
		from=getCtpTop().fromType;
	}
	var hasLoadingFeedback = false;
	var hasLoadingLog =false;
	var category="${param.category}";
	var canUpdate = ${taskAuth.canUpdate },canDecompose = ${taskAuth.canDecompose },canDelete = ${taskAuth.canDelete },hasNewTaskAuth = ${hasNewTaskAuth };
	$(function(){
		setAttachCss();
		//加载菜单
		loadMenu();
		//加载评论
		$("#replyArea").loadCommentArea(30, taskId);
        $("#commentContent").textareaGray();
        //评论隐藏
        if(from=='bnOperate'||from=='planTask'){
	        $("#reply_li").hide();
		}
		if(category=="feedback"){
			taskLiEvent(1);
		}
	});
</script>
</html>