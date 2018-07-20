<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='project.body.phase.label' /></title>
<script type="text/javascript">
<!--
	var obj = transParams.parentWin;
    var phId = obj.$("#currentPhaseId").val();
	/**
	 * 设置当前阶段
	 */
	function setCurrentPhase(){
		var phaseId = $("#phaseId").val();
		if(phaseId!=phId){
			var phase = obj.projectArr.get(phaseId);
			obj.$("#currentPhaseId").val(phase.phaseId);
			obj.$("#currentPhaseName").val(phase.phaseName);
			obj.$("#changeFlag").val("true");
		}
		closeWindow();
	}
	
	function closeWindow(){
		getA8Top().phaseForCreateDialog.close();
	}
//-->
</script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<tr>
		<td class="PopupTitle" height="20"><fmt:message key="project.body.phase.label" /></td>
	</tr>
	<tr>
		<td align="center" valign="top" style="padding-top: 10px;">
			<select id="phaseId" name="phaseId" class="condition" style="width:150px;">
				<script type="text/javascript">
				<!--
					var obj = transParams.parentWin;
					var phases = obj.projectArr;
			        var phasesKeys = phases.keys();
			        for(var i = 0; i < phasesKeys.size(); i ++){
			            var phaseObj = phases.get(phasesKeys.get(i));
			            document.write("<option value='" + phaseObj.phaseId + "'>" + phaseObj.phaseName + "</option>");
			        }
				//-->
				</script>
			</select>
		</td>
	</tr>
	<tr>
		<td height="25" align="right" class="bg-advance-bottom">
			<input type="button" onclick="setCurrentPhase();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="closeWindow();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>