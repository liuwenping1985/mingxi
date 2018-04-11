<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.advance.event.name')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/common/workflow/workflowEventAdvancedSetting.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var paramObjs= window.parentDialogObj['workflow_dialog_advancedSetting_id'].getTransParams();
var from = "${ctp:escapeJavascript(param.from)}";
var nodeId = "${ctp:escapeJavascript(param.nodeId)}";
var processId = "${processId}";
var eventType2Ids = "${ctp:escapeJavascript(eventType2Ids)}";

var eventUrls = "${ctp:escapeJavascript(urls)}";
var selectName = "${ctp:i18n('workflow.advance.event.set.alert.select.name')}"; ////请选择事件名称
var alertRepeat = "${ctp:i18n('workflow.advance.event.set.alert.repeat')}"; // //"不能重复选择事件，请修改！"
var alertOne = "${ctp:i18n('workflow.advance.event.set.alert.select.one')}" ;////"请至少勾选一项！"
</script>
</head>
<body>
<form id="theForm" name="theForm" action="" method="post">
<table id="eventSetting" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
	<thead>
		<tr>
			<th width="8%" align="center"></th>
			<th width="10%" align="center">${ctp:i18n('workflow.advance.event.set.type')}</th> <%--事件类型 --%>
			<th width="16%" align="center">${ctp:i18n('workflow.advance.event.set.name')}</th>
			
			<c:if test="${param.from eq 'node' && param.nodeId ne 'start'}">
				<th>${ctp:i18n('workflow.advance.event.set.before.deal') }</th>
				<th>${ctp:i18n('workflow.advance.event.set.deal') }</th>
				<th>${ctp:i18n('workflow.advance.event.set.before.fallback') }</th>
				<th>${ctp:i18n('workflow.advance.event.set.fallback') }</th>
				<th>${ctp:i18n('workflow.advance.event.set.before.retrieve')}</th>
				<th>${ctp:i18n('workflow.advance.event.set.retrieve') }</th>
			</c:if>
			<c:if test="${param.from eq 'global'}">
				<th>${ctp:i18n('workflow.advance.event.set.before.send')}</th>
				<th>${ctp:i18n('workflow.advance.event.set.send')}</th>
				<th>${ctp:i18n('workflow.advance.event.set.before.stop')}</th>
				<th>${ctp:i18n('workflow.advance.event.set.stop') }</th>
				<th>${ctp:i18n('workflow.advance.event.set.before.repeal')}</th>
				<th>${ctp:i18n('workflow.advance.event.set.repeal')}</th>
				<th>${ctp:i18n('workflow.advance.event.set.finish')}</th>
			</c:if>
		</tr>
	</thead>
	<c:if test="${hasEvent}">
	<tbody id="tbody">
		<tr>
			<td nowrap="nowrap"><span id="add" class="ico16 repeater_plus_16"></span><span id="del" class="ico16 revoked_process_16 repeater_reduce_16"></span>&nbsp;&nbsp;</td>
			<td align="center">
				<select id="eventType" name="eventType" onchange="onEventTypeChange(this)" >
					<c:forEach items="${eventTypes}" var="eventType">
						<option value="${eventType.key}" >${eventType.value}</option>
					</c:forEach>
				</select>
			</td>
			<td align="center" id="eventIdTd">
				<div id="eventIdSelctDiv">
					<select id="eventId" name="eventId">
						<option value=""></option>
						<c:forEach items="${eventManagerLabelMap}" var="eventManager">
							<option value="${eventManager.key}">${eventManager.value}</option>
						</c:forEach>
					</select>
				</div>
				<div id="eventIdInputDiv">
					<input id="eventId" type="hidden" name="eventId" value="" /> 
					<input id="eventId_label"
						onclick="openDeeCfgPage(this)" attrcfg="" class="w100b han" type="text" name="eventId_label" title="" value=""
						style="height: 26px; line-height: 26px;" />
				</div>
			</td>
			<%--
			<c:if test="${param.from eq 'node' && param.nodeId eq 'start'}">
				<td align="center"><input type="checkbox" id="beforeStart" name="beforeStart" value="BeforeStart"/></td>
				<td align="center"><input type="checkbox" id="start" name="start" value="Start"/></td>
			</c:if>
			 --%>
			<c:if test="${param.from eq 'node' && param.nodeId ne 'start'}">
				<td align="center"><input type="checkbox" id="beforeFinishWorkitem" name="beforeFinishWorkitem" value="BeforeFinishWorkitem"/></td>
				<td align="center"><input type="checkbox" id="finishWorkitem" name="finishWorkitem" value="FinishWorkitem"/></td>
				<td align="center"><input type="checkbox" id="beforeStepBack" name="beforeStepBack" value="BeforeStepBack"/></td>
				<td align="center"><input type="checkbox" id="stepBack" name="stepBack" value="StepBack"/></td>
				<td align="center"><input type="checkbox" id="beforeTakeBack" name="beforeTakeBack" value="BeforeTakeBack"/></td>
				<td align="center"><input type="checkbox" id="takeBack" name="takeBack" value="TakeBack"/></td>
			</c:if>
			<c:if test="${param.from eq 'global'}">
				<td align="center"><input type="checkbox" id="beforeStart" name="beforeStart" value="BeforeStart"/></td>
				<td align="center"><input type="checkbox" id="start" name="start" value="Start"/></td>
				<td align="center"><input type="checkbox" id="beforeStop" name="beforeStop" value="BeforeStop"/></td>
				<td align="center"><input type="checkbox" id="stop" name="stop" value="Stop"/></td>
				<td align="center"><input type="checkbox" id="beforeCancel" name="beforeCancel" value="BeforeCancel"/></td>
				<td align="center"><input type="checkbox" id="cancel" name="cancel" value="Cancel"/></td>
				<td align="center"><input type="checkbox" id="processFinished" name="processFinished" value="ProcessFinished"/></td>
			</c:if>
		</tr>
	</tbody>
	</c:if>
</table>
</form>
</body>
</html>