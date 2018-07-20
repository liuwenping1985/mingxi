<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<table id="infoPropertyTable">
<tr>
	<td rowspan="2" width="1%" nowrap="nowrap">
		<a id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn">${ctp:i18n('common.toolbar.send.label')}</a><!-- 发送 -->
	</td>

	<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.workflow.label')}：</th><!-- 流程 -->
	<td width="25%">
		<div class="common_txtbox_wrap <c:choose><c:when test="${subState eq '16'}">common_txtbox_wrap_dis</c:when></c:choose>">
            <input readonly="readonly" class="w100b validate" type="text" id="process_info"
                defaultValue="${ctp:i18n('collaboration.default.workflowInfo.value')}"
                <c:choose><c:when test="${subState eq '16' || orgnialTemplate}">disabled</c:when><c:otherwise>style="color: black;"</c:otherwise></c:choose>
                value="<c:out value='${contentContext.workflowNodesInfo}'></c:out>" name="process_info" title="${ctp:i18n('collaboration.newcoll.clickforprocess')}"/>
		</div>
	</td>
	<td width="5%">
		<div class="margin_l_5" id="workflowInfo">
			<c:if test="${subState ne '16'}">
				<a comp="type:'workflowEdit',defaultPolicyId:'shenhe',defaultPolicyName:'${ctp:i18n('infosend.magazine.label.audit')}',moduleType:'info',<c:if test="${orgnialTemplate}">isTemplate:true,</c:if><c:if test="${orgnialTemplate}">isView:true,</c:if>workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
					 class="common_button common_button_icon comp edit_flow" href="#">
					<em class="ico16 process_16"> </em><c:if test="${!orgnialTemplate}">${ctp:i18n('collaboration.newcoll.bjlc')}</c:if><c:if test="${orgnialTemplate}">${ctp:i18n('collaboration.newColl.findFlow')}</c:if></a><!-- 查看流程 -->
			</c:if>
			<c:if test="${subState eq '16'}">
				<a comp="type:'workflowEdit',defaultPolicyId:'shenhe',defaultPolicyName:'${ctp:i18n('infosend.magazine.label.audit')}',moduleType:'info',isTemplate:false,isView:true,workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}',caseId : '${contentContext.wfCaseId==null ? "-1" : contentContext.wfCaseId}'"
					class="common_button common_button_icon comp edit_flow" href="#">
					<em class="ico16 process_16"> </em>${ctp:i18n('collaboration.newColl.findFlow')}</a><!-- 查看流程 -->
         	</c:if>
  		</div>
   </td>

	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('collaboration.process.cycle.label') }：</th><!-- 流程期限 -->
	<td width="15%">
		<div class="common_selectbox_wrap margin_l_5">
             <select id="deadline" name="deadline"  ${summaryVO.summary.deadline ne '' && orgnialTemplate && orgnialTemplateHasDeadLine ? 'disabled=disabled' : "" }
                  class="codecfg" codecfg="codeId:'collaboration_deadline',defaultValue:'${summaryVO.summary.deadline }'">
              </select>
		</div>
	</td>

	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('collaboration.newcoll.tx') }</th><!-- 提醒 -->
	<td width="15%" class="padding_r_10">
		<div class="common_selectbox_wrap margin_l_5">
			<select id="advanceRemind" name="advanceRemind"  ${summaryVO.summary.advanceRemind ne '' && orgnialTemplate && orgnialTemplateHasRemind ? 'disabled=disabled' : "" }
                 class="codecfg" codecfg="codeId:'common_remind_time',defaultValue:'${summaryVO.summary.advanceRemind }'">
            </select>
		</div>
	</td>

</tr>

<tr>

	<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.govform.label') }：</th><!-- 报送单 -->
	<td width="30%" colspan="2">
		<div class="common_selectbox_wrap margin_l_5">
			<select id="formId" name="formId" ${orgnialTemplate ? 'disabled=disabled' : ''}>
				<c:forEach items="${formNameList }" var="formName">
				<option value="${formName.id }" ${(summaryVO.summary.formId==formName.id)?'selected':'' } title="${formName.name }">${formName.name }</option>
				</c:forEach>
			</select>
		</div>
	</td>

	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>
		<div class="common_checkbox_box margin_l_5">
			<label class="hand" for="canTrack">
             	<input id="canTrack" name="canTrack" value="1"  class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.gz')}</label>
		</div>
	</th>
	<td>
		<div class="common_checkbox_box clearfix ">
            <label class="margin_r_10 hand disabled_color" for="radioall">
                <input id="radioall" name="radioperson" value="0" type="radio"  disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.allpeople')}</label>
            <label class="margin_r_10 hand disabled_color" for="radiopart">
                <input id="radiopart" name="radioperson" value="0" type="radio" disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.spepeople')}</label>
                <input type="hidden" id="zdgzry" name="zdgzry"  />
                <input type="hidden" id="zdgzryName" name="zdgzryName" size="20" onclick="$('#radiopart').click()" />
        </div>
	</td>

	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.prep-pigeonhole.label')}：</th>
	<td class="padding_r_10">
		<div class="common_selectbox_wrap margin_l_5">
			<select id="colPigeonhole" class="w100b" onchange="pigeonholeEvent(this)"
		        ${archiveName ne null && archiveName ne '' && orgnialTemplate ? 'disabled=disabled' : "" }>
		        <option id="defaultOption" value="1">${ctp:i18n('collaboration.deadline.no')}</option>
                                  <!-- 请选择 -->
		        <option id="modifyOption" value="2">${ctp:i18n('collaboration.newColl.pleaseSelect')}</option>
		        <c:if test="${summaryVO.archiveName ne null && summaryVO.archiveName ne ''}" >
		    	    <option value="3" selected>${summaryVO.archiveName}</option>
		        </c:if>
		    </select>
		</div>
	</td>

</tr>


</table>
