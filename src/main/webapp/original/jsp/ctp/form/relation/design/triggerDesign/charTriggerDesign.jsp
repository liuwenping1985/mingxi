<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>form</title>
	<script type="text/javascript" src="${path}/ajax.do?managerName=formTriggerDesignManager,formManager"></script>
	<script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
	<script>
		var formId = "${formId}";
		var type = "${type}";
		var triggerId = "${triggerId}";

		$(function () {

			$("#btnmodify").click(function () {
				relationEdit(null, formId);
			});
		});

		/**
		 * 数据过滤
		 * @param index
		 */
		function showDataFilterDetail(index){
			var triggerId = $("#triggerId" + index).val();
			messageDataFilter(formId, null, null, triggerId, "trigger", null, null, null, null);
		}


		/**
		 * 时间调度
		 * @param index
		 */
		function showTimeQuartzDetail(index) {
			var triggerId = $("#triggerId" + index).val();
			timeQuartzCondition(formId, null, null, triggerId, null, null);
		}

		/**
		 * 联动详情
		 * @param index
		 */
		function showRelationDetail(index, actionId){
			var triggerId = $("#triggerId" + index).val();
			var tarFormId = $("#tarFormId" + index).val();
			var relationType = $("#relationType" + index).val();
			copySetFunView(formId, tarFormId, actionId, triggerId, null, relationType, null, null);
		}
	</script>
</head>
<body class="page_color" style="background: #fff">
<div id='layout'>
	<div id="center" style="height:440px;overflow-y: auto;">
		<input id="tempMsg" type="hidden">

			<!--左右布局-->
			<div class="layout clearfix code_list padding_t_5 padding_l_10 margin_r_20 margin_l_10">

				<c:forEach items="${formTriggerList}" var="formTrigger" varStatus="status">
				<div id="triggerSet">
					<fieldset class="form_area" id="fieldsetArea">
						<legend style="font-size: 14px">&nbsp;&nbsp; ${formTrigger.triggerName} &nbsp;&nbsp;</legend>
						<div id="fillFormBase">
							<%-- 条件 --%>
							<fieldset class="form_area padding_5">
								<legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.conditions.label') } &nbsp;&nbsp;</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" height="95px;" id="triggerConditionSet">
									<input type="hidden" id="triggerId${status.index}" value="${formTrigger.triggerId}">
									<input type="hidden" id="srcFormId${status.index}" value="${formTrigger.srcFormId}">
									<input type="hidden" id="tarFormId${status.index}" value="${formTrigger.tarFormId}">
									<input type="hidden" id="relationId${status.index}" value="${formTrigger.relationId}">
									<%--触发点--%>
									<tr>
										<td align="left" rowspan="3" width="4%"></td>
										<td width="23%" align="right" nowrap="nowrap">
											<label>${ctp:i18n('form.trigger.triggerSet.triggerPoint.label')}：</label>
										</td>
										<td valign="middle">
											<span>${formTrigger.executePoint}</span>
										</td>
									</tr>

									<%-- 数据域 --%>

									<tr>
										<td align="right" nowrap="nowrap" valign="middle">
											<label><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}：</label>
										</td>
										<td valign="middle">
											<input type="hidden" id="fieldConditionId">
											<input type="hidden" id="fieldConditionFormulaId">
											<div class="clearfix">
												<c:if test="${formTrigger.hasDataFilter == true}">
													[<a href="javascript:void(0)" onclick="showDataFilterDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
												</c:if>
												<c:if test="${formTrigger.hasDataFilter == false}">[${ctp:i18n('form.format.flowprocessoption.none')}]</c:if>
											</div>
										</td>
									</tr>

									<%-- 时间调度 无流程触发有流程才有时间调度.需要判断表单是流程表单还是无流程表单--%>
									<c:if test="${!isFlow}">

									<tr id="triggerTimeQuartz">
										<td align="right" nowrap="nowrap">
											<label>${ctp:i18n('form.trigger.triggerSet.timeScheduling.label')}：</label>
										</td>
										<td nowrap="nowrap">
											<c:if test="${formTrigger.timeConditon eq 'false'}">
												[${ctp:i18n('form.format.flowprocessoption.none')}]
											</c:if>
											<c:if test="${formTrigger.timeConditon eq 'true'}">
												[<a href="javascript:void(0)" onclick="showTimeQuartzDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
											</c:if>
										</td>
									</tr>
									</c:if>

								</table>
							</fieldset>
						</div>


						<%-- 动作 --%>
						<fieldset class="form_area padding_5 margin_t_10 margin_b_10" id="actionSet">
							<legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.actions.label') }&nbsp;&nbsp; </legend>


							<c:forEach items="${formTrigger.actionList}" var="action" varStatus="actionStatus">
							<table width="100%" border="0" cellspacing="0" id="actionTable" isGrid="true">
								<tr onclick="">
									<td>
										<table width="100%" border="0" cellpadding="2" cellspacing="0" height="117px;">

											<%-- 触发流程和数据存档 --%>
											<%-- 显示创建人,信息表,数据拷贝--%>
											<c:if test="${action.actionType eq 'flow' or action.actionType eq 'unflow'}">
												<tr  style="line-height: 30px">

													<!-- 创建/发起人-->
													<td align="left" rowspan="3" width="4%"></td>
													<td width="23%" align="right" nowrap="nowrap">
														<c:if test="${action.actionType eq 'flow'}"><label>${ctp:i18n('form.trigger.triggerSet.processInitiator.label')}：</label></c:if>
														<c:if test="${action.actionType eq 'unflow'}"><label>${ctp:i18n('form.bizmap.creater.label')}：</label></c:if>
													</td>
													<td nowrap="nowrap">
														<input type="hidden" id="relationType${status.index}" value="${action.actionType}">
														${action.creator}
													</td>
												</tr>
												<%-- 触发流程: 流程模板 --%>
												<%-- 触发存档: 信息表,基础表 --%>
												<tr style="line-height: 40px">
													<td align="right" nowrap="nowrap">
														<c:if test="${action.actionType eq 'flow'}"><label>${ctp:i18n('form.trigger.triggerSet.processTemplates.label')}：</label></c:if>
														<c:if test="${action.actionType eq 'unflow'}"><label title="${ctp:i18n('form.trigger.triggerSet.unflow.formlabel')}">${ctp:getLimitLengthString(ctp:i18n('form.trigger.triggerSet.unflow.formlabel'), 18, '.. ')}:&nbsp;</label></c:if>
													</td>
													<td width="314px" style=" white-space:nowrap;overflow:hidden;text-overflow: ellipsis;display: block; " title="${action.flowTemplate}">
														${action.flowTemplate}
													</td>
												</tr>
												<!-- 数据拷贝-->
												<tr  style="line-height: 30px">
													<td align="right" nowrap="nowrap">
														<label>${ctp:i18n('form.trigger.triggerSet.copyData.label')}：</label>
													</td>
													<td nowrap="nowrap"><input id="mappingId" name="mappingId" type="hidden">
														<c:if test="${action.dataCoyp eq 'true'}">
														[<a href="javascript:void(0)" onclick="showRelationDetail(${status.index}, '${action.actionId}')">${ctp:i18n('form.trigger.copy.settings')}</a>]
														</c:if>
														<c:if test="${action.dataCoyp eq 'false'}">
															[无]
														</c:if>

													</td>
												</tr>
												<tr height="5">
													<td colspan="3">
														<hr align="center" width="96%" <c:if test="${actionStatus.last}"> style="visibility: hidden"</c:if>/>
													</td>
												</tr>
											</c:if>
										</table>
									</td>
								</tr>
							</table>
							</c:forEach>
						</fieldset>
					</fieldset>
				</div>
                    <c:if test="${not status.last}"><br></c:if>
				</c:forEach>
			</div>
	</div>
</div>

</body>
</html>
