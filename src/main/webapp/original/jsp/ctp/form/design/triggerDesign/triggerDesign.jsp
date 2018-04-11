<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>form</title>
	<script type="text/javascript" src="${path}/ajax.do?managerName=formTriggerDesignManager,formManager"></script>
</head>
<body class="page_color">
<div id='layout'>
	<div class="layout_center bg_color_white" id="center">
		<input id="tempMsg" type="hidden">
		<form action="${path }/form/triggerDesign.do?method=saveTrigger" id="saveForm">
			<div class="form_area padding_tb_5 padding_l_10" id="form">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label') }:</label></th>
						<td width="400">
							<DIV class=common_txtbox_wrap><input readonly="readonly" type="text" id="formTitle" class="w100b" value="${formBean.formName }"/></DIV>
						</td>
					</tr>
					<!-- 将非标准触发的url存起来 -->
					<tr class="hidden">
						<td>
							<c:forEach var="actionDesign" items="${actionList}" varStatus="ssss">
								<c:if test="${!(empty actionDesign.configPageURL) && actionDesign.standardFlag eq false}">
									<c:set var="actionDesignConfigPageURL" value="${actionDesign.configPageURL}&formId=${formBean.id}" />
									<c:if test="${fn:indexOf(actionDesign.configPageURL, '?') eq -1}">
										<c:set var="actionDesignConfigPageURL" value="${actionDesign.configPageURL}?formId=${formBean.id}" />
									</c:if>
									<input id="actionDesignUrl_${actionDesign.id}" name="actionDesignUrl_${actionDesign.id}" type="hidden" value="${actionDesignConfigPageURL}">
								</c:if>
							</c:forEach>
						</td>
					</tr>
				</table>
			</div>
			<!--左右布局-->
			<div class="layout clearfix code_list padding_t_5 padding_l_10">
				<div class="col2" id="triggerSet" style="float: left">
					<div class="common_txtbox clearfix margin_b_5">
						<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.pagesign.trigger.label') }:</label>
						<a class="common_button common_button_gray" href="javascript:void(0)" id="newTrigger">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
					</div>
					<fieldset class="form_area" id="fieldsetArea">
						<div id="fillFormBase">
							<fieldset class="form_area" id="">
								<legend>${ctp:i18n('form.trigger.triggerSet.definition.label') }</legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0" height="67px;" id="triggerNameSet">
									<tr>
										<td align="left" rowspan="3" width="4%"></td>
										<td width="22%" align="right" nowrap="nowrap">
											<label class="" for="text"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.name.label') }：</label>
										</td>
										<td nowrap="nowrap">
											<div id ="triggerNameDiv" class=" w200" style="width: 180px;">
												<input id="triggerId" name="triggerId" type="hidden" value="-1">
												<input id="triggerType" name="triggerType" type="hidden" value="1">
												<div class="common_txtbox_wrap">
													<input id="triggerName" name="triggerName" type="text" readonly="readonly" maxlength="80" class="validate" validate="notNullWithoutTrim:true,name:'${ctp:i18n('form.trigger.triggerSet.name.label') }',type:'string',notNull:true,character:'\&#39;&quot;&lt;&gt;'">
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td align="right" nowrap="nowrap">
											<label class="" for="text"><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.state.label') }：</label>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" id="state" value="1" forChecked="true">
											<div class="common_radio_box clearfix">
												<label class="margin_r_10 hand" for="status1"><input class="radio_com" type="radio" value="1" checkId="state" checked="checked" id="status1" name="state">${ctp:i18n('form.enable.label' )}</label>&nbsp;&nbsp;&nbsp;
												<label class="margin_r_10 hand" for="status2"><input class="radio_com" type="radio" value="0" checkId="state" id="status2" name="state" >${ctp:i18n('form.stop.label' )}</label>
											</div>
										</td>
									</tr>
									<c:if test="${type==fillBackType }">
									<tr>
										<td align="right" nowrap="nowrap">
											<label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.fillback.template') }：</label>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" id="relationFormId">
											<input type="hidden" id="sourceType">
											<input type="hidden" id="follBackFormulaId">
											<select id="relationForm">
												<option value=""></option>
												<option value="ad" formulaId=""  formId="">${ctp:i18n('form.trigger.triggerSet.fillback.template.no') }</option>
											</select>
											<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									</c:if>
								</table>
							</fieldset>
							<fieldset class="form_area padding_5 margin_t_10">
								<legend>${ctp:i18n('form.trigger.triggerSet.conditions.label') }</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" height="65px;" id="triggerConditionSet">
									<tr>
										<td align="left" rowspan="3" width="4%"></td>
										<td width="22%" align="right" nowrap="nowrap">
											<label><font color="red">*</font></label>${ctp:i18n('form.trigger.triggerSet.triggerPoint.label')}：
										</td>
										<td nowrap="nowrap">
											<input type="hidden" id="dotConditionId">
											<input type="hidden" id="dotConditionValue" value="1" forChecked="true">
											<div class="common_radio_box clearfix" style="margin-bottom: 5px;line-height: 20px;">
												<c:if test="${formBean.formType == 1 }">
												<div class="left" style="margin-right: 5px;">
													<label class="margin_r_10 hand" for="triggerDot1"><input class="radio_com" value="1" type="radio" id="triggerDot1" checkId="dotConditionValue" name="dotConditionValue" checked="checked">${ctp:i18n('form.trigger.triggerSet.processEnd.label')}</label>
												</div>
												<div class="left" style="margin-right: 5px;">
													<label class="margin_r_10 hand" for="triggerDot2"><input class="radio_com" type="radio" id="triggerDot2" checkId="dotConditionValue" name="dotConditionValue" value="2">${ctp:i18n('form.trigger.triggerSet.approvedBy.label')}</label>
												</div>
												<div class="left" style="margin-right: 5px;">
													<label class="margin_r_10 hand" for="triggerDot3"><input class="radio_com" type="radio" id="triggerDot3" checkId="dotConditionValue" name="dotConditionValue" value="21">${ctp:i18n('form.trigger.triggerSet.firstMet.label')}</label>
												</div>
												</c:if>
												<c:if test="${formBean.formType != 1 }">
										    	<label class="margin_r_10 hand" for="triggerDot1"><input class="radio_com" checkId="dotConditionValue" value="21" type="radio" id="triggerDot1" name="dotConditionValue" checked="checked">${ctp:i18n('form.trigger.triggerSet.firstMet.label')}</label>
												<label class="margin_r_10 hand" for="triggerDot2"><input class="radio_com" checkId="dotConditionValue" type="radio" id="triggerDot2" name="dotConditionValue" value="22">${ctp:i18n('form.trigger.triggerSet.metAgain.label')}</label>
												</c:if>
											</div>
										</td>
									</tr>
									<tr>
										<td align="right" nowrap="nowrap" valign="middle">
											<label><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}：</label>
										</td>
										<td valign="middle">
											<input type="hidden" id="fieldConditionId">
											<input type="hidden" id="fieldConditionFormulaId">
											<div class="clearfix">
												<div class="common_txtbox_wrap left" style="width: 160px;text-align: left;padding: 0px;">
													<textarea id="fieldConditionValue" style="width: 100%;height: 35px;border: 0px;" class="valign_m" name="fieldConditionValue" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
												</div>
												<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)"  onclick="setTriggerCondition(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
											</div>
											<!-- <input id="fieldValueBt" onclick="trigger_dataSet();" type="button" value="${ctp:i18n('form.trigger.triggerSet.set.label')}" class="button-style button-space" disabled="disabled"> -->
										</td>
									</tr>
									<c:if test="${formBean.formType != 1 }">
									<tr id="triggerTimeQuartz">
										<td align="right" nowrap="nowrap">
											<label><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.timeScheduling.label')}：</label>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" id="timeConditionId">
											<input type="hidden" id="timeFormulaId">
											<input id="timeQuartz" type="hidden" value="${timeQuartz }">
											<a class="common_button common_button_disable common_button_gray margin_l_5 margin_t_5" href="javascript:void(0)" id="timeSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									</c:if>
								</table>
							</fieldset>
						</div>
						<fieldset class="form_area padding_5 margin_t_10" id="actionSet">
							<legend>${ctp:i18n('form.trigger.triggerSet.actions.label') }</legend>
							<table width="100%" border="0" cellspacing="0" id="actionTable" isGrid="true">
								<tr onclick="">
									<td>
										<table width="100%" border="0" cellpadding="2" cellspacing="0" height="117px;">
											<!-- 触发类型-->
											<tr>
												<td align="left" rowspan="7" width="4%"></td>
												<td align="right" nowrap="nowrap">
													<label><font color="red"></font></label>${ctp:i18n('form.trigger.triggerSet.type.label')}：
												</td>
												<td nowrap="nowrap">
													<select id="actionTypeInit" class="" disabled="disabled" style="width: 160px;">
												    <c:forEach var="action" items="${actionList }" varStatus="status">
														<option <c:if test="${status.index eq 0 }">selected="selected"</c:if> value="${action.id }">${action.name }</option>
												    </c:forEach>
													</select>
												</td>
											</tr>
											<!-- 创建/发起人-->
											<tr>
												<td width="22%" align="right" nowrap="nowrap">
													<label><font color="red">*</font></label>${ctp:i18n('form.trigger.triggerSet.processInitiator.label')}：
												</td>
												<td nowrap="nowrap">
													<div class="clearfix">
														<div class="left" style="margin-top: 5px;margin-bottom: 5px;width: 170px;">
															<label for="memType1" style="width: 134px;">
																<input <c:if test="${formBean.formType != 1 }">style="display:none"</c:if> disabled="disabled" type="radio" checked="checked"id="memType1" name="memType" value=appoint>
																<input id="memName" readonly="readonly" name="memName" type="text" class="input" style="cursor: hand;width: ${formBean.formType eq 1 ? '140' : '160'}px;" value="${ctp:i18n('form.trigger.triggerSet.clickToPerson.label')}">
																<span style="width: 11px;display: inline-block;"></span>
															</label>
														</div>
														<c:if test="${formBean.formType == 1 }">
														<div class="left" style="margin-top: 5px;margin-bottom: 5px;width: 110px;">
															<label class="margin_r_10 hand" for="memType2">
																<input class="radio_com" disabled="disabled" type="radio" style='' id="memType2" name="memType" value="currentFlowStartMember">${ctp:i18n('form.trigger.triggerSet.currentSponsors.label')}
															</label>
															<span style="width: 5px;display: inline-block;"></span>
														</div>
														<div class="left" style="margin-top: 5px;margin-bottom: 5px;width: 100px;">
			                                        		<label id="memType3Label" for="memType3">
			                                        			<input type="radio" id="memType3" name="memType" value="currentFlowNode" checkId="entityMemType"/>
			                                        			<span id="currentNode">${ctp:i18n('form.trigger.triggerSet.unflow.triggernode')}</span>
			                                        		</label>
			                                        	</div>
														</c:if>
													</div>
												</td>
											</tr>
											<!-- 流程/无流程模板-->
											<tr>
												<td align="right" nowrap="nowrap">
													<label><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.processTemplates.label')}：</label>
												</td>
												<td nowrap="nowrap">
												    <div style="width: 180px;">
														<textarea style="width: 160px;" id="content" readonly="readonly" name="content">${ctp:i18n('form.trigger.triggerSet.clickToTemplate.label')}</textarea>
												    </div>
												</td>
											</tr>
											<!-- 数据拷贝-->
											<tr>
												<td align="right" nowrap="nowrap"><label>
													<font color="red"></font>${ctp:i18n('form.trigger.triggerSet.copyData.label')}：</label>
												</td>
												<td nowrap="nowrap"><input id="mappingId" name="mappingId" type="hidden">
													<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
												</td>
											</tr>
											<!-- 消息接收人-->
                                            <tr>
                                                <td width="22%" align="right" nowrap="nowrap"><label><font color="red">*</font></label>${ctp:i18n('form.trigger.triggerSet.msgReciever.label')}：</td>
                                                <td nowrap="nowrap">
                                                	<div style="width: 180px;">
                                                    	<input  readonly="readonly"  type="text" style="cursor: hand;width: 160px;" value="${ctp:i18n('form.trigger.triggerSet.clickToPerson.label')}" class="validate" validate="func:checkMsgMem,errorMsg:'${ctp:i18n('form.trigger.triggerSet.msgReciever.must') }'"/>
                                                	</div>
                                                	<input readonly="readonly" name="messageMem" type="hidden">
                                                </td>
                                            </tr>
											<!-- 消息模板-->
                                            <tr>
                                                <td width="22%" align="right" nowrap="nowrap"><label><font  color="red">*</font>${ctp:i18n('form.trigger.triggerSet.msgTemplates.label')}：</label></td>
                                                <td nowrap="nowrap"><input type="hidden"  />
                                                    <div style="width: 180px;">
                                                    	<textarea style="width: 160px;" readonly="readonly" class="validate" validate="name:'${ctp:i18n('form.trigger.triggerSet.msgTemplates.label') }',type:'string',notNull:true"></textarea>
                                                   </div>
                                                </td>
                                            </tr>
											<!-- dee任务-->
                                            <tr class="hidden">
                                                <td width="22%" align="right" nowrap="nowrap"><label><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.bindTask.label')}：</label></td>
                                                <td nowrap="nowrap"><input type="hidden"  />
													<input readonly="readonly" class="validate" validate="type:'string',notNull:true,errorMsg:'${ctp:i18n('form.trigger.triggerSet.taskList.must') }'"/>
												</td>
                                            </tr>
										</table>
										<p />
										<hr>
									</td>
								</tr>
							</table>
						</fieldset>
						<div align="center" id="buttonDiv" class="margin_t_5">
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveTrigger">${ctp:i18n('common.toolbar.save.label') }</a>
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="reset">${ctp:i18n('common.button.reset.label')}</a>
						</div>
					</fieldset>
				</div>
				<div class="col2 margin_l_5" style="float: left">
					<div class="common_txtbox clearfix margin_b_5">
						<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.trigger.triggerSet.triggerList.label')}:</label>
						<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateTrigger">${ctp:i18n('common.button.modify.label') }</a>
						<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delTrigger">${ctp:i18n('common.button.delete.label') }</a>
					</div>
					<table id="triggerListTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
						<thead>
							<tr>
								<th width="15"><input type="checkbox" onclick="selectAll(this,'triggerListTable')"/></th>
								<th width="70%">${ctp:i18n('form.trigger.triggerSet.triggerName.label')}</th>
								<th width="30%">${ctp:i18n('form.trigger.triggerSet.state.label')}</th>
							</tr>
						</thead>
						<tbody id="triggerBody">
						<c:set var="counts" value="0"></c:set>
						<c:forEach var="trigger" items="${formBean.triggerList }" varStatus="status">
							<c:if test="${trigger.type==type }">
							<tr class="hand <c:if test="${(counts % 2) == 1 }">erow</c:if>">
								<td id="selectBox"><input type="checkbox" value="${trigger.id }"/></td>
								<td onclick="showTrigger(this,'${trigger.id }')">${fn:escapeXml(trigger.name) }</td>
								<td onclick="showTrigger(this,'${trigger.id }')">${trigger.stateName }</td>
							</tr>
							<c:set var="counts" value="${counts + 1 }"></c:set>
							</c:if>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</form>
	</div>
	<form action="${path }/form/triggerDesign.do?method=saveTrigger" id="save"></form>
</div>
<table width="100%" border="0" cellspacing="0" style="display:none">
	<tr id="cloneRow" onmousedown="currentTr=$(this)" onmouseover="currentTr=$(this)">
		<td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" height="107px;">
				<!-- 类型 -->
				<tr id="label">
					<td align="left" rowspan="8" width="25">
						<br />
						<br />
						<a href="javascript:void(0)" onclick="addRow(this)"><span class="ico16 repeater_plus_16"></span></a>
						<br />
						<br />
						<a href="javascript:void(0)" onclick="del(this)"><span class="ico16 revoked_process_16 repeater_reduce_16"></span></a>
						<br />
						<br />
					</td>
					<td align="right" nowrap="nowrap">
						<input type="hidden" id="actionId" />
						<label><font color="red"></font></label>${ctp:i18n('form.trigger.triggerSet.type.label')}：
					</td>
					<td nowrap="nowrap">
						<select class="" id="actionType" style="width: 160px;">
							<c:forEach var="action" items="${actionList }" varStatus="status">
								<option <c:if test="${status.index eq 0 }">selected="selected"</c:if> value="${action.id }">${action.name }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<!-- 流程发起人/创建人 -->
				<tr class="flow unflow hidden">
					<td width="22%" align="right" nowrap="nowrap">
						<label><font color="red">*</font></label><span id="creator">${ctp:i18n('form.trigger.triggerSet.processInitiator.label')}</span>：
					</td>
					<td nowrap="nowrap" id="showmemtype">
						<div class="left" style="margin-top: 5px;margin-bottom: 5px;width: 162px;">
							<input type="hidden" id="entityMemType" value="appoint" forChecked="true"/>
							<div class="left">
								<label for="memType1">
									<input <c:if test="${formBean.formType != 1 }">class="hidden"</c:if> type="radio" checked="checked" id="memType1" name="memType" value="appoint" checkId="entityMemType"/>
								</label>
							</div>
							<div class="left common_txtbox_wrap">
								<input id="flowMem_txt" readonly="readonly" name="flowMem_txt" type="text" style="cursor: hand;" value="${ctp:i18n('form.trigger.triggerSet.clickToPerson.label')}" class="validate" validate="func:checkFlowMem,errorMsg:'${ctp:i18n("form.trigger.triggerSet.template.sender") }'"/>
							</div>
							<input id="flowMem" name="flowMem" type="hidden" />
						</div>
						<c:if test="${formBean.formType == 1 }">
						<!-- 当前流程发起人 -->
						<div class="left" style="margin-top: 5px;margin-bottom: 5px;width: 110px;">
							<label for="memType2">
								<input type="radio" id="memType2" name="memType" value="currentFlowStartMember" checkId="entityMemType"/>
								<span id="currentPerson">${ctp:i18n('form.trigger.triggerSet.currentSponsors.label')}</span>
							</label>
							<span style="width: 5px;display: inline-block;"></span>
						</div>
						<!-- 触发节点 -->
						<div class="left" style="margin-top: 5px;margin-bottom: 5px;width: 100px;">
							<label id="memType3Label" for="memType3">
								<input type="radio" id="memType3" name="memType" value="currentFlowNode" checkId="entityMemType"/>
								<span id="currentNode">${ctp:i18n('form.trigger.triggerSet.unflow.triggernode')}</span>
							</label>
						</div>
						</c:if>
					</td>
				</tr>
				<!-- 流程模板 -->
				<tr class="flow unflow hidden">
					<td align="right" nowrap="nowrap">
						<label><font color="red">*</font><span id="flowLabel">${ctp:i18n('form.trigger.triggerSet.processTemplates.label')}：</span></label>
					</td>
					<td >
						<input type="hidden" id="formId" />
						<input type="hidden" id="templateId" />
						<div style="width: 150px;" class="common_txtbox_wrap left">
							<textarea id="content" readonly="readonly" name="content" style="width: 100%;border: 0px;" class="validate" validate="errorMsg:'${ctp:i18n('form.trigger.triggerSet.template.notnull') }',type:'string',notNull:true,isDeaultValue:true,deaultValue:'${ctp:i18n('form.trigger.triggerSet.clickToTemplate.label')}'">${ctp:i18n('form.trigger.triggerSet.clickToTemplate.label')}</textarea>
						</div>
					</td>
				</tr>
				<!-- 数据拷贝设置 -->
				<tr class="flow unflow hidden">
					<td align="right" nowrap="nowrap">
						<label> <font color="red" id="unflowFont"></font>${ctp:i18n('form.trigger.triggerSet.copyData.label')}：</label>
					</td>
					<td nowrap="nowrap">
						<input id="fillBackType" type="hidden" />
						<input id="fillBackKey" type="hidden" />
						<input id="fillBackValue" type="hidden" />
						<input name="ConfigValue" id="ConfigValue" type="hidden" value="">
						<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="copySet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
					</td>
				</tr>
				<!-- 消息接收人 -->
				<tr class="hidden message">
					<td width="22%" align="right" nowrap="nowrap">
						<label><font color="red">*</font></label>${ctp:i18n('form.trigger.triggerSet.msgReciever.label')}：
					</td>
					<td nowrap="nowrap">
						<div style="width: 162px;">
							<div class="common_txtbox_wrap">
								<input id="messageMem_txt" readonly="readonly" name="messageMem_txt" type="text" style="cursor: hand;" value="${ctp:i18n('form.trigger.triggerSet.clickToPerson.label')}" class="validate" validate="func:checkMsgMem,errorMsg:'${ctp:i18n('form.trigger.triggerSet.msgReciever.must') }'"/>
							</div>
						</div>
						<input id="messageMem" readonly="readonly" name="messageMem" type="hidden">
					</td>
				</tr>
				<!-- 消息模板 -->
				<tr class="hidden message">
					<td width="22%" align="right" nowrap="nowrap">
						<label><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.msgTemplates.label')}：</label>
					</td>
					<td>
						<input type="hidden" id="msgId" />
						<div style="width: 180px;">
							<textarea id="msgContent" name="msgContent" style="width: 160px;" readonly="readonly" class="validate" validate="name:'${ctp:i18n('form.trigger.triggerSet.msgTemplates.label') }',type:'string',notNull:true"></textarea>
						</div>
					</td>
				</tr>
				<tr class="hidden message sms">
					<td width="22%" align="right" nowrap="nowrap"><label>${ctp:i18n('form.trigger.triggerSet.sendsms.label')}：</label></td>
					<td nowrap="nowrap" id ="smshtml">
						<div class="common_radio_box clearfix">
							<input type="hidden"  id = "sendsms" name = "sendsms" value = "false">
							<label class="margin_r_10 hand" for="sendsmsradio1"><input name="sendsmsradio" class="radio_com" id="sendsmsradio1" type="radio" value="true">${ctp:i18n('common.yes') }</label>
							<label class="margin_r_10 hand" for="sendsmsradio4"><input name="sendsmsradio" class="radio_com" id="sendsmsradio4" type="radio" value="false">${ctp:i18n('common.no') }</label>
						</div>
					</td>
				</tr>
				<tr class="hidden taskDEE">
					<td width="22%" align="right" nowrap="nowrap"><label><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.bindTask.label')}：</label></td>
					<td nowrap="nowrap"><input type="hidden" id="taskId" />
						<div style="width: 180px;">
							<input id="taskName" name="taskName" style="width: 160px;" readonly="readonly" class="validate" validate="name:'${ctp:i18n('form.trigger.triggerSet.dee.label') }',type:'string',notNull:true,errorMsg:'${ctp:i18n('form.trigger.triggerSet.taskList.must') }'"/>
						</div>
					</td>
				</tr>
				<!-- 触发预留接口 创建人员 创建会议 创建项目走的就是此处去处理 需要排除标准的触发(触发流程、存档、消息、DEE) -->
				<c:forEach var="actionDesign" items="${actionList}" varStatus="s">
					<c:if test="${!(empty actionDesign.configPageURL) && actionDesign.standardFlag eq false}">
						<tr class="hidden ${actionDesign.id}">
							<td colspan="2">
								<iframe id="DesignIframe_${actionDesign.id}" name="DesignIframe_${actionDesign.id}" src="" width="100%" height="100" frameborder="0" marginheight="0" marginwidth="0"></iframe>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</table>
			<p />
			<hr>
		</td>
	</tr>
</table>
</body>
<%@ include file="triggerDesign.js.jsp" %>
<%@ include file="../../common/common.js.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
</html>
