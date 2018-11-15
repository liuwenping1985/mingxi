<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title></title>
</head>
<body class="page_color">
<div id="layout">
	<div class="layout_center bg_color_white" id="center">
		<input id="tempMsg" type="hidden">
		<form action="${path }/form/triggerDesign.do?method=saveTrigger" id="saveForm">
			<div class="form_area padding_tb_5 padding_l_10" id="form">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label') }:</label>
						</th>
						<td width="400">
							<div class="common_txtbox_wrap">
								<input type="text" id="formTitle" readonly="readonly" class="w100b" value="${formBean.formName }" />
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="layout clearfix code_list padding_t_5 padding_l_10">
				<div class="col2" id="triggerSet" style="float: left">
					<div class="common_txtbox clearfix margin_b_5">
						<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.trigger.automatic.setting.label') }:</label>
						<a class="common_button common_button_gray" href="javascript:void(0)" id="newTrigger">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
					</div>
					<fieldset class="form_area" id="fieldsetArea">
						<div id="fillFormBase">
							<fieldset class="form_area">
								<legend>${ctp:i18n('form.trigger.automatic.definition.label') }</legend>
								<table width="100%" height="67" border="0" cellpadding="0" cellspacing="0" id="triggerNameSet">
									<tr>
										<td width="4%" rowspan="2"></td>
										<td width="22%" align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.name.label') }：</td>
										<td nowrap="nowrap">
											<div id="triggerNameDiv" style="width: 180px;">
												<input type="hidden" id="triggerId" name="triggerId" value="">
												<input type="hidden" id="triggerType" name="triggerType" value="4">
												<div class="common_txtbox_wrap">
													<input type="text" id="triggerName" name="triggerName" readonly="readonly" maxlength="80" class="validate" validate="notNullWithoutTrim:true,name:'${ctp:i18n('form.trigger.triggerSet.name.label') }',type:'string',notNull:true,character:'\&#39;&quot;&lt;&gt;'">
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.state.label') }：</td>
										<td nowrap="nowrap">
											<input type="hidden" id="state" value="1" forChecked="true">
											<div class="common_radio_box clearfix">
												<label class="margin_r_10 hand" for="status1">
													<input type="radio" class="radio_com" name="state" checkId="state" id="status1" value="1" checked="checked" />${ctp:i18n('form.enable.label' )}
												</label>
												<label class="margin_r_10 hand" for="status2">
													<input type="radio" class="radio_com" name="state" checkId="state" id="status2" value="0" />${ctp:i18n('form.stop.label' )}
												</label>
											</div>
										</td>
									</tr>
								</table>
							</fieldset>
							<fieldset class="form_area padding_5 margin_t_10">
								<legend>${ctp:i18n('form.trigger.triggerSet.conditions.label') }</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" height="65px;" id="triggerConditionSet">
									<tr>
										<td width="4%"rowspan="2"></td>
										<td width="22%" align="right" nowrap="nowrap"><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}：</td>
										<td nowrap="nowrap">
											<input type="hidden" id="dotConditionValue">
											<input type="hidden" id="fieldConditionId">
											<input type="hidden" id="fieldConditionFormulaId">
											<div class="clearfix">
												<div class="common_txtbox_wrap left" style="width: 160px; text-align: left; padding: 0px;">
													<textarea id="fieldConditionValue" style="width: 100%; height: 35px; border: 0px;" class="valign_m" name="fieldConditionValue" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
												</div>
												<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" onclick="setTriggerCondition4Auto(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
											</div>
										</td>
									</tr>
									<c:if test="${formBean.formType != 1 }">
									<tr id="triggerTimeQuartz">
										<td align="right" nowrap="nowrap">
											<label><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.timeScheduling.label')}：</label>
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
								<tr>
									<td>
										<table width="100%" height="80" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td width="4%" rowspan="4"></td>
												<td width="22%" align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.type.label')}：</td>
												<td nowrap="nowrap">
													<select id="actionTypeInit" class="" disabled="disabled" style="width: 160px;">
														<c:forEach var="action" items="${actionList }" varStatus="status">
															<option <c:if test="${status.index eq 0 }">selected="selected"</c:if> value="${action.id }">${action.name }</option>
														</c:forEach>
													</select>
												</td>
											</tr>
											<tr>
												<td align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.automatic.rule.label')}：</td>
												<td nowrap="nowrap">
													<div class="clearfix">
														<div class="common_txtbox_wrap left" style="width: 160px;text-align: left;padding: 0px;display: none">
															<textarea id="ruleValue" style="width: 100%;height: 35px;border: 0px;" class="valign_m" name="ruleValue" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
														</div>
														<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)"  onclick="setTriggerCondition(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
													</div>
												</td>
											</tr>
										</table>
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
						<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.trigger.automatic.list.label')}:</label>
						<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateTrigger">${ctp:i18n('common.button.modify.label') }</a>
						<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delTrigger">${ctp:i18n('common.button.delete.label') }</a>
					</div>
					<table id="triggerListTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
						<thead>
						<tr>
							<th width="15">
								<input type="checkbox" onclick="selectAll(this,'triggerListTable')" />
							</th>
							<th width="70%">${ctp:i18n('form.trigger.automatic.name.label')}</th>
							<th width="30%">${ctp:i18n('form.trigger.triggerSet.state.label')}</th>
						</tr>
						</thead>
						<tbody id="triggerBody">
						<c:set var="counts" value="0"></c:set>
						<c:forEach var="trigger" items="${formBean.triggerList }" varStatus="status">
							<c:if test="${trigger.type==type && empty trigger.formTriggerId}">
								<tr class="hand <c:if test="${(counts % 2)==1 }">erow</c:if>">
									<td id="selectBox">
										<input type="checkbox" value="${trigger.id }" />
									</td>
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
<table width="100%" border="0" cellspacing="0" style="display: none">
	<tr id="cloneRow" onmousedown="currentTr=$(this)">
		<td>
			<table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
				<tr id="label" style="height:25px">
					<td width="4%" rowspan="4">
						<!--
						<br /><br />
						<div id="addRow" onclick="addRow(this)"><span class="ico16 repeater_plus_16"></span></div>
						<br /><br />
						<div id="delRow" onclick="delRow(this)"><span class="ico16 revoked_process_16 repeater_reduce_16"></span></div>
						<br /><br />
						-->
					</td>
					<td width="22%" align="right" nowrap="nowrap">
						<span id="actionTypeLabel">${ctp:i18n('form.trigger.triggerSet.type.label')}：</span>
					</td>
					<input type="hidden" id="actionId" />
					<td nowrap="nowrap">
						<div id="actionTypeTd">
							<select class="" id="actionType" style="width: 160px;">
								<c:forEach var="action" items="${actionList }" varStatus="status">
									<option <c:if test="${status.index eq 0 }">selected="selected"</c:if> value="${action.id }">${action.name }</option>
								</c:forEach>
							</select>
						</div>
					</td>
				</tr>
				<tr class="billOuter hidden" style="height:45px">
					<td align="right" nowrap="nowrap">
						<font color="red">*</font><span id="flowLabel">${ctp:i18n('form.trigger.automatic.billtarget.label')}</span>：
					</td>
					<td nowrap="nowrap">
						<div class="clearfix">
							<div class="common_txtbox_wrap left" style="width: 160px;text-align: left;padding: 0px;">
								<input type="hidden" id="targetbillValue" />
								<textarea id="formulaDisplay" style="width: 100%;height: 35px;border: 0px;" class="valign_m" name="formulaDisplay" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
							</div>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)"  id="targetbillSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
						</div>
					</td>
				</tr>
				<tr class="billOuter hidden" style="height:45px">
					<td align="right" nowrap="nowrap">
						<font color="red"></font><span id="repeatRowLoactionLabel">${ctp:i18n('form.trigger.automatic.repeatrowlocation.label')}</span>：
					</td>
					<td nowrap="nowrap">
						<div class="clearfix">
							<div class="common_txtbox_wrap left" style="width: 160px;text-align: left;padding: 0px;">
								<input type="hidden" id="repeatRowLoactionKey" name="repeatRowLoactionKey" />
								<input type="text" id="repeatRowLoactionValue" name="repeatRowLoactionValue"  style="margin-top: 3px;" readonly mytype="12" />
							</div>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="repeatRowLoactionSet" >${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
						</div>
					</td>
				</tr>
				<tr>
					<td align="right" nowrap="nowrap" style="height:45px" id="ruleLabel">
						<font color="red">*</font>${ctp:i18n('form.trigger.automatic.rule.label')}：
					</td>
					<td nowrap="nowrap">
						<input type="hidden" id="formId" value="${formBean.id}"/>
						<div class="clearfix">
							<div class="common_txtbox_wrap left" style="width: 160px;text-align: left;padding: 0px;display: none" >
								<textarea id="ruleValue2" style="width: 100%;height: 35px;border: 0px;" class="valign_m" name="ruleValue2" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
							</div>
							<input id="fillBackType" type="hidden" />
							<input id="fillBackKey" type="hidden" />
							<input id="fillBackValue" type="hidden" />
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="ruleSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
						</div>
					</td>
				</tr>
			</table>
			<p />
		</td>
	</tr>
</table>
</body>
<%@ include file="automaticDesign.js.jsp" %>
<%@ include file="../../common/common.js.jsp" %>
</html>