<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- <%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>

	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
<title></title>

<script type="text/javascript">
var taskId = "${taskId}";
var taskResultOld = "${taskResult}";
var taskRelFieldOld = "${taskRelField}";
var taskParamStrOld = "${taskParamStr}";
var taskFieldStrOld = "${taskFieldStr}";
var extendName = "${param.inputType}";
var fieldName = "${param.fieldName}";
var taskParamOld = new Array();
var taskFieldOld = new Array();
var isCanChange = "${param.isCanChange}";
function init(){
	if(extendName == "exchangetask"){
		document.getElementById("refFieldTr").style.display = "";
	}else{
		document.getElementById("refFieldTr").style.display = "none";
	}
	$("#inputType").val(extendName);
	$("#fieldName").val(fieldName);
	$("#fieldStr").val(taskFieldStrOld);
	$("#paramStr").val(taskParamStrOld);
	$("#refTaskField").val(taskRelFieldOld);
	$("#refFieldTable").val(refFieldTable);
	document.getElementById("paramTr").style.display = "none";
	document.getElementById("fieldTr").style.display = "none";
	if(taskParamStrOld.length>0){
		document.getElementById("paramTr").style.display = "";
		var params = taskParamStrOld.split('|');
		if(params.length>0){
			for(var i = 0;i < params.length; i++){
				var paramStr = params[i].split(',');
				var param = new Array();
				param.name = paramStr[0];
				param.value = paramStr[1];
				taskParamOld.push(param);
			}
		}
	}
	if(taskFieldStrOld.length>0){
		document.getElementById("fieldTr").style.display = "";
		var fields = taskFieldStrOld.split('|');
		if(fields.length>0){
			for(var j = 0;j < fields.length; j++){
				var fieldStr = fields[j].split(',');
				var field = new Array();
				field.name = fieldStr[0];
				field.checked = fieldStr[4];
				taskFieldOld.push(field);
			}
		}
	}
	if(taskId!="" && taskId.length>0){
		getDeeTask(taskId);
	} 
	//加防护,如果表单发布已经存在数据了,不允许修改关联表单及关联表单字段
	if(isCanChange == "false"){
		var inputs = document.getElementsByTagName("INPUT");
		if(inputs){
			for(var i = 0; i < inputs.length; i++){
				if(inputs[i].name == "b2") continue;
				inputs[i].disabled = "disabled";
			}
		}
		var selects = document.getElementsByTagName("SELECT");
		if(selects){
			for(var i = 0; i < selects.length; i++){
				selects[i].disabled = "disabled";
			}
		}
	} 
	$(":button").css({ width: "50px"});
}

function getDeeTask(taskId){
	var url = "${pageContext.request.contextPath}/form/fieldDesign.do?method=getDeeTask&taskId=" + taskId +"&extendName="+extendName+"&rnd="+Math.random();
	//var requestCaller = new XMLHttpRequestCaller(this, null, null, false, "GET", "true", url);
	//var taskAttJsonStr = requestCaller.serviceRequest();
	$.ajax({
		type:"GET",
		url:url,
		async: false,
		success:function(data){
			var taskAttJson = eval("(" + data + ")");
			if(taskAttJson.error!=null && typeof(taskAttJson.error)!="undefined"){
				$.alert("${ctp:i18n('form.create.input.setting.deetask.error.label')}！");
				return;
			}
			var id = taskAttJson.taskId;
			if(id==null||id=="undefined"){
				return;
			}
			document.getElementById("taskId").value = id;
			document.getElementById("taskName").value = taskAttJson.taskName;
			var taskResult = document.all("taskResult");
			for(var m = taskResult.options.length -1 ; m >= 0 ; m--){
				taskResult.options.remove(m);
			}
			for(var i = 0; i < taskAttJson.taskResultIds.length; i++){
				var taskResultId = taskAttJson.taskResultIds[i];
				var taskResulName = taskAttJson.taskResults[taskResultId];
				taskResult.options.add(new Option(taskResulName,taskResultId));
			}
			for(var n = 0 ; n < taskResult.options.length; n++){
				var current = taskResult.options[n];
				if(current.value == taskResultOld){
					current.selected = true;
					break;
				}
			}
			var taskParam = document.getElementById("taskParam");
			while(taskParam.hasChildNodes() && taskParam.children.length>1){
				if($(taskParam.lastChild).attr("id")=="paramTitle"){
					break;
				}
				taskParam.removeChild(taskParam.lastChild);
			}
			for(var k = 0; k < taskAttJson.taskParamNames.length; k++){
				var taskParamName = taskAttJson.taskParamNames[k];
				var index = taskAttJson.taskParams[taskParamName].indexOf(",");
				var value = taskAttJson.taskParams[taskParamName].substring(0,index);
				var description = taskAttJson.taskParams[taskParamName].substring(index+1);
				var tr = document.createElement("tr");
				var tdParamName = document.createElement("td");
				var teName = document.createTextNode(taskParamName); 
				tdParamName.setAttribute("value",taskParamName);
				tdParamName.appendChild(teName); 
				if(taskParamOld.length>0){
					for(var i = 0; i < taskParamOld.length ; i++){
						if(taskParamOld[i].name == taskParamName){
							value = taskParamOld[i].value;
							break;
						}
					}
				}
				var tdparamValue = document.createElement("td");
		        var inputValue = "<INPUT id='"+taskParamName+"' class=disabled name='taskSetParam' description='"+description+"' value="+value+">&nbsp;";
		        var inputButton = "<INPUT class=button-style onclick=setTaskParam('"+taskParamName+"'); value='${ctp:i18n('form.extend.show.set.lable')}'  type='button' name='setParam'>";
				tdparamValue.innerHTML = inputValue + inputButton;
		        var tdparamDescription = document.createElement("td");
				var teDescription = document.createTextNode(description); 
				tdparamDescription.setAttribute("value",description); 
				tdparamDescription.appendChild(teDescription); 
		        tr.appendChild(tdParamName);
		        tr.appendChild(tdparamValue);
		        tr.appendChild(tdparamDescription);
				taskParam.appendChild(tr);
			}
			if(taskParam.children.length == 1){
				document.getElementById("paramTr").style.display = "none";
			}else{
				//document.getElementById("paramTr").style.display = "";
				$("#paramTr").show();
			}
			if(taskResult.options.length > 0){
				getTaskResult();
				changeFieldTrStyle();
			}else{
				document.getElementById("fieldTr").style.display = "none";
			}
		}
	});
	$(":button").css({ width: "50px"});
}

function OK(){
	var taskResult = document.getElementById("taskResult");
	var refInputField = document.getElementById("refInputField");
	var taskId = document.getElementById("taskId");
	var taskName = document.getElementById("taskName");
	var taskParams = document.getElementsByName("taskSetParam");
	var taskFields = document.getElementsByName("taskCheckField");
	if(taskResult.options.length == 0){
		$.alert("${ctp:i18n('form.create.input.setting.deetask.resullt.noexist.label')}！");
		return "error";
	}
	if(refInputField.options.length == 0 || taskFields.length == 0){
		$.alert("${ctp:i18n('form.create.input.setting.deetask.field.noexist.label')}！");
		return "error";
	}
	var refFieldTable = $("#task_" + refInputField.value).attr("fieldTable");
	var params = new Array();
	if(taskParams!=null && taskParams.length > 0){
		for(var i = 0;i < taskParams.length;i++){
			var param = new Array();
			param.paramName = taskParams[i].id;
			if(taskParams[i].value.indexOf("{") > -1){
				param.paramValue = taskParams[i].value.substring(1,taskParams[i].value.length - 1);
			}else{
				param.paramValue = taskParams[i].value;
			}
			param.paramDescription = $(taskParams[i]).attr("description");
			params.push(param);
		}
	}
	var fields = new Array();
	var checkedLength = 0;
	for(var j = 0; j < taskFields.length; j++){
		var field = new Object();
		field.fieldName = $(taskFields[j]).attr("fieldName");
		field.fieldShowName = $(taskFields[j]).attr("fieldShowName");
		field.fieldDataType = $(taskFields[j]).attr("fieldDataType");
		field.fieldDataLength = $(taskFields[j]).attr("fieldLength");
		field.checked = false;
		if(taskFields[j].checked == true){
			field.checked = true;
			checkedLength++;
		}
		fields.push(field);
	}
	if(checkedLength == 0){
		$.alert("${ctp:i18n('form.create.input.setting.deetask.field.select.label')}！");
		return "error";
	}
	var paramStr = "";
	 for(var m=0; m< params.length;m++){
		paramStr += params[m].paramName + "," + params[m].paramValue + "," + params[m].paramDescription;
		if(m < params.length - 1){
			paramStr += "|";
		}
	 }
	//任务字段字符串，格式为  , , , , | , , , , | , ....
	var fieldStr = "";
	for(var n=0; n< fields.length;n++){
		fieldStr += fields[n].fieldName+ "," + fields[n].fieldShowName + "," + fields[n].fieldDataType  + ","+ fields[n].fieldDataLength+ ","+ fields[n].checked;
		if(n < fields.length - 1){
			fieldStr += "|";
		}	 
	 }
	var text = "";
	if(document.getElementById("refFieldTr").style.display!="none"){
		text = refInputField.options[refInputField.selectedIndex].text;
	}
	$("#paramStr").val(paramStr);
	$("#fieldStr").val(fieldStr);
	$("#refFieldTable").val(refFieldTable);
	$("#refTaskField").val(refInputField.value);
	$("#refFieldDisplay").val(text);
	//调用后台manager，缓存deetask
	if(isCanChange == "true"){
		var manager = new formFieldDesignManager();
		manager.saveOrUpdateDeeTask($("body").formobj({domains:['rtable','dee']}));
	}
	var deeTaskParam=new Object();
    deeTaskParam.taskId = taskId.value;
    deeTaskParam.taskName = taskName.value;
    deeTaskParam.taskResult = taskResult.value;
    deeTaskParam.refInputField = refInputField.value;
    deeTaskParam.refFieldDisplay = text;
    deeTaskParam.taskParam = paramStr;
    deeTaskParam.taskField = fieldStr;
    deeTaskParam.refFieldTable = refFieldTable;
    return deeTaskParam;
}

function changeFieldTrStyle(){
	var refInputField = document.getElementById("refInputField");
	if(refInputField.options.length > 0){
		document.getElementById("fieldTr").style.display = "";
	}else{
		document.getElementById("fieldTr").style.display = "none";
	}
}

function getTaskResult(){
	var taskId = document.getElementById("taskId").value;
	var resultId = document.getElementById("taskResult").value;
	var url = "${path}/form/fieldDesign.do?method=getDeeTaskField&taskId=" + taskId + "&resultId=" + resultId + "&extendName=" +extendName + "&rnd="+Math.random();
	//var requestCaller = new XMLHttpRequestCaller(this, null, null, false, "GET", "true", url);
	url = encodeURI(url);
	var taskAttJson;
	$.ajax({
		type:"GET",
		url:url,
		async: false,
		success:function(data){
			if(data.length>0){
				taskAttJson = eval("("+data+")");
				if(taskAttJson.error!=null && typeof(taskAttJson.error)!="undefined"){
					$.alert("${ctp:i18n('form.create.input.setting.deetask.error.label')}！");
					return;
				}
				var refInputField = document.all("refInputField");
				for(var i = refInputField.options.length -1 ; i >= 0 ; i--){
					refInputField.options.remove(i);
				}
				var taskField = document.getElementById("taskField");
				while(taskField.hasChildNodes()){
					taskField.removeChild(taskField.firstChild);
				}
				for(var j = 0; j < taskAttJson.inputAttFieldNames.length; j++){
					var taskFieldName = taskAttJson.inputAttFieldNames[j];
					var taskFieldShowName = taskAttJson.inputAttFieldDisplays[taskFieldName];
					var taskFieldDigit = taskAttJson.inputAttFieldDigits[taskFieldName];
					var taskFieldDataType = taskAttJson.inputAttFieldTypes[taskFieldName];
					var taskFieldLength = taskAttJson.inputAttFieldLenghts[taskFieldName];
					var taskFieldTable = taskAttJson.inputAttFieldTables[taskFieldName];
					var taskFieldDisplay = taskAttJson.inputAttFieldDisplays[taskFieldName];
					refInputField.options.add(new Option(taskFieldDisplay,taskFieldName));
					var td = document.createElement("td");
					var checked = true;
					var checkbox = "<input type='checkbox' name='taskCheckField' fieldName = '"+taskFieldName+"' fieldShowName='"+taskFieldShowName+"' fieldDataType='"+taskFieldDataType+"' fieldLength='"+taskFieldLength+"' fieldDigit='"+taskFieldDigit+"' fieldTable='"+taskFieldTable+"' id='task_"+taskFieldName+"'";   		
					if(taskFieldOld.length>0){
						for(var t = 0; t < taskFieldOld.length ; t++){
							if(taskFieldOld[t].name == taskFieldName && taskFieldOld[t].checked == "true"){
								checkbox += "checked = 'checked'";
								break;
							}
						}
					}else{
						checkbox += "checked = 'checked'";
					}
					checkbox += " >";
					var label = "<label for='taskFieldName'>"+taskFieldDisplay+"</label>";
					td.innerHTML = checkbox + label;
					if(j % 3 == 0){
						var tr = document.createElement("tr");
						tr.appendChild(td);
						tr.setAttribute("id","tr"+(j/3));
						taskField.appendChild(tr);
					}else{
						var tr = taskField.lastChild;
						tr.appendChild(td);
					}
				}
				for(var n = 0 ; n < refInputField.options.length; n++){
					var current = refInputField.options[n];
					if(current.value == taskRelFieldOld){
						current.selected = true;
						break;
					}
				}
				changeFieldTrStyle(); 
			}
		}
	});
	//var taskAttJsonStr = requestCaller.serviceRequest();
	//var taskAttJson = eval("(" + taskAttJsonStr + ")");
	
}

//设置参数
function setTaskParam(id){
	//var sendObj = new Object();
	var showStr= $("#"+id).attr("description");
	//sendObj.showStr = showStr;
	//sendObj.windowObj = self;
	//var rValue = window.showModalDialog("${path}/form/fieldDesign.do?method=setTaskParam",sendObj,"dialogWidth:600px;dialogHeight:561px");
	//if(rValue!=null){
		//document.getElementById(id).value = rValue.showStr;
	//}
	var dialog = $.dialog({
		width:500,
		height:400,
		targetWindow:getCtpTop(),
		transParams:window,
		url:"${path}/form/fieldDesign.do?method=setTaskParam&showStr="+showStr+"&fieldName="+fieldName,
	    title : '${ctp:i18n("form.trigger.triggerSet.parameterSet.label")}',
	    buttons : [ {
	    text : "${ctp:i18n('common.button.ok.label')}",
	    id:"sure",
	    handler : function() {
		     var returnValue = dialog.getReturnValue();
		     if(returnValue){
		    	 dialog.close();
		    	 if(returnValue!=""){
		    		 var obj = returnValue.split(",");
		    		 var value = obj[0];
		    		 var display = obj[1];
		    		 $("#"+id).val(display).attr("description",value);
		    		 
		    	 }
		    	 //document.getElementById(id).value = retValue;
		     }
	    }
	    }, {
	      text : "${ctp:i18n('common.button.cancel.label')}",
	      id:"exit",
	      handler : function() {
	        dialog.close();
	      }
	    } ]
	  });
}

//选择任务
function selectDeeTask(){
	var sendObj = new Object();
	var dialog = $.dialog({
		width:550,
		height:300,
		targetWindow:getCtpTop(),
		transParams:window,
		url:"${path }/form/triggerDesign.do?method=triggerDEETask",
	    title : '${ctp:i18n("form.trigger.triggerSet.dee.label")}',
	    buttons : [ {
	      text : "${ctp:i18n('common.button.ok.label')}",
	      id:"sure",
	      handler : function() {
		      var retValue = dialog.getReturnValue();
		      if(retValue){
		    	  dialog.close();
		    	  $("#taskId").val(retValue.taskId);
		    	  $("#taskName").val(retValue.taskName);
		    	  getDeeTask(retValue.taskId);
		      }
	      }
	    }, {
	      text : "${ctp:i18n('common.button.cancel.label')}",
	      id:"exit",
	      handler : function() {
	        dialog.close();
	      }
	    } ]
	  });
    	
}
</script>
<style type="text/css">
	.input-262{
		width:280px;
	}
	body{
		font-size: x-small;
		background-color: #EDEDED;
	}
</style>

</head>
<body onload="init();">
<div style="overflow-y:auto;">
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="popupTitleRight" id="rtable">
		
		<tr>
		  <td height="10px;" colspan="2"></td>
		</tr>
		<tr id="cloneRow" onmousedown="currentTr=$(this)">
			<td colspan="2">
			<div class="scrollList" style="margin-top: 50px;">
				<table width="100%" height="30%" border="0" cellpadding="0" cellspacing="0" id="dee">
					<!--任务选择-->
					<tr >
					     <td align="right" nowrap="nowrap" width="25%">${ctp:i18n("form.create.input.setting.deetask.select.label")}：</td>
					     <td nowrap="nowrap">
					     	 <input type="hidden" name="taskId" id="taskId">
					     	 <input type="hidden" name="inputType" id="inputType">
					     	 <input type="hidden" name="fieldName" id="fieldName">
					     	 <input type="hidden" name="paramStr" id="paramStr"/>
					     	 <input type="hidden" name="refTaskField" id="refTaskField"/>
					     	 <input type="hidden" name="fieldStr" id="fieldStr"/>
					     	 <input type="hidden" name="refFieldTable" id="refFieldTable"/>
					     	 <input type="hidden" name="refFieldDisplay" id="refFieldDisplay"/>
					         <input type="text" name="taskName" id="taskName" class="input-262" disabled readonly="true">&nbsp;&nbsp;
					         <input type="button" value="${ctp:i18n('form.input.inputtype.oper.label')}" class="button-style" 
					                id="setTask" name="setTask" onClick="selectDeeTask();">
					    </td>
					 </tr>
					 <!--结果集选择-->
					 <tr>
					     <td align="right" nowrap="nowrap" width="25%">${ctp:i18n('form.create.input.setting.deetask.result.select.label')}：</td>
					     <td nowrap="nowrap">
					         <select id="taskResult" name="taskResult" onChange="getTaskResult()" class="input-262">
					         </select>
					    </td>
					 </tr>
					 <!--绑定字段-->
					 <tr id = "refFieldTr">
					     <td align="right" nowrap="nowrap" width="25%">${ctp:i18n('form.create.input.setting.deetask.reffield.select.label')}：</td>
					     <td nowrap="nowrap">
					         <select id="refInputField" name="refInputField" class="input-262">
					         </select>
					    </td>
					 </tr>
					 <!--参数设置-->
					 <tr id = "paramTr">
					     <td align="right" valign="top"  nowrap="nowrap" width="25%">${ctp:i18n('form.create.input.setting.deetask.param.setting.label') }：</td>
					     <td nowrap="nowrap">
							<table width="90%" height="30%" cellpadding="0" cellspacing="2" style="border: 1px solid gray;">
								<tbody id="taskParam">
									<tr id="paramTitle">
										<th><strong>${ctp:i18n('form.create.input.setting.deetask.param.name.label')}</strong></th>
										<th><strong>${ctp:i18n('form.create.input.setting.deetask.param.setting.label')}</strong></th>
										<th><strong>${ctp:i18n('form.create.input.setting.deetask.param.des.label')}</strong></th>
									</tr>
								</tbody>
							</table>
					    </td>
					 </tr>
					 <!--列表显示字段-->
					 <tr id = "fieldTr">
					     <td align="right" valign="top" nowrap="nowrap" width="25%">${ctp:i18n('form.create.input.setting.deetask.showField.label')}：</td>
					     <td nowrap="nowrap">
					         <table width="90%" height="30%" border="0" cellpadding="0" cellspacing="0">
					         	<tbody id="taskField">
								</tbody>
							</table>
					    </td>
					 </tr>
				</table>
			</div>
			</td>
		</tr>
	</table>
</div>
</body>		
</html>