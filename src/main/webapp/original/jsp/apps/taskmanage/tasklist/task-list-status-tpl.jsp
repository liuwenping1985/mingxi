<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%-- 左侧状态栏模板 --%>
<script type="text/html" id="statusLeft-tpl">
<li class="item_all" statusvalue="-1" style="margin-top: 0px;"><span class="text"><c:choose><c:when test="${listType == 'Manage'}">${ctp:showMemberNameOnly(memberId)}</c:when><c:otherwise>${ctp:i18n("taskmanage.all")}</c:otherwise></c:choose></span><span class="number ">{{ d.all }}</span><em class=""></em></li>
<li class="" statusvalue="-2"><span class="text" title="${ctp:i18n('taskmanage.status.unfinished')}">${ctp:i18n('taskmanage.status.unfinished')}</span><span class="number ">{{ d.unfinished }}<em class=""></em></span></li>
<li class="" statusvalue="2"><span class="text"  title="${ctp:i18n('taskmanage.status.marching')}">${ctp:i18n('taskmanage.status.marching')}</span><span class="number ">{{ d.marching }}<em class=""></em></span></li>
<li class="" statusvalue="1"><span class="text"  title="${ctp:i18n('taskmanage.status.notstarted')}">${ctp:i18n('taskmanage.status.notstarted')}</span><span class="number ">{{ d.notstarted }}<em class=""></em></span></li>
<li class="" statusvalue="6"><span class="text"  title="${ctp:i18n('taskmanage.overdue.yes')}">${ctp:i18n('taskmanage.overdue.yes')}</span><span class="number color_red">{{ d.overdue }}<em class=""></em></span></li>
<li class="" statusvalue="4"><span class="text"  title="${ctp:i18n('taskmanage.status.finished')}">${ctp:i18n('taskmanage.status.finished')}</span><span class="number ">{{ d.finished }}<em class=""></em></span></li>
<li class="" statusvalue="5"><span class="text"  title="${ctp:i18n('taskmanage.status.canceled')}">${ctp:i18n('taskmanage.status.canceled')}</span><span class="number ">{{ d.canceled }}<em class=""></em></span></li>
</script>
<%-- 右侧任务模板 --%>
<script type="text/html" id="statusCenter-tpl">
<%-- 右侧任务模板 --%>
{{# for(var i = 0; i < d.list.length; i++){                                         }}
{{#    var t = d.list[i];                                                           }}
    <li task_id="{{t.id}}" is_overdue="{{t.overdue}}" class="list_item clearfix {{t.auth.canView ? "" : "li_noView" }} {{t.overdue ? 'li_equipment' : ''}} {{!t.auth.canUpdate && !t.auth.canDelete && !t.auth.canFeedback && !t.auth.canHasten ? 'li_noControl' : ''}}">
<%-- 任务名称 --%>
        <span class="projectName">
<%--任务名称-重要程度图标 --%>
{{#     if(t.importantLevel == 2){                                             }}
            <span class='ico16 important_16'></span>
{{#     }else if(t.importantLevel == 3){                                       }}
            <span class='ico16 much_important_16'></span>
{{#     }                                                                      }}
<%--任务名称-里程碑图标 --%>
{{#     if(t.milestone){                                                       }}
            <span class='ico16 milestone'></span>
{{#     }                                                                      }}
<%--任务名称-风险程度图标 --%>
{{#     if(t.riskLevel == 1){                                                  }}
            <span class='ico16 l_risk_16'></span>
{{#     }else if(t.riskLevel == 2){                                            }}
            <span class='ico16 risk_16'></span>
{{#     }else if(t.riskLevel == 3){                                            }}
            <span class='ico16 h_risk_16'></span>
{{#     }                                                                      }}
<%--任务名称--%>
        {{=t.subject}}
<%--任务名称-附件图标 --%>
{{#     if(t.hasAttachments){                                                  }}
            <span class='ico16 affix_16'></span>
{{#     }                                                                      }}
        </span>
<%--项目名称--%>
        <span id="projectName" class="projectType span_projectName"><a class="{{t.projectRoletypes ? 'noClick' : 'a_noEdit'}}" projectId="{{t.projectId ? t.projectId : ''}}">{{#if(t.projectName){ }} {{=t.projectName}} {{#}else{}}{{#}  }}</a></span>
<%--状态 --%>
        <span id="status_text" class="state" statusValue="{{t.status}}"><a class="noClick {{t.auth.canFeedback ? '' : 'a_noEdit'}}" title="{{t.statusName}}">{{t.statusName}}</a></span>
<%--完成率进度条--%>
        <span class="rate"><div class="rateProgress_box {{t.auth.canFeedback ? '' : 'a_noEdit'}}">
            <div class="
{{#           if(t.overdue){                                                 }}rateProgress_red
{{#           }else if(t.status == 4){                                         }}rateProgress_green
{{#           }else if(t.status == 5){                                         }}rateProgress_gray
{{#           }else{                                                           }}rateProgress_blue
{{#           }                                                                }}" style="width:{{parseInt(t.finishRate)}}%;">
            </div>
        </div></span>
<%--完成率--%>
        <span class="rateNumber">{{parseInt(t.finishRate)}}%</span>
<%--完成率编辑区--%>
{{#     if(t.auth.canFeedback && (t.status==1 || t.status==2 || t.status==4)){                }}
          <span class="rateNumber_input" id="finish_rate_input"><div class="rateNumber_error display_none" style="position: fixed;"><div><em class="rateNumber_error_arrow"></em><em class="ico16  stop_contract_16"></em>${ctp:i18n('taskmanage.input.tips') }</div></div><input class="noClick" type="text" min="0" max="100" value="{{parseInt(t.finishRate)}}" oldVal="{{parseInt(t.finishRate)}}" taskId="{{t.id}}" status={{t.status}}><span class="ie7style">%</span></span>
{{#     }                                                                      }}
<%--负责人 --%>
        <span class="people">{{t.managerNames}}</span>
<%--计划开始时间+计划结束时间 --%>
{{#     if(t.fullTime){                                                        }}
        <span class="right"><span class="time_start_1" style="width:75px">{{new Date(new Number(t.plannedStartTime)).format("yyyy-MM-dd") }}</span><span class="line">-</span><span class="time_end_1 {{t.overdue ? 'color_red' : ''}}"style="width:75px;">{{new Date(new Number(t.plannedEndTime)).format("yyyy-MM-dd") }}</span></span>
{{#     }else{                                                                 }}
        <span class="right"><span class="time_start_2" style="width:75px">{{new Date(new Number(t.plannedStartTime)).format("yyyy-MM-dd HH:mm")}}</span><span class="line">-</span><span class="time_end_2 {{t.overdue ? 'color_red' : ''}}"style="width:75px;">{{new Date(new Number(t.plannedEndTime)).format("yyyy-MM-dd HH:mm")}}</span></span>
{{#     }                                                                      }}
<%--操作按钮--%>
        <span class="operateBtn">
<%--操作按钮-催办 --%>
{{#          if(t.status != 4 && t.status != 5 && t.auth.canHasten){                                             }}
               <a id="hasten_btn" class="noClick">${ctp:i18n('taskmanage.toolbar.hasten.label') }</a>
{{#          }                                                                 }}
<%--操作按钮-汇报(开始+完成) --%>
{{#          if(t.auth.canFeedback){                                           }}
{{#             if(t.status == 1){                                             }}
                <a id="start_btn" class="noClick">${ctp:i18n('taskmanage.status.start') }</a>
{{#             }                                                              }}
{{#             if(t.status != 4 && t.status != 5){                            }}
                <a id="finish_btn" class="noClick">${ctp:i18n('taskmanage.toolbar.finish.label')}</a>
{{#             }                                                              }}
{{#          }                                                                 }}
<%--操作按钮-修改 --%>
{{#          if(t.auth.canUpdate){                                             }}
               <a id="edit_btn" class="noClick">${ctp:i18n('common.toolbar.edit.label') }</a>
{{#          }                                                                 }}
<%--操作按钮-删除 --%>
{{#          if(t.auth.canDelete){                                             }}
               <a id="delete_btn" class="noClick">${ctp:i18n('common.button.delete.label') }</a>
{{#          }                                                                 }}
            </span>
        </span>
</li>
{{# }                                                                          }}
</script>