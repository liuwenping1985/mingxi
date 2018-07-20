<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
<script type="text/javascript" src="<c:url value='/apps_res/taskmanage/js/taskDetailPage.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/taskmanage/js/comments.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=ctpCommentManager'/>"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script>
	$(function(){
		setNotContent()
	});
	function setNotContent(){
    	var parent_body_height = parent.$("#body_area").height();
    	var parent_head_height = parent.$(".padding_lr_15").height();
    	if(0 == $("#tab_log").find("li").length){
    		var html = "<div class=\"have_a_rest_area\" id=\"notcontent\">"+ "${ctp:i18n("taskmanage.condition.no.content")}" +"</div>";
    		$("#tasklogbody").html(html);
    		if(210<(parent_body_height-parent_head_height)){
        		parent.$("#task_log_iframe").height(parent_body_height-parent_head_height-30);
        		parent.$("#tabs_area").height(parent_body_height-parent_head_height-30)
        	}else{
	    		parent.$("#task_log_iframe").height(210);
	    		parent.$("#tabs_area").height(210);
            }
    	}else{
	    	var taskLogHeight = $(".tabs_area_body").height();
        	if(taskLogHeight<(parent_body_height-parent_head_height)){
        		parent.$("#task_log_iframe").height(taskLogHeight);
        		parent.$("#tabs_area").height(parent_body_height-parent_head_height-30)
        	}else{
	    		parent.$("#tabs_area").height(taskLogHeight);
	    		parent.$("#task_log_iframe").height(taskLogHeight);
            }
        }
    }
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body scrolling="no" id="tasklogbody" class="page_color">
  <div class="projectTask_detail projectTask_detail_noBorder" style="top:0px;width:100%;overflow-y:hidden;overflow-x:hidden;">
      <div class="tabs_area_body">
       <div class="tab_log" id="tab_log">
            <ul>
      <c:forEach var="log" items="${logList}" varStatus="status">
                
          <c:choose>
          <c:when test="${status.count==1}">
          <li class="clearfix current">
          <div class="tab_log_date">${log.MYDate}</div>
          
                    <div class="tab_log_point"></div>
                    <div class="tab_log_content">
                        <div class="tab_log_content_time">${log.HMDate}</div>
                        <div class="tab_log_content_people" style="width:260px;white-space:nowrap;overflow: hidden;text-overflow:ellipsis;">${log.memberName}</div>
                        <div class="tab_log_content_text" style="width:357px">${log.content}
             <c:forEach var="contentNode" items="${log.logContentNode}">
                        <p></p>${contentNode}</c:forEach>
            </div>
                    </div>
          </li>
          </c:when>
          <c:otherwise>
          <li class="clearfix ">
          <div class="tab_log_date">${log.MYDate}</div>
                    <div class="tab_log_point"></div>
                    <div class="tab_log_content">
                        <div class="tab_log_content_time">${log.HMDate}</div>
                        <div class="tab_log_content_people" style="width:260px;white-space:nowrap;overflow: hidden;text-overflow:ellipsis;">${log.memberName}</div>
                        <div class="tab_log_content_text" style="width:357px">${log.content}
                        <c:forEach var="contentNode" items="${log.logContentNode}">
                        <p></p>${contentNode}</c:forEach>
                        </div>
                    </div>
         </li>
          </c:otherwise>
          </c:choose>
                    
       </c:forEach>
              
            </ul>
        </div>
      </div>
	</div>
</body>
</html>