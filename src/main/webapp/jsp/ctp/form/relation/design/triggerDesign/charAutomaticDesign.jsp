<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title></title>
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
		 * 更新规则
		 * @param index
         */
		function showUpdateRuleDetal(index, actionId) {
			var triggerId = $("#triggerId" + index).val();
			autoUpdate(formId, null, actionId, triggerId, null, null);
		}

		function targetFormData(index, actionId) {
			var triggerId = $("#triggerId" + index).val();
			targetFormDataMethod(formId, null, actionId, triggerId, null, null)
		}

	</script>
</head>
<body class="page_color" style="background: #fff">
	<div id="layout">

			<div class="layout clearfix code_list padding_t_5 padding_lr_10" style="height:440px;overflow-y: auto;">

				<c:forEach items="${triggerList}" var="trigger" varStatus="status">

					<div id="triggerSet">
					<fieldset class="form_area" id="fieldsetArea">
						<legend style="font-size: 14px">&nbsp;&nbsp; ${trigger.triggerName}&nbsp;&nbsp; </legend>
					<div id="fillFormBase">
							<%-- 条件 --%>
						<fieldset class="form_area padding_5">
							<legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.conditions.label') }&nbsp;&nbsp; </legend>
							<table width="100%" border="0" cellpadding="2" cellspacing="0" height="65px;" id="triggerConditionSet">
								<input type="hidden" id="triggerId${status.index}" name="triggerId" value="${trigger.triggerId}">
								<input type="hidden" id="triggerType" name="triggerType" value="4">
								<%-- 数据域 --%>
								<tr>
									<td width="4%"rowspan="2"></td>
									<td width="22%" align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}：</td>
									<td nowrap="nowrap">
										<input type="hidden" id="dotConditionValue">
										<input type="hidden" id="fieldConditionId">
										<input type="hidden" id="fieldConditionFormulaId">
										<c:if test="${trigger.hasDataFilter == true}">
											[<a id="dataFilter" href="javascript:void(0)" onclick="showDataFilterDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
										</c:if>
										<c:if test="${trigger.hasDataFilter == false}">[${ctp:i18n('form.format.flowprocessoption.none')}]</c:if>
									</td>
								</tr>

								<%-- 时间调度 --%>
								<tr>
									<td align="right" nowrap="nowrap">
										<label>${ctp:i18n('form.trigger.triggerSet.timeScheduling.label')}：</label>
									</td>
									<td nowrap="nowrap">
										<input id="timeQuartz" type="hidden" value="${timeQuartz }">
										<c:if test="${trigger.timeConditon eq 'false'}">
											[${ctp:i18n('form.format.flowprocessoption.none')}]
										</c:if>
										<c:if test="${trigger.timeConditon eq 'true'}">
											[<a href="javascript:void(0)" id="timeSet" onclick="showTimeQuartzDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
										</c:if>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<fieldset class="form_area padding_5 margin_tb_10" id="actionSet">
						<legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.actions.label') }&nbsp;&nbsp; </legend>
						<c:forEach items="${trigger.actionList}" var="action">
						<table width="100%" border="0" cellspacing="0" id="actionTable" isGrid="true">
										<%-- 类型 --%>
										<tr style="line-height:30px">
											<td width="4%" rowspan="4"></td>
											<td width="22%" align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.type.label')}：</td>
											<td nowrap="nowrap">
												${action.actionType}
											</td>
										</tr>

										<c:if test="${action.actionType eq '更新其他单据'or action.actionType eq 'Update other form data'}">
										<%-- 目标单据 --%>
										<tr style="line-height:30px">
											<td width="22%" align="right" nowrap="nowrap">${ctp:i18n('form.trigger.automatic.billtarget.label')}：</td>
											<td nowrap="nowrap">
												[<a href="javascript:void(0)" onclick="targetFormData(${status.index}, '${action.id}')">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
											</td>
										</tr>

										<%-- 重复行定位 --%>
										<tr style="line-height:30px">
											<td width="22%" align="right" nowrap="nowrap">${ctp:i18n('form.trigger.automatic.repeatrowlocation.label')}：</td>
											<td width="325px" style=" white-space:nowrap;overflow:hidden;text-overflow: ellipsis;display: block; "title="${action.repeatRow}">
												<c:if test="${action.repeatRow != null}">${action.repeatRow}</c:if>
												<c:if test="${action.repeatRow == ''or action.repeatRow == null}">[${ctp:i18n('form.format.flowprocessoption.none')}]</c:if>
											</td>
										</tr>
										</c:if>


										<%-- 更新规则 --%>
										<tr style="line-height:30px">
											<td align="right" nowrap="nowrap">${ctp:i18n('form.trigger.automatic.rule.label')}：</td>
											<td nowrap="nowrap">
												<div class="clearfix">
													[<a href="javascript:void(0)" onclick="showUpdateRuleDetal(${status.index}, '${action.actionId}')">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
												</div>
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
</body>

<%@ include file="../../../common/common.js.jsp" %>
</html>