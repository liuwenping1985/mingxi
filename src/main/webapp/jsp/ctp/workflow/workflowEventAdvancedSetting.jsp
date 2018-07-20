<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>开发高级</title>
<script type="text/javascript">
var paramObjs= window.parentDialogObj['workflow_dialog_advancedSetting_id'].getTransParams();
var from = "${ctp:escapeJavascript(param.from)}";
var nodeId = "${ctp:escapeJavascript(param.nodeId)}";
$(document).ready(function(){
	var process_event_string = paramObjs.process_event;
	if(process_event_string && process_event_string != ""){
		var process_events = process_event_string.split("|");
		var tbody = $("#tbody");
		for(var i = 0; i < process_events.length; i++){
			var process_event = process_events[i];
			var process_event_arr = process_event.split("=");
			var cloneTr;
			var tempTr;
			if(i == 0){
				var firstRow = $("tr:eq(0)",tbody);
				cloneTr = firstRow.clone(true);
				tempTr = firstRow;
			}else{
				tempTr = cloneTr.clone(true);
				$("#add",tempTr).unbind("click").bind("click",function(){
				  add(this);
				});
				$("#del",tempTr).unbind("click").bind("click",function(){
				  del(this);
				});
				tempTr.appendTo(tbody);
			} 
			$("#eventId",tempTr).val(process_event_arr[0]);
			var process_event_values = process_event_arr[1].split(",");
			for(var j = 0; j < process_event_values.length; j++){
				if("BeforeStart" == process_event_values[j]){
					$("#beforeStart",tempTr).attr("checked", true);
				}
				else if("Start" == process_event_values[j]){
					$("#start",tempTr).attr("checked", true);
				}
				else if("BeforeFinishWorkitem" == process_event_values[j]){
					$("#beforeFinishWorkitem",tempTr).attr("checked", true);
				}
				else if("FinishWorkitem" == process_event_values[j]){
					$("#finishWorkitem",tempTr).attr("checked", true);
				}
				else if("BeforeStepBack" == process_event_values[j]){
					$("#beforeStepBack",tempTr).attr("checked", true);
				}
				else if("StepBack" == process_event_values[j]){
					$("#stepBack",tempTr).attr("checked", true);
				}
				else if("BeforeTakeBack" == process_event_values[j]){
					$("#beforeTakeBack",tempTr).attr("checked", true);
				}
				else if("TakeBack" == process_event_values[j]){
					$("#takeBack",tempTr).attr("checked", true);
				}
				else if("BeforeStop" == process_event_values[j]){
					$("#beforeStop",tempTr).attr("checked", true);
				}
				else if("Stop" == process_event_values[j]){
					$("#stop",tempTr).attr("checked", true);
				}
				else if("BeforeCancel" == process_event_values[j]){
					$("#beforeCancel",tempTr).attr("checked", true);
				}
				else if("Cancel" == process_event_values[j]){
					$("#cancel",tempTr).attr("checked", true);
				}
				else if("ProcessFinished" == process_event_values[j]){
					$("#processFinished",tempTr).attr("checked", true);
				}
			}
		}
	}
	$("#add").click(function(){
	  add(this);
	});
	$("#del").click(function(){
	  del(this);
	});
});

function add(obj){
	var currentTr = $(obj).parents("tr:eq(0)");
	var cloneObj = $.ctpClone(currentTr);
	$("#add",cloneObj).unbind("click").bind("click",function(){
	  add(this);
	});
	$("#del",cloneObj).unbind("click").bind("click",function(){
	  del(this);
	});
	//$("#eventId",cloneObj).val("");
	$("input[type='checkbox']", cloneObj).each(function(){
		$(this).attr("checked", false);
	});
	cloneObj.insertAfter(currentTr);
}

function del(obj){
	if($("tr","#tbody").length<=1){
		return;
	}
	var currentTr = $(obj).parents("tr:eq(0)");
	currentTr.remove();
}

var eventIdMap = new Properties();
var activityProps = new Properties();
function OK(){
	var error = "";
	var process_event = "";
	$("tr","#tbody").each(function(){
		var eventId = $("#eventId",$(this)).val();
		if(eventId == ""){
			$.alert("请选择事件");
			error = "error";
			return false;
		}
		var tempEventId = eventIdMap.get(eventId, null);
		if(tempEventId != null){
			$.alert("不能重复选择事件，请修改！");
			eventIdMap.clear();
			error = "error";
			return false;
		}else{
			eventIdMap.put(eventId,eventId);
		}
		var count = $("input[type='checkbox']:checked",$(this)).length;
		if(count == 0){
			$.alert("请至少勾选一项！");
			error = "error";
			eventIdMap.clear();
			return false;
		}
		//eventId=TakeBack,BeforeFinishWorkitem|eventId2=TakeBack,BeforeFinishWorkitem
		var eventValue = "";
		$("input[type='checkbox']:checked",$(this)).each(function(){
			eventValue += $(this).val() + ",";
		});
		process_event += eventId + "=" + eventValue.substring(0,eventValue.length-1) + "|";
	});
	if(error == "error") return error;
	process_event = process_event.substring(0,process_event.length-1);
	//alert(process_event);
	//$("#theForm").jsonSubmit();
	eventIdMap.clear();
	return process_event;
}
</script>
</head>
<body>
<form id="theForm" name="theForm" action="" method="post">
<table id="eventSetting" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
	<thead>
		<tr>
			<th width="8%" align="center"></th>
			<th width="25%" align="center">事件名称</th>
			<%--
			<c:if test="${param.from eq 'node' && param.nodeId eq 'start'}">
				<th>发起前事件</th>
				<th>发起事件</th>
			</c:if>
			 --%>
			<c:if test="${param.from eq 'node' && param.nodeId ne 'start'}">
				<th>处理前事件</th>
				<th>处理事件</th>
				<th>回退前事件</th>
				<th>回退事件</th>
				<th>取回前事件</th>
				<th>取回事件</th>
			</c:if>
			<c:if test="${param.from eq 'global'}">
				<th>发起前事件</th>
				<th>发起事件</th>
				<th>终止前事件</th>
				<th>终止事件</th>
				<th>撤销前事件</th>
				<th>撤销事件</th>
				<th>结束事件</th>
			</c:if>
		</tr>
	</thead>
	<c:if test="${not empty eventManagerLabelMap}">
	<tbody id="tbody">
		<tr>
			<td nowrap="nowrap"><span id="add" class="ico16 repeater_plus_16"></span><span id="del" class="ico16 revoked_process_16 repeater_reduce_16"></span>&nbsp;&nbsp;</td>
			<td align="center">
				<select id="eventId" name="eventId">
					<option value=""></option>
					<c:forEach items="${eventManagerLabelMap}" var="eventManager">
						<option value="${eventManager.key}">${eventManager.value}</option>
					</c:forEach>
				</select>
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