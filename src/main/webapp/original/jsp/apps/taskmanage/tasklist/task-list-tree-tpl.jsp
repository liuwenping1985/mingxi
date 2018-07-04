<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%-- 任务树模板 --%>
<script type="text/html" id="task-view-tree-tpl">
        <div class="list_item clearfix {{d.overdue ? 'li_equipment' : ''}} {{d.auth.canView ? "" : "li_noView" }} li_noControl" task_id="{{d.id}}" is_overdue="{{d.overdue}}">
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
<%--项目名称|权重--%>
        <span id="projectName" class="projectType span_projectName">
{{#			if (d.logicalDepth == 1){											}}
				<a class="{{d.projectRoletypes ? 'noClick' : 'a_noEdit'}}" projectId="{{d.projectId ? d.projectId : ''}}">{{#if(d.projectName){ }} {{=d.projectName}} {{#}else{}}{{#}  }}</a>
{{#			}else if(d.weigthStr){															}}
			${ctp:i18n("taskmanage.weight")}{{d.weigthStr}}
{{#			}																	}}
		</span>
<%--状态 --%>
        <span id="status_text" class="state" statusValue="{{d.status}}"><a class="noClick {{d.auth.canFeedback ? '' : 'a_noEdit'}}" title="{{d.statusName}}">{{d.statusName}}</a></span>
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
        <span class="right"><span class="time_start_2" style="width:75px">{{new Date(new Number(d.plannedStartTime)).format("yyyy-MM-dd HH:mm")}}</span><span class="line">-</span><span class="time_end_2 {{d.overdue ? 'color_red' : ''}}"style="width:75px;">{{new Date(new Number(d.plannedEndTime)).format("yyyy-MM-dd HH:mm")}}</span></span>
{{#     }                                                                      }}
        </div>
    </script>