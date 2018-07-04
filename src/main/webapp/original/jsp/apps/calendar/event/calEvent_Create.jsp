<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%-- <%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %> --%>
<%@ include file="/WEB-INF/jsp/project/project_select.js.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('calendar.event.search.title')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/calendar/js/calEvent_Create.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var obj=new Object();
		obj["id"]="projectID";
		//如果请求是从关联项目空间发送来的,则不隐藏
		if("${isProjectSpace}"!=1){
			obj["style"]="display:none";
		}
		//新增
		<c:if test="${calEventInfoBO.calEvent.shareType!=3}">
			initProjectSelect(obj,"projectNew");
		</c:if>
		//修改
		<c:if test="${calEventInfoBO.calEvent.shareType==3}">
			initProjectSelect(obj,"projectNew","${relateProjectId}");
		</c:if>
		//修改置灰
		<!--用于在查看的时候显示项目名称  bug OA-50297 项目相关人员查看项目事件详情，项目输入框中未显示项目名 start-->
        <c:if test="${calEventInfoBO.calEvent.shareType==3&&calEventInfoBO.calEvent.id!=-1}">
        	obj=new Object();
			obj["id"]="projectText";
			obj["disabled"]="disabled";
			obj["class"]="w100b";
        	initModify(obj,"projectModify","${relateProjectId}");
        </c:if>
	})
</script>
</head>
<body class="dialog_bg over_auto_hiddenX w100b h100b" style="_width:100%;" onLoad="loadData(${calEventInfoBO.calEvent.shareType },${calEventInfoBO.calEvent.id});">
  <div id="colorgray" >
  <div class="form_area margin_10" style="_margin: 0; _padding: 10px 20px 10px 10px">
    <form id="createCalEvent" action="calEvent.do?method=saveCalEvent" method="post">
      <div id="domaincalEvent">
          <input type="hidden" id="periodicalType" name="periodicalType" value="${calEventInfoBO.calEventPeriodicalInfo.periodicalType }" /> 
          <input type="hidden" id="dayDate" name="dayDate" value="${calEventInfoBO.calEventPeriodicalInfo.dayDate }" /> 
          <input type="hidden" id="dayWeek" name="dayWeek" value="${calEventInfoBO.calEventPeriodicalInfo.dayWeek }" /> 
          <input type="hidden" id="week" name="week" value="${calEventInfoBO.calEventPeriodicalInfo.week }" /> 
          <input type="hidden" id="month" name="month" value="${calEventInfoBO.calEventPeriodicalInfo.month }" />
          <input type="hidden" id="weeks" name="weeks" value="${calEventInfoBO.calEventPeriodicalInfo.weeks }" /> 
          <input type="hidden" id="beginTime" name="beginTime" value="${ctp:formatDate(calEventInfoBO.calEventPeriodicalInfo.beginTime) }" />
          <input type="hidden" id="endTime" name="endTime" value="${ctp:formatDate(calEventInfoBO.calEventPeriodicalInfo.endTime) }" />
          <input type="hidden" id="workType" name="workType" value="${calEventInfoBO.calEvent.workType}" /> 
          <input type="hidden" id="realEstimateTime" name="realEstimateTime" value="${calEventInfoBO.calEvent.realEstimateTime}" /> 
          <input type="hidden" id="swithMonth" name="swithMonth" value="${calEventInfoBO.calEventPeriodicalInfo.swithMonth}" /> 
          <input type="hidden" id="swithYear" name="swithYear"  value="${calEventInfoBO.calEventPeriodicalInfo.swithYear}" />
          <input type="hidden" id="updateTip" name="updateTip" value="0" />
          <input type="hidden" id="calEventID" name="calEventID" value="${calEventInfoBO.calEvent.id}" /> 
          <input type="hidden" id="isSearch" name="isSearch" value="-1" />
          <input type="hidden" name="isEntrust" id="isEntrust" value="${calEventInfoBO.calEvent.isEntrust }" /> 
          <input type="hidden" name="fromType" id="fromType"   value="${calEventInfoBO.calEvent.fromType }" /> 
          <input type="hidden" name="fromId" id="fromId" value="${calEventInfoBO.calEvent.fromId }" />
          <input type="hidden" name="periodicalChildId" id="periodicalChildId" value="${calEventInfoBO.calEvent.periodicalChildId }" />
          <input type="hidden" name="fromRecordId" id="fromRecordId" value="${calEventInfoBO.calEvent.fromRecordId }" />
          <input type="hidden" id="isG6Version" name="isG6Version" value="${empty isG6Version ? 0 : isG6Version }" />
          <input type="hidden" id="repeat_title" name="repeat_title" value="${ctp:toHTMLWithoutSpace(calEventInfoBO.calEvent.subject)}" />
        <table border=0 cellSpacing=0 cellPadding=0 align=center width="100%" style="table-layout: fixed;">
            <tr>
                <th nowrap="nowrap" width="95px"><label class=margin_r_5><font color="red">*</font>${ctp:i18n('calendar.event.create.subject')}:</label></th>
                <td colspan="3" class=margin_r_5>
                  <DIV id="subjectDIV" class="common_txtbox_wrap <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>">
                    <input id="subject" value="${ctp:toHTMLWithoutSpace(calEventInfoBO.calEvent.subject)}"
                      type="text" name="subject" class="validate"
                      validate='type:"string",name:"${ctp:i18n('calendar.event.create.subject')}",notNullWithoutTrim:true,maxLength:50'
                      <c:if test='${calEventInfoBO.calEvent.id!=-1}'> 
                        disabled </c:if> onDblClick="javascript:void(0);"/>
                  </DIV>
                </td>
            </tr>
        </table>
        <table border=0 cellSpacing=0 cellPadding=0 align=center width="100%" style="table-layout: fixed;">
            <tr>
                <th nowrap="nowrap" width="95px"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.calEventType')}:</LABEL></th>
                <td>
                  <DIV class=common_selectbox_wrap>
                      <c:if test='${calEventInfoBO.calEvent.id!=-1}'>  
                    	<select id="calEventType" style="font-size:12px;" defaultValue='${calEventInfoBO.calEvent.calEventType }' disabled  name="calEventType" class="codecfg" codecfg="codeId:'cal_event_type',query:'true',defaultValue:${calEventInfoBO.calEvent.calEventType }"> 
	                    </select>
                      </c:if>
                      <c:if test='${calEventInfoBO.calEvent.id==-1}'>  
                    	<select id="calEventType" style="font-size:12px;" defaultValue='${calEventInfoBO.calEvent.calEventType }'   name="calEventType" class="codecfg" codecfg="codeId:'cal_event_type',defaultValue:${calEventInfoBO.calEvent.calEventType }"> 
	                    </select>
                      </c:if>
                     
                  </DIV>
                </td>
                <TH nowrap="nowrap" width="75px"></TH>
                <td></td>
            </tr>
          <tr>
            <td width="100%" colspan="4"><hr /></td>
          </tr>

          <tr>
              <TH nowrap="nowrap" width="95px"><LABEL class=margin_r_5 for=text><span class="required">*</span>${ctp:i18n('calendar.event.create.beginDate')}:</LABEL></TH>
              <TD>
                  <div id="beginDateDIV" class="common_txtbox_wrap <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>">
                    <input onChange="doDate();" readonly 
                      id="beginDate" type="text" class="comp validate <c:if test='${calEventInfoBO.calEvent.id!=-1}'> color_gray2</c:if>"
                      validate='name:"${ctp:i18n('calendar.event.create.beginDate')}",notNull:true'
                      comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"
                      value="${ctp:formatDateByPattern(calEventInfoBO.calEvent.beginDate,'yyyy-MM-dd HH:mm')}" />
                  </div>
              </TD>
              <TH nowrap="nowrap" width="75px"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.signifyType')}:</LABEL></TH>
              <TD>
                <DIV class=common_selectbox_wrap>
                  <select style="font-size:12px;" 
                    <c:if test='${calEventInfoBO.calEvent.id!=-1}'> disabled </c:if>
                    id="signifyType" name="signifyType" class="codecfg"
                    codecfg="codeId:'cal_event_signifyType',defaultValue:${calEventInfoBO.calEvent.signifyType}">
                  </select>
                </DIV>
              </td>
          </tr>
          <tr>
              <TH nowrap="nowrap"><LABEL class=margin_r_5 for=text><span class="required">*</span>${ctp:i18n('calendar.event.create.endDate')}:</LABEL></TH>
              <TD><div id="endDateDIV" class="common_txtbox_wrap <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>">
                  <input onChange="doDate('endDate');"
                    value="${ctp:formatDateByPattern(calEventInfoBO.calEvent.endDate,'yyyy-MM-dd HH:mm')}"
                    id="endDate" readonly
                    type="text" class="comp validate <c:if test='${calEventInfoBO.calEvent.id!=-1}'> color_gray2</c:if>" validate='name:"${ctp:i18n('calendar.event.create.endDate')}",notNull:true'
                    comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" />
                </div></TD>
              <TH nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.states')}:</LABEL></TH>
              <TD>
                <DIV class=common_selectbox_wrap>
                  <select style="font-size:12px;" 
                    <c:if test='${calEventInfoBO.calEvent.id!=-1}'> disabled </c:if>
                    id="states" name="states" class="codecfg" onChange="statesChoice(this);"
                    codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum',defaultValue:${calEventInfoBO.calEvent.states }">
                  </select>
                </DIV>
              </td>
          </tr>

          <tr>
              <TH nowrap="nowrap" class="margin_r_5"><LABEL class=margin_r_5 for=text>${ctp:i18n('calendar.event.create.alarmFlag')}:</LABEL></TH>
              <TD>
                <DIV class=common_selectbox_wrap>
                  <select
                    <c:if test='${calEventInfoBO.calEvent.id!=-1}'> disabled </c:if>
                    id="alarmDate" name="alarmDate" class="codecfg"
                    codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.AlarmDateEnum',defaultValue:${calEventInfoBO.calEvent.alarmDate }">
                    ${calEventInfoBO.calEvent.alarmDate }
                  </select>
                </DIV>
              </td>
              <TH nowrap="nowrap"><LABEL class="margin_r_5" for=text>${ctp:i18n('calendar.event.create.completeRate')}:</LABEL></TH>
              <TD><label class="right valign_m margin_t_5 margin_l_5">%</label>
                <DIV id="completeRateDIV" class="common_txtbox_wrap <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>" style="width:85%">
                  <input class="validate"
                    validate='type:"number",name:"${ctp:i18n('calendar.event.create.completeRate')}",notNull:true,minValue:0,maxValue:100,isInteger:true'
                    <c:if test='${calEventInfoBO.calEvent.id!=-1}'> 
                      disabled </c:if>
                    type="text" name="completeRate" id="completeRate"
                    value="${calEventInfoBO.completeRate }" />
                </DIV></TD>
          </tr>
            <tr>
              <TH nowrap="nowrap" class="margin_r_5"><LABEL class=margin_r_5 for=text>${ctp:i18n('calendar.event.create.alarmFlag.beforend')}:</LABEL></TH>
              <TD>
                <DIV class=common_selectbox_wrap>
                  <select
                    <c:if test='${calEventInfoBO.calEvent.id!=-1}'> 
                      disabled </c:if>
                    id="beforendAlarm" name="beforendAlarm" class="codecfg"
                    codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.AlarmDateEnum',defaultValue:${calEventInfoBO.calEvent.beforendAlarm }">
                  </select>
                </DIV>
              </td>
  
              <TD align="left" class="margin_r_5 padding_l_20" colspan="2"><c:if
                  test='${calEventInfoBO.calEvent.id!=-1}'>
                  <A style="_width: auto" id="advancedSettings"
                    class="common_button common_button_disable">${ctp:i18n('calendar.event.create.state.title')}</A>
                </c:if> <c:if test="${calEventInfoBO.calEvent.id==-1}">
                  <A style="_width: auto" class="common_button common_button_gray"
                    href="javascript:toEventState();">${ctp:i18n('calendar.event.create.state.title')}</A>
                </c:if></TD>
            </tr>
            <tr>
              <td width="100%" colspan="4"><hr/></td>
            </tr>
            <tr>
              <th nowrap="nowrap" width="95px"><lable class=margin_r_5 for=text>${ctp:i18n('calendar.event.create.shareType')}:</lable></th>
  
              <td>
                <DIV class=common_selectbox_wrap>
                    <select style="font-size:12px;" <c:if test='${calEventInfoBO.calEvent.id!=-1}'> disabled </c:if>
                      id="shareType" name="shareType" class="codecfg" onChange="choice(this);" codecfg="codeType:'java',codeId:'com.seeyon.apps.calendar.enums.ShareTypeEnum$ShareTypeCode',defaultValue:${calEventInfoBO.calEvent.shareType }"></select>
                </DIV>
              </td>
  
              <TD align="left" colspan="2" class="padding_l_20">
                <!-- 部门-->
                <div id="shareType2" class="common_txtbox_wrap hidden <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>">
                      <input type="text" class="hand w100b" name="shareTargetDep" style="font-size:12px;" onFocus="selectPerson('shareTargetDep');"
                        <c:if test="${calEventInfoBO.calEvent.id==-1}"> value="${ctp:i18n('calendar.event.create.department')}"	</c:if>
                        <c:if test="${calEventInfoBO.calEvent.id!=-1}"> value="${calEventInfoBO.calEvent.shareTarget}" disabled </c:if> id="shareTargetDep" /> 
                       <input type="hidden" value="<c:if test='${calEventInfoBO.calEvent.shareType==2}'>${calEventInfoBO.calEvent.tranMemberIds }</c:if>" name="tranMemberIdsDep" id="tranMemberIdsDep" />
                </div> <!-- 项目 -->
                <div id="shareType3" class="common_selectbox_wrap hidden">
                	  <div id="projectNew"></div>
                	  <div id="projectModify"></div>
                </div> <!-- 公开给他人-->
                <div id="shareType4" class="common_txtbox_wrap hidden <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>">
                      <input type="text" class="hand w100b" name="shareTargetOther" style="font-size:12px;" onFocus="selectPerson('tranMemberIdsOther');" id="shareTargetOther"
                          <c:if test="${calEventInfoBO.calEvent.id==-1}">value="${ctp:i18n('calendar.event.create.publicToOther')}"	</c:if>
                          <c:if test="${calEventInfoBO.calEvent.id!=-1}">value="${calEventInfoBO.calEvent.shareTarget}"	disabled</c:if> />
                      <input value="<c:if test='${calEventInfoBO.calEvent.shareType==4 || calEventInfoBO.calEvent.shareType==8}'>${calEventInfoBO.calEvent.tranMemberIds }</c:if>" type="hidden" name="tranMemberIdsOther" id="tranMemberIdsOther" />
                </div>
              </TD>
            </tr>
            <tr>
                <th nowrap="nowrap" width="95px">
                    <c:if test="${calEventInfoBO.calEvent.isEntrust == 1}"><lable class=margin_r_5 for=text>${ctp:i18n('calendar.event.list.cancel.event.authorized.person')}:</lable></c:if> 
                    <c:if test="${calEventInfoBO.calEvent.isEntrust != 1}"><lable class=margin_r_5 for=text>${ctp:i18n('calendar.event.create.arrangement.other')}:</lable></c:if>
                </th>
                <td width="100%" colspan="3">
                    <DIV id="otherDIV" class="common_txtbox_wrap <c:if test='${calEventInfoBO.calEvent.id!=-1}'>common_txtbox_wrap_dis</c:if>">
                      <input class="hand" style="font-size:12px;" <c:if test='${calEventInfoBO.calEvent.id!=-1}'>disabled </c:if> id="other" name="other" type="text"
                            <c:if test="${calEventInfoBO.calEvent.id==-1}">
      				              <c:if test="${calEventInfoBO.calEvent.receiveMemberId==null}"> value="${ctp:i18n('calendar.event.create.person')}"</c:if>
                                    <c:if test="${calEventInfoBO.calEvent.receiveMemberId!=null}"> value="${calEventInfoBO.calEvent.receiveMemberName}" disabled </c:if>
                            </c:if>
                            <c:if test="${calEventInfoBO.calEvent.id!=-1}">value="${calEventInfoBO.calEvent.receiveMemberName}"</c:if>
                            onclick="selectPerson('otherID');" />
                       <input type="hidden" name="otherID" id="otherID" value="${calEventInfoBO.calEvent.receiveMemberId}" />
                    </DIV>
                </td>
            </tr>
            <tr>
                <td width="100%" colspan="4"><hr /></td>
            </tr>
            <tr>
                <td width="100%" colspan="1" nowrap="nowrap">
                <div class="align_right">
                    <label class=margin_r_10>${ctp:i18n('calendar.event.create.content')}</label>
                </div>
                </td>
            </tr>
            <tr>
                <td width="100%" colspan="4">
                      <textarea id="content" name="content" class="validate w100b margin_tb_5" style="font-size:12px;resize: none;max-height:98px;_margin-top:4px;_margin-bottom:4px;" validate='type:"string",name:"${ctp:i18n('calendar.event.create.content')}",notNull:false,minLength:0,maxLength:300'
                           <c:if test='${calEventInfoBO.calEvent.id!=-1}'> readonly </c:if>
                      rows="5">${v3x:toHTMLAlt(calEventInfoBO.calContent.content)}</textarea>
                </td>
            </tr>
            <tr>
                <c:if test="${calEventInfoBO.calEvent.fromType==1}">
                    <tr><td>&nbsp</td></tr>
                    <td width="100%" colspan="1">
                        <div class="align_right">
                        <lable class=margin_r_5 for=text>${ctp:i18n("calendar.event.create.project")}:</lable>                       
                        </div>                  
                        <td width="100%" colspan="3">
                        <c:if test="${calEventInfoBO.hasDeleteAffair=='yes' }">(${ctp:i18n("calendar.event.create.affair.delete")})</c:if>
                        <c:if test="${calEventInfoBO.hasDeleteAffair=='cancelAgent' }">(${ctp:i18n("calendar.event.create.affair.agent")})</c:if>
                        <c:if test="${calEventInfoBO.hasDeleteAffair=='no' }">
                            ${ctp:i18n("calendar.arrangeTime.collaboration")}[<a href="javascript:showCollation();">${ctp:toHTMLWithoutSpace(showTitle)}</a>]
                        </c:if>
                        </td>
                        
                    </td>
                </c:if>                
                <c:if test="${isEdoc == '1'}">
                    <tr><td>&nbsp</td></tr>
                    <td width="100%" colspan="1">
                        <div class="align_right">
                        <lable class=margin_r_5 for=text>${ctp:i18n("calendar.event.create.project")}:</lable>                       
                        </div>                  
                        <td width="100%" colspan="3">
                        <c:if test="${calEventInfoBO.hasDeleteAffair=='yes' }">(${ctp:i18n("calendar.event.create.edoc.delete")})</c:if>
                        <c:if test="${calEventInfoBO.hasDeleteAffair=='cancelAgent' }">(${ctp:i18n("calendar.event.create.edoc.agent")})</c:if>
                        <c:if test="${calEventInfoBO.hasDeleteAffair=='no' }">
                            ${ctp:i18n("section.app.edoc.label")}[<a href="javascript:showEdoc();">${showTitle}</a>]    
                        </c:if>
                        </td>
                    </td>
                 </c:if>
                 <c:if test="${calEventInfoBO.calEvent.fromType==5 }">
                     <tr><td>&nbsp</td></tr>
                     <td width="100%" colspan="1"> 
                         <div class="align_right">
                         <lable class=margin_r_5 for=text>${ctp:i18n("calendar.event.create.plan")}:</lable>                         
                         </div>                        
                          <td width="100%" colspan="3">
                          <c:if test="${calEventInfoBO.hasDeletePlan=='yes' }">(${ctp:i18n("calendar.event.create.plan.delete")})</c:if>
                          <c:if test="${calEventInfoBO.hasDeletePlan=='no' }">
                             ${ctp:i18n("calendar.arrangeTime.plan")}[<a href="javascript:showPlan();">${ctp:toHTMLWithoutSpace(calEventInfoBO.plan.title)}</a>]
                          </c:if>
                          </td>
                      </td>
                  </c:if>
            </tr>
            <tr><td>&nbsp</td></tr>
      		<tr>
      			<td width="100%" colspan="4">
                  <style>
                        #attachmentArea,#attachment2Areaposition1{
                          padding-left: 120px;
                          margin-top: -26px;
                          clear: both;
                          float: left;
                        }
                  </style>  
                  <div id="attarea1">
                    <a id="attaDiv2" href="javascript:void(0)" class="common_button" style="cursor: pointer;margin-right: 5px"><span class="ico16 affix_16"></span>${ctp:i18n("permission.operation.UploadAttachment")}(<span id="attachmentNumberDiv">0</span>):</a>
                          <!-- OA-87558事件查看窗口显示两个插入关联文档两个插入附件 -->
                          <%-- <label class="color_gray2 margin_r_5 display_none" id="attaDiv2_noEdit"><span class="ico16 affix_16"></span>${ctp:i18n("common.toolbar.insertAttachment.label")}(<span id="attachmentNumberDiv_text">0</span>):</label> --%>
                  </div>    				
                	<div id="attachmentTR" style="display:none;"></div>
                    <div class="comp" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:true,originalAttsNeedClone:false,canFavourite:false" attsdata='${attachmentJSON}'></div>                       
      			</td>
      		</tr>
      		<tr><td>&nbsp</td></tr>
         	<tr>
         		<td width="100%" colspan="4">
                    <div id="docarea1">
                      <a id="docDiv2"  href="javascript:void(0)" class="common_button" style="margin-right: 5px"><span class="ico16 associated_document_16"></span>${ctp:i18n("permission.operation.UploadRelDoc")}(<span id="attachment2NumberDivposition1">0</span>):</a>
                      <!-- OA-87558事件查看窗口显示两个插入关联文档两个插入附件 -->
                      <%-- <label class="color_gray2 margin_r_5 display_none" id="docDiv2_noEdit"><span class="ico16 relate_file_16"></span>${ctp:i18n("common.toolbar.insert.mydocument.label")}(<span id="attachment2NumberDivposition1_text">0</span>):</label> --%>
                  </div>
                    <div class="comp" comp="type:'assdoc',applicationCategory:'30',canDeleteOriginalAtts:true,attachmentTrId:'position1', modids:'1,3,6'" attsdata='${attachmentJSON}'></div>
         		</td>
         	</tr>
        </table>
      </div>
    </form>
  </div>
  <div id="eventReply" class="form_area margin_10 <c:if test='${calEventInfoBO.calEvent.id==-1}'>div-float hidden</c:if> <c:if test='${calEventInfoBO.calEvent.shareType==1}'><c:if test='${calEventInfoBO.calEvent.receiveMemberId==null}'>div-float hidden</c:if></c:if>">
      <p class="margin_b_5">
          <a href="javascript:toReply('${calEventInfoBO.calEvent.id}');" class="right">[${ctp:i18n('calendar.event.create.reply')}]</a> 
          <a href="javascript:showAllReply('${calEventInfoBO.calEvent.id}');" class="right margin_r_5">[${ctp:i18n('calendar.event.create.reply.search.all')}]</a>
          &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp${ctp:i18n('calendar.event.create.reply.event')}${ctp:i18n('calendar.event.create.reply')}:
      </p>
      <ul border="1" id="replyInfo" name="replyInfo" class="w100b border_all" style="height: 100px; overflow: auto;">
          <c:forEach var="calReply" items="${calEventInfoBO.calReplies }">
              <li>
                  <p class="margin_5">
                    <a href="javascript:void(0)" style="cursor:default"> ${calReply.replyUserName}(${ctp:formatDateByPattern(calReply.replyDate,'MM-dd HH:mm')}) </a>
                  </p>
                  <div class="margin_l_10">${ctp:toHTML(calReply.replyInfo)}</div>
              </li>
          </c:forEach>
      </ul>
  </div>
  <div id="oaBtnDiv" class="margin_10 align_right"><!-- 精灵打开需要在页面添加操作按钮 -->
  	<span id="spanModify" class="display_none"><a id="btnmodify" class="common_button common_button_gray"   href="javascript:void(0)" onClick="OK('update')">${ctp:i18n('common.button.modify.label')}</a></span>
  	<span id="spanOk" class="display_none"><a id="btnok" class="common_button common_button_gray" href="javascript:void(0)" onClick="OK()">${ctp:i18n('common.button.ok.label')}</a></span>
    <span id="spanCancel" class="display_none"><a id="btncancel" class="common_button common_button_gray"  href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a></span>
  </div>
  <input type="hidden" id="objectFlag" name="objectFlag" value="${objectFlag}">
  <input type="hidden" id="cInfoShareType" name="cInfoShareType" value="${calEventInfoBO.calEvent.shareType}"/>
  <input type="hidden" id="cInfoReceiveMemberId" name="cInfoReceiveMemberId" value="${calEventInfoBO.calEvent.receiveMemberId}"/>
  <input type="hidden" id="cInfoTranMemberIds" name="cInfoTranMemberIds" value="${calEventInfoBO.calEvent.tranMemberIds}"/>
  <input type="hidden" id="cInfoFromType" name="cInfoFromType" value="${calEventInfoBO.calEvent.fromType}"/>
  <input type="hidden" id="cInfoId" name="cInfoId" value="${calEventInfoBO.calEvent.id}"/>
  <input type="hidden" id="cInfoPeriodicalStyle" name="cInfoPeriodicalStyle" value="${calEventInfoBO.calEvent.periodicalStyle}"/>
  <input type="hidden" id="cInfoEndtime" name="cInfoEndtime" value="${ctp:formatDate(calEventInfoBO.calEventPeriodicalInfo.endTime)}"/>
  <input type="hidden" id="currentUserId" name="currentUserId" value="${CurrentUser.id}"/>
  <input type="hidden" id="cInfoFromId" name="cInfoFromId" value="${calEventInfoBO.calEvent.fromId }"/>
  <input type="hidden" id="cInfoAffSubject" name="cInfoAffSubject" value="${ctp:toHTML(calEventInfoBO.ctpAffair.subject)}"/>
  <input type="hidden" id="ctpShowReceiveMemberId" name="ctpShowReceiveMemberId" value="${ctp:showOrgEntitiesOfTypeAndId(calEventInfoBO.calEvent.receiveMemberId, null)}"/>
  <input type="hidden" id="ctpParseReceiveMemberId" name="ctpParseReceiveMemberId" value="${ctp:parseElementsOfTypeAndId(calEventInfoBO.calEvent.receiveMemberId)}"/>
  <input type="hidden" id="ctpShowTranMemberIds" name="ctpShowTranMemberIds" value="${ctp:showOrgEntitiesOfTypeAndId(calEventInfoBO.calEvent.tranMemberIds, null)}"/>
  <input type="hidden" id="ctpParseTranMemberIds" name="ctpParseTranMemberIds" value="${ctp:parseElementsOfTypeAndId(calEventInfoBO.calEvent.tranMemberIds)}"/>
  <input type="hidden" id="calEventCreateUserId" name="calEventCreateUserId" value="${calEventInfoBO.calEvent.createUserId}"/>
</body>
<script type="text/javascript">
    $(document).ready(function (){
    	var itemId = "${calEventInfoBO.calEvent.id}";
        if (itemId != -1) {
            $(".attachment_block").find("span:last").hide();
        }
    });
</script>
</html> 