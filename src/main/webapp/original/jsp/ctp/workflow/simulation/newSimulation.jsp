<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/component/formFieldConditionComp.js.jsp" %>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="${path}/common/workflow/simulation/js/newSimulation.js${ctp:resSuffix()}"></script>
<link rel="stylesheet" href="${path}/common/workflow/simulation/css/simulation.css${ctp:resSuffix()}">
<title>${ctp:i18n("simulation.page.label.newWorkFlowSimulation")}</title>
<script type="text/javascript">
var simulationId = "${simulation.id}";
</script>
</head>
<body class="h100b">
	<div id="newDiv">
	      <div class="basiciInformation">
                    <div class="head">${ctp:i18n("simulation.page.label.baseMessage")}</div>
                    <div class="bi_bottom" id="simulationBasiciInformation">
                        <table class="bi_table1">
                            <tbody>
                                <tr>
                                    <td class="table_font"><span>${ctp:i18n("simulation.page.label.caseName.js")}</span></td>
                                    <td colspan="3">
                                    	 <input type="hidden" id="id" name="id" value="${simulation.id}"/>
	                   					 <input type="hidden" id="openFrom" name="openFrom" value="${openFrom}"/>
	                      				 <input type="hidden" id="disable" name="disabled" value="${disable}"/>
	                      				 <textarea style="display: none" id="allNodeName" name="allNodeName" >${allNodeName}</textarea>
	                      				 <input type="hidden" id="formId"  name="formId" value="${simulation.conditionValueVO.formId }"/>
	                      				 <input type="hidden" id="formName"  name="formName" value="${simulation.conditionValueVO.formName }"/>
	                      				 <input type="hidden" id="reportId"  name="reportId" value="${simulation.reportId }"/>
	                      				 <input type="hidden" id="recentStateVal"  name="recentStateVal" value="${simulation.recentStateVal }"/>
                                    	 <input class="bi_input_size" type="text" id="code"  name="code" value="${ctp:toHTMLWithoutSpace(simulation.code)}"/>
                                    
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="bi_table2">
                            <tbody>
                                <tr>
                                    <td class="table_font promoter">
                                        <span>${ctp:i18n("simulation.page.label.startMember.js")}</span>
                                    </td>
                                    <td class="proInput">
                                    	 <input type="hidden" id="startMemberId" name="startMemberId" value="${simulation.conditionValueVO.startMemberId}"/>
                                    	<input class="bi_input_size1" type="text" id="startMemberName" name="startMemberName" value="${ctp:showMemberName(simulation.conditionValueVO.startMemberId)}"/>
                                    </td>
                                    <td colspan="2">
                                        <span>${ctp:i18n("simulation.page.label.loginAccount.js")}</span>
                                        <input type="hidden" id="selectStartAccountId" name="selectStartAccountId" value="${simulation.conditionValueVO.startAccountId}"/>
                                        <select class="bi_input_size1" id="startAccountId" name= "startAccountId">
                                            
                                        </select>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <c:if test="${simulation.conditionValueVO.hasBrancher or simulation.conditionValueVO.hasDynamicFormFields or  simulation.conditionValueVO.hasRepeatRecoder}">
                <div class="formCondition" id = "formFieldSet" >
                    <div class="head">${ctp:i18n("simulation.page.label.formFiledBranch")}</div>
                    <div class="fc_bottom" >
                    	<c:if test="${simulation.conditionValueVO.hasBrancher}">
                        <fieldset id="formMainFieldSet" >
                            <legend>${ctp:i18n("simulation.page.label.formMainFiled")}</legend>
                            <table class="fc_left" id="branchTable">
                                <tbody>
                                <c:forEach  begin="1" end="${fn:length(simulation.conditionValueVO.brancher)/2+1}" step="1" varStatus="vs">
                                    <tr>
                                         <c:forEach var="item" items="${simulation.conditionValueVO.brancher}" begin="${vs.count*2-2}" end="${vs.count*2-1}" step="1">
                                         	<td class="table_font td_width">
                                            	 ${item.display}
	                                        </td>
	                                        <td class="formField" data="${item.data}">
	                                            
	                                        </td>
                                         </c:forEach>
                                    </tr>
                              	</c:forEach>
                                </tbody>
                            </table>
                        </fieldset>
                        </c:if>
                        <c:if test="${simulation.conditionValueVO.hasRepeatRecoder}">
						<fieldset id="formSonFieldSet" >
                            <legend>${ctp:i18n("simulation.page.label.formSonFiled")}</legend>
                            <table class="fc_left" id="repeatTable">
                                <tbody>
                                <c:forEach items="${simulation.conditionValueVO.repeatRecoder}" varStatus="state" var="repeatRecoder">
	                                    <tr class="repeatFiledTr${repeatRecoder.value[0].ownerTableName}">
                                    		<c:forEach items="${repeatRecoder.value}" varStatus="state" var="repeat">
		                                       <td class="table_font td_width">
	                                          	  ${repeat.display}
	                                       	   </td>
	                                           <td class="fc_input_size formField" data="${repeat.data}">
	                                            	
	                                            </td>
                                    		</c:forEach>
                                    		<td class="table_font td_width">
	                                            	<span class="delButton repeater_reduce_16 ico16 revoked_process_16"  onclick="removeChartTr(this);"></span>
	                                            	<span class="addButton repeater_plus_16 ico16"  onclick="insertChartTr(this);"></span>
	                                            </td>
	                                    </tr>
	                                    <th></th>
                                </c:forEach>    
                                </tbody>
                            </table>
                        </fieldset>
                        </c:if>
                        <c:if test="${simulation.conditionValueVO.hasDynamicFormFields}">
                        <fieldset id="formMainFieldSet" >
                            <legend>${ctp:i18n("simulation.page.label.dynamicformFiled")}</legend>
                            <table class="fc_left" id="dynamicMatchTable">
                                <tbody>
                                <c:forEach  begin="1" end="${fn:length(simulation.conditionValueVO.dynamicFormFields)/2+1}" step="1" varStatus="vs">
                                    <tr>
                                         <c:forEach var="item" items="${simulation.conditionValueVO.dynamicFormFields}" begin="${vs.count*2-2}" end="${vs.count*2-1}" step="1">
                                         	<td class="table_font td_width">
                                            	 ${item.display}
	                                        </td>
	                                        <td class="formField" data="${item.data}">
	                                            
	                                        </td>
                                         </c:forEach>
                                    </tr>
                              	</c:forEach>
                                </tbody>
                            </table>
                        </fieldset>
                        </c:if>
                    </div>
                </div>
                </c:if>
                <div class="runningProcess" id="childFieldSet" style="display:none;">
                    <div class="head">${ctp:i18n("simulation.page.label.runningSelectData")}</div>
                    <div class="rp_bottom" id="childField">
                        <table id="workflowMatchResultTable">
                            <tbody>
                        	<c:forEach items="${simulation.conditionValueVO.simulationMatchs}" varStatus="state" var="matchResult">
                                <tr id="matchResultTr${state.index}">
                                	<th width="0px">
										<div id="workflow_definition${state.index}"  style="display: none">
										    <input type="hidden" id="process_xml">
										    <input type="hidden" id="id" value="${matchResult.id}">
										    <textarea style="display:none" id="cpMatchResultVO" >${matchResult.matchResult}</textarea>
										    <input type="hidden" id="readyObjectJSON">
										    <input type="hidden" id="workflow_data_flag" name="workflow_data_flag" value="WORKFLOW_SEEYON">
										    <input type="hidden" id="process_subsetting">
										    <input type="hidden" id="workflow_newflow_input">
										    <input type="hidden" id="workflow_node_peoples_input">
										    <input type="hidden" id="workflow_node_condition_input">
										    <input type="hidden" id="workflow_node_peoples_name_input">
										    <textarea style="display:none" id="selectData" >${matchResult.selectData}</textarea>
										    <input type="hidden" id="currentNodeId" value="${matchResult.activityId}">
										    <input type="hidden" id="processChangeMessage">
										    <input type="hidden" id="sortId" value="${matchResult.sortId }">
										    <input type="hidden" id="matchDesc" value="${matchResult.matchDesc }">
										    <input type="hidden" id="canExcute" value="${matchResult.simulationData.canExcute}">
										    <input type="hidden" id="currentUserId" value="${matchResult.currentUserId}">
										</div>
									</th>
                                    <td><span class="rp_bottom_span span-ellipsis" style="width:275px!important;" id="nodeName${state.index}"></span></td>
                                    <td>
                                    	<input class="rp_input_size" type="text" data="${state.index}" id="selectBranch${state.index}" name="selectBranch">
                                    	<label title="${ctp:i18n('simulation.page.label.showWorkflow.js')}" class="right valign_m margin_t_5 margin_l_5 ico16 process_max_16" id="showWorkflow${state.index}"></label>
                                    </td>
                                </tr>
                            </c:forEach>    
                            </tbody>
                        </table>
                    </div>
                </div>
      </div>          
</body>
</html>