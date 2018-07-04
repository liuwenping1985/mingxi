<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>任务详情页签</title>
</head>
<body class="h100b over_hidden">
	  <div id="taskDetailInfo">
		  <div class="projectTask_detail_info">
			    <div class="head_area clearfix">
				      <span class="title">${ctp:i18n('taskmanage.detail')}</span>
				      <c:if test="${param.from !='msg' && param.drillDown != 'true'}">
				      <span class="taskClose"><em class="ico24 close_24" onclick="javascript:closeContentPage()"></em></span>
				      </c:if>
			    </div>
		    <div class="body_area" style="padding-top:18px">
		    	 <%--创建时间 --%>
                 <div class="item_area word_break_all" style="padding-bottom:10px">
                    <p class="title" style="padding-bottom:2px;">${ctp:i18n('common.date.create.label')}</p>
                    <p class="text">${ctp:formatDateTime(task.createTime) }</p>
                 </div>
		    	  <%-- 项目任务 --%>
			      <c:if test="${!empty project}">
			      <div class="item_area word_break_all" style="padding-bottom:10px">
			        <p class="title" style="padding-bottom:2px;">${ctp:i18n('taskmanage.detail.project.label')}</p>
			        <p class="text">${ctp:toHTML(project.projectName) }</p>
			     </div>
			     </c:if>
			     
			     <%-- 上级任务 --%>
			     <c:if test="${!empty task.parentTaskSubject}">
			     <div class="item_area word_break_all" style="padding-bottom:10px">
			        <p class="title">${ctp:i18n('taskmanage.parentTask')}</p>
			        <p class="text">${ctp:toHTML(task.parentTaskSubject) }</p>
			     </div>
			     </c:if>
			     
			     <%-- 组装动态table(权重,重要程度,里程碑) --%>
			     <c:if test="${not empty  tableThead}" >
			      <table class="item_area" style="padding-bottom:10px">
			      	<tbody>
			      		<tr>
			      			<th width="58px" nowrap="nowrap">${tableThead[0] }</th>
			      			<th width="90px" nowrap="nowrap" style="padding-left:2px">${fn:length(tableThead) == 3 ? tableThead[1] : "" }</th>
			      			<th width="60px" nowrap="nowrap" >${fn:length(tableThead) == 3 ? tableThead[2] : (fn:length(tableThead) == 2 ? tableThead[1] :"" )}</th>
						</tr>
						<tr>
							<td nowrap="nowrap">${tableTbody[0] }</td>
							<td nowrap="nowrap">${fn:length(tableTbody) == 3 ? tableTbody[1] : "" }</td>
							<td nowrap="nowrap">${fn:length(tableTbody) == 3 ? tableTbody[2] : (fn:length(tableTbody) == 2 ? tableTbody[1] : "") }</td>
						</tr>
					</tbody>
				</table>
				</c:if>
				
		      	<%-- 开始结束时间 --%>  
		      	<div class="item_area" style="padding-bottom:10px">
		       		<p class="title">${ctp:i18n('taskmanage.planTime.part')}</p>
		        	<p class="text">
		        		<label>${plan_start_time_y }</label>
		        		<label class="margin_l_10">${plan_start_time_m }</label>
		        		<c:if test="${task.remindStartTime ne -1}">
		        			<span class="ico16 time_remind_16 margin_b_2" title="${ctp:i18n('taskmanage.remind.before.start')}: ${remindStartTimeText}"></span>
		        		</c:if>
		        	</p>
		        	<p class="text">
		       	 		<label>${plan_end_time_y }</label>
		       	 		<label class="margin_l_10">${plan_end_time_m }</label>
		       	 		<c:if test="${task.remindEndTime ne -1}">
		       	 			<span class="ico16 time_remind_16 margin_b_2" title="${ctp:i18n('taskmanage.remind.before.end')}: ${remindEndTimeText}"></span>
		       	 		</c:if>
		       	 	</p>
		      	</div>
			      
			      
		      	<c:if test="${!empty task.actualStartTime }">
			   	<div class="item_area" style="padding-bottom:10px">
			        <p class="title">${ctp:i18n('taskmanage.actualtime.part')}</p>
		       	 	<p class="text">
		       	 		<label>${actual_start_time_y }</label>
		       	 		<label class="margin_l_10">${actual_start_time_m }</label>
		       	 	</p>
		       	 	<p class="text">
		       	 		<label>${actual_end_time_y }</label>
		       	 		<label class="margin_l_10">${actual_end_time_m }</label>
		       	 	</p>
			   	</div>
		      	</c:if>
			      
			    <div class="peopleList">
			        <p class="peopleList_title">${ctp:i18n('taskmanage.manager')}</p>
			        <ul class="clearfix">
			         	<c:forEach var="userId" items="${managers}">
	      				<li class="peopleList_item" style="padding-right:0px;height:65px">
	            			<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${ctp:avatarImageUrl(userId)}" alt="">
	            			<div class="peopleList_item_name" title="${ctp:showMemberName(userId)}" style="height:18px">${ctp:showMemberName(userId)}</div>
	          			</li>
			     		</c:forEach>
			       </ul>
			     </div>
			     
			     <c:if test="${not empty participators}">
			      <div class="peopleList">
				        <p class="peopleList_title">${ctp:i18n('taskmanage.participator')}</p>
				        <ul class="clearfix">
				         	<c:forEach var="userId" items="${participators}">
				      				<li class="peopleList_item" style="padding-right:0px;height:65px">
				            			<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${ctp:avatarImageUrl(userId)}" alt="">
				            			<div class="peopleList_item_name" title="${ctp:showMemberName(userId)}" style="height:18px">${ctp:showMemberName(userId)}</div>
				          			</li>
				      		</c:forEach>
				        </ul>
			      </div>
			     </c:if>
			     
			     
			     <c:if test="${not empty inspectors}">
			     <div class="peopleList">
				        <p class="peopleList_title">${ctp:i18n('taskmanage.detail.tell.label')}</p>
				        <ul class="clearfix">
				         	<c:forEach var="userId" items="${inspectors}">
				      				<li class="peopleList_item" style="padding-right:0px;height:65px">
				            			<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${ctp:avatarImageUrl(userId)}" alt="">
				            			<div class="peopleList_item_name" title="${ctp:showMemberName(userId)}" style="height:18px">${ctp:showMemberName(userId)}</div>
				          			</li>
				      		</c:forEach>
				        </ul>
			     </div>
			     </c:if>
			     
			      <div class="peopleList">
				        <p class="peopleList_title">${ctp:i18n('taskmanage.detail.creator.label')}</p>
				        <ul class="clearfix">
				      		<li class="peopleList_item" style="height:65px">
				            	<img class="peopleList_item_pic" style="height:35px;width:35px;margin-left:5px" src="${ctp:avatarImageUrl(task.createUser)}" alt="">
				            	<div class="peopleList_item_name" title="${ctp:showMemberName(task.createUser)}" style="height:18px">${ctp:showMemberName(task.createUser)}</div>
				          	</li>
				        </ul>
			      </div>
			      
		    </div>
		  </div>
	  </div>
</body>
<script type="text/javascript">
function closeContentPage(){
	window.parent.top.$(".projectTask_detailDialogBtn_b").trigger("click");
 }
</script>
</html>