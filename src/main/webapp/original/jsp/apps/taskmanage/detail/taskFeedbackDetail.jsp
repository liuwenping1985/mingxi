<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>任务详情-汇报进度</title>
</head>

<body id="feadbackList" scrolling="no" style="overflow:hidden;background-color:#F6F6F6;">
  <div class="projectTask_detail projectTask_detail_noBorder" style="top:0px;width:100%;">
  	<c:if test="${canFeedback}">
    	<iframe  id='task_feedback_iframe' name='task_feedback_iframe' height="170px" src='' frameborder='0' width='100%' style='overflow:hidden;border-bottom:solid 1px #c8c8c8' ></iframe>
   	</c:if>
   <div class="tabs_area_body">
    <div class="tab_report">
            <ul>
            <c:forEach var="feedback" items="${taskFeedbackList}" varStatus="status">
                <li class="clearfix <c:if test="${status.count==1}">current</c:if>">
                    <div class="tab_report_date">${feedback.createDay}</div>
                    <div class="tab_<c:if test="${status.count==1}">report</c:if><c:if test="${status.count!=1}">log</c:if>_point tab_report_point_${feedback.style}"></div>
                    <div class="tab_report_content">
                        <div class="tab_report_content_time">${feedback.createTime}</div>
                        <div class="tab_report_content_people">${feedback.createUser}</div>
                        <div class="tab_report_content_text">
                            <div class="common_rateProgress clearfix left">
                                <span class="common_rateProgress_text">${feedback.taskStatus}</span><span class="rateProgress_box"><span class="rateProgress_${feedback.style}" style="width:${feedback.finishRate}%;"></span></span><span class="common_rateProgress_number">${feedback.finishRate}%</span>
                            </div>
                            <c:if test="${!empty feedback.elapsedTime && feedback.elapsedTime != '0'}">
                            <span class="tab_report_content_text_consum">${ctp:i18n("taskmanage.elapsedTime")}:${feedback.elapsedTime}${ctp:i18n("common.time.hour")}</span>
                            </c:if>
                            <c:if test="${feedback.taskRiskLevelId != 0}">
                            <span class="tab_report_content_text_risk">${ctp:i18n("taskmanage.risk")}:${feedback.taskRiskLevel}</span>
                        	</c:if>
                        </div>
                        <c:if test="${not empty feedback.content}">
                        <div class="tab_report_content_c" style="width:380px;word-wrap: break-word;word-break: break-all;">${feedback.content}</div>
                        </c:if>
                       <c:if test="${feedback.attachments != '[]'}">
                        <div class="tab_report_content_attachment margin_t_10">
                        	<div id="attachmentTR" class="left" style="display:none;"></div>
                        	  <c:if test="${feedback.attNum > 0 }" >
	        					  <div class="clearfix" id="Attachment_${status.index}">
				                    <div class="color_black left margin_r_5" style="margin-top: 5px;color: #8d8d8d;font-size: 12px;">
				                    	<em class="ico16 affix_16" style="cursor:default"></em>
				                    	(<span id="feedbackAttachmentsSize_${status.index}">${ feedback.attNum}</span>)
				                    </div>
	        						<div name="attrFileUpload" class="comp" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false" attsdata='${ feedback.attachments}'></div>
				                </div>
                        	  </c:if>
                        	  <c:if test="${feedback.accdocNum > 0 }" >
	        					 <div class="clearfix" id="RelAttachment_${status.index}">
				                    <div class="color_black left margin_r_5" style="margin-top: 5px;color: #8d8d8d;font-size: 12px;">
				                    	<em class="ico16 associated_document_16"></em>
				                    	(<span id="feedbackRelSize_${status.index}">${ feedback.accdocNum}</span>)
				                    </div>
	        						<div name="attachmentResourceTR" class="comp" comp="type:'assdoc',applicationCategory:'30',attachmentTrId:'${feedback.id}',canDeleteOriginalAtts:false,referenceId:'${feedback.taskId}', modids:'1,3'" attsdata='${feedback.attachments}'></div>
	        					 </div>
                        	  </c:if>
        				</div>
        				</c:if>
                    </div>
                </li>
            </c:forEach>
            </ul>
        </div>
      </div>
    </div>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		//如果页面来自任务与绩效不显示内容
		bindHoverEvent();
		setHeight();
		loadIframe();
	}); 

function loadIframe(){//OA-82223 直接加载会导致报错，顺序加载就不会了
	var canFeedBack=${canFeedback};
	if(canFeedBack == true){
		$("#task_feedback_iframe").attr('src',"${path}/taskmanage/taskfeedback.do?method=newTaskFeedbackPage&isEidt=1&operaType=new&taskId=${param.taskId}&isTimeLine=${param.isTimeLine}");
	}
}
/**
*绑定hover效果
*/
function bindHoverEvent(){
    $("[name='attrFileUpload']").next().find(".attachment_block").css("color","gray");
    $("[name='attachmentResourceTR']+div a").css("color","gray").live("mouseover",function(){
    	$(this).css("color","#318ed9");
    }).live("mouseout",function(){
    	$(this).css("color","gray");
    })
}
function setHeight(){
    	var iframeHeight = 0;
    	if( !${canFeedback} && $.isNull("${taskFeedbackList}")){
    		var html = "<div class=\"have_a_rest_area\" id=\"notcontent\">"+ "${ctp:i18n("taskmanage.condition.no.content")}" +"</div>";
    		$("#feadbackList").html(html);
	    	parent.$("#feedbackAreaIframe").height($("#feadbackList").height());
	    	parent.$("#tabs_area").height(parent.$("#feedbackAreaIframe").height());
    	}else if(parent.from == "bnOperate" || parent.from == "planTask"){
        	$("#task_feedback_iframe").hide();
    		if(0==$(".tab_report>ul>li").length){
    			var parent_body_height = parent.$("#body_area").height();
    	    	var parent_head_height = parent.$(".padding_lr_15").height();
    			var html = "<div class=\"have_a_rest_area\" id=\"notcontent\">"+ "${ctp:i18n("taskmanage.condition.no.content")}" +"</div>";
        		$("#feadbackList").html(html);
        		if(210<(parent_body_height-parent_head_height)){
            		parent.$("#feedbackAreaIframe").height(parent_body_height-parent_head_height-30);
            		parent.$("#tabs_area").height(parent_body_height-parent_head_height-30)
            	}else{
    	    		parent.$("#feedbackAreaIframe").height(210);
    	    		parent.$("#tabs_area").height(210);
                }
    		}else{
			       parent.$("#tabs_area").addClass("tabs_area_body_timeLineBg");
		    		var parent_body_height = parent.$("#body_area").height();
		    	    var parent_head_height = parent.$(".padding_lr_15").height();
        			$("#feadbackList").height($(".tab_report").height());
        			$(".projectTask_detail").height($(".tab_report").height());
			    	parent.$("#feedbackAreaIframe").height($(".tab_report").height());
			    	if($(".tab_report").height()>(parent_body_height-parent_head_height)){
				    	parent.$("#tabs_area").height(parent.$("#feedbackAreaIframe").height());
				    }else{
				    	parent.$("#tabs_area").height(parent_body_height-parent_head_height-30);
					}
            	}
        }else{
        	if($(".tab_report>ul>li").length>0){
			       parent.$("#tabs_area").addClass("tabs_area_body_timeLineBg");
			}else{
			  	$(".tabs_area_body").html("<div class=\"have_a_rest_area\" id=\"notcontent\">"+ $.i18n("taskmanage.condition.no.content") +"</div>");
			}
    		var parent_body_height = parent.$("#body_area").height();
    	    var parent_head_height = parent.$(".padding_lr_15").height();
    		var iframeHeight = "${canFeedback}"=="true" ? $("#task_feedback_iframe").height():0;
    		$("#feadbackList").height($(".tabs_area_body").height()+iframeHeight);
	    	parent.$("#feedbackAreaIframe").height($("#feadbackList").height()+5);
	    	if($("#feadbackList").height()>(parent_body_height-parent_head_height)){
		    	parent.$("#tabs_area").height(parent.$("#feedbackAreaIframe").height());
		    }else{
		    	parent.$("#tabs_area").height(parent_body_height-parent_head_height-30);
			}
    	}
    }
    function refreshPage(){
    	if('${param.isTimeLine}' == '1'){
	    	try{
	    		getCtpTop().refleshTimeLinePage();
	    	}catch(e){/* 不处理  */}
    	}else if('${param.isTimeLine}' == '2'){
        	//该刷新一移到taskDetailPage.js避免提示执行已释放的js，并且是在详细页关闭时刷新
    		//getCtpTop().$("#main")[0].contentWindow.location.reload(true);
    	}else{
    		/**
    		 *任务详细页面刷新，这段代码比较恶心，意思是尝试不同的刷新可能直到成功为止
    		 * 由于无法判断当前是在那个地方弹出的任务详细页面,如有高人请修改之
    		 */
    		try{
    			//我的任务任务树页面刷新 
    			window.top.$("#main")[0].contentWindow.$("#list_content_iframe")[0].contentWindow.refreshPageData();
    		}catch(e){
    			try{
    				//项目空间更多刷新  
    				window.top.$("#main")[0].contentWindow.$("#body")[0].contentWindow.refreshPageData();
    			}catch(e){
    				try{
    						//个人空间栏目刷新 section.js
			    			window.top.$("#main")[0].contentWindow.refreshTaskPortlet("taskMySection");
    				}catch(e){
    					try{
    						//项目空间栏目刷新
	    					window.top.$("#main")[0].contentWindow.$("#body")[0].contentWindow.refreshTaskPortlet("projectTaskSection");
    					}catch(e){}
    				}
    			}
    		}
    	}
    	window.parent.document.getElementById("feedbackAreaIframe").src=window.parent.document.getElementById("feedbackAreaIframe").src;
    	var date= new Date();
    	var fullTime=$("#fullTime",window.parent.document).val();
    	var nowDate ="";
    	if(fullTime=="0"){
    		//非全天
    		nowDate= date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes();;
    	}else{
    		//全天
    		nowDate= date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
    	}
    	var endDate = $("#plan_end_time",window.parent.document).text();
    	var finish = $("#task_feedback_iframe").contents().find("#finishrate_text").val();
    	var status = $("#task_feedback_iframe").contents().find("#status").val();
    		
    	$("#task_status",window.parent.document).text($("#task_feedback_iframe").contents().find("#status option[value='"+status+"']").text());
    	$("#task_finish_rate",window.parent.document).text(Number(finish)+"%");
    	//设置父页面隐藏的项目百分比
    	$("#task_finish_rate_data",window.parent.document).val(finish);
    	$("#task_status_num",window.parent.document).val(status);
    	//重新初始化父页面的菜单
    	window.parent.loadMenu();
    	$(".rateProgress_box span",window.parent.document).removeClass();
    	$(".rateProgress_box span",window.parent.document).css({width:finish+"%"});
    	if(status ==1){
    		$("#ztask-hasten-btn",window.parent.document).show();
    		if(compareDate(nowDate,endDate)>0){
    			$("#plan_end_time",window.parent.document).attr("color","red");
    			$(".rateProgress_box span",window.parent.document).addClass("rateProgress_red");
    		}else{
    			$(".rateProgress_box span",window.parent.document).addClass("rateProgress_white");
    		}
    	}else if(status ==2){
    		$("#ztask-hasten-btn",window.parent.document).show();
    		if(compareDate(nowDate,endDate)>0){
    			$("#plan_end_time",window.parent.document).attr("color","red");
    			$(".rateProgress_box span",window.parent.document).addClass("rateProgress_red");
    		}else{
    			$(".rateProgress_box span",window.parent.document).addClass("rateProgress_blue");
    		}
    	}else if(status ==4){
    		$(".rateProgress_box span",window.parent.document).addClass("rateProgress_green");
    		$("#ztask-hasten-btn",window.parent.document).hide();
    	}else if(status ==5){
    		$(".rateProgress_box span",window.parent.document).addClass("rateProgress_gray");
    		$("#ztask-hasten-btn",window.parent.document).hide();
    	}

        $("#task_feedback_iframe")[0].contentWindow.fnGetDialog(118);
    }
</script>
</html>
