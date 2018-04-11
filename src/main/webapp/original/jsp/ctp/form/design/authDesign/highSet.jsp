<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<style>
    .edit_table thead th {
        border-right: 1px solid #fff;
        font-size: 12px;
        padding: 5px 0;
    }
    .edit_table td {
        border-left: 0;
        border-bottom: 1px solid transparent!important;
        text-align: center;
        border-right: 1px solid transparent;
        font-size: 12px;
        padding:5px 0;
    }
    .edit_table tbody tr:hover{
        cursor: pointer;
    }
</style>
<title></title>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<script type="text/javascript" src="${path}/common/form/design/highSet.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
  var parWin = parent.window;
$(document).ready(function () {
    var parentTbody = $("#eventBindDiv", parWin.document);
    if ($.trim(parentTbody.html()) == "") {
        <c:forEach var="task" items="${taskList}" varStatus="status">
        var ftable = document.getElementById("tbody");
        var newRow = ftable.insertRow(-1);
        c = newRow.insertCell(0);
        c.innerHTML = "<input  id=\"bindId" + "${task.id}\"" + "name=\"bindId\" type=\"checkbox\" value=\"" + "${task.id}" + "\"/>";
        c = newRow.insertCell(1);
        c.innerHTML = "${task.name}";
        c = newRow.insertCell(2);
        c.innerHTML = getDisplay("${task.operationType}", "operationType");
        c = newRow.insertCell(3);
        c.innerHTML = getDisplay("${task.model}", "model");
        c = newRow.insertCell(4);
        c.innerHTML = getDisplay("${task.taskType}", "taskType");

        createEvent("${task.id}", "${task.name}", "${task.operationType}", "${task.model}", "${task.taskType}", "${task.taskName}", "${task.taskId}", null);
        </c:forEach>
    } else {
        var bindEventId = $("input[id='bindEventId']", parentTbody);
        if (bindEventId) {
            var bindEventIdVal = bindEventId.val();
            if (bindEventIdVal) {
                var params = bindEventIdVal.split(",");

                for (var i = 0; i < params.length; i++) {
                    if (params[i] == '') {
                        continue;
                    }
                    var taskId = $("#taskId" + params[i], parentTbody).val();
                    createEvent(params[i], $("input[id='name" + params[i] + "']", parentTbody).val(), $("input[id='operationType" + params[i] + "']", parentTbody).val(), $("input[id='model" + params[i] + "']", parentTbody).val(), $("input[id='taskType" + params[i] + "']", parentTbody).val(), $("input[id='taskName" + params[i] + "']", parentTbody).val(), taskId, null);
                }
                $("#tbody").html($("#eventBindTableDiv", parWin.document).html());
            }
        }
    }

    initToolbar();
    initCssStyle();
    changeCssStyle();
});

function createEvent(eventId, name, operationType, model, taskType, taskName, taskId, object) {
    var eventBind = new EventBind();
    eventBind.id = eventId;
    eventBind.name = name;
    eventBind.operationType = operationType;
    eventBind.model = model;
    eventBind.taskType = taskType;
    eventBind.taskName = taskName;
    eventBind.taskId = taskId;
    if (taskType == "dee") {
        if (object == null || object == "null") {
        	var i = 0;
			var j = -1;
			<c:forEach var="task" items="${taskList}" varStatus="status">
				if("${task.model}" == "block"){
					if("${task.id}" == eventId){
						j = i;
					}
					i++;
				}
			</c:forEach>
			var k = 0;
            <c:forEach var="dee" items="${deeList}" varStatus="status">
				if (k == j) {
					eventBind.taskId = taskId;
					eventBind.taskResult = "${dee.refResult}";
					eventBind.refFieldTable = "${dee.tablename}";
					eventBind.taskParam = "${dee.taskParam}";
					eventBind.taskField = "${dee.taskField}";
				}
				k++;
            </c:forEach>
        } else {
            var taskId = $("#taskId", object).val();
            eventBind.taskId = taskId;
            if (model == "block") {
                var taskResult = $("#taskResult", object).val();
                var taskParam = $("#taskParam", object).val();
                var refFieldTable = $("#refFieldTable", object).val();
                var taskField = $("#taskField", object).val();
                eventBind.taskResult = taskResult;
                eventBind.taskParam = taskParam;
                eventBind.refFieldTable = refFieldTable;
                eventBind.taskField = taskField;
            }
        }
    }
    eventBindMap.put(eventBind.id, eventBind);
}
</script>
</head>
<body style="overflow: auto;" class="margin_10">
<input type="hidden" id="taskName" name="taskName" value=""/>
<input type="hidden" id="name" name="name" value=""/>
<input type="hidden" id="operationType" name="operationType" value=""/>
<input type="hidden" id="model" name="model" value=""/>
<input type="hidden" id="taskType" name="taskType" value=""/>

<input type="hidden" id="taskId" name="taskId" value=""/>
<input type="hidden" id="taskNameDEE" name="taskNameDEE" value=""/>
<input type="hidden" id="taskResult" name="taskResult" value=""/>
<input type="hidden" id="refFieldTable" name="refFieldTable" value=""/>
<input type="hidden" id="taskParam" name="taskParam" value=""/>
<input type="hidden" id="taskField" name="taskField" value=""/>

<div class="margin_b_10">
    <div class="margin_b_10">
        <div id="toolbars"></div>
        <table id="eventBindDiv" width="100%" border="0" cellspacing="0" cellpadding="0" class="edit_table">
            <thead>
            <tr style="background-color:#b5dbeb">
                <th width="10%"><input id="allCheckBox" type="checkbox" onclick="selectAll(this)"/></th>
                <th width="30%">${ctp:i18n('common.name.label')}</th>
                <th width="20%">${ctp:i18n('DataDefine.Operation')}</th>
                <th width="20%">${ctp:i18n('form.operhigh.model.label')}</th>
                <th width="20%">${ctp:i18n('form.operhigh.tasktype.label')}</th>
            </tr>
            </thead>
            <tbody id="tbody">
            </tbody>
        </table>
    </div>
</div>
</body>
</html>