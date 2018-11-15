<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>form</title>
	<script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
	<script>
		var formId = "${formId}";
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
		 * 消息内容
		 * @param index
         */
		function showMessageContent(contentMessage, actionType, actionId, triggerIndex){
			var triggerId = $("#triggerId" + triggerIndex).val();
			showRowCondition(contentMessage, actionType, actionId, triggerId, formId);
		}
	</script>
</head>
<body class="page_color" style="background: #fff">
	<div id='layout'>
		<div id="center" style="height:440px;overflow-y: auto;">
			<div class="layout clearfix code_list padding_t_5 padding_lr_10">
				<c:forEach items="${triggerList}" var="trigger" varStatus="status">

				<div id="triggerSet">
					<fieldset class="form_area" id="fieldsetArea">
						<legend style="font-size: 14px">&nbsp;&nbsp; ${trigger.triggerName}&nbsp;&nbsp; </legend>
						<div id="fillFormBase">
							<%-- 条件 --%>
							<fieldset class="form_area">
								<legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.conditions.label') }&nbsp;&nbsp; </legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" height="95px;" id="triggerConditionSet">
									<input type="hidden" id="triggerId${status.index}" name="triggerId" value="${trigger.triggerId}">
									<%--触发点--%>
									<tr>
										<td align="left" rowspan="3" width="4%"></td>
										<td width="24%" align="right" nowrap="nowrap">
											<label>${ctp:i18n('form.trigger.triggerSet.triggerPoint.label')}：</label>
										</td>
											<td valign="middle">
												<span>${trigger.executePoint}</span>
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
												<c:if test="${trigger.hasDataFilter == true}">
												[<a id="dataFilter" href="javascript:void(0)" onclick="showDataFilterDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
												</c:if>
												<c:if test="${trigger.hasDataFilter == false}">
													[${ctp:i18n('form.format.flowprocessoption.none')}]
												</c:if>
											</div>
										</td>
									</tr>

									<%-- 时间调度.无流程的触发消息才有时间调度 --%>
									<c:if test="${isFlow == false}">
									<tr id="triggerTimeQuartz">
										<td align="right" nowrap="nowrap">
											<label>${ctp:i18n('form.trigger.triggerSet.timeScheduling.label')}：</label>
										</td>
										<td nowrap="nowrap">
											<c:if test="${trigger.timeConditon eq 'false'}">
												[${ctp:i18n('form.format.flowprocessoption.none')}]
											</c:if>
											<c:if test="${trigger.timeConditon eq 'true'}">
												[<a href="javascript:void(0)" onclick="showTimeQuartzDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
											</c:if>
										</td>
									</tr>
									</c:if>
								</table>
							</fieldset>
						</div>


						<%-- 动作 --%>
						<fieldset class="form_area margin_tb_10" id="actionSet">
							<legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.actions.label') }&nbsp;&nbsp; </legend>

							<c:forEach items="${trigger.actionList}" var="action" varStatus="actionStatus">
							<table width="100%" border="0" cellspacing="0" id="actionTable" isGrid="true">
								<tr>
									<td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0" height="90px;">

											<%-- 消息接收人 --%>
											<tr style="line-height:60px">
												<td align="left" rowspan="3" width="4%"></td>
												<td width="24%" align="right" nowrap="nowrap" title="${ctp:i18n('form.trigger.triggerSet.msgReciever.label')}">
														${ctp:getLimitLengthString(ctp:i18n('form.trigger.triggerSet.msgReciever.label'), 15, '..')}：
												</td>
												<td style=" white-space:nowrap;overflow:hidden;text-overflow: ellipsis;display: block; " width="319px" title="${action.creator}">${action.creator}</td>

											</tr>
											<!-- 消息模板-->
											<tr>
												<td width="24%" align="right" nowrap="nowrap"><label title="${ctp:i18n('form.trigger.triggerSet.msgTemplates.label')}">${ctp:getLimitLengthString(ctp:i18n('form.trigger.triggerSet.msgTemplates.label'), 15, '..')}：</label></td>
												<td nowrap="nowrap">
													<input type="hidden" id="messageContent${actionStatus.index}" value="${action.messageContent}">
													[<a href="javascript:void(0)" onclick="showMessageContent('${action.messageContent}', '${action.actionType}','${action.actionId}', '${status.index}')">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
												</td>
											</tr>

											<tr height="5">
													<td colspan="2">

															<hr align="center" width="96%" <c:if test="${actionStatus.last}"> style="visibility: hidden"</c:if>/>

													</td>
												</tr>
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
