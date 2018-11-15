<%--
/**
 * $Author: tanmf $
 * $Rev: 49750 $
 * $Date:: 2015-06-03 09:50:05#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<html>
<head>
<title>${ctp:i18n('selectPolicy.please.select')}</title>
<style type="text/css">
.toomore{
    width:230px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
</style>
</head>
<body onload="onLoadFunc()">
<div class="form_area align_center">
<form action="" name="selectPolicyForm" id ="selectPolicyForm">
<c:set var="isShowApplyToAll" value="${isShowApplyToAll eq 'true'}"/><%-- 是否显示'应用到所有' --%>
<c:set var="policyIdHtmlValue" value="${ctp:toHTML(policyId)}"></c:set>
<c:set var="policyIdHtmlValue_es" value="${policyId_es}"></c:set>
<c:set var="isCopyFrom" value="${param.copyFrom ne null && param.copyFrom ne '' && param.copyFrom ne 'null' &&  param.copyFrom ne 'undefined'}"/>
<c:set var="isCopyFromDisable" value="${isCopyFrom?'disabled':''}"/>
<c:if test="${!isShowMatchScope== true }">
<input type="hidden" id="defaultMatchScope"  name="matchScope" value="${matchScope}">
</c:if>
<input type="hidden" id="isProIncludeChild"  name="isProIncludeChild" value="${isProIncludeChild}">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="2" height="8" class="PopupTitle"></td>
	</tr>
	<tr>
	<td id="policyDiv" colspan="2" valign="top" style="padding:0 10px;">
		<div id="policyHTML">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <!-- 节点权限部分:开始 -->
			<tr>
				<td>
				<fieldset width="80%" align="center">
					<legend>${ctp:i18n('workflow.designer.node.property.setting')}</legend>
					<table align="center" width="100%" border="0">
    					<tr>
    						<td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.name.label')}:</td>
    						<td width="50%" align="left"><input style="width:197px" id="nodeNamee" name="nodeNamee" class="input-100per margin_l_5" readonly value="${ctp:toHTML(nodeName)}" title="${ctp:toHTML(nodeName)}"></td>
                            
                            <td align="right" width="22%" nowrap="nowrap"><c:if test="${'WFDynamicForm' eq partyType}"><a class="color_blue" href="#" title="${dyTitle}">[${ctp:i18n("workflow.label.fromDynamicForm")}<%-- 来自动态表 --%>]</a></c:if></td>
    					</tr>	
    					<tr>
    						<td width="28%" height="28" nowrap="nowrap" align="right">${ctp:i18n('workflow.designer.selectPolicy.please.select')}:</td>
    						<td  width="50%" height="28" nowrap="nowrap" align="left"><select style="width:200px" class="margin_l_5" onchange="disableORShow();changeIsDisplayStopNode(this);" name="policy" id="policy"  ${disable1}>
    					        <c:forEach items='${nodeAuthorityList}' var="nodePolicy" varStatus="num">
    					        	<option id="${nodePolicy.isEnabled == 0 and policyIdHtmlValue==nodePolicy.value ? 'stopNode' : ''}" value="${ctp:toHTML(nodePolicy.value)}" name="${ctp:toHTML(nodePolicy.name)}"  ${policyId==nodePolicy.value || (policyId==null && defaultPolicyId==nodePolicy.value)?"selected":"" }>${ctp:toHTML(nodePolicy.name)}</option>
    					        </c:forEach>
    				    	</select>
    			    		</td>
                            <td align="right" width="22%" nowrap="nowrap">
                            <c:if test="${disable2==true}">
                           		<a class="color_blue" href="#" onclick="${nodeType=='StartNode'?'':'policyExplain()' }" ${nodeType=='StartNode'?'disabled':'' } style="${nodeType=='StartNode'?'background: #ededed;color: #d2d2d2;cursor: default;':'' }text-decoration:none">
                                    [${ctp:i18n('workflow.designer.node.policy.explain')}]
                                </a> 
                            </c:if>
                            </td>
    			    	</tr>
					</table>
				</fieldset>
			  </td>
		  </tr>
          <!-- 节点权限部分:结束 -->
		  <tr height="10"><td colspan="3"></td></tr>
          <c:if test="${isShowNodeDeadLine == true }">
          <!-- 节点期限部分:开始-->
		  <tr>
			<td>
			<fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.limittime')}</legend>
			<table align="center" width="100%" border="0">
			   <tr>
				    <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.cycle.label')}:</td>
				    <td width="50%" height="28" colspan="2" align="left">
				    <select style="width:200px" id="dealTerm" name="dealTerm" ${disable0} onchange="doDealTermOnchange(this)" 
                            class="codecfg margin_l_5" codecfg="codeId:'collaboration_deadline',defaultValue:'${dealTerm==''?'0':dealTerm}'">
		    	     </select>
	    		    </td>
                    <td id="dealTermCustomArea" align="right" width="22%" nowrap="nowrap" style="display:none;">
                        <input value="${defaultDealTerm}" style="width:130px" id="customDealTerm" name="customDealTerm" readonly="readonly" ${disable0} type="text"  class="${disable0 eq 'disabled'?'':'comp'} input-100per margin_l_5" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,dateString:'${defaultDealTerm}'"/>
                    </td>
			   </tr>
			   <tr>
				    <td width="28%" height="28" nowrap align="right">${ctp:i18n('workflow.designer.node.advanceremindtime')}:</td>
				    <td width="50%" height="28" colspan="2"  align="left">
				    <select style="width:200px" name="remindTime" ${disable0} id="remindTime"  onchange="doDealRemindOnChange(this)"
                            class="codecfg margin_l_5" codecfg="codeId:'common_remind_time',defaultValue:'${remindTime=='-1' || remindTime==''?'0':remindTime}'">
		    	    </select>
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
			   </tr>
			   <tr id="dealTermTR">
				    <td width="28%" height="28" align="right" nowrap="nowrap">${ctp:i18n('workflow.designer.node.deadline.arrived')}:</td>
				    <td width="50%" height="28" nowrap="nowrap" colspan="2" align="left">
					<select onchange="doDealTermActionChange(this);" style="width:200px;" class="margin_l_5" name="dealTermAction" id="dealTermAction" ${disable0}>
						<option value="0" selected="selected">${ctp:i18n('workflow.designer.node.deadline.arrived.do0')}</option>
						<option value="1">${ctp:i18n('workflow.designer.node.deadline.arrived.do1')}</option>
						<option value="2">${ctp:i18n('workflow.designer.node.deadline.arrived.do2')}</option>
					</select>
                    </td>
                    <td align="left" width="22%" nowrap="nowrap">
	                    <input readonly onclick="selectPeopleForTheNode();" type="text" value="${ctp:i18n('workflow.designer.policy.people.select.tip')}" id="workflowInfo" name="workflowInfo"  class="hand;font_size12" style="width: 100px;display: none" ${disable0} />
					    <div id="workflowInfo_pepole_inputs" style="display: none"></div>
					</td>
				</tr>
				
				<tr id="cycleRemindTR" class="hidden">
				    <td width="28%" height="28" align="right" nowrap="nowrap"></td>
				    <td width="50%" height="28" nowrap="nowrap" colspan="2" align="left">
				    	<c:set value="${cycleRemindTime=='-1' || cycleRemindTime==''?'0':cycleRemindTime}" var="cycleRemindTimeValue" />
			    		<input id="cycleRemindChexkbox" type="checkbox" onClick="cycleRemindTimeClkFun()" style="valign:middle;" /> ${ctp:i18n('node.policy.cycle.remind.set.pre')}
			    		<select id="cycleRemindTime" name="cycleRemindTime" onChange="cycleRemindTimeChgFun()" lastValue="${cycleRemindTimeValue }" class="codecfg margin_l_5" codecfg="codeId:'common_remind_time',defaultValue:'${cycleRemindTimeValue}'"></select>
			    		${ctp:i18n('node.policy.cycle.remind.set.end')}
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
				</td>
				</tr>
				
				<tr height="5"><td colspan="3"></td></tr>
			</table>
			</fieldset>
		  </td>
		</tr>
        <!-- 节点期限部分:结束-->
       </c:if>
       <!-- 执行模式部分:开始  -->
	   <c:if test="${flag1==true}"><!-- 非模版流程 -->
		 <tr height="10"><td></td></tr>
		 <tr id="disableORShow" class="hidden">
			<td>
			 <fieldset width="80%" align="center">
			    <legend>${ctp:i18n('workflow.designer.node.process.mode')}</legend>
				  <table align="center">
					<tr>
						<td height="28" colspan="2">
						<c:if test="${processMode=='single'}">
							<label for="single_mode">
								<input type="radio" name="node_process_mode" id="single_mode" value="single" ${processModeDisable} ${processModeDisableClass} ${singleChecked} ${isCopyFromDisable} >
								${ctp:i18n('workflow.commonpage.processmode.single')}
							</label>
						</c:if>
						<c:if test="${processMode=='multiple'}">
							<label for="multiple_mode">
								<input type="radio" name="node_process_mode" id="multiple_mode" value="multiple" ${processModeDisable} ${processModeDisableClass} ${multipleChecked} ${isCopyFromDisable}>
								${ctp:i18n('workflow.commonpage.processmode.multiple')}
							</label>
						</c:if>
						<label for="all_mode">
							<input type="radio" name="node_process_mode" id="all_mode" value="all" ${processModeDisable} ${processModeDisableClass} ${allChecked} ${isCopyFromDisable}>
							${ctp:i18n('workflow.commonpage.processmode.all')}
						</label>
						<label for="competition_mode">	
							<input type="radio" name="node_process_mode" id="competition_mode" value="competition" ${processModeDisable} ${processModeDisableClass}  ${competitionChecked} ${isCopyFromDisable}>
							${ctp:i18n('workflow.commonpage.processmode.competition')}
						</label>
						</td>
					</tr>
				  </table>
			</fieldset>
		   </td>
		  </tr>				
		</c:if>
		<c:if test="${flag2== true}"><!-- 模版流程 -->
<c:choose>
	<c:when test="${'start' != nodeId}">
		<tr height="10"><td></td></tr>	
		  <tr>
			<td>
			   <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.process.mode')}</legend>
			   <table align="center">
				 <tr>
					<td height="28" colspan="2">
					<label for="single_mode">
  					    <input type="radio" name="node_process_mode" id="single_mode" value="single" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable} checked>
                        ${ctp:i18n('workflow.commonpage.processmode.single')}
					</label>
					<label for="multiple_mode">
						<input type="radio" name="node_process_mode" id="multiple_mode" value="multiple" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable}>
						${ctp:i18n('workflow.commonpage.processmode.multiple')}
					</label>
					<label for="all_mode">
						<input type="radio" name="node_process_mode" id="all_mode" value="all" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable}>
						${ctp:i18n('workflow.commonpage.processmode.all')}
					</label>
					<label for="competition_mode">	
						<input type="radio" name="node_process_mode" id="competition_mode" value="competition" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable}>
						${ctp:i18n('workflow.commonpage.processmode.competition')}
					</label>
				    </td>
				 </tr>
			    </table>
			    </fieldset>
				</td>
			</tr>
	</c:when>
	<c:otherwise>
		<tr height="10" style="display:none;"><td></td></tr>	
		  <tr style="display:none;">
			<td>
			   <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.process.mode')}</legend>
			   <table align="center">
				 <tr>
					<td height="28" colspan="2">
					<label for="single_mode">
  					    <input type="radio" name="node_process_mode" id="single_mode" value="single" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable} checked>
                        ${ctp:i18n('workflow.commonpage.processmode.single')}
					</label>
					<label for="multiple_mode">
						<input type="radio" name="node_process_mode" id="multiple_mode" value="multiple" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable}>
						${ctp:i18n('workflow.commonpage.processmode.multiple')}
					</label>
					<label for="all_mode">
						<input type="radio" name="node_process_mode" id="all_mode" value="all" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable}>
						${ctp:i18n('workflow.commonpage.processmode.all')}
					</label>
					<label for="competition_mode">	
						<input type="radio" name="node_process_mode" id="competition_mode" value="competition" ${processModeDisable} ${processModeDisableClass} ${isCopyFromDisable}>
						${ctp:i18n('workflow.commonpage.processmode.competition')}
					</label>
				    </td>
				 </tr>
			    </table>
			    </fieldset>
				</td>
			</tr>
	</c:otherwise>
</c:choose>
		  </c:if>
          <!-- 执行模式部分:结束  -->
		  <!-- 匹配范围部分:开始  -->
          <c:choose>
            <%--岗位匹配范围 --%>
            <c:when test="${isShowMatchScope}">
                <tr height="10"><td></td></tr>
                <tr>
               <td>
               <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.matchScope.node')}</legend>
               <table align="center" border="0" width="100%">
               <c:choose>
               <%-- 设置岗位第一行的rowSpan --%>
                   <c:when test="${isFormTemplate == true && isFormAdvanced==true}">
                      <c:set var="postRowSpan" value="4" />
                   </c:when>
                   <c:otherwise>
                   <c:set var="postRowSpan" value="3" />
                   </c:otherwise>
                 </c:choose>
                 <c:choose>
                  <%-- 集团标准岗 --%>
                  <c:when test="${isRootPost && isGroupVersion}">
                  <tr>
                           <td rowspan="${postRowSpan}" valign="top" width="20%" style="line-height: 28px;" nowrap="nowrap" align="right">
                          ${ctp:i18n('workflow.designer.node.matchScope')}:
                          </td> 
                      <td colspan="2">
                        <table width="100%">
                            <tr>
                                <td height="28px" align="left">
                                <label for="matchScope2">
                                <input type="radio" name="matchScope" onclick="disableFormFieldValue('true');hiddenDepartmentPostAutoUpIdLabel();"  id="matchScope2" value="2" ${matchScope2Checked} ${isCopyFromDisable}>
                                <c:set var="productFlagLabel" value="workflow.designer.node.matchScope.2${ctp:suffix()}" /><%--产品标志，例如政务版本为.GOV --%>
                                ${ctp:i18n(productFlagLabel)}
                                </label>
                                </td>
                                <td height="28" align="left">
                                <label for="matchScope5">
                                <input type="radio" name="matchScope" onclick="disableFormFieldValue('true');hiddenDepartmentPostAutoUpIdLabel();"   id="matchScope5" value="5" ${matchScope5Checked} ${isCopyFromDisable}>
                                ${ctp:i18n('workflow.designer.node.matchScope.5')}
                                </label>
                                </td>
                                <td height="28" align="left">
                                <label for="matchScope1">
                                <input type="radio" name="matchScope" onclick="disableFormFieldValue('true');hiddenDepartmentPostAutoUpIdLabel();"   id="matchScope1" value="1" ${matchScope1Checked} ${isCopyFromDisable}>
                                ${ctp:i18n('workflow.designer.node.matchScope.1')}
                                </label>
                                </td>
                            </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td height="28" colspan="2" align="left">
                       <label>
                       <input type="radio" onclick="disableFormFieldValue('true');showDepartmentPostAutoUpIdLabel('NoSub');" name="matchScope" id="matchScope3NoSub" value="6" ${matchScope3NoSubChecked} ${isCopyFromDisable}>
                       ${ctp:i18n('workflow.designer.node.matchScope.6')}
                       </label>
                       <label id="departmentPostAutoUpIdLabelNoSub" style="display: ${matchScope3NoSubChecked=='checked'?'':'none'}">
                            <input onclick="clickDeptPostAutoUp(this)" ${isCopyFromDisable} type="checkbox"  ${pup=='1'|| pup=='-1' || pup=='null'?'checked':''}  name="departmentPostAutoUpIdNoSub" id="departmentPostAutoUpIdNoSub">${ctp:i18n('workflow.designer.node.role.autoup.label')}
                       </label>
                     </td>
                    </tr>
                    <tr>
                      <td height="28" colspan="2" align="left">
                       <label for="matchScope3">
                       <input type="radio" onclick="disableFormFieldValue('true');showDepartmentPostAutoUpIdLabel();" name="matchScope" id="matchScope3" value="3" ${matchScope3Checked} ${isCopyFromDisable}>
                       ${ctp:i18n('workflow.designer.node.matchScope.3')}
                       </label>
                       <label for="departmentPostAutoUpId"  id="departmentPostAutoUpIdLabel" style="display: ${matchScope3Checked=='checked'?'':'none'}">
                            <input onclick="clickDeptPostAutoUp(this)" ${isCopyFromDisable} type="checkbox"  ${pup=='1'|| pup=='-1' || pup=='null'?'checked':''}  name="departmentPostAutoUpId" id="departmentPostAutoUpId">${ctp:i18n('workflow.designer.node.role.autoup.label')}
                       </label>
                     </td>
                    </tr>
                    <c:if test="${isFormTemplate == true && isFormAdvanced==true}">
                     <tr>
                       <td nowrap="nowrap"  align="left" width="50%">
                         <label for="matchScope4">
                         <input type="radio" name="matchScope" onclick="disableFormFieldValue('false');hiddenDepartmentPostAutoUpIdLabel();" id="matchScope4" value="4" ${matchScope4Checked} ${isCopyFromDisable}>
                         ${ctp:i18n('workflow.designer.node.matchScope.4')}
                         </label>
                         <select id="formFieldValue" name="formFieldValue" disabled="disabled" style="width:100px;"  onchange="isIncludeChildDepartment(this)" ${isCopyFromDisable}>
                         <option value="">--${ctp:i18n('workflow.designer.node.matchScope.4.A')}--</option>
                         ${formFieldString}
                         </select>
                        </td>
                        <td align="left" id="isIncludeChildInfo" width="30%" nowrap="nowrap"></td>
                     </tr>
                    </c:if>
                  </c:when>
                  <%--vjoin外部人员岗位 --%>
                  <c:when test="${vjoin=='1' }">
	                  <tr>
	                      <td rowspan="${postRowSpan-1}" valign="top" width="20%" style="line-height: 28px;" nowrap="nowrap" align="right">
	                          ${ctp:i18n('workflow.designer.node.matchScope')}:
	                          </td> 
	                      <td height="28px"  align="left" colspan="2">
	                      <label for="matchScope1"><input type="radio" onclick="disableFormFieldValue('true');"  name="matchScope" id="matchScope1" value="1" ${matchScope1AChecked} ${isCopyFromDisable}>
	                      	${ctp:i18n('workflow.designer.node.matchScope.1.A.vj')}
	                      </label>
	                      </td>
	                     </tr>
	                     <tr>
	                      <td height="28"  align="left" colspan="2">
	                       <label for="matchScope3">
	                       <input type="radio" onclick="disableFormFieldValue('true');" name="matchScope" id="matchScope3" value="3" ${matchScope3Checked} ${isCopyFromDisable}>
	                      	${ctp:i18n('workflow.designer.node.matchScope.3.vj')}
	                       </label>
	                      </td>
	                     </tr>
	                     <c:if test="${isFormTemplate == true && isFormAdvanced==true}">
	                     <c:set value="true" var="hasAccountPost4FormFiled"/>
	                     <tr>
	                       <td height="28"  align="left" colspan="1">
	                         <label for="matchScope4">
	                         <input type="radio" name="matchScope" onclick="disableFormFieldValue('false');" id="matchScope4" value="4" ${matchScope4Checked} ${isCopyFromDisable}>
	                         ${ctp:i18n('workflow.designer.node.matchScope.4')}
	                         </label>
	                         <select id="formFieldValue" name="formFieldValue" disabled="disabled" style="width:100px;"  onchange="isIncludeChildDepartment(this)" ${isCopyFromDisable}>
	                         <option value="">--${ctp:i18n('workflow.designer.node.matchScope.4.A')}--</option>
	                         ${formFieldString}
	                         </select>
	                        </td>
	                        <td align="left" id="isIncludeChildInfo" width="30%" nowrap="nowrap"></td>
	                     </tr>
	                    </c:if>
                  </c:when>
                  <%-- 单位岗 --%>
                  <c:otherwise>
                     <tr>
                        <td rowspan="${postRowSpan}" valign="top" width="20%" style="line-height: 28px;" nowrap="nowrap" align="right">
                          ${ctp:i18n('workflow.designer.node.matchScope')}:
                          </td> 
                      <td height="28px"  align="left" colspan="2">
                      <label for="matchScope1"><input type="radio" onclick="disableFormFieldValue('true');hiddenDepartmentPostAutoUpIdLabel();"  name="matchScope" id="matchScope1" value="1" ${matchScope1AChecked} ${isCopyFromDisable}>
                      ${ctp:i18n('workflow.designer.node.matchScope.1.A')}
                      </label>
                      </td>
                     </tr>
                     <tr>
                      <td height="28"  align="left" colspan="2">
                       <label>
                       <input type="radio" onclick="disableFormFieldValue('true');showDepartmentPostAutoUpIdLabel('NoSub');" name="matchScope" id="matchScope3NoSub" value="6" ${matchScope3NoSubChecked} ${isCopyFromDisable}>
                       ${ctp:i18n('workflow.designer.node.matchScope.6')}
                       </label>
                       <label id="departmentPostAutoUpIdLabelNoSub" style="display: ${matchScope3NoSubChecked=='checked'?'':'none'}">
                            <input onclick="clickDeptPostAutoUp(this)" ${isCopyFromDisable} type="checkbox"  ${pup=='1'|| pup=='-1' || pup=='null'?'checked':''}  name="departmentPostAutoUpIdNoSub" id="departmentPostAutoUpIdNoSub">${ctp:i18n('workflow.designer.node.role.autoup.label')}
                       </label>
                      </td>
                     </tr>
                     <tr>
                      <td height="28"  align="left" colspan="2">
                       <label for="matchScope3">
                       <input type="radio" onclick="disableFormFieldValue('true');showDepartmentPostAutoUpIdLabel();" name="matchScope" id="matchScope3" value="3" ${matchScope3Checked} ${isCopyFromDisable}>
                       ${ctp:i18n('workflow.designer.node.matchScope.3')}
                       </label>
                       <label for="departmentPostAutoUpId" id="departmentPostAutoUpIdLabel"  style="display: ${matchScope3Checked=='checked'?'':'none'}">
                            <input onclick="clickDeptPostAutoUp(this)" ${isCopyFromDisable} type="checkbox" ${pup=='1'|| pup=='-1' || pup=='null'?'checked':''} name="departmentPostAutoUpId" id="departmentPostAutoUpId">${ctp:i18n('workflow.designer.node.role.autoup.label')}
                       </label>
                      </td>
                     </tr>
                     <c:if test="${isFormTemplate == true && isFormAdvanced==true}">
                     <c:set value="true" var="hasAccountPost4FormFiled"/>
                     <tr>
                       <td height="28"  align="left" colspan="1">
                         <label for="matchScope4">
                         <input type="radio" name="matchScope" onclick="disableFormFieldValue('false');hiddenDepartmentPostAutoUpIdLabel();" id="matchScope4" value="4" ${matchScope4Checked} ${isCopyFromDisable}>
                         ${ctp:i18n('workflow.designer.node.matchScope.4')}
                         </label>
                         <select id="formFieldValue" name="formFieldValue" disabled="disabled" style="width:100px;"  onchange="isIncludeChildDepartment(this)" ${isCopyFromDisable}>
                         <option value="">--${ctp:i18n('workflow.designer.node.matchScope.4.A')}--</option>
                         ${formFieldString}
                         </select>
                        </td>
                        <td align="left" id="isIncludeChildInfo" width="30%" nowrap="nowrap"></td>
                     </tr>
                    </c:if>
                  </c:otherwise>
                 </c:choose>
                 <tr id="nouserActionTitle">
                        <td width="20%" height="28" align="right" valign="top" style="line-height: 26px;">${ctp:i18n('workflow.designer.node.nouser.action.label')}:</td>
                        <td width="80%" align="left">    
                        <select ${isCopyFromDisable}  ${disable0} style="width:200px" class="margin_l_5" name="nouserAction" id="nouserAction"  onchange="showNouserActionTitle(this);">
                            <%--弹选人界面 --%>
                            <option value="0" selected="selected">${ctp:i18n('workflow.designer.node.nouser.action.label0')}</option>
                            <%--自动跳过 --%>
                            <option value="2">${ctp:i18n('workflow.designer.node.nouser.action.label2')}</option>
                        </select>
                        <c:if test="${appName == 'collaboration' || appName == 'form'}">
	                        <div id="na_ignoreBlank" <c:if test="${appName !='form'}">style="display:none"</c:if> class="margin_l_5 margin_t_10 <c:if test="${na !='2'}">display_none</c:if>">
			                <label><input type="checkbox" <c:if test="${na_b =='1'}">disabled="disabled"</c:if> <c:if test="${na_i =='1'}">checked="checked"</c:if>  value="1" name="ignoreBlank"  id="ignoreBlank" ${matchScope4Checked} ${isCopyFromDisable}/>${ctp:i18n('workflow.node.ignoreBlank')}<!--忽略表单必填项--></label>
			                </div><div id="na_asBlankNode" class="margin_l_5 margin_t_10 <c:if test="${na !='2'}">display_none</c:if>">
			                <label><input type="checkbox" onclick="_checkNaAsBlankNode(this)" <c:if test="${na_b =='1'}">checked="checked"</c:if> value="1" name="asBlankNode"  id="asBlankNode" ${matchScope4Checked} ${isCopyFromDisable}/>${ctp:i18n('workflow.node.asBlankNode')}<!--视为空节点--></label>
			                </div>
		                </c:if>
                        </td>
                        <td nowrap="nowrap">
                        <a class="color_blue" href="#" onclick="showMatchScopeExplain(1)" style="text-decoration:none">
                        [${ctp:i18n("node.policy.match.scope.explain")}]
                        </a> 
                        </td>
                    </tr>
               </table>
              </fieldset> 
             </td>
           </tr>
            </c:when>
            <%--角色匹配范围 --%>
            <c:when test="${(partyType=='Node' || partyType=='Role') 
                        && partyId!='BlankNode' 
                        && partyId!='Sender' 
                        && partyId!='SenderDeptMember'
                        && partyId!='NodeUserDeptMember'
                        && fn:indexOf(partyId, 'SenderVjoin') eq -1
                        && fn:indexOf(partyId, 'NodeUserVjoin') eq -1
                        && fn:indexOf(partyId, 'SenderSVjoin') eq -1
                        && fn:indexOf(partyId, 'NodeUserSVjoin') eq -1
                        && partyId!='SenderSuperDeptDeptMember'
                        && partyId!='NodeUserSuperDeptDeptMember'  }">
              <tr height="10"><td></td></tr>
                <tr>
               <td>
               <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.matchScope.node')}</legend>
               <table align="center" border="0" width="100%">
              <c:if test="${isMatchup eq true}"><tr id="roleAutoUpMatchTr">
                <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.matchType')}:</td>
                <td width="72%" align="left" colspan="2">
                <label>
                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleAutoUpMatch" id="roleAutoUpMatch" 
                     ${(rup=='1'||rup=='-1' || rup=='null')?'checked':''}/><span id="roleAutoUpMatchSpan">${ctp:i18n('workflow.designer.node.role.autoup.label')}</span>
                </label>
                </td>
               </tr></c:if>
               <tr id="nouserActionTitle">
               <td width="20%" height="28" align="right" valign="top" style="line-height: 26px;">${ctp:i18n('workflow.designer.node.nouser.action.label')}:</td>
               <td width="80%" align="left">
               <select ${isCopyFromDisable}  ${disable0} style="width:200px" class="margin_l_5" name="nouserAction" id="nouserAction"  onchange="showNouserActionTitle(this);">
                    <%--弹选人界面 --%>
                    <option value="0" selected="selected">${ctp:i18n('workflow.designer.node.nouser.action.label0')}</option>
                    <%--自动跳过 --%>
                    <option value="2">${ctp:i18n('workflow.designer.node.nouser.action.label2')}</option>
                </select>
                <c:if test="${appName == 'collaboration' || appName == 'form'}">
	                <div id="na_ignoreBlank"  <c:if test="${appName !='form'}">style="display:none"</c:if>class="margin_l_5 margin_t_10 <c:if test="${na !='2'}">display_none</c:if>">
	                <label><input type="checkbox" <c:if test="${na_b =='1'}">disabled="disabled"</c:if> <c:if test="${na_i =='1'}">checked="checked"</c:if>  value="1" name="ignoreBlank"  id="ignoreBlank" ${matchScope4Checked} ${isCopyFromDisable}/>${ctp:i18n('workflow.node.ignoreBlank')}<!-- 忽略表单必填项 --></label>
	                </div><div id="na_asBlankNode" class="margin_l_5 margin_t_10 <c:if test="${na !='2'}">display_none</c:if>">
	                <label><input type="checkbox" onclick="_checkNaAsBlankNode(this)" <c:if test="${na_b =='1'}">checked="checked"</c:if> value="1" name="asBlankNode"  id="asBlankNode" ${matchScope4Checked} ${isCopyFromDisable}/>${ctp:i18n('workflow.node.asBlankNode')}<!--视为空节点--></label>
	                </div>
                </c:if>
               </td>
               <td nowrap="nowrap">
                <a class="color_blue"  href="#" onclick="showMatchScopeExplain(2)" style="text-decoration:none">
                [${ctp:i18n("node.policy.match.scope.explain")}]
                </a> 
                </td>
               </tr>
               
               
               <c:if test="${isShowRoleScope}">
               <c:set var="hasRoleMatchScope" value="true"/><%-- 标记有匹配范围选择 --%>
               <tr id="roleMatchScopeTr">
                <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.matchScope')}<!-- 匹配范围 -->:</td>
                <td width="72%" align="left" colspan="2">
                <label>
                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopeMainPostDept" 
                     <c:if test="${fn:contains(rScope,'1')}">checked</c:if> /><span id="roleMatchScopeMainPostDeptSpan">${isLeaderOrManager eq false ? ctp:i18n('org.member_form.departments.label') : ctp:i18n('workflow.branchGroup.1.1')}<%-- 所属部门/单位 --%></span>
                </label>
                <c:if test="${isLeaderOrManager eq false}" >
                <label>
                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopeVicePostDept" 
                     <c:if test="${fn:contains(rScope,'2')}">checked</c:if> /><span id="roleMatchScopeVicePostDeptSpan">${ctp:i18n('workflow.branchGroup.2.2')}<%-- 副岗部门 --%></span>
                </label>
                </c:if>
                <c:if test="${isGroupVersion}" >
                    <label>
                         <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopePartTimeDept" 
                         <c:if test="${fn:contains(rScope,'3')}">checked</c:if> /><span id="roleMatchScopePartTimeDeptSpan">${isLeaderOrManager eq false ? ctp:i18n('workflow.branchGroup.2.3') : ctp:i18n('workflow.branchGroup.1.2')}<%-- 兼职部门/单位 --%></span>
                    </label>
                    <c:if test="${isSender eq true}" >
                        <br/>
                        <label>
                        <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopeSenderAccount" 
                        <c:if test="${fn:contains(rScope,'4')}">checked</c:if> /><span id="roleMatchScopeSenderAccountSpan">${ctp:i18n("workflow.branch.byloginaccount.label")}<%-- 按发起者登录单位判断--%></span>
                        </label>
                    </c:if>
                </c:if>
                </td>
               </tr>
               </c:if>
               </table>
               </fieldset>
            </tr>            
            </c:when>
            <%--单人节点：默认走代理交接 --%>
            <c:when test="${partyType=='user' || 'true' ne isTemplete}"></c:when>
            <%--其他：由上节点选人和自动跳过 --%>
            <c:otherwise>
             <tr height="10"><td></td></tr>
                <tr>
               <td>
               <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.matchScope.node')}</legend>
               <table align="center" border="0" width="100%">
               <c:if test="${ fn:indexOf(partyId, 'SenderVjoin') ne -1 || fn:indexOf(partyId, 'NodeUserVjoin') ne -1 || fn:indexOf(partyId, 'SenderSVjoin') ne -1 || fn:indexOf(partyId, 'NodeUserSVjoin') ne -1}">
	              <tr>
	                <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.matchType')}:</td>
	                <td width="72%" align="left" colspan="2">
	                <label>
	                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleAutoUpMatch" id="roleAutoUpMatch" 
	                     ${(rup=='1'||rup=='-1' || rup=='null')?'checked':''}/><span id="roleAutoUpMatchSpan">${ctp:i18n('workflow.designer.node.role.autoup.label')}</span>
	                </label>
	                </td>
	               </tr>
               </c:if>
             <tr id="nouserActionTitle">
               <td width="28%" height="28" align="right" valign="top" style="line-height: 26px;">${ctp:i18n('workflow.designer.node.nouser.action.label')}:</td>
               <td width="72%" align="left">
               <select ${isCopyFromDisable}  ${disable0} style="width:200px" class="margin_l_5" name="nouserAction" id="nouserAction" onchange="showNouserActionTitle(this);">
                    <%--弹选人界面 --%>
                    <option value="0" selected="selected">${ctp:i18n('workflow.designer.node.nouser.action.label0')}</option>
                    <%--自动跳过 --%>
                    <option value="2">${ctp:i18n('workflow.designer.node.nouser.action.label2')}</option>
                </select>
                <c:if test="${appName == 'collaboration' || appName == 'form'}">
	                <div id="na_ignoreBlank"  <c:if test="${appName !='form'}">style="display:none"</c:if>class="margin_l_5 margin_t_10 <c:if test="${na !='2'}">display_none</c:if>">
	                <label><input type="checkbox" <c:if test="${na_b =='1'}">disabled="disabled"</c:if> <c:if test="${na_i =='1'}">checked="checked"</c:if>  value="1" name="ignoreBlank"  id="ignoreBlank" ${matchScope4Checked} ${isCopyFromDisable}/>${ctp:i18n('workflow.node.ignoreBlank')}<!--忽略表单必填项--></label>
	                </div><div id="na_asBlankNode" class="margin_l_5 margin_t_10 <c:if test="${na !='2'}">display_none</c:if>">
	                <label><input type="checkbox" onclick="_checkNaAsBlankNode(this)" <c:if test="${na_b =='1'}">checked="checked"</c:if> value="1" name="asBlankNode"  id="asBlankNode" ${matchScope4Checked} ${isCopyFromDisable}/>${ctp:i18n('workflow.node.asBlankNode')}<!--视为空节点--></label>
	                </div>
                </c:if>
               </td>
               <td nowrap="nowrap">
                <a class="color_blue"  href="#" onclick="showMatchScopeExplain(3)" style="text-decoration:none">
                [${ctp:i18n("node.policy.match.scope.explain")}]
                </a> 
                </td>
               </tr>
               <c:if test="${isShowFormRoleScope}">
               <c:set var="hasRoleMatchScope" value="true"/><%-- 标记有匹配范围选择 --%>
               <tr id="roleMatchScopeTr">
                <td width="28%" height="28" style="line-height: 28px;" align="right">${ctp:i18n('workflow.designer.node.matchScope')}<!-- 匹配范围 -->:</td>
                <td width="72%" align="left" colspan="2">
                <label>
                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopeMainPostDept" 
                     <c:if test="${fn:contains(rScope,'1')}">checked</c:if> /><span id="roleMatchScopeMainPostDeptSpan">${ctp:i18n('org.member_form.departments.label')}<%-- 所属部门/单位 --%></span>
                </label>
                <label>
                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopeVicePostDept" 
                     <c:if test="${fn:contains(rScope,'2')}">checked</c:if> /><span id="roleMatchScopeVicePostDeptSpan">${ctp:i18n('workflow.branchGroup.2.2')}<%-- 副岗部门 --%></span>
                </label>
                <c:if test="${isGroupVersion}">
                <label>
                     <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopePartTimeDept" 
                     <c:if test="${fn:contains(rScope,'3')}">checked</c:if> /><span id="roleMatchScopePartTimeDeptSpan">${ctp:i18n('workflow.branchGroup.2.3')}<%-- 兼职部门/单位 --%></span>
                </label>
                <c:if test="${fn:startsWith(partyId, 'Sender')}" >
                        <br/>
                        <label>
                        <input ${isCopyFromDisable}  ${disable0} class="margin_l_5" type="checkbox" name="roleMatchScope" id="roleMatchScopeSenderAccount" 
                        <c:if test="${fn:contains(rScope,'4')}">checked</c:if> /><span id="roleMatchScopeSenderAccountSpan">${ctp:i18n("workflow.branch.byloginaccount.label")}<%-- 按发起者登录单位判断--%></span>
                        </label>
                    </c:if>
                </c:if>
                </td>
               </tr>
               </c:if>
               </table>
              </fieldset>
              </td>
              </tr>
            </c:otherwise>
          </c:choose>
          <!-- 匹配范围部分:结束  -->
		  <!-- 表单视图绑定部分:开始  --> 
		  <c:if test="${isFormTemplate== true}">
		  <tr height="10"><td></td></tr>
		  <tr>
		     <td>
               <fieldset width="80%" align="center">
               <legend>${ctp:i18n('workflow.designer.form.bind.label')}</legend>
			   <table align="center" width="100%" border="0">
			     <tr>
				    <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.form.bind.formAndOperation')}:</td>
				    <td width="50%" align="left">
					<select style="width:200px" class="margin_l_5"  name="operations" id="operations" ${formAndOperationDisable} onchange="disableMyReadView(this);">
					<c:forEach items="${nodeBindFormViewList }" var="nodeBindFormView" >
					  <option value="${nodeBindFormView.value}" title = "${nodeBindFormView.name }" <c:if test="${nodeBindFormView.value ==currentFormOperation}">selected</c:if>>${nodeBindFormView.name}</option>
					</c:forEach>
			    	</select>
		    		</td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
				 </tr>
				 <c:if test="${!empty nodeBindMutiFormViewMap && nodeType!='StartNode'}">
			 		<tr>
			 			<td align="right" width="28%">
			 			<table align="center" width="100%" border="0">
							<c:forEach items="${views}" var="entry">
			 				<tr>
			 					<td width="100%" align="right" height="20">
			 					<input type="checkbox" onclick="enableMyOperations(this);"
			 					<c:if test="${selectedFormViewMap[entry.id]!=null }">
			 					checked
			 					</c:if>
			 					 name="formview_checkbox" id="formview_checkbox_${entry.id}" value="${entry.id}" ${formAndOperationDisable}/></td>
			 					<td nowrap="nowrap" height="20" align="left">${entry.formName}</td>
			 				</tr>
							</c:forEach>
			 			</table>
			 			</td>
			 			<td width="50%" align="left">
						<table align="center" width="100%" border="0">
							<c:forEach items="${views}" var="entry">
							<tr>
							<td height="20">
								<select 
								<c:if test="${selectedFormViewMap[entry.id]==null }">
                                    disabled
                                </c:if>
								style="width:200px" class="margin_l_5"  name="operations_${entry.id}" id="operations_${entry.id}" ${formAndOperationDisable}>
			 					<c:forEach items="${nodeBindMutiFormViewMap[entry.id].operations }" var="myOperation" >
									<c:if test="${myOperation.value.type =='readonly'}">
									    <option value="${myOperation.value.value}"
										<c:if test="${myOperation.value.defaultTag == 'true' }">
										selected
										</c:if>
										title = "${myOperation.value.name }" >${myOperation.value.name}</option>
									</c:if>
			 					</c:forEach>
								</select>
							</td>
							</tr>
							</c:forEach>
						</table>
			 			</td>
			 			<td align="left" width="22%" nowrap="nowrap"></td>
			 		</tr>
				</c:if>
				<%-- 只有编辑状态下和非发起者节点可以设置查询和统计 --%>
				<c:if test="${nodeId ne 'start'}">
               <!--   <tr>
                    <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.bindq')}:</td>
                    <td width="50%" align="left">
                        <input type="hidden" value="${queryIds }" name="bindQuerys" id="bindQuerys" readonly="readonly"/>
                        <input type="text" value="${queryIdsText }" title="${queryIdsText }" ${formqsFlag} style="width:200px" class="margin_l_5 toomore"  name="bindQuerysText" id="bindQuerysText" readonly="readonly" onclick="bindQueryFunc()"/>
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
                 </tr>
                <tr>
                    <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.binds')}:</td>
                    <td width="50%" align="left">
                        <input type="hidden" value="${statisticsIds }" name="bindCounts" id="bindCounts" readonly="readonly"/>
                        <input type="text" value="${statisticsIdsText }" title="${statisticsIdsText }" ${formqsFlag} style="width:200px" class="margin_l_5 toomore"  name="bindCountsText" id="bindCountsText" readonly="readonly" onclick="bindCountFunc()"/>
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
                 </tr>-->
                 </c:if>
			   </table>
			   </fieldset>				   
			  </td>
		 </tr>
		 </c:if>
		 <!-- 表单视图绑定部分:结束  -->
         <c:if test="${isFromTemplete or _isTemplete}"><!-- 模版流程 -->
             <!-- 节点属性说明部分:开始  -->	
    		 <tr height="10"><td></td></tr>
             <tr><td class="font_size12" align="left">${ctp:i18n('workflow.designer.node.deal.explain')}</td></tr>
             <tr>
                <td>
                <div style="padding:0px;">
                    <textarea id="desc" ${nodeState!="1"?"disabled":"" } name="desc"  rows="5" maxSize="200" class="validate font_size12" validate="isWord:true,avoidChar:'!@#$%^*()<>\\',maxLength:200,name:&#x27;${ctp:i18n('workflow.nodeProperty.dealExplain') }<%-- 处理说明 --%> &#x27;" style="width:99.5%;"></textarea>
                </div>
                </td>
             </tr>
          </c:if>
          <!-- 手工分支可选条件  -->
          <%--2014年1月之后再来做该功能
          <c:choose>
    		<c:when test="${policyId_es != 'inform' && (_isTemplete or isFromTemplete) && scene eq '0'}">
    			<tr height="10" id="hs_type_area1"><td></td></tr>
				<tr id="hs_type_area2">
					<td id="hs_type_td" align="left"></td>
				</tr>
    		</c:when>
    		<c:otherwise>
    			<tr height="10" id="hs_type_area1" style="display:none;"><td></td></tr>
				<tr id="hs_type_area2" style="display:none;">
					<td id="hs_type_td" align="left"></td>
				</tr>
    		</c:otherwise>
    	  </c:choose>
    	  --%>
		</table>
	  </div>
     </td>
    </tr>
    <%-- 批量修改节点属性  --%>
	<tr>
	 <td height="28" style="font-size: 12px;" style="padding:0 10px;">
        <div>
        <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
                <td align="left">
                    <c:if test="${isShowApplyToAll== true}">
                        <label for="applyToAllCbox">
                            <input type="checkbox" id="applyToAll" name="applyToAll" value="true">
                            <c:choose>
                                <c:when test="${_isTemplete== true }">${ctp:i18n('workflow.nodeProperty.applyToAll.templete')}</c:when>
                                <c:otherwise>${ctp:i18n('workflow.nodeProperty.applyToAll')}</c:otherwise>
                            </c:choose>
                        </label>
                    </c:if>
                </td>
                <td align="right" style="padding-top:5px;">
                	<c:if test="${isShowAdvancedSetting == 'true' && nodeId != 'start' && _isTemplete == true}">
                	<a id="btnreset" class="common_button common_button_gray" style="max-width:none" href="javascript:void(0)" onclick="openEventAdvancedSetting();">${ctp:i18n('workflow.advance.event.name')}<%--开发高级 --%></a>
                	<input type="hidden" id="process_event" name="process_event" value=""/>
                	</c:if>
                </td>
            </tr>
        </table>
        </div>
	 </td>
	</tr>
</table>
</form>
</div>
<script type="text/javascript">
var appName= '${appName}';
var paramObjs= window.parentDialogObj['workflow_dialog_setWorkflowNodeProperty_Id'].getTransParams();
//var dialogParentTransParams= window.dialogArguments;
var processXmlTemp= paramObjs.processXml;
var descOld= paramObjs.desc;
var tempProcessEvent = paramObjs.process_event;
if(tempProcessEvent){
	$("#process_event").val(tempProcessEvent);
}
if(descOld.trim()=="\t"){
  $("#desc").attr("value","");
}else{
   $("#desc").attr("value",descOld);
}
<c:if test="${(_isTemplete || isFromTemplete) && (param.nodeState eq '1' || param.nodeState eq '2')}">
if(paramObjs.hsbObj!=null){
	if(paramObjs.hsbObj.isHasHandCodition){
		$("#hs_type_td").html(paramObjs.hsbObj.optionStr);
	}
}
</c:if>
<%--
<c:if test="${(_isTemplete || isFromTemplete) && (param.nodeState ne '1' && param.nodeState ne '2')}">
	 var showName= "${ctp:i18n('workflow.matchResult.msg3')}:<select disabled>";
     if(hs_type=="0"){
       showName+= "<option value='0'>${ctp:i18n('workflow.matchResult.msg4')}</option>";
	 }else{
	   showName+= "<option value='"+hs_type+"'>"+hs_type+"</option>";
	 }
     showName +="</select>";
	 $("#hs_type_td").html(showName);
</c:if>
--%>
var wfAjax= new WFAjax();
//确定按钮响应方法
function OK(jsonArgs) {
  var innerButtonId= jsonArgs.innerButtonId;
  if(innerButtonId=='ok'){
    /* if(!checkForm(selectPolicyForm)) return; */
    <c:if test="${flag2== true}"><!-- 模版流程 -->
      var vresult= $("#selectPolicyForm").validate();
      if(!vresult){
        return false;
      }
    </c:if>
    //节点权限
    var policyOptionValue = $("#policy").attr("value");
    //节点权限名称
    var policyOptionName=$("#policy").find("option:selected").text();
    //提前提醒
    var remindTime = $("#remindTime").attr("value");
    if($("#dealTerm").val()==_dealCustom){
    	var dealTerm = $("#customDealTerm").attr("value");
    	var nowTime = new Date().getTime();
        var dealline = new Date();
        var temp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/g.exec(dealTerm);
        var remind = new Number(remindTime);
        if(temp && temp[0]){
            dealline.setFullYear(parseInt(temp[1], 10));
            dealline.setMonth(parseInt(temp[2], 10)-1);
            dealline.setDate(parseInt(temp[3], 10));
            dealline.setHours(parseInt(temp[4], 10));
            dealline.setMinutes(parseInt(temp[5], 10));
            var shijiancha = dealline.getTime() - nowTime;
            if(shijiancha<0){
                showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanNow')}");
                $("#remindTime").get(0).selectedIndex=0;
                return false;
            }
            if(shijiancha/1000/60<remind){
            	showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
                $("#remindTime").get(0).selectedIndex=0;
                return false;
            }
        }
    }else{
	    //超期期限
	    var dealTerm = $("#dealTerm").attr("value");
	    var deal = new Number(dealTerm);
	    var remind = new Number(remindTime);
	    if(deal < remind || ( deal == remind &&  deal!=0 && remind!=0 ) ){
	        showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
	        $("#remindTime").get(0).selectedIndex=0;
	        return false;
	    }
    }
    //处理说明
    var desc  = $("#desc").attr("value");
    var hasDesc = "1";
    if(!desc || ( desc.trim()=="" || desc.trim()=="\t")){
        hasDesc= "0";
    }
    //执行模式
    var processMode = "${processMode}";
    var node_process_mode = $('input:radio[name="node_process_mode"]');
    var disableORShowObj = $('#disableORShow')[0];
    //if(node_process_mode  && (disableORShowObj == null || (policyOptionValue != "inform" && policyOptionValue != "zhihui"))){
    if(node_process_mode){
        var val=$('input:radio[name="node_process_mode"]:checked').val();
        if(val!=null){
          processMode= val;
        }
    }
    //表单视图操作权限
    var formApp = "${formApp}";
    var formName = "";
    var operationName = "";
    var operationNameMutils= "";
    if($('#operations')[0]){
        var operationsValue= $("#operations").attr("value").split("|");
        if(operationsValue){
          formName = operationsValue[0];
          operationName = operationsValue[1];
        }
        var multiFormViewCheckboxs= document.getElementsByName("formview_checkbox");
        var formViewLength= multiFormViewCheckboxs.length;
        var j=0;
        for(var i=0;i<formViewLength;i++){
        	var multiFormViewCheckbox= multiFormViewCheckboxs[i];
        	if(multiFormViewCheckbox.checked){
        		var multiFormViewOperation= document.getElementById("operations_"+multiFormViewCheckbox.value).value;
        		if(j==0){
        			operationNameMutils += multiFormViewOperation;
        		}else{
        			operationNameMutils += ","+multiFormViewOperation;
        		}
        		j++;
        	}
        }
    }
    //岗位匹配范围类型
    var matchScope = 1;
    var defaultMatchScopeValue= $("#defaultMatchScope").attr("value");
    var selectMatchScopeValue=$('input:radio[name="matchScope"]:checked').val();
    if(selectMatchScopeValue){
      matchScope= selectMatchScopeValue;
    }else{
      matchScope= defaultMatchScopeValue;
    }
    //匹配范围由表单控件字段决定
    var formFieldValue = "";
    if($("#formFieldValue")[0]){
      formFieldValue= $("#formFieldValue").attr("value");
    }
    //表单控件决定匹配范围，则必须选择一个表单控件字段
    <c:if test="${(isRootPost || hasAccountPost4FormFiled) && isGroupVersion}">
    if(formFieldValue == "" && matchScope == "4"){
        showFlashAlert("${ctp:i18n('workflow.nodeProperty.formCreat_must_value')}");
        return false;
    }
    </c:if>
    //知会节点不能触发新流程
    if(policyOptionValue == "inform" || policyOptionValue == "zhihui"){
        if(${hasNewflow eq 'true'}){
            showFlashAlert("${ctp:i18n('workflow.nodeProperty.inform_alert_alreadyHasNewflow')}");
            return false;
        }
    }
    //是否将当前节点属性信息应用到其它所有节点
    var isApplyToAll = "false";
    if($("#applyToAll")[0]){
      if($("#applyToAll").attr("checked")){
        isApplyToAll = "true";
      }
    }
    //超期处理动作设置信息
    var dealTermType="";//到期处理类型
    var dealTermUserId="";
    var dealTermUserName="";
    if(${_isTemplete== true} || ((${scene == 4 || scene == 5}) && ${_isTemplete== true} )){//模板流程、督办和管控模式
        dealTermType= $("#dealTermAction").attr("value");
        if(dealTermType=='0'){//仅消息提醒
            dealTermUserId="";
            dealTermUserName="";
        }else if(dealTermType=='1'){//转给指定人
            if($("#dealTermUserId")[0]){
                dealTermUserId= $("#dealTermUserId").attr("value");//到期处理动作参数
                dealTermUserName= $("#workflowInfo").attr("value");
            }else{
                showFlashAlert("${ctp:i18n('workflow.nodeProperty.must_to_a_pople')}");
                return false;
            }
        }else{//自动跳过
            dealTermUserId="";
            dealTermUserName="";
        }
    }
    var isProIncludeChild= $("#isProIncludeChild").attr("value");
    var rAutoUp= "1";//角色是否自动向上查找，默认为1表示自动向上查找
    if($("#roleAutoUpMatch")[0]){
      var checked= $("#roleAutoUpMatch").attr("checked");
      if(checked){
        rAutoUp= "1";
      }else{
        rAutoUp= "0";
      }
    }else{//如果该input不存在，那么就设置为0
    	rAutoUp= "0";
    }
    
    var rMatchScope = "";//角色匹配范围， 1-所属部门/单位， 2-副岗部门， 3-兼职部门/单位  4-按发起者登录单位判断(发起者相对角色设置),
    <c:if test="${hasRoleMatchScope eq true}">
    //部门角色匹配范围处理
    var hasChecked = false;
    var iScopes = $("input[name='roleMatchScope']").each(function(){
        if(this.checked){
            
            hasChecked = true;
            
            var iScopeId = this.getAttribute("id");
            if("roleMatchScopeMainPostDept" == iScopeId){
                rMatchScope += "1";
            }else if("roleMatchScopeVicePostDept" == iScopeId){
                rMatchScope += "2";
            }else if("roleMatchScopePartTimeDept" == iScopeId){
                rMatchScope += "3";
            }else if("roleMatchScopeSenderAccount" == iScopeId){
                rMatchScope += "4";
            }
        }
    });
    if(!hasChecked){
        //请至少勾选一个匹配范围
        showFlashAlert("${ctp:i18n('workflow.designer.node.role.selectScope')}");
        return false;
    }
    </c:if>
    
    //匹配范围
    <c:if test="${(isRootPost || hasAccountPost4FormFiled) && isGroupVersion}">
    if(formFieldValue == "" && matchScope == "4"){
        showFlashAlert("${ctp:i18n('workflow.nodeProperty.formCreat_must_value')}");
        return false;
    }
    </c:if>
    
    var pAutoUp= "1";//岗位是否自动向上查找，默认为1表示自动向上查找

    var $postAutoUpEle = $("#departmentPostAutoUpId");
    if(matchScope == "6"){//发起者部门岗位，不包含子部门
        $postAutoUpEle = $("#departmentPostAutoUpIdNoSub");
    }
    
    if($postAutoUpEle[0]){
       var checked= $postAutoUpEle.attr("checked");
       if(checked){
         pAutoUp= "1";
       }else{
         pAutoUp= "0";
       }
    }
    var nuAction= "0";//匹配不到人时：默认0弹出选人界面
    if($("#nouserAction")[0]){
      nuAction= $("#nouserAction").attr("value");
    }
    var ignoreBlankV = "0", asBlankNodeV = "0", $ignoreBlank;
    if(nuAction == "2" && (appName == 'collaboration' || appName == 'form')){
	    $ignoreBlank = $("#ignoreBlank");
	    if($ignoreBlank.length > 0){
	        
	        if($ignoreBlank.attr("checked")){
       	        ignoreBlankV = $ignoreBlank.val();
	        }
	        if($("#asBlankNode").attr("checked")){
	            asBlankNodeV = $("#asBlankNode").val();
	        }
	    }
    }
    
    var process_event = $("#process_event").val();
    var nodeNameStr= $("#nodeNamee").attr("value");
    var queryIds= $("#bindQuerys").val()||"";
    var statisticsIds= $("#bindCounts").val()||"";
    var cycleRemindTime = $("#cycleRemindTime").val();
    var result = [policyOptionValue, policyOptionName, dealTerm, remindTime, processMode, 
                  formApp, formName, operationName, "", matchScope,
                  "${hasNewflow}", isApplyToAll,formFieldValue,desc,dealTermType,
                  dealTermUserId,dealTermUserName,hasDesc,isProIncludeChild,"-1",
                  "-1",rAutoUp,pAutoUp,nuAction,process_event,
                  operationNameMutils,"1",nodeNameStr,queryIds,statisticsIds,
                  rMatchScope, ignoreBlankV, asBlankNodeV, cycleRemindTime];
    return result;
  }
}

//匹配范围交互事件绑定
function bindRoleScopeClick(){
    
    var roleScopeAccount = document.getElementById("roleMatchScopeSenderAccount");
    if(roleScopeAccount){
	    $("input[name='roleMatchScope']").on("click", function(){
	        if(this.checked){
	            //互斥
	            var iScopeId = this.getAttribute("id");
	            if("roleMatchScopeSenderAccount" == iScopeId){
	                $("input[name='roleMatchScope']").attr("checked",false);
	                this.checked = true;
	            }else{
	                $("#roleMatchScopeSenderAccount").attr("checked",false);
	            }
	        }
	    });
    }
}
  
//控制节点权限下拉列表
function disableORShow(){
  var form = document.getElementsByName("selectPolicyForm")[0];
  var value = $("#policy").attr("value");
  var disableORShowObj = $('#disableORShow')[0];
  if( disableORShowObj && disableORShow.className != 'hidden' && value
          && (value == "inform" || value == "zhihui")){
    disableORShowObj.className = 'hidden' ;
    $("#single_mode").removeAttr("checked");
    $("#multiple_mode").removeAttr("checked");
    $("#all_mode").attr("checked","checked");
    $("#competition_mode").removeAttr("checked");
  }else if( disableORShowObj && disableORShowObj.className == 'hidden'){
    disableORShowObj.className = "" ;
  }
  
  var dealTermValue= $("#dealTerm").attr("value");
  if(dealTermValue!=0 && ( ${_isTemplete} || ((${scene == 4 || scene == 5}) && ${_isTemplete== true}) ) ){
      $("#dealTermTR").show();
      var dealTermType= $("#dealTermAction").attr("value");//到期处理类型
      if(dealTermType=='2'){//自动跳过
          if(value == "vouch"){//表单核定节点不允许设置自动跳过
            showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_vouch')}");
            $("#dealTermAction").attr("value","0");
          }else{
            if( appName!='collaboration' && appName!='form' ){
              var result= wfAjax.isExchangeNode(appName,value,'${flowPermAccountId}');
              if(result[0]=='true'){//公文交换类型的节点，不允许自动跳过
                showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_fengfa')}");
                $("#dealTermAction").attr("value","0");
              }
            }
          }
      }
  }
}

function showCycleRemindTr() {
	var isDisplay = false;
	if(appName=="collaboration" || appName=="form") {
		if("${isTemplete}" == "true") {//流程模板-通过（处理期限到）的选择来进行判断
			if($("#dealTermTR").is(":visible")) {
				var dealTermType = $("#dealTermAction").attr("value");
				if(dealTermType == "0") {
					isDisplay = true;
				}
			}
		} else {//自由流程-通过（处理期限）的选择来进行判断
			if($("#dealTerm").val() != "0") {
				isDisplay = true;
			} else if($("#dealTermCustomArea").is(":visible") && $("#customDealTerm") && $("#customDealTerm").val()!="") {
				isDisplay = true;
			}
		}
	}
	
	var lastValue = $("#cycleRemindTime").attr("lastValue");
	if(isDisplay) {
		$("#cycleRemindTR").show();
		if(lastValue == "0") {
			$("#cycleRemindTime").val("0");
			$("#cycleRemindTime").attr("disabled", true);
			$("#cycleRemindChexkbox").attr("checked", false);
		} else {
			$("#cycleRemindTime").val("${cycleRemindTimeValue}");
			$("#cycleRemindTime").attr("disabled", false);
			$("#cycleRemindChexkbox").attr("checked", true);
		}
	} else {
		$("#cycleRemindTR").hide();
		$("#cycleRemindTime").val("0");
		$("#cycleRemindTime").attr("lastValue", $("#cycleRemindTime").val());
		$("#cycleRemindTime").attr("disabled", true);
		$("#cycleRemindChexkbox").attr("checked", false);
	}
}
function cycleRemindTimeClkFun() {
	if($("#cycleRemindChexkbox").attr("checked")) {
		$("#cycleRemindTime").attr("disabled", false);		
	} else {
		$("#cycleRemindTime").attr("disabled", true);
		$("#cycleRemindTime").val("0");
	}
}
function cycleRemindTimeChgFun() {
	$("#cycleRemindTime").attr("lastValue", $("#cycleRemindTime").val());
}

/**
 * 设置表单控件匹配是否可选
 */
function disableFormFieldValue(value){
  if($("#formFieldValue")[0]){
      if(value == 'false'){
          $("#formFieldValue").removeAttr("disabled");
      }else{
          $("#formFieldValue").attr("value","");
          $("#formFieldValue").attr("disabled","disabled");
          $("#isProIncludeChild").attr("value","false");
          $("#isIncludeChildInfo").text("");
      }
  }
}

function changeDealTermAction(){
    //提前提醒
    var remindTime = $("#remindTime").attr("value");
	//超期期限
    if($("#dealTerm").val()==_dealCustom){
        $("#dealTermCustomArea").show();
    	var dealTerm = $("#customDealTerm").attr("value");
        var nowTime = new Date().getTime();
        var dealline = new Date();
        var temp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/g.exec(dealTerm);
        var remind = new Number(remindTime);
        if(temp && temp[0]){
        	dealline.setFullYear(parseInt(temp[1], 10));
            dealline.setMonth(parseInt(temp[2], 10));
            dealline.setDate(parseInt(temp[3], 10));
            dealline.setHours(parseInt(temp[4], 10));
            dealline.setMinutes(parseInt(temp[5], 10));
            var shijiancha = dealline.getTime() - nowTime;
            if(shijiancha<0 || shijiancha/1000/60<remind){
            	showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
                $("#remindTime").get(0).selectedIndex=0;
                return false;
            }
        }
    }else{
        //超期期限
        $("#dealTermCustomArea").hide();
        var dealTerm = $("#dealTerm").attr("value");
	    var deal = new Number(dealTerm);
	    var remind = new Number(remindTime);
	    if(deal < remind || ( deal == remind &&  deal!=0 && remind!=0 ) ){
	      showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
	      $("#remindTime").get(0).selectedIndex=0;
	      if(deal==0){
	        $("#dealTermTR").hide();
	        if($("#dealTerm").val()=='0'){
	            if($("#dealTermAction")[0]){
	                $("#dealTermAction").attr("value","");
	            }
	            if($("#dealTermUserId")[0]){
	                $("#dealTermUserId").attr("value","");
	            }
	            if($("#workflowInfo")[0]){
	                $("#workflowInfo").attr("value","");
	            }
	        }
	      }
	      return false;
	    }
    }
    var policyOptionValue = $("#policy").attr("value");
    if( dealTerm!='0' && ( ${_isTemplete} || ((${scene == 4 || scene == 5}) && ${_isTemplete== true}) ) ){
        $("#dealTermTR").show();
        if($("#dealTermAction")[0]){
          $("#dealTermAction").attr("value","0");
        }
        if($("#workflowInfo")[0]){
          $("#workflowInfo").hide();
        }
    }else{
        $("#dealTermTR").hide();
        if(dealTerm=='0'){
            if($("#dealTermAction")[0]){
                $("#dealTermAction").attr("value","");
            }
            if($("#dealTermUserId")[0]){
                $("#dealTermUserId").attr("value","");
            }
            if($("#workflowInfo")[0]){
                $("#workflowInfo").attr("value","");
            }
        }
    }
    
    showCycleRemindTr();
}

/**
 * 页面加载时初始化数据
 */
var _dealCustom="custom";
function onLoadFunc(){
    
  <c:if test="${na !='-1' && na !='null'}">
      $("#nouserAction").attr("value","${na}");
  </c:if>
  var tempDealTerm = "${dealTerm}";
  if(${_isTemplete!=true || (_isTemplete==true && (scene==3 || scene==4 || scene==5))}){
	      var customOption = '<option value="'+_dealCustom+'">${ctp:i18n("workflow.designer.node.customDealterm")}</option>';
		  $(customOption).insertAfter($("#dealTerm option[value=0]"));
		  if(/^\d\d\d\d-\d\d-\d\d \d\d:\d\d$/g.test(tempDealTerm)){
		      $("#dealTerm").attr("value","custom");
		      $("#dealTermCustomArea").show();
		  }else if(/^-?\d$/g.test(tempDealTerm)){
		      $("#dealTerm").attr("value","${dealTerm==''?'0':dealTerm}");
		      $("#dealTermCustomArea").hide();
		  }
  }
  $("#remindTime").attr("value","${remindTime=='-1' || remindTime==''?'0':remindTime}");
  //模板设计模式
  if(${_isTemplete== true}){
    $.each($('input:radio[name="node_process_mode"]'), function(i,val){  
      if(val.value=="${processMode}"){
        val.checked= true;
      }
    });
    var dealTermValue= "${dealTerm}"||"0";
    if(dealTermValue !='0'){//选择了处理期限到策略
          $("#dealTermTR").show();
          if(${dealTermType!='' && dealTermType !='null' && dealTermType !='undefined'}){
              $("#dealTermAction").attr("value","${dealTermType}");
          }else{
              $("#dealTermAction").attr("value","0");
          }
          if(${dealTermUserId !='' && dealTermUserName !='' && dealTermType!='' && dealTermUserId !='null' && dealTermUserName !='null' && dealTermType !='null'}){
              if(${dealTermType=='1'}){
                  $("#workflowInfo").show();
                  $("#workflowInfo").attr("value","${dealTermUserName}");
                  if($("#dealTermUserId")[0]){
                      $("#dealTermUserId").attr("value","${dealTermUserId}");
                  }else{
                      var str="";
                      str += '<input type="hidden" id="dealTermUserId" name="dealTermUserId" value="${dealTermUserId}" />';
                      $("#workflowInfo_pepole_inputs").html(str);
                  }
              }
          }
      }else{//没有选择处理期限到策略
        $("#dealTermTR").hide();
      }
  }else{
    $("#dealTermTR").hide();
  }

  
  //督办和管理控制模式
  if( (${scene == 4 || scene == 5}) && ${_isTemplete== true}){
      if(dealTermValue !='0'){
        $("#dealTermTR").show();
        if(${dealTermType!='' && dealTermType !='null' && dealTermType !='undefined'}){
             $("#dealTermAction").attr("value","${dealTermType}");
        }else{
             $("#dealTermAction").attr("value","0");
        }
        if(${dealTermUserId !='' && dealTermUserName !='' && dealTermType!='' && dealTermUserId !='null'  && dealTermUserName !='null' && dealTermType !='null'}){
              if(${dealTermType=='1'}){
                  $("#workflowInfo").show();
                  $("#workflowInfo").attr("value","${dealTermUserName}");
                  if($("#dealTermUserId")[0]){
                      $("#dealTermUserId").attr("value","${dealTermUserId}");
                  }else{
                      var str="";
                      str += '<input type="hidden" id="dealTermUserId" name="dealTermUserId" value="${dealTermUserId}" />';
                      $("#workflowInfo_pepole_inputs").html(str);
                  }
              }
          }
      }else{
          $("#dealTermTR").hide();
      }
  }
  //不是模板，不是人员节点
  if(${!_isTemplete &&  partyType != 'user' && (nodeState eq '1')}){
      var portyid = escape("${policyIdHtmlValue_es}") ;
      var disableORShowObj = document.getElementById('disableORShow') ;
      if(portyid != 'inform' && portyid != 'zhihui' && disableORShowObj){
          disableORShowObj.className = '' ;
      }
  }
  //表单控件决定匹配范围
  if($("#matchScope4")[0] && $("#matchScope4").attr("checked")){
      if($("#formFieldValue")[0]){
        var isCopyFrom = "${isCopyFrom}";
        if(isCopyFrom != "true"){
        	$("#formFieldValue").removeAttr("disabled");
        }
        //$("#formFieldValue").attr("value","${formField}");
        var selectedValue = "${formField}";
        $("#formFieldValue option").each(function(){
        	var tempThis = $(this);
        	if(tempThis.val()==selectedValue || tempThis.attr("title")==selectedValue){
        		tempThis.prop("selected", true);
        		tempThis = null;
        		return false;
        	}
        	tempThis = null;
        });
        var fType= $("#formFieldValue").find("option:selected").attr("formFieldType");
        $("#formFieldValue").attr('title',$("#formFieldValue").find("option:selected").attr("title"));
        if(fType=='department'||fType=='multidepartment'){//单部门和多部门时
        	if("${isExternalType}"=="false"){
	          <c:choose>
	          <c:when test="${isProIncludeChild=='true'}">
	          $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.includeChildren')})");
	          </c:when>
	          <c:when test="${isProIncludeChild=='false'}">
	          $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.excludeChildren')})");
	          </c:when>
	          <c:otherwise>
	          $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.includeChildren')})");
	          </c:otherwise>
	          </c:choose>
        	}else{
        		$("#isProIncludeChild").attr("value","true");
        	}
        }
      }
  }
  //表单控件节点不能选择执行模式
  var partyType = '${partyType}';
  var partyId= '${partyId}';
  var isFormFieldRole= '${param.isFormFieldRole}';
  var nodeNameeTemp= $("#nodeNamee").attr("value");
  var report2="${ctp:i18n('member.report2')}";
  var isAccountRole="${isAccountRole}";
  if (isAccountRole=="true"){
	  $("#roleAutoUpMatchSpan").html("${ctp:i18n('workflow.designer.node.accountrole.autoup.label')}");
  }
  
  if(nodeNameeTemp.indexOf(report2)>=0){
	  if(partyId.indexOf("ReciprocalRoleReporter")>=0){
		  	//相对角色汇报人
		  	//执行模式只能能是单人执行
			  $("#single_mode").attr("checked",true);
			  $("#multiple_mode").attr("disabled","disabled");
			  $("#all_mode").attr("disabled","disabled");
			  $("#competition_mode").attr("disabled","disabled");
			  
			  //不显示匹配方式
			  $("#roleAutoUpMatch").attr("checked",false);
			  $("#roleAutoUpMatchTr").css("display","none");
		}
	  
	  if(partyId.indexOf("Multimember@")>=0){
		  	//表单控件汇报人 默认选择担任执行
		  	//多人
		  	<c:if test="${!isCopyFrom}">
		  	//  $("#single_mode").attr("checked",true);
	          $("#single_mode").attr("disabled",false);
	          $("#multiple_mode").attr("disabled",false);
	          $("#all_mode").attr("disabled",false);
	          $("#competition_mode").attr("disabled",false);
	         </c:if>
		}else if(partyId.indexOf("Member@")>=0){
		  	//表单控件汇报人 默认选择担任执行
		  	//单人
			  $("#single_mode").attr("checked",true);
			  $("#multiple_mode").attr("disabled",false);
			  $("#multiple_mode").attr("disabled","disabled");
			  $("#all_mode").attr("disabled","disabled");
			  $("#competition_mode").attr("disabled","disabled");
		}
  }
 else if(partyType == "FormField"){
      if(isFormFieldRole=='false'){
        if($("#single_mode")[0] && $("#multiple_mode")[0] && $("#all_mode")[0] && $("#competition_mode")[0]){
          if(partyId.indexOf('Multimember')!=0&&partyId.indexOf('Department')!=0
        		  &&partyId.indexOf('Multidepartment')!=0&&partyId.indexOf('Account')!=0
        		  &&partyId.indexOf('Multiaccount')!=0){
            $("#single_mode").attr("disabled","disabled");
            $("#multiple_mode").attr("disabled","disabled");
            $("#all_mode").attr("disabled","disabled");
            $("#competition_mode").attr("disabled","disabled");
          }
        }
      }
  }
 else if(partyType == "WFDynamicForm"){
     if(partyId.indexOf("Member@")!=-1){
         $("#single_mode").attr("disabled","disabled");
         $("#multiple_mode").attr("disabled","disabled");
         $("#all_mode").attr("disabled","disabled");
         $("#competition_mode").attr("disabled","disabled");
     }
 }
  var objvalue= $("#operations").val();
  if(objvalue){
    var myFormViewId= objvalue.split("|")[0];
    $("#formview_checkbox_"+myFormViewId).attr("disabled","disabled");
    $("#formview_checkbox_"+myFormViewId).removeAttr("checked");
    $("#operations_"+myFormViewId).attr("disabled","disabled");
  }
  
  <c:forEach items="${views}" var="entry">
      <c:forEach items="${nodeBindMutiFormViewMap[entry.id].operations }" var="myOperation" >
            <c:if test="${myOperation.value.type == 'readonly'}">
                 <c:if test="${ selectedFormViewOperationMap[myOperation.value.value] !=null}">
                       $("#operations_${entry.id}").attr("value","${myOperation.value.value}");
                 </c:if>
            </c:if>
      </c:forEach>
  </c:forEach>
  
  //部门相对角色匹配范围事件添加
  bindRoleScopeClick();
  
  showCycleRemindTr();
}

/**
 * 删除被停用的 option 节点
 * 前提：当一个自定义节点被停用后，修改有这个节点的模版流程
 * 要求：进入页面时在设置节点权限中显示这个被停用的节点，当选择其它节点后被停用的这个节点自动消失
 */
function changeIsDisplayStopNode(obj) {
    for (var i = 0 ; i < obj.options.length ; i ++) {
        if (obj.options[i].id == 'stopNode'){
          obj.remove(i);
        }
    }
    if(obj.value=="inform"){
    	var temp1 = $("#hs_type_area1"),temp2 = $("#hs_type_area2");
    	if(temp1.size()>0){
    		temp1.css("display","none");
    		temp2.css("display","none");
    	}
    	temp1 = temp2 = null;
    }else{
    	var temp1 = $("#hs_type_area1"),temp2 = $("#hs_type_area2");
    	if(temp1.size()>0){
    		temp1.css("display","");
    		temp2.css("display","");
    	}
    	temp1 = temp2 = null;
    }
}

/**
 * 超期处理动作切换
 */
function doDealTermActionChange(obj){
	if(obj.value=='1'){
		$("#workflowInfo").show();
	}else{
		$("#workflowInfo").hide();
	}
	var form = document.getElementById("selectPolicyForm");
	//checkForm(selectPolicyForm);
    var policyOptionValue = $("#policy").attr("value");
    if(policyOptionValue == "vouch"){//核定节点不允许设置自动跳过
    	if(obj.value=='2'){
    	   showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_vouch')}");
    	   obj.value='0';
    	}
    }else{
        var isPass= true;
    	if(obj.value=='2'){
    	    //var result= wfAjax.hasConditionAfterSelectNode(processXmlTemp,'${nodeId}');
    	    //if(result[0]=='true'){
    	      //showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_branch')}");
    	      //obj.value='0';
    	      //isPass= false;
    	    //}
    	    if(isPass){
              if( appName!='collaboration' && appName!='form' ){
                var result= wfAjax.isExchangeNode(appName,policyOptionValue,'${flowPermAccountId}');
                if(result[0]=='true'){//公文交换类型的节点，不允许自动跳过
                  showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_fengfa')}");
                  $("#dealTermAction").attr("value","0");
                }
              }
            }
    	}
    }
    showCycleRemindTr();
}

var selectPeopleForTheNode_value= "${dealTermUserNameForSelectPeopleDisplay}";
/**
 * 指定给人员：调用选人控件
 */
function selectPeopleForTheNode(){
  $.selectPeople({
    type:'selectPeople',
    targetWindow:getCtpTop(),
    panels:'Department,Post,Team,Node',
    selectType:'Member,Node',
    showFlowTypeRadio: false,
	extParameters: 'replace',
	isNeedCheckLevelScope:false,
	isConfirmExcludeSubDepartment:true,
    maxSize:1,
    minSize:1,
    params : {
      value: selectPeopleForTheNode_value
    },
    callback:function(ret){
      if(ret.obj){
          selectPeopleForTheNode_value= ret.value;
    	  setPeopleFieldsOfDealTerm(ret.obj);
      }
    }
  });
}

/**
 * 将选人控件返回的值写到当前页面隐藏域中
 */
function setPeopleFieldsOfDealTerm(elements){
	if (!elements) {
        return false;
    }
	var person = elements[0] || [];
	var str="";
	//alert(person.type+";"+person.id+";"+person.name);
    var dealTermUserId_temp= person.id;
	if(person.id=="CurrentNodeDeptMember" //当前节点部门成员
	    || person.id=="CurrentNodeSuperDeptDeptMember"//当前节点上级部门成员
	  || person.id=="SenderDeptMember" //发起者部门成员
	    || person.id=="NodeUserDeptMember"//上节点部门成员 
	      || person.id=="SenderSuperDeptDeptMember"//发起者上级部门部门成员
	        || person.id=="NodeUserSuperDeptDeptMember"//上节点上级部门部门成员
	    ){
		if(person.excludeChildDepartment==true){//不包含子部门
			dealTermUserId_temp += "|0";
		}else{//包含子部门
			dealTermUserId_temp += "|1";
		}
	}
	str += '<input type="hidden" name="dealTermUserType" value="' + person.type + '" />';
       str += '<input type="hidden" id="dealTermUserId" name="dealTermUserId" value="' + dealTermUserId_temp + '" />';
       str += '<input type="hidden" id="dealTermUserName" name="dealTermUserName" value="' + escapeStringToHTML(person.name) + '" />';
       str += '<input type="hidden" name="dealTermAccountId" value="' + person.accountId + '" />';
       str += '<input type="hidden" id="dealTermAccountShortname" name="dealTermAccountShortname" value="' + escapeStringToHTML(person.accountShortname) + '" />';
       
	document.getElementById("workflowInfo_pepole_inputs").innerHTML= str;
	if(escapeStringToHTML(person.accountShortname)!=''){
		document.getElementById("workflowInfo").value=escapeStringToHTML(person.name)+"("+escapeStringToHTML(person.accountShortname)+")";
	}else{
		document.getElementById("workflowInfo").value=escapeStringToHTML(person.name);
	}
}
	
/**
 * 将字符串转换成HTML代码
 */
function escapeStringToHTML(str, isEscapeSpace){
    if(!str){
        return "";
    }
    str = str.replace(/&/g, "&amp;");
    str = str.replace(/</g, "&lt;");
    str = str.replace(/>/g, "&gt;");
    str = str.replace(/\r/g, ""); 
    str = str.replace(/\n/g, "<br/>"); 
    str = str.replace(/\'/g, "&#039;");
    str = str.replace(/"/g, "&#034;");
    
    if(typeof(isEscapeSpace) != 'undefined' && (isEscapeSpace == true || isEscapeSpace == "true")){
        str = str.replace(/ /g, "&nbsp;");
    }
    return str;
}

/**
 * 处理期限超期提醒选择事件函数
 */
function doDealRemindOnChange(obj){
    //提前提醒
    var remindTime = obj.value;
    if($("#dealTerm").val()==_dealCustom){
        var dealTerm = $("#customDealTerm").attr("value");
        var nowTime = new Date().getTime();
        var dealline = new Date();
        var temp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/g.exec(dealTerm);
        var remind = new Number(remindTime);
        if(temp && temp[0]){
            dealline.setFullYear(parseInt(temp[1], 10));
            dealline.setMonth(parseInt(temp[2], 10)-1);
            dealline.setDate(parseInt(temp[3], 10));
            dealline.setHours(parseInt(temp[4], 10));
            dealline.setMinutes(parseInt(temp[5], 10));
            var shijiancha = dealline.getTime() - nowTime;
            if(shijiancha<0 || shijiancha/1000/60<remind){
            	showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
                $("#remindTime").get(0).selectedIndex=0;
                return false;
            }
        }
    }else{
        //超期期限
        var dealTerm = $("#dealTerm").attr("value");
        var deal = new Number(dealTerm);
        var remind = new Number(remindTime);
        if(deal <= remind){
          showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
          $("#remindTime").get(0).selectedIndex=0;
          if(deal==0){
            $("#dealTermTR").hide();
            if(obj.value=='0'){
                if($("#dealTermAction")[0]){
                    $("#dealTermAction").attr("value","");
                }
                if($("#dealTermUserId")[0]){
                    $("#dealTermUserId").attr("value","");
                }
                if($("#workflowInfo")[0]){
                    $("#workflowInfo").attr("value","");
                }
            }
          }
          return false;
        }
    }
    
    showCycleRemindTr();
}

/**
 * 处理期限选择事件函数
 */
function doDealTermOnchange(obj){
	changeDealTermAction();
}

/**
 * 显示节点权限说明页面
 */
function policyExplain(){
    var dialog = $.dialog({
        url : '<c:url value="${nodePolicyExplainUrl}"/>',
        transParams : window,
        width : 295,
        height : 275,
        minParam:{show:false},
        maxParam:{show:false},
        title : '${ctp:i18n("node.policy.explain")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.ok.label") }',
                handler : function(){
                    dialog.transParams = null;
                    dialog.close();
            }}
        ],
        targetWindow: getCtpTop()
    });
}

function showMatchScopeExplain(type){
  var dialog = $.dialog({
    url : '<c:url value="/workflow/designer.do?method=showMatchScopeExplain&isGroup=${isGroupVersion}&type="/>'+type,
    transParams : window,
    width : 295,
    height : 275,
    minParam:{show:false},
    maxParam:{show:false},
    title : '${ctp:i18n("node.policy.match.scope.explain")}',
    buttons : [
        {
            text : '${ctp:i18n("common.button.ok.label") }',
            handler : function(){
                dialog.transParams = null;
                dialog.close();
        }}
    ],
    targetWindow: getCtpTop()
});
}

function isIncludeChildDepartment(obj){
  var value= obj.value;
  var fType= $(obj).find("option:selected").attr("formFieldType");
  if(value==''){
    $(obj).attr('title','');
  }else{
    $(obj).attr('title',$(obj).find("option:selected").attr("title"));
  }
  if(fType=='department'||fType=='multidepartment'){//单部门和多部门时，弹出确认对话框
	  if("${isExternalType}"=="false"){
	    var random = $.messageBox({
	      'title': "${ctp:i18n('workflow.label.dialog.confimTitle')}",//'确认对话框',
	      'type': 100,
	      'msg': '${ctp:i18n('workflow.designer.isIncludeChild')}',//是否包含子部门?
	      'imgType':'4',
	      buttons: [{
	      id:'include',
	          text: "${ctp:i18n('workflow.designer.include')}",//包含
	          handler: function () { 
	            $("#isProIncludeChild").attr("value","true");
	            $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.includeChildren')})"); //包含子部门
	          }
	      }, {
	      id:'exclude',
	          text: "${ctp:i18n('workflow.designer.exclude')}",//不包含
	          handler: function () {
	            $("#isProIncludeChild").attr("value","false");
	            $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.excludeChildren')})");//不包含子部门
	          }
	      }, {
	        id:'cancle',
	        text: "${ctp:i18n('workflow.designer.button.cancel')}",//取消
	        handler: function () {
	          $("#isProIncludeChild").attr("value","false");
	          $("#isIncludeChildInfo").text("");
	          obj.value= "";
	        }
	    }]
	    });
	  }else{
		  $("#isProIncludeChild").attr("value","true");
		  //$("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.includeChildren')})"); //包含子部门
	  }
  }else{
    $("#isProIncludeChild").attr("value","false");
    $("#isIncludeChildInfo").text("");
  }
}

/**
 * 显示提示信息
 */
function showFlashAlert(args) {
  try{
    var alert = $.alert(args);
  }catch(e){
    alert(args);
  }
}

function showDepartmentPostAutoUpIdLabel(code){
  
  if('NoSub' == code){
      document.getElementById("departmentPostAutoUpIdLabel").style.display="none";
      document.getElementById("departmentPostAutoUpIdLabelNoSub").style.display="";
  }else{
      document.getElementById("departmentPostAutoUpIdLabel").style.display="";
      document.getElementById("departmentPostAutoUpIdLabelNoSub").style.display="none";
  }
}
//单位岗和
function clickDeptPostAutoUp(obj){
    
    var checkState = obj.checked;
    var e1 = document.getElementById("departmentPostAutoUpId");
    var e2 = document.getElementById("departmentPostAutoUpIdNoSub");
    if(e1){
        e1.checked = checkState;
    }
    if(e2){
        e2.checked = checkState;
    }
}

function hiddenDepartmentPostAutoUpIdLabel(){
  document.getElementById("departmentPostAutoUpIdLabel").style.display="none";
  document.getElementById("departmentPostAutoUpIdLabelNoSub").style.display="none";
}

function showNouserActionTitle(_this){
  //do nothing
  
  if( appName == 'collaboration' || appName == 'form' ){
	  var $naIgnoreBlank, $naAsBlankNode;
	  $naAsBlankNode = $("#na_ignoreBlank");
	  $naIgnoreBlank = $("#na_asBlankNode");
	  if(_this.value == "2"){//无人时自动跳过
	      $naAsBlankNode.removeClass("display_none");
	      $naIgnoreBlank.removeClass("display_none");
	  }else{
	      $naAsBlankNode.addClass("display_none");
	      $naIgnoreBlank.addClass("display_none");
	  }
  }
}
/** 点击按照空节点匹配  **/
function _checkNaAsBlankNode(_this){
    
    var $ignoreBlank = $("#ignoreBlank");
    if(_this.checked){
        $ignoreBlank.attr("checked", true);
        $ignoreBlank.attr("disabled", true);
    }else{
        $ignoreBlank.attr("disabled", false);
    }
}

function openEventAdvancedSetting(){
	var nodeId = "${nodeId}";
	var dialogWidth = "500";
	if(nodeId != "start"){
		dialogWidth = "700";
	}
	var dialog = $.dialog({
		id:"workflow_dialog_advancedSetting_id",
		url: _ctxPath + "/workflow/designer.do?method=advancedSetting&appName=${appName}&from=node&nodeId=${nodeId}",
		title : "${ctp:i18n('workflow.advance.event.name')}",//"开发高级",
		width :800,
		height:400,
		transParams:{
			"process_event":$("#process_event").val()
		},
		targetWindow:getCtpTop(),
		buttons : [ {
			text : $.i18n("common.button.ok.label"),
		    id:"workflowEventAdvancedSetting",
		    handler : function() {
				var returnValue=dialog.getReturnValue();
			    if(returnValue == "error"){
				    return;
			    }
			    $("#process_event").val(returnValue);
			    dialog.close();
		    }
		}, {
			text : $.i18n("common.button.delete.label"),
            handler : function(){
				$("#process_event").val("");
				dialog.close();
			}
		}, {
		      text : $.i18n("common.button.cancel.label"),
		      id:"exit",
		      handler : function() {
		        dialog.close();
		      }
	    }]
	});
}

function disableMyReadView(obj){
	<c:if test="${!empty nodeBindMutiFormViewMap && nodeType!='StartNode'}">
		<c:forEach items="${nodeBindMutiFormViewMap}" var="entry">
			$("#formview_checkbox_${entry.key}").removeAttr("disabled");
			$("#operations_${entry.key}").removeAttr("disabled");
			enableMyOperations($("#formview_checkbox_${entry.key}")[0]);
		</c:forEach>
	</c:if>
	if(obj && obj.value){
	  var objvalue= obj.value;
      var myFormViewId= objvalue.split("|")[0];
      $("#formview_checkbox_"+myFormViewId).attr("disabled","disabled");
      $("#formview_checkbox_"+myFormViewId).removeAttr("checked");
      $("#operations_"+myFormViewId).attr("disabled","disabled");
	}
}

function enableMyOperations(obj){
  var myId= obj.value;
  if(obj.checked){
    $("#operations_"+myId).removeAttr("disabled");
  }else{
    $("#operations_"+myId).attr("disabled","disabled");
  }
  
}
function bindQueryFunc(){
	bindFunction("${ctp:i18n('workflow.designer.node.bindq')}", "${queryType}", $("#bindQuerys").val(),function(obj){
		$("#bindQuerys").val(obj.ids);
		if(obj.ids==null || obj.ids==""){
			$("#bindQuerysText").val("<${ctp:i18n('workflow.designer.node.plseq')}>");
		}else{
			$("#bindQuerysText").val(obj.names).attr("title", obj.names);
		}
	});
}
function bindCountFunc(){
	bindFunction("${ctp:i18n('workflow.designer.node.binds')}", "${statisticsType}", $("#bindCounts").val(),function(obj){
        $("#bindCounts").val(obj.ids);
        if(obj.ids==null || obj.ids==""){
            $("#bindCountsText").val("<${ctp:i18n('workflow.designer.node.plses')}>");
        }else{
        	$("#bindCountsText").val(obj.names).attr("title", obj.names);
        }
    });
}
function bindFunction(title, type, selectedIds, callBack){
	var formApp = "${formApp}";
	var url = '<c:url value="/workflow/designer.do?method=propertyBind&type="/>'+type+"&formApp="+formApp+"&selectedIds="+selectedIds;
	var dialog = $.dialog({
	    url : url,
	    transParams : {},
	    width : 635,
	    height : 375,
	    minParam:{show:false},
	    maxParam:{show:false},
	    title : title,
	    buttons : [
	        {
	            text : '${ctp:i18n("common.button.ok.label") }',
	            handler : function(){
	                var returnValue=dialog.getReturnValue();
	                try{
	                	returnValue = $.parseJSON(returnValue);
                	}catch(e){}
	                if(returnValue==null || returnValue.success==false){
	                    return;
	                }
	                callBack(returnValue);
                    dialog.transParams = null;
	                dialog.close();
                }
            },{
            	text : '${ctp:i18n("common.button.cancel.label") }',
            	handler : function(){
            		dialog.close();
            	}
            }
	    ],
	    targetWindow: getCtpTop()
	});
}

//ready


</script>
</body>
</html>