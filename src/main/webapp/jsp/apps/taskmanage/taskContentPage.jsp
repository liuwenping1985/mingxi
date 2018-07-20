<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body class="h100b over_hidden">
  <!-- 项目任务－查看页－内容 -->
  <div id="taskDetailInfo">
  <!-- 项目任务－查看页－更多信息 -->
  <div class="projectTask_detail_info">
    <div class="head_area clearfix">
      <span class="title">${ctp:i18n('taskmanage.detail')}</span>
      <c:if test="${from !='msg' and drillDown!='true'}">
      	<span class="taskClose"><em class="ico24 close_24" onclick="javascript:closeContentPage()"></em></span>
      </c:if>
    </div>
    <div class="body_area" style="padding-top:18px">
      <c:if test="${hasProjectName eq true}">
      	<div class="item_area word_break_all" style="padding-bottom:10px">
        <p class="title" style="padding-bottom:2px;">${ctp:i18n('taskmanage.detail.project.label')}</p>
        <p class="text" id="project_name"></p>
      </div>
     </c:if>
     <c:if test="${hasParentTaskSubject eq true}">
      <div class="item_area word_break_all" style="padding-bottom:10px">
        <p class="title">${ctp:i18n('taskmanage.parentTask')}</p>
        <p class="text" id="parent_task_subject"></p>
      </div>
     </c:if>
      ${targtTable}
      <div class="item_area" style="padding-bottom:10px">
        <p class="title">${ctp:i18n('taskmanage.planTime.part')}</p>
        <p class="text">
        	<label id="plan_start_time_y"></label>
        	<label id="plan_start_time_m" class="margin_l_10"></label>
        	<c:if test="${remindStartTime ne -1}">
        		<span class="ico16 time_remind_16 margin_b_2" title="${ctp:i18n('taskmanage.remind.before.start')}: ${remindStartTimeText}"></span>
        	</c:if>
        </p>
        <p class="text">
       	 	<label id="plan_end_time_y"></label>
       	 	<label id="plan_end_time_m" class="margin_l_10"></label>
       	 	<c:if test="${remindEndTime ne -1}">
       	 		<span class="ico16 time_remind_16 margin_b_2" title="${ctp:i18n('taskmanage.remind.before.end')}: ${remindEndTimeText}"></span>
       	 	</c:if>
       	 </p>
      </div>
      <c:if test="${hasActualTime eq true}">
	   <div class="item_area" style="padding-bottom:10px">
	        <p class="title">${ctp:i18n('taskmanage.actualtime.part')}</p>
       	 	<p class="text">
       	 		<label id="actual_start_time_y"></label>
       	 		<label id="actual_start_time_m" class="margin_l_10"></label>
       	 	</p>
       	 	<p class="text">
       	 		<label id="actual_end_time_y"></label>
       	 		<label id="actual_end_time_m" class="margin_l_10"></label>
       	 	</p>
	   	</div>
      </c:if>
      <div class="peopleList">
        <p class="peopleList_title">${ctp:i18n('taskmanage.manager')}</p>
        <ul class="clearfix">
         	<c:forEach var="memberBo" items="${manageList}" varStatus="status">
      				<li class="peopleList_item" style="padding-right:0px;height:65px">
            			<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${memberBo.imgUrl}" alt="">
            			<div class="peopleList_item_name" title="${memberBo.userName}" style="height:18px">${memberBo.userName}</div>
          			</li>
      		</c:forEach>
        </ul>
      </div>
      <c:if test="${not empty participatsList}">
	      <div class="peopleList">
	        <p class="peopleList_title">${ctp:i18n('taskmanage.participator')}</p>
	        <ul class="clearfix">
	         	<c:forEach var="memberBo" items="${participatsList}" varStatus="status">
	      				<li class="peopleList_item" style="padding-right:0px;height:65px">
	            			<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${memberBo.imgUrl}" alt="">
	            			<div class="peopleList_item_name" title="${memberBo.userName}" style="height:18px">${memberBo.userName}</div>
	          			</li>
	      		</c:forEach>
	        </ul>
	      </div>
      </c:if>
      <c:if test="${not empty inspectorsList}">
      <div class="peopleList">
        <p class="peopleList_title">${ctp:i18n('taskmanage.detail.tell.label')}</p>
        <ul class="clearfix">
         	<c:forEach var="memberBo" items="${inspectorsList}" varStatus="status">
      				<li class="peopleList_item" style="padding-right:0px;height:65px">
            			<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${memberBo.imgUrl}" alt="">
            			<div class="peopleList_item_name" title="${memberBo.userName}" style="height:18px">${memberBo.userName}</div>
          			</li>
      		</c:forEach>
        </ul>
      </div>
      </c:if>
      <div class="peopleList">
        <p class="peopleList_title">${ctp:i18n('taskmanage.detail.creator.label')}</p>
        <ul class="clearfix">
      		<li class="peopleList_item" style="height:65px">
            	<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${creator.imgUrl}" alt="">
            	<div class="peopleList_item_name" title="${creator.userName}" style="height:18px">${creator.userName}</div>
          	</li>
        </ul>
      </div>
    </div>
  </div>
  </div>
</body>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskContentPage.js${ctp:resSuffix()}"></script>
</html>