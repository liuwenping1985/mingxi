<%--
 $Author:  he.t$
 $Rev:  280$
 $Date:: 2014-12-18 14:38:52#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>${ctp:i18n('taskmanage.indexOfProjectAndTask.title')}</title>
	<script type="text/javascript" charset="UTF-8" src="${path}/common/js/ui/seeyon.ui.zsTree-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/projectandtask/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/tasklist/com.seeyon.apps.task-list-tree-debug.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
	$(document).ready(function() {
		initTreeListPage();
		$("body").bind("click",function(e){
			//增加点击事件：OA-79118点击除了列表外的其他地方，任务页面没有自动关闭
			if($(e.target).closest("div.list_item").size()<=0){
				try{
				  projectTaskDetailDialog_close();
				}catch(e){}
			}
		});
	});
	</script>
	<style>
		.stadic_head_height{height:0px;}
		.stadic_body_top_bottom{bottom: 0px;top: 0px;overflow-y:scroll;overflow-x:hidden;margin-left:5px;}
	</style>
	<script type="text/html" id="task-view-tree-tpl">
		<div class="list_item clearfix li_noControl" task_id="{{d.id}}" is_overdue="{{d.overdue}}">
<%-- 任务名称 --%>
        <span class="projectName">
<%--任务名称-重要程度图标 --%>
{{#     if(d.importantLevel == 2){                                             }}
            <span class='ico16 important_16'></span>
{{#     }else if(d.importantLevel == 3){                                       }}
            <span class='ico16 much_important_16'></span>
{{#     }                                                                      }}
<%--任务名称-里程碑图标 --%>
{{#     if(d.milestone){                                                       }}
            <span class='ico16 milestone'></span>
{{#     }                                                                      }}
<%--任务名称-风险程度图标 --%>
{{#     if(d.riskLevel == 1){                                                  }}
            <span class='ico16 l_risk_16'></span>
{{#     }else if(d.riskLevel == 2){                                            }}
            <span class='ico16 risk_16'></span>
{{#     }else if(d.riskLevel == 3){                                            }}
            <span class='ico16 h_risk_16'></span>
{{#     }                                                                      }}
<%--任务名称--%>
        {{=d.subject}}
<%--任务名称-附件图标 --%>
{{#     if(d.hasAttachments){                                                  }}
            <span class='ico16 affix_16'></span>
{{#     }                                                                      }}
        </span>
<%--项目名称--%>
        <span id="projectName" class="projectType span_projectName"><a class="{{d.projectRoletypes ? 'noClick' : 'a_noEdit'}}" projectId="{{d.projectId ? d.projectId : ''}}">{{#if(d.projectName){ }} {{=d.projectName}} {{#}else{}}{{#}  }}</a></span>
<%--状态 --%>
        <span id="status_text" class="state" statusValue="{{d.status}}"><a class="noClick {{d.auth.canFeedback ? '' : 'a_noEdit'}}">{{d.statusName}}</a></span>
            <span class="rate">
                <div class="rateProgress_box">
                {{# if(d.overdue){      }}
                    <div class="rateProgress_red" style="width:{{parseInt(d.finishRate)}}%;"></div>
                {{# }else if(d.status == 4){        }}
                    <div class="rateProgress_green" style="width:{{parseInt(d.finishRate)}}%;"></div>
                {{# }else if(d.status == 5){        }}
                    <div class="rateProgress_gray" style="width:{{parseInt(d.finishRate)}}%;"></div>
                {{# }else{                          }}
                    <div class="rateProgress_blue" style="width:{{parseInt(d.finishRate)}}%;"></div>
                {{# }                               }}
                </div>
            </span>
            <span class="rateNumber">{{parseInt(d.finishRate)}}%</span>
            <span class="people">{{d.managerNames}}</span>
<%--计划开始时间+计划结束时间 --%>
{{#     if(d.fullTime){                                                        }}
        <span class="right"><span class="time_start_1" style="width:75px">{{new Date(new Number(d.plannedStartTime)).format("yyyy-MM-dd") }}</span><span class="line">-</span><span class="time_end_1 {{d.overdue ? 'color_red' : ''}}"style="width:75px;">{{new Date(new Number(d.plannedEndTime)).format("yyyy-MM-dd") }}</span></span>
{{#     }else{                                                                 }}
        <span class="right"><span class="time_start_2" style="width:75px">{{new Date(new Number(d.plannedStartTime)).format("yyyy-MM-dd hh:mm:ss")}}</span><span class="line">-</span><span class="time_end_2 {{d.overdue ? 'color_red' : ''}}"style="width:75px;">{{new Date(new Number(d.plannedEndTime)).format("yyyy-MM-dd hh:mm:ss")}}</span></span>
{{#     }                                                                      }}
        </div>
	</script>
</head>
<body class="h100b over_hidden">
	<div class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height">
		</div>
		<div class="stadic_layout_body stadic_body_top_bottom relative">
			<div class='projectTask_listArea' style="overflow:auto;">
		    	<div id='zsTreeList' class='list list_tree'>
		    	</div>
			</div>
		</div>
	</div>
</body>
</html>